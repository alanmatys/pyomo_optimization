*Set declaration
Sets
    c   /HIW
         HIM/
    a   /comedy
         football/;

*Variable declaration
Variables
        x(a)    Number of ads of type a to be purchased

        z       Objective function value;

*Parameter declaration
Parameter
        theta(a)    Cost of running ad of type a
        /comedy 50
         football   100/;

Table
        mu(a,c)     Number of viewers for ad of type a from customer base c

            HIW     HIM
comedy      7       2
football    2       12;

Parameter
        alpha(c)    Minimum viewership from customer base c
        /HIW    28
         HIM    24/;

*Objective function definition
Equation    obj     Objective function;
            obj..   z =e= sum(a,theta(a)*x(a));

*Constraint definition
Equation    eq1(c)  Constraint 1;
            eq1(c)..    sum(a,mu(a,c)*x(a)) =g= alpha(c);

*Model assembly
model GAMS_LP_example_3 /all/;

*Solver option
option lp = cplex;

*Solve statement
solve GAMS_LP_example_3 using lp minimization z;
