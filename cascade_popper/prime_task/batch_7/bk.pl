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

integer(51). integer(52). integer(53). integer(54). integer(55). integer(56). integer(57). integer(58). integer(59). integer(60).
integer(751). integer(752). integer(753). integer(754). integer(755). integer(756). integer(757). integer(758). integer(759). integer(760).
integer(761). integer(762). integer(763). integer(764). integer(765). integer(766). integer(767). integer(768). integer(769). integer(770).
integer(1151). integer(1152). integer(1153). integer(1154). integer(1155). integer(1156). integer(1157). integer(1158). integer(1159). integer(1160).
integer(1291). integer(1292). integer(1293). integer(1294). integer(1295). integer(1296). integer(1297). integer(1298). integer(1299). integer(1300).
integer(1601). integer(1602). integer(1603). integer(1604). integer(1605). integer(1606). integer(1607). integer(1608). integer(1609). integer(1610).
integer(2971). integer(2972). integer(2973). integer(2974). integer(2975). integer(2976). integer(2977). integer(2978). integer(2979). integer(2980).
integer(3391). integer(3392). integer(3393). integer(3394). integer(3395). integer(3396). integer(3397). integer(3398). integer(3399). integer(3400).
succ(51,52). succ(52,53). succ(53,54). succ(54,55). succ(55,56).
succ(216,217). succ(217,218). succ(218,219). succ(219,220). succ(220,221).
succ(366,367). succ(367,368). succ(368,369). succ(369,370). succ(370,371).
succ(466,467). succ(467,468). succ(468,469). succ(469,470). succ(470,471).
succ(486,487). succ(487,488). succ(488,489). succ(489,490). succ(490,491).
succ(751,752). succ(752,753). succ(753,754). succ(754,755). succ(755,756).
succ(761,762). succ(762,763). succ(763,764). succ(764,765). succ(765,766).
succ(1086,1087). succ(1087,1088). succ(1088,1089). succ(1089,1090). succ(1090,1091).
succ(1151,1152). succ(1152,1153). succ(1153,1154). succ(1154,1155). succ(1155,1156).
succ(1291,1292). succ(1292,1293). succ(1293,1294). succ(1294,1295). succ(1295,1296).
succ(1296,1297). succ(1297,1298). succ(1298,1299). succ(1299,1300). succ(1300,1301).
succ(1601,1602). succ(1602,1603). succ(1603,1604). succ(1604,1605). succ(1605,1606).
succ(2971,2972). succ(2972,2973). succ(2973,2974). succ(2974,2975). succ(2975,2976).
succ(3391,3392). succ(3392,3393). succ(3393,3394). succ(3394,3395). succ(3395,3396).
succ(5086,5087). succ(5087,5088). succ(5088,5089). succ(5089,5090). succ(5090,5091).
succ(5236,5237). succ(5237,5238). succ(5238,5239). succ(5239,5240). succ(5240,5241).
succ(7876,7877). succ(7877,7878). succ(7878,7879). succ(7879,7880). succ(7880,7881).
is_prime(467). is_prime(479). is_prime(487). is_prime(491). is_prime(499). is_prime(503). is_prime(509). is_prime(521). is_prime(523). is_prime(541).
is_prime(1087). is_prime(1091). is_prime(1093). is_prime(1097). is_prime(1103). is_prime(1109). is_prime(1117). is_prime(1123). is_prime(1129). is_prime(1151).
is_prime(1297). is_prime(1301). is_prime(1303). is_prime(1307). is_prime(1319). is_prime(1321). is_prime(1327). is_prime(1361). is_prime(1367). is_prime(1373).
is_prime(1993). is_prime(1997). is_prime(1999). is_prime(2003). is_prime(2011). is_prime(2017). is_prime(2027). is_prime(2029). is_prime(2039). is_prime(2053).
is_prime(5099). is_prime(5101). is_prime(5107). is_prime(5113). is_prime(5119). is_prime(5147). is_prime(5153). is_prime(5167). is_prime(5171). is_prime(5179).
is_composite(1152). is_composite(1154). is_composite(1155). is_composite(1156). is_composite(1157). is_composite(1158). is_composite(1159). is_composite(1160). is_composite(1161). is_composite(1162).
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