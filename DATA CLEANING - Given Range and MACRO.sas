/*****************************/
/******* DATA CLEANING *******/
/*****************************/



/************************************************************************/
/********* Looking for possible data errors using a GIVEN RANGE *********/
/************************************************************************/

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

*Method using known ranges;
title "Listing of Patient Numbers and Invalid Data Values";
data _null_;
	set Blood_Pressure;
	file print;
	***Check Hear_Rate;
	if (Heart_Rate lt 40 and not missing(Heart_Rate)) or
		Heart_Rate gt 100 then put Subj= @10 Heart_Rate=;
	***Check SBP;
	if (SBP lt 80 and not missing(SBP)) or
		SBP gt 200 then put Subj= @10 SBP=;
	***Check DBP;
	if (DBP lt 60 and not missing(DBP)) or
		DBP gt 120 then put Subj= @10 DBP=;
run;



/************************************************************************/
/********* Looking for possible data errors using a GIVEN RANGE *********/
/************************************************************************/

*Macro to perform range checking for numeric variables;
%macro errors(Var=,		/* Variable to test		*/
			  Low=,		/* Low value			*/
			  High=,	/* High value			*/
			  Missing=IGNORE
			  			/* How to treat missing values		*/
			  			/* Ignore is the default. To flag 	*/
			  			/* missing values as errors set 	*/
			  			/* Missing=ERROR					*/);

data Tmp;
	set &Dsn(keep=&Idvar &Var);
	length Reason $ 10 Variable $ 32;
	Variable = "&Var";
	Value = &Var;
	if &Var lt &Low and not missing(&Var) then do;
		Reason='Low';
		output;
	end;
	%if %upcase(&Missing) ne IGNORE %then %do;
	else if missing (&Var) then do;
		Reason='Missing';
		output;
	end;
	%end;

	else if &Var gt &High then do;
		Reason='High';
		output;
		end;
		drop &Var;
	run;
	proc append base=errors data=Tmp;
	run;
%mend errors; 

*Macro to generate an error report after the errors has been run;
%macro report;
	proc sort data=errors;
		by &Idvar;
	run;

	proc print data=errors;
		title "Error Report for Data Set &Dsn";
		id &Idvar;
		var Variable Value Reason;
	run;

	proc datasets library=work nolist;
		delete errors;
		delete tmp;
	run;
	quit;
%mend report;


*Testing the macro;
%let Dsn = Blood_Pressure;
%let Idvar = Subj;
%errors(Var=Heart_Rate, Low=40, High=100, Missing=error)
%errors(Var=SBP, Low=80, High=200, Missing=ignore)
%errors(Var=DBP, Low=60, High=120, Missing=ignore)
%report