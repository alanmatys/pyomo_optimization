* Set declaration
Set i /1*5/;

Alias (i,j);

Variables
    r       'Radius of identically sized circles'
    x(i)    'x coordinate of circle i'
    y(i)    'y coordinate of circle i'

    z       'Objective function value';

Equation obj    'Objective function';
         obj..  z =e= r;

*Limits on the variables
x.lo(i) = -1; x.up(i) = 1;
y.lo(i) = -1; y.up(i) = 1;
r.lo = 0.05; r.up = 0.4;

Equation eq4(i) 'Containment constraint';
         eq4(i)..   sqr(1-r) =g= sqr(x(i)) + sqr(y(i));

Equation eq5(i,j)   'No overlap constraint';
         eq5(i,j)$(ord(i)<ord(j)).. sqr(x(i) - x(j)) + sqr(y(i) - y(j)) =g= 4*sqr(r);

* Initial solution to obtain feasible solution easily
x.l(i) = -0.2 + ord(i)*0.1;
y.l(i) = -0.2 + ord(i)*0.1;

Model GAMS_NLP_example_2 /all/;

option nlp = ipopt;

solve GAMS_NLP_example_2 using nlp maximizing z;
