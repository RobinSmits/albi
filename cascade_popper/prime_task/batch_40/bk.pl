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

integer(11). integer(12). integer(13). integer(14). integer(15). integer(16). integer(17). integer(18). integer(19). integer(20).
integer(241). integer(242). integer(243). integer(244). integer(245). integer(246). integer(247). integer(248). integer(249). integer(250).
integer(251). integer(252). integer(253). integer(254). integer(255). integer(256). integer(257). integer(258). integer(259). integer(260).
integer(1051). integer(1052). integer(1053). integer(1054). integer(1055). integer(1056). integer(1057). integer(1058). integer(1059). integer(1060).
integer(1301). integer(1302). integer(1303). integer(1304). integer(1305). integer(1306). integer(1307). integer(1308). integer(1309). integer(1310).
integer(1831). integer(1832). integer(1833). integer(1834). integer(1835). integer(1836). integer(1837). integer(1838). integer(1839). integer(1840).
integer(2131). integer(2132). integer(2133). integer(2134). integer(2135). integer(2136). integer(2137). integer(2138). integer(2139). integer(2140).
integer(2381). integer(2382). integer(2383). integer(2384). integer(2385). integer(2386). integer(2387). integer(2388). integer(2389). integer(2390).
integer(5351). integer(5352). integer(5353). integer(5354). integer(5355). integer(5356). integer(5357). integer(5358). integer(5359). integer(5360).
succ(11,12). succ(12,13). succ(13,14). succ(14,15). succ(15,16).
succ(16,17). succ(17,18). succ(18,19). succ(19,20). succ(20,21).
succ(116,117). succ(117,118). succ(118,119). succ(119,120). succ(120,121).
succ(126,127). succ(127,128). succ(128,129). succ(129,130). succ(130,131).
succ(241,242). succ(242,243). succ(243,244). succ(244,245). succ(245,246).
succ(251,252). succ(252,253). succ(253,254). succ(254,255). succ(255,256).
succ(616,617). succ(617,618). succ(618,619). succ(619,620). succ(620,621).
succ(1051,1052). succ(1052,1053). succ(1053,1054). succ(1054,1055). succ(1055,1056).
succ(1301,1302). succ(1302,1303). succ(1303,1304). succ(1304,1305). succ(1305,1306).
succ(1306,1307). succ(1307,1308). succ(1308,1309). succ(1309,1310). succ(1310,1311).
succ(1831,1832). succ(1832,1833). succ(1833,1834). succ(1834,1835). succ(1835,1836).
succ(2131,2132). succ(2132,2133). succ(2133,2134). succ(2134,2135). succ(2135,2136).
succ(2381,2382). succ(2382,2383). succ(2383,2384). succ(2384,2385). succ(2385,2386).
succ(2416,2417). succ(2417,2418). succ(2418,2419). succ(2419,2420). succ(2420,2421).
succ(2436,2437). succ(2437,2438). succ(2438,2439). succ(2439,2440). succ(2440,2441).
succ(4456,4457). succ(4457,4458). succ(4458,4459). succ(4459,4460). succ(4460,4461).
succ(5346,5347). succ(5347,5348). succ(5348,5349). succ(5349,5350). succ(5350,5351).
succ(5351,5352). succ(5352,5353). succ(5353,5354). succ(5354,5355). succ(5355,5356).
is_prime(127). is_prime(131). is_prime(137). is_prime(139). is_prime(149). is_prime(151). is_prime(157). is_prime(163). is_prime(167). is_prime(173).
is_prime(739). is_prime(743). is_prime(751). is_prime(757). is_prime(761). is_prime(769). is_prime(773). is_prime(787). is_prime(797). is_prime(809).
is_prime(2131). is_prime(2137). is_prime(2141). is_prime(2143). is_prime(2153). is_prime(2161). is_prime(2179). is_prime(2203). is_prime(2207). is_prime(2213).
is_prime(2437). is_prime(2441). is_prime(2447). is_prime(2459). is_prime(2467). is_prime(2473). is_prime(2477). is_prime(2503). is_prime(2521). is_prime(2531).
is_prime(3083). is_prime(3089). is_prime(3109). is_prime(3119). is_prime(3121). is_prime(3137). is_prime(3163). is_prime(3167). is_prime(3169). is_prime(3181).
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