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

integer(191). integer(192). integer(193). integer(194). integer(195). integer(196). integer(197). integer(198). integer(199). integer(200).
integer(311). integer(312). integer(313). integer(314). integer(315). integer(316). integer(317). integer(318). integer(319). integer(320).
integer(401). integer(402). integer(403). integer(404). integer(405). integer(406). integer(407). integer(408). integer(409). integer(410).
integer(631). integer(632). integer(633). integer(634). integer(635). integer(636). integer(637). integer(638). integer(639). integer(640).
integer(1301). integer(1302). integer(1303). integer(1304). integer(1305). integer(1306). integer(1307). integer(1308). integer(1309). integer(1310).
integer(2251). integer(2252). integer(2253). integer(2254). integer(2255). integer(2256). integer(2257). integer(2258). integer(2259). integer(2260).
integer(4951). integer(4952). integer(4953). integer(4954). integer(4955). integer(4956). integer(4957). integer(4958). integer(4959). integer(4960).
integer(5641). integer(5642). integer(5643). integer(5644). integer(5645). integer(5646). integer(5647). integer(5648). integer(5649). integer(5650).
succ(166,167). succ(167,168). succ(168,169). succ(169,170). succ(170,171).
succ(191,192). succ(192,193). succ(193,194). succ(194,195). succ(195,196).
succ(306,307). succ(307,308). succ(308,309). succ(309,310). succ(310,311).
succ(311,312). succ(312,313). succ(313,314). succ(314,315). succ(315,316).
succ(401,402). succ(402,403). succ(403,404). succ(404,405). succ(405,406).
succ(631,632). succ(632,633). succ(633,634). succ(634,635). succ(635,636).
succ(1276,1277). succ(1277,1278). succ(1278,1279). succ(1279,1280). succ(1280,1281).
succ(1301,1302). succ(1302,1303). succ(1303,1304). succ(1304,1305). succ(1305,1306).
succ(2251,2252). succ(2252,2253). succ(2253,2254). succ(2254,2255). succ(2255,2256).
succ(2266,2267). succ(2267,2268). succ(2268,2269). succ(2269,2270). succ(2270,2271).
succ(4546,4547). succ(4547,4548). succ(4548,4549). succ(4549,4550). succ(4550,4551).
succ(4951,4952). succ(4952,4953). succ(4953,4954). succ(4954,4955). succ(4955,4956).
succ(5416,5417). succ(5417,5418). succ(5418,5419). succ(5419,5420). succ(5420,5421).
succ(5641,5642). succ(5642,5643). succ(5643,5644). succ(5644,5645). succ(5645,5646).
is_prime(2833). is_prime(2837). is_prime(2843). is_prime(2851). is_prime(2857). is_prime(2861). is_prime(2879). is_prime(2887). is_prime(2897). is_prime(2903).
is_prime(4943). is_prime(4951). is_prime(4957). is_prime(4967). is_prime(4969). is_prime(4973). is_prime(4987). is_prime(4993). is_prime(4999). is_prime(5003).
is_prime(5641). is_prime(5647). is_prime(5651). is_prime(5653). is_prime(5657). is_prime(5659). is_prime(5669). is_prime(5683). is_prime(5689). is_prime(5693).
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