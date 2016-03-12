/*****************************This code contains 3 macros***************************************************/
/*******1. logistic_model - This macro shall build a logistic model on the modeling dataset for the*********/
/******************************variables specified in the variable list*************************************/
/**2. validation - This macro shall score the validation datasets passed to it on the basis of the scoring**/
/************************equation generated from the logistic model developed above*************************/
/**3. post processing - This macro shall present relevant outputs like the VIF, CORR and accuracy and GINI**/
/*************************Charts for the modeling and validation datasets passed to it**********************/


/**************Declare all the variables to be used while building the model in the model_vars list*********/
/*******The scr_eq variable is used to create the equation on the basis of the estimates in the model*******/

%let model_vars=
t_num_prg_dv28
t_total_calls_dv23
total_sales_dv7_flg1
t_norder_dv2
total_sales_dv23_flg
frqnt_calls_dv15_flg1
;

%let scr_eq;

%macro logistic_model(lib_ds,model_data,varlist);

	PROC LOGISTIC DATA = &lib_ds..&model_data. NAMELEN = 32 DESCENDING 
	      OUTEST = view1;
	      MODEL loss_flag = &varlist. /;
		  	/*SELECTION= BACKWARD*/
			/*SLE = 0.10*/
			/*SLS = 0.10;*/
	      OUTPUT OUT = score_model_ds P = PRED;
	      ODS OUTPUT PARAMETERESTIMATES = view2;
	RUN;

	proc sql NOPRINT;
		select distinct variable into :varlist_model_out separated by " "
		from view2 where UPCASE(variable) NE 'INTERCEPT';
	quit;

	data create_eq;
		set view2;
			length eq $50;
		if upcase(variable) = "INTERCEPT" then do;
			eq = compress(estimate);
		end;
		else do;
			check2=compress(estimate);
			eq=compress(variable||"*"||check2);
		end;
	run;

	proc sql noprint ; select eq into: equation separated by '+' from create_eq ; quit;

	%let scr_eq=%sysfunc(compress(1/(1+(exp((-1)*(&equation.))))));

%mend;

/*%logistic_model(m_pharma,model_201207_final_dataset,&model_vars.);*/

%macro validation(lib_ds,val_data);

	data score_&val_data.;
		set &lib_ds..&val_data.;
		score = &scr_eq.;
	run;

%mend;

/*%validation(m_pharma,val2_201212_final_dataset);*/

%macro post_processing(lib_name,dataset,score_var,dep_var,varlist);
		
	proc reg data= &lib_name..&dataset. CORR ;  
	      model &dep_var. = &varlist./ vif ;
	run;

	proc rank data=&lib_name..&dataset. groups=10 ties= mean out=r_score;
	      var &score_var.;
	      ranks r_&score_var.;
	run;

	proc summary data=r_score NWAY MISSING;
	      var loss_flag &score_var.;
	      class r_&score_var.;
	      output out=acc_plot (rename=_freq_=count_all_accounts)
	      sum(loss_flag) = total_loss_accounts
	      mean(&score_var.) = mean_pred;
	run;

	proc sort data= acc_plot; by descending mean_pred; run;

	data acc_plot;
	      set acc_plot;
		  retain cum_goods;
		  retain cum_bads;
	      bad_rate  = total_loss_accounts/count_all_accounts;
		  goods = count_all_accounts*(1-bad_rate);
		  bads = count_all_accounts*(bad_rate);
		  cum_goods = sum(goods,cum_goods);
		  cum_bads = sum(bads,cum_bads);
		  cum_goods = cum_goods;
		  cum_bads = cum_bads;
	run;

	data anno;
	   function='move'; 
	   xsys='1'; ysys='1'; 
	   x=0; y=0; 
	   output;
	   function='draw'; 
	   xsys='1'; ysys='1'; 
	   color='red'; 
	   x=100; y=100; 
	   output;
	run;

	symbol interpol= join;

	proc sql noprint; select round(max(bad_rate)+0.05,0.1) into: max_axis1 from acc_plot; quit;

	proc gplot data=acc_plot annotate=anno ;
	      plot bad_rate*mean_pred/haxis=0 to &max_axis1. by 0.1  vaxis=0 to &max_axis1. by 0.1;
	run;

	proc sql noprint; select round(max(cum_goods)+0.05,0.1) into: max_axis2 from acc_plot; quit;

	proc sql noprint; select round(max(cum_bads)+0.05,0.1) into: max_axis3 from acc_plot; quit;

	proc gplot data=acc_plot annotate=anno ;
	      plot cum_bads*cum_goods/haxis=0 to &max_axis2. by 50  vaxis=0 to &max_axis3. by 50;
	run;

%mend;

/*%post_processing(work,score_model_ds,pred,loss_flag,&model_vars.);*/


