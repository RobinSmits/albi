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

integer(1031). integer(1032). integer(1033). integer(1034). integer(1035). integer(1036). integer(1037). integer(1038). integer(1039). integer(1040).
integer(1871). integer(1872). integer(1873). integer(1874). integer(1875). integer(1876). integer(1877). integer(1878). integer(1879). integer(1880).
integer(2731). integer(2732). integer(2733). integer(2734). integer(2735). integer(2736). integer(2737). integer(2738). integer(2739). integer(2740).
integer(3121). integer(3122). integer(3123). integer(3124). integer(3125). integer(3126). integer(3127). integer(3128). integer(3129). integer(3130).
integer(4441). integer(4442). integer(4443). integer(4444). integer(4445). integer(4446). integer(4447). integer(4448). integer(4449). integer(4450).
integer(5431). integer(5432). integer(5433). integer(5434). integer(5435). integer(5436). integer(5437). integer(5438). integer(5439). integer(5440).
integer(5881). integer(5882). integer(5883). integer(5884). integer(5885). integer(5886). integer(5887). integer(5888). integer(5889). integer(5890).
succ(36,37). succ(37,38). succ(38,39). succ(39,40). succ(40,41).
succ(176,177). succ(177,178). succ(178,179). succ(179,180). succ(180,181).
succ(906,907). succ(907,908). succ(908,909). succ(909,910). succ(910,911).
succ(1031,1032). succ(1032,1033). succ(1033,1034). succ(1034,1035). succ(1035,1036).
succ(1871,1872). succ(1872,1873). succ(1873,1874). succ(1874,1875). succ(1875,1876).
succ(2286,2287). succ(2287,2288). succ(2288,2289). succ(2289,2290). succ(2290,2291).
succ(2676,2677). succ(2677,2678). succ(2678,2679). succ(2679,2680). succ(2680,2681).
succ(2731,2732). succ(2732,2733). succ(2733,2734). succ(2734,2735). succ(2735,2736).
succ(3121,3122). succ(3122,3123). succ(3123,3124). succ(3124,3125). succ(3125,3126).
succ(3136,3137). succ(3137,3138). succ(3138,3139). succ(3139,3140). succ(3140,3141).
succ(4326,4327). succ(4327,4328). succ(4328,4329). succ(4329,4330). succ(4330,4331).
succ(4336,4337). succ(4337,4338). succ(4338,4339). succ(4339,4340). succ(4340,4341).
succ(4441,4442). succ(4442,4443). succ(4443,4444). succ(4444,4445). succ(4445,4446).
succ(4446,4447). succ(4447,4448). succ(4448,4449). succ(4449,4450). succ(4450,4451).
succ(5431,5432). succ(5432,5433). succ(5433,5434). succ(5434,5435). succ(5435,5436).
succ(5436,5437). succ(5437,5438). succ(5438,5439). succ(5439,5440). succ(5440,5441).
succ(5881,5882). succ(5882,5883). succ(5883,5884). succ(5884,5885). succ(5885,5886).
succ(5896,5897). succ(5897,5898). succ(5898,5899). succ(5899,5900). succ(5900,5901).
succ(6336,6337). succ(6337,6338). succ(6338,6339). succ(6339,6340). succ(6340,6341).
is_prime(179). is_prime(181). is_prime(191). is_prime(193). is_prime(197). is_prime(199). is_prime(211). is_prime(223). is_prime(227). is_prime(229).
is_prime(2293). is_prime(2297). is_prime(2309). is_prime(2311). is_prime(2333). is_prime(2339). is_prime(2341). is_prime(2347). is_prime(2351). is_prime(2357).
is_prime(2749). is_prime(2753). is_prime(2767). is_prime(2777). is_prime(2789). is_prime(2791). is_prime(2797). is_prime(2801). is_prime(2803). is_prime(2819).
is_prime(4327). is_prime(4337). is_prime(4339). is_prime(4349). is_prime(4357). is_prime(4363). is_prime(4373). is_prime(4391). is_prime(4397). is_prime(4409).
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