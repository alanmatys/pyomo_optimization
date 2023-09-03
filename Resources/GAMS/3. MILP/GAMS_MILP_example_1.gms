*Set declaration
Set a
    /compact,
     midsize,
     large/;

*Variable definition
Integer variable
    x(a)    'Number of cars of each type that should be manufactured';

Binary variable
    y(a)    'Binary variable - whether or not car of type a is built';

Variable
    z       'Objective function value';

*Parameter declaration
Parameter phi(a)    'Profit contribution of each type of car'
          /compact  2000
           midsize  3000
           large    4000/;

Parameter mu(a)     'Minimum number of each type of car to be manufactured, if at all'
          /compact  1000
           midsize  1000
           large    1000/;

Table alpha(a,*)
            steel   labor
compact     1.5     30
midsize     3       25
large       5       40
;

Scalar sigma    'Steel availability limit'  /6000/;

Scalar gamma    'Labor availability limit'  /60000/;

Parameter M(a)  'Big M values for constraints relating to each type of car'
          /compact  2000
           midsize  2000
           large    1200/;

*Objective function declaration
Equation obj    'Objective function';
         obj..  z =e= sum(a,phi(a)*x(a));

*Constraint definition
Equation eq1(a) 'Constraint part 1 for either-or constraint equivalent for each car';
         eq1(a)..   x(a) =l= M(a)*y(a);

Equation eq2(a) 'Constraint part 2 for either-or constraint equivalent for each car';
         eq2(a)..   mu(a) - x(a) =l= M(a)*( 1-y(a) );

Equation eq3    'Steel constraint';
         eq3..  sum(a,alpha(a,"steel")*x(a)) =l= sigma;

Equation eq4    'Labor constraint';
         eq4..  sum(a,alpha(a,"labor")*x(a)) =l= gamma;

*Variable bounds
x.lo(a) = 0;
x.up(a) = M(a);

Model GAMS_MILP_example_1 /all/;

option mip = cplex;

solve GAMS_MILP_example_1 using mip maximizing z;

*Writing results to text file
File GAMS_MILP_example_1_output_results  /GAMS_MILP_example_1_output_results.txt/;
GAMS_MILP_example_1_output_results.pc = 5;

put GAMS_MILP_example_1_output_results;
put "Model status: " GAMS_MILP_example_1.modelstat    /;
put "Solver status: " GAMS_MILP_example_1.solvestat   /;
put "Objective = total profit from manufacturing cars: " z.l /;
put "Number of cars manufactured: " /;
loop (a,
      put a.tl x.l(a) /
);
put "Are cars manufactured? (1: yes, 0: no): " /;
loop (a,
      put a.tl y.l(a) /
);
putclose;
