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

integer(421). integer(422). integer(423). integer(424). integer(425). integer(426). integer(427). integer(428). integer(429). integer(430).
integer(431). integer(432). integer(433). integer(434). integer(435). integer(436). integer(437). integer(438). integer(439). integer(440).
integer(761). integer(762). integer(763). integer(764). integer(765). integer(766). integer(767). integer(768). integer(769). integer(770).
integer(2341). integer(2342). integer(2343). integer(2344). integer(2345). integer(2346). integer(2347). integer(2348). integer(2349). integer(2350).
integer(2351). integer(2352). integer(2353). integer(2354). integer(2355). integer(2356). integer(2357). integer(2358). integer(2359). integer(2360).
integer(2411). integer(2412). integer(2413). integer(2414). integer(2415). integer(2416). integer(2417). integer(2418). integer(2419). integer(2420).
integer(2851). integer(2852). integer(2853). integer(2854). integer(2855). integer(2856). integer(2857). integer(2858). integer(2859). integer(2860).
integer(3461). integer(3462). integer(3463). integer(3464). integer(3465). integer(3466). integer(3467). integer(3468). integer(3469). integer(3470).
succ(101,102). succ(102,103). succ(103,104). succ(104,105). succ(105,106).
succ(396,397). succ(397,398). succ(398,399). succ(399,400). succ(400,401).
succ(421,422). succ(422,423). succ(423,424). succ(424,425). succ(425,426).
succ(431,432). succ(432,433). succ(433,434). succ(434,435). succ(435,436).
succ(761,762). succ(762,763). succ(763,764). succ(764,765). succ(765,766).
succ(826,827). succ(827,828). succ(828,829). succ(829,830). succ(830,831).
succ(2341,2342). succ(2342,2343). succ(2343,2344). succ(2344,2345). succ(2345,2346).
succ(2351,2352). succ(2352,2353). succ(2353,2354). succ(2354,2355). succ(2355,2356).
succ(2411,2412). succ(2412,2413). succ(2413,2414). succ(2414,2415). succ(2415,2416).
succ(2851,2852). succ(2852,2853). succ(2853,2854). succ(2854,2855). succ(2855,2856).
succ(3461,3462). succ(3462,3463). succ(3463,3464). succ(3464,3465). succ(3465,3466).
succ(4156,4157). succ(4157,4158). succ(4158,4159). succ(4159,4160). succ(4160,4161).
succ(5106,5107). succ(5107,5108). succ(5108,5109). succ(5109,5110). succ(5110,5111).
succ(6046,6047). succ(6047,6048). succ(6048,6049). succ(6049,6050). succ(6050,6051).
succ(6366,6367). succ(6367,6368). succ(6368,6369). succ(6369,6370). succ(6370,6371).
is_prime(2). is_prime(3). is_prime(5). is_prime(7). is_prime(11). is_prime(13). is_prime(17). is_prime(19). is_prime(23). is_prime(29).
is_prime(4153). is_prime(4157). is_prime(4159). is_prime(4177). is_prime(4201). is_prime(4211). is_prime(4217). is_prime(4219). is_prime(4229). is_prime(4231).
is_prime(6373). is_prime(6379). is_prime(6389). is_prime(6397). is_prime(6421). is_prime(6427). is_prime(6449). is_prime(6451). is_prime(6469). is_prime(6473).
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