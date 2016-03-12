/************This macro is used to iterate and produce text with week-wise dates************/
/************The Dates back-track by 7 days from the observation point**********************/
/*****This macro could be used to generate to rename/define sequentially named variables****/

%macro set(var_name,obpointdt);

	%let week_var = &obpointdt.;
	%let last_fr_week = &obpointdt.;
	%let x = %str(;);

	%do i = 1 %to 52 %by 1;
/**************************The 01 week is the week of snapshot date*************************/
		%let yr = %sysfunc(year(&week_var));
		%let wk = %sysfunc(week(&week_var,w));
		%if &wk. = 0 %then %do;
			%let yr2 = %sysfunc(year(%sysfunc(intnx(week,&week_var,-1))));
			%let wk2 = 52;
		%end;
		%else %do;
			%let yr2 = %sysfunc(year(&week_var));
			%let wk2 = %sysfunc(week(&week_var,w));
		%end;
		%if &wk2. < 10 %then %do;
			%let wk3 = %sysfunc(compress(0&wk2));
		%end;
		%else %let wk3 = %sysfunc(compress(&wk2));
				%put &var_name._&yr2.&wk3._max_sum&x.;
		%let week_var = %sysfunc(intnx(week,&last_fr_week,%eval(-1*&i)));
	%end;

%mend;

%set(nitin,"31Jul1990"d);