/**********************************************************************************/
/************** CONCATENATION of 2 SAS data sets using SET statement  *************/
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

/*proc contents data=Name1; run;*/

*Concatenating SAS data sets using a SET statement;
data Combined;
	set Name1 Name2;
run;



/**********************************************************************************/
/************ CONCATENATION of 2 SAS data sets using APPEND statement  ************/
/**********************************************************************************/

data Name1_1;
	input Name : $12. Gender : $1. Age : best2. Height : best2. Weight : best3.;
datalines;
Horvath F 63 64 130
Chien M 28 65 122
Hanbicki F 72 62 240
Morgan F 71 66 160
;
run;

data Name2_1;
	input Name : $12. Gender : $1. Age : best2. Height : best2. Weight : best3.;
datalines;
Snow M 51 76 240
Hillary F 35 69 155
;
run;

*Name1_1 will go from 4 to 6 observations;
proc append base=Name1_1 data=Name2_1; run;
	 