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

integer(231). integer(232). integer(233). integer(234). integer(235). integer(236). integer(237). integer(238). integer(239). integer(240).
integer(2671). integer(2672). integer(2673). integer(2674). integer(2675). integer(2676). integer(2677). integer(2678). integer(2679). integer(2680).
integer(4201). integer(4202). integer(4203). integer(4204). integer(4205). integer(4206). integer(4207). integer(4208). integer(4209). integer(4210).
integer(4211). integer(4212). integer(4213). integer(4214). integer(4215). integer(4216). integer(4217). integer(4218). integer(4219). integer(4220).
integer(4441). integer(4442). integer(4443). integer(4444). integer(4445). integer(4446). integer(4447). integer(4448). integer(4449). integer(4450).
integer(6211). integer(6212). integer(6213). integer(6214). integer(6215). integer(6216). integer(6217). integer(6218). integer(6219). integer(6220).
integer(7481). integer(7482). integer(7483). integer(7484). integer(7485). integer(7486). integer(7487). integer(7488). integer(7489). integer(7490).
succ(31,32). succ(32,33). succ(33,34). succ(34,35). succ(35,36).
succ(36,37). succ(37,38). succ(38,39). succ(39,40). succ(40,41).
succ(66,67). succ(67,68). succ(68,69). succ(69,70). succ(70,71).
succ(86,87). succ(87,88). succ(88,89). succ(89,90). succ(90,91).
succ(231,232). succ(232,233). succ(233,234). succ(234,235). succ(235,236).
succ(236,237). succ(237,238). succ(238,239). succ(239,240). succ(240,241).
succ(876,877). succ(877,878). succ(878,879). succ(879,880). succ(880,881).
succ(2286,2287). succ(2287,2288). succ(2288,2289). succ(2289,2290). succ(2290,2291).
succ(2296,2297). succ(2297,2298). succ(2298,2299). succ(2299,2300). succ(2300,2301).
succ(2556,2557). succ(2557,2558). succ(2558,2559). succ(2559,2560). succ(2560,2561).
succ(2671,2672). succ(2672,2673). succ(2673,2674). succ(2674,2675). succ(2675,2676).
succ(3516,3517). succ(3517,3518). succ(3518,3519). succ(3519,3520). succ(3520,3521).
succ(3526,3527). succ(3527,3528). succ(3528,3529). succ(3529,3530). succ(3530,3531).
succ(4201,4202). succ(4202,4203). succ(4203,4204). succ(4204,4205). succ(4205,4206).
succ(4211,4212). succ(4212,4213). succ(4213,4214). succ(4214,4215). succ(4215,4216).
succ(4441,4442). succ(4442,4443). succ(4443,4444). succ(4444,4445). succ(4445,4446).
succ(5406,5407). succ(5407,5408). succ(5408,5409). succ(5409,5410). succ(5410,5411).
succ(6211,6212). succ(6212,6213). succ(6213,6214). succ(6214,6215). succ(6215,6216).
succ(7176,7177). succ(7177,7178). succ(7178,7179). succ(7179,7180). succ(7180,7181).
succ(7296,7297). succ(7297,7298). succ(7298,7299). succ(7299,7300). succ(7300,7301).
succ(7481,7482). succ(7482,7483). succ(7483,7484). succ(7484,7485). succ(7485,7486).
succ(7486,7487). succ(7487,7488). succ(7488,7489). succ(7489,7490). succ(7490,7491).
is_prime(179). is_prime(181). is_prime(191). is_prime(193). is_prime(197). is_prime(199). is_prime(211). is_prime(223). is_prime(227). is_prime(229).
is_prime(233). is_prime(239). is_prime(241). is_prime(251). is_prime(257). is_prime(263). is_prime(269). is_prime(271). is_prime(277). is_prime(281).
is_prime(877). is_prime(881). is_prime(883). is_prime(887). is_prime(907). is_prime(911). is_prime(919). is_prime(929). is_prime(937). is_prime(941).
is_prime(3517). is_prime(3527). is_prime(3529). is_prime(3533). is_prime(3539). is_prime(3541). is_prime(3547). is_prime(3557). is_prime(3559). is_prime(3571).
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