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

integer(71). integer(72). integer(73). integer(74). integer(75). integer(76). integer(77). integer(78). integer(79). integer(80).
integer(121). integer(122). integer(123). integer(124). integer(125). integer(126). integer(127). integer(128). integer(129). integer(130).
integer(191). integer(192). integer(193). integer(194). integer(195). integer(196). integer(197). integer(198). integer(199). integer(200).
integer(541). integer(542). integer(543). integer(544). integer(545). integer(546). integer(547). integer(548). integer(549). integer(550).
integer(1801). integer(1802). integer(1803). integer(1804). integer(1805). integer(1806). integer(1807). integer(1808). integer(1809). integer(1810).
integer(4591). integer(4592). integer(4593). integer(4594). integer(4595). integer(4596). integer(4597). integer(4598). integer(4599). integer(4600).
succ(71,72). succ(72,73). succ(73,74). succ(74,75). succ(75,76).
succ(121,122). succ(122,123). succ(123,124). succ(124,125). succ(125,126).
succ(126,127). succ(127,128). succ(128,129). succ(129,130). succ(130,131).
succ(191,192). succ(192,193). succ(193,194). succ(194,195). succ(195,196).
succ(541,542). succ(542,543). succ(543,544). succ(544,545). succ(545,546).
succ(556,557). succ(557,558). succ(558,559). succ(559,560). succ(560,561).
succ(606,607). succ(607,608). succ(608,609). succ(609,610). succ(610,611).
succ(726,727). succ(727,728). succ(728,729). succ(729,730). succ(730,731).
succ(976,977). succ(977,978). succ(978,979). succ(979,980). succ(980,981).
succ(1801,1802). succ(1802,1803). succ(1803,1804). succ(1804,1805). succ(1805,1806).
succ(2346,2347). succ(2347,2348). succ(2348,2349). succ(2349,2350). succ(2350,2351).
succ(3606,3607). succ(3607,3608). succ(3608,3609). succ(3609,3610). succ(3610,3611).
succ(4591,4592). succ(4592,4593). succ(4593,4594). succ(4594,4595). succ(4595,4596).
succ(4596,4597). succ(4597,4598). succ(4598,4599). succ(4599,4600). succ(4600,4601).
succ(5476,5477). succ(5477,5478). succ(5478,5479). succ(5479,5480). succ(5480,5481).
succ(6196,6197). succ(6197,6198). succ(6198,6199). succ(6199,6200). succ(6200,6201).
is_prime(127). is_prime(131). is_prime(137). is_prime(139). is_prime(149). is_prime(151). is_prime(157). is_prime(163). is_prime(167). is_prime(173).
is_prime(607). is_prime(613). is_prime(617). is_prime(619). is_prime(631). is_prime(641). is_prime(643). is_prime(647). is_prime(653). is_prime(659).
is_prime(1523). is_prime(1531). is_prime(1543). is_prime(1549). is_prime(1553). is_prime(1559). is_prime(1567). is_prime(1571). is_prime(1579). is_prime(1583).
is_prime(4591). is_prime(4597). is_prime(4603). is_prime(4621). is_prime(4637). is_prime(4639). is_prime(4643). is_prime(4649). is_prime(4651). is_prime(4657).
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