/*Output as pdf file */
ods pdf file = "/folders/myfolders/HW124/HW7/hw7.pdf";
options nodate nonumber;

/*Import excel file into SAS as work.employees  */
proc import datafile = "/folders/myfolders/HW124/HW7/employees.xlsx" dbms=xlsx
	out = work.employees replace;
run;

/*Import excel file into SAS as work.employees_sales  */
proc import datafile = "/folders/myfolders/HW124/HW7/employees_sales.xlsx" dbms = xlsx
	out = work.employees_sales replace;
run;

/*Import excel file into SAS as work.player_salaries */
proc import datafile = "/folders/myfolders/HW124/HW7/MLBPlayerSalaries.xlsx" dbms = xlsx
	out = work.player_salaries replace;
run;

/*Part 1  */
/*Merge the two tables (employees and employees_sales)  */
proc sql; 
	create table salesmerged as
	select employees.Name, Position, Sales format =dollar14., Month, Year 
	from  employees inner join employees_sales
	on employees.Name = employees_sales.Name
	where year = 2017;
run;

/*Print merged employees and employees_sales table  */
title "Employee and Sales Information Merged"; 
proc print data = salesmerged noobs;
run;

/*Part 2  */
/*Calculate the total annual sales for each employee in salesmerged  */
title "Total Annual Sales for each Sales Representative";
proc means data = salesmerged nonobs sum noprint;
	class Name Position;
	var sales;
	ways 2;
	output out = totalsales (Drop = _type_ _freq_) sum = employee_sum;
	format sales dollar14.;
	label employee_sum = "Total Sales";
run;

/*Print total annual sales for each employee in salesmerged  */
proc print data = totalsales noobs label;
run;

/*Part 3  */
/*Sort totalsales by sales from highest to lowest  */
title "Total Annual Sales for each Sales Representative Sorted by Sales";
proc sql;
	select name, position, employee_sum format = dollar14.
	from totalsales
	order by employee_sum desc;
run;

/*Part 4  */
/*Display the top ten salaries for designated hitters  */
title "Total Annual Sales for each Sales Representative Sorted by Sales";
proc sql outobs=10;;
	select Player, Year, Salary format = dollar14., Position, Team
	from player_salaries
	where position = "Designated Hitter"
	order by salary desc;	
run;

/*Part 5  */
/*End of pdf file*/
ods pdf close;



