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

integer(331). integer(332). integer(333). integer(334). integer(335). integer(336). integer(337). integer(338). integer(339). integer(340).
integer(521). integer(522). integer(523). integer(524). integer(525). integer(526). integer(527). integer(528). integer(529). integer(530).
integer(811). integer(812). integer(813). integer(814). integer(815). integer(816). integer(817). integer(818). integer(819). integer(820).
integer(881). integer(882). integer(883). integer(884). integer(885). integer(886). integer(887). integer(888). integer(889). integer(890).
integer(941). integer(942). integer(943). integer(944). integer(945). integer(946). integer(947). integer(948). integer(949). integer(950).
integer(1171). integer(1172). integer(1173). integer(1174). integer(1175). integer(1176). integer(1177). integer(1178). integer(1179). integer(1180).
integer(1471). integer(1472). integer(1473). integer(1474). integer(1475). integer(1476). integer(1477). integer(1478). integer(1479). integer(1480).
integer(2351). integer(2352). integer(2353). integer(2354). integer(2355). integer(2356). integer(2357). integer(2358). integer(2359). integer(2360).
integer(2371). integer(2372). integer(2373). integer(2374). integer(2375). integer(2376). integer(2377). integer(2378). integer(2379). integer(2380).
integer(3571). integer(3572). integer(3573). integer(3574). integer(3575). integer(3576). integer(3577). integer(3578). integer(3579). integer(3580).
integer(3581). integer(3582). integer(3583). integer(3584). integer(3585). integer(3586). integer(3587). integer(3588). integer(3589). integer(3590).
integer(4271). integer(4272). integer(4273). integer(4274). integer(4275). integer(4276). integer(4277). integer(4278). integer(4279). integer(4280).
succ(16,17). succ(17,18). succ(18,19). succ(19,20). succ(20,21).
succ(46,47). succ(47,48). succ(48,49). succ(49,50). succ(50,51).
succ(256,257). succ(257,258). succ(258,259). succ(259,260). succ(260,261).
succ(331,332). succ(332,333). succ(333,334). succ(334,335). succ(335,336).
succ(346,347). succ(347,348). succ(348,349). succ(349,350). succ(350,351).
succ(521,522). succ(522,523). succ(523,524). succ(524,525). succ(525,526).
succ(811,812). succ(812,813). succ(813,814). succ(814,815). succ(815,816).
succ(876,877). succ(877,878). succ(878,879). succ(879,880). succ(880,881).
succ(881,882). succ(882,883). succ(883,884). succ(884,885). succ(885,886).
succ(941,942). succ(942,943). succ(943,944). succ(944,945). succ(945,946).
succ(946,947). succ(947,948). succ(948,949). succ(949,950). succ(950,951).
succ(1171,1172). succ(1172,1173). succ(1173,1174). succ(1174,1175). succ(1175,1176).
succ(1471,1472). succ(1472,1473). succ(1473,1474). succ(1474,1475). succ(1475,1476).
succ(2351,2352). succ(2352,2353). succ(2353,2354). succ(2354,2355). succ(2355,2356).
succ(2371,2372). succ(2372,2373). succ(2373,2374). succ(2374,2375). succ(2375,2376).
succ(3571,3572). succ(3572,3573). succ(3573,3574). succ(3574,3575). succ(3575,3576).
succ(3581,3582). succ(3582,3583). succ(3583,3584). succ(3584,3585). succ(3585,3586).
succ(4271,4272). succ(4272,4273). succ(4273,4274). succ(4274,4275). succ(4275,4276).
succ(4546,4547). succ(4547,4548). succ(4548,4549). succ(4549,4550). succ(4550,4551).
succ(4566,4567). succ(4567,4568). succ(4568,4569). succ(4569,4570). succ(4570,4571).
succ(5226,5227). succ(5227,5228). succ(5228,5229). succ(5229,5230). succ(5230,5231).
is_prime(811). is_prime(821). is_prime(823). is_prime(827). is_prime(829). is_prime(839). is_prime(853). is_prime(857). is_prime(859). is_prime(863).
is_prime(877). is_prime(881). is_prime(883). is_prime(887). is_prime(907). is_prime(911). is_prime(919). is_prime(929). is_prime(937). is_prime(941).
is_prime(947). is_prime(953). is_prime(967). is_prime(971). is_prime(977). is_prime(983). is_prime(991). is_prime(997). is_prime(1009). is_prime(1013).
is_prime(2371). is_prime(2377). is_prime(2381). is_prime(2383). is_prime(2389). is_prime(2393). is_prime(2399). is_prime(2411). is_prime(2417). is_prime(2423).
is_prime(3581). is_prime(3583). is_prime(3593). is_prime(3607). is_prime(3613). is_prime(3617). is_prime(3623). is_prime(3631). is_prime(3637). is_prime(3643).
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