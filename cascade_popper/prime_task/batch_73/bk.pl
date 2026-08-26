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

integer(181). integer(182). integer(183). integer(184). integer(185). integer(186). integer(187). integer(188). integer(189). integer(190).
integer(191). integer(192). integer(193). integer(194). integer(195). integer(196). integer(197). integer(198). integer(199). integer(200).
integer(211). integer(212). integer(213). integer(214). integer(215). integer(216). integer(217). integer(218). integer(219). integer(220).
integer(881). integer(882). integer(883). integer(884). integer(885). integer(886). integer(887). integer(888). integer(889). integer(890).
integer(941). integer(942). integer(943). integer(944). integer(945). integer(946). integer(947). integer(948). integer(949). integer(950).
integer(1571). integer(1572). integer(1573). integer(1574). integer(1575). integer(1576). integer(1577). integer(1578). integer(1579). integer(1580).
integer(1721). integer(1722). integer(1723). integer(1724). integer(1725). integer(1726). integer(1727). integer(1728). integer(1729). integer(1730).
integer(5881). integer(5882). integer(5883). integer(5884). integer(5885). integer(5886). integer(5887). integer(5888). integer(5889). integer(5890).
integer(6151). integer(6152). integer(6153). integer(6154). integer(6155). integer(6156). integer(6157). integer(6158). integer(6159). integer(6160).
integer(7151). integer(7152). integer(7153). integer(7154). integer(7155). integer(7156). integer(7157). integer(7158). integer(7159). integer(7160).
succ(46,47). succ(47,48). succ(48,49). succ(49,50). succ(50,51).
succ(181,182). succ(182,183). succ(183,184). succ(184,185). succ(185,186).
succ(191,192). succ(192,193). succ(193,194). succ(194,195). succ(195,196).
succ(211,212). succ(212,213). succ(213,214). succ(214,215). succ(215,216).
succ(881,882). succ(882,883). succ(883,884). succ(884,885). succ(885,886).
succ(941,942). succ(942,943). succ(943,944). succ(944,945). succ(945,946).
succ(1571,1572). succ(1572,1573). succ(1573,1574). succ(1574,1575). succ(1575,1576).
succ(1721,1722). succ(1722,1723). succ(1723,1724). succ(1724,1725). succ(1725,1726).
succ(1846,1847). succ(1847,1848). succ(1848,1849). succ(1849,1850). succ(1850,1851).
succ(2236,2237). succ(2237,2238). succ(2238,2239). succ(2239,2240). succ(2240,2241).
succ(5076,5077). succ(5077,5078). succ(5078,5079). succ(5079,5080). succ(5080,5081).
succ(5881,5882). succ(5882,5883). succ(5883,5884). succ(5884,5885). succ(5885,5886).
succ(6151,6152). succ(6152,6153). succ(6153,6154). succ(6154,6155). succ(6155,6156).
succ(7151,7152). succ(7152,7153). succ(7153,7154). succ(7154,7155). succ(7155,7156).
is_prime(5449). is_prime(5471). is_prime(5477). is_prime(5479). is_prime(5483). is_prime(5501). is_prime(5503). is_prime(5507). is_prime(5519). is_prime(5521).
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