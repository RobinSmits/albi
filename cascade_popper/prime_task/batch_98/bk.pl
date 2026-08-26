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
integer(821). integer(822). integer(823). integer(824). integer(825). integer(826). integer(827). integer(828). integer(829). integer(830).
integer(1601). integer(1602). integer(1603). integer(1604). integer(1605). integer(1606). integer(1607). integer(1608). integer(1609). integer(1610).
integer(1811). integer(1812). integer(1813). integer(1814). integer(1815). integer(1816). integer(1817). integer(1818). integer(1819). integer(1820).
integer(1831). integer(1832). integer(1833). integer(1834). integer(1835). integer(1836). integer(1837). integer(1838). integer(1839). integer(1840).
integer(2731). integer(2732). integer(2733). integer(2734). integer(2735). integer(2736). integer(2737). integer(2738). integer(2739). integer(2740).
integer(3461). integer(3462). integer(3463). integer(3464). integer(3465). integer(3466). integer(3467). integer(3468). integer(3469). integer(3470).
integer(4651). integer(4652). integer(4653). integer(4654). integer(4655). integer(4656). integer(4657). integer(4658). integer(4659). integer(4660).
integer(5981). integer(5982). integer(5983). integer(5984). integer(5985). integer(5986). integer(5987). integer(5988). integer(5989). integer(5990).
succ(71,72). succ(72,73). succ(73,74). succ(74,75). succ(75,76).
succ(821,822). succ(822,823). succ(823,824). succ(824,825). succ(825,826).
succ(1601,1602). succ(1602,1603). succ(1603,1604). succ(1604,1605). succ(1605,1606).
succ(1811,1812). succ(1812,1813). succ(1813,1814). succ(1814,1815). succ(1815,1816).
succ(1831,1832). succ(1832,1833). succ(1833,1834). succ(1834,1835). succ(1835,1836).
succ(2731,2732). succ(2732,2733). succ(2733,2734). succ(2734,2735). succ(2735,2736).
succ(3456,3457). succ(3457,3458). succ(3458,3459). succ(3459,3460). succ(3460,3461).
succ(3461,3462). succ(3462,3463). succ(3463,3464). succ(3464,3465). succ(3465,3466).
succ(4506,4507). succ(4507,4508). succ(4508,4509). succ(4509,4510). succ(4510,4511).
succ(4651,4652). succ(4652,4653). succ(4653,4654). succ(4654,4655). succ(4655,4656).
succ(4656,4657). succ(4657,4658). succ(4658,4659). succ(4659,4660). succ(4660,4661).
succ(4936,4937). succ(4937,4938). succ(4938,4939). succ(4939,4940). succ(4940,4941).
succ(5406,5407). succ(5407,5408). succ(5408,5409). succ(5409,5410). succ(5410,5411).
succ(5981,5982). succ(5982,5983). succ(5983,5984). succ(5984,5985). succ(5985,5986).
is_prime(739). is_prime(743). is_prime(751). is_prime(757). is_prime(761). is_prime(769). is_prime(773). is_prime(787). is_prime(797). is_prime(809).
is_prime(4507). is_prime(4513). is_prime(4517). is_prime(4519). is_prime(4523). is_prime(4547). is_prime(4549). is_prime(4561). is_prime(4567). is_prime(4583).
is_prime(5953). is_prime(5981). is_prime(5987). is_prime(6007). is_prime(6011). is_prime(6029). is_prime(6037). is_prime(6043). is_prime(6047). is_prime(6053).
is_composite(72). is_composite(74). is_composite(75). is_composite(76). is_composite(77). is_composite(78). is_composite(80). is_composite(81). is_composite(82). is_composite(84).
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