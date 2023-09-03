Set p    'Set containing all products'
/milk,
 butter,
 cheese1,
 cheese2/;

Variable x(p)    'Amount of each product consumed (in 1000s of tons)';
Integer variable x;

Variable c(p)    'Price of each product (in 1000s of pounds)';
Nonnegative variable c;

Variable z       'Objective function value';

Parameter alpha(p) 'Fat content in each product (%)';
$include GAMS_MINLP_example_2_input_alpha_data.txt

Parameter beta(p)  'Dry matter content in each product (%)';
$include GAMS_MINLP_example_2_input_beta_data.txt

Parameter gamma    'Amount of fat available (from raw milk production, in 1000s of tons)'
/121/;

Parameter theta    'Amount of dry matter available (from raw milk production, in 1000s of tons'
/250/;

Parameter mu(p)    'Average consumption of products (in 1000s of tons)';
$include GAMS_MINLP_example_2_input_mu_data.txt

Parameter chi(p)    'Average price of products (in 1000s of pounds)';
$include GAMS_MINLP_example_2_input_chi_data.txt

Parameter epsilon(p)     'Elasticity of demand relationship';
$include GAMS_MINLP_example_2_input_epsilon_data.txt

Parameter nu(p,p)      'Cross elasticity of demand relationship';
$include GAMS_MINLP_example_2_input_nu_data.txt

Parameter rho(p)   'Coefficients for policy constraint';
$include GAMS_MINLP_example_2_input_rho_data.txt


Equation obj       'Objective function';
         obj..     z =e= sum(p,x(p)*c(p));

Equation eq1       'Fat content constraint';
         eq1..     sum(p,alpha(p)*x(p)/100) =l= gamma;

Equation eq2       'Dry matter constraint';
         eq2..     sum(p,beta(p)*x(p)/100) =l= theta;

Equation eq3       'Linear demand relationship for milk';
         eq3..     ( x('milk') - mu('milk') )/mu('milk') =e= -epsilon('milk')*( c('milk') - chi('milk') )/chi('milk');

Equation eq4       'Linear demand relationship for butter';
         eq4..     ( x('butter') - mu('butter') )/mu('butter') =e= -epsilon('butter')*( c('butter') - chi('butter') )/chi('butter');

Equation eq5       'Linear demand relationship for cheese1';
         eq5..     ( x('cheese1') - mu('cheese1') )/mu('cheese1') =e= -epsilon('cheese1')*( c('cheese1') - chi('cheese1') )/chi('cheese1') + nu('cheese1','cheese2')*( c('cheese2') - chi('cheese2') )/chi('cheese2');

Equation eq6       'Linear demand relationship for cheese2';
         eq6..     ( x('cheese2') - mu('cheese2') )/mu('cheese2') =e= -epsilon('cheese2')*( c('cheese2') - chi('cheese2') )/chi('cheese2') + nu('cheese2','cheese1')*( c('cheese1') - chi('cheese1') )/chi('cheese1');

Equation eq7       'Policy constraint';
         eq7..     sum(p,rho(p)*(c(p) - chi(p))/chi(p)) =e= 0;

Model GAMS_MINLP_example_2 /all/;

option intVarUp = 2;

option optCr = 0;

option MINLP = baron;

Solve GAMS_MINLP_example_2 using MINLP maximizing z;

