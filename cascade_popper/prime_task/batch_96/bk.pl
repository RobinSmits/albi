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
integer(41). integer(42). integer(43). integer(44). integer(45). integer(46). integer(47). integer(48). integer(49). integer(50).
integer(71). integer(72). integer(73). integer(74). integer(75). integer(76). integer(77). integer(78). integer(79). integer(80).
integer(251). integer(252). integer(253). integer(254). integer(255). integer(256). integer(257). integer(258). integer(259). integer(260).
integer(3511). integer(3512). integer(3513). integer(3514). integer(3515). integer(3516). integer(3517). integer(3518). integer(3519). integer(3520).
integer(3671). integer(3672). integer(3673). integer(3674). integer(3675). integer(3676). integer(3677). integer(3678). integer(3679). integer(3680).
integer(5011). integer(5012). integer(5013). integer(5014). integer(5015). integer(5016). integer(5017). integer(5018). integer(5019). integer(5020).
integer(6091). integer(6092). integer(6093). integer(6094). integer(6095). integer(6096). integer(6097). integer(6098). integer(6099). integer(6100).
integer(6101). integer(6102). integer(6103). integer(6104). integer(6105). integer(6106). integer(6107). integer(6108). integer(6109). integer(6110).
succ(31,32). succ(32,33). succ(33,34). succ(34,35). succ(35,36).
succ(41,42). succ(42,43). succ(43,44). succ(44,45). succ(45,46).
succ(71,72). succ(72,73). succ(73,74). succ(74,75). succ(75,76).
succ(161,162). succ(162,163). succ(163,164). succ(164,165). succ(165,166).
succ(166,167). succ(167,168). succ(168,169). succ(169,170). succ(170,171).
succ(246,247). succ(247,248). succ(248,249). succ(249,250). succ(250,251).
succ(251,252). succ(252,253). succ(253,254). succ(254,255). succ(255,256).
succ(1216,1217). succ(1217,1218). succ(1218,1219). succ(1219,1220). succ(1220,1221).
succ(1486,1487). succ(1487,1488). succ(1488,1489). succ(1489,1490). succ(1490,1491).
succ(2766,2767). succ(2767,2768). succ(2768,2769). succ(2769,2770). succ(2770,2771).
succ(3511,3512). succ(3512,3513). succ(3513,3514). succ(3514,3515). succ(3515,3516).
succ(3671,3672). succ(3672,3673). succ(3673,3674). succ(3674,3675). succ(3675,3676).
succ(5011,5012). succ(5012,5013). succ(5013,5014). succ(5014,5015). succ(5015,5016).
succ(6091,6092). succ(6092,6093). succ(6093,6094). succ(6094,6095). succ(6095,6096).
succ(6101,6102). succ(6102,6103). succ(6103,6104). succ(6104,6105). succ(6105,6106).
succ(7906,7907). succ(7907,7908). succ(7908,7909). succ(7909,7910). succ(7910,7911).
is_prime(31). is_prime(37). is_prime(41). is_prime(43). is_prime(47). is_prime(53). is_prime(59). is_prime(61). is_prime(67). is_prime(71).
is_prime(2539). is_prime(2543). is_prime(2549). is_prime(2551). is_prime(2557). is_prime(2579). is_prime(2591). is_prime(2593). is_prime(2609). is_prime(2617).
is_prime(5009). is_prime(5011). is_prime(5021). is_prime(5023). is_prime(5039). is_prime(5051). is_prime(5059). is_prime(5077). is_prime(5081). is_prime(5087).
is_composite(85). is_composite(86). is_composite(87). is_composite(88). is_composite(90). is_composite(91). is_composite(92). is_composite(93). is_composite(94). is_composite(95).
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