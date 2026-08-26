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

integer(131). integer(132). integer(133). integer(134). integer(135). integer(136). integer(137). integer(138). integer(139). integer(140).
integer(191). integer(192). integer(193). integer(194). integer(195). integer(196). integer(197). integer(198). integer(199). integer(200).
integer(251). integer(252). integer(253). integer(254). integer(255). integer(256). integer(257). integer(258). integer(259). integer(260).
integer(311). integer(312). integer(313). integer(314). integer(315). integer(316). integer(317). integer(318). integer(319). integer(320).
integer(401). integer(402). integer(403). integer(404). integer(405). integer(406). integer(407). integer(408). integer(409). integer(410).
integer(1801). integer(1802). integer(1803). integer(1804). integer(1805). integer(1806). integer(1807). integer(1808). integer(1809). integer(1810).
integer(7321). integer(7322). integer(7323). integer(7324). integer(7325). integer(7326). integer(7327). integer(7328). integer(7329). integer(7330).
integer(7331). integer(7332). integer(7333). integer(7334). integer(7335). integer(7336). integer(7337). integer(7338). integer(7339). integer(7340).
succ(131,132). succ(132,133). succ(133,134). succ(134,135). succ(135,136).
succ(136,137). succ(137,138). succ(138,139). succ(139,140). succ(140,141).
succ(191,192). succ(192,193). succ(193,194). succ(194,195). succ(195,196).
succ(251,252). succ(252,253). succ(253,254). succ(254,255). succ(255,256).
succ(311,312). succ(312,313). succ(313,314). succ(314,315). succ(315,316).
succ(401,402). succ(402,403). succ(403,404). succ(404,405). succ(405,406).
succ(786,787). succ(787,788). succ(788,789). succ(789,790). succ(790,791).
succ(1786,1787). succ(1787,1788). succ(1788,1789). succ(1789,1790). succ(1790,1791).
succ(1801,1802). succ(1802,1803). succ(1803,1804). succ(1804,1805). succ(1805,1806).
succ(1876,1877). succ(1877,1878). succ(1878,1879). succ(1879,1880). succ(1880,1881).
succ(1986,1987). succ(1987,1988). succ(1988,1989). succ(1989,1990). succ(1990,1991).
succ(3036,3037). succ(3037,3038). succ(3038,3039). succ(3039,3040). succ(3040,3041).
succ(7236,7237). succ(7237,7238). succ(7238,7239). succ(7239,7240). succ(7240,7241).
succ(7321,7322). succ(7322,7323). succ(7323,7324). succ(7324,7325). succ(7325,7326).
succ(7331,7332). succ(7332,7333). succ(7333,7334). succ(7334,7335). succ(7335,7336).
is_prime(5393). is_prime(5399). is_prime(5407). is_prime(5413). is_prime(5417). is_prime(5419). is_prime(5431). is_prime(5437). is_prime(5441). is_prime(5443).
is_prime(6143). is_prime(6151). is_prime(6163). is_prime(6173). is_prime(6197). is_prime(6199). is_prime(6203). is_prime(6211). is_prime(6217). is_prime(6221).
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