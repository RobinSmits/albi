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

integer(211). integer(212). integer(213). integer(214). integer(215). integer(216). integer(217). integer(218). integer(219). integer(220).
integer(761). integer(762). integer(763). integer(764). integer(765). integer(766). integer(767). integer(768). integer(769). integer(770).
integer(1291). integer(1292). integer(1293). integer(1294). integer(1295). integer(1296). integer(1297). integer(1298). integer(1299). integer(1300).
integer(1301). integer(1302). integer(1303). integer(1304). integer(1305). integer(1306). integer(1307). integer(1308). integer(1309). integer(1310).
integer(1481). integer(1482). integer(1483). integer(1484). integer(1485). integer(1486). integer(1487). integer(1488). integer(1489). integer(1490).
integer(1741). integer(1742). integer(1743). integer(1744). integer(1745). integer(1746). integer(1747). integer(1748). integer(1749). integer(1750).
integer(2161). integer(2162). integer(2163). integer(2164). integer(2165). integer(2166). integer(2167). integer(2168). integer(2169). integer(2170).
integer(6151). integer(6152). integer(6153). integer(6154). integer(6155). integer(6156). integer(6157). integer(6158). integer(6159). integer(6160).
integer(7901). integer(7902). integer(7903). integer(7904). integer(7905). integer(7906). integer(7907). integer(7908). integer(7909). integer(7910).
succ(46,47). succ(47,48). succ(48,49). succ(49,50). succ(50,51).
succ(211,212). succ(212,213). succ(213,214). succ(214,215). succ(215,216).
succ(366,367). succ(367,368). succ(368,369). succ(369,370). succ(370,371).
succ(761,762). succ(762,763). succ(763,764). succ(764,765). succ(765,766).
succ(886,887). succ(887,888). succ(888,889). succ(889,890). succ(890,891).
succ(906,907). succ(907,908). succ(908,909). succ(909,910). succ(910,911).
succ(1291,1292). succ(1292,1293). succ(1293,1294). succ(1294,1295). succ(1295,1296).
succ(1301,1302). succ(1302,1303). succ(1303,1304). succ(1304,1305). succ(1305,1306).
succ(1481,1482). succ(1482,1483). succ(1483,1484). succ(1484,1485). succ(1485,1486).
succ(1626,1627). succ(1627,1628). succ(1628,1629). succ(1629,1630). succ(1630,1631).
succ(1636,1637). succ(1637,1638). succ(1638,1639). succ(1639,1640). succ(1640,1641).
succ(1741,1742). succ(1742,1743). succ(1743,1744). succ(1744,1745). succ(1745,1746).
succ(1776,1777). succ(1777,1778). succ(1778,1779). succ(1779,1780). succ(1780,1781).
succ(2161,2162). succ(2162,2163). succ(2163,2164). succ(2164,2165). succ(2165,2166).
succ(6151,6152). succ(6152,6153). succ(6153,6154). succ(6154,6155). succ(6155,6156).
succ(7056,7057). succ(7057,7058). succ(7058,7059). succ(7059,7060). succ(7060,7061).
succ(7816,7817). succ(7817,7818). succ(7818,7819). succ(7819,7820). succ(7820,7821).
succ(7901,7902). succ(7902,7903). succ(7903,7904). succ(7904,7905). succ(7905,7906).
succ(7906,7907). succ(7907,7908). succ(7908,7909). succ(7909,7910). succ(7910,7911).
is_prime(1741). is_prime(1747). is_prime(1753). is_prime(1759). is_prime(1777). is_prime(1783). is_prime(1787). is_prime(1789). is_prime(1801). is_prime(1811).
is_prime(6143). is_prime(6151). is_prime(6163). is_prime(6173). is_prime(6197). is_prime(6199). is_prime(6203). is_prime(6211). is_prime(6217). is_prime(6221).
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