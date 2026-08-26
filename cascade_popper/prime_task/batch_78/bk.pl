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

integer(91). integer(92). integer(93). integer(94). integer(95). integer(96). integer(97). integer(98). integer(99). integer(100).
integer(601). integer(602). integer(603). integer(604). integer(605). integer(606). integer(607). integer(608). integer(609). integer(610).
integer(661). integer(662). integer(663). integer(664). integer(665). integer(666). integer(667). integer(668). integer(669). integer(670).
integer(2281). integer(2282). integer(2283). integer(2284). integer(2285). integer(2286). integer(2287). integer(2288). integer(2289). integer(2290).
integer(2411). integer(2412). integer(2413). integer(2414). integer(2415). integer(2416). integer(2417). integer(2418). integer(2419). integer(2420).
integer(3001). integer(3002). integer(3003). integer(3004). integer(3005). integer(3006). integer(3007). integer(3008). integer(3009). integer(3010).
integer(3631). integer(3632). integer(3633). integer(3634). integer(3635). integer(3636). integer(3637). integer(3638). integer(3639). integer(3640).
succ(6,7). succ(7,8). succ(8,9). succ(9,10). succ(10,11).
succ(16,17). succ(17,18). succ(18,19). succ(19,20). succ(20,21).
succ(91,92). succ(92,93). succ(93,94). succ(94,95). succ(95,96).
succ(96,97). succ(97,98). succ(98,99). succ(99,100). succ(100,101).
succ(156,157). succ(157,158). succ(158,159). succ(159,160). succ(160,161).
succ(166,167). succ(167,168). succ(168,169). succ(169,170). succ(170,171).
succ(196,197). succ(197,198). succ(198,199). succ(199,200). succ(200,201).
succ(336,337). succ(337,338). succ(338,339). succ(339,340). succ(340,341).
succ(601,602). succ(602,603). succ(603,604). succ(604,605). succ(605,606).
succ(661,662). succ(662,663). succ(663,664). succ(664,665). succ(665,666).
succ(756,757). succ(757,758). succ(758,759). succ(759,760). succ(760,761).
succ(786,787). succ(787,788). succ(788,789). succ(789,790). succ(790,791).
succ(906,907). succ(907,908). succ(908,909). succ(909,910). succ(910,911).
succ(2086,2087). succ(2087,2088). succ(2088,2089). succ(2089,2090). succ(2090,2091).
succ(2281,2282). succ(2282,2283). succ(2283,2284). succ(2284,2285). succ(2285,2286).
succ(2411,2412). succ(2412,2413). succ(2413,2414). succ(2414,2415). succ(2415,2416).
succ(2416,2417). succ(2417,2418). succ(2418,2419). succ(2419,2420). succ(2420,2421).
succ(3001,3002). succ(3002,3003). succ(3003,3004). succ(3004,3005). succ(3005,3006).
succ(3631,3632). succ(3632,3633). succ(3633,3634). succ(3634,3635). succ(3635,3636).
succ(3636,3637). succ(3637,3638). succ(3638,3639). succ(3639,3640). succ(3640,3641).
is_prime(353). is_prime(359). is_prime(367). is_prime(373). is_prime(379). is_prime(383). is_prime(389). is_prime(397). is_prime(401). is_prime(409).
is_prime(661). is_prime(673). is_prime(677). is_prime(683). is_prime(691). is_prime(701). is_prime(709). is_prime(719). is_prime(727). is_prime(733).
is_prime(2063). is_prime(2069). is_prime(2081). is_prime(2083). is_prime(2087). is_prime(2089). is_prime(2099). is_prime(2111). is_prime(2113). is_prime(2129).
is_prime(3001). is_prime(3011). is_prime(3019). is_prime(3023). is_prime(3037). is_prime(3041). is_prime(3049). is_prime(3061). is_prime(3067). is_prime(3079).
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