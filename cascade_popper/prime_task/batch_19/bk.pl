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

integer(461). integer(462). integer(463). integer(464). integer(465). integer(466). integer(467). integer(468). integer(469). integer(470).
integer(691). integer(692). integer(693). integer(694). integer(695). integer(696). integer(697). integer(698). integer(699). integer(700).
integer(751). integer(752). integer(753). integer(754). integer(755). integer(756). integer(757). integer(758). integer(759). integer(760).
integer(941). integer(942). integer(943). integer(944). integer(945). integer(946). integer(947). integer(948). integer(949). integer(950).
integer(2011). integer(2012). integer(2013). integer(2014). integer(2015). integer(2016). integer(2017). integer(2018). integer(2019). integer(2020).
integer(2591). integer(2592). integer(2593). integer(2594). integer(2595). integer(2596). integer(2597). integer(2598). integer(2599). integer(2600).
integer(3221). integer(3222). integer(3223). integer(3224). integer(3225). integer(3226). integer(3227). integer(3228). integer(3229). integer(3230).
integer(5381). integer(5382). integer(5383). integer(5384). integer(5385). integer(5386). integer(5387). integer(5388). integer(5389). integer(5390).
integer(6211). integer(6212). integer(6213). integer(6214). integer(6215). integer(6216). integer(6217). integer(6218). integer(6219). integer(6220).
integer(6521). integer(6522). integer(6523). integer(6524). integer(6525). integer(6526). integer(6527). integer(6528). integer(6529). integer(6530).
succ(21,22). succ(22,23). succ(23,24). succ(24,25). succ(25,26).
succ(461,462). succ(462,463). succ(463,464). succ(464,465). succ(465,466).
succ(466,467). succ(467,468). succ(468,469). succ(469,470). succ(470,471).
succ(676,677). succ(677,678). succ(678,679). succ(679,680). succ(680,681).
succ(691,692). succ(692,693). succ(693,694). succ(694,695). succ(695,696).
succ(751,752). succ(752,753). succ(753,754). succ(754,755). succ(755,756).
succ(941,942). succ(942,943). succ(943,944). succ(944,945). succ(945,946).
succ(1446,1447). succ(1447,1448). succ(1448,1449). succ(1449,1450). succ(1450,1451).
succ(1626,1627). succ(1627,1628). succ(1628,1629). succ(1629,1630). succ(1630,1631).
succ(2011,2012). succ(2012,2013). succ(2013,2014). succ(2014,2015). succ(2015,2016).
succ(2266,2267). succ(2267,2268). succ(2268,2269). succ(2269,2270). succ(2270,2271).
succ(2466,2467). succ(2467,2468). succ(2468,2469). succ(2469,2470). succ(2470,2471).
succ(2591,2592). succ(2592,2593). succ(2593,2594). succ(2594,2595). succ(2595,2596).
succ(3216,3217). succ(3217,3218). succ(3218,3219). succ(3219,3220). succ(3220,3221).
succ(3221,3222). succ(3222,3223). succ(3223,3224). succ(3224,3225). succ(3225,3226).
succ(3796,3797). succ(3797,3798). succ(3798,3799). succ(3799,3800). succ(3800,3801).
succ(5381,5382). succ(5382,5383). succ(5383,5384). succ(5384,5385). succ(5385,5386).
succ(5386,5387). succ(5387,5388). succ(5388,5389). succ(5389,5390). succ(5390,5391).
succ(6211,6212). succ(6212,6213). succ(6213,6214). succ(6214,6215). succ(6215,6216).
succ(6216,6217). succ(6217,6218). succ(6218,6219). succ(6219,6220). succ(6220,6221).
succ(6521,6522). succ(6522,6523). succ(6523,6524). succ(6524,6525). succ(6525,6526).
is_prime(467). is_prime(479). is_prime(487). is_prime(491). is_prime(499). is_prime(503). is_prime(509). is_prime(521). is_prime(523). is_prime(541).
is_prime(739). is_prime(743). is_prime(751). is_prime(757). is_prime(761). is_prime(769). is_prime(773). is_prime(787). is_prime(797). is_prime(809).
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