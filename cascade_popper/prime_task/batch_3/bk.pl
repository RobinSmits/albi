%% ============================================================
%% BACKGROUND KNOWLEDGE: Prime Number ILP Task
%% Target: prime(X, Y) - Y is the next prime after X
%% Domain: 1..8500
%% ============================================================

%% --- Number Domain (1..8500) ---


%% --- Successor Relation ---

%% --- Primality (1059 primes up to 8500) ---

%% --- Composite numbers (7440 composites) ---


%% --- Comparison ---

%% --- Basic Arithmetic ---

%% --- Divisibility ---

%% --- Parity ---

%% --- Constants ---

%% --- No prime exists strictly between X and Y ---

integer(641). integer(642). integer(643). integer(644). integer(645). integer(646). integer(647). integer(648). integer(649). integer(650).
integer(661). integer(662). integer(663). integer(664). integer(665). integer(666). integer(667). integer(668). integer(669). integer(670).
integer(1091). integer(1092). integer(1093). integer(1094). integer(1095). integer(1096). integer(1097). integer(1098). integer(1099). integer(1100).
integer(1931). integer(1932). integer(1933). integer(1934). integer(1935). integer(1936). integer(1937). integer(1938). integer(1939). integer(1940).
integer(3121). integer(3122). integer(3123). integer(3124). integer(3125). integer(3126). integer(3127). integer(3128). integer(3129). integer(3130).
integer(3691). integer(3692). integer(3693). integer(3694). integer(3695). integer(3696). integer(3697). integer(3698). integer(3699). integer(3700).
succ(126,127). succ(127,128). succ(128,129). succ(129,130). succ(130,131).
succ(256,257). succ(257,258). succ(258,259). succ(259,260). succ(260,261).
succ(641,642). succ(642,643). succ(643,644). succ(644,645). succ(645,646).
succ(661,662). succ(662,663). succ(663,664). succ(664,665). succ(665,666).
succ(1091,1092). succ(1092,1093). succ(1093,1094). succ(1094,1095). succ(1095,1096).
succ(1116,1117). succ(1117,1118). succ(1118,1119). succ(1119,1120). succ(1120,1121).
succ(1636,1637). succ(1637,1638). succ(1638,1639). succ(1639,1640). succ(1640,1641).
succ(1931,1932). succ(1932,1933). succ(1933,1934). succ(1934,1935). succ(1935,1936).
succ(2646,2647). succ(2647,2648). succ(2648,2649). succ(2649,2650). succ(2650,2651).
succ(2656,2657). succ(2657,2658). succ(2658,2659). succ(2659,2660). succ(2660,2661).
succ(3121,3122). succ(3122,3123). succ(3123,3124). succ(3124,3125). succ(3125,3126).
succ(3256,3257). succ(3257,3258). succ(3258,3259). succ(3259,3260). succ(3260,3261).
succ(3346,3347). succ(3347,3348). succ(3348,3349). succ(3349,3350). succ(3350,3351).
succ(3691,3692). succ(3692,3693). succ(3693,3694). succ(3694,3695). succ(3695,3696).
succ(3696,3697). succ(3697,3698). succ(3698,3699). succ(3699,3700). succ(3700,3701).
succ(5296,5297). succ(5297,5298). succ(5298,5299). succ(5299,5300). succ(5300,5301).
is_prime(127). is_prime(131). is_prime(137). is_prime(139). is_prime(149). is_prime(151). is_prime(157). is_prime(163). is_prime(167). is_prime(173).
is_prime(661). is_prime(673). is_prime(677). is_prime(683). is_prime(691). is_prime(701). is_prime(709). is_prime(719). is_prime(727). is_prime(733).
is_prime(3259). is_prime(3271). is_prime(3299). is_prime(3301). is_prime(3307). is_prime(3313). is_prime(3319). is_prime(3323). is_prime(3329). is_prime(3331).
is_composite(1440). is_composite(1441). is_composite(1442). is_composite(1443). is_composite(1444). is_composite(1445). is_composite(1446). is_composite(1448). is_composite(1449). is_composite(1450).
greater_than(X, Y) :- integer(X), integer(Y), X > Y.
less_than(X, Y) :- integer(X), integer(Y), X < Y.
geq(X, Y) :- integer(X), integer(Y), X >= Y.
leq(X, Y) :- integer(X), integer(Y), X =< Y.
plus(X, Y, Z) :- integer(X), integer(Y), Z is X + Y, integer(Z).
minus(X, Y, Z) :- integer(X), integer(Y), Z is X - Y, Z > 0, integer(Z).
times(X, Y, Z) :- integer(X), integer(Y), X > 0, Y > 0, Z is X * Y, integer(Z).
modulo(X, Y, Z) :- integer(X), integer(Y), Y > 0, Z is X mod Y.
int_div(X, Y, Z) :- integer(X), integer(Y), Y > 0, Z is X // Y, integer(Z).
divides(D, N) :- integer(D), integer(N), D > 0, N > 0, 0 is N mod D.
not_divides(D, N) :- integer(D), integer(N), D > 0, N > 0, R is N mod D, R \= 0.
even(N) :- integer(N), 0 is N mod 2.
odd(N) :- integer(N), 1 is N mod 2.
one(1).
two(2).
no_prime_between(X, Y) :- succ(X, Y).
no_prime_between(X, Y) :- succ(X, Z), is_composite(Z), no_prime_between(Z, Y).