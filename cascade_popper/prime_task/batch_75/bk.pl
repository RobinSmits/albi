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
integer(601). integer(602). integer(603). integer(604). integer(605). integer(606). integer(607). integer(608). integer(609). integer(610).
integer(1571). integer(1572). integer(1573). integer(1574). integer(1575). integer(1576). integer(1577). integer(1578). integer(1579). integer(1580).
integer(1951). integer(1952). integer(1953). integer(1954). integer(1955). integer(1956). integer(1957). integer(1958). integer(1959). integer(1960).
integer(2161). integer(2162). integer(2163). integer(2164). integer(2165). integer(2166). integer(2167). integer(2168). integer(2169). integer(2170).
integer(3881). integer(3882). integer(3883). integer(3884). integer(3885). integer(3886). integer(3887). integer(3888). integer(3889). integer(3890).
integer(4691). integer(4692). integer(4693). integer(4694). integer(4695). integer(4696). integer(4697). integer(4698). integer(4699). integer(4700).
integer(7591). integer(7592). integer(7593). integer(7594). integer(7595). integer(7596). integer(7597). integer(7598). integer(7599). integer(7600).
succ(96,97). succ(97,98). succ(98,99). succ(99,100). succ(100,101).
succ(176,177). succ(177,178). succ(178,179). succ(179,180). succ(180,181).
succ(211,212). succ(212,213). succ(213,214). succ(214,215). succ(215,216).
succ(226,227). succ(227,228). succ(228,229). succ(229,230). succ(230,231).
succ(601,602). succ(602,603). succ(603,604). succ(604,605). succ(605,606).
succ(1096,1097). succ(1097,1098). succ(1098,1099). succ(1099,1100). succ(1100,1101).
succ(1566,1567). succ(1567,1568). succ(1568,1569). succ(1569,1570). succ(1570,1571).
succ(1571,1572). succ(1572,1573). succ(1573,1574). succ(1574,1575). succ(1575,1576).
succ(1666,1667). succ(1667,1668). succ(1668,1669). succ(1669,1670). succ(1670,1671).
succ(1951,1952). succ(1952,1953). succ(1953,1954). succ(1954,1955). succ(1955,1956).
succ(2161,2162). succ(2162,2163). succ(2163,2164). succ(2164,2165). succ(2165,2166).
succ(3881,3882). succ(3882,3883). succ(3883,3884). succ(3884,3885). succ(3885,3886).
succ(4691,4692). succ(4692,4693). succ(4693,4694). succ(4694,4695). succ(4695,4696).
succ(4936,4937). succ(4937,4938). succ(4938,4939). succ(4939,4940). succ(4940,4941).
succ(6246,6247). succ(6247,6248). succ(6248,6249). succ(6249,6250). succ(6250,6251).
succ(7456,7457). succ(7457,7458). succ(7458,7459). succ(7459,7460). succ(7460,7461).
succ(7591,7592). succ(7592,7593). succ(7593,7594). succ(7594,7595). succ(7595,7596).
is_prime(179). is_prime(181). is_prime(191). is_prime(193). is_prime(197). is_prime(199). is_prime(211). is_prime(223). is_prime(227). is_prime(229).
is_prime(4663). is_prime(4673). is_prime(4679). is_prime(4691). is_prime(4703). is_prime(4721). is_prime(4723). is_prime(4729). is_prime(4733). is_prime(4751).
is_prime(4943). is_prime(4951). is_prime(4957). is_prime(4967). is_prime(4969). is_prime(4973). is_prime(4987). is_prime(4993). is_prime(4999). is_prime(5003).
is_prime(6229). is_prime(6247). is_prime(6257). is_prime(6263). is_prime(6269). is_prime(6271). is_prime(6277). is_prime(6287). is_prime(6299). is_prime(6301).
is_composite(96). is_composite(98). is_composite(99). is_composite(100). is_composite(102). is_composite(104). is_composite(105). is_composite(106). is_composite(108). is_composite(110).
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