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
integer(701). integer(702). integer(703). integer(704). integer(705). integer(706). integer(707). integer(708). integer(709). integer(710).
integer(881). integer(882). integer(883). integer(884). integer(885). integer(886). integer(887). integer(888). integer(889). integer(890).
integer(1231). integer(1232). integer(1233). integer(1234). integer(1235). integer(1236). integer(1237). integer(1238). integer(1239). integer(1240).
integer(4721). integer(4722). integer(4723). integer(4724). integer(4725). integer(4726). integer(4727). integer(4728). integer(4729). integer(4730).
integer(5701). integer(5702). integer(5703). integer(5704). integer(5705). integer(5706). integer(5707). integer(5708). integer(5709). integer(5710).
integer(5711). integer(5712). integer(5713). integer(5714). integer(5715). integer(5716). integer(5717). integer(5718). integer(5719). integer(5720).
integer(6121). integer(6122). integer(6123). integer(6124). integer(6125). integer(6126). integer(6127). integer(6128). integer(6129). integer(6130).
integer(6131). integer(6132). integer(6133). integer(6134). integer(6135). integer(6136). integer(6137). integer(6138). integer(6139). integer(6140).
integer(6761). integer(6762). integer(6763). integer(6764). integer(6765). integer(6766). integer(6767). integer(6768). integer(6769). integer(6770).
succ(271,272). succ(272,273). succ(273,274). succ(274,275). succ(275,276).
succ(276,277). succ(277,278). succ(278,279). succ(279,280). succ(280,281).
succ(316,317). succ(317,318). succ(318,319). succ(319,320). succ(320,321).
succ(336,337). succ(337,338). succ(338,339). succ(339,340). succ(340,341).
succ(346,347). succ(347,348). succ(348,349). succ(349,350). succ(350,351).
succ(701,702). succ(702,703). succ(703,704). succ(704,705). succ(705,706).
succ(881,882). succ(882,883). succ(883,884). succ(884,885). succ(885,886).
succ(1231,1232). succ(1232,1233). succ(1233,1234). succ(1234,1235). succ(1235,1236).
succ(1236,1237). succ(1237,1238). succ(1238,1239). succ(1239,1240). succ(1240,1241).
succ(1746,1747). succ(1747,1748). succ(1748,1749). succ(1749,1750). succ(1750,1751).
succ(1786,1787). succ(1787,1788). succ(1788,1789). succ(1789,1790). succ(1790,1791).
succ(3546,3547). succ(3547,3548). succ(3548,3549). succ(3549,3550). succ(3550,3551).
succ(3556,3557). succ(3557,3558). succ(3558,3559). succ(3559,3560). succ(3560,3561).
succ(4721,4722). succ(4722,4723). succ(4723,4724). succ(4724,4725). succ(4725,4726).
succ(5416,5417). succ(5417,5418). succ(5418,5419). succ(5419,5420). succ(5420,5421).
succ(5701,5702). succ(5702,5703). succ(5703,5704). succ(5704,5705). succ(5705,5706).
succ(5711,5712). succ(5712,5713). succ(5713,5714). succ(5714,5715). succ(5715,5716).
succ(6121,6122). succ(6122,6123). succ(6123,6124). succ(6124,6125). succ(6125,6126).
succ(6131,6132). succ(6132,6133). succ(6133,6134). succ(6134,6135). succ(6135,6136).
succ(6736,6737). succ(6737,6738). succ(6738,6739). succ(6739,6740). succ(6740,6741).
succ(6761,6762). succ(6762,6763). succ(6763,6764). succ(6764,6765). succ(6765,6766).
is_prime(1663). is_prime(1667). is_prime(1669). is_prime(1693). is_prime(1697). is_prime(1699). is_prime(1709). is_prime(1721). is_prime(1723). is_prime(1733).
is_prime(5701). is_prime(5711). is_prime(5717). is_prime(5737). is_prime(5741). is_prime(5743). is_prime(5749). is_prime(5779). is_prime(5783). is_prime(5791).
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