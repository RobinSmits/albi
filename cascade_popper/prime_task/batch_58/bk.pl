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

integer(61). integer(62). integer(63). integer(64). integer(65). integer(66). integer(67). integer(68). integer(69). integer(70).
integer(191). integer(192). integer(193). integer(194). integer(195). integer(196). integer(197). integer(198). integer(199). integer(200).
integer(251). integer(252). integer(253). integer(254). integer(255). integer(256). integer(257). integer(258). integer(259). integer(260).
integer(1231). integer(1232). integer(1233). integer(1234). integer(1235). integer(1236). integer(1237). integer(1238). integer(1239). integer(1240).
integer(3301). integer(3302). integer(3303). integer(3304). integer(3305). integer(3306). integer(3307). integer(3308). integer(3309). integer(3310).
integer(5791). integer(5792). integer(5793). integer(5794). integer(5795). integer(5796). integer(5797). integer(5798). integer(5799). integer(5800).
integer(6091). integer(6092). integer(6093). integer(6094). integer(6095). integer(6096). integer(6097). integer(6098). integer(6099). integer(6100).
succ(61,62). succ(62,63). succ(63,64). succ(64,65). succ(65,66).
succ(66,67). succ(67,68). succ(68,69). succ(69,70). succ(70,71).
succ(191,192). succ(192,193). succ(193,194). succ(194,195). succ(195,196).
succ(241,242). succ(242,243). succ(243,244). succ(244,245). succ(245,246).
succ(251,252). succ(252,253). succ(253,254). succ(254,255). succ(255,256).
succ(306,307). succ(307,308). succ(308,309). succ(309,310). succ(310,311).
succ(1231,1232). succ(1232,1233). succ(1233,1234). succ(1234,1235). succ(1235,1236).
succ(1626,1627). succ(1627,1628). succ(1628,1629). succ(1629,1630). succ(1630,1631).
succ(1776,1777). succ(1777,1778). succ(1778,1779). succ(1779,1780). succ(1780,1781).
succ(1846,1847). succ(1847,1848). succ(1848,1849). succ(1849,1850). succ(1850,1851).
succ(1866,1867). succ(1867,1868). succ(1868,1869). succ(1869,1870). succ(1870,1871).
succ(2646,2647). succ(2647,2648). succ(2648,2649). succ(2649,2650). succ(2650,2651).
succ(3166,3167). succ(3167,3168). succ(3168,3169). succ(3169,3170). succ(3170,3171).
succ(3301,3302). succ(3302,3303). succ(3303,3304). succ(3304,3305). succ(3305,3306).
succ(5791,5792). succ(5792,5793). succ(5793,5794). succ(5794,5795). succ(5795,5796).
succ(6091,6092). succ(6092,6093). succ(6093,6094). succ(6094,6095). succ(6095,6096).
is_prime(1229). is_prime(1231). is_prime(1237). is_prime(1249). is_prime(1259). is_prime(1277). is_prime(1279). is_prime(1283). is_prime(1289). is_prime(1291).
is_prime(4153). is_prime(4157). is_prime(4159). is_prime(4177). is_prime(4201). is_prime(4211). is_prime(4217). is_prime(4219). is_prime(4229). is_prime(4231).
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