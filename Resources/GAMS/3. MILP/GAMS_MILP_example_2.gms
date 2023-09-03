* Set declaration
Set
    t   'Time periods in a day'
    /12am-6am,
     6am-9am,
     9am-3pm,
     3pm-6pm,
     6pm-12am/;

Set g   'Types of generators available'
    /G1*G3/;

*Variable declaration
Variable x(g,t) 'Output of generator of type g during time period t (in MW)';

Nonnegative variable x;

Integer variables
    n(g,t)  'Number of generators of type g in use during time period t'
    s(g,t)  'Number of generators of type g started up during time period t'
;
*No need to define nonnegativity for n and s because GAMS takes 0 to +inf bounds for integers

Variable
    z   'Objective function value';

*Parameter declaration
Parameter delta(t)  'Demand during each time period (in MW)'
          /12am-6am 15000
           6am-9am  30000
           9am-3pm  25000
           3pm-6pm  40000
           6pm-12am 27000/;

Parameter theta(t)  'Number of hours in each time period (in h)'
          /12am-6am 6
           6am-9am  3
           9am-3pm  6
           3pm-6pm  3
           6pm-12am 6/;

Table alpha(g,*)    'Generation data'
    min_pow     max_pow     min_cost        inc_cost        start       gen_lim
*   (MW)        (MW)        (£/h)           (£/MW/h)        (£)         (Units)
G1  850         2000        1000            2.0             2000        12
G2  1250        1750        2600            1.3             1000        10
G3  1500        4000        3000            3.0             500         5
;

Parameter epsilon(g,t)  'Simplifying objective function parameters';
* epsilon is the cost per hour for operating generator g in time period t, times number of hours in period t (in £)

epsilon(g,t) = theta(t)*alpha(g,"min_cost");

Parameter phi(g,t)      'Simplifying objective function parameters';
* phi is the cost per hour per MW for operation of generator g at min. level in time period t, times the no. of hours in period t (in £/MW)

phi(g,t) = theta(t)*alpha(g,"inc_cost");

* Objective function definition
Equation obj    'Objective function';
         obj..  z =e= sum( (g,t),epsilon(g,t)*n(g,t) + alpha(g,"start")*s(g,t) + phi(g,t)*(x(g,t)-alpha(g,"min_pow")*n(g,t)) );

* Constraint definition
Equation eq1(t) 'Power demand satisfaction';
         eq1(t)..   sum(g,x(g,t)) =g= delta(t);

Equation eq2(t) 'Spinning reserve requirement';
         eq2(t)..   sum(g,alpha(g,"max_pow")*n(g,t)) =g= 1.15*delta(t);

Equation eq3(g,t)   'Start-up definition';
         eq3(g,t).. s(g,t) =g= n(g,t) - n(g,t--1);

Equation eq4(g,t)   'Minimum generation levels';
         eq4(g,t).. x(g,t) =g= alpha(g,"min_pow")*n(g,t);

Equation eq5(g,t)   'Maximum generation levels';
         eq5(g,t).. x(g,t) =l= alpha(g,"max_pow")*n(g,t);

*Limit on the number of generators used in each time period
n.up(g,t) = alpha(g,"gen_lim");

Model GAMS_MILP_example_2 /all/;

GAMS_MILP_example_2.optCr = 0;

option mip = CPLEX;

solve GAMS_MILP_example_2 minimizing z using mip;

*Writing results to a gdx file
execute_unload 'GAMS_MILP_example_2_output_results.gdx', t, g, z, x, n, s;
