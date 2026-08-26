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

integer(281). integer(282). integer(283). integer(284). integer(285). integer(286). integer(287). integer(288). integer(289). integer(290).
integer(811). integer(812). integer(813). integer(814). integer(815). integer(816). integer(817). integer(818). integer(819). integer(820).
integer(821). integer(822). integer(823). integer(824). integer(825). integer(826). integer(827). integer(828). integer(829). integer(830).
integer(991). integer(992). integer(993). integer(994). integer(995). integer(996). integer(997). integer(998). integer(999). integer(1000).
integer(1601). integer(1602). integer(1603). integer(1604). integer(1605). integer(1606). integer(1607). integer(1608). integer(1609). integer(1610).
integer(2671). integer(2672). integer(2673). integer(2674). integer(2675). integer(2676). integer(2677). integer(2678). integer(2679). integer(2680).
integer(3061). integer(3062). integer(3063). integer(3064). integer(3065). integer(3066). integer(3067). integer(3068). integer(3069). integer(3070).
integer(4421). integer(4422). integer(4423). integer(4424). integer(4425). integer(4426). integer(4427). integer(4428). integer(4429). integer(4430).
succ(41,42). succ(42,43). succ(43,44). succ(44,45). succ(45,46).
succ(156,157). succ(157,158). succ(158,159). succ(159,160). succ(160,161).
succ(166,167). succ(167,168). succ(168,169). succ(169,170). succ(170,171).
succ(281,282). succ(282,283). succ(283,284). succ(284,285). succ(285,286).
succ(366,367). succ(367,368). succ(368,369). succ(369,370). succ(370,371).
succ(546,547). succ(547,548). succ(548,549). succ(549,550). succ(550,551).
succ(811,812). succ(812,813). succ(813,814). succ(814,815). succ(815,816).
succ(821,822). succ(822,823). succ(823,824). succ(824,825). succ(825,826).
succ(991,992). succ(992,993). succ(993,994). succ(994,995). succ(995,996).
succ(1596,1597). succ(1597,1598). succ(1598,1599). succ(1599,1600). succ(1600,1601).
succ(1601,1602). succ(1602,1603). succ(1603,1604). succ(1604,1605). succ(1605,1606).
succ(1866,1867). succ(1867,1868). succ(1868,1869). succ(1869,1870). succ(1870,1871).
succ(1876,1877). succ(1877,1878). succ(1878,1879). succ(1879,1880). succ(1880,1881).
succ(2446,2447). succ(2447,2448). succ(2448,2449). succ(2449,2450). succ(2450,2451).
succ(2671,2672). succ(2672,2673). succ(2673,2674). succ(2674,2675). succ(2675,2676).
succ(3061,3062). succ(3062,3063). succ(3063,3064). succ(3064,3065). succ(3065,3066).
succ(3066,3067). succ(3067,3068). succ(3068,3069). succ(3069,3070). succ(3070,3071).
succ(4421,4422). succ(4422,4423). succ(4423,4424). succ(4424,4425). succ(4425,4426).
succ(6606,6607). succ(6607,6608). succ(6608,6609). succ(6609,6610). succ(6610,6611).
succ(7506,7507). succ(7507,7508). succ(7508,7509). succ(7509,7510). succ(7510,7511).
is_prime(547). is_prime(557). is_prime(563). is_prime(569). is_prime(571). is_prime(577). is_prime(587). is_prime(593). is_prime(599). is_prime(601).
is_prime(811). is_prime(821). is_prime(823). is_prime(827). is_prime(829). is_prime(839). is_prime(853). is_prime(857). is_prime(859). is_prime(863).
is_prime(1597). is_prime(1601). is_prime(1607). is_prime(1609). is_prime(1613). is_prime(1619). is_prime(1621). is_prime(1627). is_prime(1637). is_prime(1657).
is_prime(4421). is_prime(4423). is_prime(4441). is_prime(4447). is_prime(4451). is_prime(4457). is_prime(4463). is_prime(4481). is_prime(4483). is_prime(4493).
is_prime(7507). is_prime(7517). is_prime(7523). is_prime(7529). is_prime(7537). is_prime(7541). is_prime(7547). is_prime(7549). is_prime(7559). is_prime(7561).
is_composite(282). is_composite(284). is_composite(285). is_composite(286). is_composite(287). is_composite(288). is_composite(289). is_composite(290). is_composite(291). is_composite(292).
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