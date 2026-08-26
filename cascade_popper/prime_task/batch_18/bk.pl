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

integer(401). integer(402). integer(403). integer(404). integer(405). integer(406). integer(407). integer(408). integer(409). integer(410).
integer(1021). integer(1022). integer(1023). integer(1024). integer(1025). integer(1026). integer(1027). integer(1028). integer(1029). integer(1030).
integer(1151). integer(1152). integer(1153). integer(1154). integer(1155). integer(1156). integer(1157). integer(1158). integer(1159). integer(1160).
integer(3631). integer(3632). integer(3633). integer(3634). integer(3635). integer(3636). integer(3637). integer(3638). integer(3639). integer(3640).
integer(4561). integer(4562). integer(4563). integer(4564). integer(4565). integer(4566). integer(4567). integer(4568). integer(4569). integer(4570).
integer(4951). integer(4952). integer(4953). integer(4954). integer(4955). integer(4956). integer(4957). integer(4958). integer(4959). integer(4960).
integer(6221). integer(6222). integer(6223). integer(6224). integer(6225). integer(6226). integer(6227). integer(6228). integer(6229). integer(6230).
succ(106,107). succ(107,108). succ(108,109). succ(109,110). succ(110,111).
succ(136,137). succ(137,138). succ(138,139). succ(139,140). succ(140,141).
succ(276,277). succ(277,278). succ(278,279). succ(279,280). succ(280,281).
succ(401,402). succ(402,403). succ(403,404). succ(404,405). succ(405,406).
succ(756,757). succ(757,758). succ(758,759). succ(759,760). succ(760,761).
succ(1021,1022). succ(1022,1023). succ(1023,1024). succ(1024,1025). succ(1025,1026).
succ(1151,1152). succ(1152,1153). succ(1153,1154). succ(1154,1155). succ(1155,1156).
succ(1296,1297). succ(1297,1298). succ(1298,1299). succ(1299,1300). succ(1300,1301).
succ(1696,1697). succ(1697,1698). succ(1698,1699). succ(1699,1700). succ(1700,1701).
succ(1876,1877). succ(1877,1878). succ(1878,1879). succ(1879,1880). succ(1880,1881).
succ(1996,1997). succ(1997,1998). succ(1998,1999). succ(1999,2000). succ(2000,2001).
succ(3631,3632). succ(3632,3633). succ(3633,3634). succ(3634,3635). succ(3635,3636).
succ(4516,4517). succ(4517,4518). succ(4518,4519). succ(4519,4520). succ(4520,4521).
succ(4561,4562). succ(4562,4563). succ(4563,4564). succ(4564,4565). succ(4565,4566).
succ(4566,4567). succ(4567,4568). succ(4568,4569). succ(4569,4570). succ(4570,4571).
succ(4951,4952). succ(4952,4953). succ(4953,4954). succ(4954,4955). succ(4955,4956).
succ(4956,4957). succ(4957,4958). succ(4958,4959). succ(4959,4960). succ(4960,4961).
succ(6216,6217). succ(6217,6218). succ(6218,6219). succ(6219,6220). succ(6220,6221).
succ(6221,6222). succ(6222,6223). succ(6223,6224). succ(6224,6225). succ(6225,6226).
is_prime(73). is_prime(79). is_prime(83). is_prime(89). is_prime(97). is_prime(101). is_prime(103). is_prime(107). is_prime(109). is_prime(113).
is_prime(283). is_prime(293). is_prime(307). is_prime(311). is_prime(313). is_prime(317). is_prime(331). is_prime(337). is_prime(347). is_prime(349).
is_prime(1297). is_prime(1301). is_prime(1303). is_prime(1307). is_prime(1319). is_prime(1321). is_prime(1327). is_prime(1361). is_prime(1367). is_prime(1373).
is_prime(1993). is_prime(1997). is_prime(1999). is_prime(2003). is_prime(2011). is_prime(2017). is_prime(2027). is_prime(2029). is_prime(2039). is_prime(2053).
is_composite(614). is_composite(615). is_composite(616). is_composite(618). is_composite(620). is_composite(621). is_composite(622). is_composite(623). is_composite(624). is_composite(625).
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