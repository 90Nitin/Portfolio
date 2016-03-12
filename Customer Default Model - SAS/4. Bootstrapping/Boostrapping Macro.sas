/***************************This code runs a bootstrap validation on the modeling dataset******************/
/*****************Observations are picked at random(with replacement) from the modeling dataset************/
/**************************************Logistic Regression is then run on the new datasets and the count of
insignificance of the variables is noted*******************************************************************/

/***************************Pass the variables to be used to create the model*******************************/

options obs=max;

%let model_vars=
t_norder_dv2
t_num_prg_dv28
t_total_sales_dv22
gsales_dv15_flg
norder_dv22_flg1
total_sales_dv7_flg1
tsales_tckt_dv19_flg1
norder_dv9_flg
;

%macro bootstrap(lib_name,ds_name,dep_var,varlist,n_iter);

	data final_param_estim;
		set _null_;
	run;

	proc sql NOPRINT;
		select count(*) into: nobs from &lib_name..&ds_name.;
	run;

	%do j = 1 %to &n_iter.;
			
			PROC SURVEYSELECT DATA=&lib_name..&ds_name. METHOD=URS OUTHITS
				OUT=&ds_name._&j. SAMPSIZE= &nobs.;
			RUN;

			PROC LOGISTIC DATA = &ds_name._&j. NAMELEN = 32 DESCENDING 
		      OUTEST = view1;
		      MODEL &dep_var. = &varlist./ lackfit;
		      OUTPUT OUT = score_base P = PRED;
		      ODS OUTPUT PARAMETERESTIMATES = view2;
			RUN;

			data view2;
				set view2;
				length iteration $10;
				iteration = "&j.";
			run;

			data final_param_estim;
				set final_param_estim
				view2;
			run;

	%end;

		proc freq data=final_param_estim NOPRINT; tables variable*iteration/out=x;
			where ProbChiSq > 0.05;
		run;

		
		proc means data= final_param_estim;
			class variable;
			var ProbChiSq;
		run;

		
		proc sql;
			create table max_count as 
			select variable, count(*) as count_records
			from final_param_estim
			where probchisq>0.05 and upcase(variable) NE 'INTERCEPT'
			group by variable
			order by variable;
		quit;

%mend;

/*%bootstrap(m_pharma,model_201207_final_dataset,loss_flag,&model_vars.,100);*/
