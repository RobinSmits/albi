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

integer(61). integer(62). integer(63). integer(64). integer(65). integer(66). integer(67). integer(68). integer(69). integer(70).
integer(211). integer(212). integer(213). integer(214). integer(215). integer(216). integer(217). integer(218). integer(219). integer(220).
integer(1061). integer(1062). integer(1063). integer(1064). integer(1065). integer(1066). integer(1067). integer(1068). integer(1069). integer(1070).
integer(1381). integer(1382). integer(1383). integer(1384). integer(1385). integer(1386). integer(1387). integer(1388). integer(1389). integer(1390).
integer(1511). integer(1512). integer(1513). integer(1514). integer(1515). integer(1516). integer(1517). integer(1518). integer(1519). integer(1520).
integer(1621). integer(1622). integer(1623). integer(1624). integer(1625). integer(1626). integer(1627). integer(1628). integer(1629). integer(1630).
integer(1931). integer(1932). integer(1933). integer(1934). integer(1935). integer(1936). integer(1937). integer(1938). integer(1939). integer(1940).
integer(2081). integer(2082). integer(2083). integer(2084). integer(2085). integer(2086). integer(2087). integer(2088). integer(2089). integer(2090).
integer(2551). integer(2552). integer(2553). integer(2554). integer(2555). integer(2556). integer(2557). integer(2558). integer(2559). integer(2560).
succ(61,62). succ(62,63). succ(63,64). succ(64,65). succ(65,66).
succ(66,67). succ(67,68). succ(68,69). succ(69,70). succ(70,71).
succ(196,197). succ(197,198). succ(198,199). succ(199,200). succ(200,201).
succ(211,212). succ(212,213). succ(213,214). succ(214,215). succ(215,216).
succ(276,277). succ(277,278). succ(278,279). succ(279,280). succ(280,281).
succ(346,347). succ(347,348). succ(348,349). succ(349,350). succ(350,351).
succ(486,487). succ(487,488). succ(488,489). succ(489,490). succ(490,491).
succ(726,727). succ(727,728). succ(728,729). succ(729,730). succ(730,731).
succ(1061,1062). succ(1062,1063). succ(1063,1064). succ(1064,1065). succ(1065,1066).
succ(1381,1382). succ(1382,1383). succ(1383,1384). succ(1384,1385). succ(1385,1386).
succ(1511,1512). succ(1512,1513). succ(1513,1514). succ(1514,1515). succ(1515,1516).
succ(1596,1597). succ(1597,1598). succ(1598,1599). succ(1599,1600). succ(1600,1601).
succ(1621,1622). succ(1622,1623). succ(1623,1624). succ(1624,1625). succ(1625,1626).
succ(1931,1932). succ(1932,1933). succ(1933,1934). succ(1934,1935). succ(1935,1936).
succ(1986,1987). succ(1987,1988). succ(1988,1989). succ(1989,1990). succ(1990,1991).
succ(1996,1997). succ(1997,1998). succ(1998,1999). succ(1999,2000). succ(2000,2001).
succ(2081,2082). succ(2082,2083). succ(2083,2084). succ(2084,2085). succ(2085,2086).
succ(2551,2552). succ(2552,2553). succ(2553,2554). succ(2554,2555). succ(2555,2556).
succ(6636,6637). succ(6637,6638). succ(6638,6639). succ(6639,6640). succ(6640,6641).
succ(7306,7307). succ(7307,7308). succ(7308,7309). succ(7309,7310). succ(7310,7311).
is_prime(1381). is_prime(1399). is_prime(1409). is_prime(1423). is_prime(1427). is_prime(1429). is_prime(1433). is_prime(1439). is_prime(1447). is_prime(1451).
is_prime(1597). is_prime(1601). is_prime(1607). is_prime(1609). is_prime(1613). is_prime(1619). is_prime(1621). is_prime(1627). is_prime(1637). is_prime(1657).
is_prime(7307). is_prime(7309). is_prime(7321). is_prime(7331). is_prime(7333). is_prime(7349). is_prime(7351). is_prime(7369). is_prime(7393). is_prime(7411).
is_composite(1512). is_composite(1513). is_composite(1514). is_composite(1515). is_composite(1516). is_composite(1517). is_composite(1518). is_composite(1519). is_composite(1520). is_composite(1521).
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