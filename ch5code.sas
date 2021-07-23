proc sql;
	/* Create an empty table */
	create table empty (a num, b char, c double precision);
	select * from empty;
	describe table empty;

	/* Create an empty table like another table */
	select * from sashelp.air;
	create table empty2 like sashelp.air;
	describe table empty2;

	/* Create a table from a query result */
	create table filled as select * from sashelp.air;
	select * from filled;

	/* insert */
	create table ex like empty;
	insert into ex set a=1, b='first', c=1 set a=2;
	insert into ex values (3,'three',3);
	insert into ex values (4,5);
	insert into ex (a,c) values(5,5); 
	select * from ex;

	/* update */
	update ex set c = sum(100,c) where a<3;
	select * from ex;

	/* alter table */
	alter table ex drop b;
	alter table ex add d num format=date9.;
	select * from ex;

	/* How might we actually put something in column d? */
	update ex set d=c+2;
	select * from ex;


drop table ex;	
quit;
