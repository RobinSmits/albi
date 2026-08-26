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

integer(541). integer(542). integer(543). integer(544). integer(545). integer(546). integer(547). integer(548). integer(549). integer(550).
integer(941). integer(942). integer(943). integer(944). integer(945). integer(946). integer(947). integer(948). integer(949). integer(950).
integer(1381). integer(1382). integer(1383). integer(1384). integer(1385). integer(1386). integer(1387). integer(1388). integer(1389). integer(1390).
integer(2351). integer(2352). integer(2353). integer(2354). integer(2355). integer(2356). integer(2357). integer(2358). integer(2359). integer(2360).
integer(2441). integer(2442). integer(2443). integer(2444). integer(2445). integer(2446). integer(2447). integer(2448). integer(2449). integer(2450).
integer(4481). integer(4482). integer(4483). integer(4484). integer(4485). integer(4486). integer(4487). integer(4488). integer(4489). integer(4490).
succ(16,17). succ(17,18). succ(18,19). succ(19,20). succ(20,21).
succ(96,97). succ(97,98). succ(98,99). succ(99,100). succ(100,101).
succ(106,107). succ(107,108). succ(108,109). succ(109,110). succ(110,111).
succ(126,127). succ(127,128). succ(128,129). succ(129,130). succ(130,131).
succ(541,542). succ(542,543). succ(543,544). succ(544,545). succ(545,546).
succ(936,937). succ(937,938). succ(938,939). succ(939,940). succ(940,941).
succ(941,942). succ(942,943). succ(943,944). succ(944,945). succ(945,946).
succ(1366,1367). succ(1367,1368). succ(1368,1369). succ(1369,1370). succ(1370,1371).
succ(1381,1382). succ(1382,1383). succ(1383,1384). succ(1384,1385). succ(1385,1386).
succ(1426,1427). succ(1427,1428). succ(1428,1429). succ(1429,1430). succ(1430,1431).
succ(2351,2352). succ(2352,2353). succ(2353,2354). succ(2354,2355). succ(2355,2356).
succ(2356,2357). succ(2357,2358). succ(2358,2359). succ(2359,2360). succ(2360,2361).
succ(2441,2442). succ(2442,2443). succ(2443,2444). succ(2444,2445). succ(2445,2446).
succ(3636,3637). succ(3637,3638). succ(3638,3639). succ(3639,3640). succ(3640,3641).
succ(4296,4297). succ(4297,4298). succ(4298,4299). succ(4299,4300). succ(4300,4301).
succ(4481,4482). succ(4482,4483). succ(4483,4484). succ(4484,4485). succ(4485,4486).
is_prime(127). is_prime(131). is_prime(137). is_prime(139). is_prime(149). is_prime(151). is_prime(157). is_prime(163). is_prime(167). is_prime(173).
is_prime(233). is_prime(239). is_prime(241). is_prime(251). is_prime(257). is_prime(263). is_prime(269). is_prime(271). is_prime(277). is_prime(281).
is_prime(1381). is_prime(1399). is_prime(1409). is_prime(1423). is_prime(1427). is_prime(1429). is_prime(1433). is_prime(1439). is_prime(1447). is_prime(1451).
is_prime(7109). is_prime(7121). is_prime(7127). is_prime(7129). is_prime(7151). is_prime(7159). is_prime(7177). is_prime(7187). is_prime(7193). is_prime(7207).
is_prime(7649). is_prime(7669). is_prime(7673). is_prime(7681). is_prime(7687). is_prime(7691). is_prime(7699). is_prime(7703). is_prime(7717). is_prime(7723).
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