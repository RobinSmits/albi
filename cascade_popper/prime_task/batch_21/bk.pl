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

integer(101). integer(102). integer(103). integer(104). integer(105). integer(106). integer(107). integer(108). integer(109). integer(110).
integer(191). integer(192). integer(193). integer(194). integer(195). integer(196). integer(197). integer(198). integer(199). integer(200).
integer(251). integer(252). integer(253). integer(254). integer(255). integer(256). integer(257). integer(258). integer(259). integer(260).
integer(271). integer(272). integer(273). integer(274). integer(275). integer(276). integer(277). integer(278). integer(279). integer(280).
integer(281). integer(282). integer(283). integer(284). integer(285). integer(286). integer(287). integer(288). integer(289). integer(290).
integer(331). integer(332). integer(333). integer(334). integer(335). integer(336). integer(337). integer(338). integer(339). integer(340).
integer(1361). integer(1362). integer(1363). integer(1364). integer(1365). integer(1366). integer(1367). integer(1368). integer(1369). integer(1370).
integer(1451). integer(1452). integer(1453). integer(1454). integer(1455). integer(1456). integer(1457). integer(1458). integer(1459). integer(1460).
integer(2671). integer(2672). integer(2673). integer(2674). integer(2675). integer(2676). integer(2677). integer(2678). integer(2679). integer(2680).
integer(3181). integer(3182). integer(3183). integer(3184). integer(3185). integer(3186). integer(3187). integer(3188). integer(3189). integer(3190).
integer(3391). integer(3392). integer(3393). integer(3394). integer(3395). integer(3396). integer(3397). integer(3398). integer(3399). integer(3400).
integer(4391). integer(4392). integer(4393). integer(4394). integer(4395). integer(4396). integer(4397). integer(4398). integer(4399). integer(4400).
integer(7451). integer(7452). integer(7453). integer(7454). integer(7455). integer(7456). integer(7457). integer(7458). integer(7459). integer(7460).
succ(101,102). succ(102,103). succ(103,104). succ(104,105). succ(105,106).
succ(106,107). succ(107,108). succ(108,109). succ(109,110). succ(110,111).
succ(191,192). succ(192,193). succ(193,194). succ(194,195). succ(195,196).
succ(251,252). succ(252,253). succ(253,254). succ(254,255). succ(255,256).
succ(271,272). succ(272,273). succ(273,274). succ(274,275). succ(275,276).
succ(281,282). succ(282,283). succ(283,284). succ(284,285). succ(285,286).
succ(331,332). succ(332,333). succ(333,334). succ(334,335). succ(335,336).
succ(336,337). succ(337,338). succ(338,339). succ(339,340). succ(340,341).
succ(546,547). succ(547,548). succ(548,549). succ(549,550). succ(550,551).
succ(1361,1362). succ(1362,1363). succ(1363,1364). succ(1364,1365). succ(1365,1366).
succ(1451,1452). succ(1452,1453). succ(1453,1454). succ(1454,1455). succ(1455,1456).
succ(2476,2477). succ(2477,2478). succ(2478,2479). succ(2479,2480). succ(2480,2481).
succ(2671,2672). succ(2672,2673). succ(2673,2674). succ(2674,2675). succ(2675,2676).
succ(2676,2677). succ(2677,2678). succ(2678,2679). succ(2679,2680). succ(2680,2681).
succ(2836,2837). succ(2837,2838). succ(2838,2839). succ(2839,2840). succ(2840,2841).
succ(3181,3182). succ(3182,3183). succ(3183,3184). succ(3184,3185). succ(3185,3186).
succ(3391,3392). succ(3392,3393). succ(3393,3394). succ(3394,3395). succ(3395,3396).
succ(3406,3407). succ(3407,3408). succ(3408,3409). succ(3409,3410). succ(3410,3411).
succ(4391,4392). succ(4392,4393). succ(4393,4394). succ(4394,4395). succ(4395,4396).
succ(7451,7452). succ(7452,7453). succ(7453,7454). succ(7454,7455). succ(7455,7456).
succ(7456,7457). succ(7457,7458). succ(7458,7459). succ(7459,7460). succ(7460,7461).
is_prime(73). is_prime(79). is_prime(83). is_prime(89). is_prime(97). is_prime(101). is_prime(103). is_prime(107). is_prime(109). is_prime(113).
is_prime(547). is_prime(557). is_prime(563). is_prime(569). is_prime(571). is_prime(577). is_prime(587). is_prime(593). is_prime(599). is_prime(601).
is_prime(1453). is_prime(1459). is_prime(1471). is_prime(1481). is_prime(1483). is_prime(1487). is_prime(1489). is_prime(1493). is_prime(1499). is_prime(1511).
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