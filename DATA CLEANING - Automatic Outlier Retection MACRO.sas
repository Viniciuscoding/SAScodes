/*****************************/
/******* DATA CLEANING *******/
/*****************************/

*Program to create the Blood_Pressure data set;
data blood_pressure;
   call streaminit(37373);
   do Drug = 'Placebo','Drug A','Drug B';
      do i = 1 to 20;
         Subj + 1;
         if mod(Subj,2) then Gender = 'M';
         else Gender = 'F';
         SBP = rand('normal',130,10) +
               7*(Drug eq 'Placebo') - 6*(Drug eq 'Drug B')
               + (rand('uniform') lt .2)*(rand('normal',0,30));
         SBP = round(SBP,2);
         DBP = rand('normal',80,5) +
               3*(Drug eq 'Placebo') - 2*(Drug eq 'Drug B')
               + (rand('uniform') lt .2)*(rand('normal',0,30));
         DBP = round(DBP,2);
         if Subj in (5,15,25,55) then call missing(SBP, DBP);
         if Subj in (4,18) then call missing(Gender);
         Heart_Rate = int(rand('normal',70,20) 
                       + 5*(Gender='M') 
                       - 8*(Drug eq 'Drug B'));
         if Subj in (2,8) then call missing(Heart_Rate);
         output;
      end;
   end;
   drop i;
run;

/************************************************************************/
/************ MACRO that performs automatic OUTLIER DETECTION ***********/
/************************************************************************/

*Method using automatic outlier detection;
%macro Auto_Outliers(Dsn=,		/* Data set name						*/
					 ID=,		/* Name of ID variable					*/
					 Var_list=,	/* List of variables to check			*/
					 			/* separate names with spaces			*/
					 Trim=0.1,	/* Integer 0 to n = number to trim		*/
					 			/* from each tail; if between 0 and 0.5,*/
					 			/* proportion to trim in each tail		*/
					 N_sd=2		/* Number of standard deviations		*/);
	ods listing close;
	ods output TrimmedMeans=Trimmed(keep=VarName Mean Stdmean DF);
	proc univariate data=&Dsn trim=&Trim;
		var &Var_list;
	run;
	ods output close;

	data Restructure;
		set &Dsn;
		length Varname $ 32;
		array vars[*] &Var_list;
		do i = 1 to dim(vars);
			Varname = vname(vars[i]);
			Value = vars[i];
			output;
		end;
		keep &ID Varname Value;
	run;

	proc sort data=trimmed;
		by Varname;
	run;

	proc sort data=restructure;
		by Varname;
	run;

	data Outliers;
		merge Restructure Trimmed;
		by Varname;
		Std = StdMean * sqrt(DF + 1);
		if Value lt Mean - &N_sd * Std and not missing(Value)
			then do;
				Reason = 'Low  ';
				output;
			end;
		else if Value gt Mean + &N_sd * Std
			then do;
			Reason = 'High';
			output;
			end; *checking;
		run;
	run;

	proc sort data=Outliers;
		by &ID;
	run;

	ods listing;
	title "Outliers Based on Trimmed Statistics";
	proc print data=Outliers;
		id &ID;
		var Varname Value Reason;
	run;

	proc datasets nolist library=work;
		delete Trimmed;
		delete Restructure;
	run;
	quit;
%mend auto_outliers;


*TESTING THE AUTO OUTLIERS MACRO;
%auto_outliers(Dsn=Blood_Pressure, ID=Subj, Var_List=Heart_Rate SBP DBP, N_Sd=2.5)
 