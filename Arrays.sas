/*****************************/
/* Lesson Video Part 2       */
/* Defining and using Arrays */
/*****************************/

/***********/
/* Example */
/***********/
/* Defining numeric arrays */
data numArray;
/* 	Define the array - array name, number of variables, length of each variable, 
      variable names, initial values */
	array mnth(3) 6 month1 month2 month3 (20 30 40);

/* 	b1 = mnth(1) + 5; */
/* 	b2 = mnth(2) + 5; */
/* 	b3 = mnth(3) + 5; */
	
	array b(3) b1-b3; /*can also list out: b1 b2 b3*/
	
	do i = 1 to dim(b);
		b(i) = mnth(i) + 5;
	end;
	
	drop i;
	
/* 	Referencing an array value outside the subscript range produces a syntax error */
/* 	b4 = mnth(4) + 5; */
run;

proc print data=numArray; 
run;

proc contents data=numArray;
run;


/***********/
/* Example */
/***********/
/* Defining character arrays */
data charArray;
	array places(3) $ 10 first sec third ("A", "B", "C");
	
	testCats = cats(places(1), places(2), places(3));
	
	length CatsLoop $10;
	do i = 1 to 3;
		CatsLoop = cats(CatsLoop, places(i));
/* 		output; */
	end;	
	
	drop i;
run;

proc print data=charArray; 
run;

proc contents data=charArray;
run;





/***************************/
/* Lesson Video Part 3     */
/* Repetitive calculations */
/***************************/

/***********/
/* Example */
/***********/
/* Using character arrays to perform repetitive calculations on many variables */
/* Create new variables with similar attributes */
data flags;
	set sashelp.flags;
	
/* 	Defines array that will contain ALL character variables */
	array charVar(*) $ project title descript file keywords location type;
	
	do i = 1 to dim(charVar);
		charVar(i) = Propcase(charVar(i));
	end;
	
	drop i;

run;

proc contents data=sashelp.flags; 
run;

/***********/
/* Example */
/***********/
/* Using arrays to perform repetitive numeric calculations on many variables */
proc print data=sashelp.pricedata;
run;

/* Change from dollars to euros (Current exchange rate is 0.87) */
data priceEur;
	set sashelp.pricedata;

	price1Eur = price1*0.87;
	price2Eur = price2*0.87;
	price3Eur = price3*0.87;
	price4Eur = price4*0.87;
	price5Eur = price5*0.87;
/* 	Continue until all 17 price columns are converted */
run;

/* Change prices from Dollars to Euros using Arrays */
data priceEurArrays;
	set sashelp.pricedata;
	
	array priceDol(*) price1-price17;
	array priceEur(*) priceEur1-priceEur17;
	
	do i = 1 to dim(priceDol);
		priceEur(i) = priceDol(i)*.87;
	end;
	
	drop i;
run;

proc print data=priceEurArrays;
	var price1 priceEur1 price2 priceEur2;
	format price1 price2 dollar10.2 priceEur1 priceEur2 Euro10.2;
run;




/***********************/
/* Lesson Video Part 4 */ 
/* Restructuring Data  */
/***********************/

/***********/
/* Example */
/***********/
/* Three different exams taken by students */
data examScores;
	input exam1 exam2 exam3;
	datalines;
83.5 78 69
88 66.5 83
72.5 70.5 50
92 63.5 82
94 97.5 99
74 77.5 78
90 86 0
100 98 100
86 70.5 88.5
86.5 75.5 64
77 84.5 0
85.5 72 74.5
100 91.5 100
78.5 54.5 87
61 0 0
64.5 64 66.5
93 99 95
;
run;

proc print data=examScores; run;

proc means data=examScores mean;
	var exam1-exam3;
run;

/* Convert all zero scores to missing */
/* Without the DO Loop and Arrays: */
data NoDOArrays;
	set examScores;
	
/* 	This can get long if you have lots of variables!! */
	if exam1 = 0 then exam1 = .;
	if exam2 = 0 then exam2 = .;
	if exam3 = 0 then exam3 = .;
	
run;	


/* Cleaning the data using DO Loops and Arrays; */
data cleanExams;
	set examScores;

/* 	Creates a column containing the observation/row number */
	StudentID = _N_;

	array exams(*) _numeric_; /*All numeric variables in the table will be in exams array*/

/* 	Alternative syntax defining the array  */
/* 	array exams(3) exam1-exam3; */
	
/* 	Convert all 0's to missing values */
	do i = 1 to dim(exams);
		if exams(i)=0 then exams(i)=.;
	end;
	
	drop i;
run;

proc print data=cleanExams; 
run;

proc means data=cleanExams mean;
	var exam1-exam3;
run;


/* Transform dataset from multiple variables to single column (wide to long format) */
data examTransformed;
	set cleanExams;

	array exams(*) exam1-exam3;
	
	do exam_num = 1 to 3;
		scores = exams(exam_num);
		output;
	end;
	
	keep StudentID exam_num scores;

/* 	Alternative syntax */
/* 	drop exam1-exam3; */
run;

proc print data=examTransformed; run;


/* Create side-by-side box plot of exam scores*/
proc sgplot data=examTransformed;
	vbox scores/category=exam_num;
	xaxis label = "Exam";
	yaxis label = "Scores";
run;

/***********************/
/* Lesson Video Part 5 */ 
/* Restructuring Data  */
/***********************/
/* Transform data back to original form - single column of values to multiple variables (long to wide format)*/
data examsOrigTable;
	set examTransformed;
	
	array exams(*) exam1-exam3;

/* 	Keep the values for exam1 and exam2 until ready to output all three exams scores */
	retain exam1 exam2;
	
/* 	Group rows by each student */
/* 	BY variable MUST be sorted first! */
	by StudentID;
	
/* 	If it's the first row for a particular StudentID */
/* 	i=0 initializes the counter to start again at 0 for each student */
/* 	Can use this special variable only when using the BY statement */
	if first.StudentID then i=0;

/* 	Change counter so it goes to the next exam in array */
	i+1; 
	exams(i)=scores;
	
/* 	When it reaches the last row for a student, output a new row to the table */
/* 	with all the current exam values */
	if last.StudentID then output;
	
	keep StudentID exam1-exam3;
run;

proc print data=examsOrigTable;
run;




