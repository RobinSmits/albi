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

integer(191). integer(192). integer(193). integer(194). integer(195). integer(196). integer(197). integer(198). integer(199). integer(200).
integer(541). integer(542). integer(543). integer(544). integer(545). integer(546). integer(547). integer(548). integer(549). integer(550).
integer(661). integer(662). integer(663). integer(664). integer(665). integer(666). integer(667). integer(668). integer(669). integer(670).
integer(1201). integer(1202). integer(1203). integer(1204). integer(1205). integer(1206). integer(1207). integer(1208). integer(1209). integer(1210).
integer(3931). integer(3932). integer(3933). integer(3934). integer(3935). integer(3936). integer(3937). integer(3938). integer(3939). integer(3940).
integer(4261). integer(4262). integer(4263). integer(4264). integer(4265). integer(4266). integer(4267). integer(4268). integer(4269). integer(4270).
integer(4931). integer(4932). integer(4933). integer(4934). integer(4935). integer(4936). integer(4937). integer(4938). integer(4939). integer(4940).
integer(7411). integer(7412). integer(7413). integer(7414). integer(7415). integer(7416). integer(7417). integer(7418). integer(7419). integer(7420).
succ(46,47). succ(47,48). succ(48,49). succ(49,50). succ(50,51).
succ(191,192). succ(192,193). succ(193,194). succ(194,195). succ(195,196).
succ(541,542). succ(542,543). succ(543,544). succ(544,545). succ(545,546).
succ(546,547). succ(547,548). succ(548,549). succ(549,550). succ(550,551).
succ(661,662). succ(662,663). succ(663,664). succ(664,665). succ(665,666).
succ(676,677). succ(677,678). succ(678,679). succ(679,680). succ(680,681).
succ(726,727). succ(727,728). succ(728,729). succ(729,730). succ(730,731).
succ(1201,1202). succ(1202,1203). succ(1203,1204). succ(1204,1205). succ(1205,1206).
succ(2136,2137). succ(2137,2138). succ(2138,2139). succ(2139,2140). succ(2140,2141).
succ(2676,2677). succ(2677,2678). succ(2678,2679). succ(2679,2680). succ(2680,2681).
succ(2686,2687). succ(2687,2688). succ(2688,2689). succ(2689,2690). succ(2690,2691).
succ(3931,3932). succ(3932,3933). succ(3933,3934). succ(3934,3935). succ(3935,3936).
succ(4126,4127). succ(4127,4128). succ(4128,4129). succ(4129,4130). succ(4130,4131).
succ(4261,4262). succ(4262,4263). succ(4263,4264). succ(4264,4265). succ(4265,4266).
succ(4931,4932). succ(4932,4933). succ(4933,4934). succ(4934,4935). succ(4935,4936).
succ(7411,7412). succ(7412,7413). succ(7413,7414). succ(7414,7415). succ(7415,7416).
succ(7416,7417). succ(7417,7418). succ(7418,7419). succ(7419,7420). succ(7420,7421).
is_prime(179). is_prime(181). is_prime(191). is_prime(193). is_prime(197). is_prime(199). is_prime(211). is_prime(223). is_prime(227). is_prime(229).
is_prime(283). is_prime(293). is_prime(307). is_prime(311). is_prime(313). is_prime(317). is_prime(331). is_prime(337). is_prime(347). is_prime(349).
is_prime(419). is_prime(421). is_prime(431). is_prime(433). is_prime(439). is_prime(443). is_prime(449). is_prime(457). is_prime(461). is_prime(463).
is_prime(547). is_prime(557). is_prime(563). is_prime(569). is_prime(571). is_prime(577). is_prime(587). is_prime(593). is_prime(599). is_prime(601).
is_prime(661). is_prime(673). is_prime(677). is_prime(683). is_prime(691). is_prime(701). is_prime(709). is_prime(719). is_prime(727). is_prime(733).
is_prime(739). is_prime(743). is_prime(751). is_prime(757). is_prime(761). is_prime(769). is_prime(773). is_prime(787). is_prime(797). is_prime(809).
is_prime(2689). is_prime(2693). is_prime(2699). is_prime(2707). is_prime(2711). is_prime(2713). is_prime(2719). is_prime(2729). is_prime(2731). is_prime(2741).
is_prime(7417). is_prime(7433). is_prime(7451). is_prime(7457). is_prime(7459). is_prime(7477). is_prime(7481). is_prime(7487). is_prime(7489). is_prime(7499).
is_composite(46). is_composite(48). is_composite(49). is_composite(50). is_composite(51). is_composite(52). is_composite(54). is_composite(55). is_composite(56). is_composite(57).
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