/******************************************************************************/
/**** IDENTIFYING observations with exactly 'N' OBSERVATIONS per subject  *****/
/******************************************************************************/

data TwoRecords;
	input Subj : 3. Weight : 3.;
datalines;
001 200
001 190
002 155
002 157
003 123
004 220
004 221
004 210
005 111
005 112
;

proc sort data=TwoRecords;
	by Subj;
run;

data Not_Two;
	set TwoRecords;
	by Subj;
	if First.Subj then n=0;
	n + 1;
	if Last.Subj and n ne 2 then output;
run;

