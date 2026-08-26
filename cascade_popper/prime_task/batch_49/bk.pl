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
integer(151). integer(152). integer(153). integer(154). integer(155). integer(156). integer(157). integer(158). integer(159). integer(160).
integer(311). integer(312). integer(313). integer(314). integer(315). integer(316). integer(317). integer(318). integer(319). integer(320).
integer(1511). integer(1512). integer(1513). integer(1514). integer(1515). integer(1516). integer(1517). integer(1518). integer(1519). integer(1520).
integer(1531). integer(1532). integer(1533). integer(1534). integer(1535). integer(1536). integer(1537). integer(1538). integer(1539). integer(1540).
integer(1721). integer(1722). integer(1723). integer(1724). integer(1725). integer(1726). integer(1727). integer(1728). integer(1729). integer(1730).
integer(2281). integer(2282). integer(2283). integer(2284). integer(2285). integer(2286). integer(2287). integer(2288). integer(2289). integer(2290).
integer(7001). integer(7002). integer(7003). integer(7004). integer(7005). integer(7006). integer(7007). integer(7008). integer(7009). integer(7010).
succ(31,32). succ(32,33). succ(33,34). succ(34,35). succ(35,36).
succ(86,87). succ(87,88). succ(88,89). succ(89,90). succ(90,91).
succ(126,127). succ(127,128). succ(128,129). succ(129,130). succ(130,131).
succ(146,147). succ(147,148). succ(148,149). succ(149,150). succ(150,151).
succ(151,152). succ(152,153). succ(153,154). succ(154,155). succ(155,156).
succ(166,167). succ(167,168). succ(168,169). succ(169,170). succ(170,171).
succ(311,312). succ(312,313). succ(313,314). succ(314,315). succ(315,316).
succ(1186,1187). succ(1187,1188). succ(1188,1189). succ(1189,1190). succ(1190,1191).
succ(1511,1512). succ(1512,1513). succ(1513,1514). succ(1514,1515). succ(1515,1516).
succ(1531,1532). succ(1532,1533). succ(1533,1534). succ(1534,1535). succ(1535,1536).
succ(1666,1667). succ(1667,1668). succ(1668,1669). succ(1669,1670). succ(1670,1671).
succ(1721,1722). succ(1722,1723). succ(1723,1724). succ(1724,1725). succ(1725,1726).
succ(2281,2282). succ(2282,2283). succ(2283,2284). succ(2284,2285). succ(2285,2286).
succ(2886,2887). succ(2887,2888). succ(2888,2889). succ(2889,2890). succ(2890,2891).
succ(4006,4007). succ(4007,4008). succ(4008,4009). succ(4009,4010). succ(4010,4011).
succ(6996,6997). succ(6997,6998). succ(6998,6999). succ(6999,7000). succ(7000,7001).
succ(7001,7002). succ(7002,7003). succ(7003,7004). succ(7004,7005). succ(7005,7006).
succ(7486,7487). succ(7487,7488). succ(7488,7489). succ(7489,7490). succ(7490,7491).
is_prime(31). is_prime(37). is_prime(41). is_prime(43). is_prime(47). is_prime(53). is_prime(59). is_prime(61). is_prime(67). is_prime(71).
is_prime(127). is_prime(131). is_prime(137). is_prime(139). is_prime(149). is_prime(151). is_prime(157). is_prime(163). is_prime(167). is_prime(173).
is_prime(353). is_prime(359). is_prime(367). is_prime(373). is_prime(379). is_prime(383). is_prime(389). is_prime(397). is_prime(401). is_prime(409).
is_prime(2293). is_prime(2297). is_prime(2309). is_prime(2311). is_prime(2333). is_prime(2339). is_prime(2341). is_prime(2347). is_prime(2351). is_prime(2357).
is_prime(7001). is_prime(7013). is_prime(7019). is_prime(7027). is_prime(7039). is_prime(7043). is_prime(7057). is_prime(7069). is_prime(7079). is_prime(7103).
is_composite(146). is_composite(147). is_composite(148). is_composite(150). is_composite(152). is_composite(153). is_composite(154). is_composite(155). is_composite(156). is_composite(158).
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