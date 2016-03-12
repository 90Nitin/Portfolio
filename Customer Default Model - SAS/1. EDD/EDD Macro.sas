/*option compress=yes mlogic symbolgen mprint merror ;                                                                                                                                                           
%LET time=%SYSFUNC(TIME()); %PUT %SYSFUNC(PUTN(&time,time.));                                                                                                                                                    
                                                                                                                                                                                                                 
*** ***************************************************************************/                                                                                                                                 
*** EDD:Extended Data Dictionary Gen-2                                      ***/                                                                                                                                 
*** ***************************************************************************/                                                                                                                                 
                                                           ***/                                                                                                                                 
*******************************************************************************/                                                                                                                                 
*** NARRATIVE: (A QUICK VIEW OF WHAT`S IN ANY SAS DATASET) *;               ***/                                                                                                                                 
*** THIS IS LIKE A COMBINATION OF PROC CONTENTS AND PROC PRINT ON           ***/                                                                                                                                 
*** ALL THE VARIABLES IN A SAS DATASET. IT PROVIDES A QUICK LOOK            ***/                                                                                                                                 
*** AT WHAT IS CONTAINED IN A SAS DATASET. IT LISTS EACH VARIABLE           ***/                                                                                                                                 
*** IN THE DATASET, THE NUMBER OF DISTINCT VALUES FOR THE VARIABLE,         ***/                                                                                                                                 
***PERCENTILES FOR NUMERIC VARIBELS, TOP FIVE AND BOTTOM FIVE VALUES FOR    ***/                                                                                                                                 
***CAHARACTER VARIABLE, AS WELL AS FORMAT, LENGTH, LABEL, ETC.              ***/                                                                                                                                 
*******************************************************************************/                                                                                                                                 
*** MACRO PARAMETERS                                                        ***/                                                                                                                                 
*******************************************************************************/                                                                                                                                 
***                                                                         ***/                                                                                                                                 
*** DSNAME  = SAS input dataset                                             ***/                                                                                                                                 
*** LIBNAME = Library Name for input dataset                                ***/                                                                                                                                 
*** edd_out_loc= Specify path for saving ouput of EDD-GEN-2. EDD outputs are***/                                                                                                                                 
***           in the saved in the form of *.html file and *.xls file.       ***/                                                                                                                                 
*** NUM_UNIQ= Option for displaying number of unique values for numeric     ***/                                                                                                                                 
***           variable. NUM_UNIQ=Y will calculate number of unique values   ***/                                                                                                                                 
***           for numeric variable. NUM_UNIQ=N will not calculate number    ***/                                                                                                                                 
***           of unique values for numeric variable.                        ***/                                                                                                                                 
***           NOTE: Option NUM_UNIQ=Y takes long time for producing output. ***/                                                                                                                                 
***                                                                         ***/                                                                                                                                 
*******************************************************************************/                                                                                                                                 
*** REFERENCES :                                                            ***/                                                                                                                                 
***                                                                         ***/                                                                                                                                 
***                                                                         ***/                                                                                                                                 
***                                                                         ***/                                                                                                                                 
***                                                                         ***/                                                                                                                                 
***                                                                         ***/                                                                                                                                 
*******************************************************************************/;                                                                                                                                
                                                                                                                                                                                                                 
 %macro edd (libname, dsname, edd_out_loc, NUM_UNIQ );                                                                                                                                                           
                                                                                                                                                                                                                 
data _null_ ;                                                                                                                                                                                                    
xyz=trim(substr("&dsname",1,5)) ;                                                                                                                                                                                
abc=compress(xyz||"_EDD_"||"&sysdate") ;                                                                                                                                                                         
call symput ("datname",abc);                                                                                                                                                                                     
run;                                                                                                                                                                                                             
                                                                                                                                                                                                                 
data &datname  ;                                                                                                                                                                                                 
                                                                                                                                                                                                                 
format   name     $32. ;                                                                                                                                                                                         
format   label     $50. ;                                                                                                                                                                                        
format   type     $4. ;                                                                                                                                                                                          
format   var_length     $30. ;                                                                                                                                                                                   
format   numobs     $30. ;                                                                                                                                                                                       
format   nmiss     $30. ;                                                                                                                                                                                        
format   unique     $30. ;                                                                                                                                                                                       
format   mean_or_top1     $30. ;                                                                                                                                                                                 
format   min_or_top2     $30. ;                                                                                                                                                                                  
format   p1_or_top3     $30. ;                                                                                                                                                                                   
format   p5_or_top4     $30. ;                                                                                                                                                                                   
format   p25_or_top5     $30. ;                                                                                                                                                                                  
format   median_or_bot5     $30. ;                                                                                                                                                                               
format   p75_or_bot4     $30. ;                                                                                                                                                                                  
format   p95_or_bot3     $30. ;                                                                                                                                                                                  
format   p99_or_bot2     $30. ;                                                                                                                                                                                  
format   max_or_bot1     $30. ;                                                                                                                                                                                  
                                                                                                                                                                                                                 
run;                                                                                                                                                                                                             
                                                                                                                                                                                                                 
%let indata=&datname ;                                                                                                                                                                                           
                                                                                                                                                                                                                 
proc sql;                                                                                                                                                                                                        
create table type_test as                                                                                                                                                                                        
select a.varnum, a.name, a.type, a.length, a.label, a.format, a.npos, b.nobs                                                                                                                                     
from dictionary.columns as a , dictionary.tables as b                                                                                                                                                            
where a.libname=%upcase("&libname") and b.libname=%upcase("&libname") and                                                                                                                                        
a.memname=%upcase("&dsname")and  b.memname=%upcase("&dsname") order by varnum;                                                                                                                                   
quit;                                                                                                                                                                                                            
                                                                                                                                                                                                                 
                                                                                                                                                                                                                 
                                                                                                                                                                                                                 
%let no_char=0 ;                                                                                                                                                                                                 
proc sql noprint;                                                                                                                                                                                                
select count(type) into: no_char                                                                                                                                                                                 
from type_test where type="char" ;                                                                                                                                                                               
quit;                                                                                                                                                                                                            
                                                                                                                                                                                                                 
%let no_num=0 ;                                                                                                                                                                                                  
proc sql noprint;                                                                                                                                                                                                
select count(type) into: no_num                                                                                                                                                                                  
from type_test where type="num" ;                                                                                                                                                                                
quit;                                                                                                                                                                                                            
                                                                                                                                                                                                                 
%LET time=%SYSFUNC(TIME()); %PUT %SYSFUNC(PUTN(&time,time.));                                                                                                                                                    
                                                                                                                                                                                                                 
%if &no_num > 0 %then %do;                                                                                                                                                                                       
                                                                                                                                                                                                                 
                  %edd_numeric ;                                                                                                                                                                                 
                                                                                                                                                                                                                 
                                                                                                                                                                                                                 
                  proc datasets;                                                                                                                                                                                 
                  append base=&indata                                                                                                                                                                            
                  data=base_num_final force ;                                                                                                                                                                    
                  quit;                                                                                                                                                                                          
                                                                                                                                                                                                                 
                                                                                                                                                                                                                 
%end;                                                                                                                                                                                                            
                                                                                                                                                                                                                 
%if &no_char > 0 %then %do;                                                                                                                                                                                      
                                                                                                                                                                                                                 
%LET time=%SYSFUNC(TIME()); %PUT %SYSFUNC(PUTN(&time,time.));                                                                                                                                                    
                                                                                                                                                                                                                 
                                                                                                                                                                                                                 
                  %edd_character ;                                                                                                                                                                               
                                                                                                                                                                                                                 
                  proc datasets;                                                                                                                                                                                 
                  append base=&indata                                                                                                                                                                            
                  data=base_char_final force ;                                                                                                                                                                   
                  quit;                                                                                                                                                                                          
                                                                                                                                                                                                                 
%end;                                                                                                                                                                                                            
                                                                                                                                                                                                                 
%LET time=%SYSFUNC(TIME()); %PUT %SYSFUNC(PUTN(&time,time.));                                                                                                                                                    
                                                                                                                                                                                                                 
/*Add variable number and its position                                                                                                                                                                     */    
                                                                                                                                                                                                                 
 data var_pos (keep=name n_pos varnum) ;                                                                                                                                                                         
 set type_test ;                                                                                                                                                                                                 
 format   name     $32. ;                                                                                                                                                                                        
 n_pos=put (npos , 30.) ;                                                                                                                                                                                        
                                                                                                                                                                                                                 
 run;                                                                                                                                                                                                            
                                                                                                                                                                                                                 
proc sql;                                                                                                                                                                                                        
create table &indata  as                                                                                                                                                                                         
select a.* , b.*                                                                                                                                                                                                 
from &indata as a , var_pos as b                                                                                                                                                                                 
where a.name=b.name ;                                                                                                                                                                                            
quit;                                                                                                                                                                                                            
                                                                                                                                                                                                                 
                                                                                                                                                                                                                 
                        proc sort data=&indata  out=&indata (drop=varnum);                                                                                                                                       
                  by varnum ;                                                                                                                                                                                    
                  where name ne " " ;                                                                                                                                                                            
                  run;                                                                                                                                                                                           
                                                                                                                                                                                                                 
data  &indata;                                                                                                                                                                                                   
retain name label type var_length n_pos ;                                                                                                                                                                        
set &indata  ;                                                                                                                                                                                                   
run;                                                                                                                                                                                                             
ods html file="&edd_out_loc..xls";                                                                                                                                                                               
                                                                                                                                                                                                                 
proc print data=&indata;                                                                                                                                                                                         
run;                                                                                                                                                                                                             
                                                                                                                                                                                                                 
ods html close;                                                                                                                                                                                                  
                                                                                                                                                                                                                 
ods html file="&edd_out_loc..html";                                                                                                                                                                              
                                                                                                                                                                                                                 
proc print data=&indata;                                                                                                                                                                                         
run;                                                                                                                                                                                                             
                                                                                                                                                                                                                 
ods html close;                                                                                                                                                                                                  
                                                                                                                                                                                                                 
%LET time=%SYSFUNC(TIME()); %PUT %SYSFUNC(PUTN(&time,time.));                                                                                                                                                    
                                                                                                                                                                                                                 
%mend edd ;
%macro edd_numeric ;                                                                                                                                                             
title "%upcase(&libname..&dsname)";                                                                                                                                              
/*Create an output dataset for the contents*/                                                                                                                                    
proc sql;                                                                                                                                                                        
create table varlist as                                                                                                                                                          
select a.varnum, a.name, a.type, a.length, a.label, a.format, a.npos, b.nobs                                                                                                     
from dictionary.columns as a , dictionary.tables as b                                                                                                                            
where a.libname=%upcase("&libname") and b.libname=%upcase("&libname") and                                                                                                        
a.memname=%upcase("&dsname")and  b.memname=%upcase("&dsname")and a.type="num" order by varnum;                                                                                   
quit;                                                                                                                                                                            
                                                                                                                                                                                 
/* Number of variables in dataset */                                                                                                                                             
proc sql noprint;                                                                                                                                                                
select count(name) into: no_var                                                                                                                                                  
from varlist;                                                                                                                                                                    
quit;                                                                                                                                                                            
/* Use the data step SYMPUT CALL routine to move                                                                                                                                 
the values of variables VARNAME, NAME, TYPE,                                                                                                                                     
LENGTH, LABEL, and FORMAT into Macro variables                                                                                                                                   
*/                                                                                                                                                                               
data _null_;                                                                                                                                                                     
set varlist;                                                                                                                                                                     
call                                                                                                                                                                             
symput('varn'||left(put(_n_,4.)),compress(varnum                                                                                                                                 
));                                                                                                                                                                              
call                                                                                                                                                                             
symput('name'||left(put(_n_,4.)),trim(name));                                                                                                                                    
call                                                                                                                                                                             
symput('type'||left(put(_n_,4.)),compress(upcase                                                                                                                                 
(type)));                                                                                                                                                                        
                                                                                                                                                                                 
call                                                                                                                                                                             
symput('leng'||left(put(_n_,4.)),compress(length                                                                                                                                 
));                                                                                                                                                                              
call                                                                                                                                                                             
symput('labe'||left(put(_n_,4.)),trim(label));                                                                                                                                   
call                                                                                                                                                                             
symput('form'||left(put(_n_,4.)),trim(format));                                                                                                                                  
                                                                                                                                                                                 
call                                                                                                                                                                             
symput('pos'||left(put(_n_,4.)),trim(npos));                                                                                                                                     
                                                                                                                                                                                 
run;                                                                                                                                                                             
                                                                                                                                                                                 
                                                                                                                                                                                 
data varlist ;                                                                                                                                                                   
set varlist ;                                                                                                                                                                    
varnum=_N_ ;                                                                                                                                                                     
/*SIZE_KB=CEIL((260 + 1*136+NOBS*length)/512);*/                                                                                                                                 
/*Cum_KB+SIZE_KB ;*/                                                                                                                                                             
/*SIZE_MB=round(SIZE_KB/1048576,0.1);*/                                                                                                                                          
/*CUM_MB+SIZE_MB ;*/                                                                                                                                                             
run;                                                                                                                                                                             
                                                                                                                                                                                 
/*If any varaible in the datset has value  greter than "SIZE_LIM"  then macro variable updates its value */                                                                      
/*with maximum value */                                                                                                                                                          
                                                                                                                                                                                 
/*proc means data=varlist max;*/                                                                                                                                                 
/*var size_kb ;*/                                                                                                                                                                
/*output out=test max(size_kb)=maxsz ;*/                                                                                                                                         
/*run;*/                                                                                                                                                                         
/**/                                                                                                                                                                             
/*data test (keep=mxz);*/                                                                                                                                                        
/*set test ;*/                                                                                                                                                                   
/*size=&siz_lim ;*/                                                                                                                                                              
/*mxz=max(size,maxsz);*/                                                                                                                                                         
/*run;*/                                                                                                                                                                         
                                                                                                                                                                                 
                                                                                                                                                                                 
/*data _null_;*/                                                                                                                                                                 
/*set test;*/                                                                                                                                                                    
/*call symput ("siz_lim",mxz);*/                                                                                                                                                 
/*run;*/                                                                                                                                                                         
/*proc delete data=test ;run;*/                                                                                                                                                  
                                                                                                                                                                                 
/*Create "size" macro-variable for each variable in the dataset*/                                                                                                                
                                                                                                                                                                                 
                                                                                                                                                                                 
                                                                                                                                                                                 
/*data _null_;*/                                                                                                                                                                 
/*set varlist;*/                                                                                                                                                                 
/*call*/                                                                                                                                                                         
/*symput('size'||left(put(_n_,4.)),compress(SIZE_KB));*/                                                                                                                         
/*run;*/                                                                                                                                                                         
                                                                                                                                                                                 
                                                                                                                                                                                 
                                                                                                                                                                                 
/*data num_data (keep=*/                                                                                                                                                         
/*%do i=1 %to &no_var;*/                                                                                                                                                         
/*&&NAME&I*/                                                                                                                                                                     
/*%end; */                                                                                                                                                                       
/*) ;*/                                                                                                                                                                          
/*set &LIBNAME..&DSNAME;*/                                                                                                                                                       
/*run; */                                                                                                                                                                        
                                                                                                                                                                                 
%LET time=%SYSFUNC(TIME()); %PUT %SYSFUNC(PUTN(&time,time.));                                                                                                                    
                                                                                                                                                                                 
data varlist ;                                                                                                                                                                   
set varlist ;                                                                                                                                                                    
grp=ceil(_N_/400) ;                                                                                                                                                              
                                                                                                                                                                                 
run;                                                                                                                                                                             
                                                                                                                                                                                 
                                                                                                                                                                                 
proc sql noprint;                                                                                                                                                                
select max(grp) into: no_grp                                                                                                                                                     
from varlist;                                                                                                                                                                    
quit;                                                                                                                                                                            
                                                                                                                                                                                 
%LET time=%SYSFUNC(TIME()); %PUT %SYSFUNC(PUTN(&time,time.));                                                                                                                    
                                                                                                                                                                                 
%do i=1 %to &no_grp;                                                                                                                                                             
                                                                                                                                                                                 
%LET time=%SYSFUNC(TIME()); %PUT %SYSFUNC(PUTN(&time,time.));                                                                                                                    
                                                                                                                                                                                 
      data varlist_&i ;                                                                                                                                                          
      set varlist ;                                                                                                                                                              
      where grp=&i ;                                                                                                                                                             
      run;                                                                                                                                                                       
                                                                                                                                                                                 
      data _null_;                                                                                                                                                               
      set varlist_&i;                                                                                                                                                            
      call                                                                                                                                                                       
      symput('varn'||left(put(_n_,4.)),compress(varnum                                                                                                                           
      ));                                                                                                                                                                        
      call                                                                                                                                                                       
      symput('name'||left(put(_n_,4.)),trim(name));                                                                                                                              
      call                                                                                                                                                                       
      symput('type'||left(put(_n_,4.)),compress(upcase                                                                                                                           
      (type)));                                                                                                                                                                  
                                                                                                                                                                                 
      call                                                                                                                                                                       
      symput('leng'||left(put(_n_,4.)),compress(length                                                                                                                           
      ));                                                                                                                                                                        
      call                                                                                                                                                                       
      symput('labe'||left(put(_n_,4.)),trim(label));                                                                                                                             
      call                                                                                                                                                                       
      symput('form'||left(put(_n_,4.)),trim(format));                                                                                                                            
      call                                                                                                                                                                       
      symput('pos'||left(put(_n_,4.)),trim(npos));                                                                                                                               
      run;                                                                                                                                                                       
                                                                                                                                                                                 
      proc sql noprint;                                                                                                                                                          
      select count(grp) into: no_obs                                                                                                                                             
      from varlist_&i;                                                                                                                                                           
      quit;                                                                                                                                                                      
                                                                                                                                                                                 
%LET time=%SYSFUNC(TIME()); %PUT %SYSFUNC(PUTN(&time,time.));                                                                                                                    
                                                                                                                                                                                 
      data orig_&i ;                                                                                                                                                             
      set &LIBNAME..&DSNAME (keep=                                                                                                                                               
      %do j=1 %to &no_obs;                                                                                                                                                       
      &&NAME&j                                                                                                                                                                   
                                                                                                                                                                                 
      %end;                                                                                                                                                                      
      );                                                                                                                                                                         
      run;                                                                                                                                                                       
                                                                                                                                                                                 
%LET time=%SYSFUNC(TIME()); %PUT %SYSFUNC(PUTN(&time,time.));                                                                                                                    
                                                                                                                                                                                 
                                                                                                                                                                                 
                                                                                                                                                                                 
                                                                                                                                                                                 
      /*EDD for Numeric Variable*/                                                                                                                                               
                                                                                                                                                                                 
      proc sort data=varlist_&i;                                                                                                                                                 
      by varnum;                                                                                                                                                                 
      run;                                                                                                                                                                       
                                                                                                                                                                                 
      data varlist_&i;                                                                                                                                                           
      set varlist_&i;                                                                                                                                                            
      mergeid=_N_;                                                                                                                                                               
      call symput ("count_num",_N_);                                                                                                                                             
      run;                                                                                                                                                                       
                                                                                                                                                                                 
      proc means data=orig_&i noprint;                                                                                                                                           
      var :;                                                                                                                                                                     
      output out=tmp1 (drop=_type_ _freq_)  n= nmiss= mean= min= p1= p5= p25= median= p75= p95= p99= max= /autoname;                                                             
      run;                                                                                                                                                                       
                                                                                                                                                                                 
      proc transpose data=tmp1 out=tmp1_tr;                                                                                                                                      
      run;                                                                                                                                                                       
                                                                                                                                                                                 
      data num_n num_nmiss num_mean num_min num_p1 num_p5 num_p25 num_median num_p75 num_p95 num_p99 num_max;                                                                    
      set tmp1_tr;                                                                                                                                                               
            if _N_ <= &count_num then output num_n;                                                                                                                              
            if &count_num < _N_ <= 2*&count_num then output num_nmiss;                                                                                                           
            if 2*&count_num < _N_ <= 3*&count_num then output num_mean;                                                                                                          
            if 3*&count_num < _N_ <= 4*&count_num then output num_min;                                                                                                           
            if 4*&count_num < _N_ <= 5*&count_num then output num_p1;                                                                                                            
            if 5*&count_num < _N_ <= 6*&count_num then output num_p5;                                                                                                            
            if 6*&count_num < _N_ <= 7*&count_num then output num_p25;                                                                                                           
            if 7*&count_num < _N_ <= 8*&count_num then output num_median;                                                                                                        
            if 8*&count_num < _N_ <= 9*&count_num then output num_p75;                                                                                                           
            if 9*&count_num < _N_ <= 10*&count_num then output num_p95;                                                                                                          
            if 10*&count_num < _N_ <= 11*&count_num then output num_p99;                                                                                                         
            if 11*&count_num < _N_ <= 12*&count_num then output num_max;                                                                                                         
      run;                                                                                                                                                                       
                                                                                                                                                                                 
      /* Renaming the relevant variables*/                                                                                                                                       
            data num_n (rename=(col1=n));set num_n;mergeid=_N_;run;                                                                                                              
            data num_nmiss (rename=(col1=nmiss));set num_nmiss;mergeid=_N_;run;                                                                                                  
            data num_mean (rename=(col1=mean_or_top1));set num_mean;mergeid=_N_;run;                                                                                             
            data num_min (rename=(col1=min_or_top2)) ;set num_min;mergeid=_N_;run;                                                                                               
            data num_p1 (rename=(col1=p1_or_top3));set num_p1;mergeid=_N_;run;                                                                                                   
            data num_p5 (rename=(col1=p5_or_top4));set num_p5;mergeid=_N_;run;                                                                                                   
            data num_p25 (rename=(col1=p25_or_top5));set num_p25;mergeid=_N_;run;                                                                                                
            data num_median (rename=(col1=median_or_bot5));set num_median;mergeid=_N_;run;                                                                                       
            data num_p75 (rename=(col1=p75_or_bot4));set num_p75;mergeid=_N_;run;                                                                                                
            data num_p95 (rename=(col1=p95_or_bot3));set num_p95;mergeid=_N_;run;                                                                                                
            data num_p99 (rename=(col1=p99_or_bot2));set num_p99;mergeid=_N_;run;                                                                                                
            data num_max (rename=(col1=max_or_bot1));set num_max;mergeid=_N_;run;                                                                                                
                                                                                                                                                                                 
      data base_num_merged (drop=_name_);                                                                                                                                        
      merge num_n num_nmiss num_mean num_min num_p1 num_p5 num_p25 num_median num_p75 num_p95 num_p99 num_max;                                                                   
      by mergeid;                                                                                                                                                                
      run;                                                                                                                                                                       
                                                                                                                                                                                 
/*      Calculate unique values for numeric variable*/                                                                                                                           
%LET time=%SYSFUNC(TIME()); %PUT %SYSFUNC(PUTN(&time,time.));                                                                                                                    
                                                                                                                                                                                 
                  %if &num_uniq=Y %then %do;                                                                                                                                     
                                                                                                                                                                                 
                              proc sql noprint;                                                                                                                                  
                              create table uniq as                                                                                                                               
                              select                                                                                                                                             
                                                                                                                                                                                 
                              %let l=0 ;                                                                                                                                         
                                    %do %until (&no_obs=&l);                                                                                                                     
                                                                                                                                                                                 
                                                %if &l < &no_obs %then %do ;                                                                                                     
                                                %let l=%eval(&l+1) ;                                                                                                             
                                                count (distinct &&NAME&l )  as &&NAME&l ,                                                                                        
                                                %end;                                                                                                                            
                                                                                                                                                                                 
                                                                                                                                                                                 
                                                %if &l =%eval(&no_obs-1) %then %do ;                                                                                             
                                                %let l=%eval(&l+1) ;                                                                                                             
                                                                                                                                                                                 
                                                count (distinct &&NAME&l )  as &&NAME&l                                                                                          
                                                %end;                                                                                                                            
                                    %end;                                                                                                                                        
                                                                                                                                                                                 
                              from orig_&i;                                                                                                                                      
                              quit;                                                                                                                                              
                                                                                                                                                                                 
%LET time=%SYSFUNC(TIME()); %PUT %SYSFUNC(PUTN(&time,time.));                                                                                                                    
                                                                                                                                                                                 
                              proc transpose data=uniq out=uniq_tr;                                                                                                              
                              run;                                                                                                                                               
                                                                                                                                                                                 
                              data uniq_tr  (drop=_Name_ col1) ;                                                                                                                 
                              set uniq_tr ;                                                                                                                                      
                              format name $30. ;                                                                                                                                 
                              format count $30. ;                                                                                                                                
                              unique=put(col1,30.) ;                                                                                                                             
                              name=_NAME_ ;                                                                                                                                      
                              run;                                                                                                                                               
                                                                                                                                                                                 
                              proc sort data=uniq_tr ;                                                                                                                           
                              by name ;                                                                                                                                          
                              run;                                                                                                                                               
                                                                                                                                                                                 
                              proc sort data=varlist_&i ;                                                                                                                        
                              by name ;                                                                                                                                          
                              run;                                                                                                                                               
                                                                                                                                                                                 
                                                                                                                                                                                 
                              data varlist_&i ;                                                                                                                                  
                              merge varlist_&i (in=aa) uniq_tr (in=bb);                                                                                                          
                              by name ;                                                                                                                                          
                              if aa ;                                                                                                                                            
                              run;                                                                                                                                               
                                                                                                                                                                                 
                                                                                                                                                                                 
                                                                                                                                                                                 
                  %end;                                                                                                                                                          
%LET time=%SYSFUNC(TIME()); %PUT %SYSFUNC(PUTN(&time,time.));                                                                                                                    
                                                                                                                                                                                 
                  %if &num_uniq=N %then %do;                                                                                                                                     
                                                                                                                                                                                 
                  data varlist_&i ;                                                                                                                                              
                  set varlist_&i ;                                                                                                                                               
                  format unique $30. ;                                                                                                                                           
                  unique=" " ;                                                                                                                                                   
                  run;                                                                                                                                                           
                                                                                                                                                                                 
                  %end;                                                                                                                                                          
                                                                                                                                                                                 
                                                                                                                                                                                 
                                                                                                                                                                                 
      /* Final EDD for num variables*/                                                                                                                                           
                                                                                                                                                                                 
      proc sort data=varlist_&i ;                                                                                                                                                
      by mergeid ;                                                                                                                                                               
      run;                                                                                                                                                                       
                                                                                                                                                                                 
      proc sort data=base_num_merged ;                                                                                                                                           
      by mergeid ;                                                                                                                                                               
      run;                                                                                                                                                                       
                                                                                                                                                                                 
                                                                                                                                                                                 
      data base_num_merged_&i (drop=mergeid);                                                                                                                                    
      merge varlist_&i base_num_merged;                                                                                                                                          
      by mergeid;                                                                                                                                                                
      run;                                                                                                                                                                       
                                                                                                                                                                                 
                                                                                                                                                                                 
      %if &i=1 %then %do ;                                                                                                                                                       
      data base_num_final ;                                                                                                                                                      
      set base_num_merged_&i ;                                                                                                                                                   
      run;                                                                                                                                                                       
      %end ;                                                                                                                                                                     
      %else %do;                                                                                                                                                                 
                                                                                                                                                                                 
      proc datasets;                                                                                                                                                             
            append base=base_num_final                                                                                                                                           
            data=base_num_merged_&i force ;                                                                                                                                      
            quit;                                                                                                                                                                
                                                                                                                                                                                 
      %end ;                                                                                                                                                                     
                                                                                                                                                                                 
      proc delete data=orig_&i base_num_merged_&i num_n num_nmiss num_mean num_min num_p1 num_p5 num_p25 num_median num_p75 num_p95 num_p99 num_max;                             
      run;                                                                                                                                                                       
%end;                                                                                                                                                                            
                                                                                                                                                                                 
/*proc delete data=num_data ;*/                                                                                                                                                  
/*run;*/                                                                                                                                                                         
                                                                                                                                                                                 
data  base_num_final (drop= label                                                                                                                                                
length max_or_bot1 mean_or_top1 median_or_bot5 min_or_top2 n name nmiss nobs                                                                                                     
p1_or_top3 p25_or_top5 p5_or_top4 p75_or_bot4 p95_or_bot3 p99_or_bot2 type                                                                                                       
 );                                                                                                                                                                              
set Base_num_final ;                                                                                                                                                             
d1=put (label , 30.) ;                                                                                                                                                           
d2=put (length , 30.) ;                                                                                                                                                          
d3=put (max_or_bot1 , 30.5) ;                                                                                                                                                    
d4=put (mean_or_top1 , 30.5) ;                                                                                                                                                   
d5=put (median_or_bot5 , 30.5) ;                                                                                                                                                 
d6=put (min_or_top2 , 30.5) ;                                                                                                                                                    
d7=put (n , 30.5) ;                                                                                                                                                              
d8=put (name , 30.5) ;                                                                                                                                                           
d9=put (nmiss , 30.5) ;                                                                                                                                                          
d10=put (nobs , 30.5) ;                                                                                                                                                          
d11=put (p1_or_top3 , 30.5) ;                                                                                                                                                    
d12=put (p25_or_top5 , 30.5) ;                                                                                                                                                   
d13=put (p5_or_top4 , 30.5) ;                                                                                                                                                    
d14=put (p75_or_bot4 , 30.5) ;                                                                                                                                                   
d15=put (p95_or_bot3 , 30.5) ;                                                                                                                                                   
d16=put (p99_or_bot2 , 30.5) ;                                                                                                                                                   
d17=put (type , 30.) ;                                                                                                                                                           
                                                                                                                                                                                 
run;                                                                                                                                                                             
                                                                                                                                                                                 
data base_num_final(rename=(d1=label                                                                                                                                             
d2=var_length  d3=max_or_bot1  d4=mean_or_top1  d5=median_or_bot5  d6=min_or_top2                                                                                                
d7=n  d8=name  d9=nmiss  d10=numobs  d11=p1_or_top3  d12=p25_or_top5                                                                                                             
d13=p5_or_top4 d14=p75_or_bot4  d15=p95_or_bot3  d16=p99_or_bot2  d17=type                                                                                                       
 ));                                                                                                                                                                             
set base_num_final ;                                                                                                                                                             
                                                                                                                                                                                 
run;                                                                                                                                                                             
                                                                                                                                                                                 
                                                                                                                                                                                 
data base_num_final (keep=                                                                                                                                                       
name label      type var_length       numobs nmiss      unique mean_or_top1 min_or_top2                                                                                          
p1_or_top3 p5_or_top4 p25_or_top5 median_or_bot5 p75_or_bot4                                                                                                                     
p95_or_bot3 p99_or_bot2      max_or_bot1                                                                                                                                         
                                                                                                                                                                                 
);                                                                                                                                                                               
                                                                                                                                                                                 
retain  name label      type var_length      n_pos numobs nmiss      unique mean_or_top1 min_or_top2                                                                             
p1_or_top3 p5_or_top4 p25_or_top5 median_or_bot5 p75_or_bot4                                                                                                                     
p95_or_bot3 p99_or_bot2      max_or_bot1                                                                                                                                         
  ;                                                                                                                                                                              
set base_num_final;                                                                                                                                                              
format unique $30. ;                                                                                                                                                             
run;                                                                                                                                                                             
                                                                                                                                                                                 
                                                                                                                                                                                 
%mend ;
%macro edd_character ;                                                                                                                                                           
title "%upcase(&libname..&dsname)";                                                                                                                                              
/*Create an output dataset for the contents*/                                                                                                                                    
proc sql;                                                                                                                                                                        
create table varlist as                                                                                                                                                          
select a.varnum, a.name, a.type, a.length, a.label, a.format, a.npos, b.nobs                                                                                                     
from dictionary.columns as a , dictionary.tables as b                                                                                                                            
where a.libname=%upcase("&libname") and b.libname=%upcase("&libname") and                                                                                                        
a.memname=%upcase("&dsname")and  b.memname=%upcase("&dsname")and a.type="char" order by varnum;                                                                                  
quit;                                                                                                                                                                            
                                                                                                                                                                                 
/* Number of variables in dataset */                                                                                                                                             
proc sql noprint;                                                                                                                                                                
select count(name) into: no_var                                                                                                                                                  
from varlist;                                                                                                                                                                    
quit;                                                                                                                                                                            
/* Use the data step SYMPUT CALL routine to move                                                                                                                                 
the values of variables VARNAME, NAME, TYPE,                                                                                                                                     
LENGTH, LABEL, and FORMAT into Macro variables                                                                                                                                   
*/                                                                                                                                                                               
data _null_;                                                                                                                                                                     
set varlist;                                                                                                                                                                     
call                                                                                                                                                                             
symput('varn'||left(put(_n_,4.)),compress(varnum                                                                                                                                 
));                                                                                                                                                                              
call                                                                                                                                                                             
symput('name'||left(put(_n_,4.)),trim(name));                                                                                                                                    
call                                                                                                                                                                             
symput('type'||left(put(_n_,4.)),compress(upcase                                                                                                                                 
(type)));                                                                                                                                                                        
                                                                                                                                                                                 
call                                                                                                                                                                             
symput('leng'||left(put(_n_,4.)),compress(length                                                                                                                                 
));                                                                                                                                                                              
call                                                                                                                                                                             
symput('labe'||left(put(_n_,4.)),trim(label));                                                                                                                                   
call                                                                                                                                                                             
symput('form'||left(put(_n_,4.)),trim(format));                                                                                                                                  
run;                                                                                                                                                                             
                                                                                                                                                                                 
/*Create varible indicating datasize for each variable. We used Empirical formula for */                                                                                         
/*calculating approximate size for each variable*/                                                                                                                               
                                                                                                                                                                                 
data varlist ;                                                                                                                                                                   
set varlist ;                                                                                                                                                                    
varnum=_N_ ;                                                                                                                                                                     
/*SIZE_KB=CEIL((260 + 1*136+NOBS*length)/512);*/                                                                                                                                 
/*Cum_KB+SIZE_KB ;*/                                                                                                                                                             
/*SIZE_MB=round(SIZE_KB/1048576,0.1);*/                                                                                                                                          
/*CUM_MB+SIZE_MB ;*/                                                                                                                                                             
run;                                                                                                                                                                             
                                                                                                                                                                                 
                                                                                                                                                                                 
                                                                                                                                                                                 
/*data _null_;*/                                                                                                                                                                 
/*set varlist;*/                                                                                                                                                                 
/*call*/                                                                                                                                                                         
/*symput('size'||left(put(_n_,4.)),compress(SIZE_KB));*/                                                                                                                         
/*run;*/                                                                                                                                                                         
                                                                                                                                                                                 
                                                                                                                                                                                 
                                                                                                                                                                                 
/*Assign Group Name for splitting data in to specified size limit in KB*/                                                                                                        
                                                                                                                                                                                 
data varlist ;                                                                                                                                                                   
set varlist ;                                                                                                                                                                    
grp=ceil(_N_/400) ;                                                                                                                                                              
                                                                                                                                                                                 
run;                                                                                                                                                                             
                                                                                                                                                                                 
/*Determine number of variables in subsetted data*/                                                                                                                              
                                                                                                                                                                                 
proc sql noprint;                                                                                                                                                                
select max(grp) into: no_grp                                                                                                                                                     
from varlist;                                                                                                                                                                    
quit;                                                                                                                                                                            
                                                                                                                                                                                 
/*Perform the following operation "N" times. (N=Number of datsets subsetted from Numeric Dataset)*/                                                                              
                                                                                                                                                                                 
%do i=1 %to &no_grp;                                                                                                                                                             
                                                                                                                                                                                 
                  data varlist_&i ;                                                                                                                                              
                  set varlist ;                                                                                                                                                  
                  where grp=&i ;                                                                                                                                                 
                  run;                                                                                                                                                           
                                                                                                                                                                                 
                                                                                                                                                                                 
                  proc sql noprint;                                                                                                                                              
                  select count(grp) into: no_obs                                                                                                                                 
                  from varlist_&i;                                                                                                                                               
                  quit;                                                                                                                                                          
                                                                                                                                                                                 
                                                                                                                                                                                 
                  data _null_;                                                                                                                                                   
                  set varlist_&i;                                                                                                                                                
                  call                                                                                                                                                           
                  symput('varn'||left(put(_n_,4.)),compress(varnum                                                                                                               
                  ));                                                                                                                                                            
                  call                                                                                                                                                           
                  symput('name'||left(put(_n_,4.)),trim(name));                                                                                                                  
                  call                                                                                                                                                           
                  symput('type'||left(put(_n_,4.)),compress(upcase                                                                                                               
                  (type)));                                                                                                                                                      
                                                                                                                                                                                 
                  call                                                                                                                                                           
                  symput('leng'||left(put(_n_,4.)),compress(length                                                                                                               
                  ));                                                                                                                                                            
                  call                                                                                                                                                           
                  symput('labe'||left(put(_n_,4.)),trim(label));                                                                                                                 
                  call                                                                                                                                                           
                  symput('form'||left(put(_n_,4.)),trim(format));                                                                                                                
                  run;                                                                                                                                                           
                                                                                                                                                                                 
                                                                                                                                                                                 
                                                                                                                                                                                 
                  data orig_&i (keep=                                                                                                                                            
                  %do j=1 %to &no_obs;                                                                                                                                           
                  &&NAME&j                                                                                                                                                       
                                                                                                                                                                                 
                  %end;                                                                                                                                                          
                  );                                                                                                                                                             
                  set &LIBNAME..&DSNAME ;                                                                                                                                        
                  run;                                                                                                                                                           
                                                                                                                                                                                 
                        proc sort data=varlist_&i;                                                                                                                               
                        by name;                                                                                                                                                 
                        run;                                                                                                                                                     
                                                                                                                                                                                 
                  data _NULL_;                                                                                                                                                   
                  set varlist_&i;                                                                                                                                                
                  var=compress("nam"||_N_);                                                                                                                                      
                  var1=compress("ischar"||_N_);                                                                                                                                  
                  call symput (var,name);                                                                                                                                        
                  call symput (var1,type);                                                                                                                                       
                  call symput ("countvar",_N_);                                                                                                                                  
                  run;                                                                                                                                                           
                                                                                                                                                                                 
                  /* Finding top 5 and bottom 5 for the character variables*/                                                                                                    
                  %let k=0;                                                                                                                                                      
                                                                                                                                                                                 
                  %do l=1 %to &countvar;                                                                                                                                         
                        %let charfreq_done = 0;                                                                                                                                  
                        %if &&ischar&i =char %then                                                                                                                               
                        %do;                                                                                                                                                     
                        %let k=%eval(&k+1);                                                                                                                                      
                                                                                                                                                                                 
                        proc freq data=orig_&i noprint;                                                                                                                          
                        tables &&nam&k/missing out=freqout&k;                                                                                                                    
                        run;                                                                                                                                                     
                                                                                                                                                                                 
                  /* Counting the number of distinct values of a char var*/                                                                                                      
                        data _NULL_;                                                                                                                                             
                        set freqout&k end=final;                                                                                                                                 
                        if final then call symput ("numobs",compress(_N_));                                                                                                      
                        run;                                                                                                                                                     
                                                                                                                                                                                 
/*                        Reset the value of "no_miss" variable to 0. If number of missing is zero then */                                                                       
/*                        this variable will not be assigned and it retains its value=0*/                                                                                        
                        %let no_miss=0 ;                                                                                                                                         
                                                                                                                                                                                 
                                                                                                                                                                                 
                        /* Counting the number of missing values of a char var*/                                                                                                 
                                                                                                                                                                                 
                        proc sql noprint;                                                                                                                                        
                        select count into: no_miss                                                                                                                               
                        from freqout&k where &&nam&k=" ";                                                                                                                        
                        quit;                                                                                                                                                    
                                                                                                                                                                                 
                  /* Creating a flag for detecting whether bottom 5 need to be found out or not*/                                                                                
                        %let botfreq=0;                                                                                                                                          
                        %if (&numobs gt 5) %then %let botfreq=1;                                                                                                                 
                                                                                                                                                                                 
                  /* Finding the top 5 values with their counts and formatting them properly*/                                                                                   
                        proc sort data=freqout&k out=freqout_top5_&k;                                                                                                            
                        by descending count;                                                                                                                                     
                        run;                                                                                                                                                     
                        data freqout_top5_&k (drop=&&nam&k);                                                                                                                     
                        set freqout_top5_&k;                                                                                                                                     
                        format new $100. ;                                                                                                                                       
                        new=(trim(&&nam&k)||"::"||compress(count));                                                                                                              
                        if _N_ lt 6;                                                                                                                                             
                        run;                                                                                                                                                     
                        data freqout_top5_&k (drop=new);                                                                                                                         
                        set freqout_top5_&k;                                                                                                                                     
                        &&nam&k=new;                                                                                                                                             
                        run;                                                                                                                                                     
                         proc transpose data=freqout_top5_&k out=freqout_top5_&k;                                                                                                
                        var &&nam&k;                                                                                                                                             
                        run;                                                                                                                                                     
                        data freqout_top5_&k (rename=(col1=mean_or_top1 col2=min_or_top2 col3=p1_or_top3 col4=p5_or_top4 col5=p25_or_top5));                                     
                        set freqout_top5_&k ;                                                                                                                                    
                        run;                                                                                                                                                     
                                                                                                                                                                                 
                        proc sort data=freqout&k out=freqout_bot5_&k;                                                                                                            
                        by count;                                                                                                                                                
                        run;                                                                                                                                                     
                        data freqout_bot5_&k (drop=&&nam&k);                                                                                                                     
                        set freqout_bot5_&k;                                                                                                                                     
                        format new $100. ;                                                                                                                                       
                        new=(trim(&&nam&k)||"::"||compress(count));                                                                                                              
                        id=_N_;                                                                                                                                                  
                        if _N_ lt 6;                                                                                                                                             
                        run;                                                                                                                                                     
                        proc sort data=freqout_bot5_&k;                                                                                                                          
                        by descending id;                                                                                                                                        
                        run;                                                                                                                                                     
                        data freqout_bot5_&k (drop=new id);                                                                                                                      
                        set freqout_bot5_&k;                                                                                                                                     
                        &&nam&k=new;                                                                                                                                             
                        run;                                                                                                                                                     
                                                                                                                                                                                 
                  /* To check if the character variable has 5 or less than 5 distinct values and accordingly do formatting*/                                                     
                        %if (&botfreq eq 0) %then                                                                                                                                
                        %do;                                                                                                                                                     
                        data freqout_bot5_&k;                                                                                                                                    
                        set freqout_bot5_&k;                                                                                                                                     
                        &&nam&k='';;                                                                                                                                             
                        run;                                                                                                                                                     
                        %end;                                                                                                                                                    
                                                                                                                                                                                 
                        proc transpose data=freqout_bot5_&k out=freqout_bot5_&k;                                                                                                 
                        var &&nam&k;                                                                                                                                             
                        run;                                                                                                                                                     
                        data freqout_bot5_&k (rename=(col1=median_or_bot5 col2=p75_or_bot4 col3=p95_or_bot3 col4=p99_or_bot2 col5=max_or_bot1));                                 
                        set freqout_bot5_&k ;                                                                                                                                    
                        run;                                                                                                                                                     
                        data stat&k;                                                                                                                                             
                        merge freqout_top5_&k freqout_bot5_&k;                                                                                                                   
                        by _name_;                                                                                                                                               
                        run;                                                                                                                                                     
                                                                                                                                                                                 
                        /*Create variable for number of unique values and number of missing values*/                                                                             
                        data stat&k;                                                                                                                                             
                        set stat&k;                                                                                                                                              
                        nmiss=&no_miss;                                                                                                                                          
                        nunique=&numobs ;                                                                                                                                        
                        run;                                                                                                                                                     
                                                                                                                                                                                 
                  /* Appending the results for all the char variables and making one single dataset*/                                                                            
                        data stat1;                                                                                                                                              
                        length _name_ mean_or_top1 min_or_top2 p1_or_top3 p5_or_top4 p25_or_top5 median_or_bot5 p75_or_bot4                                                      
                        p95_or_bot3 p99_or_bot2 max_or_bot1 $100;                                                                                                                
                        set stat1;                                                                                                                                               
                        run;                                                                                                                                                     
                                                                                                                                                                                 
                                                                                                                                                                                 
                        proc datasets;                                                                                                                                           
                        append base=stat1                                                                                                                                        
                        data=stat&k force ;                                                                                                                                      
                        quit;                                                                                                                                                    
                                                                                                                                                                                 
                  /* Setting the flag if the top5-bottom5 analysis was done for a varibale*/                                                                                     
                        %let charfreq_done=1;                                                                                                                                    
                                                                                                                                                                                 
                  %end;                                                                                                                                                          
                                                                                                                                                                                 
                        %if (&k ne 1 and &charfreq_done eq 1) %then %do;                                                                                                         
                        proc delete data=stat&k ;                                                                                                                                
                        run;                                                                                                                                                     
                        %end;                                                                                                                                                    
                                                                                                                                                                                 
                        %if (&charfreq_done eq 1) %then %do;                                                                                                                     
                        proc delete data=freqout&k freqout_top5_&k freqout_bot5_&k;                                                                                              
                        run;                                                                                                                                                     
                        %end;                                                                                                                                                    
                                                                                                                                                                                 
                  %end;                                                                                                                                                          
                                                                                                                                                                                 
                  /* Obtaining the final dataset for char variables*/                                                                                                            
                  data final_char;                                                                                                                                               
                  set stat1;                                                                                                                                                     
                  if _N_ > 1;                                                                                                                                                    
                  run;                                                                                                                                                           
                                                                                                                                                                                 
                  proc delete data=stat1;                                                                                                                                        
                  run;                                                                                                                                                           
                                                                                                                                                                                 
                                                                                                                                                                                 
                  /* Generating the final EDD for character variables*/                                                                                                          
                  data base_char_merged_final;                                                                                                                                   
                  merge varlist_&i final_char (rename=(_name_=name));                                                                                                            
                  n="N/A";                                                                                                                                                       
                  by name;                                                                                                                                                       
                  run;                                                                                                                                                           
                                                                                                                                                                                 
                  data base_char_merged_final;                                                                                                                                   
                  retain name label type length  varnum n nmiss;                                                                                                                 
                  set base_char_merged_final;                                                                                                                                    
                  run;                                                                                                                                                           
                                                                                                                                                                                 
                  /* Converting the numeric entires in the EDD for numeric variables to character */                                                                             
                  data base_char_merged_final1                                                                                                                                   
                  (drop=n1 nmiss1 mean1 min1 p11 p51 p251 median1 p751 p951 p991 max1 n nmiss mean_or_top1  min_or_top2                                                          
                          p1_or_top3   p5_or_top4  p25_or_top5  median_or_bot5  p75_or_bot4  p95_or_bot3  p99_or_bot2  max_or_bot1);                                             
                  set base_char_merged_final;                                                                                                                                    
                        n1=n;                                                                                                                                                    
                        n2=put(n1,30.);                                                                                                                                          
                        nmiss1=nmiss;                                                                                                                                            
                        nmiss2=put(nmiss1,30.);                                                                                                                                  
                        mean1=mean_or_top1;                                                                                                                                      
                        mean2=put(mean1,30.5);                                                                                                                                   
                        min1=min_or_top2;                                                                                                                                        
                        min2=put(min1,30.5);                                                                                                                                     
                        p11=p1_or_top3;                                                                                                                                          
                        p12=put(p11,30.5);                                                                                                                                       
                        p51=p5_or_top4;                                                                                                                                          
                        p52=put(p51,30.5);                                                                                                                                       
                        p251=p25_or_top5;                                                                                                                                        
                        p252=put(p251,30.5);                                                                                                                                     
                        median1=median_or_bot5;                                                                                                                                  
                        median2=put(median1,30.5);                                                                                                                               
                        p751=p75_or_bot4;                                                                                                                                        
                        p752=put(p751,30.5);                                                                                                                                     
                        p951=p95_or_bot3;                                                                                                                                        
                        p952=put(p951,30.5);                                                                                                                                     
                        p991=p99_or_bot2;                                                                                                                                        
                        p992=put(p991,30.5);                                                                                                                                     
                        max1=max_or_bot1;                                                                                                                                        
                        max2=put(max1,30.5);                                                                                                                                     
                        numobs=put(nobs,30.) ;                                                                                                                                   
                        unique=put(nunique,30.) ;                                                                                                                                
                        var_length=put(length,30.);                                                                                                                              
                  run;                                                                                                                                                           
                                                                                                                                                                                 
                                                                                                                                                                                 
                  data base_char_merged_final1 (rename=( n2=n nmiss2=nmiss mean2=mean_or_top1 min2=min_or_top2  p12=p1_or_top3   p52=p5_or_top4  p252=p25_or_top5                
                  median2=median_or_bot5  p752=p75_or_bot4  p952=p95_or_bot3  p992=p99_or_bot2  max2=max_or_bot1 ));                                                             
                  set base_char_merged_final1;                                                                                                                                   
                  run;                                                                                                                                                           
                                                                                                                                                                                 
/*                  data base_char_merged_final1;*/                                                                                                                              
/*                  var_length numobs nmiss unique  mean_or_top1 min_or_top2 p1_or_top3 p5_or_top4 p25_or_top5 median_or_bot5 p75_or_bot4 p95_or_bot3 p99_or_bot2 */             
/*                  max_or_bot1 $100;*/                                                                                                                                          
/*                  set base_char_merged_final1;*/                                                                                                                               
/*                  run;*/                                                                                                                                                       
                                                                                                                                                                                 
                  data base_char_merged_final1;                                                                                                                                  
                  retain name label type  var_length numobs nmiss unique  mean_or_top1 min_or_top2 p1_or_top3 p5_or_top4 p25_or_top5 median_or_bot5 p75_or_bot4 p95_or_bot3      
                  p99_or_bot2 ;                                                                                                                                                  
                  set base_char_merged_final1;                                                                                                                                   
                  run;                                                                                                                                                           
                                                                                                                                                                                 
                  %if &i=1 %then %do ;                                                                                                                                           
                  data base_char_final ;                                                                                                                                         
                  set base_char_merged_final1 ;                                                                                                                                  
                  run;                                                                                                                                                           
                  %end ;                                                                                                                                                         
                                                                                                                                                                                 
                  %else %do;                                                                                                                                                     
                  proc datasets;                                                                                                                                                 
                  append base=base_char_final                                                                                                                                    
                  data=base_char_merged_final1 force ;                                                                                                                           
                  quit;                                                                                                                                                          
                  %end ;                                                                                                                                                         
                                                                                                                                                                                 
                  data base_char_final (keep=                                                                                                                                    
                  name label      type  var_length      numobs nmiss      unique mean_or_top1 min_or_top2                                                                        
                  p1_or_top3 p5_or_top4 p25_or_top5 median_or_bot5 p75_or_bot4                                                                                                   
                  p95_or_bot3 p99_or_bot2      max_or_bot1                                                                                                                       
                                                                                                                                                                                 
                  );                                                                                                                                                             
                  set base_char_final ;                                                                                                                                          
                  run;                                                                                                                                                           
                                                                                                                                                                                 
                  proc delete data= orig_&i varlist_&i ;                                                                                                                         
                  run;                                                                                                                                                           
                                                                                                                                                                                 
                                                                                                                                                                                 
%end;                                                                                                                                                                            
                                                                                                                                                                                 
                                                                                                                                                                                 
                        proc delete data= Base_char_merged_final Base_char_merged_final1 Final_char  varlist;                                                                    
                        run;                                                                                                                                                     
                                                                                                                                                                                 
%mend edd_character;

/*%edd(libname, dsname, edd_out_loc, NUM_UNIQ );*/