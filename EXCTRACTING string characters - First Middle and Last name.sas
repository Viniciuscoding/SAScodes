/*******************************************************************************/
/*************** Computing the AVERAGE of the 'n' HIGHEST SCORES ***************/
/*******************************************************************************/

*Data set Full_Name to demonstrate how to extract first, middle, and last names
 from a single variable;
data Full_Name;
   input @1 Name $30.;
datalines;
Jane Ireland
Ronald P. Cody
Robert Louis Stevenson
Daniel Friedman
Louis H. Horvath
Mary Williams
;

*SUPER IMPORTANT!!! MUCH MORE EFFICIENT THAN EXCEL!!!!;
Data Separate;
	set Full_Name;
	First = SCAN(Name, 1, ' '); *Look for the first word from left-to-right(positive integers e.x. 1);
	Last = SCAN(Name, -1, ' '); *Look for the first word from right-to-left(negative integers e.x. -1); 
	Middle = SCAN(Name, 2, ' '); *Look for the second word from left-to-right;
	if MISSING(SCAN(Name, 3)) then Middle = ' '; *Look for the third word from left-to-right. If missing
												  the third word, the Middle name which is the same as the Last name
												  due to the missing last word is set to empty and only Last word
												  will have saved the second name(2nd name from left-to-right = 1st name from
												  right-to-left);
run;




