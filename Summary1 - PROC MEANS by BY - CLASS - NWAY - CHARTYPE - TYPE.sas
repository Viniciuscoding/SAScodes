/******************************************************************************/
/******* PROC MEANS to create a data set containing summary information *******/
/******************************************************************************/

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


/*******************************************************************************/
/************************ PROC MEANS of a specific variable ********************/
/*******************************************************************************/

*Computing the means of all observations and outputting it to a SAS data set;
proc means data=Blood_Pressure noprint;
	var Heart_Rate;
	output out=Summary(keep=Mean_HR) mean=Mean_HR;
run;



/*******************************************************************************/
/* PROC MEANS of a variable broken down by values of another variable using BY */
/*******************************************************************************/

proc sort data=Blood_Pressure;
	by Drug;
run;

proc means data=Blood_Pressure noprint;
	var Heart_Rate;
	output out=Summary_BY mean=Mean_HR;
	by Drug;
run;



/**********************************************************************************/
/* PROC MEANS of a variable broken down by values of another variable using CLASS */
/**********************************************************************************/

*Using PROC MEANS to create a summary data set;
proc means data=Blood_Pressure noprint;
	class Drug;
	var Heart_Rate;
	output out=Summary_CLASS mean=Mean_HR;
run;

*Demonstrating the NWAY option;
proc means data=Blood_Pressure noprint nway;
	var Heart_Rate;
	output out=Summary_NWAY mean=Mean_HR;
	class Drug;
run;



/**********************************************************************************/
/*** Have PROC MEANS name variables in the OUTPUT automatically through AUTONAME **/
/**********************************************************************************/

proc means data=Blood_Pressure noprint nway;
	Class Drug;
	var Heart_Rate;
	output out=Summary_AUTONAME (drop=_type_ _freq_)
		n= mean= max= / autoname;
run;



/**********************************************************************************/
/*************** Demonstrating the CHARTYPE option with PROC MEANS ****************/
/**********************************************************************************/

proc means data=Blood_Pressure noprint chartype;
	class Drug Gender;
	var Heart_Rate;
	output out=Summary_MultiCLASS mean=Mean_HR;
run;



/**********************************************************************************/
/******** Using _TYPE_ variable to send summary data to separate data sets ********/
/**********************************************************************************/

data  Grand(drop=Drug Gender)
	  ByGender(drop=Drug)
	  ByDrug(drop=Gender)
	  ByDrugGender;
	  drop _type_ _freq_;
	set Summary_MultiCLASS;
	if _type_ = '00' then output Grand;
	else if _type_ = '01' then output ByGender;
	else if _type_ = '10' then output ByDrug;
	else if _type_ = '11' then output ByDrugGender;
run;