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

integer(241). integer(242). integer(243). integer(244). integer(245). integer(246). integer(247). integer(248). integer(249). integer(250).
integer(991). integer(992). integer(993). integer(994). integer(995). integer(996). integer(997). integer(998). integer(999). integer(1000).
integer(1741). integer(1742). integer(1743). integer(1744). integer(1745). integer(1746). integer(1747). integer(1748). integer(1749). integer(1750).
integer(1801). integer(1802). integer(1803). integer(1804). integer(1805). integer(1806). integer(1807). integer(1808). integer(1809). integer(1810).
integer(1951). integer(1952). integer(1953). integer(1954). integer(1955). integer(1956). integer(1957). integer(1958). integer(1959). integer(1960).
integer(4261). integer(4262). integer(4263). integer(4264). integer(4265). integer(4266). integer(4267). integer(4268). integer(4269). integer(4270).
integer(4271). integer(4272). integer(4273). integer(4274). integer(4275). integer(4276). integer(4277). integer(4278). integer(4279). integer(4280).
integer(5261). integer(5262). integer(5263). integer(5264). integer(5265). integer(5266). integer(5267). integer(5268). integer(5269). integer(5270).
succ(211,212). succ(212,213). succ(213,214). succ(214,215). succ(215,216).
succ(241,242). succ(242,243). succ(243,244). succ(244,245). succ(245,246).
succ(256,257). succ(257,258). succ(258,259). succ(259,260). succ(260,261).
succ(276,277). succ(277,278). succ(278,279). succ(279,280). succ(280,281).
succ(546,547). succ(547,548). succ(548,549). succ(549,550). succ(550,551).
succ(556,557). succ(557,558). succ(558,559). succ(559,560). succ(560,561).
succ(976,977). succ(977,978). succ(978,979). succ(979,980). succ(980,981).
succ(991,992). succ(992,993). succ(993,994). succ(994,995). succ(995,996).
succ(1741,1742). succ(1742,1743). succ(1743,1744). succ(1744,1745). succ(1745,1746).
succ(1746,1747). succ(1747,1748). succ(1748,1749). succ(1749,1750). succ(1750,1751).
succ(1801,1802). succ(1802,1803). succ(1803,1804). succ(1804,1805). succ(1805,1806).
succ(1951,1952). succ(1952,1953). succ(1953,1954). succ(1954,1955). succ(1955,1956).
succ(2706,2707). succ(2707,2708). succ(2708,2709). succ(2709,2710). succ(2710,2711).
succ(4261,4262). succ(4262,4263). succ(4263,4264). succ(4264,4265). succ(4265,4266).
succ(4271,4272). succ(4272,4273). succ(4273,4274). succ(4274,4275). succ(4275,4276).
succ(5261,5262). succ(5262,5263). succ(5263,5264). succ(5264,5265). succ(5265,5266).
succ(7506,7507). succ(7507,7508). succ(7508,7509). succ(7509,7510). succ(7510,7511).
succ(7516,7517). succ(7517,7518). succ(7518,7519). succ(7519,7520). succ(7520,7521).
is_prime(547). is_prime(557). is_prime(563). is_prime(569). is_prime(571). is_prime(577). is_prime(587). is_prime(593). is_prime(599). is_prime(601).
is_prime(1741). is_prime(1747). is_prime(1753). is_prime(1759). is_prime(1777). is_prime(1783). is_prime(1787). is_prime(1789). is_prime(1801). is_prime(1811).
is_prime(1823). is_prime(1831). is_prime(1847). is_prime(1861). is_prime(1867). is_prime(1871). is_prime(1873). is_prime(1877). is_prime(1879). is_prime(1889).
is_prime(1993). is_prime(1997). is_prime(1999). is_prime(2003). is_prime(2011). is_prime(2017). is_prime(2027). is_prime(2029). is_prime(2039). is_prime(2053).
is_prime(6679). is_prime(6689). is_prime(6691). is_prime(6701). is_prime(6703). is_prime(6709). is_prime(6719). is_prime(6733). is_prime(6737). is_prime(6761).
is_prime(7507). is_prime(7517). is_prime(7523). is_prime(7529). is_prime(7537). is_prime(7541). is_prime(7547). is_prime(7549). is_prime(7559). is_prime(7561).
is_composite(930). is_composite(931). is_composite(932). is_composite(933). is_composite(934). is_composite(935). is_composite(936). is_composite(938). is_composite(939). is_composite(940).
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