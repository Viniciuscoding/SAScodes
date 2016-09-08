/**********************************************************************************/
/* MULTIPLE OUTPUT data sets from PROC MEANS using different variables with CLASS */
/**********************************************************************************/

*BLOOD PRESSURE DATA SET;
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



/**********************************************************************************/
/****** Combining SUMMARY and DETAIL DATA using a conditional SET statement *******/
/**********************************************************************************/

*Program to compare each person's heart rate with 
 the mean heart rate of all the observations;
proc means data=Blood_Pressure noprint;
	var Heart_Rate;
	output out=Summary(keep=Mean_HR) mean=Mean_HR;
run;

* Demonstrating a conditional SET statement;
data SET_Percent_of_Mean;
	set Blood_Pressure(keep=Heart_Rate Subj);
	if _n_ = 1 then set Summary;
	Percent = round(100*(Heart_Rate / Mean_HR));
run;



/**********************************************************************************/
/*************** Combining SUMMARY and DETAIL DATA using PROC SQL *****************/
/**********************************************************************************/

*Solution using PROC SQL;
proc sql;
	create table SQL_Percent_of_Mean as
	select Subj, Heart_Rate, Mean_HR
	from Blood_Pressure, Summary;
quit;



/**********************************************************************************/
/******* Combining SUMMARY and DETAIL DATA using PROC SQL without PROC MEANS ******/
/**********************************************************************************/

*PROC SQL solution not using PROC MEANS;
proc sql;
	create table NOMean_SQL_Percent_of_Mean as
	select Subj, Heart_Rate, round(100 * Heart_Rate / mean(Heart_Rate))
		as Percent
	from Blood_Pressure;
quit;



/**********************************************************************************/
/************ Combining SUMMARY and DETAIL DATA using a MACRO VARIABLE ************/
/**********************************************************************************/

* Solution using a macro variable;
data _null_;
	set summary;
	call symputx('Macro_Mean', Mean_HR);
run;

proc sql noprint;
	select mean(Heart_Rate)
	into :Macro_Mean
	from Blood_Pressure;
quit;

data MACRO_Percent_of_Mean;
	set Blood_Pressure(keep=Heart_Rate Subj);
	Percent = round(100 * (Heart_Rate / &Macro_Mean));
run;

/**********************************************************************************/
/****** Combining SUMMARY and DETAIL DATA for each category of a BY variable ******/
/**********************************************************************************/

*Program to compare each person's heart rate with the mean heart rate for each value
of Gender;

proc means data=Blood_Pressure noprint nway;
	class Gender;
	var Heart_Rate;
	output out=By_Gender(keep=Gender Mean_HR) mean=Mean_HR;
run;

proc sort data=Blood_Pressure; by Gender; run;

data BY_Percent_of_Mean;
	merge Blood_Pressure(keep=Heart_Rate Gender Subj) By_Gender;
	by Gender;
	Percent = round(100 * (Heart_Rate / Mean_HR));
run;

proc sort data=BY_Percent_of_Mean; by Subj; run;