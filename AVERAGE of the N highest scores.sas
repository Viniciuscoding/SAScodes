/*******************************************************************************/
/*************** Computing the AVERAGE of the 'n' HIGHEST SCORES ***************/
/*******************************************************************************/

*Scores data set;
data Scores;
   input Name : $ Score1-score10;
datalines;
John 95 92 87 100 96 88 89 78 02 95
Mary 98 96 93 89 95 95 94 . . 99
Sarpal 87 84 87 88 80 . 81 78 77 92
Sophie 78 79 81 82 84 85 86 88 90 95
;

*Sorting within an observation: Using CALL SORTN;
data Ordered_Scores;
	set Scores;
	call sortn(of Score1-Score10); /*ASCENDING order*/
   /******************************************/
   /**/	Average = mean(of Score3-Score10); /**/
   /******************************************/
run;

data Ordered_Scores_Descending;
	set Scores;
	call sortn(of Score10-Score1); /*DESCENDING order*/
   /******************************************/
   /**/	Average = mean(of Score1-Score8);  /**/
   /******************************************/
run;




