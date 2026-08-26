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
integer(1031). integer(1032). integer(1033). integer(1034). integer(1035). integer(1036). integer(1037). integer(1038). integer(1039). integer(1040).
integer(2411). integer(2412). integer(2413). integer(2414). integer(2415). integer(2416). integer(2417). integer(2418). integer(2419). integer(2420).
integer(6301). integer(6302). integer(6303). integer(6304). integer(6305). integer(6306). integer(6307). integer(6308). integer(6309). integer(6310).
integer(6761). integer(6762). integer(6763). integer(6764). integer(6765). integer(6766). integer(6767). integer(6768). integer(6769). integer(6770).
integer(7541). integer(7542). integer(7543). integer(7544). integer(7545). integer(7546). integer(7547). integer(7548). integer(7549). integer(7550).
succ(36,37). succ(37,38). succ(38,39). succ(39,40). succ(40,41).
succ(41,42). succ(42,43). succ(43,44). succ(44,45). succ(45,46).
succ(136,137). succ(137,138). succ(138,139). succ(139,140). succ(140,141).
succ(221,222). succ(222,223). succ(223,224). succ(224,225). succ(225,226).
succ(1031,1032). succ(1032,1033). succ(1033,1034). succ(1034,1035). succ(1035,1036).
succ(2411,2412). succ(2412,2413). succ(2413,2414). succ(2414,2415). succ(2415,2416).
succ(2776,2777). succ(2777,2778). succ(2778,2779). succ(2779,2780). succ(2780,2781).
succ(6301,6302). succ(6302,6303). succ(6303,6304). succ(6304,6305). succ(6305,6306).
succ(6546,6547). succ(6547,6548). succ(6548,6549). succ(6549,6550). succ(6550,6551).
succ(6761,6762). succ(6762,6763). succ(6763,6764). succ(6764,6765). succ(6765,6766).
succ(7536,7537). succ(7537,7538). succ(7538,7539). succ(7539,7540). succ(7540,7541).
succ(7541,7542). succ(7542,7543). succ(7543,7544). succ(7544,7545). succ(7545,7546).
is_prime(2063). is_prime(2069). is_prime(2081). is_prime(2083). is_prime(2087). is_prime(2089). is_prime(2099). is_prime(2111). is_prime(2113). is_prime(2129).
is_prime(6763). is_prime(6779). is_prime(6781). is_prime(6791). is_prime(6793). is_prime(6803). is_prime(6823). is_prime(6827). is_prime(6829). is_prime(6833).
is_composite(33). is_composite(34). is_composite(35). is_composite(36). is_composite(38). is_composite(39). is_composite(40). is_composite(42). is_composite(44). is_composite(45).
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