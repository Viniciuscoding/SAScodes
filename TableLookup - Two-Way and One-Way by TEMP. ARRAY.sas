/************************************************************************/
/******** Performing a ONE-WAY TABLE LOOKUP using TEMPORARY ARRAY *******/
/************************************************************************/

*Data set GOALS, containing the sales goals for the years 2004 through 2012;
data Goals;
   do Year = 2004 to 2012;
      input Goal @;
      output;
   end;
datalines;
20 21 24 28 34 40 49 60 75
;

*Load a temporary with the Goals data;
data Array_Sales_Goals;
	array Goalsarray[2004:2012] _temporary_;
	if _n_ = 1 then do Year = 2004 to 2012;
		set Goals;
		Goalsarray[Year] = Goal;
	end;

	set Sales;
	Difference = Sales - Goalsarray[Year];
run;



/************************************************************************/
/******** Performing a TWO-WAY TABLE LOOKUP using TEMPORARY ARRAY *******/
/************************************************************************/

*Data set GOALS_JOB, containing the sales goals for the years
 2004 through 2012 for each of 4 job categories;
data Goals_Job;
   do Year = 2004 to 2012;
      do Job = 1 to 4;
         input Goal @;
         output;
      end;
   end;
datalines;
20 21 24 28 34 40 49 60 75
21 22 25 30 40 45 55 67 82
24 27 29 37 45 51 62 74 90
30 38 40 47 53 60 70 80 99
;

*Data set Sales_Job, containing the sales figures(in thousands) for each salesperson;
data Sales_Job;   
   input Sales_ID $  Job @;
   do Year = 2004 to 2012;
      input Sales @;
      output;
   end;
datalines;
1234 1 20.5 22 26 27 37 45 55 61 72
7477 2 18 18 17 23 33 44 55 66 65
4343 4 20.1 21.1 24.3 28.8 34.8 40.9 51.0 62 80
9988 3 16 17 18 22 34 44 58 75 88
;


*TWO-WAY table lookup using temporary arrays;
data Two_Way;
	array Goals_Job[2004:2012,4] _temporary_;
	if _n_ = 1 then 
	do Year = 2004 to 2012;
		do Job = 1 to 4;
			set Goals_Job;
			Goals_Job[Year, Job] = Goal;
		end;
	end;

	set Sales_Job;
	drop Goal Job;
	Difference = Sales - Goals_Job[Year,Job];
run;