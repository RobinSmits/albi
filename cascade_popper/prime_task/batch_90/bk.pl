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

integer(311). integer(312). integer(313). integer(314). integer(315). integer(316). integer(317). integer(318). integer(319). integer(320).
integer(491). integer(492). integer(493). integer(494). integer(495). integer(496). integer(497). integer(498). integer(499). integer(500).
integer(631). integer(632). integer(633). integer(634). integer(635). integer(636). integer(637). integer(638). integer(639). integer(640).
integer(641). integer(642). integer(643). integer(644). integer(645). integer(646). integer(647). integer(648). integer(649). integer(650).
integer(751). integer(752). integer(753). integer(754). integer(755). integer(756). integer(757). integer(758). integer(759). integer(760).
integer(1151). integer(1152). integer(1153). integer(1154). integer(1155). integer(1156). integer(1157). integer(1158). integer(1159). integer(1160).
integer(2111). integer(2112). integer(2113). integer(2114). integer(2115). integer(2116). integer(2117). integer(2118). integer(2119). integer(2120).
integer(4621). integer(4622). integer(4623). integer(4624). integer(4625). integer(4626). integer(4627). integer(4628). integer(4629). integer(4630).
integer(7151). integer(7152). integer(7153). integer(7154). integer(7155). integer(7156). integer(7157). integer(7158). integer(7159). integer(7160).
integer(7351). integer(7352). integer(7353). integer(7354). integer(7355). integer(7356). integer(7357). integer(7358). integer(7359). integer(7360).
succ(26,27). succ(27,28). succ(28,29). succ(29,30). succ(30,31).
succ(56,57). succ(57,58). succ(58,59). succ(59,60). succ(60,61).
succ(106,107). succ(107,108). succ(108,109). succ(109,110). succ(110,111).
succ(126,127). succ(127,128). succ(128,129). succ(129,130). succ(130,131).
succ(311,312). succ(312,313). succ(313,314). succ(314,315). succ(315,316).
succ(491,492). succ(492,493). succ(493,494). succ(494,495). succ(495,496).
succ(631,632). succ(632,633). succ(633,634). succ(634,635). succ(635,636).
succ(641,642). succ(642,643). succ(643,644). succ(644,645). succ(645,646).
succ(751,752). succ(752,753). succ(753,754). succ(754,755). succ(755,756).
succ(1151,1152). succ(1152,1153). succ(1153,1154). succ(1154,1155). succ(1155,1156).
succ(2111,2112). succ(2112,2113). succ(2113,2114). succ(2114,2115). succ(2115,2116).
succ(3616,3617). succ(3617,3618). succ(3618,3619). succ(3619,3620). succ(3620,3621).
succ(3946,3947). succ(3947,3948). succ(3948,3949). succ(3949,3950). succ(3950,3951).
succ(3966,3967). succ(3967,3968). succ(3968,3969). succ(3969,3970). succ(3970,3971).
succ(4621,4622). succ(4622,4623). succ(4623,4624). succ(4624,4625). succ(4625,4626).
succ(6946,6947). succ(6947,6948). succ(6948,6949). succ(6949,6950). succ(6950,6951).
succ(7056,7057). succ(7057,7058). succ(7058,7059). succ(7059,7060). succ(7060,7061).
succ(7151,7152). succ(7152,7153). succ(7153,7154). succ(7154,7155). succ(7155,7156).
succ(7351,7352). succ(7352,7353). succ(7353,7354). succ(7354,7355). succ(7355,7356).
is_prime(127). is_prime(131). is_prime(137). is_prime(139). is_prime(149). is_prime(151). is_prime(157). is_prime(163). is_prime(167). is_prime(173).
is_prime(6947). is_prime(6949). is_prime(6959). is_prime(6961). is_prime(6967). is_prime(6971). is_prime(6977). is_prime(6983). is_prime(6991). is_prime(6997).
is_composite(720). is_composite(721). is_composite(722). is_composite(723). is_composite(724). is_composite(725). is_composite(726). is_composite(728). is_composite(729). is_composite(730).
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