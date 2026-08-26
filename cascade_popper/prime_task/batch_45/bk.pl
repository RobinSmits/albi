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

integer(41). integer(42). integer(43). integer(44). integer(45). integer(46). integer(47). integer(48). integer(49). integer(50).
integer(181). integer(182). integer(183). integer(184). integer(185). integer(186). integer(187). integer(188). integer(189). integer(190).
integer(1031). integer(1032). integer(1033). integer(1034). integer(1035). integer(1036). integer(1037). integer(1038). integer(1039). integer(1040).
integer(1471). integer(1472). integer(1473). integer(1474). integer(1475). integer(1476). integer(1477). integer(1478). integer(1479). integer(1480).
integer(2011). integer(2012). integer(2013). integer(2014). integer(2015). integer(2016). integer(2017). integer(2018). integer(2019). integer(2020).
integer(4591). integer(4592). integer(4593). integer(4594). integer(4595). integer(4596). integer(4597). integer(4598). integer(4599). integer(4600).
integer(5651). integer(5652). integer(5653). integer(5654). integer(5655). integer(5656). integer(5657). integer(5658). integer(5659). integer(5660).
integer(6871). integer(6872). integer(6873). integer(6874). integer(6875). integer(6876). integer(6877). integer(6878). integer(6879). integer(6880).
succ(16,17). succ(17,18). succ(18,19). succ(19,20). succ(20,21).
succ(41,42). succ(42,43). succ(43,44). succ(44,45). succ(45,46).
succ(181,182). succ(182,183). succ(183,184). succ(184,185). succ(185,186).
succ(796,797). succ(797,798). succ(798,799). succ(799,800). succ(800,801).
succ(856,857). succ(857,858). succ(858,859). succ(859,860). succ(860,861).
succ(1031,1032). succ(1032,1033). succ(1033,1034). succ(1034,1035). succ(1035,1036).
succ(1116,1117). succ(1117,1118). succ(1118,1119). succ(1119,1120). succ(1120,1121).
succ(1471,1472). succ(1472,1473). succ(1473,1474). succ(1474,1475). succ(1475,1476).
succ(2011,2012). succ(2012,2013). succ(2013,2014). succ(2014,2015). succ(2015,2016).
succ(2026,2027). succ(2027,2028). succ(2028,2029). succ(2029,2030). succ(2030,2031).
succ(3676,3677). succ(3677,3678). succ(3678,3679). succ(3679,3680). succ(3680,3681).
succ(4591,4592). succ(4592,4593). succ(4593,4594). succ(4594,4595). succ(4595,4596).
succ(5646,5647). succ(5647,5648). succ(5648,5649). succ(5649,5650). succ(5650,5651).
succ(5651,5652). succ(5652,5653). succ(5653,5654). succ(5654,5655). succ(5655,5656).
succ(6871,6872). succ(6872,6873). succ(6873,6874). succ(6874,6875). succ(6875,6876).
is_prime(179). is_prime(181). is_prime(191). is_prime(193). is_prime(197). is_prime(199). is_prime(211). is_prime(223). is_prime(227). is_prime(229).
is_prime(1453). is_prime(1459). is_prime(1471). is_prime(1481). is_prime(1483). is_prime(1487). is_prime(1489). is_prime(1493). is_prime(1499). is_prime(1511).
is_prime(4591). is_prime(4597). is_prime(4603). is_prime(4621). is_prime(4637). is_prime(4639). is_prime(4643). is_prime(4649). is_prime(4651). is_prime(4657).
is_composite(1790). is_composite(1791). is_composite(1792). is_composite(1793). is_composite(1794). is_composite(1795). is_composite(1796). is_composite(1797). is_composite(1798). is_composite(1799).
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