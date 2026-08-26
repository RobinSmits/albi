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
integer(251). integer(252). integer(253). integer(254). integer(255). integer(256). integer(257). integer(258). integer(259). integer(260).
integer(911). integer(912). integer(913). integer(914). integer(915). integer(916). integer(917). integer(918). integer(919). integer(920).
integer(1021). integer(1022). integer(1023). integer(1024). integer(1025). integer(1026). integer(1027). integer(1028). integer(1029). integer(1030).
integer(1201). integer(1202). integer(1203). integer(1204). integer(1205). integer(1206). integer(1207). integer(1208). integer(1209). integer(1210).
integer(1451). integer(1452). integer(1453). integer(1454). integer(1455). integer(1456). integer(1457). integer(1458). integer(1459). integer(1460).
integer(2371). integer(2372). integer(2373). integer(2374). integer(2375). integer(2376). integer(2377). integer(2378). integer(2379). integer(2380).
integer(3001). integer(3002). integer(3003). integer(3004). integer(3005). integer(3006). integer(3007). integer(3008). integer(3009). integer(3010).
integer(3011). integer(3012). integer(3013). integer(3014). integer(3015). integer(3016). integer(3017). integer(3018). integer(3019). integer(3020).
integer(3191). integer(3192). integer(3193). integer(3194). integer(3195). integer(3196). integer(3197). integer(3198). integer(3199). integer(3200).
integer(3221). integer(3222). integer(3223). integer(3224). integer(3225). integer(3226). integer(3227). integer(3228). integer(3229). integer(3230).
integer(6101). integer(6102). integer(6103). integer(6104). integer(6105). integer(6106). integer(6107). integer(6108). integer(6109). integer(6110).
succ(126,127). succ(127,128). succ(128,129). succ(129,130). succ(130,131).
succ(131,132). succ(132,133). succ(133,134). succ(134,135). succ(135,136).
succ(136,137). succ(137,138). succ(138,139). succ(139,140). succ(140,141).
succ(156,157). succ(157,158). succ(158,159). succ(159,160). succ(160,161).
succ(251,252). succ(252,253). succ(253,254). succ(254,255). succ(255,256).
succ(906,907). succ(907,908). succ(908,909). succ(909,910). succ(910,911).
succ(911,912). succ(912,913). succ(913,914). succ(914,915). succ(915,916).
succ(1021,1022). succ(1022,1023). succ(1023,1024). succ(1024,1025). succ(1025,1026).
succ(1201,1202). succ(1202,1203). succ(1203,1204). succ(1204,1205). succ(1205,1206).
succ(1446,1447). succ(1447,1448). succ(1448,1449). succ(1449,1450). succ(1450,1451).
succ(1451,1452). succ(1452,1453). succ(1453,1454). succ(1454,1455). succ(1455,1456).
succ(1986,1987). succ(1987,1988). succ(1988,1989). succ(1989,1990). succ(1990,1991).
succ(2286,2287). succ(2287,2288). succ(2288,2289). succ(2289,2290). succ(2290,2291).
succ(2371,2372). succ(2372,2373). succ(2373,2374). succ(2374,2375). succ(2375,2376).
succ(2376,2377). succ(2377,2378). succ(2378,2379). succ(2379,2380). succ(2380,2381).
succ(2616,2617). succ(2617,2618). succ(2618,2619). succ(2619,2620). succ(2620,2621).
succ(3001,3002). succ(3002,3003). succ(3003,3004). succ(3004,3005). succ(3005,3006).
succ(3011,3012). succ(3012,3013). succ(3013,3014). succ(3014,3015). succ(3015,3016).
succ(3191,3192). succ(3192,3193). succ(3193,3194). succ(3194,3195). succ(3195,3196).
succ(3221,3222). succ(3222,3223). succ(3223,3224). succ(3224,3225). succ(3225,3226).
succ(6101,6102). succ(6102,6103). succ(6103,6104). succ(6104,6105). succ(6105,6106).
is_prime(127). is_prime(131). is_prime(137). is_prime(139). is_prime(149). is_prime(151). is_prime(157). is_prime(163). is_prime(167). is_prime(173).
is_prime(2371). is_prime(2377). is_prime(2381). is_prime(2383). is_prime(2389). is_prime(2393). is_prime(2399). is_prime(2411). is_prime(2417). is_prime(2423).
is_prime(3001). is_prime(3011). is_prime(3019). is_prime(3023). is_prime(3037). is_prime(3041). is_prime(3049). is_prime(3061). is_prime(3067). is_prime(3079).
is_composite(245). is_composite(246). is_composite(247). is_composite(248). is_composite(249). is_composite(250). is_composite(252). is_composite(253). is_composite(254). is_composite(255).
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