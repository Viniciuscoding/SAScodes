/******************************************************************************/
/****************** Reading Data with User-Defined INFORMATS  *****************/
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

*Using PROC SORT to detect duplicate BY value;
proc sort data=Duplicates out=NO_DUPKEY nodupkey;
	by Subj;
run;

proc sort data=Duplicates out=NO_DUPRECS noduprecs;
	by Subj; *NODUPRECS option removes SUCCESSIVE DUPLICATES;
run;

/******************************************************************************/
/************ NODUPRECS problem with NON-CONSECUTIVE DUPLICATES  **************/
/******************************************************************************/

data Special_CASE;
	input Subj : 3. X : 1. Y : 1.;
datalines;
001 1 2
001 3 2
001 1 2
002 5 7
003 7 8
003 7 8
005 4 5
;

*Solution for the NODUPRECS problem with NON-CONSECUTIVE DUPLICATES;
*SORT BY _ALL_;

proc sort data=Special_CASE out=Wrong noduprecs;
	by Subj; *NODUPRECS option removes SUCCESSIVE DUPLICATES;
run;

proc sort data=Special_CASE out=Solution noduprecs;
	by _all_;
run;

*NODUPKEY with the specific variables sorting works as well;
proc sort data=Special_CASE out=NO_DUPKEY_Test nodupkey; by Subj X; run;

*NODUPKEY with wrong specific variables sorting will remove variables that are not repeating;
proc sort data=Special_CASE out=NO_DUPKEY_Wrong nodupkey; by Subj Y; run;