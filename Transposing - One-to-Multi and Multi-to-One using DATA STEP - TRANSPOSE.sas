/************************************************************************/
/**** Coverting a data set with one observation per subject into one ****/
/******** with multiple observations per subject using DATA STEP ********/
/************************************************************************/


data OnePer;
	input Subj : $3. Dx1 : 4. Dx2 : 4. Dx3 : 4.;
	*input Subj : $3. Dx1-Dx3 : 3.; *Fancier way to write the input code;
datalines;
001 450 430 410
002 250 240 .
003 410 250 500
004 240 . .
;

*One observation per subject to multiple observations per subject usinf DATA STEP;

data ManyPer;
	set OnePer;
	array Dx[3];
	do Visit = 1 to 3;
		if not missing(Dx[Visit]) then do;
			Diagnosis = Dx[Visit];
			output;
		end;
	end;
	keep Subj  Diagnosis  Visit;
run;



/************************************************************************/
/**** Coverting a data set with one observation per subject into one ****/
/******** with multiple observations per subject using TRANSPOSE ********/
/************************************************************************/

proc transpose data=OnePer out=One_to_Multi;
	by Subj; *The BY variable;
	var Dx1-Dx3; *The variables to be transposed;
run;

proc transpose data=OnePer out=One_to_Multi_TRANSPOSED  (rename = (col1 = Diagnosis)
														 drop = _name_
														 where = (Diagnosis is not null));
	by Subj;
	var Dx1-Dx3;
run;	



/************************************************************************/
/*** Coverting a data set with multiple observations per subject into ***/
/********* one with one observation per subject using TRANSPOSE *********/
/************************************************************************/

proc sort data=ManyPer; by Subj Visit; run;

data Multi_to_One;
	set ManyPer; *Data restructured from DATA STEP;
	by Subj;
	array Dx[3];
	retain Dx1-Dx3;
	if first.Subj then call missing(of Dx1-Dx3); *If 'of' is removed from the argument then
							 missing values will be exchanged by the previous values instead.
							 'of' ought to be included if missing values are to be included.;
	Dx[Visit] = Diagnosis;
	if last.Subj then output;
	keep Subj Dx1-Dx3;
run;

proc transpose data=ManyPer out=Multi_to_One_TRANSPOSED(drop=_name_)
	prefix=Dx;
	id Visit;
	by Subj;
	var Diagnosis; *Not necessary since Diagnosis is the left variable; 
				   *If there were more variables than var would be necessary;
run;
