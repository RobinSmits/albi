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
integer(281). integer(282). integer(283). integer(284). integer(285). integer(286). integer(287). integer(288). integer(289). integer(290).
integer(661). integer(662). integer(663). integer(664). integer(665). integer(666). integer(667). integer(668). integer(669). integer(670).
integer(1321). integer(1322). integer(1323). integer(1324). integer(1325). integer(1326). integer(1327). integer(1328). integer(1329). integer(1330).
integer(2141). integer(2142). integer(2143). integer(2144). integer(2145). integer(2146). integer(2147). integer(2148). integer(2149). integer(2150).
integer(2671). integer(2672). integer(2673). integer(2674). integer(2675). integer(2676). integer(2677). integer(2678). integer(2679). integer(2680).
integer(7351). integer(7352). integer(7353). integer(7354). integer(7355). integer(7356). integer(7357). integer(7358). integer(7359). integer(7360).
integer(7451). integer(7452). integer(7453). integer(7454). integer(7455). integer(7456). integer(7457). integer(7458). integer(7459). integer(7460).
succ(46,47). succ(47,48). succ(48,49). succ(49,50). succ(50,51).
succ(166,167). succ(167,168). succ(168,169). succ(169,170). succ(170,171).
succ(186,187). succ(187,188). succ(188,189). succ(189,190). succ(190,191).
succ(191,192). succ(192,193). succ(193,194). succ(194,195). succ(195,196).
succ(281,282). succ(282,283). succ(283,284). succ(284,285). succ(285,286).
succ(661,662). succ(662,663). succ(663,664). succ(664,665). succ(665,666).
succ(786,787). succ(787,788). succ(788,789). succ(789,790). succ(790,791).
succ(796,797). succ(797,798). succ(798,799). succ(799,800). succ(800,801).
succ(1086,1087). succ(1087,1088). succ(1088,1089). succ(1089,1090). succ(1090,1091).
succ(1321,1322). succ(1322,1323). succ(1323,1324). succ(1324,1325). succ(1325,1326).
succ(2016,2017). succ(2017,2018). succ(2018,2019). succ(2019,2020). succ(2020,2021).
succ(2026,2027). succ(2027,2028). succ(2028,2029). succ(2029,2030). succ(2030,2031).
succ(2141,2142). succ(2142,2143). succ(2143,2144). succ(2144,2145). succ(2145,2146).
succ(2671,2672). succ(2672,2673). succ(2673,2674). succ(2674,2675). succ(2675,2676).
succ(5716,5717). succ(5717,5718). succ(5718,5719). succ(5719,5720). succ(5720,5721).
succ(5736,5737). succ(5737,5738). succ(5738,5739). succ(5739,5740). succ(5740,5741).
succ(7351,7352). succ(7352,7353). succ(7353,7354). succ(7354,7355). succ(7355,7356).
succ(7451,7452). succ(7452,7453). succ(7453,7454). succ(7454,7455). succ(7455,7456).
is_prime(179). is_prime(181). is_prime(191). is_prime(193). is_prime(197). is_prime(199). is_prime(211). is_prime(223). is_prime(227). is_prime(229).
is_prime(283). is_prime(293). is_prime(307). is_prime(311). is_prime(313). is_prime(317). is_prime(331). is_prime(337). is_prime(347). is_prime(349).
is_prime(661). is_prime(673). is_prime(677). is_prime(683). is_prime(691). is_prime(701). is_prime(709). is_prime(719). is_prime(727). is_prime(733).
is_prime(1087). is_prime(1091). is_prime(1093). is_prime(1097). is_prime(1103). is_prime(1109). is_prime(1117). is_prime(1123). is_prime(1129). is_prime(1151).
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