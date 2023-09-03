*Set declaration
Set
    i   'Item'
    /i1*i6/
    m   'Machine'
    /bending,soldering,assembly/;

Alias (i,k);

*Variable declaration
Variable
    R(i,k)  'Item i has position k'
    S(m,k)  'Start time for job in position k on machine m'
    C(m,k)  'Completion time for job in position k on machine m'
    T       'Time before first job and last job'
;

Binary variable R;
Positive variable S, C;

*Parameter declaration
Table tau(m,i)  'Processing time (in min)'
            i1  i2  i3  i4  i5  i6
bending     3   6   3   5   5   7
soldering   5   4   2   4   4   5
assembly    5   2   4   6   3   6
;

*Objective function definition not required here; objective is T

*Constraint definition
Equation    eq1(k)      'Every position gets a job';
            eq1(k)..    sum(i,R(i,k)) =e= 1;

Equation    eq2(i)      'Every job is assigned a rank';
            eq2(i)..    sum(k,R(i,k)) =e= 1;

Equation    eq3(m,k)    'Relations between the end of job ranked k on machine m, and start of job ranked k+1 on machine m';
            eq3(m,k)$(ord(k)<card(k)).. S(m,k+1) =g= C(m,k);

Equation    eq4(m,k)    'Relations between the end of job ranked k on machine m, and start of job ranked k on machine m+1';
            eq4(m,k)$(ord(m)<card(m)).. S(m+1,k) =g= C(m,k);

Equation    eq5(m,k)    'Calculation of completion time based on start time and processing time';
            eq5(m,k)..  C(m,k) =e= S(m,k) + sum(i,tau(m,i)*R(i,k));

Equation    eq6         'Completion time of last job on last machine';
            eq6..       T =g= C('assembly','i6');

Model GAMS_MILP_example_3 /all/;

option optCr = 0;

solve GAMS_MILP_example_3 using mip minimizing T;

* In order to import blank cells with placeholders
* Because gdx does not export 0 values
loop ( (i,k) $ (R.l(i,k) = 0), R.fx(i,k) = 100 );
loop ( (m,k) $ (S.l(m,k) = 0), S.fx(m,k) = -1);
loop ( (m,k) $ (C.l(m,k) = 0), C.fx(m,k) = -1);

* Writing results to .xlsx file

*First, export solution as .gdx
execute_unload "GAMS_MILP_example_3_output_results.gdx" R.l S.l C.l T;

* Next, export to .xlsx
execute 'gdxxrw.exe GAMS_MILP_example_3_output_results.gdx o=GAMS_MILP_example_3_results.xlsx var=R.l rng=Sheet1!A2';
execute 'gdxxrw.exe GAMS_MILP_example_3_output_results.gdx o=GAMS_MILP_example_3_results.xlsx var=S.l rng=Sheet1!J2';
execute 'gdxxrw.exe GAMS_MILP_example_3_output_results.gdx o=GAMS_MILP_example_3_results.xlsx var=C.l rng=Sheet1!A15';
execute 'gdxxrw.exe GAMS_MILP_example_3_output_results.gdx o=GAMS_MILP_example_3_results.xlsx var=T rng=Sheet1!J15';
