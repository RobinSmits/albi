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

integer(201). integer(202). integer(203). integer(204). integer(205). integer(206). integer(207). integer(208). integer(209). integer(210).
integer(211). integer(212). integer(213). integer(214). integer(215). integer(216). integer(217). integer(218). integer(219). integer(220).
integer(281). integer(282). integer(283). integer(284). integer(285). integer(286). integer(287). integer(288). integer(289). integer(290).
integer(521). integer(522). integer(523). integer(524). integer(525). integer(526). integer(527). integer(528). integer(529). integer(530).
integer(601). integer(602). integer(603). integer(604). integer(605). integer(606). integer(607). integer(608). integer(609). integer(610).
integer(881). integer(882). integer(883). integer(884). integer(885). integer(886). integer(887). integer(888). integer(889). integer(890).
integer(1061). integer(1062). integer(1063). integer(1064). integer(1065). integer(1066). integer(1067). integer(1068). integer(1069). integer(1070).
integer(1201). integer(1202). integer(1203). integer(1204). integer(1205). integer(1206). integer(1207). integer(1208). integer(1209). integer(1210).
integer(1291). integer(1292). integer(1293). integer(1294). integer(1295). integer(1296). integer(1297). integer(1298). integer(1299). integer(1300).
integer(2411). integer(2412). integer(2413). integer(2414). integer(2415). integer(2416). integer(2417). integer(2418). integer(2419). integer(2420).
integer(5261). integer(5262). integer(5263). integer(5264). integer(5265). integer(5266). integer(5267). integer(5268). integer(5269). integer(5270).
integer(6551). integer(6552). integer(6553). integer(6554). integer(6555). integer(6556). integer(6557). integer(6558). integer(6559). integer(6560).
integer(6701). integer(6702). integer(6703). integer(6704). integer(6705). integer(6706). integer(6707). integer(6708). integer(6709). integer(6710).
succ(126,127). succ(127,128). succ(128,129). succ(129,130). succ(130,131).
succ(201,202). succ(202,203). succ(203,204). succ(204,205). succ(205,206).
succ(211,212). succ(212,213). succ(213,214). succ(214,215). succ(215,216).
succ(276,277). succ(277,278). succ(278,279). succ(279,280). succ(280,281).
succ(281,282). succ(282,283). succ(283,284). succ(284,285). succ(285,286).
succ(521,522). succ(522,523). succ(523,524). succ(524,525). succ(525,526).
succ(601,602). succ(602,603). succ(603,604). succ(604,605). succ(605,606).
succ(881,882). succ(882,883). succ(883,884). succ(884,885). succ(885,886).
succ(1061,1062). succ(1062,1063). succ(1063,1064). succ(1064,1065). succ(1065,1066).
succ(1186,1187). succ(1187,1188). succ(1188,1189). succ(1189,1190). succ(1190,1191).
succ(1201,1202). succ(1202,1203). succ(1203,1204). succ(1204,1205). succ(1205,1206).
succ(1291,1292). succ(1292,1293). succ(1293,1294). succ(1294,1295). succ(1295,1296).
succ(1666,1667). succ(1667,1668). succ(1668,1669). succ(1669,1670). succ(1670,1671).
succ(2411,2412). succ(2412,2413). succ(2413,2414). succ(2414,2415). succ(2415,2416).
succ(3346,3347). succ(3347,3348). succ(3348,3349). succ(3349,3350). succ(3350,3351).
succ(5236,5237). succ(5237,5238). succ(5238,5239). succ(5239,5240). succ(5240,5241).
succ(5261,5262). succ(5262,5263). succ(5263,5264). succ(5264,5265). succ(5265,5266).
succ(6046,6047). succ(6047,6048). succ(6048,6049). succ(6049,6050). succ(6050,6051).
succ(6546,6547). succ(6547,6548). succ(6548,6549). succ(6549,6550). succ(6550,6551).
succ(6551,6552). succ(6552,6553). succ(6553,6554). succ(6554,6555). succ(6555,6556).
succ(6701,6702). succ(6702,6703). succ(6703,6704). succ(6704,6705). succ(6705,6706).
is_prime(127). is_prime(131). is_prime(137). is_prime(139). is_prime(149). is_prime(151). is_prime(157). is_prime(163). is_prime(167). is_prime(173).
is_prime(1663). is_prime(1667). is_prime(1669). is_prime(1693). is_prime(1697). is_prime(1699). is_prime(1709). is_prime(1721). is_prime(1723). is_prime(1733).
is_prime(3343). is_prime(3347). is_prime(3359). is_prime(3361). is_prime(3371). is_prime(3373). is_prime(3389). is_prime(3391). is_prime(3407). is_prime(3413).
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