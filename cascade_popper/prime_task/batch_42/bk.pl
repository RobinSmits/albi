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

integer(181). integer(182). integer(183). integer(184). integer(185). integer(186). integer(187). integer(188). integer(189). integer(190).
integer(211). integer(212). integer(213). integer(214). integer(215). integer(216). integer(217). integer(218). integer(219). integer(220).
integer(1511). integer(1512). integer(1513). integer(1514). integer(1515). integer(1516). integer(1517). integer(1518). integer(1519). integer(1520).
integer(1531). integer(1532). integer(1533). integer(1534). integer(1535). integer(1536). integer(1537). integer(1538). integer(1539). integer(1540).
integer(5861). integer(5862). integer(5863). integer(5864). integer(5865). integer(5866). integer(5867). integer(5868). integer(5869). integer(5870).
integer(6221). integer(6222). integer(6223). integer(6224). integer(6225). integer(6226). integer(6227). integer(6228). integer(6229). integer(6230).
succ(16,17). succ(17,18). succ(18,19). succ(19,20). succ(20,21).
succ(181,182). succ(182,183). succ(183,184). succ(184,185). succ(185,186).
succ(211,212). succ(212,213). succ(213,214). succ(214,215). succ(215,216).
succ(346,347). succ(347,348). succ(348,349). succ(349,350). succ(350,351).
succ(366,367). succ(367,368). succ(368,369). succ(369,370). succ(370,371).
succ(786,787). succ(787,788). succ(788,789). succ(789,790). succ(790,791).
succ(1116,1117). succ(1117,1118). succ(1118,1119). succ(1119,1120). succ(1120,1121).
succ(1511,1512). succ(1512,1513). succ(1513,1514). succ(1514,1515). succ(1515,1516).
succ(1531,1532). succ(1532,1533). succ(1533,1534). succ(1534,1535). succ(1535,1536).
succ(4026,4027). succ(4027,4028). succ(4028,4029). succ(4029,4030). succ(4030,4031).
succ(4216,4217). succ(4217,4218). succ(4218,4219). succ(4219,4220). succ(4220,4221).
succ(4336,4337). succ(4337,4338). succ(4338,4339). succ(4339,4340). succ(4340,4341).
succ(5856,5857). succ(5857,5858). succ(5858,5859). succ(5859,5860). succ(5860,5861).
succ(5861,5862). succ(5862,5863). succ(5863,5864). succ(5864,5865). succ(5865,5866).
succ(6221,6222). succ(6222,6223). succ(6223,6224). succ(6224,6225). succ(6225,6226).
succ(7816,7817). succ(7817,7818). succ(7818,7819). succ(7819,7820). succ(7820,7821).
is_prime(179). is_prime(181). is_prime(191). is_prime(193). is_prime(197). is_prime(199). is_prime(211). is_prime(223). is_prime(227). is_prime(229).
is_prime(353). is_prime(359). is_prime(367). is_prime(373). is_prime(379). is_prime(383). is_prime(389). is_prime(397). is_prime(401). is_prime(409).
is_prime(5861). is_prime(5867). is_prime(5869). is_prime(5879). is_prime(5881). is_prime(5897). is_prime(5903). is_prime(5923). is_prime(5927). is_prime(5939).
is_prime(6229). is_prime(6247). is_prime(6257). is_prime(6263). is_prime(6269). is_prime(6271). is_prime(6277). is_prime(6287). is_prime(6299). is_prime(6301).
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