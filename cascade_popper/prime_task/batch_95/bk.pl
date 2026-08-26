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

integer(71). integer(72). integer(73). integer(74). integer(75). integer(76). integer(77). integer(78). integer(79). integer(80).
integer(491). integer(492). integer(493). integer(494). integer(495). integer(496). integer(497). integer(498). integer(499). integer(500).
integer(1321). integer(1322). integer(1323). integer(1324). integer(1325). integer(1326). integer(1327). integer(1328). integer(1329). integer(1330).
integer(2621). integer(2622). integer(2623). integer(2624). integer(2625). integer(2626). integer(2627). integer(2628). integer(2629). integer(2630).
integer(3701). integer(3702). integer(3703). integer(3704). integer(3705). integer(3706). integer(3707). integer(3708). integer(3709). integer(3710).
succ(36,37). succ(37,38). succ(38,39). succ(39,40). succ(40,41).
succ(71,72). succ(72,73). succ(73,74). succ(74,75). succ(75,76).
succ(306,307). succ(307,308). succ(308,309). succ(309,310). succ(310,311).
succ(366,367). succ(367,368). succ(368,369). succ(369,370). succ(370,371).
succ(491,492). succ(492,493). succ(493,494). succ(494,495). succ(495,496).
succ(1086,1087). succ(1087,1088). succ(1088,1089). succ(1089,1090). succ(1090,1091).
succ(1321,1322). succ(1322,1323). succ(1323,1324). succ(1324,1325). succ(1325,1326).
succ(1326,1327). succ(1327,1328). succ(1328,1329). succ(1329,1330). succ(1330,1331).
succ(1366,1367). succ(1367,1368). succ(1368,1369). succ(1369,1370). succ(1370,1371).
succ(2616,2617). succ(2617,2618). succ(2618,2619). succ(2619,2620). succ(2620,2621).
succ(2621,2622). succ(2622,2623). succ(2623,2624). succ(2624,2625). succ(2625,2626).
succ(3701,3702). succ(3702,3703). succ(3703,3704). succ(3704,3705). succ(3705,3706).
succ(3946,3947). succ(3947,3948). succ(3948,3949). succ(3949,3950). succ(3950,3951).
succ(6826,6827). succ(6827,6828). succ(6828,6829). succ(6829,6830). succ(6830,6831).
succ(7026,7027). succ(7027,7028). succ(7028,7029). succ(7029,7030). succ(7030,7031).
is_prime(1087). is_prime(1091). is_prime(1093). is_prime(1097). is_prime(1103). is_prime(1109). is_prime(1117). is_prime(1123). is_prime(1129). is_prime(1151).
is_prime(2293). is_prime(2297). is_prime(2309). is_prime(2311). is_prime(2333). is_prime(2339). is_prime(2341). is_prime(2347). is_prime(2351). is_prime(2357).
is_prime(2621). is_prime(2633). is_prime(2647). is_prime(2657). is_prime(2659). is_prime(2663). is_prime(2671). is_prime(2677). is_prime(2683). is_prime(2687).
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