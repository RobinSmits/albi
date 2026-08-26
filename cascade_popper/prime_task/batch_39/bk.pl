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

integer(461). integer(462). integer(463). integer(464). integer(465). integer(466). integer(467). integer(468). integer(469). integer(470).
integer(811). integer(812). integer(813). integer(814). integer(815). integer(816). integer(817). integer(818). integer(819). integer(820).
integer(2251). integer(2252). integer(2253). integer(2254). integer(2255). integer(2256). integer(2257). integer(2258). integer(2259). integer(2260).
integer(2861). integer(2862). integer(2863). integer(2864). integer(2865). integer(2866). integer(2867). integer(2868). integer(2869). integer(2870).
integer(3931). integer(3932). integer(3933). integer(3934). integer(3935). integer(3936). integer(3937). integer(3938). integer(3939). integer(3940).
integer(4111). integer(4112). integer(4113). integer(4114). integer(4115). integer(4116). integer(4117). integer(4118). integer(4119). integer(4120).
succ(36,37). succ(37,38). succ(38,39). succ(39,40). succ(40,41).
succ(316,317). succ(317,318). succ(318,319). succ(319,320). succ(320,321).
succ(461,462). succ(462,463). succ(463,464). succ(464,465). succ(465,466).
succ(486,487). succ(487,488). succ(488,489). succ(489,490). succ(490,491).
succ(796,797). succ(797,798). succ(798,799). succ(799,800). succ(800,801).
succ(811,812). succ(812,813). succ(813,814). succ(814,815). succ(815,816).
succ(996,997). succ(997,998). succ(998,999). succ(999,1000). succ(1000,1001).
succ(1236,1237). succ(1237,1238). succ(1238,1239). succ(1239,1240). succ(1240,1241).
succ(2236,2237). succ(2237,2238). succ(2238,2239). succ(2239,2240). succ(2240,2241).
succ(2251,2252). succ(2252,2253). succ(2253,2254). succ(2254,2255). succ(2255,2256).
succ(2856,2857). succ(2857,2858). succ(2858,2859). succ(2859,2860). succ(2860,2861).
succ(2861,2862). succ(2862,2863). succ(2863,2864). succ(2864,2865). succ(2865,2866).
succ(3456,3457). succ(3457,3458). succ(3458,3459). succ(3459,3460). succ(3460,3461).
succ(3931,3932). succ(3932,3933). succ(3933,3934). succ(3934,3935). succ(3935,3936).
succ(4111,4112). succ(4112,4113). succ(4113,4114). succ(4114,4115). succ(4115,4116).
succ(4126,4127). succ(4127,4128). succ(4128,4129). succ(4129,4130). succ(4130,4131).
is_prime(233). is_prime(239). is_prime(241). is_prime(251). is_prime(257). is_prime(263). is_prime(269). is_prime(271). is_prime(277). is_prime(281).
is_prime(811). is_prime(821). is_prime(823). is_prime(827). is_prime(829). is_prime(839). is_prime(853). is_prime(857). is_prime(859). is_prime(863).
is_composite(318). is_composite(319). is_composite(320). is_composite(321). is_composite(322). is_composite(323). is_composite(324). is_composite(325). is_composite(326). is_composite(327).
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