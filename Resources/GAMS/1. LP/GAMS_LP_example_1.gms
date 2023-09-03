*Variable declaration
Variables
        x1      Number of comedy ads purchased
        x2      Number of football ads purchased

        z       Objective function value

;

*Objective function definition
Equation    obj     Objective function;
            obj..   z =e= 50*x1 + 100*x2;

*Constraint definition
Equation    eq1     Constraint 1;
            eq1..   7*x1 + 2*x2 =g= 28;

Equation    eq2     Constraint 2;
            eq2..   2*x1 + 12*x2 =g= 24;

*Model assembly
model GAMS_LP_example_1 /all/;

*Solver option
option lp = cplex;

*Solve statement
solve GAMS_LP_example_1 using lp minimization z;

