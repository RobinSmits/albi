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
integer(151). integer(152). integer(153). integer(154). integer(155). integer(156). integer(157). integer(158). integer(159). integer(160).
integer(2141). integer(2142). integer(2143). integer(2144). integer(2145). integer(2146). integer(2147). integer(2148). integer(2149). integer(2150).
integer(2551). integer(2552). integer(2553). integer(2554). integer(2555). integer(2556). integer(2557). integer(2558). integer(2559). integer(2560).
integer(2801). integer(2802). integer(2803). integer(2804). integer(2805). integer(2806). integer(2807). integer(2808). integer(2809). integer(2810).
integer(5051). integer(5052). integer(5053). integer(5054). integer(5055). integer(5056). integer(5057). integer(5058). integer(5059). integer(5060).
integer(6841). integer(6842). integer(6843). integer(6844). integer(6845). integer(6846). integer(6847). integer(6848). integer(6849). integer(6850).
succ(61,62). succ(62,63). succ(63,64). succ(64,65). succ(65,66).
succ(126,127). succ(127,128). succ(128,129). succ(129,130). succ(130,131).
succ(136,137). succ(137,138). succ(138,139). succ(139,140). succ(140,141).
succ(151,152). succ(152,153). succ(153,154). succ(154,155). succ(155,156).
succ(1486,1487). succ(1487,1488). succ(1488,1489). succ(1489,1490). succ(1490,1491).
succ(1626,1627). succ(1627,1628). succ(1628,1629). succ(1629,1630). succ(1630,1631).
succ(1656,1657). succ(1657,1658). succ(1658,1659). succ(1659,1660). succ(1660,1661).
succ(2086,2087). succ(2087,2088). succ(2088,2089). succ(2089,2090). succ(2090,2091).
succ(2136,2137). succ(2137,2138). succ(2138,2139). succ(2139,2140). succ(2140,2141).
succ(2141,2142). succ(2142,2143). succ(2143,2144). succ(2144,2145). succ(2145,2146).
succ(2551,2552). succ(2552,2553). succ(2553,2554). succ(2554,2555). succ(2555,2556).
succ(2801,2802). succ(2802,2803). succ(2803,2804). succ(2804,2805). succ(2805,2806).
succ(3136,3137). succ(3137,3138). succ(3138,3139). succ(3139,3140). succ(3140,3141).
succ(5051,5052). succ(5052,5053). succ(5053,5054). succ(5054,5055). succ(5055,5056).
succ(6246,6247). succ(6247,6248). succ(6248,6249). succ(6249,6250). succ(6250,6251).
succ(6256,6257). succ(6257,6258). succ(6258,6259). succ(6259,6260). succ(6260,6261).
succ(6841,6842). succ(6842,6843). succ(6843,6844). succ(6844,6845). succ(6845,6846).
succ(7866,7867). succ(7867,7868). succ(7868,7869). succ(7869,7870). succ(7870,7871).
is_prime(127). is_prime(131). is_prime(137). is_prime(139). is_prime(149). is_prime(151). is_prime(157). is_prime(163). is_prime(167). is_prime(173).
is_prime(6841). is_prime(6857). is_prime(6863). is_prime(6869). is_prime(6871). is_prime(6883). is_prime(6899). is_prime(6907). is_prime(6911). is_prime(6917).
is_composite(744). is_composite(745). is_composite(746). is_composite(747). is_composite(748). is_composite(749). is_composite(750). is_composite(752). is_composite(753). is_composite(754).
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