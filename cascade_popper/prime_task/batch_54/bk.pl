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
integer(401). integer(402). integer(403). integer(404). integer(405). integer(406). integer(407). integer(408). integer(409). integer(410).
integer(461). integer(462). integer(463). integer(464). integer(465). integer(466). integer(467). integer(468). integer(469). integer(470).
integer(971). integer(972). integer(973). integer(974). integer(975). integer(976). integer(977). integer(978). integer(979). integer(980).
integer(3491). integer(3492). integer(3493). integer(3494). integer(3495). integer(3496). integer(3497). integer(3498). integer(3499). integer(3500).
integer(3571). integer(3572). integer(3573). integer(3574). integer(3575). integer(3576). integer(3577). integer(3578). integer(3579). integer(3580).
succ(46,47). succ(47,48). succ(48,49). succ(49,50). succ(50,51).
succ(96,97). succ(97,98). succ(98,99). succ(99,100). succ(100,101).
succ(136,137). succ(137,138). succ(138,139). succ(139,140). succ(140,141).
succ(251,252). succ(252,253). succ(253,254). succ(254,255). succ(255,256).
succ(396,397). succ(397,398). succ(398,399). succ(399,400). succ(400,401).
succ(401,402). succ(402,403). succ(403,404). succ(404,405). succ(405,406).
succ(461,462). succ(462,463). succ(463,464). succ(464,465). succ(465,466).
succ(971,972). succ(972,973). succ(973,974). succ(974,975). succ(975,976).
succ(976,977). succ(977,978). succ(978,979). succ(979,980). succ(980,981).
succ(1486,1487). succ(1487,1488). succ(1488,1489). succ(1489,1490). succ(1490,1491).
succ(2356,2357). succ(2357,2358). succ(2358,2359). succ(2359,2360). succ(2360,2361).
succ(2376,2377). succ(2377,2378). succ(2378,2379). succ(2379,2380). succ(2380,2381).
succ(2466,2467). succ(2467,2468). succ(2468,2469). succ(2469,2470). succ(2470,2471).
succ(2886,2887). succ(2887,2888). succ(2888,2889). succ(2889,2890). succ(2890,2891).
succ(2896,2897). succ(2897,2898). succ(2898,2899). succ(2899,2900). succ(2900,2901).
succ(3491,3492). succ(3492,3493). succ(3493,3494). succ(3494,3495). succ(3495,3496).
succ(3571,3572). succ(3572,3573). succ(3573,3574). succ(3574,3575). succ(3575,3576).
succ(7536,7537). succ(7537,7538). succ(7538,7539). succ(7539,7540). succ(7540,7541).
is_prime(6763). is_prime(6779). is_prime(6781). is_prime(6791). is_prime(6793). is_prime(6803). is_prime(6823). is_prime(6827). is_prime(6829). is_prime(6833).
is_composite(159). is_composite(160). is_composite(161). is_composite(162). is_composite(164). is_composite(165). is_composite(166). is_composite(168). is_composite(169). is_composite(170).
is_composite(674). is_composite(675). is_composite(676). is_composite(678). is_composite(679). is_composite(680). is_composite(681). is_composite(682). is_composite(684). is_composite(685).
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