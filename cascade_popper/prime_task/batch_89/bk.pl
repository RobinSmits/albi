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
integer(241). integer(242). integer(243). integer(244). integer(245). integer(246). integer(247). integer(248). integer(249). integer(250).
integer(311). integer(312). integer(313). integer(314). integer(315). integer(316). integer(317). integer(318). integer(319). integer(320).
integer(1151). integer(1152). integer(1153). integer(1154). integer(1155). integer(1156). integer(1157). integer(1158). integer(1159). integer(1160).
integer(1831). integer(1832). integer(1833). integer(1834). integer(1835). integer(1836). integer(1837). integer(1838). integer(1839). integer(1840).
integer(1901). integer(1902). integer(1903). integer(1904). integer(1905). integer(1906). integer(1907). integer(1908). integer(1909). integer(1910).
integer(2801). integer(2802). integer(2803). integer(2804). integer(2805). integer(2806). integer(2807). integer(2808). integer(2809). integer(2810).
integer(4391). integer(4392). integer(4393). integer(4394). integer(4395). integer(4396). integer(4397). integer(4398). integer(4399). integer(4400).
integer(5471). integer(5472). integer(5473). integer(5474). integer(5475). integer(5476). integer(5477). integer(5478). integer(5479). integer(5480).
integer(7481). integer(7482). integer(7483). integer(7484). integer(7485). integer(7486). integer(7487). integer(7488). integer(7489). integer(7490).
integer(7901). integer(7902). integer(7903). integer(7904). integer(7905). integer(7906). integer(7907). integer(7908). integer(7909). integer(7910).
succ(11,12). succ(12,13). succ(13,14). succ(14,15). succ(15,16).
succ(106,107). succ(107,108). succ(108,109). succ(109,110). succ(110,111).
succ(136,137). succ(137,138). succ(138,139). succ(139,140). succ(140,141).
succ(241,242). succ(242,243). succ(243,244). succ(244,245). succ(245,246).
succ(311,312). succ(312,313). succ(313,314). succ(314,315). succ(315,316).
succ(936,937). succ(937,938). succ(938,939). succ(939,940). succ(940,941).
succ(1151,1152). succ(1152,1153). succ(1153,1154). succ(1154,1155). succ(1155,1156).
succ(1276,1277). succ(1277,1278). succ(1278,1279). succ(1279,1280). succ(1280,1281).
succ(1831,1832). succ(1832,1833). succ(1833,1834). succ(1834,1835). succ(1835,1836).
succ(1901,1902). succ(1902,1903). succ(1903,1904). succ(1904,1905). succ(1905,1906).
succ(2796,2797). succ(2797,2798). succ(2798,2799). succ(2799,2800). succ(2800,2801).
succ(2801,2802). succ(2802,2803). succ(2803,2804). succ(2804,2805). succ(2805,2806).
succ(4391,4392). succ(4392,4393). succ(4393,4394). succ(4394,4395). succ(4395,4396).
succ(4396,4397). succ(4397,4398). succ(4398,4399). succ(4399,4400). succ(4400,4401).
succ(5471,5472). succ(5472,5473). succ(5473,5474). succ(5474,5475). succ(5475,5476).
succ(5476,5477). succ(5477,5478). succ(5478,5479). succ(5479,5480). succ(5480,5481).
succ(7236,7237). succ(7237,7238). succ(7238,7239). succ(7239,7240). succ(7240,7241).
succ(7476,7477). succ(7477,7478). succ(7478,7479). succ(7479,7480). succ(7480,7481).
succ(7481,7482). succ(7482,7483). succ(7483,7484). succ(7484,7485). succ(7485,7486).
succ(7901,7902). succ(7902,7903). succ(7903,7904). succ(7904,7905). succ(7905,7906).
is_prime(1823). is_prime(1831). is_prime(1847). is_prime(1861). is_prime(1867). is_prime(1871). is_prime(1873). is_prime(1877). is_prime(1879). is_prime(1889).
is_prime(1901). is_prime(1907). is_prime(1913). is_prime(1931). is_prime(1933). is_prime(1949). is_prime(1951). is_prime(1973). is_prime(1979). is_prime(1987).
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