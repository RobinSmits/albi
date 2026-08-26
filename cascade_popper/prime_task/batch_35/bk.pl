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

integer(431). integer(432). integer(433). integer(434). integer(435). integer(436). integer(437). integer(438). integer(439). integer(440).
integer(521). integer(522). integer(523). integer(524). integer(525). integer(526). integer(527). integer(528). integer(529). integer(530).
integer(541). integer(542). integer(543). integer(544). integer(545). integer(546). integer(547). integer(548). integer(549). integer(550).
integer(821). integer(822). integer(823). integer(824). integer(825). integer(826). integer(827). integer(828). integer(829). integer(830).
integer(911). integer(912). integer(913). integer(914). integer(915). integer(916). integer(917). integer(918). integer(919). integer(920).
integer(1021). integer(1022). integer(1023). integer(1024). integer(1025). integer(1026). integer(1027). integer(1028). integer(1029). integer(1030).
integer(1031). integer(1032). integer(1033). integer(1034). integer(1035). integer(1036). integer(1037). integer(1038). integer(1039). integer(1040).
integer(2161). integer(2162). integer(2163). integer(2164). integer(2165). integer(2166). integer(2167). integer(2168). integer(2169). integer(2170).
integer(2281). integer(2282). integer(2283). integer(2284). integer(2285). integer(2286). integer(2287). integer(2288). integer(2289). integer(2290).
integer(2531). integer(2532). integer(2533). integer(2534). integer(2535). integer(2536). integer(2537). integer(2538). integer(2539). integer(2540).
integer(3881). integer(3882). integer(3883). integer(3884). integer(3885). integer(3886). integer(3887). integer(3888). integer(3889). integer(3890).
integer(4801). integer(4802). integer(4803). integer(4804). integer(4805). integer(4806). integer(4807). integer(4808). integer(4809). integer(4810).
succ(36,37). succ(37,38). succ(38,39). succ(39,40). succ(40,41).
succ(126,127). succ(127,128). succ(128,129). succ(129,130). succ(130,131).
succ(156,157). succ(157,158). succ(158,159). succ(159,160). succ(160,161).
succ(226,227). succ(227,228). succ(228,229). succ(229,230). succ(230,231).
succ(316,317). succ(317,318). succ(318,319). succ(319,320). succ(320,321).
succ(431,432). succ(432,433). succ(433,434). succ(434,435). succ(435,436).
succ(521,522). succ(522,523). succ(523,524). succ(524,525). succ(525,526).
succ(541,542). succ(542,543). succ(543,544). succ(544,545). succ(545,546).
succ(821,822). succ(822,823). succ(823,824). succ(824,825). succ(825,826).
succ(911,912). succ(912,913). succ(913,914). succ(914,915). succ(915,916).
succ(936,937). succ(937,938). succ(938,939). succ(939,940). succ(940,941).
succ(946,947). succ(947,948). succ(948,949). succ(949,950). succ(950,951).
succ(1021,1022). succ(1022,1023). succ(1023,1024). succ(1024,1025). succ(1025,1026).
succ(1031,1032). succ(1032,1033). succ(1033,1034). succ(1034,1035). succ(1035,1036).
succ(2161,2162). succ(2162,2163). succ(2163,2164). succ(2164,2165). succ(2165,2166).
succ(2281,2282). succ(2282,2283). succ(2283,2284). succ(2284,2285). succ(2285,2286).
succ(2286,2287). succ(2287,2288). succ(2288,2289). succ(2289,2290). succ(2290,2291).
succ(2531,2532). succ(2532,2533). succ(2533,2534). succ(2534,2535). succ(2535,2536).
succ(3876,3877). succ(3877,3878). succ(3878,3879). succ(3879,3880). succ(3880,3881).
succ(3881,3882). succ(3882,3883). succ(3883,3884). succ(3884,3885). succ(3885,3886).
succ(4801,4802). succ(4802,4803). succ(4803,4804). succ(4804,4805). succ(4805,4806).
is_prime(127). is_prime(131). is_prime(137). is_prime(139). is_prime(149). is_prime(151). is_prime(157). is_prime(163). is_prime(167). is_prime(173).
is_prime(419). is_prime(421). is_prime(431). is_prime(433). is_prime(439). is_prime(443). is_prime(449). is_prime(457). is_prime(461). is_prime(463).
is_prime(947). is_prime(953). is_prime(967). is_prime(971). is_prime(977). is_prime(983). is_prime(991). is_prime(997). is_prime(1009). is_prime(1013).
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