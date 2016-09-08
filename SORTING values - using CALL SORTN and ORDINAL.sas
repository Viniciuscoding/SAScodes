/*******************************************************************************/
/**************** SORTING within an observation using CALL SORTN ***************/
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

*Does not keep the orignal data set table. Save the original table before using CALL SORTN;
data Ordered_Scores;
	set Scores;
	CALL SORTN(of Score1-Score10);
	*CALL SORTN(of Score _:); *Does not work the order correctly;
run;

/*******************************************************************************/
/************* SORTING within an observation using ORDINAL function ************/
/*******************************************************************************/

*Using ORDINAL;
*keep the original data set and add new columns to the sorted one;
data Ordered_Scores_stacked;
	set Scores;
	array Score[10];
	array Sorted[10];
	do i = 1 to 10;
		Sorted[i] = ordinal(i, of Score[*]);
	end;
	drop i;
run;



