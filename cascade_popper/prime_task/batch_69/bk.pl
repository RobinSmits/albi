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

integer(271). integer(272). integer(273). integer(274). integer(275). integer(276). integer(277). integer(278). integer(279). integer(280).
integer(421). integer(422). integer(423). integer(424). integer(425). integer(426). integer(427). integer(428). integer(429). integer(430).
integer(1181). integer(1182). integer(1183). integer(1184). integer(1185). integer(1186). integer(1187). integer(1188). integer(1189). integer(1190).
integer(2081). integer(2082). integer(2083). integer(2084). integer(2085). integer(2086). integer(2087). integer(2088). integer(2089). integer(2090).
integer(2711). integer(2712). integer(2713). integer(2714). integer(2715). integer(2716). integer(2717). integer(2718). integer(2719). integer(2720).
integer(3301). integer(3302). integer(3303). integer(3304). integer(3305). integer(3306). integer(3307). integer(3308). integer(3309). integer(3310).
integer(4241). integer(4242). integer(4243). integer(4244). integer(4245). integer(4246). integer(4247). integer(4248). integer(4249). integer(4250).
succ(271,272). succ(272,273). succ(273,274). succ(274,275). succ(275,276).
succ(336,337). succ(337,338). succ(338,339). succ(339,340). succ(340,341).
succ(421,422). succ(422,423). succ(423,424). succ(424,425). succ(425,426).
succ(676,677). succ(677,678). succ(678,679). succ(679,680). succ(680,681).
succ(996,997). succ(997,998). succ(998,999). succ(999,1000). succ(1000,1001).
succ(1181,1182). succ(1182,1183). succ(1183,1184). succ(1184,1185). succ(1185,1186).
succ(1606,1607). succ(1607,1608). succ(1608,1609). succ(1609,1610). succ(1610,1611).
succ(2081,2082). succ(2082,2083). succ(2083,2084). succ(2084,2085). succ(2085,2086).
succ(2236,2237). succ(2237,2238). succ(2238,2239). succ(2239,2240). succ(2240,2241).
succ(2711,2712). succ(2712,2713). succ(2713,2714). succ(2714,2715). succ(2715,2716).
succ(3301,3302). succ(3302,3303). succ(3303,3304). succ(3304,3305). succ(3305,3306).
succ(3306,3307). succ(3307,3308). succ(3308,3309). succ(3309,3310). succ(3310,3311).
succ(4006,4007). succ(4007,4008). succ(4008,4009). succ(4009,4010). succ(4010,4011).
succ(4241,4242). succ(4242,4243). succ(4243,4244). succ(4244,4245). succ(4245,4246).
succ(4356,4357). succ(4357,4358). succ(4358,4359). succ(4359,4360). succ(4360,4361).
succ(5866,5867). succ(5867,5868). succ(5868,5869). succ(5869,5870). succ(5870,5871).
is_prime(419). is_prime(421). is_prime(431). is_prime(433). is_prime(439). is_prime(443). is_prime(449). is_prime(457). is_prime(461). is_prime(463).
is_prime(3433). is_prime(3449). is_prime(3457). is_prime(3461). is_prime(3463). is_prime(3467). is_prime(3469). is_prime(3491). is_prime(3499). is_prime(3511).
is_prime(4241). is_prime(4243). is_prime(4253). is_prime(4259). is_prime(4261). is_prime(4271). is_prime(4273). is_prime(4283). is_prime(4289). is_prime(4297).
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