/************************************************************************************/
/**** Determine the number of observations in a SAS data set using LIBRARY TABLES ***/
/************************************************************************************/

*Method using library tables;
data _null_;
	set sashelp.vtable;
	where libname="WORK" and memname="STOCKS";
	***Note: you must use uppercase values for libname and memname;
	Num_obs = Nobs - Delobs;   *Nobs = total number of observations
	   							Delob = Number of delete observations;
	put "Nobs - Delobs: num_obs = " num_obs;
run;
	


/************************************************************************************/
/**** Determine the number of observations in a SAS data set using SAS functions ****/
/************************************************************************************/

data _null_;
	Exist = EXIST("stocks");
	if Exist then do;
		Dsid = OPEN("Stocks");
		Num_obs = ATTRN(Dsid, "Nlobs");
		*Nlobs is the number of logical observations not marked for deleting;
		put "Number of observations in STOCK is: " Num_obs;
	end;
	else put "Data set STOCKS does not exist";
	RC = CLOSE(Dsis);
run;

