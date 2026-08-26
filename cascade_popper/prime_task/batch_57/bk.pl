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

integer(211). integer(212). integer(213). integer(214). integer(215). integer(216). integer(217). integer(218). integer(219). integer(220).
integer(461). integer(462). integer(463). integer(464). integer(465). integer(466). integer(467). integer(468). integer(469). integer(470).
integer(991). integer(992). integer(993). integer(994). integer(995). integer(996). integer(997). integer(998). integer(999). integer(1000).
integer(1601). integer(1602). integer(1603). integer(1604). integer(1605). integer(1606). integer(1607). integer(1608). integer(1609). integer(1610).
integer(2711). integer(2712). integer(2713). integer(2714). integer(2715). integer(2716). integer(2717). integer(2718). integer(2719). integer(2720).
integer(5101). integer(5102). integer(5103). integer(5104). integer(5105). integer(5106). integer(5107). integer(5108). integer(5109). integer(5110).
integer(6661). integer(6662). integer(6663). integer(6664). integer(6665). integer(6666). integer(6667). integer(6668). integer(6669). integer(6670).
succ(91,92). succ(92,93). succ(93,94). succ(94,95). succ(95,96).
succ(96,97). succ(97,98). succ(98,99). succ(99,100). succ(100,101).
succ(136,137). succ(137,138). succ(138,139). succ(139,140). succ(140,141).
succ(211,212). succ(212,213). succ(213,214). succ(214,215). succ(215,216).
succ(461,462). succ(462,463). succ(463,464). succ(464,465). succ(465,466).
succ(991,992). succ(992,993). succ(993,994). succ(994,995). succ(995,996).
succ(1326,1327). succ(1327,1328). succ(1328,1329). succ(1329,1330). succ(1330,1331).
succ(1601,1602). succ(1602,1603). succ(1603,1604). succ(1604,1605). succ(1605,1606).
succ(1606,1607). succ(1607,1608). succ(1608,1609). succ(1609,1610). succ(1610,1611).
succ(1906,1907). succ(1907,1908). succ(1908,1909). succ(1909,1910). succ(1910,1911).
succ(1986,1987). succ(1987,1988). succ(1988,1989). succ(1989,1990). succ(1990,1991).
succ(2711,2712). succ(2712,2713). succ(2713,2714). succ(2714,2715). succ(2715,2716).
succ(5101,5102). succ(5102,5103). succ(5103,5104). succ(5104,5105). succ(5105,5106).
succ(5986,5987). succ(5987,5988). succ(5988,5989). succ(5989,5990). succ(5990,5991).
succ(6006,6007). succ(6007,6008). succ(6008,6009). succ(6009,6010). succ(6010,6011).
succ(6636,6637). succ(6637,6638). succ(6638,6639). succ(6639,6640). succ(6640,6641).
succ(6661,6662). succ(6662,6663). succ(6663,6664). succ(6664,6665). succ(6665,6666).
succ(7416,7417). succ(7417,7418). succ(7418,7419). succ(7419,7420). succ(7420,7421).
is_prime(2). is_prime(3). is_prime(5). is_prime(7). is_prime(11). is_prime(13). is_prime(17). is_prime(19). is_prime(23). is_prime(29).
is_prime(283). is_prime(293). is_prime(307). is_prime(311). is_prime(313). is_prime(317). is_prime(331). is_prime(337). is_prime(347). is_prime(349).
is_prime(5099). is_prime(5101). is_prime(5107). is_prime(5113). is_prime(5119). is_prime(5147). is_prime(5153). is_prime(5167). is_prime(5171). is_prime(5179).
is_prime(7417). is_prime(7433). is_prime(7451). is_prime(7457). is_prime(7459). is_prime(7477). is_prime(7481). is_prime(7487). is_prime(7489). is_prime(7499).
is_composite(134). is_composite(135). is_composite(136). is_composite(138). is_composite(140). is_composite(141). is_composite(142). is_composite(143). is_composite(144). is_composite(145).
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