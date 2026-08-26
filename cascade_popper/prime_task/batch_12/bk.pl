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

integer(2111). integer(2112). integer(2113). integer(2114). integer(2115). integer(2116). integer(2117). integer(2118). integer(2119). integer(2120).
integer(2521). integer(2522). integer(2523). integer(2524). integer(2525). integer(2526). integer(2527). integer(2528). integer(2529). integer(2530).
integer(3701). integer(3702). integer(3703). integer(3704). integer(3705). integer(3706). integer(3707). integer(3708). integer(3709). integer(3710).
integer(5171). integer(5172). integer(5173). integer(5174). integer(5175). integer(5176). integer(5177). integer(5178). integer(5179). integer(5180).
integer(5471). integer(5472). integer(5473). integer(5474). integer(5475). integer(5476). integer(5477). integer(5478). integer(5479). integer(5480).
integer(5641). integer(5642). integer(5643). integer(5644). integer(5645). integer(5646). integer(5647). integer(5648). integer(5649). integer(5650).
integer(7321). integer(7322). integer(7323). integer(7324). integer(7325). integer(7326). integer(7327). integer(7328). integer(7329). integer(7330).
integer(7691). integer(7692). integer(7693). integer(7694). integer(7695). integer(7696). integer(7697). integer(7698). integer(7699). integer(7700).
succ(36,37). succ(37,38). succ(38,39). succ(39,40). succ(40,41).
succ(121,122). succ(122,123). succ(123,124). succ(124,125). succ(125,126).
succ(126,127). succ(127,128). succ(128,129). succ(129,130). succ(130,131).
succ(576,577). succ(577,578). succ(578,579). succ(579,580). succ(580,581).
succ(1236,1237). succ(1237,1238). succ(1238,1239). succ(1239,1240). succ(1240,1241).
succ(2111,2112). succ(2112,2113). succ(2113,2114). succ(2114,2115). succ(2115,2116).
succ(2266,2267). succ(2267,2268). succ(2268,2269). succ(2269,2270). succ(2270,2271).
succ(2476,2477). succ(2477,2478). succ(2478,2479). succ(2479,2480). succ(2480,2481).
succ(2521,2522). succ(2522,2523). succ(2523,2524). succ(2524,2525). succ(2525,2526).
succ(3696,3697). succ(3697,3698). succ(3698,3699). succ(3699,3700). succ(3700,3701).
succ(3701,3702). succ(3702,3703). succ(3703,3704). succ(3704,3705). succ(3705,3706).
succ(5166,5167). succ(5167,5168). succ(5168,5169). succ(5169,5170). succ(5170,5171).
succ(5171,5172). succ(5172,5173). succ(5173,5174). succ(5174,5175). succ(5175,5176).
succ(5471,5472). succ(5472,5473). succ(5473,5474). succ(5474,5475). succ(5475,5476).
succ(5641,5642). succ(5642,5643). succ(5643,5644). succ(5644,5645). succ(5645,5646).
succ(5646,5647). succ(5647,5648). succ(5648,5649). succ(5649,5650). succ(5650,5651).
succ(7321,7322). succ(7322,7323). succ(7323,7324). succ(7324,7325). succ(7325,7326).
succ(7686,7687). succ(7687,7688). succ(7688,7689). succ(7689,7690). succ(7690,7691).
succ(7691,7692). succ(7692,7693). succ(7693,7694). succ(7694,7695). succ(7695,7696).
is_prime(127). is_prime(131). is_prime(137). is_prime(139). is_prime(149). is_prime(151). is_prime(157). is_prime(163). is_prime(167). is_prime(173).
is_prime(233). is_prime(239). is_prime(241). is_prime(251). is_prime(257). is_prime(263). is_prime(269). is_prime(271). is_prime(277). is_prime(281).
is_prime(1153). is_prime(1163). is_prime(1171). is_prime(1181). is_prime(1187). is_prime(1193). is_prime(1201). is_prime(1213). is_prime(1217). is_prime(1223).
is_prime(1229). is_prime(1231). is_prime(1237). is_prime(1249). is_prime(1259). is_prime(1277). is_prime(1279). is_prime(1283). is_prime(1289). is_prime(1291).
is_prime(2909). is_prime(2917). is_prime(2927). is_prime(2939). is_prime(2953). is_prime(2957). is_prime(2963). is_prime(2969). is_prime(2971). is_prime(2999).
is_prime(5449). is_prime(5471). is_prime(5477). is_prime(5479). is_prime(5483). is_prime(5501). is_prime(5503). is_prime(5507). is_prime(5519). is_prime(5521).
is_prime(5641). is_prime(5647). is_prime(5651). is_prime(5653). is_prime(5657). is_prime(5659). is_prime(5669). is_prime(5683). is_prime(5689). is_prime(5693).
is_composite(122). is_composite(123). is_composite(124). is_composite(125). is_composite(126). is_composite(128). is_composite(129). is_composite(130). is_composite(132). is_composite(133).
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