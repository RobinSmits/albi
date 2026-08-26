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

integer(251). integer(252). integer(253). integer(254). integer(255). integer(256). integer(257). integer(258). integer(259). integer(260).
integer(331). integer(332). integer(333). integer(334). integer(335). integer(336). integer(337). integer(338). integer(339). integer(340).
integer(461). integer(462). integer(463). integer(464). integer(465). integer(466). integer(467). integer(468). integer(469). integer(470).
integer(2221). integer(2222). integer(2223). integer(2224). integer(2225). integer(2226). integer(2227). integer(2228). integer(2229). integer(2230).
integer(6971). integer(6972). integer(6973). integer(6974). integer(6975). integer(6976). integer(6977). integer(6978). integer(6979). integer(6980).
integer(7541). integer(7542). integer(7543). integer(7544). integer(7545). integer(7546). integer(7547). integer(7548). integer(7549). integer(7550).
succ(96,97). succ(97,98). succ(98,99). succ(99,100). succ(100,101).
succ(136,137). succ(137,138). succ(138,139). succ(139,140). succ(140,141).
succ(251,252). succ(252,253). succ(253,254). succ(254,255). succ(255,256).
succ(256,257). succ(257,258). succ(258,259). succ(259,260). succ(260,261).
succ(331,332). succ(332,333). succ(333,334). succ(334,335). succ(335,336).
succ(336,337). succ(337,338). succ(338,339). succ(339,340). succ(340,341).
succ(456,457). succ(457,458). succ(458,459). succ(459,460). succ(460,461).
succ(461,462). succ(462,463). succ(463,464). succ(464,465). succ(465,466).
succ(1186,1187). succ(1187,1188). succ(1188,1189). succ(1189,1190). succ(1190,1191).
succ(1276,1277). succ(1277,1278). succ(1278,1279). succ(1279,1280). succ(1280,1281).
succ(1696,1697). succ(1697,1698). succ(1698,1699). succ(1699,1700). succ(1700,1701).
succ(2221,2222). succ(2222,2223). succ(2223,2224). succ(2224,2225). succ(2225,2226).
succ(6036,6037). succ(6037,6038). succ(6038,6039). succ(6039,6040). succ(6040,6041).
succ(6971,6972). succ(6972,6973). succ(6973,6974). succ(6974,6975). succ(6975,6976).
succ(6976,6977). succ(6977,6978). succ(6978,6979). succ(6979,6980). succ(6980,6981).
succ(7541,7542). succ(7542,7543). succ(7543,7544). succ(7544,7545). succ(7545,7546).
succ(7546,7547). succ(7547,7548). succ(7548,7549). succ(7549,7550). succ(7550,7551).
is_prime(1523). is_prime(1531). is_prime(1543). is_prime(1549). is_prime(1553). is_prime(1559). is_prime(1567). is_prime(1571). is_prime(1579). is_prime(1583).
is_prime(2221). is_prime(2237). is_prime(2239). is_prime(2243). is_prime(2251). is_prime(2267). is_prime(2269). is_prime(2273). is_prime(2281). is_prime(2287).
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