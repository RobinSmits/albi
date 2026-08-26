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

integer(101). integer(102). integer(103). integer(104). integer(105). integer(106). integer(107). integer(108). integer(109). integer(110).
integer(131). integer(132). integer(133). integer(134). integer(135). integer(136). integer(137). integer(138). integer(139). integer(140).
integer(421). integer(422). integer(423). integer(424). integer(425). integer(426). integer(427). integer(428). integer(429). integer(430).
integer(2131). integer(2132). integer(2133). integer(2134). integer(2135). integer(2136). integer(2137). integer(2138). integer(2139). integer(2140).
integer(2141). integer(2142). integer(2143). integer(2144). integer(2145). integer(2146). integer(2147). integer(2148). integer(2149). integer(2150).
integer(2731). integer(2732). integer(2733). integer(2734). integer(2735). integer(2736). integer(2737). integer(2738). integer(2739). integer(2740).
integer(2741). integer(2742). integer(2743). integer(2744). integer(2745). integer(2746). integer(2747). integer(2748). integer(2749). integer(2750).
integer(3541). integer(3542). integer(3543). integer(3544). integer(3545). integer(3546). integer(3547). integer(3548). integer(3549). integer(3550).
integer(4751). integer(4752). integer(4753). integer(4754). integer(4755). integer(4756). integer(4757). integer(4758). integer(4759). integer(4760).
integer(6421). integer(6422). integer(6423). integer(6424). integer(6425). integer(6426). integer(6427). integer(6428). integer(6429). integer(6430).
succ(66,67). succ(67,68). succ(68,69). succ(69,70). succ(70,71).
succ(101,102). succ(102,103). succ(103,104). succ(104,105). succ(105,106).
succ(106,107). succ(107,108). succ(108,109). succ(109,110). succ(110,111).
succ(131,132). succ(132,133). succ(133,134). succ(134,135). succ(135,136).
succ(421,422). succ(422,423). succ(423,424). succ(424,425). succ(425,426).
succ(646,647). succ(647,648). succ(648,649). succ(649,650). succ(650,651).
succ(826,827). succ(827,828). succ(828,829). succ(829,830). succ(830,831).
succ(856,857). succ(857,858). succ(858,859). succ(859,860). succ(860,861).
succ(996,997). succ(997,998). succ(998,999). succ(999,1000). succ(1000,1001).
succ(1486,1487). succ(1487,1488). succ(1488,1489). succ(1489,1490). succ(1490,1491).
succ(2131,2132). succ(2132,2133). succ(2133,2134). succ(2134,2135). succ(2135,2136).
succ(2141,2142). succ(2142,2143). succ(2143,2144). succ(2144,2145). succ(2145,2146).
succ(2731,2732). succ(2732,2733). succ(2733,2734). succ(2734,2735). succ(2735,2736).
succ(2741,2742). succ(2742,2743). succ(2743,2744). succ(2744,2745). succ(2745,2746).
succ(3541,3542). succ(3542,3543). succ(3543,3544). succ(3544,3545). succ(3545,3546).
succ(3546,3547). succ(3547,3548). succ(3548,3549). succ(3549,3550). succ(3550,3551).
succ(3766,3767). succ(3767,3768). succ(3768,3769). succ(3769,3770). succ(3770,3771).
succ(4751,4752). succ(4752,4753). succ(4753,4754). succ(4754,4755). succ(4755,4756).
succ(6396,6397). succ(6397,6398). succ(6398,6399). succ(6399,6400). succ(6400,6401).
succ(6421,6422). succ(6422,6423). succ(6423,6424). succ(6424,6425). succ(6425,6426).
is_prime(739). is_prime(743). is_prime(751). is_prime(757). is_prime(761). is_prime(769). is_prime(773). is_prime(787). is_prime(797). is_prime(809).
is_prime(2131). is_prime(2137). is_prime(2141). is_prime(2143). is_prime(2153). is_prime(2161). is_prime(2179). is_prime(2203). is_prime(2207). is_prime(2213).
is_composite(1488). is_composite(1490). is_composite(1491). is_composite(1492). is_composite(1494). is_composite(1495). is_composite(1496). is_composite(1497). is_composite(1498). is_composite(1500).
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