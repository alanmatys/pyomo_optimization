* Set definition
Sets
    w   'Weapons'
    /ICBM       InterContinental Ballistic Missile
    MRBM-1      MediumRange Ballistci Missiles from area number 1
    LR-Bomber   LongeRange Bomber
    F-Bomber    Fighter Bomber
    MRBM-2      MediumRange Ballistic Missiles from area number 2
    /
    t    'Targets'
    /1*20/
    t_spec(t)   'Specific targets'
;

t_spec('1') = yes;
t_spec('6') = yes;
t_spec('10') = yes;
t_spec('14') = yes;
t_spec('15') = yes;
t_spec('16') = yes;
t_spec('20') = yes;

*Variable definitions
Positive Variable
    x(w,t)  Number of weapons of type w assigned to target t
;

Variable
    z   Objective function value;

* Parameter declaration
Table
    phi(w,t)    Probability that weapon w will not damage target t
$include GAMS_NLP_example_3_input_weapons_parameter_phi.txt
;

Parameter alpha(w)  Total number of weapons available per type w
    /ICBM   200
     MRBM-1 100
     LR-Bomber  300
     F-Bomber   150
     MRBM-2 250
    /;

Parameter beta(t)   Military value of targets per type t
    /1  60
     2  50
     3  50
     4  75
     5  40
     6  60
     7  35
     8  30
     9  25
     10 150
     11 30
     12 45
     13 125
     14 200
     15 200
     16 130
     17 100
     18 100
     19 100
     20 150
     /;

Parameter gamma(t)  Minimum number of weapons to be assigned to each target t
    /1  30
     6  100
     10 40
     14 50
     15 70
     16 35
     20 10
    /;

*Constraint definition
Equation obj    Objective function;
         obj..  z =e= sum(t,beta(t)*(1.00-prod(w,(phi(w,t)**x(w,t)))));

Equation eq1(w)    Constraint 1;
         eq1(w)..  sum(t,x(w,t)) =l= alpha(w);

Equation eq2(t) Constraint 2;
         eq2(t)$t_spec(t).. sum(w,x(w,t)) =g= gamma(t);

* Model assembly
model GAMS_NLP_example_3 /all/;

option nlp = ipopt;

solve GAMS_NLP_example_3 using nlp maximization z;



















