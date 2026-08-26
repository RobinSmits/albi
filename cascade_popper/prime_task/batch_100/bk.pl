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

integer(131). integer(132). integer(133). integer(134). integer(135). integer(136). integer(137). integer(138). integer(139). integer(140).
integer(251). integer(252). integer(253). integer(254). integer(255). integer(256). integer(257). integer(258). integer(259). integer(260).
integer(331). integer(332). integer(333). integer(334). integer(335). integer(336). integer(337). integer(338). integer(339). integer(340).
integer(1091). integer(1092). integer(1093). integer(1094). integer(1095). integer(1096). integer(1097). integer(1098). integer(1099). integer(1100).
integer(1861). integer(1862). integer(1863). integer(1864). integer(1865). integer(1866). integer(1867). integer(1868). integer(1869). integer(1870).
integer(5501). integer(5502). integer(5503). integer(5504). integer(5505). integer(5506). integer(5507). integer(5508). integer(5509). integer(5510).
integer(6571). integer(6572). integer(6573). integer(6574). integer(6575). integer(6576). integer(6577). integer(6578). integer(6579). integer(6580).
integer(7841). integer(7842). integer(7843). integer(7844). integer(7845). integer(7846). integer(7847). integer(7848). integer(7849). integer(7850).
succ(126,127). succ(127,128). succ(128,129). succ(129,130). succ(130,131).
succ(131,132). succ(132,133). succ(133,134). succ(134,135). succ(135,136).
succ(171,172). succ(172,173). succ(173,174). succ(174,175). succ(175,176).
succ(226,227). succ(227,228). succ(228,229). succ(229,230). succ(230,231).
succ(251,252). succ(252,253). succ(253,254). succ(254,255). succ(255,256).
succ(331,332). succ(332,333). succ(333,334). succ(334,335). succ(335,336).
succ(346,347). succ(347,348). succ(348,349). succ(349,350). succ(350,351).
succ(856,857). succ(857,858). succ(858,859). succ(859,860). succ(860,861).
succ(876,877). succ(877,878). succ(878,879). succ(879,880). succ(880,881).
succ(1091,1092). succ(1092,1093). succ(1093,1094). succ(1094,1095). succ(1095,1096).
succ(1276,1277). succ(1277,1278). succ(1278,1279). succ(1279,1280). succ(1280,1281).
succ(1746,1747). succ(1747,1748). succ(1748,1749). succ(1749,1750). succ(1750,1751).
succ(1861,1862). succ(1862,1863). succ(1863,1864). succ(1864,1865). succ(1865,1866).
succ(1866,1867). succ(1867,1868). succ(1868,1869). succ(1869,1870). succ(1870,1871).
succ(2026,2027). succ(2027,2028). succ(2028,2029). succ(2029,2030). succ(2030,2031).
succ(5501,5502). succ(5502,5503). succ(5503,5504). succ(5504,5505). succ(5505,5506).
succ(6571,6572). succ(6572,6573). succ(6573,6574). succ(6574,6575). succ(6575,6576).
succ(7841,7842). succ(7842,7843). succ(7843,7844). succ(7844,7845). succ(7845,7846).
is_prime(127). is_prime(131). is_prime(137). is_prime(139). is_prime(149). is_prime(151). is_prime(157). is_prime(163). is_prime(167). is_prime(173).
is_prime(353). is_prime(359). is_prime(367). is_prime(373). is_prime(379). is_prime(383). is_prime(389). is_prime(397). is_prime(401). is_prime(409).
is_prime(877). is_prime(881). is_prime(883). is_prime(887). is_prime(907). is_prime(911). is_prime(919). is_prime(929). is_prime(937). is_prime(941).
is_prime(7841). is_prime(7853). is_prime(7867). is_prime(7873). is_prime(7877). is_prime(7879). is_prime(7883). is_prime(7901). is_prime(7907). is_prime(7919).
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