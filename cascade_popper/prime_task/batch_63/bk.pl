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
integer(1021). integer(1022). integer(1023). integer(1024). integer(1025). integer(1026). integer(1027). integer(1028). integer(1029). integer(1030).
integer(1901). integer(1902). integer(1903). integer(1904). integer(1905). integer(1906). integer(1907). integer(1908). integer(1909). integer(1910).
integer(2221). integer(2222). integer(2223). integer(2224). integer(2225). integer(2226). integer(2227). integer(2228). integer(2229). integer(2230).
integer(6581). integer(6582). integer(6583). integer(6584). integer(6585). integer(6586). integer(6587). integer(6588). integer(6589). integer(6590).
integer(7331). integer(7332). integer(7333). integer(7334). integer(7335). integer(7336). integer(7337). integer(7338). integer(7339). integer(7340).
succ(36,37). succ(37,38). succ(38,39). succ(39,40). succ(40,41).
succ(41,42). succ(42,43). succ(43,44). succ(44,45). succ(45,46).
succ(336,337). succ(337,338). succ(338,339). succ(339,340). succ(340,341).
succ(346,347). succ(347,348). succ(348,349). succ(349,350). succ(350,351).
succ(556,557). succ(557,558). succ(558,559). succ(559,560). succ(560,561).
succ(936,937). succ(937,938). succ(938,939). succ(939,940). succ(940,941).
succ(1021,1022). succ(1022,1023). succ(1023,1024). succ(1024,1025). succ(1025,1026).
succ(1901,1902). succ(1902,1903). succ(1903,1904). succ(1904,1905). succ(1905,1906).
succ(2221,2222). succ(2222,2223). succ(2223,2224). succ(2224,2225). succ(2225,2226).
succ(2656,2657). succ(2657,2658). succ(2658,2659). succ(2659,2660). succ(2660,2661).
succ(2706,2707). succ(2707,2708). succ(2708,2709). succ(2709,2710). succ(2710,2711).
succ(4956,4957). succ(4957,4958). succ(4958,4959). succ(4959,4960). succ(4960,4961).
succ(4966,4967). succ(4967,4968). succ(4968,4969). succ(4969,4970). succ(4970,4971).
succ(6316,6317). succ(6317,6318). succ(6318,6319). succ(6319,6320). succ(6320,6321).
succ(6576,6577). succ(6577,6578). succ(6578,6579). succ(6579,6580). succ(6580,6581).
succ(6581,6582). succ(6582,6583). succ(6583,6584). succ(6584,6585). succ(6585,6586).
succ(7331,7332). succ(7332,7333). succ(7333,7334). succ(7334,7335). succ(7335,7336).
is_prime(1019). is_prime(1021). is_prime(1031). is_prime(1033). is_prime(1039). is_prime(1049). is_prime(1051). is_prime(1061). is_prime(1063). is_prime(1069).
is_prime(1901). is_prime(1907). is_prime(1913). is_prime(1931). is_prime(1933). is_prime(1949). is_prime(1951). is_prime(1973). is_prime(1979). is_prime(1987).
is_prime(2221). is_prime(2237). is_prime(2239). is_prime(2243). is_prime(2251). is_prime(2267). is_prime(2269). is_prime(2273). is_prime(2281). is_prime(2287).
is_prime(6577). is_prime(6581). is_prime(6599). is_prime(6607). is_prime(6619). is_prime(6637). is_prime(6653). is_prime(6659). is_prime(6661). is_prime(6673).
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