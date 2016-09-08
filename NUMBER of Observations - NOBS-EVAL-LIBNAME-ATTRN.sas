/************************************************************************************/
/****** Determine the number of observations in a SAS data set with NOBS= SET *******/
/************************************************************************************/

data Stocks;
   do Date = '01jan2012'd to '28feb2012'd;
      input Price @@;
      if weekday(Date) not in (1 7) then output;
   end;
   format Date date9.;
datalines;
23 24 24 33 25 25 24 26 24 33 34 28 29 31 33 30
28 29 38 37 21 21 28 30 31 31 32 31 31 32 33
33 30 29 27 22 26 26 26 29 30 30 31 32 36 37 39 35 
35 34 33 32 31 31 33 34 35 37 33
;

*Determing the number of observations in a SAS data set;
*Using the SET option NOBS=;

data New;
	set Stocks nobs = Number_of_obs;
	if _n_ = 1 then
		put "The number of observations in data set STOCKS is: "
			Number_of_obs;
	How_Far = _n_ / Number_of_obs;
run;

*Placing the number of observations in a SAS data set into a macro variable;

data _null_;
	if 0 then set Stocks nobs = Number_of_obs;
	call symputx('N_of_obs', Number_of_obs);
	put "The number of observations in STOCK is &N_of_obs";
	stop;
run;



/************************************************************************************/
/**** Listing the last five observations in data set Stocks using MACRO and EVAL ****/
/************************************************************************************/

*Listing the last five observations in data set Stocks;
%let Start = %eval(&N_of_obs - 4);

data Last_Five;
	set Stocks(firstobs = &Start);
run;



