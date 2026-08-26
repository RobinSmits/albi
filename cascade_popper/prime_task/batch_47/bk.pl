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
integer(541). integer(542). integer(543). integer(544). integer(545). integer(546). integer(547). integer(548). integer(549). integer(550).
integer(701). integer(702). integer(703). integer(704). integer(705). integer(706). integer(707). integer(708). integer(709). integer(710).
integer(2251). integer(2252). integer(2253). integer(2254). integer(2255). integer(2256). integer(2257). integer(2258). integer(2259). integer(2260).
integer(2381). integer(2382). integer(2383). integer(2384). integer(2385). integer(2386). integer(2387). integer(2388). integer(2389). integer(2390).
integer(2741). integer(2742). integer(2743). integer(2744). integer(2745). integer(2746). integer(2747). integer(2748). integer(2749). integer(2750).
integer(4211). integer(4212). integer(4213). integer(4214). integer(4215). integer(4216). integer(4217). integer(4218). integer(4219). integer(4220).
integer(4451). integer(4452). integer(4453). integer(4454). integer(4455). integer(4456). integer(4457). integer(4458). integer(4459). integer(4460).
integer(5441). integer(5442). integer(5443). integer(5444). integer(5445). integer(5446). integer(5447). integer(5448). integer(5449). integer(5450).
integer(5591). integer(5592). integer(5593). integer(5594). integer(5595). integer(5596). integer(5597). integer(5598). integer(5599). integer(5600).
succ(206,207). succ(207,208). succ(208,209). succ(209,210). succ(210,211).
succ(211,212). succ(212,213). succ(213,214). succ(214,215). succ(215,216).
succ(316,317). succ(317,318). succ(318,319). succ(319,320). succ(320,321).
succ(396,397). succ(397,398). succ(398,399). succ(399,400). succ(400,401).
succ(541,542). succ(542,543). succ(543,544). succ(544,545). succ(545,546).
succ(586,587). succ(587,588). succ(588,589). succ(589,590). succ(590,591).
succ(606,607). succ(607,608). succ(608,609). succ(609,610). succ(610,611).
succ(701,702). succ(702,703). succ(703,704). succ(704,705). succ(705,706).
succ(2251,2252). succ(2252,2253). succ(2253,2254). succ(2254,2255). succ(2255,2256).
succ(2381,2382). succ(2382,2383). succ(2383,2384). succ(2384,2385). succ(2385,2386).
succ(2741,2742). succ(2742,2743). succ(2743,2744). succ(2744,2745). succ(2745,2746).
succ(4211,4212). succ(4212,4213). succ(4213,4214). succ(4214,4215). succ(4215,4216).
succ(4216,4217). succ(4217,4218). succ(4218,4219). succ(4219,4220). succ(4220,4221).
succ(4446,4447). succ(4447,4448). succ(4448,4449). succ(4449,4450). succ(4450,4451).
succ(4451,4452). succ(4452,4453). succ(4453,4454). succ(4454,4455). succ(4455,4456).
succ(4596,4597). succ(4597,4598). succ(4598,4599). succ(4599,4600). succ(4600,4601).
succ(5436,5437). succ(5437,5438). succ(5438,5439). succ(5439,5440). succ(5440,5441).
succ(5441,5442). succ(5442,5443). succ(5443,5444). succ(5444,5445). succ(5445,5446).
succ(5556,5557). succ(5557,5558). succ(5558,5559). succ(5559,5560). succ(5560,5561).
succ(5591,5592). succ(5592,5593). succ(5593,5594). succ(5594,5595). succ(5595,5596).
is_prime(419). is_prime(421). is_prime(431). is_prime(433). is_prime(439). is_prime(443). is_prime(449). is_prime(457). is_prime(461). is_prime(463).
is_prime(607). is_prime(613). is_prime(617). is_prime(619). is_prime(631). is_prime(641). is_prime(643). is_prime(647). is_prime(653). is_prime(659).
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