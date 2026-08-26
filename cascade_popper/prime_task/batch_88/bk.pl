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

integer(151). integer(152). integer(153). integer(154). integer(155). integer(156). integer(157). integer(158). integer(159). integer(160).
integer(191). integer(192). integer(193). integer(194). integer(195). integer(196). integer(197). integer(198). integer(199). integer(200).
integer(701). integer(702). integer(703). integer(704). integer(705). integer(706). integer(707). integer(708). integer(709). integer(710).
integer(1381). integer(1382). integer(1383). integer(1384). integer(1385). integer(1386). integer(1387). integer(1388). integer(1389). integer(1390).
integer(1901). integer(1902). integer(1903). integer(1904). integer(1905). integer(1906). integer(1907). integer(1908). integer(1909). integer(1910).
integer(2141). integer(2142). integer(2143). integer(2144). integer(2145). integer(2146). integer(2147). integer(2148). integer(2149). integer(2150).
integer(2711). integer(2712). integer(2713). integer(2714). integer(2715). integer(2716). integer(2717). integer(2718). integer(2719). integer(2720).
integer(2791). integer(2792). integer(2793). integer(2794). integer(2795). integer(2796). integer(2797). integer(2798). integer(2799). integer(2800).
succ(151,152). succ(152,153). succ(153,154). succ(154,155). succ(155,156).
succ(186,187). succ(187,188). succ(188,189). succ(189,190). succ(190,191).
succ(191,192). succ(192,193). succ(193,194). succ(194,195). succ(195,196).
succ(701,702). succ(702,703). succ(703,704). succ(704,705). succ(705,706).
succ(886,887). succ(887,888). succ(888,889). succ(889,890). succ(890,891).
succ(1381,1382). succ(1382,1383). succ(1383,1384). succ(1384,1385). succ(1385,1386).
succ(1866,1867). succ(1867,1868). succ(1868,1869). succ(1869,1870). succ(1870,1871).
succ(1901,1902). succ(1902,1903). succ(1903,1904). succ(1904,1905). succ(1905,1906).
succ(1906,1907). succ(1907,1908). succ(1908,1909). succ(1909,1910). succ(1910,1911).
succ(2141,2142). succ(2142,2143). succ(2143,2144). succ(2144,2145). succ(2145,2146).
succ(2676,2677). succ(2677,2678). succ(2678,2679). succ(2679,2680). succ(2680,2681).
succ(2706,2707). succ(2707,2708). succ(2708,2709). succ(2709,2710). succ(2710,2711).
succ(2711,2712). succ(2712,2713). succ(2713,2714). succ(2714,2715). succ(2715,2716).
succ(2791,2792). succ(2792,2793). succ(2793,2794). succ(2794,2795). succ(2795,2796).
succ(3216,3217). succ(3217,3218). succ(3218,3219). succ(3219,3220). succ(3220,3221).
succ(4786,4787). succ(4787,4788). succ(4788,4789). succ(4789,4790). succ(4790,4791).
succ(7246,7247). succ(7247,7248). succ(7248,7249). succ(7249,7250). succ(7250,7251).
is_prime(1381). is_prime(1399). is_prime(1409). is_prime(1423). is_prime(1427). is_prime(1429). is_prime(1433). is_prime(1439). is_prime(1447). is_prime(1451).
is_prime(1901). is_prime(1907). is_prime(1913). is_prime(1931). is_prime(1933). is_prime(1949). is_prime(1951). is_prime(1973). is_prime(1979). is_prime(1987).
is_prime(6679). is_prime(6689). is_prime(6691). is_prime(6701). is_prime(6703). is_prime(6709). is_prime(6719). is_prime(6733). is_prime(6737). is_prime(6761).
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