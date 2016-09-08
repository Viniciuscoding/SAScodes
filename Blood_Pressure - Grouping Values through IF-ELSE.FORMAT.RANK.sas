/******************************************************************************/
/**************** GROUPING VALUES USING IF-THEN-ELSE STATEMENTS ***************/
/******************************************************************************/


data Blood_Pressure;
	input Subj : $2. Heart_Rate : best3.;
datalines;
1 71
2 .
3 78
4 60
5 79
6 96
7 51
8 .
9 54
10 65

run;

data Grouped;
	length HR_Group $ 10.; *Defines the length of HR_Group. Moreover, it sets the variable HR_Group first in column;
	set Blood_Pressure(keep=Subj Heart_Rate);
	if missing(Heart_Rate) then HR_Group = ' ';
	else if Heart_Rate lt 40 then HR_Group = '<40';
	else if Heart_Rate lt 60 then HR_Group = '40-<60';
	else if Heart_Rate lt 80 then HR_Group = '60-<80';
	else if Heart_Rate lt 100 then HR_Group = '80-<100';
	else HR_Group = '100 +';
run;


/******************************************************************************/
/***************** GROUPING VALUES USING USER_DEFINED FORMATS *****************/
/******************************************************************************/

* Grouping values using formats;
proc format;
	value HRgrp   0 - <40  = '<40'
				 40 - <60  = '40-<60'
				 60 - <80  = '60-<80'
				 80 - <100 = '80-<100'
				100 - high = '100 +';
run;

data Grouped_byPUT;
	set Blood_Pressure(keep=Subj Heart_Rate);
	HR_Group = put(Heart_Rate, HRgrp.);
run;


/******************************************************************************/
/*********************** GROUPING VALUES USING PROC RANK **********************/
/******************************************************************************/

data Raw_Data;
	input Subj : $3. X : best1. Y : best2.;
datalines;
001 3 10
002 7 20
003 2 30
004 4 40
;
run;

/* SYNTAX;
PROC RANK DATA=data-set-name OUT=output-data-set-name
		  GROUPS=n;
	VAR list of variables;
	RANKS list of variables holding the rank values;
run;
*/

proc rank data=Raw_Data out=Rank_Data;
	var X;
	ranks Rank_X;
run;

* DIVIDING X INTO 2 EQUAL GROUPS;

proc rank data=Raw_Data(keep=Subj X) out=Group_Data groups=2;
	var X;
	ranks Group_X;
run;

data Blood_Pressure1;
	input Subj : $2. Heart_Rate : best3.;
datalines;
1 71
2 .
3 78
4 60
5 79
6 96
7 51
8 .
9 54
10 65
11 55
12 48

run;

proc rank data=Blood_Pressure1(keep=Subj Heart_Rate)
		  out = New_Grouped groups=5;
	var Heart_Rate;
	ranks HR_Group;
run;