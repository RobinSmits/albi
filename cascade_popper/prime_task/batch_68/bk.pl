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

integer(21). integer(22). integer(23). integer(24). integer(25). integer(26). integer(27). integer(28). integer(29). integer(30).
integer(221). integer(222). integer(223). integer(224). integer(225). integer(226). integer(227). integer(228). integer(229). integer(230).
integer(241). integer(242). integer(243). integer(244). integer(245). integer(246). integer(247). integer(248). integer(249). integer(250).
integer(1511). integer(1512). integer(1513). integer(1514). integer(1515). integer(1516). integer(1517). integer(1518). integer(1519). integer(1520).
integer(1721). integer(1722). integer(1723). integer(1724). integer(1725). integer(1726). integer(1727). integer(1728). integer(1729). integer(1730).
integer(2341). integer(2342). integer(2343). integer(2344). integer(2345). integer(2346). integer(2347). integer(2348). integer(2349). integer(2350).
integer(2441). integer(2442). integer(2443). integer(2444). integer(2445). integer(2446). integer(2447). integer(2448). integer(2449). integer(2450).
integer(2621). integer(2622). integer(2623). integer(2624). integer(2625). integer(2626). integer(2627). integer(2628). integer(2629). integer(2630).
integer(4931). integer(4932). integer(4933). integer(4934). integer(4935). integer(4936). integer(4937). integer(4938). integer(4939). integer(4940).
integer(5711). integer(5712). integer(5713). integer(5714). integer(5715). integer(5716). integer(5717). integer(5718). integer(5719). integer(5720).
succ(21,22). succ(22,23). succ(23,24). succ(24,25). succ(25,26).
succ(216,217). succ(217,218). succ(218,219). succ(219,220). succ(220,221).
succ(221,222). succ(222,223). succ(223,224). succ(224,225). succ(225,226).
succ(241,242). succ(242,243). succ(243,244). succ(244,245). succ(245,246).
succ(606,607). succ(607,608). succ(608,609). succ(609,610). succ(610,611).
succ(616,617). succ(617,618). succ(618,619). succ(619,620). succ(620,621).
succ(1511,1512). succ(1512,1513). succ(1513,1514). succ(1514,1515). succ(1515,1516).
succ(1721,1722). succ(1722,1723). succ(1723,1724). succ(1724,1725). succ(1725,1726).
succ(2341,2342). succ(2342,2343). succ(2343,2344). succ(2344,2345). succ(2345,2346).
succ(2436,2437). succ(2437,2438). succ(2438,2439). succ(2439,2440). succ(2440,2441).
succ(2441,2442). succ(2442,2443). succ(2443,2444). succ(2444,2445). succ(2445,2446).
succ(2621,2622). succ(2622,2623). succ(2623,2624). succ(2624,2625). succ(2625,2626).
succ(2646,2647). succ(2647,2648). succ(2648,2649). succ(2649,2650). succ(2650,2651).
succ(4931,4932). succ(4932,4933). succ(4933,4934). succ(4934,4935). succ(4935,4936).
succ(5711,5712). succ(5712,5713). succ(5713,5714). succ(5714,5715). succ(5715,5716).
succ(5716,5717). succ(5717,5718). succ(5718,5719). succ(5719,5720). succ(5720,5721).
succ(5826,5827). succ(5827,5828). succ(5828,5829). succ(5829,5830). succ(5830,5831).
succ(7026,7027). succ(7027,7028). succ(7028,7029). succ(7029,7030). succ(7030,7031).
succ(7246,7247). succ(7247,7248). succ(7248,7249). succ(7249,7250). succ(7250,7251).
is_prime(607). is_prime(613). is_prime(617). is_prime(619). is_prime(631). is_prime(641). is_prime(643). is_prime(647). is_prime(653). is_prime(659).
is_prime(1523). is_prime(1531). is_prime(1543). is_prime(1549). is_prime(1553). is_prime(1559). is_prime(1567). is_prime(1571). is_prime(1579). is_prime(1583).
is_prime(2437). is_prime(2441). is_prime(2447). is_prime(2459). is_prime(2467). is_prime(2473). is_prime(2477). is_prime(2503). is_prime(2521). is_prime(2531).
is_prime(2621). is_prime(2633). is_prime(2647). is_prime(2657). is_prime(2659). is_prime(2663). is_prime(2671). is_prime(2677). is_prime(2683). is_prime(2687).
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