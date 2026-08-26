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

integer(11). integer(12). integer(13). integer(14). integer(15). integer(16). integer(17). integer(18). integer(19). integer(20).
integer(101). integer(102). integer(103). integer(104). integer(105). integer(106). integer(107). integer(108). integer(109). integer(110).
integer(401). integer(402). integer(403). integer(404). integer(405). integer(406). integer(407). integer(408). integer(409). integer(410).
integer(2521). integer(2522). integer(2523). integer(2524). integer(2525). integer(2526). integer(2527). integer(2528). integer(2529). integer(2530).
integer(2531). integer(2532). integer(2533). integer(2534). integer(2535). integer(2536). integer(2537). integer(2538). integer(2539). integer(2540).
integer(6911). integer(6912). integer(6913). integer(6914). integer(6915). integer(6916). integer(6917). integer(6918). integer(6919). integer(6920).
succ(11,12). succ(12,13). succ(13,14). succ(14,15). succ(15,16).
succ(101,102). succ(102,103). succ(103,104). succ(104,105). succ(105,106).
succ(226,227). succ(227,228). succ(228,229). succ(229,230). succ(230,231).
succ(396,397). succ(397,398). succ(398,399). succ(399,400). succ(400,401).
succ(401,402). succ(402,403). succ(403,404). succ(404,405). succ(405,406).
succ(676,677). succ(677,678). succ(678,679). succ(679,680). succ(680,681).
succ(1906,1907). succ(1907,1908). succ(1908,1909). succ(1909,1910). succ(1910,1911).
succ(2521,2522). succ(2522,2523). succ(2523,2524). succ(2524,2525). succ(2525,2526).
succ(2531,2532). succ(2532,2533). succ(2533,2534). succ(2534,2535). succ(2535,2536).
succ(3616,3617). succ(3617,3618). succ(3618,3619). succ(3619,3620). succ(3620,3621).
succ(3726,3727). succ(3727,3728). succ(3728,3729). succ(3729,3730). succ(3730,3731).
succ(5506,5507). succ(5507,5508). succ(5508,5509). succ(5509,5510). succ(5510,5511).
succ(6906,6907). succ(6907,6908). succ(6908,6909). succ(6909,6910). succ(6910,6911).
succ(6911,6912). succ(6912,6913). succ(6913,6914). succ(6914,6915). succ(6915,6916).
is_prime(3733). is_prime(3739). is_prime(3761). is_prime(3767). is_prime(3769). is_prime(3779). is_prime(3793). is_prime(3797). is_prime(3803). is_prime(3821).
is_prime(4759). is_prime(4783). is_prime(4787). is_prime(4789). is_prime(4793). is_prime(4799). is_prime(4801). is_prime(4813). is_prime(4817). is_prime(4831).
is_composite(219). is_composite(220). is_composite(221). is_composite(222). is_composite(224). is_composite(225). is_composite(226). is_composite(228). is_composite(230). is_composite(231).
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