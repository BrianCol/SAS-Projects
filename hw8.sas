/*Output as pdf file */
ods pdf file = "/folders/myfolders/HW124/HW8/hw8.pdf";
options nodate nonumber;

/*Open excel file into SAS*/
proc import datafile = "/folders/myfolders/HW124/HW8/Hotels.xlsx" dbms=xlsx
	out = work.hotels replace;
run;

/*Part 1  */
/*Calculate the "peak-season" pricing by increasing all expenses by 25%  */
data hotelsoffpeak;
	set work.hotels;
	array offpeak(*) Expense1 Expense2 Expense3 Expense4 Expense5 Expense6;
	do i = 1 to dim(offpeak);
		offpeak(i) = offpeak(i) * 1.25;
	end;
	format Expense1-Expense6 dollar10.2;
	drop i;
run;

/*Print hotelsoffpeak data table  */
title "Peak Season Resort Pricing";
proc print data = hotelsoffpeak noobs;
run;

/*Part 2  */
/*Restructure the work.tables table from "wide" to "long" format  */
title "Restructure Data from Wide to Long format";
data widehotels;
	set work.hotels;
	array expense(*) Expense1 - Expense6;
	do ExpenseID = 1 to dim(expense);
		expense_wide = expense(expenseID);
		output;
	end; 
	format expense_wide dollar10.2;
	keep Resort ExpenseID expense_wide;
	label expense_wide = "Expenses";
run;

/*Print widehotels data table  */
proc print data = widehotels noobs label;
run;

/*Part 3  */
/*Restructure the table widehotels from "long" to "wide" format  */
data longhotels;
	set widehotels;
	array expense(*) Expense1 - Expense6;
	retain Expense1 - Expense6;
	by Resort;
	if first.Resort then i = 0;
	i + 1;
	expense(i) = expense_wide;
	if last.Resort then output;
	format Expense1 - Expense6 dollar14.2;
	drop i expense_wide ExpenseID;
run;

/*Print longhotels data table  */
title "Restructure Data from Long to Wide format";
proc print data = longhotels noobs;
run;

/*Part 4  */
/*End of pdf file*/
ods pdf close;
	