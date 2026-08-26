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
integer(571). integer(572). integer(573). integer(574). integer(575). integer(576). integer(577). integer(578). integer(579). integer(580).
integer(1051). integer(1052). integer(1053). integer(1054). integer(1055). integer(1056). integer(1057). integer(1058). integer(1059). integer(1060).
integer(1061). integer(1062). integer(1063). integer(1064). integer(1065). integer(1066). integer(1067). integer(1068). integer(1069). integer(1070).
integer(2221). integer(2222). integer(2223). integer(2224). integer(2225). integer(2226). integer(2227). integer(2228). integer(2229). integer(2230).
integer(2551). integer(2552). integer(2553). integer(2554). integer(2555). integer(2556). integer(2557). integer(2558). integer(2559). integer(2560).
integer(4001). integer(4002). integer(4003). integer(4004). integer(4005). integer(4006). integer(4007). integer(4008). integer(4009). integer(4010).
integer(4871). integer(4872). integer(4873). integer(4874). integer(4875). integer(4876). integer(4877). integer(4878). integer(4879). integer(4880).
integer(5741). integer(5742). integer(5743). integer(5744). integer(5745). integer(5746). integer(5747). integer(5748). integer(5749). integer(5750).
succ(31,32). succ(32,33). succ(33,34). succ(34,35). succ(35,36).
succ(131,132). succ(132,133). succ(133,134). succ(134,135). succ(135,136).
succ(571,572). succ(572,573). succ(573,574). succ(574,575). succ(575,576).
succ(1051,1052). succ(1052,1053). succ(1053,1054). succ(1054,1055). succ(1055,1056).
succ(1061,1062). succ(1062,1063). succ(1063,1064). succ(1064,1065). succ(1065,1066).
succ(2086,2087). succ(2087,2088). succ(2088,2089). succ(2089,2090). succ(2090,2091).
succ(2206,2207). succ(2207,2208). succ(2208,2209). succ(2209,2210). succ(2210,2211).
succ(2221,2222). succ(2222,2223). succ(2223,2224). succ(2224,2225). succ(2225,2226).
succ(2551,2552). succ(2552,2553). succ(2553,2554). succ(2554,2555). succ(2555,2556).
succ(3166,3167). succ(3167,3168). succ(3168,3169). succ(3169,3170). succ(3170,3171).
succ(3606,3607). succ(3607,3608). succ(3608,3609). succ(3609,3610). succ(3610,3611).
succ(4001,4002). succ(4002,4003). succ(4003,4004). succ(4004,4005). succ(4005,4006).
succ(4871,4872). succ(4872,4873). succ(4873,4874). succ(4874,4875). succ(4875,4876).
succ(4876,4877). succ(4877,4878). succ(4878,4879). succ(4879,4880). succ(4880,4881).
succ(5736,5737). succ(5737,5738). succ(5738,5739). succ(5739,5740). succ(5740,5741).
succ(5741,5742). succ(5742,5743). succ(5743,5744). succ(5744,5745). succ(5745,5746).
is_prime(31). is_prime(37). is_prime(41). is_prime(43). is_prime(47). is_prime(53). is_prime(59). is_prime(61). is_prime(67). is_prime(71).
is_prime(73). is_prime(79). is_prime(83). is_prime(89). is_prime(97). is_prime(101). is_prime(103). is_prime(107). is_prime(109). is_prime(113).
is_prime(353). is_prime(359). is_prime(367). is_prime(373). is_prime(379). is_prime(383). is_prime(389). is_prime(397). is_prime(401). is_prime(409).
is_prime(2221). is_prime(2237). is_prime(2239). is_prime(2243). is_prime(2251). is_prime(2267). is_prime(2269). is_prime(2273). is_prime(2281). is_prime(2287).
is_prime(4001). is_prime(4003). is_prime(4007). is_prime(4013). is_prime(4019). is_prime(4021). is_prime(4027). is_prime(4049). is_prime(4051). is_prime(4057).
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