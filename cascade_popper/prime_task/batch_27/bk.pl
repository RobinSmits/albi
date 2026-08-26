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

integer(521). integer(522). integer(523). integer(524). integer(525). integer(526). integer(527). integer(528). integer(529). integer(530).
integer(751). integer(752). integer(753). integer(754). integer(755). integer(756). integer(757). integer(758). integer(759). integer(760).
integer(1321). integer(1322). integer(1323). integer(1324). integer(1325). integer(1326). integer(1327). integer(1328). integer(1329). integer(1330).
integer(2311). integer(2312). integer(2313). integer(2314). integer(2315). integer(2316). integer(2317). integer(2318). integer(2319). integer(2320).
integer(2551). integer(2552). integer(2553). integer(2554). integer(2555). integer(2556). integer(2557). integer(2558). integer(2559). integer(2560).
integer(4751). integer(4752). integer(4753). integer(4754). integer(4755). integer(4756). integer(4757). integer(4758). integer(4759). integer(4760).
integer(6011). integer(6012). integer(6013). integer(6014). integer(6015). integer(6016). integer(6017). integer(6018). integer(6019). integer(6020).
succ(36,37). succ(37,38). succ(38,39). succ(39,40). succ(40,41).
succ(66,67). succ(67,68). succ(68,69). succ(69,70). succ(70,71).
succ(521,522). succ(522,523). succ(523,524). succ(524,525). succ(525,526).
succ(751,752). succ(752,753). succ(753,754). succ(754,755). succ(755,756).
succ(1216,1217). succ(1217,1218). succ(1218,1219). succ(1219,1220). succ(1220,1221).
succ(1306,1307). succ(1307,1308). succ(1308,1309). succ(1309,1310). succ(1310,1311).
succ(1321,1322). succ(1322,1323). succ(1323,1324). succ(1324,1325). succ(1325,1326).
succ(1566,1567). succ(1567,1568). succ(1568,1569). succ(1569,1570). succ(1570,1571).
succ(2311,2312). succ(2312,2313). succ(2313,2314). succ(2314,2315). succ(2315,2316).
succ(2551,2552). succ(2552,2553). succ(2553,2554). succ(2554,2555). succ(2555,2556).
succ(2556,2557). succ(2557,2558). succ(2558,2559). succ(2559,2560). succ(2560,2561).
succ(2956,2957). succ(2957,2958). succ(2958,2959). succ(2959,2960). succ(2960,2961).
succ(4751,4752). succ(4752,4753). succ(4753,4754). succ(4754,4755). succ(4755,4756).
succ(6006,6007). succ(6007,6008). succ(6008,6009). succ(6009,6010). succ(6010,6011).
succ(6011,6012). succ(6012,6013). succ(6013,6014). succ(6014,6015). succ(6015,6016).
is_prime(179). is_prime(181). is_prime(191). is_prime(193). is_prime(197). is_prime(199). is_prime(211). is_prime(223). is_prime(227). is_prime(229).
is_prime(1229). is_prime(1231). is_prime(1237). is_prime(1249). is_prime(1259). is_prime(1277). is_prime(1279). is_prime(1283). is_prime(1289). is_prime(1291).
is_prime(2749). is_prime(2753). is_prime(2767). is_prime(2777). is_prime(2789). is_prime(2791). is_prime(2797). is_prime(2801). is_prime(2803). is_prime(2819).
is_prime(4759). is_prime(4783). is_prime(4787). is_prime(4789). is_prime(4793). is_prime(4799). is_prime(4801). is_prime(4813). is_prime(4817). is_prime(4831).
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