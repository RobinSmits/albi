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
integer(191). integer(192). integer(193). integer(194). integer(195). integer(196). integer(197). integer(198). integer(199). integer(200).
integer(1051). integer(1052). integer(1053). integer(1054). integer(1055). integer(1056). integer(1057). integer(1058). integer(1059). integer(1060).
integer(1621). integer(1622). integer(1623). integer(1624). integer(1625). integer(1626). integer(1627). integer(1628). integer(1629). integer(1630).
integer(1741). integer(1742). integer(1743). integer(1744). integer(1745). integer(1746). integer(1747). integer(1748). integer(1749). integer(1750).
integer(2861). integer(2862). integer(2863). integer(2864). integer(2865). integer(2866). integer(2867). integer(2868). integer(2869). integer(2870).
integer(3761). integer(3762). integer(3763). integer(3764). integer(3765). integer(3766). integer(3767). integer(3768). integer(3769). integer(3770).
integer(6301). integer(6302). integer(6303). integer(6304). integer(6305). integer(6306). integer(6307). integer(6308). integer(6309). integer(6310).
integer(6311). integer(6312). integer(6313). integer(6314). integer(6315). integer(6316). integer(6317). integer(6318). integer(6319). integer(6320).
integer(6361). integer(6362). integer(6363). integer(6364). integer(6365). integer(6366). integer(6367). integer(6368). integer(6369). integer(6370).
integer(6971). integer(6972). integer(6973). integer(6974). integer(6975). integer(6976). integer(6977). integer(6978). integer(6979). integer(6980).
succ(61,62). succ(62,63). succ(63,64). succ(64,65). succ(65,66).
succ(156,157). succ(157,158). succ(158,159). succ(159,160). succ(160,161).
succ(191,192). succ(192,193). succ(193,194). succ(194,195). succ(195,196).
succ(196,197). succ(197,198). succ(198,199). succ(199,200). succ(200,201).
succ(396,397). succ(397,398). succ(398,399). succ(399,400). succ(400,401).
succ(1051,1052). succ(1052,1053). succ(1053,1054). succ(1054,1055). succ(1055,1056).
succ(1621,1622). succ(1622,1623). succ(1623,1624). succ(1624,1625). succ(1625,1626).
succ(1741,1742). succ(1742,1743). succ(1743,1744). succ(1744,1745). succ(1745,1746).
succ(2861,2862). succ(2862,2863). succ(2863,2864). succ(2864,2865). succ(2865,2866).
succ(3466,3467). succ(3467,3468). succ(3468,3469). succ(3469,3470). succ(3470,3471).
succ(3761,3762). succ(3762,3763). succ(3763,3764). succ(3764,3765). succ(3765,3766).
succ(5926,5927). succ(5927,5928). succ(5928,5929). succ(5929,5930). succ(5930,5931).
succ(6301,6302). succ(6302,6303). succ(6303,6304). succ(6304,6305). succ(6305,6306).
succ(6311,6312). succ(6312,6313). succ(6313,6314). succ(6314,6315). succ(6315,6316).
succ(6361,6362). succ(6362,6363). succ(6363,6364). succ(6364,6365). succ(6365,6366).
succ(6366,6367). succ(6367,6368). succ(6368,6369). succ(6369,6370). succ(6370,6371).
succ(6966,6967). succ(6967,6968). succ(6968,6969). succ(6969,6970). succ(6970,6971).
succ(6971,6972). succ(6972,6973). succ(6973,6974). succ(6974,6975). succ(6975,6976).
succ(7576,7577). succ(7577,7578). succ(7578,7579). succ(7579,7580). succ(7580,7581).
is_prime(1741). is_prime(1747). is_prime(1753). is_prime(1759). is_prime(1777). is_prime(1783). is_prime(1787). is_prime(1789). is_prime(1801). is_prime(1811).
is_prime(6311). is_prime(6317). is_prime(6323). is_prime(6329). is_prime(6337). is_prime(6343). is_prime(6353). is_prime(6359). is_prime(6361). is_prime(6367).
is_composite(196). is_composite(198). is_composite(200). is_composite(201). is_composite(202). is_composite(203). is_composite(204). is_composite(205). is_composite(206). is_composite(207).
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