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

integer(211). integer(212). integer(213). integer(214). integer(215). integer(216). integer(217). integer(218). integer(219). integer(220).
integer(491). integer(492). integer(493). integer(494). integer(495). integer(496). integer(497). integer(498). integer(499). integer(500).
integer(941). integer(942). integer(943). integer(944). integer(945). integer(946). integer(947). integer(948). integer(949). integer(950).
integer(1171). integer(1172). integer(1173). integer(1174). integer(1175). integer(1176). integer(1177). integer(1178). integer(1179). integer(1180).
integer(2081). integer(2082). integer(2083). integer(2084). integer(2085). integer(2086). integer(2087). integer(2088). integer(2089). integer(2090).
integer(6781). integer(6782). integer(6783). integer(6784). integer(6785). integer(6786). integer(6787). integer(6788). integer(6789). integer(6790).
integer(7211). integer(7212). integer(7213). integer(7214). integer(7215). integer(7216). integer(7217). integer(7218). integer(7219). integer(7220).
integer(7681). integer(7682). integer(7683). integer(7684). integer(7685). integer(7686). integer(7687). integer(7688). integer(7689). integer(7690).
succ(211,212). succ(212,213). succ(213,214). succ(214,215). succ(215,216).
succ(456,457). succ(457,458). succ(458,459). succ(459,460). succ(460,461).
succ(491,492). succ(492,493). succ(493,494). succ(494,495). succ(495,496).
succ(941,942). succ(942,943). succ(943,944). succ(944,945). succ(945,946).
succ(946,947). succ(947,948). succ(948,949). succ(949,950). succ(950,951).
succ(1171,1172). succ(1172,1173). succ(1173,1174). succ(1174,1175). succ(1175,1176).
succ(1186,1187). succ(1187,1188). succ(1188,1189). succ(1189,1190). succ(1190,1191).
succ(1426,1427). succ(1427,1428). succ(1428,1429). succ(1429,1430). succ(1430,1431).
succ(2081,2082). succ(2082,2083). succ(2083,2084). succ(2084,2085). succ(2085,2086).
succ(3406,3407). succ(3407,3408). succ(3408,3409). succ(3409,3410). succ(3410,3411).
succ(6781,6782). succ(6782,6783). succ(6783,6784). succ(6784,6785). succ(6785,6786).
succ(7206,7207). succ(7207,7208). succ(7208,7209). succ(7209,7210). succ(7210,7211).
succ(7211,7212). succ(7212,7213). succ(7213,7214). succ(7214,7215). succ(7215,7216).
succ(7681,7682). succ(7682,7683). succ(7683,7684). succ(7684,7685). succ(7685,7686).
succ(7716,7717). succ(7717,7718). succ(7718,7719). succ(7719,7720). succ(7720,7721).
is_prime(947). is_prime(953). is_prime(967). is_prime(971). is_prime(977). is_prime(983). is_prime(991). is_prime(997). is_prime(1009). is_prime(1013).
is_prime(1153). is_prime(1163). is_prime(1171). is_prime(1181). is_prime(1187). is_prime(1193). is_prime(1201). is_prime(1213). is_prime(1217). is_prime(1223).
is_prime(2063). is_prime(2069). is_prime(2081). is_prime(2083). is_prime(2087). is_prime(2089). is_prime(2099). is_prime(2111). is_prime(2113). is_prime(2129).
is_prime(7211). is_prime(7213). is_prime(7219). is_prime(7229). is_prime(7237). is_prime(7243). is_prime(7247). is_prime(7253). is_prime(7283). is_prime(7297).
is_composite(942). is_composite(943). is_composite(944). is_composite(945). is_composite(946). is_composite(948). is_composite(949). is_composite(950). is_composite(951). is_composite(952).
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