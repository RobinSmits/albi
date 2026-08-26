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

integer(171). integer(172). integer(173). integer(174). integer(175). integer(176). integer(177). integer(178). integer(179). integer(180).
integer(701). integer(702). integer(703). integer(704). integer(705). integer(706). integer(707). integer(708). integer(709). integer(710).
integer(2011). integer(2012). integer(2013). integer(2014). integer(2015). integer(2016). integer(2017). integer(2018). integer(2019). integer(2020).
integer(3191). integer(3192). integer(3193). integer(3194). integer(3195). integer(3196). integer(3197). integer(3198). integer(3199). integer(3200).
integer(3691). integer(3692). integer(3693). integer(3694). integer(3695). integer(3696). integer(3697). integer(3698). integer(3699). integer(3700).
integer(3821). integer(3822). integer(3823). integer(3824). integer(3825). integer(3826). integer(3827). integer(3828). integer(3829). integer(3830).
integer(4721). integer(4722). integer(4723). integer(4724). integer(4725). integer(4726). integer(4727). integer(4728). integer(4729). integer(4730).
integer(6311). integer(6312). integer(6313). integer(6314). integer(6315). integer(6316). integer(6317). integer(6318). integer(6319). integer(6320).
integer(6451). integer(6452). integer(6453). integer(6454). integer(6455). integer(6456). integer(6457). integer(6458). integer(6459). integer(6460).
succ(156,157). succ(157,158). succ(158,159). succ(159,160). succ(160,161).
succ(171,172). succ(172,173). succ(173,174). succ(174,175). succ(175,176).
succ(366,367). succ(367,368). succ(368,369). succ(369,370). succ(370,371).
succ(701,702). succ(702,703). succ(703,704). succ(704,705). succ(705,706).
succ(2011,2012). succ(2012,2013). succ(2013,2014). succ(2014,2015). succ(2015,2016).
succ(3186,3187). succ(3187,3188). succ(3188,3189). succ(3189,3190). succ(3190,3191).
succ(3191,3192). succ(3192,3193). succ(3193,3194). succ(3194,3195). succ(3195,3196).
succ(3676,3677). succ(3677,3678). succ(3678,3679). succ(3679,3680). succ(3680,3681).
succ(3691,3692). succ(3692,3693). succ(3693,3694). succ(3694,3695). succ(3695,3696).
succ(3821,3822). succ(3822,3823). succ(3823,3824). succ(3824,3825). succ(3825,3826).
succ(4721,4722). succ(4722,4723). succ(4723,4724). succ(4724,4725). succ(4725,4726).
succ(6276,6277). succ(6277,6278). succ(6278,6279). succ(6279,6280). succ(6280,6281).
succ(6286,6287). succ(6287,6288). succ(6288,6289). succ(6289,6290). succ(6290,6291).
succ(6311,6312). succ(6312,6313). succ(6313,6314). succ(6314,6315). succ(6315,6316).
succ(6316,6317). succ(6317,6318). succ(6318,6319). succ(6319,6320). succ(6320,6321).
succ(6451,6452). succ(6452,6453). succ(6453,6454). succ(6454,6455). succ(6455,6456).
is_prime(1229). is_prime(1231). is_prime(1237). is_prime(1249). is_prime(1259). is_prime(1277). is_prime(1279). is_prime(1283). is_prime(1289). is_prime(1291).
is_prime(3187). is_prime(3191). is_prime(3203). is_prime(3209). is_prime(3217). is_prime(3221). is_prime(3229). is_prime(3251). is_prime(3253). is_prime(3257).
is_prime(6311). is_prime(6317). is_prime(6323). is_prime(6329). is_prime(6337). is_prime(6343). is_prime(6353). is_prime(6359). is_prime(6361). is_prime(6367).
is_composite(171). is_composite(172). is_composite(174). is_composite(175). is_composite(176). is_composite(177). is_composite(178). is_composite(180). is_composite(182). is_composite(183).
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