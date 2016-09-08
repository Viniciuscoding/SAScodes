/******************************************************************************/
/****************** Reading Data with User-Defined INFORMATS  *****************/
/******************************************************************************/



*Using PROC SORT to detect duplicate BY value;
proc sort data=Duplicates out=Sorted nodupkey;
	by Subj;
run;

