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

integer(151). integer(152). integer(153). integer(154). integer(155). integer(156). integer(157). integer(158). integer(159). integer(160).
integer(211). integer(212). integer(213). integer(214). integer(215). integer(216). integer(217). integer(218). integer(219). integer(220).
integer(821). integer(822). integer(823). integer(824). integer(825). integer(826). integer(827). integer(828). integer(829). integer(830).
integer(1361). integer(1362). integer(1363). integer(1364). integer(1365). integer(1366). integer(1367). integer(1368). integer(1369). integer(1370).
integer(2311). integer(2312). integer(2313). integer(2314). integer(2315). integer(2316). integer(2317). integer(2318). integer(2319). integer(2320).
integer(2381). integer(2382). integer(2383). integer(2384). integer(2385). integer(2386). integer(2387). integer(2388). integer(2389). integer(2390).
integer(2711). integer(2712). integer(2713). integer(2714). integer(2715). integer(2716). integer(2717). integer(2718). integer(2719). integer(2720).
integer(3761). integer(3762). integer(3763). integer(3764). integer(3765). integer(3766). integer(3767). integer(3768). integer(3769). integer(3770).
integer(4561). integer(4562). integer(4563). integer(4564). integer(4565). integer(4566). integer(4567). integer(4568). integer(4569). integer(4570).
integer(6581). integer(6582). integer(6583). integer(6584). integer(6585). integer(6586). integer(6587). integer(6588). integer(6589). integer(6590).
integer(6691). integer(6692). integer(6693). integer(6694). integer(6695). integer(6696). integer(6697). integer(6698). integer(6699). integer(6700).
integer(6701). integer(6702). integer(6703). integer(6704). integer(6705). integer(6706). integer(6707). integer(6708). integer(6709). integer(6710).
succ(76,77). succ(77,78). succ(78,79). succ(79,80). succ(80,81).
succ(151,152). succ(152,153). succ(153,154). succ(154,155). succ(155,156).
succ(196,197). succ(197,198). succ(198,199). succ(199,200). succ(200,201).
succ(211,212). succ(212,213). succ(213,214). succ(214,215). succ(215,216).
succ(486,487). succ(487,488). succ(488,489). succ(489,490). succ(490,491).
succ(821,822). succ(822,823). succ(823,824). succ(824,825). succ(825,826).
succ(1361,1362). succ(1362,1363). succ(1363,1364). succ(1364,1365). succ(1365,1366).
succ(1366,1367). succ(1367,1368). succ(1368,1369). succ(1369,1370). succ(1370,1371).
succ(1776,1777). succ(1777,1778). succ(1778,1779). succ(1779,1780). succ(1780,1781).
succ(1786,1787). succ(1787,1788). succ(1788,1789). succ(1789,1790). succ(1790,1791).
succ(2311,2312). succ(2312,2313). succ(2313,2314). succ(2314,2315). succ(2315,2316).
succ(2376,2377). succ(2377,2378). succ(2378,2379). succ(2379,2380). succ(2380,2381).
succ(2381,2382). succ(2382,2383). succ(2383,2384). succ(2384,2385). succ(2385,2386).
succ(2711,2712). succ(2712,2713). succ(2713,2714). succ(2714,2715). succ(2715,2716).
succ(3761,3762). succ(3762,3763). succ(3763,3764). succ(3764,3765). succ(3765,3766).
succ(3766,3767). succ(3767,3768). succ(3768,3769). succ(3769,3770). succ(3770,3771).
succ(4056,4057). succ(4057,4058). succ(4058,4059). succ(4059,4060). succ(4060,4061).
succ(4561,4562). succ(4562,4563). succ(4563,4564). succ(4564,4565). succ(4565,4566).
succ(4876,4877). succ(4877,4878). succ(4878,4879). succ(4879,4880). succ(4880,4881).
succ(6581,6582). succ(6582,6583). succ(6583,6584). succ(6584,6585). succ(6585,6586).
succ(6691,6692). succ(6692,6693). succ(6693,6694). succ(6694,6695). succ(6695,6696).
succ(6701,6702). succ(6702,6703). succ(6703,6704). succ(6704,6705). succ(6705,6706).
is_prime(4073). is_prime(4079). is_prime(4091). is_prime(4093). is_prime(4099). is_prime(4111). is_prime(4127). is_prime(4129). is_prime(4133). is_prime(4139).
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