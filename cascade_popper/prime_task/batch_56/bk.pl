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
integer(571). integer(572). integer(573). integer(574). integer(575). integer(576). integer(577). integer(578). integer(579). integer(580).
integer(971). integer(972). integer(973). integer(974). integer(975). integer(976). integer(977). integer(978). integer(979). integer(980).
integer(2221). integer(2222). integer(2223). integer(2224). integer(2225). integer(2226). integer(2227). integer(2228). integer(2229). integer(2230).
integer(4021). integer(4022). integer(4023). integer(4024). integer(4025). integer(4026). integer(4027). integer(4028). integer(4029). integer(4030).
integer(5581). integer(5582). integer(5583). integer(5584). integer(5585). integer(5586). integer(5587). integer(5588). integer(5589). integer(5590).
integer(6961). integer(6962). integer(6963). integer(6964). integer(6965). integer(6966). integer(6967). integer(6968). integer(6969). integer(6970).
succ(56,57). succ(57,58). succ(58,59). succ(59,60). succ(60,61).
succ(66,67). succ(67,68). succ(68,69). succ(69,70). succ(70,71).
succ(106,107). succ(107,108). succ(108,109). succ(109,110). succ(110,111).
succ(226,227). succ(227,228). succ(228,229). succ(229,230). succ(230,231).
succ(251,252). succ(252,253). succ(253,254). succ(254,255). succ(255,256).
succ(256,257). succ(257,258). succ(258,259). succ(259,260). succ(260,261).
succ(271,272). succ(272,273). succ(273,274). succ(274,275). succ(275,276).
succ(571,572). succ(572,573). succ(573,574). succ(574,575). succ(575,576).
succ(971,972). succ(972,973). succ(973,974). succ(974,975). succ(975,976).
succ(1666,1667). succ(1667,1668). succ(1668,1669). succ(1669,1670). succ(1670,1671).
succ(2221,2222). succ(2222,2223). succ(2223,2224). succ(2224,2225). succ(2225,2226).
succ(2236,2237). succ(2237,2238). succ(2238,2239). succ(2239,2240). succ(2240,2241).
succ(2416,2417). succ(2417,2418). succ(2418,2419). succ(2419,2420). succ(2420,2421).
succ(2436,2437). succ(2437,2438). succ(2438,2439). succ(2439,2440). succ(2440,2441).
succ(4021,4022). succ(4022,4023). succ(4023,4024). succ(4024,4025). succ(4025,4026).
succ(5581,5582). succ(5582,5583). succ(5583,5584). succ(5584,5585). succ(5585,5586).
succ(6961,6962). succ(6962,6963). succ(6963,6964). succ(6964,6965). succ(6965,6966).
succ(6966,6967). succ(6967,6968). succ(6968,6969). succ(6969,6970). succ(6970,6971).
is_prime(2221). is_prime(2237). is_prime(2239). is_prime(2243). is_prime(2251). is_prime(2267). is_prime(2269). is_prime(2273). is_prime(2281). is_prime(2287).
is_prime(2437). is_prime(2441). is_prime(2447). is_prime(2459). is_prime(2467). is_prime(2473). is_prime(2477). is_prime(2503). is_prime(2521). is_prime(2531).
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