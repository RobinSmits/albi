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

integer(761). integer(762). integer(763). integer(764). integer(765). integer(766). integer(767). integer(768). integer(769). integer(770).
integer(1481). integer(1482). integer(1483). integer(1484). integer(1485). integer(1486). integer(1487). integer(1488). integer(1489). integer(1490).
integer(1531). integer(1532). integer(1533). integer(1534). integer(1535). integer(1536). integer(1537). integer(1538). integer(1539). integer(1540).
integer(1811). integer(1812). integer(1813). integer(1814). integer(1815). integer(1816). integer(1817). integer(1818). integer(1819). integer(1820).
integer(3911). integer(3912). integer(3913). integer(3914). integer(3915). integer(3916). integer(3917). integer(3918). integer(3919). integer(3920).
integer(5231). integer(5232). integer(5233). integer(5234). integer(5235). integer(5236). integer(5237). integer(5238). integer(5239). integer(5240).
integer(6571). integer(6572). integer(6573). integer(6574). integer(6575). integer(6576). integer(6577). integer(6578). integer(6579). integer(6580).
succ(756,757). succ(757,758). succ(758,759). succ(759,760). succ(760,761).
succ(761,762). succ(762,763). succ(763,764). succ(764,765). succ(765,766).
succ(786,787). succ(787,788). succ(788,789). succ(789,790). succ(790,791).
succ(966,967). succ(967,968). succ(968,969). succ(969,970). succ(970,971).
succ(1446,1447). succ(1447,1448). succ(1448,1449). succ(1449,1450). succ(1450,1451).
succ(1481,1482). succ(1482,1483). succ(1483,1484). succ(1484,1485). succ(1485,1486).
succ(1486,1487). succ(1487,1488). succ(1488,1489). succ(1489,1490). succ(1490,1491).
succ(1531,1532). succ(1532,1533). succ(1533,1534). succ(1534,1535). succ(1535,1536).
succ(1596,1597). succ(1597,1598). succ(1598,1599). succ(1599,1600). succ(1600,1601).
succ(1811,1812). succ(1812,1813). succ(1813,1814). succ(1814,1815). succ(1815,1816).
succ(2476,2477). succ(2477,2478). succ(2478,2479). succ(2479,2480). succ(2480,2481).
succ(3906,3907). succ(3907,3908). succ(3908,3909). succ(3909,3910). succ(3910,3911).
succ(3911,3912). succ(3912,3913). succ(3913,3914). succ(3914,3915). succ(3915,3916).
succ(5231,5232). succ(5232,5233). succ(5233,5234). succ(5234,5235). succ(5235,5236).
succ(6066,6067). succ(6067,6068). succ(6068,6069). succ(6069,6070). succ(6070,6071).
succ(6396,6397). succ(6397,6398). succ(6398,6399). succ(6399,6400). succ(6400,6401).
succ(6571,6572). succ(6572,6573). succ(6573,6574). succ(6574,6575). succ(6575,6576).
succ(6576,6577). succ(6577,6578). succ(6578,6579). succ(6579,6580). succ(6580,6581).
succ(7126,7127). succ(7127,7128). succ(7128,7129). succ(7129,7130). succ(7130,7131).
is_prime(179). is_prime(181). is_prime(191). is_prime(193). is_prime(197). is_prime(199). is_prime(211). is_prime(223). is_prime(227). is_prime(229).
is_prime(1453). is_prime(1459). is_prime(1471). is_prime(1481). is_prime(1483). is_prime(1487). is_prime(1489). is_prime(1493). is_prime(1499). is_prime(1511).
is_prime(1597). is_prime(1601). is_prime(1607). is_prime(1609). is_prime(1613). is_prime(1619). is_prime(1621). is_prime(1627). is_prime(1637). is_prime(1657).
is_prime(3433). is_prime(3449). is_prime(3457). is_prime(3461). is_prime(3463). is_prime(3467). is_prime(3469). is_prime(3491). is_prime(3499). is_prime(3511).
is_prime(3911). is_prime(3917). is_prime(3919). is_prime(3923). is_prime(3929). is_prime(3931). is_prime(3943). is_prime(3947). is_prime(3967). is_prime(3989).
is_prime(6067). is_prime(6073). is_prime(6079). is_prime(6089). is_prime(6091). is_prime(6101). is_prime(6113). is_prime(6121). is_prime(6131). is_prime(6133).
is_prime(6577). is_prime(6581). is_prime(6599). is_prime(6607). is_prime(6619). is_prime(6637). is_prime(6653). is_prime(6659). is_prime(6661). is_prime(6673).
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