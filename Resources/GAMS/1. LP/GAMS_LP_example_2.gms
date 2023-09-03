*Variable definition
Variables
        x1  Number of workers beginning work on Monday
        x2  Number of workers beginning work on Tuesday
        x3  Number of workers beginning work on Wednesday
        x4  Number of workers beginning work on Thursday
        x5  Number of workers beginning work on Friday
        x6  Number of workers beginning work on Saturday
        x7  Number of workers beginning work on Sunday

        z   Objective function value
;

*Objective function definition
Equation    obj     Objective function;
            obj..   z =e= x1 + x2 + x3 + x4 + x5 + x6 + x7;

*Constraint definition
Equation    eq1     Monday requirement;
            eq1..   x1 + x4 + x5 + x6 + x7 =g= 17;

Equation    eq2     Tuesday requirement;
            eq2..   x1 + x2 + x5 + x6 + x7 =g= 13;

Equation    eq3     Wednesday requirement;
            eq3..   x1 + x2 + x3 + x6 + x7 =g= 15;

Equation    eq4     Thursday requirement;
            eq4..   x1 + x2 + x3 + x4 + x7 =g= 19;

Equation    eq5     Friday requirement;
            eq5..   x1 + x2 + x3 + x4 + x5 =g= 14;

Equation    eq6     Saturday requirement;
            eq6..   x2 + x3 + x4 + x5 + x6 =g= 16;

Equation    eq7     Sunday requirement;
            eq7..   x3 + x4 + x5 + x6 + x7 =g= 11;

*Adding non-negativity constraints
Equation    eq8     Nonneg Monday;
            eq8..   x1 =g= 0;

Equation    eq9     Nonneg Tuesday;
            eq9..   x2 =g= 0;

Equation    eq10    Nonneg Wednesday;
            eq10..  x3 =g= 0;

Equation    eq11    Nonneg Thursday;
            eq11..  x4 =g= 0;

Equation    eq12    Nonneg Friday;
            eq12..  x5 =g= 0;

Equation    eq13    Nonneg Saturday;
            eq13..  x6 =g= 0;

Equation    eq14    Nonneg Sunday;
            eq14..  x7 =g= 0;


*Model assembly
model GAMS_LP_example_2 /all/;

option lp = cplex;

solve GAMS_LP_example_2 using lp minimization z;



