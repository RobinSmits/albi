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

integer(181). integer(182). integer(183). integer(184). integer(185). integer(186). integer(187). integer(188). integer(189). integer(190).
integer(191). integer(192). integer(193). integer(194). integer(195). integer(196). integer(197). integer(198). integer(199). integer(200).
integer(491). integer(492). integer(493). integer(494). integer(495). integer(496). integer(497). integer(498). integer(499). integer(500).
integer(1051). integer(1052). integer(1053). integer(1054). integer(1055). integer(1056). integer(1057). integer(1058). integer(1059). integer(1060).
integer(1571). integer(1572). integer(1573). integer(1574). integer(1575). integer(1576). integer(1577). integer(1578). integer(1579). integer(1580).
integer(1601). integer(1602). integer(1603). integer(1604). integer(1605). integer(1606). integer(1607). integer(1608). integer(1609). integer(1610).
integer(1621). integer(1622). integer(1623). integer(1624). integer(1625). integer(1626). integer(1627). integer(1628). integer(1629). integer(1630).
integer(1861). integer(1862). integer(1863). integer(1864). integer(1865). integer(1866). integer(1867). integer(1868). integer(1869). integer(1870).
integer(1871). integer(1872). integer(1873). integer(1874). integer(1875). integer(1876). integer(1877). integer(1878). integer(1879). integer(1880).
integer(4091). integer(4092). integer(4093). integer(4094). integer(4095). integer(4096). integer(4097). integer(4098). integer(4099). integer(4100).
succ(106,107). succ(107,108). succ(108,109). succ(109,110). succ(110,111).
succ(181,182). succ(182,183). succ(183,184). succ(184,185). succ(185,186).
succ(191,192). succ(192,193). succ(193,194). succ(194,195). succ(195,196).
succ(196,197). succ(197,198). succ(198,199). succ(199,200). succ(200,201).
succ(491,492). succ(492,493). succ(493,494). succ(494,495). succ(495,496).
succ(726,727). succ(727,728). succ(728,729). succ(729,730). succ(730,731).
succ(826,827). succ(827,828). succ(828,829). succ(829,830). succ(830,831).
succ(1051,1052). succ(1052,1053). succ(1053,1054). succ(1054,1055). succ(1055,1056).
succ(1426,1427). succ(1427,1428). succ(1428,1429). succ(1429,1430). succ(1430,1431).
succ(1571,1572). succ(1572,1573). succ(1573,1574). succ(1574,1575). succ(1575,1576).
succ(1601,1602). succ(1602,1603). succ(1603,1604). succ(1604,1605). succ(1605,1606).
succ(1621,1622). succ(1622,1623). succ(1623,1624). succ(1624,1625). succ(1625,1626).
succ(1626,1627). succ(1627,1628). succ(1628,1629). succ(1629,1630). succ(1630,1631).
succ(1846,1847). succ(1847,1848). succ(1848,1849). succ(1849,1850). succ(1850,1851).
succ(1861,1862). succ(1862,1863). succ(1863,1864). succ(1864,1865). succ(1865,1866).
succ(1871,1872). succ(1872,1873). succ(1873,1874). succ(1874,1875). succ(1875,1876).
succ(1876,1877). succ(1877,1878). succ(1878,1879). succ(1879,1880). succ(1880,1881).
succ(4091,4092). succ(4092,4093). succ(4093,4094). succ(4094,4095). succ(4095,4096).
succ(6426,6427). succ(6427,6428). succ(6428,6429). succ(6429,6430). succ(6430,6431).
is_prime(179). is_prime(181). is_prime(191). is_prime(193). is_prime(197). is_prime(199). is_prime(211). is_prime(223). is_prime(227). is_prime(229).
is_prime(7649). is_prime(7669). is_prime(7673). is_prime(7681). is_prime(7687). is_prime(7691). is_prime(7699). is_prime(7703). is_prime(7717). is_prime(7723).
is_composite(20). is_composite(21). is_composite(22). is_composite(24). is_composite(25). is_composite(26). is_composite(27). is_composite(28). is_composite(30). is_composite(32).
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