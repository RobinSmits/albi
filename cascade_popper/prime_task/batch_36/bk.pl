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
integer(271). integer(272). integer(273). integer(274). integer(275). integer(276). integer(277). integer(278). integer(279). integer(280).
integer(691). integer(692). integer(693). integer(694). integer(695). integer(696). integer(697). integer(698). integer(699). integer(700).
integer(1471). integer(1472). integer(1473). integer(1474). integer(1475). integer(1476). integer(1477). integer(1478). integer(1479). integer(1480).
integer(2131). integer(2132). integer(2133). integer(2134). integer(2135). integer(2136). integer(2137). integer(2138). integer(2139). integer(2140).
integer(2731). integer(2732). integer(2733). integer(2734). integer(2735). integer(2736). integer(2737). integer(2738). integer(2739). integer(2740).
integer(6271). integer(6272). integer(6273). integer(6274). integer(6275). integer(6276). integer(6277). integer(6278). integer(6279). integer(6280).
integer(7621). integer(7622). integer(7623). integer(7624). integer(7625). integer(7626). integer(7627). integer(7628). integer(7629). integer(7630).
succ(101,102). succ(102,103). succ(103,104). succ(104,105). succ(105,106).
succ(166,167). succ(167,168). succ(168,169). succ(169,170). succ(170,171).
succ(191,192). succ(192,193). succ(193,194). succ(194,195). succ(195,196).
succ(271,272). succ(272,273). succ(273,274). succ(274,275). succ(275,276).
succ(276,277). succ(277,278). succ(278,279). succ(279,280). succ(280,281).
succ(396,397). succ(397,398). succ(398,399). succ(399,400). succ(400,401).
succ(691,692). succ(692,693). succ(693,694). succ(694,695). succ(695,696).
succ(1471,1472). succ(1472,1473). succ(1473,1474). succ(1474,1475). succ(1475,1476).
succ(1776,1777). succ(1777,1778). succ(1778,1779). succ(1779,1780). succ(1780,1781).
succ(2131,2132). succ(2132,2133). succ(2133,2134). succ(2134,2135). succ(2135,2136).
succ(2436,2437). succ(2437,2438). succ(2438,2439). succ(2439,2440). succ(2440,2441).
succ(2446,2447). succ(2447,2448). succ(2448,2449). succ(2449,2450). succ(2450,2451).
succ(2616,2617). succ(2617,2618). succ(2618,2619). succ(2619,2620). succ(2620,2621).
succ(2731,2732). succ(2732,2733). succ(2733,2734). succ(2734,2735). succ(2735,2736).
succ(3526,3527). succ(3527,3528). succ(3528,3529). succ(3529,3530). succ(3530,3531).
succ(6271,6272). succ(6272,6273). succ(6273,6274). succ(6274,6275). succ(6275,6276).
succ(7516,7517). succ(7517,7518). succ(7518,7519). succ(7519,7520). succ(7520,7521).
succ(7621,7622). succ(7622,7623). succ(7623,7624). succ(7624,7625). succ(7625,7626).
is_prime(2131). is_prime(2137). is_prime(2141). is_prime(2143). is_prime(2153). is_prime(2161). is_prime(2179). is_prime(2203). is_prime(2207). is_prime(2213).
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