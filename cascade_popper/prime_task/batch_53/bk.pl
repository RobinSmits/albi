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
integer(101). integer(102). integer(103). integer(104). integer(105). integer(106). integer(107). integer(108). integer(109). integer(110).
integer(211). integer(212). integer(213). integer(214). integer(215). integer(216). integer(217). integer(218). integer(219). integer(220).
integer(641). integer(642). integer(643). integer(644). integer(645). integer(646). integer(647). integer(648). integer(649). integer(650).
integer(1171). integer(1172). integer(1173). integer(1174). integer(1175). integer(1176). integer(1177). integer(1178). integer(1179). integer(1180).
integer(3181). integer(3182). integer(3183). integer(3184). integer(3185). integer(3186). integer(3187). integer(3188). integer(3189). integer(3190).
succ(61,62). succ(62,63). succ(63,64). succ(64,65). succ(65,66).
succ(101,102). succ(102,103). succ(103,104). succ(104,105). succ(105,106).
succ(206,207). succ(207,208). succ(208,209). succ(209,210). succ(210,211).
succ(211,212). succ(212,213). succ(213,214). succ(214,215). succ(215,216).
succ(256,257). succ(257,258). succ(258,259). succ(259,260). succ(260,261).
succ(396,397). succ(397,398). succ(398,399). succ(399,400). succ(400,401).
succ(641,642). succ(642,643). succ(643,644). succ(644,645). succ(645,646).
succ(826,827). succ(827,828). succ(828,829). succ(829,830). succ(830,831).
succ(1171,1172). succ(1172,1173). succ(1173,1174). succ(1174,1175). succ(1175,1176).
succ(3181,3182). succ(3182,3183). succ(3183,3184). succ(3184,3185). succ(3185,3186).
succ(3186,3187). succ(3187,3188). succ(3188,3189). succ(3189,3190). succ(3190,3191).
succ(4176,4177). succ(4177,4178). succ(4178,4179). succ(4179,4180). succ(4180,4181).
succ(6066,6067). succ(6067,6068). succ(6068,6069). succ(6069,6070). succ(6070,6071).
is_prime(3187). is_prime(3191). is_prime(3203). is_prime(3209). is_prime(3217). is_prime(3221). is_prime(3229). is_prime(3251). is_prime(3253). is_prime(3257).
is_prime(6067). is_prime(6073). is_prime(6079). is_prime(6089). is_prime(6091). is_prime(6101). is_prime(6113). is_prime(6121). is_prime(6131). is_prime(6133).
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