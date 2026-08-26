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

integer(251). integer(252). integer(253). integer(254). integer(255). integer(256). integer(257). integer(258). integer(259). integer(260).
integer(271). integer(272). integer(273). integer(274). integer(275). integer(276). integer(277). integer(278). integer(279). integer(280).
integer(641). integer(642). integer(643). integer(644). integer(645). integer(646). integer(647). integer(648). integer(649). integer(650).
integer(1051). integer(1052). integer(1053). integer(1054). integer(1055). integer(1056). integer(1057). integer(1058). integer(1059). integer(1060).
integer(1871). integer(1872). integer(1873). integer(1874). integer(1875). integer(1876). integer(1877). integer(1878). integer(1879). integer(1880).
integer(2281). integer(2282). integer(2283). integer(2284). integer(2285). integer(2286). integer(2287). integer(2288). integer(2289). integer(2290).
integer(4621). integer(4622). integer(4623). integer(4624). integer(4625). integer(4626). integer(4627). integer(4628). integer(4629). integer(4630).
integer(5521). integer(5522). integer(5523). integer(5524). integer(5525). integer(5526). integer(5527). integer(5528). integer(5529). integer(5530).
succ(126,127). succ(127,128). succ(128,129). succ(129,130). succ(130,131).
succ(131,132). succ(132,133). succ(133,134). succ(134,135). succ(135,136).
succ(136,137). succ(137,138). succ(138,139). succ(139,140). succ(140,141).
succ(251,252). succ(252,253). succ(253,254). succ(254,255). succ(255,256).
succ(271,272). succ(272,273). succ(273,274). succ(274,275). succ(275,276).
succ(641,642). succ(642,643). succ(643,644). succ(644,645). succ(645,646).
succ(646,647). succ(647,648). succ(648,649). succ(649,650). succ(650,651).
succ(946,947). succ(947,948). succ(948,949). succ(949,950). succ(950,951).
succ(1051,1052). succ(1052,1053). succ(1053,1054). succ(1054,1055). succ(1055,1056).
succ(1866,1867). succ(1867,1868). succ(1868,1869). succ(1869,1870). succ(1870,1871).
succ(1871,1872). succ(1872,1873). succ(1873,1874). succ(1874,1875). succ(1875,1876).
succ(2281,2282). succ(2282,2283). succ(2283,2284). succ(2284,2285). succ(2285,2286).
succ(2616,2617). succ(2617,2618). succ(2618,2619). succ(2619,2620). succ(2620,2621).
succ(3466,3467). succ(3467,3468). succ(3468,3469). succ(3469,3470). succ(3470,3471).
succ(4621,4622). succ(4622,4623). succ(4623,4624). succ(4624,4625). succ(4625,4626).
succ(4636,4637). succ(4637,4638). succ(4638,4639). succ(4639,4640). succ(4640,4641).
succ(5521,5522). succ(5522,5523). succ(5523,5524). succ(5524,5525). succ(5525,5526).
succ(7546,7547). succ(7547,7548). succ(7548,7549). succ(7549,7550). succ(7550,7551).
succ(7606,7607). succ(7607,7608). succ(7608,7609). succ(7609,7610). succ(7610,7611).
is_prime(127). is_prime(131). is_prime(137). is_prime(139). is_prime(149). is_prime(151). is_prime(157). is_prime(163). is_prime(167). is_prime(173).
is_prime(947). is_prime(953). is_prime(967). is_prime(971). is_prime(977). is_prime(983). is_prime(991). is_prime(997). is_prime(1009). is_prime(1013).
is_composite(58). is_composite(60). is_composite(62). is_composite(63). is_composite(64). is_composite(65). is_composite(66). is_composite(68). is_composite(69). is_composite(70).
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