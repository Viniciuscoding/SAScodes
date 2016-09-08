/******************************************************************************/
/************************** Computing a MOVING AVERAGE ************************/
/******************************************************************************/

data stocks;
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

* MOVING AVERAGE;

data Moving;
	set Stocks;
	Last = lag(Price);
	Twoback = lag2(Price);
	if _n_ ge 3 then Moving = mean(of Price, Last, Twoback);
run;

title "Plots of Stock Price and Three Day Moving Average";
proc sgplot data = moving;
	series x=Date y=Price;
	series x=Date y=Moving;
run;

/******************************************************************************/
/********************* MACRO for MOVING AVERAGE computation *******************/
/******************************************************************************/

%macro Moving_ave(In_dsn=,		/*Input data set name						*/
				  Out_dsn=,		/*Output data set name						*/
				  Var=,			/*Variable on which to compute the average  */
				  Moving=, 		/*Variable for moving average				*/
				  n= );			/*Number of observations on which to compute
				  				  the average								*/
	data &Out_dsn;
		set &In_dsn;
***Compute the lags;
		_x1 = &Var;
		%do i = 1 %to &n - 1;
			%let Num = %eval(&i + 1);
		 	 _x&Num = lag&i(&Var);
		%end;
	
***If the observation number is greater than or equal to the number
   of values needed for the moving average, output;
	if _n_ ge &n then do;
		&Moving = mean (of _x1 - _x&n);
		output;
	end;
	drop _x: ;
	run;
%mend Moving_ave;

*Testing the macro;
%moving_Ave(In_dsn = Stocks,
			Out_dsn = Moving_stocks,
			Var = Price,
			Moving = Average,
			n = 5)


 


