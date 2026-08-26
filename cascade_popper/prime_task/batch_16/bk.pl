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

integer(11). integer(12). integer(13). integer(14). integer(15). integer(16). integer(17). integer(18). integer(19). integer(20).
integer(71). integer(72). integer(73). integer(74). integer(75). integer(76). integer(77). integer(78). integer(79). integer(80).
integer(281). integer(282). integer(283). integer(284). integer(285). integer(286). integer(287). integer(288). integer(289). integer(290).
integer(691). integer(692). integer(693). integer(694). integer(695). integer(696). integer(697). integer(698). integer(699). integer(700).
integer(1291). integer(1292). integer(1293). integer(1294). integer(1295). integer(1296). integer(1297). integer(1298). integer(1299). integer(1300).
integer(1931). integer(1932). integer(1933). integer(1934). integer(1935). integer(1936). integer(1937). integer(1938). integer(1939). integer(1940).
integer(2741). integer(2742). integer(2743). integer(2744). integer(2745). integer(2746). integer(2747). integer(2748). integer(2749). integer(2750).
integer(3821). integer(3822). integer(3823). integer(3824). integer(3825). integer(3826). integer(3827). integer(3828). integer(3829). integer(3830).
integer(5851). integer(5852). integer(5853). integer(5854). integer(5855). integer(5856). integer(5857). integer(5858). integer(5859). integer(5860).
integer(6271). integer(6272). integer(6273). integer(6274). integer(6275). integer(6276). integer(6277). integer(6278). integer(6279). integer(6280).
integer(6481). integer(6482). integer(6483). integer(6484). integer(6485). integer(6486). integer(6487). integer(6488). integer(6489). integer(6490).
succ(11,12). succ(12,13). succ(13,14). succ(14,15). succ(15,16).
succ(66,67). succ(67,68). succ(68,69). succ(69,70). succ(70,71).
succ(71,72). succ(72,73). succ(73,74). succ(74,75). succ(75,76).
succ(256,257). succ(257,258). succ(258,259). succ(259,260). succ(260,261).
succ(281,282). succ(282,283). succ(283,284). succ(284,285). succ(285,286).
succ(691,692). succ(692,693). succ(693,694). succ(694,695). succ(695,696).
succ(756,757). succ(757,758). succ(758,759). succ(759,760). succ(760,761).
succ(1291,1292). succ(1292,1293). succ(1293,1294). succ(1294,1295). succ(1295,1296).
succ(1446,1447). succ(1447,1448). succ(1448,1449). succ(1449,1450). succ(1450,1451).
succ(1906,1907). succ(1907,1908). succ(1908,1909). succ(1909,1910). succ(1910,1911).
succ(1931,1932). succ(1932,1933). succ(1933,1934). succ(1934,1935). succ(1935,1936).
succ(2206,2207). succ(2207,2208). succ(2208,2209). succ(2209,2210). succ(2210,2211).
succ(2296,2297). succ(2297,2298). succ(2298,2299). succ(2299,2300). succ(2300,2301).
succ(2741,2742). succ(2742,2743). succ(2743,2744). succ(2744,2745). succ(2745,2746).
succ(3821,3822). succ(3822,3823). succ(3823,3824). succ(3824,3825). succ(3825,3826).
succ(5851,5852). succ(5852,5853). succ(5853,5854). succ(5854,5855). succ(5855,5856).
succ(6196,6197). succ(6197,6198). succ(6198,6199). succ(6199,6200). succ(6200,6201).
succ(6271,6272). succ(6272,6273). succ(6273,6274). succ(6274,6275). succ(6275,6276).
succ(6276,6277). succ(6277,6278). succ(6278,6279). succ(6279,6280). succ(6280,6281).
succ(6481,6482). succ(6482,6483). succ(6483,6484). succ(6484,6485). succ(6485,6486).
is_prime(1663). is_prime(1667). is_prime(1669). is_prime(1693). is_prime(1697). is_prime(1699). is_prime(1709). is_prime(1721). is_prime(1723). is_prime(1733).
is_prime(2293). is_prime(2297). is_prime(2309). is_prime(2311). is_prime(2333). is_prime(2339). is_prime(2341). is_prime(2347). is_prime(2351). is_prime(2357).
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