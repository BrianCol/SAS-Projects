*midterm project section 3 10am class;

%macro midterm(form);

data Key(keep=ID Ans i) Student(keep=ID StuAns i);
	infile "/folders/myfolders/Stat224/Midterm/Form &form.1.csv" dlm="," dsd missover;
	input ID $ blank (q1-q150) ($);
	array Q{150} $ q1-q150;
	if ID = "&form.&form.&form.&form.KEY" then do i = 1 to 150;
		Ans = Q{i};
		output Key;
	end;
	else do i = 1 to 150;
		StuAns = Q{i};
		output Student;
	end;
run;

proc sql;
	create table combined&form. as
	select Student.ID as StudentID,  
		sum(case when Ans=StuAns then 1 else 0 end) as Score,
		round(Calculated Score/150, .01) as Perc
	from Key, Student
	where Key.i=Student.i
	group by Student.ID
	;
quit;

*read in domains;
data Domains;
	infile "/folders/myfolders/Stat224/Midterm/Domains Form &form..csv" dlm="," dsd missover firstobs=2;
	input ItemID Domain $ DomainNum;
run;

proc sql;
	create table Domain&form. as
	select Student.ID as StudentID, Domains.DomainNum as DomainNum,  
		sum(case when Ans=StuAns then 1 else 0 end) as Score,
		round(Calculated Score/150, .01) as Perc
	from Key, Student, Domains
	where Key.i=Student.i
	group by Student.ID, Domains.DomainNum
	;
quit;

*another SQL similar to above, but from key,student,domains
and group by Student.ID,DomainNum;

%mend Midterm;

%Midterm(A);
%Midterm(B);
%Midterm(C);
%Midterm(D);

Proc SQL;
	create table overall as
	select *
	from combinedA
	union all
	select *
	from combinedB
	union all
	select *
	from combinedC
	union all
	select *
	from combinedD
	;
quit;

*alternatively using the data step;

data overall;
	set combinedA combinedB combinedC combinedD;
run;

*overall class average;
proc SQL;
	create table summary as
	select
	avg(score) as classavg,
	avg(perc) as classperc
	from overall
	;
quit;



/* %mend Midterm; */
/*  */
/* %Midterm(A); */
/* %Midterm(B); */
/* %Midterm(C); */
/* %Midterm(D); */

*Domains;
Proc SQL;
	create table overall_Domains as
	select *
	from DomainA
	union all
	select *
	from DomainB
	union all
	select *
	from DomainC
	union all
	select *
	from DomainD
	;
quit;

*alternatively using the data step;

data overall_Domains;
	set DomainA DomainB DomainC DomainD;
run;

*overall class average;
proc SQL;
	create table summary_Domains as
	select
	avg(score) as classavg,
	avg(perc) as classperc
	from overall_Domains
	;
quit;

