/******************************************************************************/
/****** READING A NUMERIC VALUE THAT CONTAINS UNITS SUCH AS LBs. OR KGs. ******/
/******************************************************************************/

data Units;
	input @1 Subj $3.
		  @5 Weight $8.
		  @13 Height $10.;
datalines;
001 80kgs   5ft 3in
002 190lbs  6' 11
003 70KG.   5ft 11in
004 177LbS. 5' 11"
005 100kgs  6ft
;
run;


*MODIFIERS used:'kd'  = keep digits
				'kds' = keep digits and space characters
				'i'   = ignore case;
data No_Units;
	set Units;
	*Using COMPRESS function to extract digits from Weight;
	Weight_lbs = input(compress(Weight,,'kd'), 12.);											 
		*INPUT: Converts the result of COMPRESS, a character, to a numeric value;
    	*COMPRESS: Specifies which determined characters will be removed;
	*IMPORTANT: MODIFIER -> 'kd' = keep digits
				(,,) = Double commas are used to interpret 'kd' as MODIFIER rather than a second argument in COMPRESS;
	*If you find k or K then multiply it by 2.2(kg to lbs);
	if findc(Weight, 'k', 'i') then Weight_lbs = Weight_lbs * 2.2; * MODIFIER 'i' = ignores case;
	Height = compress(Height,, 'kds');
		*MODIFIER 'kds' = keed digits and space characters;
	Feet = input(scan(Height, 1, ' '), 12.); *Used to extract the feet values;
	Inches = input(scan(Height, 2, ' '), 12.); *Used to extract the inch values;
		*IMPORTANT: SCAN function returns a MISSING VALUE for Inches if Height only contains a single number(feet);
	if missing(Inches) then Inches = 0;
	Height_Inches = 12 * Feet + Inches; *Conversion from Feet to Inches, multiply feet by 12;
	drop Feet Inches;
run;


/******************************** USING PERL **********************************/

data Perl_No_Units;
	set Units(drop=Height);
	if _n_ = 1 then do;
		Regex = "/^(\d+)(\D)/";
		re = prxparse(Regex);
	end;
	retain re;
	if prxmatch(re, Weight) then do;
		Weight_lbs = input(prxposn(re, 1, Weight), 8.);
		Units = prxposn(re, 2, Weight);
		if upcase(Units) = 'K' then Weight_lbs = Weight_lbs * 2.2;
	end;
	keep Subj Weight Weight_lbs;
run;

/************************************* END *************************************/