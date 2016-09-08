/******************************************************************************/
/**** Using SAS data set to create a format by creating a CONTROL data set ****/
/******************************************************************************/

data Codes;
	input ICD9 : $5. Description & $25.; *I used best3. for ICD9 but it did not return fomartted value;
datalines;
020 Plague
022 Anthrax
390 Rheumatic fever
410 Myocardial infarction
493 Asthma
540 Appendicitis
;
run;

*Program to create a control data set from SAS data set;
data Control;
	set Codes(rename=(ICD9 = Start Description = Label));
	retain Fmtname '$ICDFMT' Type 'C';
run;

*Using a control data set to create a format;
proc format cntlin=Control;
	select $ICDFMT;
run;

*Using the CNTLIN= created data set;
data disease;
	input ICD9 : $5. @@;
datalines;
020 410 500 493
;
title "Listing of DISEASE";
proc report data=disease nowd headline;
	columns ICD9=Unformatted ICD9;
	define ICD9 / "Formatted Value" width=11 format= $ICDFMT.;
	define Unformatted / "Original Unformatted Value" width=11;
run;



/******************************************************************************/
/**** Using SAS data set to create a format by creating a CONTROL data set ****/
/***************** Adding and OTHER category to your format *******************/
/******************************************************************************/

data control;
	set Codes(rename=(ICD9 = Start Description = Label)) end=last;
	retain Fmtname '$ICDFMT' Type 'C';
	output;
	if last then do;
		HLO = 'o'; *o = OTHER;
		Label = 'Not Found';
		output;
	end;
run;

title "Adding OTHER Category";
proc format cntlin=Control;
	select $ICDFMT;
run;



