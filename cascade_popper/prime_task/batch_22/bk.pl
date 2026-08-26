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
integer(971). integer(972). integer(973). integer(974). integer(975). integer(976). integer(977). integer(978). integer(979). integer(980).
integer(1181). integer(1182). integer(1183). integer(1184). integer(1185). integer(1186). integer(1187). integer(1188). integer(1189). integer(1190).
integer(1231). integer(1232). integer(1233). integer(1234). integer(1235). integer(1236). integer(1237). integer(1238). integer(1239). integer(1240).
integer(1301). integer(1302). integer(1303). integer(1304). integer(1305). integer(1306). integer(1307). integer(1308). integer(1309). integer(1310).
integer(1381). integer(1382). integer(1383). integer(1384). integer(1385). integer(1386). integer(1387). integer(1388). integer(1389). integer(1390).
integer(1951). integer(1952). integer(1953). integer(1954). integer(1955). integer(1956). integer(1957). integer(1958). integer(1959). integer(1960).
integer(2531). integer(2532). integer(2533). integer(2534). integer(2535). integer(2536). integer(2537). integer(2538). integer(2539). integer(2540).
succ(141,142). succ(142,143). succ(143,144). succ(144,145). succ(145,146).
succ(211,212). succ(212,213). succ(213,214). succ(214,215). succ(215,216).
succ(466,467). succ(467,468). succ(468,469). succ(469,470). succ(470,471).
succ(971,972). succ(972,973). succ(973,974). succ(974,975). succ(975,976).
succ(1181,1182). succ(1182,1183). succ(1183,1184). succ(1184,1185). succ(1185,1186).
succ(1186,1187). succ(1187,1188). succ(1188,1189). succ(1189,1190). succ(1190,1191).
succ(1216,1217). succ(1217,1218). succ(1218,1219). succ(1219,1220). succ(1220,1221).
succ(1231,1232). succ(1232,1233). succ(1233,1234). succ(1234,1235). succ(1235,1236).
succ(1301,1302). succ(1302,1303). succ(1303,1304). succ(1304,1305). succ(1305,1306).
succ(1381,1382). succ(1382,1383). succ(1383,1384). succ(1384,1385). succ(1385,1386).
succ(1696,1697). succ(1697,1698). succ(1698,1699). succ(1699,1700). succ(1700,1701).
succ(1846,1847). succ(1847,1848). succ(1848,1849). succ(1849,1850). succ(1850,1851).
succ(1951,1952). succ(1952,1953). succ(1953,1954). succ(1954,1955). succ(1955,1956).
succ(2531,2532). succ(2532,2533). succ(2533,2534). succ(2534,2535). succ(2535,2536).
succ(6856,6857). succ(6857,6858). succ(6858,6859). succ(6859,6860). succ(6860,6861).
succ(7726,7727). succ(7727,7728). succ(7728,7729). succ(7729,7730). succ(7730,7731).
is_prime(467). is_prime(479). is_prime(487). is_prime(491). is_prime(499). is_prime(503). is_prime(509). is_prime(521). is_prime(523). is_prime(541).
is_prime(1381). is_prime(1399). is_prime(1409). is_prime(1423). is_prime(1427). is_prime(1429). is_prime(1433). is_prime(1439). is_prime(1447). is_prime(1451).
is_prime(1823). is_prime(1831). is_prime(1847). is_prime(1861). is_prime(1867). is_prime(1871). is_prime(1873). is_prime(1877). is_prime(1879). is_prime(1889).
is_prime(2539). is_prime(2543). is_prime(2549). is_prime(2551). is_prime(2557). is_prime(2579). is_prime(2591). is_prime(2593). is_prime(2609). is_prime(2617).
is_prime(7727). is_prime(7741). is_prime(7753). is_prime(7757). is_prime(7759). is_prime(7789). is_prime(7793). is_prime(7817). is_prime(7823). is_prime(7829).
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