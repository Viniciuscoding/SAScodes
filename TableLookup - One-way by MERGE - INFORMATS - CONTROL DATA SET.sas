/************************************************************************/
/****** Performing a ONE-WAY TABLE LOOKUP using a MERGE statement *******/
/************************************************************************/


data Sales;
	input Sales_ID : $4. Year : 4. Sales : 5.;
datalines;
1234 2004 20.5
1234 2005 22.0
1234 2006 26.0
1234 2007 27.0
1234 2008 37.0
;
run;

data Goals;
	input Year : 4. Goal : 2.;
datalines;
2004 20
2005 21
2006 24
2007 28
2008 34
;
run;

*Using a MERGE to perform a table lookup;
proc sort data=Goals; by Year; run;
proc sort data=Sales; by Year; run;

data Sales_Goals;
	merge Goals Sales;
	by Year;
	Difference = Sales - Goal;
run;

proc sort data=Sales_Goals; by Sales_ID Year; run;



/************************************************************************/
/**** Performing a ONE-WAY TABLE LOOKUP using USER-DEFINED INFORMATS ****/
/************************************************************************/

*Creating the INFORMAT "manually" using PROC FORMAT;
proc format;
	invalue Goalfmt 2004=20
					2005=21
					2006=24
					2007=28
					2008=34
					2009=40
					2010=49
					2011=60
					2012=75;
run;

data Sales_Goals_INVALUE;
	set Sales;
	Goal = input(put(Year,4.),Goalfmt.); *INPUT: Character-to-numeric conversion;
										 *PUT: Necessary to trasnform year into character variable;
										   *OBS: Necessary because first argument of INPUT must be a character;
										 *Goalfmt: A numeric informat. It converts the year to numeric value;
												   *EX: Year 2008 is converted to 34(numeric value);
	Difference = Sales - Goal;
run;



/************************************************************************/
/************* Creating an INFORMAT using CONTROL DATA SET **************/
/************************************************************************/

data Control;
	set Goals(rename=(Year = Start Goal = Label));
	retain Fmtname '@goalfmt' Type 'I'; * @ stands for INFORMAT, '@goalfmt'. Without it, 'goalfmt' is a FORMAT;
run;

proc format; *cntlin = Control;
	select @goalfmt;
run;

proc format cntlin = Control;
	select @goalfmt;
run;


