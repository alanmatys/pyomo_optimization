* Set definition
Set m   /1*6/;

* Variable declaration
Variables
    a1  'Coefficient 1 in linear regression'
    a2  'Coefficient 2 in linear regression'

    b1  'Coefficient 1 in nonlinear regression'
    b2  'Coefficient 2 in nonlinear regression'
    b3  'Coefficient 3 in nonlinear regression'

    z   'Objective function value';

* Parameter declaration
Table datapoints(m,*)   'Data for regression'
    y       x
1   127     -5
2   151     -3
3   379     -1
4   421     5
5   460     3
6   426     1;

*Objective declaration
Equation    obj_linear_regress  'Objective function for linear regression';
            obj_linear_regress..    z =e= sum(m,sqr(datapoints(m,"y")-(a1+a2*datapoints(m,"x")))) ;

Equation    obj_nonlinear_regress   'Objective function for nonlinear regression';
            obj_nonlinear_regress.. z =e= sum(m,sqr(datapoints(m,"y")-(b1+b2*exp(b3*datapoints(m,"x"))))) ;

Model GAMS_NLP_example_1_linear_regress /obj_linear_regress/;
Model GAMS_NLP_example_1_nonlinear_regress /obj_nonlinear_regress/;

b3.lo = -5.0;
b3.up = 5.0;

b1.l = 500;
b2.l = -150;
b3.l = -0.2;

Solve GAMS_NLP_example_1_linear_regress minimizing z using nlp;
Solve GAMS_NLP_example_1_nonlinear_regress minimizing z using nlp;

