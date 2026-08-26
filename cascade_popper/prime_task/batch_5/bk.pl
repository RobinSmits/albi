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
integer(61). integer(62). integer(63). integer(64). integer(65). integer(66). integer(67). integer(68). integer(69). integer(70).
integer(71). integer(72). integer(73). integer(74). integer(75). integer(76). integer(77). integer(78). integer(79). integer(80).
integer(1181). integer(1182). integer(1183). integer(1184). integer(1185). integer(1186). integer(1187). integer(1188). integer(1189). integer(1190).
integer(1801). integer(1802). integer(1803). integer(1804). integer(1805). integer(1806). integer(1807). integer(1808). integer(1809). integer(1810).
integer(1811). integer(1812). integer(1813). integer(1814). integer(1815). integer(1816). integer(1817). integer(1818). integer(1819). integer(1820).
integer(3331). integer(3332). integer(3333). integer(3334). integer(3335). integer(3336). integer(3337). integer(3338). integer(3339). integer(3340).
integer(4201). integer(4202). integer(4203). integer(4204). integer(4205). integer(4206). integer(4207). integer(4208). integer(4209). integer(4210).
integer(5171). integer(5172). integer(5173). integer(5174). integer(5175). integer(5176). integer(5177). integer(5178). integer(5179). integer(5180).
succ(26,27). succ(27,28). succ(28,29). succ(29,30). succ(30,31).
succ(31,32). succ(32,33). succ(33,34). succ(34,35). succ(35,36).
succ(61,62). succ(62,63). succ(63,64). succ(64,65). succ(65,66).
succ(71,72). succ(72,73). succ(73,74). succ(74,75). succ(75,76).
succ(256,257). succ(257,258). succ(258,259). succ(259,260). succ(260,261).
succ(306,307). succ(307,308). succ(308,309). succ(309,310). succ(310,311).
succ(1116,1117). succ(1117,1118). succ(1118,1119). succ(1119,1120). succ(1120,1121).
succ(1181,1182). succ(1182,1183). succ(1183,1184). succ(1184,1185). succ(1185,1186).
succ(1801,1802). succ(1802,1803). succ(1803,1804). succ(1804,1805). succ(1805,1806).
succ(1811,1812). succ(1812,1813). succ(1813,1814). succ(1814,1815). succ(1815,1816).
succ(2656,2657). succ(2657,2658). succ(2658,2659). succ(2659,2660). succ(2660,2661).
succ(3331,3332). succ(3332,3333). succ(3333,3334). succ(3334,3335). succ(3335,3336).
succ(4176,4177). succ(4177,4178). succ(4178,4179). succ(4179,4180). succ(4180,4181).
succ(4201,4202). succ(4202,4203). succ(4203,4204). succ(4204,4205). succ(4205,4206).
succ(4296,4297). succ(4297,4298). succ(4298,4299). succ(4299,4300). succ(4300,4301).
succ(4326,4327). succ(4327,4328). succ(4328,4329). succ(4329,4330). succ(4330,4331).
succ(5171,5172). succ(5172,5173). succ(5173,5174). succ(5174,5175). succ(5175,5176).
succ(6256,6257). succ(6257,6258). succ(6258,6259). succ(6259,6260). succ(6260,6261).
is_prime(31). is_prime(37). is_prime(41). is_prime(43). is_prime(47). is_prime(53). is_prime(59). is_prime(61). is_prime(67). is_prime(71).
is_prime(353). is_prime(359). is_prime(367). is_prime(373). is_prime(379). is_prime(383). is_prime(389). is_prime(397). is_prime(401). is_prime(409).
is_prime(3343). is_prime(3347). is_prime(3359). is_prime(3361). is_prime(3371). is_prime(3373). is_prime(3389). is_prime(3391). is_prime(3407). is_prime(3413).
is_prime(3733). is_prime(3739). is_prime(3761). is_prime(3767). is_prime(3769). is_prime(3779). is_prime(3793). is_prime(3797). is_prime(3803). is_prime(3821).
is_prime(4327). is_prime(4337). is_prime(4339). is_prime(4349). is_prime(4357). is_prime(4363). is_prime(4373). is_prime(4391). is_prime(4397). is_prime(4409).
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