Set      c       'Different classes in the plane'
/First,Business,Economy/;

Set      h       'Price level options'
/Option1,Option2,Option3/;

Set      i       'Demand scenarios'
/Scenario1,Scenario2,Scenario3/;
Alias(i,ii,iii);

Binary Variable p1(c,h)     'Whether price option h is chosen for class c in week 1';
Binary Variable p2(i,c,h)   'Whether price option h is chosen for class c in week 2, as a result of demand scenario i in week 1';
Binary Variable p3(i,ii,c,h)'Whether price option h is chosen for class c in week 3, as a result of demand scenario i in week 1 and scenario ii in week 2';

Variable s1(i,c,h)          'Number of tickets sold in week 1 for class c under demand scenario i';
Variable s2(i,ii,c,h)       'Number of tickets sold in week 2 for class c under demand scenario i in week 1 and ii in week 2';
Variable s3(i,ii,iii,c,h)   'Number of tickets sold in week 3 for class c under demand scenario i in week 1, ii in week 2, and iii in week 3';
*Integer Variables s1, s2, s3;
Nonnegative variables s1, s2, s3;

Variable n                  'Number of planes hired to fly';
Integer Variable n;
n.up = 6;

Variable z                  'Objective function value';

Parameter psi(i)  'Probability of occurence of each demand scenario i'
/Scenario1       0.1
 Scenario2       0.7
 Scenario3       0.2/;

Parameter delta1(i,c,h)     'Demand for week 1 for class c under price option h, under demand scenario i';
$call gdxxrw i=GAMS_MINLP_example_3_input_data.xls o=test1.gdx par=delta1 rng=sheet1!A2:E11 rDim=2 cDim=1 trace=5
$gdxin test1.gdx
$load delta1
$gdxin

Parameter delta2(i,c,h)      'Demand for week 2 for class c under price option h, under demand scenario i';
$call gdxxrw i=GAMS_MINLP_example_3_input_data.xls o=test2.gdx par=delta2 rng=sheet1!G2:K11 rDim=2 cDim=1 trace=5
$gdxin test2.gdx
$load delta2
$gdxin

Parameter delta3(i,c,h)      'Demand for week 3 for class c under price option h, under demand scenario i';
$call gdxxrw i=GAMS_MINLP_example_3_input_data.xls o=test3.gdx par=delta3 rng=sheet1!M2:Q11 rDim=2 cDim=1 trace=5
$gdxin test3.gdx
$load delta3
$gdxin

$onEcho > pi1_data.txt
I="%system.fp%GAMS_MINLP_example_3_input_data.xls"
R=sheet1!A14:D17
O=pi1_data.inc
$offEcho

$call =xls2gms @pi1_data.txt

Table pi1(c,h)               'Price options h for class c in week 1'
$include pi1_data.inc
;

display pi1;

$onEcho > pi2_data.txt
I="%system.fp%GAMS_MINLP_example_3_input_data.xls"
R=sheet1!G14:J17
O=pi2_data.inc
$offEcho

$call =xls2gms @pi2_data.txt

Table pi2(c,h)               'Price options h for class c in week 2'
$include pi2_data.inc
;

display pi2;

$onEcho > pi3_data.txt
I="%system.fp%GAMS_MINLP_example_3_input_data.xls"
R=sheet1!M14:P17
O=pi3_data.inc
$offEcho

$call =xls2gms @pi3_data.txt

Table pi3(c,h)               'Price options h for class c in week 3'
$include pi3_data.inc
;

display pi3;

Parameter gamma(c)           'Seat capacity for each class c'
/First           37
 Business        38
 Economy         47/;

Equation obj                 'Objective function';
         obj..               z =e= sum((i,c,h),psi(i)*pi1(c,h)*p1(c,h)*s1(i,c,h)) +
                                   sum((i,ii,c,h),psi(i)*psi(ii)*pi2(c,h)*p2(i,c,h)*s2(i,ii,c,h)) +
                                   sum((i,ii,iii,c,h),psi(i)*psi(ii)*psi(iii)*p3(i,ii,c,h)*pi3(c,h)*s3(i,ii,iii,c,h)) -
                                   50000*n;

* For WEEK 1
Equation eq1a(c)         'Only one price option must be chosen in week 1';
         eq1a(c)..       sum(h,p1(c,h)) =e= 1;
Equation eq1b(i,c,h)     'Sales must not exceed demand in week 1';
         eq1b(i,c,h)..   s1(i,c,h) =l= delta1(i,c,h)*p1(c,h);

* For WEEK 2
Equation eq2a(i,c)       'Only one price option must be chosen in week 2';
         eq2a(i,c)..     sum(h,p2(i,c,h)) =e= 1;
Equation eq2b(i,ii,c,h)  'Sales must not exceed demand in week 2';
         eq2b(i,ii,c,h)..s2(i,ii,c,h) =l= delta2(ii,c,h)*p2(i,c,h);

* For WEEK 3
Equation eq3a(i,ii,c)    'Only one price option must be chosen in week 3';
         eq3a(i,ii,c)..  sum(h,p3(i,ii,c,h)) =e= 1;
Equation eq3b(i,ii,iii,c,h)  'Sales must not exceed demand in week 3';
         eq3b(i,ii,iii,c,h)..s3(i,ii,iii,c,h) =l= delta3(iii,c,h)*p3(i,ii,c,h);

Equation eq4(i,ii,iii,c)  'Seat capacity must be abided by';
         eq4(i,ii,iii,c)..sum(h,s1(i,c,h)) + sum(h,s2(i,ii,c,h)) + sum(h,s3(i,ii,iii,c,h))
                          =l= gamma(c)*n;

Model GAMS_MINLP_example_3 /all/;

option optCr = 0;

option MINLP = bonmin;

Solve GAMS_MINLP_example_3 using MINLP maximizing z;


