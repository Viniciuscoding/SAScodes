/******************************************************************************/
/************** Detecting duplicate BY values using a DATA step  **************/
/******************************************************************************/

data Duplicates;
	input Subj : 3. Gender : $1. Age : 3. Height : 2. Weight : 3.;
datalines;
001 M 23 63 122
002 F 44 59 109
002 F 44 59 109
003 M 87 67 200
004 F 100 53 112
004 F 50 59 201
005 M 45 69 188
;


proc sort data=Duplicates out=Sorted_Duplicates_DATAstep;
	by Subj;
run;

data Keeping_Duplicates;
	set Sorted_Duplicates_DATAstep;
	by Subj;
	if First.Subj and Last.Subj then delete;
run;



/******************************************************************************/
/********** Extracting the first and last observation in a BY group  **********/
/******************************************************************************/

 proc sort data=Duplicates out=Sorted_Duplicates;
 	by Subj;
run;

data _null_;
	set Sorted_Duplicates;
	by Subj;
	put Subj= First.Subj= Last.Subj=;
run;

*Selecting the last observation for each subject;
proc sort data=Duplicates out=Last_Object;
	by Subj;
run;

data Last;
	set Sorted_Duplicates;
	by Subj;
	if Last.Subj;
run;

*Selecting the first observation for each subject;
proc sort data=Duplicates out=First_Object;
	by Subj;
run;

data First;
	set First_Object;
	by Subj;
	if First.Subj;
run;




