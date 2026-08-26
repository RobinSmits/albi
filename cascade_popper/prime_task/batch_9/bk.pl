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
integer(491). integer(492). integer(493). integer(494). integer(495). integer(496). integer(497). integer(498). integer(499). integer(500).
integer(1951). integer(1952). integer(1953). integer(1954). integer(1955). integer(1956). integer(1957). integer(1958). integer(1959). integer(1960).
integer(4231). integer(4232). integer(4233). integer(4234). integer(4235). integer(4236). integer(4237). integer(4238). integer(4239). integer(4240).
integer(4241). integer(4242). integer(4243). integer(4244). integer(4245). integer(4246). integer(4247). integer(4248). integer(4249). integer(4250).
integer(6421). integer(6422). integer(6423). integer(6424). integer(6425). integer(6426). integer(6427). integer(6428). integer(6429). integer(6430).
integer(7121). integer(7122). integer(7123). integer(7124). integer(7125). integer(7126). integer(7127). integer(7128). integer(7129). integer(7130).
succ(71,72). succ(72,73). succ(73,74). succ(74,75). succ(75,76).
succ(96,97). succ(97,98). succ(98,99). succ(99,100). succ(100,101).
succ(106,107). succ(107,108). succ(108,109). succ(109,110). succ(110,111).
succ(116,117). succ(117,118). succ(118,119). succ(119,120). succ(120,121).
succ(126,127). succ(127,128). succ(128,129). succ(129,130). succ(130,131).
succ(131,132). succ(132,133). succ(133,134). succ(134,135). succ(135,136).
succ(486,487). succ(487,488). succ(488,489). succ(489,490). succ(490,491).
succ(491,492). succ(492,493). succ(493,494). succ(494,495). succ(495,496).
succ(876,877). succ(877,878). succ(878,879). succ(879,880). succ(880,881).
succ(1366,1367). succ(1367,1368). succ(1368,1369). succ(1369,1370). succ(1370,1371).
succ(1951,1952). succ(1952,1953). succ(1953,1954). succ(1954,1955). succ(1955,1956).
succ(4231,4232). succ(4232,4233). succ(4233,4234). succ(4234,4235). succ(4235,4236).
succ(4241,4242). succ(4242,4243). succ(4243,4244). succ(4244,4245). succ(4245,4246).
succ(5806,5807). succ(5807,5808). succ(5808,5809). succ(5809,5810). succ(5810,5811).
succ(6421,6422). succ(6422,6423). succ(6423,6424). succ(6424,6425). succ(6425,6426).
succ(6426,6427). succ(6427,6428). succ(6428,6429). succ(6429,6430). succ(6430,6431).
succ(7121,7122). succ(7122,7123). succ(7123,7124). succ(7124,7125). succ(7125,7126).
is_prime(73). is_prime(79). is_prime(83). is_prime(89). is_prime(97). is_prime(101). is_prime(103). is_prime(107). is_prime(109). is_prime(113).
is_prime(127). is_prime(131). is_prime(137). is_prime(139). is_prime(149). is_prime(151). is_prime(157). is_prime(163). is_prime(167). is_prime(173).
is_prime(877). is_prime(881). is_prime(883). is_prime(887). is_prime(907). is_prime(911). is_prime(919). is_prime(929). is_prime(937). is_prime(941).
is_prime(1523). is_prime(1531). is_prime(1543). is_prime(1549). is_prime(1553). is_prime(1559). is_prime(1567). is_prime(1571). is_prime(1579). is_prime(1583).
is_prime(4073). is_prime(4079). is_prime(4091). is_prime(4093). is_prime(4099). is_prime(4111). is_prime(4127). is_prime(4129). is_prime(4133). is_prime(4139).
is_prime(4241). is_prime(4243). is_prime(4253). is_prime(4259). is_prime(4261). is_prime(4271). is_prime(4273). is_prime(4283). is_prime(4289). is_prime(4297).
is_prime(7109). is_prime(7121). is_prime(7127). is_prime(7129). is_prime(7151). is_prime(7159). is_prime(7177). is_prime(7187). is_prime(7193). is_prime(7207).
is_composite(72). is_composite(74). is_composite(75). is_composite(76). is_composite(77). is_composite(78). is_composite(80). is_composite(81). is_composite(82). is_composite(84).
is_composite(954). is_composite(955). is_composite(956). is_composite(957). is_composite(958). is_composite(959). is_composite(960). is_composite(961). is_composite(962). is_composite(963).
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