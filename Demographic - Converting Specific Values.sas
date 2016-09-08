

/******************************************************************************/
/*** CONVERTING SPECIFIC VALUES TO MISSING VALUES FOR ALL NUMERIC VARIABLES ***/
/******************************************************************************/

data Demographic;
	input Subj : $2. Score : best12. Weight : Best12. Heart_Rate : best12. 
		  DOB : anydtdte10. Gender : $10. Party : $12.;
	format DOB date10.;
datalines;
1 70 999 76 04NOV1955 Male NA
2 26 160 62 08APR1955 NA NA
3 71 195 71 20JUL1955 male na
4 40 132 74 08JAN1955 Male Republican
5 999 181 62 15AUG1951 Female Democrat
6 62 71 52 24JAN1950 Male democrat
7 24 136 72 26NOV1950 Female democrat
8 5 174 71 08NOV1950 Female democrat
9 5 172 47 28DEC1951 Male Democrat
10 94 173 999 06MAY1953 Male republican
11 99 170 63 27FEB1950 na NA
12 10 133 63 18MAR1954 Male democrat
13 6 131 60 26MAR1951 Female republican
14 999 140 79 01OCT1950 NA na
15 999 124 999 12OCT1950 NA na
16 44 194 72 31DEC1952 Female republican
17 62 196 68 09MAR1951 Female democrat
18 57 133 72 15SEP1951 Female Democrat
19 45 137 86 16NOV1951 NA Republican
20 90 170 80 01OCT1951 Female Republican

run;

*Finding and converting numeric values and characters;

data Num_missing;
	set Demographic;
	array Nums[*] _numeric_; *Array of numeric values;
	do i = 1 to dim(Nums); *Creates an array with all numeric variables from Demographic;
		if Nums[i] = 999 then Nums[i] = ".";
	end;
	drop i;
run;



/******************************************************************************/
/** CONVERTING SPECIFIC VALUES TO MISSING VALUES FOR ALL CHARACTER VARIABLES **/
/******************************************************************************/

data Char_missing;
	set Demographic;
	array Chars[*] _character_; *Array of character values;
	do j = 1 to dim(Chars); *Creates an array with all character variables from Demographic;
		if Chars[j] = 'NA' or Chars[j] = 'na' then Chars[j] = '.';
	end;
	drop j;

	*Fancier character code;
	array Cool[*] _character_; *Array of character values;
	do k = 1 to dim(Cool); *Creates an array with all character variables from Demographic;
		if Cool[k] in ('NA', 'na') then Cool[k] = '.';
	end;
	drop k;
run;



/******************************************************************************/
/************** CONVERTING ALL CHARACTER VARIABLES TO UPPERCASE ***************/
/******************************************************************************/

data Upper;
	set Demographic;
	array UpKse[*] _character_;
	do l = 1 to dim(UpKse);
		UpKse[l] = upcase(UpKse[l]);
	end;
	drop l;
run;

