/************************************************************************/
/**** Updating a SAS data set using a TRANSACTION data set by UPDATE ****/
/************************************************************************/

data Hardware;
	input @1 Item_Number : best4.
		  @5 Description $25.
		  @30 Price;
	format Price dollar16.2;
datalines;
1238 Cross Cut Saw 18 inch    18.75
1122 Cross Cut Saw 24 inch    23.95
2001 Nails, 10 penny          5.57
2002 Nails, 8 penny           4.59
3003 Pliers, Needle nose      12.98
3035 Pliers, cutting          15.99
4005 Hammer, 6 pound          12.98
4006 Hammer, 8 pound          15.98
4007 Hammer, sledge           19.98
;
run;

*UPDATING a master file with data from transaction file;

data New_Prices;
	input Item_Number : best4. Price;
datalines;
2002 5.98
4006 16.98
;
run;

proc sort data=Hardware; by Item_Number; run;
proc sort data=New_Prices; by Item_Number; run;

data Hardware_June2012;
	update Hardware New_Prices;
	by Item_Number;
run;




/************************************************************************/
/**** Updating a SAS data set using a TRANSACTION data set by MODIFY ****/
/************************************************************************/

proc sort data=Hardware out=Hardware_Modify; by Item_Number; run;

data Hardware_Modify;
	modify Hardware_Modify New_Prices;
	by Item_Number;
run;




/************************************************************************/
/* Updating several variables using TRANSACTION files with INPUT method */
/************************************************************************/

data Demographic;
   call streaminit(374354);
   do Subj = 1 to 20;
      if rand('uniform') ge .1 then Score = ceil(rand('uniform')*100);
      else Score = 999;
      if rand('uniform') ge .1 then Weight = ceil(rand('normal',150,30));
      else Weight = 999;
      if rand('uniform') ge .1 then Heart_Rate = ceil(rand('normal',70,10));
      else Heart_Rate = 999;
      DOB = -3652 + ceil(rand('uniform')*2190);
      if rand('uniform') gt .5 then Gender = 'Female';
      else Gender = 'Male';
      if rand('uniform') lt .2 then Gender = 'NA';
      if rand('uniform') ge .8 then Gender = lowcase(Gender);
      if rand('uniform') gt .6 then Party = 'Republican';
      else Party = 'Democrat';
      if rand('uniform') lt .2 then Party = 'NA';
      if rand('uniform') gt .5 then Party = lowcase(Party);
      output;
   end;
   format DOB date9.;
run;

*Using named input to create the transaction data set;

*Changing Score to 72 and Party to Republican in Subject 2
 Changing DOB to 26NOV1951 and Weight=140 in Subject 7;
data New_Values;
	informat Gender $6. Party $10. DOB Date9.;
	input Subj= Score= Weight= Heart_Rate= DOB= Gender= Party=;
	format DOB date9.;
datalines;
Subj=2 Score=72 Party=Republican
Subj=7 DOB=26NOV1951 Weight=140
;
run;

proc sort data=Demographic; by Subj; run;
proc sort data=New_Values; by Subj; run;

data Demographic_June2012;
	update Demographic New_Values;
	by Subj;
run;