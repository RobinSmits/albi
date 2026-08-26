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

integer(41). integer(42). integer(43). integer(44). integer(45). integer(46). integer(47). integer(48). integer(49). integer(50).
integer(101). integer(102). integer(103). integer(104). integer(105). integer(106). integer(107). integer(108). integer(109). integer(110).
integer(911). integer(912). integer(913). integer(914). integer(915). integer(916). integer(917). integer(918). integer(919). integer(920).
integer(1091). integer(1092). integer(1093). integer(1094). integer(1095). integer(1096). integer(1097). integer(1098). integer(1099). integer(1100).
integer(1571). integer(1572). integer(1573). integer(1574). integer(1575). integer(1576). integer(1577). integer(1578). integer(1579). integer(1580).
integer(1721). integer(1722). integer(1723). integer(1724). integer(1725). integer(1726). integer(1727). integer(1728). integer(1729). integer(1730).
integer(4231). integer(4232). integer(4233). integer(4234). integer(4235). integer(4236). integer(4237). integer(4238). integer(4239). integer(4240).
succ(41,42). succ(42,43). succ(43,44). succ(44,45). succ(45,46).
succ(101,102). succ(102,103). succ(103,104). succ(104,105). succ(105,106).
succ(106,107). succ(107,108). succ(108,109). succ(109,110). succ(110,111).
succ(156,157). succ(157,158). succ(158,159). succ(159,160). succ(160,161).
succ(466,467). succ(467,468). succ(468,469). succ(469,470). succ(470,471).
succ(911,912). succ(912,913). succ(913,914). succ(914,915). succ(915,916).
succ(1091,1092). succ(1092,1093). succ(1093,1094). succ(1094,1095). succ(1095,1096).
succ(1096,1097). succ(1097,1098). succ(1098,1099). succ(1099,1100). succ(1100,1101).
succ(1566,1567). succ(1567,1568). succ(1568,1569). succ(1569,1570). succ(1570,1571).
succ(1571,1572). succ(1572,1573). succ(1573,1574). succ(1574,1575). succ(1575,1576).
succ(1636,1637). succ(1637,1638). succ(1638,1639). succ(1639,1640). succ(1640,1641).
succ(1721,1722). succ(1722,1723). succ(1723,1724). succ(1724,1725). succ(1725,1726).
succ(1786,1787). succ(1787,1788). succ(1788,1789). succ(1789,1790). succ(1790,1791).
succ(1906,1907). succ(1907,1908). succ(1908,1909). succ(1909,1910). succ(1910,1911).
succ(4231,4232). succ(4232,4233). succ(4233,4234). succ(4234,4235). succ(4235,4236).
succ(5196,5197). succ(5197,5198). succ(5198,5199). succ(5199,5200). succ(5200,5201).
succ(6036,6037). succ(6037,6038). succ(6038,6039). succ(6039,6040). succ(6040,6041).
is_prime(467). is_prime(479). is_prime(487). is_prime(491). is_prime(499). is_prime(503). is_prime(509). is_prime(521). is_prime(523). is_prime(541).
is_prime(1663). is_prime(1667). is_prime(1669). is_prime(1693). is_prime(1697). is_prime(1699). is_prime(1709). is_prime(1721). is_prime(1723). is_prime(1733).
is_prime(3659). is_prime(3671). is_prime(3673). is_prime(3677). is_prime(3691). is_prime(3697). is_prime(3701). is_prime(3709). is_prime(3719). is_prime(3727).
is_prime(5189). is_prime(5197). is_prime(5209). is_prime(5227). is_prime(5231). is_prime(5233). is_prime(5237). is_prime(5261). is_prime(5273). is_prime(5279).
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