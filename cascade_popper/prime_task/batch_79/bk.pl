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

integer(41). integer(42). integer(43). integer(44). integer(45). integer(46). integer(47). integer(48). integer(49). integer(50).
integer(101). integer(102). integer(103). integer(104). integer(105). integer(106). integer(107). integer(108). integer(109). integer(110).
integer(1531). integer(1532). integer(1533). integer(1534). integer(1535). integer(1536). integer(1537). integer(1538). integer(1539). integer(1540).
integer(1741). integer(1742). integer(1743). integer(1744). integer(1745). integer(1746). integer(1747). integer(1748). integer(1749). integer(1750).
integer(2591). integer(2592). integer(2593). integer(2594). integer(2595). integer(2596). integer(2597). integer(2598). integer(2599). integer(2600).
integer(5281). integer(5282). integer(5283). integer(5284). integer(5285). integer(5286). integer(5287). integer(5288). integer(5289). integer(5290).
integer(5351). integer(5352). integer(5353). integer(5354). integer(5355). integer(5356). integer(5357). integer(5358). integer(5359). integer(5360).
integer(5381). integer(5382). integer(5383). integer(5384). integer(5385). integer(5386). integer(5387). integer(5388). integer(5389). integer(5390).
succ(41,42). succ(42,43). succ(43,44). succ(44,45). succ(45,46).
succ(46,47). succ(47,48). succ(48,49). succ(49,50). succ(50,51).
succ(66,67). succ(67,68). succ(68,69). succ(69,70). succ(70,71).
succ(96,97). succ(97,98). succ(98,99). succ(99,100). succ(100,101).
succ(101,102). succ(102,103). succ(103,104). succ(104,105). succ(105,106).
succ(196,197). succ(197,198). succ(198,199). succ(199,200). succ(200,201).
succ(226,227). succ(227,228). succ(228,229). succ(229,230). succ(230,231).
succ(466,467). succ(467,468). succ(468,469). succ(469,470). succ(470,471).
succ(556,557). succ(557,558). succ(558,559). succ(559,560). succ(560,561).
succ(576,577). succ(577,578). succ(578,579). succ(579,580). succ(580,581).
succ(1531,1532). succ(1532,1533). succ(1533,1534). succ(1534,1535). succ(1535,1536).
succ(1741,1742). succ(1742,1743). succ(1743,1744). succ(1744,1745). succ(1745,1746).
succ(2591,2592). succ(2592,2593). succ(2593,2594). succ(2594,2595). succ(2595,2596).
succ(5281,5282). succ(5282,5283). succ(5283,5284). succ(5284,5285). succ(5285,5286).
succ(5296,5297). succ(5297,5298). succ(5298,5299). succ(5299,5300). succ(5300,5301).
succ(5351,5352). succ(5352,5353). succ(5353,5354). succ(5354,5355). succ(5355,5356).
succ(5381,5382). succ(5382,5383). succ(5383,5384). succ(5384,5385). succ(5385,5386).
is_prime(73). is_prime(79). is_prime(83). is_prime(89). is_prime(97). is_prime(101). is_prime(103). is_prime(107). is_prime(109). is_prime(113).
is_prime(419). is_prime(421). is_prime(431). is_prime(433). is_prime(439). is_prime(443). is_prime(449). is_prime(457). is_prime(461). is_prime(463).
is_prime(467). is_prime(479). is_prime(487). is_prime(491). is_prime(499). is_prime(503). is_prime(509). is_prime(521). is_prime(523). is_prime(541).
is_prime(1523). is_prime(1531). is_prime(1543). is_prime(1549). is_prime(1553). is_prime(1559). is_prime(1567). is_prime(1571). is_prime(1579). is_prime(1583).
is_prime(1741). is_prime(1747). is_prime(1753). is_prime(1759). is_prime(1777). is_prime(1783). is_prime(1787). is_prime(1789). is_prime(1801). is_prime(1811).
is_prime(3083). is_prime(3089). is_prime(3109). is_prime(3119). is_prime(3121). is_prime(3137). is_prime(3163). is_prime(3167). is_prime(3169). is_prime(3181).
is_prime(5281). is_prime(5297). is_prime(5303). is_prime(5309). is_prime(5323). is_prime(5333). is_prime(5347). is_prime(5351). is_prime(5381). is_prime(5387).
is_composite(578). is_composite(579). is_composite(580). is_composite(581). is_composite(582). is_composite(583). is_composite(584). is_composite(585). is_composite(586). is_composite(588).
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