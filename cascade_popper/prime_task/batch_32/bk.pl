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

integer(31). integer(32). integer(33). integer(34). integer(35). integer(36). integer(37). integer(38). integer(39). integer(40).
integer(131). integer(132). integer(133). integer(134). integer(135). integer(136). integer(137). integer(138). integer(139). integer(140).
integer(211). integer(212). integer(213). integer(214). integer(215). integer(216). integer(217). integer(218). integer(219). integer(220).
integer(431). integer(432). integer(433). integer(434). integer(435). integer(436). integer(437). integer(438). integer(439). integer(440).
integer(1201). integer(1202). integer(1203). integer(1204). integer(1205). integer(1206). integer(1207). integer(1208). integer(1209). integer(1210).
integer(1831). integer(1832). integer(1833). integer(1834). integer(1835). integer(1836). integer(1837). integer(1838). integer(1839). integer(1840).
integer(1861). integer(1862). integer(1863). integer(1864). integer(1865). integer(1866). integer(1867). integer(1868). integer(1869). integer(1870).
integer(3911). integer(3912). integer(3913). integer(3914). integer(3915). integer(3916). integer(3917). integer(3918). integer(3919). integer(3920).
integer(4691). integer(4692). integer(4693). integer(4694). integer(4695). integer(4696). integer(4697). integer(4698). integer(4699). integer(4700).
integer(6491). integer(6492). integer(6493). integer(6494). integer(6495). integer(6496). integer(6497). integer(6498). integer(6499). integer(6500).
integer(6521). integer(6522). integer(6523). integer(6524). integer(6525). integer(6526). integer(6527). integer(6528). integer(6529). integer(6530).
succ(31,32). succ(32,33). succ(33,34). succ(34,35). succ(35,36).
succ(36,37). succ(37,38). succ(38,39). succ(39,40). succ(40,41).
succ(131,132). succ(132,133). succ(133,134). succ(134,135). succ(135,136).
succ(136,137). succ(137,138). succ(138,139). succ(139,140). succ(140,141).
succ(196,197). succ(197,198). succ(198,199). succ(199,200). succ(200,201).
succ(211,212). succ(212,213). succ(213,214). succ(214,215). succ(215,216).
succ(431,432). succ(432,433). succ(433,434). succ(434,435). succ(435,436).
succ(456,457). succ(457,458). succ(458,459). succ(459,460). succ(460,461).
succ(1201,1202). succ(1202,1203). succ(1203,1204). succ(1204,1205). succ(1205,1206).
succ(1216,1217). succ(1217,1218). succ(1218,1219). succ(1219,1220). succ(1220,1221).
succ(1306,1307). succ(1307,1308). succ(1308,1309). succ(1309,1310). succ(1310,1311).
succ(1656,1657). succ(1657,1658). succ(1658,1659). succ(1659,1660). succ(1660,1661).
succ(1666,1667). succ(1667,1668). succ(1668,1669). succ(1669,1670). succ(1670,1671).
succ(1831,1832). succ(1832,1833). succ(1833,1834). succ(1834,1835). succ(1835,1836).
succ(1861,1862). succ(1862,1863). succ(1863,1864). succ(1864,1865). succ(1865,1866).
succ(2916,2917). succ(2917,2918). succ(2918,2919). succ(2919,2920). succ(2920,2921).
succ(3911,3912). succ(3912,3913). succ(3913,3914). succ(3914,3915). succ(3915,3916).
succ(3916,3917). succ(3917,3918). succ(3918,3919). succ(3919,3920). succ(3920,3921).
succ(4691,4692). succ(4692,4693). succ(4693,4694). succ(4694,4695). succ(4695,4696).
succ(5146,5147). succ(5147,5148). succ(5148,5149). succ(5149,5150). succ(5150,5151).
succ(6491,6492). succ(6492,6493). succ(6493,6494). succ(6494,6495). succ(6495,6496).
succ(6521,6522). succ(6522,6523). succ(6523,6524). succ(6524,6525). succ(6525,6526).
is_prime(31). is_prime(37). is_prime(41). is_prime(43). is_prime(47). is_prime(53). is_prime(59). is_prime(61). is_prime(67). is_prime(71).
is_prime(1019). is_prime(1021). is_prime(1031). is_prime(1033). is_prime(1039). is_prime(1049). is_prime(1051). is_prime(1061). is_prime(1063). is_prime(1069).
is_prime(2909). is_prime(2917). is_prime(2927). is_prime(2939). is_prime(2953). is_prime(2957). is_prime(2963). is_prime(2969). is_prime(2971). is_prime(2999).
is_prime(3911). is_prime(3917). is_prime(3919). is_prime(3923). is_prime(3929). is_prime(3931). is_prime(3943). is_prime(3947). is_prime(3967). is_prime(3989).
is_prime(5009). is_prime(5011). is_prime(5021). is_prime(5023). is_prime(5039). is_prime(5051). is_prime(5059). is_prime(5077). is_prime(5081). is_prime(5087).
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