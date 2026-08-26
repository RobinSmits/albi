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

integer(141). integer(142). integer(143). integer(144). integer(145). integer(146). integer(147). integer(148). integer(149). integer(150).
integer(421). integer(422). integer(423). integer(424). integer(425). integer(426). integer(427). integer(428). integer(429). integer(430).
integer(431). integer(432). integer(433). integer(434). integer(435). integer(436). integer(437). integer(438). integer(439). integer(440).
integer(2351). integer(2352). integer(2353). integer(2354). integer(2355). integer(2356). integer(2357). integer(2358). integer(2359). integer(2360).
integer(2371). integer(2372). integer(2373). integer(2374). integer(2375). integer(2376). integer(2377). integer(2378). integer(2379). integer(2380).
integer(6361). integer(6362). integer(6363). integer(6364). integer(6365). integer(6366). integer(6367). integer(6368). integer(6369). integer(6370).
succ(141,142). succ(142,143). succ(143,144). succ(144,145). succ(145,146).
succ(256,257). succ(257,258). succ(258,259). succ(259,260). succ(260,261).
succ(421,422). succ(422,423). succ(423,424). succ(424,425). succ(425,426).
succ(431,432). succ(432,433). succ(433,434). succ(434,435). succ(435,436).
succ(456,457). succ(457,458). succ(458,459). succ(459,460). succ(460,461).
succ(1596,1597). succ(1597,1598). succ(1598,1599). succ(1599,1600). succ(1600,1601).
succ(1776,1777). succ(1777,1778). succ(1778,1779). succ(1779,1780). succ(1780,1781).
succ(2346,2347). succ(2347,2348). succ(2348,2349). succ(2349,2350). succ(2350,2351).
succ(2351,2352). succ(2352,2353). succ(2353,2354). succ(2354,2355). succ(2355,2356).
succ(2356,2357). succ(2357,2358). succ(2358,2359). succ(2359,2360). succ(2360,2361).
succ(2371,2372). succ(2372,2373). succ(2373,2374). succ(2374,2375). succ(2375,2376).
succ(6361,6362). succ(6362,6363). succ(6363,6364). succ(6364,6365). succ(6365,6366).
succ(7756,7757). succ(7757,7758). succ(7758,7759). succ(7759,7760). succ(7760,7761).
succ(7926,7927). succ(7927,7928). succ(7928,7929). succ(7929,7930). succ(7930,7931).
is_prime(2). is_prime(3). is_prime(5). is_prime(7). is_prime(11). is_prime(13). is_prime(17). is_prime(19). is_prime(23). is_prime(29).
is_prime(1597). is_prime(1601). is_prime(1607). is_prime(1609). is_prime(1613). is_prime(1619). is_prime(1621). is_prime(1627). is_prime(1637). is_prime(1657).
is_prime(2371). is_prime(2377). is_prime(2381). is_prime(2383). is_prime(2389). is_prime(2393). is_prime(2399). is_prime(2411). is_prime(2417). is_prime(2423).
is_prime(7927). is_prime(7933). is_prime(7937). is_prime(7949). is_prime(7951). is_prime(7963). is_prime(7993). is_prime(8009). is_prime(8011). is_prime(8017).
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