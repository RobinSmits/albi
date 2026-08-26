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
integer(41). integer(42). integer(43). integer(44). integer(45). integer(46). integer(47). integer(48). integer(49). integer(50).
integer(131). integer(132). integer(133). integer(134). integer(135). integer(136). integer(137). integer(138). integer(139). integer(140).
integer(251). integer(252). integer(253). integer(254). integer(255). integer(256). integer(257). integer(258). integer(259). integer(260).
integer(1721). integer(1722). integer(1723). integer(1724). integer(1725). integer(1726). integer(1727). integer(1728). integer(1729). integer(1730).
integer(1931). integer(1932). integer(1933). integer(1934). integer(1935). integer(1936). integer(1937). integer(1938). integer(1939). integer(1940).
integer(7621). integer(7622). integer(7623). integer(7624). integer(7625). integer(7626). integer(7627). integer(7628). integer(7629). integer(7630).
integer(7741). integer(7742). integer(7743). integer(7744). integer(7745). integer(7746). integer(7747). integer(7748). integer(7749). integer(7750).
succ(11,12). succ(12,13). succ(13,14). succ(14,15). succ(15,16).
succ(36,37). succ(37,38). succ(38,39). succ(39,40). succ(40,41).
succ(41,42). succ(42,43). succ(43,44). succ(44,45). succ(45,46).
succ(131,132). succ(132,133). succ(133,134). succ(134,135). succ(135,136).
succ(166,167). succ(167,168). succ(168,169). succ(169,170). succ(170,171).
succ(226,227). succ(227,228). succ(228,229). succ(229,230). succ(230,231).
succ(246,247). succ(247,248). succ(248,249). succ(249,250). succ(250,251).
succ(251,252). succ(252,253). succ(253,254). succ(254,255). succ(255,256).
succ(1236,1237). succ(1237,1238). succ(1238,1239). succ(1239,1240). succ(1240,1241).
succ(1721,1722). succ(1722,1723). succ(1723,1724). succ(1724,1725). succ(1725,1726).
succ(1931,1932). succ(1932,1933). succ(1933,1934). succ(1934,1935). succ(1935,1936).
succ(2656,2657). succ(2657,2658). succ(2658,2659). succ(2659,2660). succ(2660,2661).
succ(2956,2957). succ(2957,2958). succ(2958,2959). succ(2959,2960). succ(2960,2961).
succ(6826,6827). succ(6827,6828). succ(6828,6829). succ(6829,6830). succ(6830,6831).
succ(7606,7607). succ(7607,7608). succ(7608,7609). succ(7609,7610). succ(7610,7611).
succ(7621,7622). succ(7622,7623). succ(7623,7624). succ(7624,7625). succ(7625,7626).
succ(7726,7727). succ(7727,7728). succ(7728,7729). succ(7729,7730). succ(7730,7731).
succ(7741,7742). succ(7742,7743). succ(7743,7744). succ(7744,7745). succ(7745,7746).
is_prime(233). is_prime(239). is_prime(241). is_prime(251). is_prime(257). is_prime(263). is_prime(269). is_prime(271). is_prime(277). is_prime(281).
is_prime(7727). is_prime(7741). is_prime(7753). is_prime(7757). is_prime(7759). is_prime(7789). is_prime(7793). is_prime(7817). is_prime(7823). is_prime(7829).
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