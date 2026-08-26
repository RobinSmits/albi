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

integer(241). integer(242). integer(243). integer(244). integer(245). integer(246). integer(247). integer(248). integer(249). integer(250).
integer(251). integer(252). integer(253). integer(254). integer(255). integer(256). integer(257). integer(258). integer(259). integer(260).
integer(571). integer(572). integer(573). integer(574). integer(575). integer(576). integer(577). integer(578). integer(579). integer(580).
integer(911). integer(912). integer(913). integer(914). integer(915). integer(916). integer(917). integer(918). integer(919). integer(920).
integer(2111). integer(2112). integer(2113). integer(2114). integer(2115). integer(2116). integer(2117). integer(2118). integer(2119). integer(2120).
integer(2341). integer(2342). integer(2343). integer(2344). integer(2345). integer(2346). integer(2347). integer(2348). integer(2349). integer(2350).
integer(3371). integer(3372). integer(3373). integer(3374). integer(3375). integer(3376). integer(3377). integer(3378). integer(3379). integer(3380).
succ(111,112). succ(112,113). succ(113,114). succ(114,115). succ(115,116).
succ(241,242). succ(242,243). succ(243,244). succ(244,245). succ(245,246).
succ(251,252). succ(252,253). succ(253,254). succ(254,255). succ(255,256).
succ(346,347). succ(347,348). succ(348,349). succ(349,350). succ(350,351).
succ(466,467). succ(467,468). succ(468,469). succ(469,470). succ(470,471).
succ(571,572). succ(572,573). succ(573,574). succ(574,575). succ(575,576).
succ(886,887). succ(887,888). succ(888,889). succ(889,890). succ(890,891).
succ(911,912). succ(912,913). succ(913,914). succ(914,915). succ(915,916).
succ(996,997). succ(997,998). succ(998,999). succ(999,1000). succ(1000,1001).
succ(1296,1297). succ(1297,1298). succ(1298,1299). succ(1299,1300). succ(1300,1301).
succ(1306,1307). succ(1307,1308). succ(1308,1309). succ(1309,1310). succ(1310,1311).
succ(1656,1657). succ(1657,1658). succ(1658,1659). succ(1659,1660). succ(1660,1661).
succ(2026,2027). succ(2027,2028). succ(2028,2029). succ(2029,2030). succ(2030,2031).
succ(2111,2112). succ(2112,2113). succ(2113,2114). succ(2114,2115). succ(2115,2116).
succ(2206,2207). succ(2207,2208). succ(2208,2209). succ(2209,2210). succ(2210,2211).
succ(2341,2342). succ(2342,2343). succ(2343,2344). succ(2344,2345). succ(2345,2346).
succ(2686,2687). succ(2687,2688). succ(2688,2689). succ(2689,2690). succ(2690,2691).
succ(3306,3307). succ(3307,3308). succ(3308,3309). succ(3309,3310). succ(3310,3311).
succ(3371,3372). succ(3372,3373). succ(3373,3374). succ(3374,3375). succ(3375,3376).
succ(4636,4637). succ(4637,4638). succ(4638,4639). succ(4639,4640). succ(4640,4641).
is_prime(467). is_prime(479). is_prime(487). is_prime(491). is_prime(499). is_prime(503). is_prime(509). is_prime(521). is_prime(523). is_prime(541).
is_prime(1297). is_prime(1301). is_prime(1303). is_prime(1307). is_prime(1319). is_prime(1321). is_prime(1327). is_prime(1361). is_prime(1367). is_prime(1373).
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