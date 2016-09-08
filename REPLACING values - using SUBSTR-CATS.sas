/*******************************************************************************/
/*** Replacing the first eight digits of a credit card number with asterisks ***/
/*******************************************************************************/

*CREDIT data set containing ID's and Credit card numbers,
 and phone numbers;
data credit;
   input ID :$3. Account : $12. Phone : $13.;
datalines;
001 1234567800001212 (908)232-2737
002 5411002233448882 (830)939-8877
003 8384001993746111 (830)838-6667
;

*Replacing the first 8 digits of a credit card number with asterisks;

*Using SUBSTRINGS and CONCATENATION functions;
data Credit_Report;
	length Last_Four $ 12;
	set Credit;
	Last_Four_9 = CATS('********', SUBSTR(Account,9)); * 9 means the substring postion. Position 9 is not included;
													   * Only positions on the left side of 9. In other words, positions < 9;
run;

*Using the SUBSTR function on the left-hand side of the equal sign data Credit_report;
data Credit_report;
	set Credit;
	Last_Four = Accounts;
	substr(Last_Four, 1,8) = '********';
run;
