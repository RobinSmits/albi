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
integer(111). integer(112). integer(113). integer(114). integer(115). integer(116). integer(117). integer(118). integer(119). integer(120).
integer(151). integer(152). integer(153). integer(154). integer(155). integer(156). integer(157). integer(158). integer(159). integer(160).
integer(211). integer(212). integer(213). integer(214). integer(215). integer(216). integer(217). integer(218). integer(219). integer(220).
integer(331). integer(332). integer(333). integer(334). integer(335). integer(336). integer(337). integer(338). integer(339). integer(340).
integer(1091). integer(1092). integer(1093). integer(1094). integer(1095). integer(1096). integer(1097). integer(1098). integer(1099). integer(1100).
integer(1451). integer(1452). integer(1453). integer(1454). integer(1455). integer(1456). integer(1457). integer(1458). integer(1459). integer(1460).
integer(1471). integer(1472). integer(1473). integer(1474). integer(1475). integer(1476). integer(1477). integer(1478). integer(1479). integer(1480).
integer(1481). integer(1482). integer(1483). integer(1484). integer(1485). integer(1486). integer(1487). integer(1488). integer(1489). integer(1490).
integer(3271). integer(3272). integer(3273). integer(3274). integer(3275). integer(3276). integer(3277). integer(3278). integer(3279). integer(3280).
integer(6841). integer(6842). integer(6843). integer(6844). integer(6845). integer(6846). integer(6847). integer(6848). integer(6849). integer(6850).
integer(7561). integer(7562). integer(7563). integer(7564). integer(7565). integer(7566). integer(7567). integer(7568). integer(7569). integer(7570).
succ(46,47). succ(47,48). succ(48,49). succ(49,50). succ(50,51).
succ(61,62). succ(62,63). succ(63,64). succ(64,65). succ(65,66).
succ(66,67). succ(67,68). succ(68,69). succ(69,70). succ(70,71).
succ(111,112). succ(112,113). succ(113,114). succ(114,115). succ(115,116).
succ(151,152). succ(152,153). succ(153,154). succ(154,155). succ(155,156).
succ(211,212). succ(212,213). succ(213,214). succ(214,215). succ(215,216).
succ(256,257). succ(257,258). succ(258,259). succ(259,260). succ(260,261).
succ(316,317). succ(317,318). succ(318,319). succ(319,320). succ(320,321).
succ(331,332). succ(332,333). succ(333,334). succ(334,335). succ(335,336).
succ(1086,1087). succ(1087,1088). succ(1088,1089). succ(1089,1090). succ(1090,1091).
succ(1091,1092). succ(1092,1093). succ(1093,1094). succ(1094,1095). succ(1095,1096).
succ(1096,1097). succ(1097,1098). succ(1098,1099). succ(1099,1100). succ(1100,1101).
succ(1451,1452). succ(1452,1453). succ(1453,1454). succ(1454,1455). succ(1455,1456).
succ(1471,1472). succ(1472,1473). succ(1473,1474). succ(1474,1475). succ(1475,1476).
succ(1481,1482). succ(1482,1483). succ(1483,1484). succ(1484,1485). succ(1485,1486).
succ(1656,1657). succ(1657,1658). succ(1658,1659). succ(1659,1660). succ(1660,1661).
succ(1876,1877). succ(1877,1878). succ(1878,1879). succ(1879,1880). succ(1880,1881).
succ(3271,3272). succ(3272,3273). succ(3273,3274). succ(3274,3275). succ(3275,3276).
succ(4506,4507). succ(4507,4508). succ(4508,4509). succ(4509,4510). succ(4510,4511).
succ(6841,6842). succ(6842,6843). succ(6843,6844). succ(6844,6845). succ(6845,6846).
succ(6856,6857). succ(6857,6858). succ(6858,6859). succ(6859,6860). succ(6860,6861).
succ(7561,7562). succ(7562,7563). succ(7563,7564). succ(7564,7565). succ(7565,7566).
is_prime(1087). is_prime(1091). is_prime(1093). is_prime(1097). is_prime(1103). is_prime(1109). is_prime(1117). is_prime(1123). is_prime(1129). is_prime(1151).
is_prime(1663). is_prime(1667). is_prime(1669). is_prime(1693). is_prime(1697). is_prime(1699). is_prime(1709). is_prime(1721). is_prime(1723). is_prime(1733).
is_prime(3259). is_prime(3271). is_prime(3299). is_prime(3301). is_prime(3307). is_prime(3313). is_prime(3319). is_prime(3323). is_prime(3329). is_prime(3331).
is_prime(4507). is_prime(4513). is_prime(4517). is_prime(4519). is_prime(4523). is_prime(4547). is_prime(4549). is_prime(4561). is_prime(4567). is_prime(4583).
is_prime(6841). is_prime(6857). is_prime(6863). is_prime(6869). is_prime(6871). is_prime(6883). is_prime(6899). is_prime(6907). is_prime(6911). is_prime(6917).
is_composite(4). is_composite(6). is_composite(8). is_composite(9). is_composite(10). is_composite(12). is_composite(14). is_composite(15). is_composite(16). is_composite(18).
is_composite(111). is_composite(112). is_composite(114). is_composite(115). is_composite(116). is_composite(117). is_composite(118). is_composite(119). is_composite(120). is_composite(121).
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