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

integer(191). integer(192). integer(193). integer(194). integer(195). integer(196). integer(197). integer(198). integer(199). integer(200).
integer(241). integer(242). integer(243). integer(244). integer(245). integer(246). integer(247). integer(248). integer(249). integer(250).
integer(491). integer(492). integer(493). integer(494). integer(495). integer(496). integer(497). integer(498). integer(499). integer(500).
integer(1381). integer(1382). integer(1383). integer(1384). integer(1385). integer(1386). integer(1387). integer(1388). integer(1389). integer(1390).
integer(2011). integer(2012). integer(2013). integer(2014). integer(2015). integer(2016). integer(2017). integer(2018). integer(2019). integer(2020).
integer(2971). integer(2972). integer(2973). integer(2974). integer(2975). integer(2976). integer(2977). integer(2978). integer(2979). integer(2980).
integer(4001). integer(4002). integer(4003). integer(4004). integer(4005). integer(4006). integer(4007). integer(4008). integer(4009). integer(4010).
succ(181,182). succ(182,183). succ(183,184). succ(184,185). succ(185,186).
succ(191,192). succ(192,193). succ(193,194). succ(194,195). succ(195,196).
succ(241,242). succ(242,243). succ(243,244). succ(244,245). succ(245,246).
succ(486,487). succ(487,488). succ(488,489). succ(489,490). succ(490,491).
succ(491,492). succ(492,493). succ(493,494). succ(494,495). succ(495,496).
succ(546,547). succ(547,548). succ(548,549). succ(549,550). succ(550,551).
succ(966,967). succ(967,968). succ(968,969). succ(969,970). succ(970,971).
succ(976,977). succ(977,978). succ(978,979). succ(979,980). succ(980,981).
succ(1381,1382). succ(1382,1383). succ(1383,1384). succ(1384,1385). succ(1385,1386).
succ(1566,1567). succ(1567,1568). succ(1568,1569). succ(1569,1570). succ(1570,1571).
succ(1996,1997). succ(1997,1998). succ(1998,1999). succ(1999,2000). succ(2000,2001).
succ(2011,2012). succ(2012,2013). succ(2013,2014). succ(2014,2015). succ(2015,2016).
succ(2016,2017). succ(2017,2018). succ(2018,2019). succ(2019,2020). succ(2020,2021).
succ(2971,2972). succ(2972,2973). succ(2973,2974). succ(2974,2975). succ(2975,2976).
succ(4001,4002). succ(4002,4003). succ(4003,4004). succ(4004,4005). succ(4005,4006).
succ(4356,4357). succ(4357,4358). succ(4358,4359). succ(4359,4360). succ(4360,4361).
succ(4986,4987). succ(4987,4988). succ(4988,4989). succ(4989,4990). succ(4990,4991).
succ(7206,7207). succ(7207,7208). succ(7208,7209). succ(7209,7210). succ(7210,7211).
is_prime(179). is_prime(181). is_prime(191). is_prime(193). is_prime(197). is_prime(199). is_prime(211). is_prime(223). is_prime(227). is_prime(229).
is_prime(233). is_prime(239). is_prime(241). is_prime(251). is_prime(257). is_prime(263). is_prime(269). is_prime(271). is_prime(277). is_prime(281).
is_prime(547). is_prime(557). is_prime(563). is_prime(569). is_prime(571). is_prime(577). is_prime(587). is_prime(593). is_prime(599). is_prime(601).
is_prime(1381). is_prime(1399). is_prime(1409). is_prime(1423). is_prime(1427). is_prime(1429). is_prime(1433). is_prime(1439). is_prime(1447). is_prime(1451).
is_prime(4001). is_prime(4003). is_prime(4007). is_prime(4013). is_prime(4019). is_prime(4021). is_prime(4027). is_prime(4049). is_prime(4051). is_prime(4057).
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