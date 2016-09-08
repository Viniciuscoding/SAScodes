/************************************************************************/
/******* Computing a person's age, given his or her data of birth *******/
/************************************************************************/

*DEMOGRAPHIC DATA SET;
data Demographic;
   call streaminit(374354);
   do Subj = 1 to 20;
      if rand('uniform') ge .1 then Score = ceil(rand('uniform')*100);
      else Score = 999;
      if rand('uniform') ge .1 then Weight = ceil(rand('normal',150,30));
      else Weight = 999;
      if rand('uniform') ge .1 then Heart_Rate = ceil(rand('normal',70,10));
      else Heart_Rate = 999;
      DOB = -3652 + ceil(rand('uniform')*2190);
      if rand('uniform') gt .5 then Gender = 'Female';
      else Gender = 'Male';
      if rand('uniform') lt .2 then Gender = 'NA';
      if rand('uniform') ge .8 then Gender = lowcase(Gender);
      if rand('uniform') gt .6 then Party = 'Republican';
      else Party = 'Democrat';
      if rand('uniform') lt .2 then Party = 'NA';
      if rand('uniform') gt .5 then Party = lowcase(Party);
      output;
   end;
   format DOB date9.;
run;

*Computing a person's age, given date of birth;
data Compute_Age;
	set Demographic; *DOB is the column with Days of Birthdays;
	Age_Exact = yrdif(DOB, '01jan2012'd); *1st arg. = Initial period;  *2nd arg. = Final period;
	Age_Last_Birthday = int(Age_Exact);
	Age_Exact_Today = yrdif(DOB, TODAY()); *TODAY(): gives the current date as final period;
	Age_Today_Last_Birthday = int(Age_Exact_Today);
run;



/**************************************************************************/
/** Computing a SAS date when the day of the month may be missing by MDY **/
/**************************************************************************/

data MoDayYear;
   input Month Day Year;
datalines;
10 21 1955
6 . 1985
8 1 2001
9 . 2000
;

*Computing a SAS date when the day of the month may be missing;
data Compute_Date;
	set MoDayYear;
	if missing(Day) then Date = MDY(Month, 15, Year); *Missing date then 15th day is used as alternate day;
	else Date = MDY(Month, Day, Year);
	format Date date9.;
run;



/************************************************************************/
/**** Computing a SAS date when the day of the month may be missing *****/
/******************** Using COALESCE function ***************************/
/************************************************************************/

*Alternative (elegant) solution suggested by Mark Jordan;
data Compute_Date_COALESCE;
	set MoDayYear;
	Date = MDY(Month,coalesce(Day,15),Year);
	format Date date9.;
run;


