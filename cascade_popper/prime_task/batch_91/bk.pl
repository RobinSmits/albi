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

integer(421). integer(422). integer(423). integer(424). integer(425). integer(426). integer(427). integer(428). integer(429). integer(430).
integer(431). integer(432). integer(433). integer(434). integer(435). integer(436). integer(437). integer(438). integer(439). integer(440).
integer(691). integer(692). integer(693). integer(694). integer(695). integer(696). integer(697). integer(698). integer(699). integer(700).
integer(701). integer(702). integer(703). integer(704). integer(705). integer(706). integer(707). integer(708). integer(709). integer(710).
integer(1741). integer(1742). integer(1743). integer(1744). integer(1745). integer(1746). integer(1747). integer(1748). integer(1749). integer(1750).
integer(1801). integer(1802). integer(1803). integer(1804). integer(1805). integer(1806). integer(1807). integer(1808). integer(1809). integer(1810).
integer(5741). integer(5742). integer(5743). integer(5744). integer(5745). integer(5746). integer(5747). integer(5748). integer(5749). integer(5750).
succ(16,17). succ(17,18). succ(18,19). succ(19,20). succ(20,21).
succ(66,67). succ(67,68). succ(68,69). succ(69,70). succ(70,71).
succ(421,422). succ(422,423). succ(423,424). succ(424,425). succ(425,426).
succ(431,432). succ(432,433). succ(433,434). succ(434,435). succ(435,436).
succ(691,692). succ(692,693). succ(693,694). succ(694,695). succ(695,696).
succ(701,702). succ(702,703). succ(703,704). succ(704,705). succ(705,706).
succ(1366,1367). succ(1367,1368). succ(1368,1369). succ(1369,1370). succ(1370,1371).
succ(1566,1567). succ(1567,1568). succ(1568,1569). succ(1569,1570). succ(1570,1571).
succ(1696,1697). succ(1697,1698). succ(1698,1699). succ(1699,1700). succ(1700,1701).
succ(1741,1742). succ(1742,1743). succ(1743,1744). succ(1744,1745). succ(1745,1746).
succ(1746,1747). succ(1747,1748). succ(1748,1749). succ(1749,1750). succ(1750,1751).
succ(1801,1802). succ(1802,1803). succ(1803,1804). succ(1804,1805). succ(1805,1806).
succ(3726,3727). succ(3727,3728). succ(3728,3729). succ(3729,3730). succ(3730,3731).
succ(4156,4157). succ(4157,4158). succ(4158,4159). succ(4159,4160). succ(4160,4161).
succ(4986,4987). succ(4987,4988). succ(4988,4989). succ(4989,4990). succ(4990,4991).
succ(5196,5197). succ(5197,5198). succ(5198,5199). succ(5199,5200). succ(5200,5201).
succ(5741,5742). succ(5742,5743). succ(5743,5744). succ(5744,5745). succ(5745,5746).
is_prime(1453). is_prime(1459). is_prime(1471). is_prime(1481). is_prime(1483). is_prime(1487). is_prime(1489). is_prime(1493). is_prime(1499). is_prime(1511).
is_prime(1741). is_prime(1747). is_prime(1753). is_prime(1759). is_prime(1777). is_prime(1783). is_prime(1787). is_prime(1789). is_prime(1801). is_prime(1811).
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