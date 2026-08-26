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

integer(81). integer(82). integer(83). integer(84). integer(85). integer(86). integer(87). integer(88). integer(89). integer(90).
integer(2251). integer(2252). integer(2253). integer(2254). integer(2255). integer(2256). integer(2257). integer(2258). integer(2259). integer(2260).
integer(3851). integer(3852). integer(3853). integer(3854). integer(3855). integer(3856). integer(3857). integer(3858). integer(3859). integer(3860).
integer(6781). integer(6782). integer(6783). integer(6784). integer(6785). integer(6786). integer(6787). integer(6788). integer(6789). integer(6790).
integer(6791). integer(6792). integer(6793). integer(6794). integer(6795). integer(6796). integer(6797). integer(6798). integer(6799). integer(6800).
integer(6911). integer(6912). integer(6913). integer(6914). integer(6915). integer(6916). integer(6917). integer(6918). integer(6919). integer(6920).
integer(7561). integer(7562). integer(7563). integer(7564). integer(7565). integer(7566). integer(7567). integer(7568). integer(7569). integer(7570).
succ(81,82). succ(82,83). succ(83,84). succ(84,85). succ(85,86).
succ(151,152). succ(152,153). succ(153,154). succ(154,155). succ(155,156).
succ(156,157). succ(157,158). succ(158,159). succ(159,160). succ(160,161).
succ(226,227). succ(227,228). succ(228,229). succ(229,230). succ(230,231).
succ(856,857). succ(857,858). succ(858,859). succ(859,860). succ(860,861).
succ(886,887). succ(887,888). succ(888,889). succ(889,890). succ(890,891).
succ(1236,1237). succ(1237,1238). succ(1238,1239). succ(1239,1240). succ(1240,1241).
succ(2251,2252). succ(2252,2253). succ(2253,2254). succ(2254,2255). succ(2255,2256).
succ(2266,2267). succ(2267,2268). succ(2268,2269). succ(2269,2270). succ(2270,2271).
succ(2446,2447). succ(2447,2448). succ(2448,2449). succ(2449,2450). succ(2450,2451).
succ(2466,2467). succ(2467,2468). succ(2468,2469). succ(2469,2470). succ(2470,2471).
succ(2686,2687). succ(2687,2688). succ(2688,2689). succ(2689,2690). succ(2690,2691).
succ(3846,3847). succ(3847,3848). succ(3848,3849). succ(3849,3850). succ(3850,3851).
succ(3851,3852). succ(3852,3853). succ(3853,3854). succ(3854,3855). succ(3855,3856).
succ(6286,6287). succ(6287,6288). succ(6288,6289). succ(6289,6290). succ(6290,6291).
succ(6781,6782). succ(6782,6783). succ(6783,6784). succ(6784,6785). succ(6785,6786).
succ(6791,6792). succ(6792,6793). succ(6793,6794). succ(6794,6795). succ(6795,6796).
succ(6911,6912). succ(6912,6913). succ(6913,6914). succ(6914,6915). succ(6915,6916).
succ(6916,6917). succ(6917,6918). succ(6918,6919). succ(6919,6920). succ(6920,6921).
succ(7561,7562). succ(7562,7563). succ(7563,7564). succ(7564,7565). succ(7565,7566).
is_prime(7573). is_prime(7577). is_prime(7583). is_prime(7589). is_prime(7591). is_prime(7603). is_prime(7607). is_prime(7621). is_prime(7639). is_prime(7643).
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