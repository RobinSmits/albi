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
integer(271). integer(272). integer(273). integer(274). integer(275). integer(276). integer(277). integer(278). integer(279). integer(280).
integer(571). integer(572). integer(573). integer(574). integer(575). integer(576). integer(577). integer(578). integer(579). integer(580).
integer(631). integer(632). integer(633). integer(634). integer(635). integer(636). integer(637). integer(638). integer(639). integer(640).
integer(1061). integer(1062). integer(1063). integer(1064). integer(1065). integer(1066). integer(1067). integer(1068). integer(1069). integer(1070).
integer(2371). integer(2372). integer(2373). integer(2374). integer(2375). integer(2376). integer(2377). integer(2378). integer(2379). integer(2380).
integer(2381). integer(2382). integer(2383). integer(2384). integer(2385). integer(2386). integer(2387). integer(2388). integer(2389). integer(2390).
integer(2591). integer(2592). integer(2593). integer(2594). integer(2595). integer(2596). integer(2597). integer(2598). integer(2599). integer(2600).
integer(3251). integer(3252). integer(3253). integer(3254). integer(3255). integer(3256). integer(3257). integer(3258). integer(3259). integer(3260).
integer(7841). integer(7842). integer(7843). integer(7844). integer(7845). integer(7846). integer(7847). integer(7848). integer(7849). integer(7850).
succ(96,97). succ(97,98). succ(98,99). succ(99,100). succ(100,101).
succ(166,167). succ(167,168). succ(168,169). succ(169,170). succ(170,171).
succ(241,242). succ(242,243). succ(243,244). succ(244,245). succ(245,246).
succ(271,272). succ(272,273). succ(273,274). succ(274,275). succ(275,276).
succ(571,572). succ(572,573). succ(573,574). succ(574,575). succ(575,576).
succ(586,587). succ(587,588). succ(588,589). succ(589,590). succ(590,591).
succ(631,632). succ(632,633). succ(633,634). succ(634,635). succ(635,636).
succ(1061,1062). succ(1062,1063). succ(1063,1064). succ(1064,1065). succ(1065,1066).
succ(2371,2372). succ(2372,2373). succ(2373,2374). succ(2374,2375). succ(2375,2376).
succ(2381,2382). succ(2382,2383). succ(2383,2384). succ(2384,2385). succ(2385,2386).
succ(2591,2592). succ(2592,2593). succ(2593,2594). succ(2594,2595). succ(2595,2596).
succ(2926,2927). succ(2927,2928). succ(2928,2929). succ(2929,2930). succ(2930,2931).
succ(3251,3252). succ(3252,3253). succ(3253,3254). succ(3254,3255). succ(3255,3256).
succ(5656,5657). succ(5657,5658). succ(5658,5659). succ(5659,5660). succ(5660,5661).
succ(5896,5897). succ(5897,5898). succ(5898,5899). succ(5899,5900). succ(5900,5901).
succ(7841,7842). succ(7842,7843). succ(7843,7844). succ(7844,7845). succ(7845,7846).
is_prime(1153). is_prime(1163). is_prime(1171). is_prime(1181). is_prime(1187). is_prime(1193). is_prime(1201). is_prime(1213). is_prime(1217). is_prime(1223).
is_prime(2371). is_prime(2377). is_prime(2381). is_prime(2383). is_prime(2389). is_prime(2393). is_prime(2399). is_prime(2411). is_prime(2417). is_prime(2423).
is_prime(2539). is_prime(2543). is_prime(2549). is_prime(2551). is_prime(2557). is_prime(2579). is_prime(2591). is_prime(2593). is_prime(2609). is_prime(2617).
is_prime(7841). is_prime(7853). is_prime(7867). is_prime(7873). is_prime(7877). is_prime(7879). is_prime(7883). is_prime(7901). is_prime(7907). is_prime(7919).
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