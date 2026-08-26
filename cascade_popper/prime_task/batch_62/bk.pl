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
integer(131). integer(132). integer(133). integer(134). integer(135). integer(136). integer(137). integer(138). integer(139). integer(140).
integer(461). integer(462). integer(463). integer(464). integer(465). integer(466). integer(467). integer(468). integer(469). integer(470).
integer(1291). integer(1292). integer(1293). integer(1294). integer(1295). integer(1296). integer(1297). integer(1298). integer(1299). integer(1300).
integer(1361). integer(1362). integer(1363). integer(1364). integer(1365). integer(1366). integer(1367). integer(1368). integer(1369). integer(1370).
integer(1451). integer(1452). integer(1453). integer(1454). integer(1455). integer(1456). integer(1457). integer(1458). integer(1459). integer(1460).
integer(5431). integer(5432). integer(5433). integer(5434). integer(5435). integer(5436). integer(5437). integer(5438). integer(5439). integer(5440).
integer(5821). integer(5822). integer(5823). integer(5824). integer(5825). integer(5826). integer(5827). integer(5828). integer(5829). integer(5830).
integer(7211). integer(7212). integer(7213). integer(7214). integer(7215). integer(7216). integer(7217). integer(7218). integer(7219). integer(7220).
succ(66,67). succ(67,68). succ(68,69). succ(69,70). succ(70,71).
succ(71,72). succ(72,73). succ(73,74). succ(74,75). succ(75,76).
succ(126,127). succ(127,128). succ(128,129). succ(129,130). succ(130,131).
succ(131,132). succ(132,133). succ(133,134). succ(134,135). succ(135,136).
succ(461,462). succ(462,463). succ(463,464). succ(464,465). succ(465,466).
succ(676,677). succ(677,678). succ(678,679). succ(679,680). succ(680,681).
succ(1291,1292). succ(1292,1293). succ(1293,1294). succ(1294,1295). succ(1295,1296).
succ(1361,1362). succ(1362,1363). succ(1363,1364). succ(1364,1365). succ(1365,1366).
succ(1451,1452). succ(1452,1453). succ(1453,1454). succ(1454,1455). succ(1455,1456).
succ(2016,2017). succ(2017,2018). succ(2018,2019). succ(2019,2020). succ(2020,2021).
succ(2766,2767). succ(2767,2768). succ(2768,2769). succ(2769,2770). succ(2770,2771).
succ(2776,2777). succ(2777,2778). succ(2778,2779). succ(2779,2780). succ(2780,2781).
succ(5431,5432). succ(5432,5433). succ(5433,5434). succ(5434,5435). succ(5435,5436).
succ(5506,5507). succ(5507,5508). succ(5508,5509). succ(5509,5510). succ(5510,5511).
succ(5821,5822). succ(5822,5823). succ(5823,5824). succ(5824,5825). succ(5825,5826).
succ(5826,5827). succ(5827,5828). succ(5828,5829). succ(5829,5830). succ(5830,5831).
succ(7211,7212). succ(7212,7213). succ(7213,7214). succ(7214,7215). succ(7215,7216).
succ(7756,7757). succ(7757,7758). succ(7758,7759). succ(7759,7760). succ(7760,7761).
is_prime(127). is_prime(131). is_prime(137). is_prime(139). is_prime(149). is_prime(151). is_prime(157). is_prime(163). is_prime(167). is_prime(173).
is_prime(7211). is_prime(7213). is_prime(7219). is_prime(7229). is_prime(7237). is_prime(7243). is_prime(7247). is_prime(7253). is_prime(7283). is_prime(7297).
is_composite(1292). is_composite(1293). is_composite(1294). is_composite(1295). is_composite(1296). is_composite(1298). is_composite(1299). is_composite(1300). is_composite(1302). is_composite(1304).
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