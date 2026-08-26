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

integer(71). integer(72). integer(73). integer(74). integer(75). integer(76). integer(77). integer(78). integer(79). integer(80).
integer(401). integer(402). integer(403). integer(404). integer(405). integer(406). integer(407). integer(408). integer(409). integer(410).
integer(631). integer(632). integer(633). integer(634). integer(635). integer(636). integer(637). integer(638). integer(639). integer(640).
integer(1171). integer(1172). integer(1173). integer(1174). integer(1175). integer(1176). integer(1177). integer(1178). integer(1179). integer(1180).
integer(1181). integer(1182). integer(1183). integer(1184). integer(1185). integer(1186). integer(1187). integer(1188). integer(1189). integer(1190).
integer(1231). integer(1232). integer(1233). integer(1234). integer(1235). integer(1236). integer(1237). integer(1238). integer(1239). integer(1240).
integer(1301). integer(1302). integer(1303). integer(1304). integer(1305). integer(1306). integer(1307). integer(1308). integer(1309). integer(1310).
integer(2591). integer(2592). integer(2593). integer(2594). integer(2595). integer(2596). integer(2597). integer(2598). integer(2599). integer(2600).
integer(3361). integer(3362). integer(3363). integer(3364). integer(3365). integer(3366). integer(3367). integer(3368). integer(3369). integer(3370).
integer(4051). integer(4052). integer(4053). integer(4054). integer(4055). integer(4056). integer(4057). integer(4058). integer(4059). integer(4060).
integer(5021). integer(5022). integer(5023). integer(5024). integer(5025). integer(5026). integer(5027). integer(5028). integer(5029). integer(5030).
integer(6481). integer(6482). integer(6483). integer(6484). integer(6485). integer(6486). integer(6487). integer(6488). integer(6489). integer(6490).
integer(6491). integer(6492). integer(6493). integer(6494). integer(6495). integer(6496). integer(6497). integer(6498). integer(6499). integer(6500).
integer(6991). integer(6992). integer(6993). integer(6994). integer(6995). integer(6996). integer(6997). integer(6998). integer(6999). integer(7000).
succ(71,72). succ(72,73). succ(73,74). succ(74,75). succ(75,76).
succ(76,77). succ(77,78). succ(78,79). succ(79,80). succ(80,81).
succ(401,402). succ(402,403). succ(403,404). succ(404,405). succ(405,406).
succ(616,617). succ(617,618). succ(618,619). succ(619,620). succ(620,621).
succ(631,632). succ(632,633). succ(633,634). succ(634,635). succ(635,636).
succ(946,947). succ(947,948). succ(948,949). succ(949,950). succ(950,951).
succ(966,967). succ(967,968). succ(968,969). succ(969,970). succ(970,971).
succ(1171,1172). succ(1172,1173). succ(1173,1174). succ(1174,1175). succ(1175,1176).
succ(1181,1182). succ(1182,1183). succ(1183,1184). succ(1184,1185). succ(1185,1186).
succ(1231,1232). succ(1232,1233). succ(1233,1234). succ(1234,1235). succ(1235,1236).
succ(1296,1297). succ(1297,1298). succ(1298,1299). succ(1299,1300). succ(1300,1301).
succ(1301,1302). succ(1302,1303). succ(1303,1304). succ(1304,1305). succ(1305,1306).
succ(2556,2557). succ(2557,2558). succ(2558,2559). succ(2559,2560). succ(2560,2561).
succ(2591,2592). succ(2592,2593). succ(2593,2594). succ(2594,2595). succ(2595,2596).
succ(3361,3362). succ(3362,3363). succ(3363,3364). succ(3364,3365). succ(3365,3366).
succ(4051,4052). succ(4052,4053). succ(4053,4054). succ(4054,4055). succ(4055,4056).
succ(5021,5022). succ(5022,5023). succ(5023,5024). succ(5024,5025). succ(5025,5026).
succ(6481,6482). succ(6482,6483). succ(6483,6484). succ(6484,6485). succ(6485,6486).
succ(6491,6492). succ(6492,6493). succ(6493,6494). succ(6494,6495). succ(6495,6496).
succ(6991,6992). succ(6992,6993). succ(6993,6994). succ(6994,6995). succ(6995,6996).
is_prime(73). is_prime(79). is_prime(83). is_prime(89). is_prime(97). is_prime(101). is_prime(103). is_prime(107). is_prime(109). is_prime(113).
is_prime(947). is_prime(953). is_prime(967). is_prime(971). is_prime(977). is_prime(983). is_prime(991). is_prime(997). is_prime(1009). is_prime(1013).
is_prime(1297). is_prime(1301). is_prime(1303). is_prime(1307). is_prime(1319). is_prime(1321). is_prime(1327). is_prime(1361). is_prime(1367). is_prime(1373).
is_prime(3823). is_prime(3833). is_prime(3847). is_prime(3851). is_prime(3853). is_prime(3863). is_prime(3877). is_prime(3881). is_prime(3889). is_prime(3907).
is_prime(6481). is_prime(6491). is_prime(6521). is_prime(6529). is_prime(6547). is_prime(6551). is_prime(6553). is_prime(6563). is_prime(6569). is_prime(6571).
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