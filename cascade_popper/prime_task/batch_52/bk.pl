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

integer(11). integer(12). integer(13). integer(14). integer(15). integer(16). integer(17). integer(18). integer(19). integer(20).
integer(71). integer(72). integer(73). integer(74). integer(75). integer(76). integer(77). integer(78). integer(79). integer(80).
integer(281). integer(282). integer(283). integer(284). integer(285). integer(286). integer(287). integer(288). integer(289). integer(290).
integer(1201). integer(1202). integer(1203). integer(1204). integer(1205). integer(1206). integer(1207). integer(1208). integer(1209). integer(1210).
integer(2741). integer(2742). integer(2743). integer(2744). integer(2745). integer(2746). integer(2747). integer(2748). integer(2749). integer(2750).
integer(3271). integer(3272). integer(3273). integer(3274). integer(3275). integer(3276). integer(3277). integer(3278). integer(3279). integer(3280).
integer(3581). integer(3582). integer(3583). integer(3584). integer(3585). integer(3586). integer(3587). integer(3588). integer(3589). integer(3590).
integer(4801). integer(4802). integer(4803). integer(4804). integer(4805). integer(4806). integer(4807). integer(4808). integer(4809). integer(4810).
succ(11,12). succ(12,13). succ(13,14). succ(14,15). succ(15,16).
succ(71,72). succ(72,73). succ(73,74). succ(74,75). succ(75,76).
succ(136,137). succ(137,138). succ(138,139). succ(139,140). succ(140,141).
succ(196,197). succ(197,198). succ(198,199). succ(199,200). succ(200,201).
succ(276,277). succ(277,278). succ(278,279). succ(279,280). succ(280,281).
succ(281,282). succ(282,283). succ(283,284). succ(284,285). succ(285,286).
succ(456,457). succ(457,458). succ(458,459). succ(459,460). succ(460,461).
succ(1201,1202). succ(1202,1203). succ(1203,1204). succ(1204,1205). succ(1205,1206).
succ(1786,1787). succ(1787,1788). succ(1788,1789). succ(1789,1790). succ(1790,1791).
succ(2296,2297). succ(2297,2298). succ(2298,2299). succ(2299,2300). succ(2300,2301).
succ(2346,2347). succ(2347,2348). succ(2348,2349). succ(2349,2350). succ(2350,2351).
succ(2356,2357). succ(2357,2358). succ(2358,2359). succ(2359,2360). succ(2360,2361).
succ(2741,2742). succ(2742,2743). succ(2743,2744). succ(2744,2745). succ(2745,2746).
succ(3271,3272). succ(3272,3273). succ(3273,3274). succ(3274,3275). succ(3275,3276).
succ(3581,3582). succ(3582,3583). succ(3583,3584). succ(3584,3585). succ(3585,3586).
succ(4801,4802). succ(4802,4803). succ(4803,4804). succ(4804,4805). succ(4805,4806).
succ(6606,6607). succ(6607,6608). succ(6608,6609). succ(6609,6610). succ(6610,6611).
is_prime(73). is_prime(79). is_prime(83). is_prime(89). is_prime(97). is_prime(101). is_prime(103). is_prime(107). is_prime(109). is_prime(113).
is_prime(283). is_prime(293). is_prime(307). is_prime(311). is_prime(313). is_prime(317). is_prime(331). is_prime(337). is_prime(347). is_prime(349).
is_prime(2749). is_prime(2753). is_prime(2767). is_prime(2777). is_prime(2789). is_prime(2791). is_prime(2797). is_prime(2801). is_prime(2803). is_prime(2819).
is_prime(3581). is_prime(3583). is_prime(3593). is_prime(3607). is_prime(3613). is_prime(3617). is_prime(3623). is_prime(3631). is_prime(3637). is_prime(3643).
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