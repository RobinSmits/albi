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
integer(101). integer(102). integer(103). integer(104). integer(105). integer(106). integer(107). integer(108). integer(109). integer(110).
integer(181). integer(182). integer(183). integer(184). integer(185). integer(186). integer(187). integer(188). integer(189). integer(190).
integer(601). integer(602). integer(603). integer(604). integer(605). integer(606). integer(607). integer(608). integer(609). integer(610).
integer(2111). integer(2112). integer(2113). integer(2114). integer(2115). integer(2116). integer(2117). integer(2118). integer(2119). integer(2120).
integer(3361). integer(3362). integer(3363). integer(3364). integer(3365). integer(3366). integer(3367). integer(3368). integer(3369). integer(3370).
integer(3371). integer(3372). integer(3373). integer(3374). integer(3375). integer(3376). integer(3377). integer(3378). integer(3379). integer(3380).
integer(5701). integer(5702). integer(5703). integer(5704). integer(5705). integer(5706). integer(5707). integer(5708). integer(5709). integer(5710).
succ(11,12). succ(12,13). succ(13,14). succ(14,15). succ(15,16).
succ(41,42). succ(42,43). succ(43,44). succ(44,45). succ(45,46).
succ(96,97). succ(97,98). succ(98,99). succ(99,100). succ(100,101).
succ(101,102). succ(102,103). succ(103,104). succ(104,105). succ(105,106).
succ(181,182). succ(182,183). succ(183,184). succ(184,185). succ(185,186).
succ(196,197). succ(197,198). succ(198,199). succ(199,200). succ(200,201).
succ(466,467). succ(467,468). succ(468,469). succ(469,470). succ(470,471).
succ(601,602). succ(602,603). succ(603,604). succ(604,605). succ(605,606).
succ(976,977). succ(977,978). succ(978,979). succ(979,980). succ(980,981).
succ(2111,2112). succ(2112,2113). succ(2113,2114). succ(2114,2115). succ(2115,2116).
succ(2836,2837). succ(2837,2838). succ(2838,2839). succ(2839,2840). succ(2840,2841).
succ(3361,3362). succ(3362,3363). succ(3363,3364). succ(3364,3365). succ(3365,3366).
succ(3371,3372). succ(3372,3373). succ(3373,3374). succ(3374,3375). succ(3375,3376).
succ(3796,3797). succ(3797,3798). succ(3798,3799). succ(3799,3800). succ(3800,3801).
succ(4966,4967). succ(4967,4968). succ(4968,4969). succ(4969,4970). succ(4970,4971).
succ(5701,5702). succ(5702,5703). succ(5703,5704). succ(5704,5705). succ(5705,5706).
is_prime(467). is_prime(479). is_prime(487). is_prime(491). is_prime(499). is_prime(503). is_prime(509). is_prime(521). is_prime(523). is_prime(541).
is_prime(2689). is_prime(2693). is_prime(2699). is_prime(2707). is_prime(2711). is_prime(2713). is_prime(2719). is_prime(2729). is_prime(2731). is_prime(2741).
is_prime(2833). is_prime(2837). is_prime(2843). is_prime(2851). is_prime(2857). is_prime(2861). is_prime(2879). is_prime(2887). is_prime(2897). is_prime(2903).
is_prime(5701). is_prime(5711). is_prime(5717). is_prime(5737). is_prime(5741). is_prime(5743). is_prime(5749). is_prime(5779). is_prime(5783). is_prime(5791).
is_composite(602). is_composite(603). is_composite(604). is_composite(605). is_composite(606). is_composite(608). is_composite(609). is_composite(610). is_composite(611). is_composite(612).
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