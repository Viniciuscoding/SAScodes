/******************************************************************************/
/******************************* CHARACTER CONVERSION *************************/
/******************************************************************************/


data Char_Values;
	input Age : $3. Weight : $3. Gender : $1. DOB : mmddyy10.;
	format DOB mmddyy10.;
datalines;
23 150 M 10/21/1983
67 220 M 09/12/2001
77 101 F 05/06/1977
;

data Num_Values;
	set Char_Values (rename=(Age = C_Age
							 Weight = C_Weight));
	Age = input(C_Age, best12.);
	Weight = input(C_Weight, best12.);
	drop C_:; *drop all variables that begin with C_;
run;


/******************************************************************************/
/******************** CHARACTER CONVERSION USING A MACRO **********************/
/******************************************************************************/

* Macro to convert selected character variables to numeric variables;

%macro char_to_num(In_dsn=,		/*Name of the input data set*/
				   Out_dsn=,	/*Name of the output data set*/
				   Var_list= );	/*List of character variables that you want to
				   				convert*/

/* Check for null var list */
	%if &var_list ne %then %do;
/* Count the number of variables in the */
	%let n=%sysfunc(countw(&var_list)); /* COUNTW function: computes the number of words in a string */

	data &Out_dsn;
		set &In_dsn (rename= (
		%do i = 1 %to &n; /* Used to extract each of the individual variable names */
		%let Var = %scan(&Var_list, &i);  /* Break up list into variable names */
		&Var = C_&Var /* Rename each variable name to C_ variable name */
		%end;
		));
		%do i = 1 %to &n;
			/* Break up list into variable names */
			%let Var = %scan(&Var_list, &i); /* SCAN function: obtain each of the variable names */ 
			&Var = input(C_&Var,best12.); /* Convert every character variable to number */
    	%end;
		drop C_:; /*Drop the variables that begins with C_: */
	run;
	%end;

%mend char_to_num;
* TESTING THE CHARACTER-TO-NUMERIC CONVERSION MACRO;
%char_to_num(In_dsn=Char_Values, Out_dsn=Macro_Num_Values, Var_list=Age Weight)

