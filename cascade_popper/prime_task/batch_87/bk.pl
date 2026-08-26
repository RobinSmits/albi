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
integer(151). integer(152). integer(153). integer(154). integer(155). integer(156). integer(157). integer(158). integer(159). integer(160).
integer(311). integer(312). integer(313). integer(314). integer(315). integer(316). integer(317). integer(318). integer(319). integer(320).
integer(421). integer(422). integer(423). integer(424). integer(425). integer(426). integer(427). integer(428). integer(429). integer(430).
integer(601). integer(602). integer(603). integer(604). integer(605). integer(606). integer(607). integer(608). integer(609). integer(610).
integer(911). integer(912). integer(913). integer(914). integer(915). integer(916). integer(917). integer(918). integer(919). integer(920).
integer(971). integer(972). integer(973). integer(974). integer(975). integer(976). integer(977). integer(978). integer(979). integer(980).
integer(1871). integer(1872). integer(1873). integer(1874). integer(1875). integer(1876). integer(1877). integer(1878). integer(1879). integer(1880).
succ(16,17). succ(17,18). succ(18,19). succ(19,20). succ(20,21).
succ(41,42). succ(42,43). succ(43,44). succ(44,45). succ(45,46).
succ(151,152). succ(152,153). succ(153,154). succ(154,155). succ(155,156).
succ(156,157). succ(157,158). succ(158,159). succ(159,160). succ(160,161).
succ(306,307). succ(307,308). succ(308,309). succ(309,310). succ(310,311).
succ(311,312). succ(312,313). succ(313,314). succ(314,315). succ(315,316).
succ(421,422). succ(422,423). succ(423,424). succ(424,425). succ(425,426).
succ(601,602). succ(602,603). succ(603,604). succ(604,605). succ(605,606).
succ(606,607). succ(607,608). succ(608,609). succ(609,610). succ(610,611).
succ(796,797). succ(797,798). succ(798,799). succ(799,800). succ(800,801).
succ(911,912). succ(912,913). succ(913,914). succ(914,915). succ(915,916).
succ(966,967). succ(967,968). succ(968,969). succ(969,970). succ(970,971).
succ(971,972). succ(972,973). succ(973,974). succ(974,975). succ(975,976).
succ(1426,1427). succ(1427,1428). succ(1428,1429). succ(1429,1430). succ(1430,1431).
succ(1871,1872). succ(1872,1873). succ(1873,1874). succ(1874,1875). succ(1875,1876).
succ(2706,2707). succ(2707,2708). succ(2708,2709). succ(2709,2710). succ(2710,2711).
succ(5926,5927). succ(5927,5928). succ(5928,5929). succ(5929,5930). succ(5930,5931).
is_prime(283). is_prime(293). is_prime(307). is_prime(311). is_prime(313). is_prime(317). is_prime(331). is_prime(337). is_prime(347). is_prime(349).
is_prime(419). is_prime(421). is_prime(431). is_prime(433). is_prime(439). is_prime(443). is_prime(449). is_prime(457). is_prime(461). is_prime(463).
is_prime(607). is_prime(613). is_prime(617). is_prime(619). is_prime(631). is_prime(641). is_prime(643). is_prime(647). is_prime(653). is_prime(659).
is_composite(1164). is_composite(1165). is_composite(1166). is_composite(1167). is_composite(1168). is_composite(1169). is_composite(1170). is_composite(1172). is_composite(1173). is_composite(1174).
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