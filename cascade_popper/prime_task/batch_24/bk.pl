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

integer(31). integer(32). integer(33). integer(34). integer(35). integer(36). integer(37). integer(38). integer(39). integer(40).
integer(521). integer(522). integer(523). integer(524). integer(525). integer(526). integer(527). integer(528). integer(529). integer(530).
integer(821). integer(822). integer(823). integer(824). integer(825). integer(826). integer(827). integer(828). integer(829). integer(830).
integer(1811). integer(1812). integer(1813). integer(1814). integer(1815). integer(1816). integer(1817). integer(1818). integer(1819). integer(1820).
integer(1931). integer(1932). integer(1933). integer(1934). integer(1935). integer(1936). integer(1937). integer(1938). integer(1939). integer(1940).
integer(4651). integer(4652). integer(4653). integer(4654). integer(4655). integer(4656). integer(4657). integer(4658). integer(4659). integer(4660).
succ(31,32). succ(32,33). succ(33,34). succ(34,35). succ(35,36).
succ(96,97). succ(97,98). succ(98,99). succ(99,100). succ(100,101).
succ(366,367). succ(367,368). succ(368,369). succ(369,370). succ(370,371).
succ(456,457). succ(457,458). succ(458,459). succ(459,460). succ(460,461).
succ(521,522). succ(522,523). succ(523,524). succ(524,525). succ(525,526).
succ(821,822). succ(822,823). succ(823,824). succ(824,825). succ(825,826).
succ(826,827). succ(827,828). succ(828,829). succ(829,830). succ(830,831).
succ(1811,1812). succ(1812,1813). succ(1813,1814). succ(1814,1815). succ(1815,1816).
succ(1931,1932). succ(1932,1933). succ(1933,1934). succ(1934,1935). succ(1935,1936).
succ(2136,2137). succ(2137,2138). succ(2138,2139). succ(2139,2140). succ(2140,2141).
succ(2376,2377). succ(2377,2378). succ(2378,2379). succ(2379,2380). succ(2380,2381).
succ(4651,4652). succ(4652,4653). succ(4653,4654). succ(4654,4655). succ(4655,4656).
succ(4786,4787). succ(4787,4788). succ(4788,4789). succ(4789,4790). succ(4790,4791).
succ(5166,5167). succ(5167,5168). succ(5168,5169). succ(5169,5170). succ(5170,5171).
succ(7296,7297). succ(7297,7298). succ(7298,7299). succ(7299,7300). succ(7300,7301).
succ(7306,7307). succ(7307,7308). succ(7308,7309). succ(7309,7310). succ(7310,7311).
is_prime(31). is_prime(37). is_prime(41). is_prime(43). is_prime(47). is_prime(53). is_prime(59). is_prime(61). is_prime(67). is_prime(71).
is_prime(1823). is_prime(1831). is_prime(1847). is_prime(1861). is_prime(1867). is_prime(1871). is_prime(1873). is_prime(1877). is_prime(1879). is_prime(1889).
is_prime(7307). is_prime(7309). is_prime(7321). is_prime(7331). is_prime(7333). is_prime(7349). is_prime(7351). is_prime(7369). is_prime(7393). is_prime(7411).
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