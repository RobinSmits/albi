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
integer(211). integer(212). integer(213). integer(214). integer(215). integer(216). integer(217). integer(218). integer(219). integer(220).
integer(461). integer(462). integer(463). integer(464). integer(465). integer(466). integer(467). integer(468). integer(469). integer(470).
integer(541). integer(542). integer(543). integer(544). integer(545). integer(546). integer(547). integer(548). integer(549). integer(550).
integer(1321). integer(1322). integer(1323). integer(1324). integer(1325). integer(1326). integer(1327). integer(1328). integer(1329). integer(1330).
integer(1361). integer(1362). integer(1363). integer(1364). integer(1365). integer(1366). integer(1367). integer(1368). integer(1369). integer(1370).
integer(1481). integer(1482). integer(1483). integer(1484). integer(1485). integer(1486). integer(1487). integer(1488). integer(1489). integer(1490).
integer(2521). integer(2522). integer(2523). integer(2524). integer(2525). integer(2526). integer(2527). integer(2528). integer(2529). integer(2530).
integer(3251). integer(3252). integer(3253). integer(3254). integer(3255). integer(3256). integer(3257). integer(3258). integer(3259). integer(3260).
integer(5501). integer(5502). integer(5503). integer(5504). integer(5505). integer(5506). integer(5507). integer(5508). integer(5509). integer(5510).
integer(5531). integer(5532). integer(5533). integer(5534). integer(5535). integer(5536). integer(5537). integer(5538). integer(5539). integer(5540).
succ(71,72). succ(72,73). succ(73,74). succ(74,75). succ(75,76).
succ(211,212). succ(212,213). succ(213,214). succ(214,215). succ(215,216).
succ(226,227). succ(227,228). succ(228,229). succ(229,230). succ(230,231).
succ(456,457). succ(457,458). succ(458,459). succ(459,460). succ(460,461).
succ(461,462). succ(462,463). succ(463,464). succ(464,465). succ(465,466).
succ(541,542). succ(542,543). succ(543,544). succ(544,545). succ(545,546).
succ(546,547). succ(547,548). succ(548,549). succ(549,550). succ(550,551).
succ(1086,1087). succ(1087,1088). succ(1088,1089). succ(1089,1090). succ(1090,1091).
succ(1216,1217). succ(1217,1218). succ(1218,1219). succ(1219,1220). succ(1220,1221).
succ(1321,1322). succ(1322,1323). succ(1323,1324). succ(1324,1325). succ(1325,1326).
succ(1361,1362). succ(1362,1363). succ(1363,1364). succ(1364,1365). succ(1365,1366).
succ(1426,1427). succ(1427,1428). succ(1428,1429). succ(1429,1430). succ(1430,1431).
succ(1481,1482). succ(1482,1483). succ(1483,1484). succ(1484,1485). succ(1485,1486).
succ(1696,1697). succ(1697,1698). succ(1698,1699). succ(1699,1700). succ(1700,1701).
succ(2521,2522). succ(2522,2523). succ(2523,2524). succ(2524,2525). succ(2525,2526).
succ(3251,3252). succ(3252,3253). succ(3253,3254). succ(3254,3255). succ(3255,3256).
succ(3846,3847). succ(3847,3848). succ(3848,3849). succ(3849,3850). succ(3850,3851).
succ(5501,5502). succ(5502,5503). succ(5503,5504). succ(5504,5505). succ(5505,5506).
succ(5531,5532). succ(5532,5533). succ(5533,5534). succ(5534,5535). succ(5535,5536).
succ(5556,5557). succ(5557,5558). succ(5558,5559). succ(5559,5560). succ(5560,5561).
succ(5656,5657). succ(5657,5658). succ(5658,5659). succ(5659,5660). succ(5660,5661).
is_prime(547). is_prime(557). is_prime(563). is_prime(569). is_prime(571). is_prime(577). is_prime(587). is_prime(593). is_prime(599). is_prime(601).
is_prime(1087). is_prime(1091). is_prime(1093). is_prime(1097). is_prime(1103). is_prime(1109). is_prime(1117). is_prime(1123). is_prime(1129). is_prime(1151).
is_prime(1823). is_prime(1831). is_prime(1847). is_prime(1861). is_prime(1867). is_prime(1871). is_prime(1873). is_prime(1877). is_prime(1879). is_prime(1889).
is_composite(208). is_composite(209). is_composite(210). is_composite(212). is_composite(213). is_composite(214). is_composite(215). is_composite(216). is_composite(217). is_composite(218).
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