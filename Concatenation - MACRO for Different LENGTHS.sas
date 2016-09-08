/******************************************************************************************/
/* Writing out a SAS program to an external file with char variables of different lengths */
/******************************************************************************************/

data Name1;
	input Name : $12. Gender : $1. Age : best2. Height : best2. Weight : best3.;
datalines;
Horvath F 63 64 130
Chien M 28 65 122
Hanbicki F 72 62 240
Morgan F 71 66 160
;
run;

data Name2;
	input Name : $12. Gender : $1. Age : best2. Height : best2. Weight : best3.;
datalines;
Snow M 51 76 240
Hillary F 35 69 155
;
run;

data Name3;
	input Name : $16. Gender : $1. Age : best2. Height : best2. Weight : best3.;
datalines;
Zemlachenko M 55 72 220
Reardon M 27 75 180
;
run;

proc contents data=Name2 noprint 
	out=Out1(keep=Name Type Length where=(Type=2));
run;

proc contents data=Name3 noprint
	out=Out2(keep=Name Type Length where=(Type=2));
run;

*Using a DATA step to write out a SAS program to an external file;

data _null_;
	merge Out1
		  Out2(rename=(Length = Length2));
		  end=last;
	by Name;
	file "C:\SAS Books' Sample Code and Data\External Files\Combined.sas";

* Step 1;
	if _n_ = 1 then put "Data Combined;";

* Step 2;
	L = max(Length, Length2);

* Step 3;
	put "    length " Name " $ " L 3. ";";

* Step 4;
	if Last then do;
		put "   set Name1 Name2;";
		put "run;";
	end;
run;

* Step 5;
%include "C:\SAS Books' Sample Code and Data\External Files\Combined.sas";



/**************************************************************************************/
/* MACRO to CONCATENATE 2 SAS data sets with character variables of different lengths */
/**************************************************************************************/

%macro Concatenate (Dsn1=,		/*Name of the first data set	*/
	 				Dsn2=,		/*Name of the second data set	*/
	 				Out=		/*Name of combined data set		*/);

	proc contents data=&Dsn1 noprint
	 	out=out1(keep=Name Type Length where=(Type=2));
	run;

	proc contents data=&Dsn2 noprint
		out=out2(keep=Name Type=Length where=(Type=2));
	run;

	data out1;
		set out1;
		Name = propcase(Name);
	run;

	data out2;
		set out2;
		Name = propcase(Name);
	run;

	data _null_;
		file "C:\SAS Books' Sample Code and Data\External Files\CombinedMACRO.sas"; *Writing a DATA statement to an external file;
		merge out1 out2(rename=(Length=Length2)) end=last; 
		by Name;
		if _n_ = 1 then put "Data &out;";
		L = max(Length,Length2);
		put "  length " Name " $ " L 2. ";";
		if last then do;
			put "  set &Dsn1 &Dsn2;";
			put "run;";
		end;
	run;

	%include "C:\SAS Books' Sample Code and Data\External Files\CombinedMACRO.sas";

%mend concatenate;

* Testing the Concatenate macro;

%Concatenate(Dsn1=Name2, Dsn2=Name3, out=CombinedMACRO)

title "Contents of COMBINED";
proc contents data=CombinedMACRO;
run;

