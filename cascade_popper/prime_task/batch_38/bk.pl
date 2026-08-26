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

integer(211). integer(212). integer(213). integer(214). integer(215). integer(216). integer(217). integer(218). integer(219). integer(220).
integer(641). integer(642). integer(643). integer(644). integer(645). integer(646). integer(647). integer(648). integer(649). integer(650).
integer(3061). integer(3062). integer(3063). integer(3064). integer(3065). integer(3066). integer(3067). integer(3068). integer(3069). integer(3070).
integer(5851). integer(5852). integer(5853). integer(5854). integer(5855). integer(5856). integer(5857). integer(5858). integer(5859). integer(5860).
integer(5861). integer(5862). integer(5863). integer(5864). integer(5865). integer(5866). integer(5867). integer(5868). integer(5869). integer(5870).
integer(5981). integer(5982). integer(5983). integer(5984). integer(5985). integer(5986). integer(5987). integer(5988). integer(5989). integer(5990).
integer(7591). integer(7592). integer(7593). integer(7594). integer(7595). integer(7596). integer(7597). integer(7598). integer(7599). integer(7600).
succ(16,17). succ(17,18). succ(18,19). succ(19,20). succ(20,21).
succ(51,52). succ(52,53). succ(53,54). succ(54,55). succ(55,56).
succ(126,127). succ(127,128). succ(128,129). succ(129,130). succ(130,131).
succ(201,202). succ(202,203). succ(203,204). succ(204,205). succ(205,206).
succ(211,212). succ(212,213). succ(213,214). succ(214,215). succ(215,216).
succ(251,252). succ(252,253). succ(253,254). succ(254,255). succ(255,256).
succ(256,257). succ(257,258). succ(258,259). succ(259,260). succ(260,261).
succ(641,642). succ(642,643). succ(643,644). succ(644,645). succ(645,646).
succ(2916,2917). succ(2917,2918). succ(2918,2919). succ(2919,2920). succ(2920,2921).
succ(2926,2927). succ(2927,2928). succ(2928,2929). succ(2929,2930). succ(2930,2931).
succ(3061,3062). succ(3062,3063). succ(3063,3064). succ(3064,3065). succ(3065,3066).
succ(3256,3257). succ(3257,3258). succ(3258,3259). succ(3259,3260). succ(3260,3261).
succ(5146,5147). succ(5147,5148). succ(5148,5149). succ(5149,5150). succ(5150,5151).
succ(5346,5347). succ(5347,5348). succ(5348,5349). succ(5349,5350). succ(5350,5351).
succ(5851,5852). succ(5852,5853). succ(5853,5854). succ(5854,5855). succ(5855,5856).
succ(5856,5857). succ(5857,5858). succ(5858,5859). succ(5859,5860). succ(5860,5861).
succ(5861,5862). succ(5862,5863). succ(5863,5864). succ(5864,5865). succ(5865,5866).
succ(5866,5867). succ(5867,5868). succ(5868,5869). succ(5869,5870). succ(5870,5871).
succ(5981,5982). succ(5982,5983). succ(5983,5984). succ(5984,5985). succ(5985,5986).
succ(5986,5987). succ(5987,5988). succ(5988,5989). succ(5989,5990). succ(5990,5991).
succ(7591,7592). succ(7592,7593). succ(7593,7594). succ(7594,7595). succ(7595,7596).
is_prime(127). is_prime(131). is_prime(137). is_prime(139). is_prime(149). is_prime(151). is_prime(157). is_prime(163). is_prime(167). is_prime(173).
is_prime(1019). is_prime(1021). is_prime(1031). is_prime(1033). is_prime(1039). is_prime(1049). is_prime(1051). is_prime(1061). is_prime(1063). is_prime(1069).
is_prime(5861). is_prime(5867). is_prime(5869). is_prime(5879). is_prime(5881). is_prime(5897). is_prime(5903). is_prime(5923). is_prime(5927). is_prime(5939).
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