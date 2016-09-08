/**********************************************************************************/
/******** CONCATENATION of 2 SAS data sets with different lengths by FORCE ********/
/**********************************************************************************/

data Name1;
	input Name : $12. Gender : $1. Age : best2. Height : best2. Weight : best3.;
datalines;
Horvath F 63 64 130
Chien M 28 65 122
Hanbicki F 72 62 240
Morgan F 71 66 160
;
run;

data Name2;
	input Name : $12. Gender : $1. Age : best2. Height : best2. Weight : best3.;
datalines;
Snow M 51 76 240
Hillary F 35 69 155
;
run;

data Name3;
	input Name : $16. Gender : $1. Age : best2. Height : best2. Weight : best3.;
datalines;
Zemlachenko M 55 72 220
Reardon M 27 75 180
;
run;

*APPENDING by FORCE;
proc append base=Name1 data= Name3 force; run;



/**********************************************************************************/
/*** CONCATENATION of 2 SAS data sets with different lengths by SET with LENGTH ***/
/**********************************************************************************/

Data Combined_LENGTH;
	length Name $18 Gender $2;
	set Name2 Name3;
run;