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
integer(311). integer(312). integer(313). integer(314). integer(315). integer(316). integer(317). integer(318). integer(319). integer(320).
integer(1091). integer(1092). integer(1093). integer(1094). integer(1095). integer(1096). integer(1097). integer(1098). integer(1099). integer(1100).
integer(1151). integer(1152). integer(1153). integer(1154). integer(1155). integer(1156). integer(1157). integer(1158). integer(1159). integer(1160).
integer(1471). integer(1472). integer(1473). integer(1474). integer(1475). integer(1476). integer(1477). integer(1478). integer(1479). integer(1480).
integer(1901). integer(1902). integer(1903). integer(1904). integer(1905). integer(1906). integer(1907). integer(1908). integer(1909). integer(1910).
integer(2441). integer(2442). integer(2443). integer(2444). integer(2445). integer(2446). integer(2447). integer(2448). integer(2449). integer(2450).
integer(6991). integer(6992). integer(6993). integer(6994). integer(6995). integer(6996). integer(6997). integer(6998). integer(6999). integer(7000).
integer(7691). integer(7692). integer(7693). integer(7694). integer(7695). integer(7696). integer(7697). integer(7698). integer(7699). integer(7700).
succ(41,42). succ(42,43). succ(43,44). succ(44,45). succ(45,46).
succ(66,67). succ(67,68). succ(68,69). succ(69,70). succ(70,71).
succ(96,97). succ(97,98). succ(98,99). succ(99,100). succ(100,101).
succ(191,192). succ(192,193). succ(193,194). succ(194,195). succ(195,196).
succ(311,312). succ(312,313). succ(313,314). succ(314,315). succ(315,316).
succ(316,317). succ(317,318). succ(318,319). succ(319,320). succ(320,321).
succ(1091,1092). succ(1092,1093). succ(1093,1094). succ(1094,1095). succ(1095,1096).
succ(1151,1152). succ(1152,1153). succ(1153,1154). succ(1154,1155). succ(1155,1156).
succ(1471,1472). succ(1472,1473). succ(1473,1474). succ(1474,1475). succ(1475,1476).
succ(1901,1902). succ(1902,1903). succ(1903,1904). succ(1904,1905). succ(1905,1906).
succ(2441,2442). succ(2442,2443). succ(2443,2444). succ(2444,2445). succ(2445,2446).
succ(2446,2447). succ(2447,2448). succ(2448,2449). succ(2449,2450). succ(2450,2451).
succ(3906,3907). succ(3907,3908). succ(3908,3909). succ(3909,3910). succ(3910,3911).
succ(4656,4657). succ(4657,4658). succ(4658,4659). succ(4659,4660). succ(4660,4661).
succ(6991,6992). succ(6992,6993). succ(6993,6994). succ(6994,6995). succ(6995,6996).
succ(6996,6997). succ(6997,6998). succ(6998,6999). succ(6999,7000). succ(7000,7001).
succ(7576,7577). succ(7577,7578). succ(7578,7579). succ(7579,7580). succ(7580,7581).
succ(7691,7692). succ(7692,7693). succ(7693,7694). succ(7694,7695). succ(7695,7696).
is_prime(1019). is_prime(1021). is_prime(1031). is_prime(1033). is_prime(1039). is_prime(1049). is_prime(1051). is_prime(1061). is_prime(1063). is_prime(1069).
is_prime(1153). is_prime(1163). is_prime(1171). is_prime(1181). is_prime(1187). is_prime(1193). is_prime(1201). is_prime(1213). is_prime(1217). is_prime(1223).
is_prime(1901). is_prime(1907). is_prime(1913). is_prime(1931). is_prime(1933). is_prime(1949). is_prime(1951). is_prime(1973). is_prime(1979). is_prime(1987).
is_prime(4663). is_prime(4673). is_prime(4679). is_prime(4691). is_prime(4703). is_prime(4721). is_prime(4723). is_prime(4729). is_prime(4733). is_prime(4751).
is_prime(7573). is_prime(7577). is_prime(7583). is_prime(7589). is_prime(7591). is_prime(7603). is_prime(7607). is_prime(7621). is_prime(7639). is_prime(7643).
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