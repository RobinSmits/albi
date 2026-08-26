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
integer(431). integer(432). integer(433). integer(434). integer(435). integer(436). integer(437). integer(438). integer(439). integer(440).
integer(631). integer(632). integer(633). integer(634). integer(635). integer(636). integer(637). integer(638). integer(639). integer(640).
integer(1361). integer(1362). integer(1363). integer(1364). integer(1365). integer(1366). integer(1367). integer(1368). integer(1369). integer(1370).
integer(2081). integer(2082). integer(2083). integer(2084). integer(2085). integer(2086). integer(2087). integer(2088). integer(2089). integer(2090).
integer(5231). integer(5232). integer(5233). integer(5234). integer(5235). integer(5236). integer(5237). integer(5238). integer(5239). integer(5240).
integer(5801). integer(5802). integer(5803). integer(5804). integer(5805). integer(5806). integer(5807). integer(5808). integer(5809). integer(5810).
succ(11,12). succ(12,13). succ(13,14). succ(14,15). succ(15,16).
succ(181,182). succ(182,183). succ(183,184). succ(184,185). succ(185,186).
succ(191,192). succ(192,193). succ(193,194). succ(194,195). succ(195,196).
succ(431,432). succ(432,433). succ(433,434). succ(434,435). succ(435,436).
succ(556,557). succ(557,558). succ(558,559). succ(559,560). succ(560,561).
succ(616,617). succ(617,618). succ(618,619). succ(619,620). succ(620,621).
succ(631,632). succ(632,633). succ(633,634). succ(634,635). succ(635,636).
succ(876,877). succ(877,878). succ(878,879). succ(879,880). succ(880,881).
succ(1326,1327). succ(1327,1328). succ(1328,1329). succ(1329,1330). succ(1330,1331).
succ(1361,1362). succ(1362,1363). succ(1363,1364). succ(1364,1365). succ(1365,1366).
succ(2016,2017). succ(2017,2018). succ(2018,2019). succ(2019,2020). succ(2020,2021).
succ(2081,2082). succ(2082,2083). succ(2083,2084). succ(2084,2085). succ(2085,2086).
succ(2086,2087). succ(2087,2088). succ(2088,2089). succ(2089,2090). succ(2090,2091).
succ(4396,4397). succ(4397,4398). succ(4398,4399). succ(4399,4400). succ(4400,4401).
succ(5226,5227). succ(5227,5228). succ(5228,5229). succ(5229,5230). succ(5230,5231).
succ(5231,5232). succ(5232,5233). succ(5233,5234). succ(5234,5235). succ(5235,5236).
succ(5801,5802). succ(5802,5803). succ(5803,5804). succ(5804,5805). succ(5805,5806).
succ(5806,5807). succ(5807,5808). succ(5808,5809). succ(5809,5810). succ(5810,5811).
is_prime(877). is_prime(881). is_prime(883). is_prime(887). is_prime(907). is_prime(911). is_prime(919). is_prime(929). is_prime(937). is_prime(941).
is_prime(2689). is_prime(2693). is_prime(2699). is_prime(2707). is_prime(2711). is_prime(2713). is_prime(2719). is_prime(2729). is_prime(2731). is_prime(2741).
is_prime(5801). is_prime(5807). is_prime(5813). is_prime(5821). is_prime(5827). is_prime(5839). is_prime(5843). is_prime(5849). is_prime(5851). is_prime(5857).
is_composite(184). is_composite(185). is_composite(186). is_composite(187). is_composite(188). is_composite(189). is_composite(190). is_composite(192). is_composite(194). is_composite(195).
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