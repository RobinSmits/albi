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

integer(161). integer(162). integer(163). integer(164). integer(165). integer(166). integer(167). integer(168). integer(169). integer(170).
integer(331). integer(332). integer(333). integer(334). integer(335). integer(336). integer(337). integer(338). integer(339). integer(340).
integer(431). integer(432). integer(433). integer(434). integer(435). integer(436). integer(437). integer(438). integer(439). integer(440).
integer(1021). integer(1022). integer(1023). integer(1024). integer(1025). integer(1026). integer(1027). integer(1028). integer(1029). integer(1030).
integer(3541). integer(3542). integer(3543). integer(3544). integer(3545). integer(3546). integer(3547). integer(3548). integer(3549). integer(3550).
integer(4451). integer(4452). integer(4453). integer(4454). integer(4455). integer(4456). integer(4457). integer(4458). integer(4459). integer(4460).
integer(6791). integer(6792). integer(6793). integer(6794). integer(6795). integer(6796). integer(6797). integer(6798). integer(6799). integer(6800).
integer(7741). integer(7742). integer(7743). integer(7744). integer(7745). integer(7746). integer(7747). integer(7748). integer(7749). integer(7750).
succ(126,127). succ(127,128). succ(128,129). succ(129,130). succ(130,131).
succ(161,162). succ(162,163). succ(163,164). succ(164,165). succ(165,166).
succ(166,167). succ(167,168). succ(168,169). succ(169,170). succ(170,171).
succ(331,332). succ(332,333). succ(333,334). succ(334,335). succ(335,336).
succ(431,432). succ(432,433). succ(433,434). succ(434,435). succ(435,436).
succ(1021,1022). succ(1022,1023). succ(1023,1024). succ(1024,1025). succ(1025,1026).
succ(1596,1597). succ(1597,1598). succ(1598,1599). succ(1599,1600). succ(1600,1601).
succ(1606,1607). succ(1607,1608). succ(1608,1609). succ(1609,1610). succ(1610,1611).
succ(1636,1637). succ(1637,1638). succ(1638,1639). succ(1639,1640). succ(1640,1641).
succ(1656,1657). succ(1657,1658). succ(1658,1659). succ(1659,1660). succ(1660,1661).
succ(1746,1747). succ(1747,1748). succ(1748,1749). succ(1749,1750). succ(1750,1751).
succ(3541,3542). succ(3542,3543). succ(3543,3544). succ(3544,3545). succ(3545,3546).
succ(4451,4452). succ(4452,4453). succ(4453,4454). succ(4454,4455). succ(4455,4456).
succ(4456,4457). succ(4457,4458). succ(4458,4459). succ(4459,4460). succ(4460,4461).
succ(6791,6792). succ(6792,6793). succ(6793,6794). succ(6794,6795). succ(6795,6796).
succ(7476,7477). succ(7477,7478). succ(7478,7479). succ(7479,7480). succ(7480,7481).
succ(7741,7742). succ(7742,7743). succ(7743,7744). succ(7744,7745). succ(7745,7746).
is_prime(127). is_prime(131). is_prime(137). is_prime(139). is_prime(149). is_prime(151). is_prime(157). is_prime(163). is_prime(167). is_prime(173).
is_prime(179). is_prime(181). is_prime(191). is_prime(193). is_prime(197). is_prime(199). is_prime(211). is_prime(223). is_prime(227). is_prime(229).
is_prime(1597). is_prime(1601). is_prime(1607). is_prime(1609). is_prime(1613). is_prime(1619). is_prime(1621). is_prime(1627). is_prime(1637). is_prime(1657).
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