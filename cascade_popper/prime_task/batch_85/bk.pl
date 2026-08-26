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
integer(1231). integer(1232). integer(1233). integer(1234). integer(1235). integer(1236). integer(1237). integer(1238). integer(1239). integer(1240).
integer(1451). integer(1452). integer(1453). integer(1454). integer(1455). integer(1456). integer(1457). integer(1458). integer(1459). integer(1460).
integer(1481). integer(1482). integer(1483). integer(1484). integer(1485). integer(1486). integer(1487). integer(1488). integer(1489). integer(1490).
integer(2311). integer(2312). integer(2313). integer(2314). integer(2315). integer(2316). integer(2317). integer(2318). integer(2319). integer(2320).
integer(2791). integer(2792). integer(2793). integer(2794). integer(2795). integer(2796). integer(2797). integer(2798). integer(2799). integer(2800).
integer(4111). integer(4112). integer(4113). integer(4114). integer(4115). integer(4116). integer(4117). integer(4118). integer(4119). integer(4120).
integer(5521). integer(5522). integer(5523). integer(5524). integer(5525). integer(5526). integer(5527). integer(5528). integer(5529). integer(5530).
integer(6661). integer(6662). integer(6663). integer(6664). integer(6665). integer(6666). integer(6667). integer(6668). integer(6669). integer(6670).
integer(7121). integer(7122). integer(7123). integer(7124). integer(7125). integer(7126). integer(7127). integer(7128). integer(7129). integer(7130).
succ(31,32). succ(32,33). succ(33,34). succ(34,35). succ(35,36).
succ(1231,1232). succ(1232,1233). succ(1233,1234). succ(1234,1235). succ(1235,1236).
succ(1451,1452). succ(1452,1453). succ(1453,1454). succ(1454,1455). succ(1455,1456).
succ(1481,1482). succ(1482,1483). succ(1483,1484). succ(1484,1485). succ(1485,1486).
succ(1986,1987). succ(1987,1988). succ(1988,1989). succ(1989,1990). succ(1990,1991).
succ(1996,1997). succ(1997,1998). succ(1998,1999). succ(1999,2000). succ(2000,2001).
succ(2311,2312). succ(2312,2313). succ(2313,2314). succ(2314,2315). succ(2315,2316).
succ(2791,2792). succ(2792,2793). succ(2793,2794). succ(2794,2795). succ(2795,2796).
succ(2796,2797). succ(2797,2798). succ(2798,2799). succ(2799,2800). succ(2800,2801).
succ(4111,4112). succ(4112,4113). succ(4113,4114). succ(4114,4115). succ(4115,4116).
succ(5521,5522). succ(5522,5523). succ(5523,5524). succ(5524,5525). succ(5525,5526).
succ(5526,5527). succ(5527,5528). succ(5528,5529). succ(5529,5530). succ(5530,5531).
succ(6661,6662). succ(6662,6663). succ(6663,6664). succ(6664,6665). succ(6665,6666).
succ(7121,7122). succ(7122,7123). succ(7123,7124). succ(7124,7125). succ(7125,7126).
succ(7126,7127). succ(7127,7128). succ(7128,7129). succ(7129,7130). succ(7130,7131).
succ(7176,7177). succ(7177,7178). succ(7178,7179). succ(7179,7180). succ(7180,7181).
succ(7186,7187). succ(7187,7188). succ(7188,7189). succ(7189,7190). succ(7190,7191).
is_prime(31). is_prime(37). is_prime(41). is_prime(43). is_prime(47). is_prime(53). is_prime(59). is_prime(61). is_prime(67). is_prime(71).
is_prime(1229). is_prime(1231). is_prime(1237). is_prime(1249). is_prime(1259). is_prime(1277). is_prime(1279). is_prime(1283). is_prime(1289). is_prime(1291).
is_prime(1993). is_prime(1997). is_prime(1999). is_prime(2003). is_prime(2011). is_prime(2017). is_prime(2027). is_prime(2029). is_prime(2039). is_prime(2053).
is_prime(2063). is_prime(2069). is_prime(2081). is_prime(2083). is_prime(2087). is_prime(2089). is_prime(2099). is_prime(2111). is_prime(2113). is_prime(2129).
is_prime(5527). is_prime(5531). is_prime(5557). is_prime(5563). is_prime(5569). is_prime(5573). is_prime(5581). is_prime(5591). is_prime(5623). is_prime(5639).
is_composite(1452). is_composite(1454). is_composite(1455). is_composite(1456). is_composite(1457). is_composite(1458). is_composite(1460). is_composite(1461). is_composite(1462). is_composite(1463).
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