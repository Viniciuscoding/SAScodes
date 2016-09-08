/***********************************************************************************/
/** Counting the number of a specific response in a list of variables using ARRAY **/
/***********************************************************************************/

data Questionnaire;
   input Subj (Q1-Q5)(: $1.);
datalines;
1 y y n n y
2 N N n   Y
3 N n n n n
4 y Y n N y
5 y y y y y
;

data Count_YN;
	set Questionnaire;
	array Q[5];
	Num_Y = 0;
	Num_N = 0;
	do i = 1 to 5;
		if upcase(Q[i]) eq 'Y' then Num_Y + 1;
		else if upcase(Q[i]) eq 'N' then Num_N + 1;
	end;
	drop i;
run;


/******************************************************************************************/
/* Counting the number of specific responses in a list of variables using CATS and COUNTN */  
/******************************************************************************************/

data Counting_YN;
	set Questionnaire;
	Num_Y = countc(cats(of Q1-Q5), 'Y','i');
	Num_N = countc(cats(of Q1-Q5), 'N','i');
run;


