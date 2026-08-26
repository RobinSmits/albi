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

integer(31). integer(32). integer(33). integer(34). integer(35). integer(36). integer(37). integer(38). integer(39). integer(40).
integer(151). integer(152). integer(153). integer(154). integer(155). integer(156). integer(157). integer(158). integer(159). integer(160).
integer(541). integer(542). integer(543). integer(544). integer(545). integer(546). integer(547). integer(548). integer(549). integer(550).
integer(1621). integer(1622). integer(1623). integer(1624). integer(1625). integer(1626). integer(1627). integer(1628). integer(1629). integer(1630).
integer(1831). integer(1832). integer(1833). integer(1834). integer(1835). integer(1836). integer(1837). integer(1838). integer(1839). integer(1840).
integer(2161). integer(2162). integer(2163). integer(2164). integer(2165). integer(2166). integer(2167). integer(2168). integer(2169). integer(2170).
integer(3041). integer(3042). integer(3043). integer(3044). integer(3045). integer(3046). integer(3047). integer(3048). integer(3049). integer(3050).
integer(3851). integer(3852). integer(3853). integer(3854). integer(3855). integer(3856). integer(3857). integer(3858). integer(3859). integer(3860).
integer(7001). integer(7002). integer(7003). integer(7004). integer(7005). integer(7006). integer(7007). integer(7008). integer(7009). integer(7010).
succ(31,32). succ(32,33). succ(33,34). succ(34,35). succ(35,36).
succ(36,37). succ(37,38). succ(38,39). succ(39,40). succ(40,41).
succ(46,47). succ(47,48). succ(48,49). succ(49,50). succ(50,51).
succ(151,152). succ(152,153). succ(153,154). succ(154,155). succ(155,156).
succ(156,157). succ(157,158). succ(158,159). succ(159,160). succ(160,161).
succ(541,542). succ(542,543). succ(543,544). succ(544,545). succ(545,546).
succ(1276,1277). succ(1277,1278). succ(1278,1279). succ(1279,1280). succ(1280,1281).
succ(1306,1307). succ(1307,1308). succ(1308,1309). succ(1309,1310). succ(1310,1311).
succ(1606,1607). succ(1607,1608). succ(1608,1609). succ(1609,1610). succ(1610,1611).
succ(1621,1622). succ(1622,1623). succ(1623,1624). succ(1624,1625). succ(1625,1626).
succ(1636,1637). succ(1637,1638). succ(1638,1639). succ(1639,1640). succ(1640,1641).
succ(1831,1832). succ(1832,1833). succ(1833,1834). succ(1834,1835). succ(1835,1836).
succ(1846,1847). succ(1847,1848). succ(1848,1849). succ(1849,1850). succ(1850,1851).
succ(2161,2162). succ(2162,2163). succ(2163,2164). succ(2164,2165). succ(2165,2166).
succ(2416,2417). succ(2417,2418). succ(2418,2419). succ(2419,2420). succ(2420,2421).
succ(3036,3037). succ(3037,3038). succ(3038,3039). succ(3039,3040). succ(3040,3041).
succ(3041,3042). succ(3042,3043). succ(3043,3044). succ(3044,3045). succ(3045,3046).
succ(3851,3852). succ(3852,3853). succ(3853,3854). succ(3854,3855). succ(3855,3856).
succ(5386,5387). succ(5387,5388). succ(5388,5389). succ(5389,5390). succ(5390,5391).
succ(7001,7002). succ(7002,7003). succ(7003,7004). succ(7004,7005). succ(7005,7006).
succ(7876,7877). succ(7877,7878). succ(7878,7879). succ(7879,7880). succ(7880,7881).
is_prime(31). is_prime(37). is_prime(41). is_prime(43). is_prime(47). is_prime(53). is_prime(59). is_prime(61). is_prime(67). is_prime(71).
is_prime(5393). is_prime(5399). is_prime(5407). is_prime(5413). is_prime(5417). is_prime(5419). is_prime(5431). is_prime(5437). is_prime(5441). is_prime(5443).
is_prime(7001). is_prime(7013). is_prime(7019). is_prime(7027). is_prime(7039). is_prime(7043). is_prime(7057). is_prime(7069). is_prime(7079). is_prime(7103).
is_composite(542). is_composite(543). is_composite(544). is_composite(545). is_composite(546). is_composite(548). is_composite(549). is_composite(550). is_composite(551). is_composite(552).
is_composite(1278). is_composite(1280). is_composite(1281). is_composite(1282). is_composite(1284). is_composite(1285). is_composite(1286). is_composite(1287). is_composite(1288). is_composite(1290).
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