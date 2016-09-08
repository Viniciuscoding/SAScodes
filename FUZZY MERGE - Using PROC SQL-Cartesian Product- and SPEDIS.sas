/***********************************************************************************/
/** FUZZY MERGE - Matching 2 SAS data sets with different spelled names by SPEDIS **/
/** Using PROC SQL step to create a CARTESIAN PRODUCT between the 2 SAS data sets **/
/***********************************************************************************/

data Name_One;
	input Name1 : $12. DOB1 : date10. Gender1 $1.;
datalines;
Friedman 14JUL1946 M
Chien 21OCT1965 F
MacDonald 12FEB2001 M
Fitzgerald 04AUG1966 M
GREGORY 05FEB1955 F
;
run;

data Name_Two;
	input Name2 : $12. DOB2 : date10. Gender2 $1.;
datalines;
Freidman 14JUL1946 M
Chen 21OCT1965 F
McDonald 12FEB2001 M
Fitzgerald 04AUG1966 M
Gregory 05FEB1955 F
;
run;

*CARTESIAN PRODUCT: PROC SQL code that creates a list of possible or exact matches;
proc sql; *A code that creates a list of possible matches and excat matchesa CARTESIAN PRODUCT;
	create table Possible_Matches as
	select * from Name_One, Name_Two
	where SPEDIS(upcase(Name1),upcase(Name2)) between 1 and 25 and 
	DOB1 eq DOB2 and
	Gender1 eq Gender2;
quit;

*WHERE clause: selects all observations in the Cartesian product data set where
		the two names are within a spelling of 25(SPEDIS);
*SPEDIS function: stands for spelling distance. It helps to determine words that
 		 have similar spelling but are not exact match. 1 to 25 means a
		 spelling distance of 25 characters while 0 (MEANS an EXACT MATCH);
	*IMPORTANT: upcase is used on both data sets in SPEDIS to match names
				that are not in the same case; 

proc sql;
	create table Exact_Matches as
	select * from Name_One, Name_Two
	where SPEDIS(upcase(Name1), upcase(Name2)) eq 0 and
	DOB1 eq DOB2 and
	Gender1 eq Gender2;
quit;
