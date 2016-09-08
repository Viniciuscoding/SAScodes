/************************************************************************************/
/** Computing DIFFERENCES between observations using DIF and LAG(for each subject) **/
/************************************************************************************/

data Visits;
	input Patient : 3. Visit : 1. Weight 3.;
datalines;
001 1 120
001 2 124
001 3 124
002 1 200
003 1 310
003 2 305
003 3 298
003 3 290
004 1 160
004 2 162
;

*Computing inter-patient differences;
******* LAG and DIF functions to compute differences *******;
proc sort data=Visits; by patient; run;

data Difference;
	set Visits;
	by Patient;
	Diff_Wt = Weight - LAG(Weight);
	Diff_Weight = DIF(Weight);
	if not first.Patient then output;
run;



/************************************************************************************/
/********** Computing DIFFERENCES between the first and last observations ***********/
/************************************************************************************/

*Computing the differences between the first and last visit;
proc sort data = Visits; by Patient Visit; run;

data First_Last;
	set Visits;
	by Patient;
	if first.Patient and last.Patient then delete; *Delete observations where only one visit;
	retain First_Wt;
	if first.Patient then First_Wt = Weight;
	if last.Patient then do;
		Diff_Wt = Weight - First_Wt;
		output;
	end;
run;

*Redoing the previous program using the LAG function;
data First_Last_LAG;
	set Visits;
	by Patient;
	if first.Patient and last.Patient then delete; *Delete observations where only one visit;
	if first.Patient or last.Patient then Diff_Wt = Weight - LAG(Weight);
	if last.Patient then output;
run;


