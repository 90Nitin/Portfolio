/***********************Binning Macro creates equal frequency bins on the given variable********************/
/***The User is to input the name of the dataset along with the library in which the dataset can be found***/
/*********The User is to also input the name of the variable on which binning is to be conducted************/
/*****The Macro shall then create equal frequency bins on the given variable and shall produce summary tables 
against the same********************************************************************************************/

/*The Macro creates 2 temporary datasets - rnkd_&var_name. and smmry_rnkd_&var_name.***********************/
/*******************rnkd_&var_name. contains a bin variable against the variable passed********************/
/*********************smmry_rnkd_&var_name. contains a bin-wise summary for the variable*******************
**********************************************and the dependent variable **********************************/

%macro binning(ds_name,lib_name,var_name,dep_var);

	proc sql noprint;
			select count(*) into :nobs from &lib_name..&ds_name.;
	quit;

	proc sql noprint;
		select count(*) into :nmiss from &lib_name..&ds_name. where &var_name. = .;
	quit;

	proc sort data = &lib_name..&ds_name. out=rnkd_&var_name.;
		by &var_name.;
	run;

	data rnkd_&var_name.;
		set rnkd_&var_name.;

		if _n_<=&nmiss. then bin = .;
			else if (_n_ > &nmiss. and _n_ < =  ((%sysevalf(&nobs. - &nmiss.)/10)+ &nmiss.) ) then bin = 1;
			else %do i = 2 %to 10 %by 1;
				if (_n_ >  %sysevalf(((&i.-1)*(&nobs. - &nmiss.)/10)+ &nmiss.)) and 
				_n_ < = %sysevalf(((&i.)*(&nobs. - &nmiss.)/10)+&nmiss.)
				then bin = &i.;
			%end;
	run;

	proc summary data=rnkd_&var_name.  NWAY MISSING;
		var &var_name. &dep_var.;
		class bin;
		output out=smmry_rnkd_&var_name. n(&var_name.)=n_var
		sum(&var_name.)=sum_var max(&var_name.)=max_var min(&var_name.)=min_var mean(&var_name.)=mean_var
		mean(&dep_var.)=event_rate;
	run;

	data smmry_rnkd_&var_name.;
		set smmry_rnkd_&var_name.;
		length var_name $50;
		logit = log(event_rate/(1-event_rate));
		var_name = "&var_name.";
	run;

%mend;

%binning(MODEL_201207_FINAL_DATASET,m_pharma,gsales_dv6,loss_flag );

