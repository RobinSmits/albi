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

integer(251). integer(252). integer(253). integer(254). integer(255). integer(256). integer(257). integer(258). integer(259). integer(260).
integer(571). integer(572). integer(573). integer(574). integer(575). integer(576). integer(577). integer(578). integer(579). integer(580).
integer(811). integer(812). integer(813). integer(814). integer(815). integer(816). integer(817). integer(818). integer(819). integer(820).
integer(1061). integer(1062). integer(1063). integer(1064). integer(1065). integer(1066). integer(1067). integer(1068). integer(1069). integer(1070).
integer(1621). integer(1622). integer(1623). integer(1624). integer(1625). integer(1626). integer(1627). integer(1628). integer(1629). integer(1630).
integer(2441). integer(2442). integer(2443). integer(2444). integer(2445). integer(2446). integer(2447). integer(2448). integer(2449). integer(2450).
integer(5101). integer(5102). integer(5103). integer(5104). integer(5105). integer(5106). integer(5107). integer(5108). integer(5109). integer(5110).
integer(5441). integer(5442). integer(5443). integer(5444). integer(5445). integer(5446). integer(5447). integer(5448). integer(5449). integer(5450).
integer(5531). integer(5532). integer(5533). integer(5534). integer(5535). integer(5536). integer(5537). integer(5538). integer(5539). integer(5540).
succ(196,197). succ(197,198). succ(198,199). succ(199,200). succ(200,201).
succ(251,252). succ(252,253). succ(253,254). succ(254,255). succ(255,256).
succ(571,572). succ(572,573). succ(573,574). succ(574,575). succ(575,576).
succ(576,577). succ(577,578). succ(578,579). succ(579,580). succ(580,581).
succ(726,727). succ(727,728). succ(728,729). succ(729,730). succ(730,731).
succ(811,812). succ(812,813). succ(813,814). succ(814,815). succ(815,816).
succ(1061,1062). succ(1062,1063). succ(1063,1064). succ(1064,1065). succ(1065,1066).
succ(1446,1447). succ(1447,1448). succ(1448,1449). succ(1449,1450). succ(1450,1451).
succ(1621,1622). succ(1622,1623). succ(1623,1624). succ(1624,1625). succ(1625,1626).
succ(2441,2442). succ(2442,2443). succ(2443,2444). succ(2444,2445). succ(2445,2446).
succ(2646,2647). succ(2647,2648). succ(2648,2649). succ(2649,2650). succ(2650,2651).
succ(5101,5102). succ(5102,5103). succ(5103,5104). succ(5104,5105). succ(5105,5106).
succ(5106,5107). succ(5107,5108). succ(5108,5109). succ(5109,5110). succ(5110,5111).
succ(5441,5442). succ(5442,5443). succ(5443,5444). succ(5444,5445). succ(5445,5446).
succ(5526,5527). succ(5527,5528). succ(5528,5529). succ(5529,5530). succ(5530,5531).
succ(5531,5532). succ(5532,5533). succ(5533,5534). succ(5534,5535). succ(5535,5536).
is_prime(811). is_prime(821). is_prime(823). is_prime(827). is_prime(829). is_prime(839). is_prime(853). is_prime(857). is_prime(859). is_prime(863).
is_prime(5527). is_prime(5531). is_prime(5557). is_prime(5563). is_prime(5569). is_prime(5573). is_prime(5581). is_prime(5591). is_prime(5623). is_prime(5639).
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