data rainfall;
	input year amount;
	datalines;
	2010 3.9
	2011 2.1
	2012 3.6
	2013 4.3
	2014 1.8
	2015 5.2
	2016 3.5
	2017 4.4
	2018 3.2
	;
run;

proc boxplot data=rainfall;
	plot amount;
	label amount = "Total Rainfall this Decade";
run;

proc boxplot data=rainfall;
	plot amount*year;
	label amount = "Total Annual Rainfall";
run;

data rainfall2;
	set rainfall;
	group = 1;
run;

proc print data=rainfall2;
run;

proc boxplot data=rainfall2;
	plot amount*group;
	label amount = "Total Annual Rainfall";
run;

*Bar Graph;
*Needs Groups;

data rainfall3;
	set rainfall;
	if amount < 2 then group="little";
	else if amount < 4 then group="avg";
	else group="high";
run;

proc sgchart data=rainfall3;
	vbar group / discrete type=percent;
run;
