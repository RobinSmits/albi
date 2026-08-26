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

integer(101). integer(102). integer(103). integer(104). integer(105). integer(106). integer(107). integer(108). integer(109). integer(110).
integer(331). integer(332). integer(333). integer(334). integer(335). integer(336). integer(337). integer(338). integer(339). integer(340).
integer(751). integer(752). integer(753). integer(754). integer(755). integer(756). integer(757). integer(758). integer(759). integer(760).
integer(881). integer(882). integer(883). integer(884). integer(885). integer(886). integer(887). integer(888). integer(889). integer(890).
integer(991). integer(992). integer(993). integer(994). integer(995). integer(996). integer(997). integer(998). integer(999). integer(1000).
integer(2341). integer(2342). integer(2343). integer(2344). integer(2345). integer(2346). integer(2347). integer(2348). integer(2349). integer(2350).
integer(5081). integer(5082). integer(5083). integer(5084). integer(5085). integer(5086). integer(5087). integer(5088). integer(5089). integer(5090).
integer(6961). integer(6962). integer(6963). integer(6964). integer(6965). integer(6966). integer(6967). integer(6968). integer(6969). integer(6970).
succ(101,102). succ(102,103). succ(103,104). succ(104,105). succ(105,106).
succ(226,227). succ(227,228). succ(228,229). succ(229,230). succ(230,231).
succ(316,317). succ(317,318). succ(318,319). succ(319,320). succ(320,321).
succ(331,332). succ(332,333). succ(333,334). succ(334,335). succ(335,336).
succ(576,577). succ(577,578). succ(578,579). succ(579,580). succ(580,581).
succ(586,587). succ(587,588). succ(588,589). succ(589,590). succ(590,591).
succ(751,752). succ(752,753). succ(753,754). succ(754,755). succ(755,756).
succ(756,757). succ(757,758). succ(758,759). succ(759,760). succ(760,761).
succ(881,882). succ(882,883). succ(883,884). succ(884,885). succ(885,886).
succ(886,887). succ(887,888). succ(888,889). succ(889,890). succ(890,891).
succ(991,992). succ(992,993). succ(993,994). succ(994,995). succ(995,996).
succ(996,997). succ(997,998). succ(998,999). succ(999,1000). succ(1000,1001).
succ(1116,1117). succ(1117,1118). succ(1118,1119). succ(1119,1120). succ(1120,1121).
succ(2341,2342). succ(2342,2343). succ(2343,2344). succ(2344,2345). succ(2345,2346).
succ(2346,2347). succ(2347,2348). succ(2348,2349). succ(2349,2350). succ(2350,2351).
succ(4816,4817). succ(4817,4818). succ(4818,4819). succ(4819,4820). succ(4820,4821).
succ(5076,5077). succ(5077,5078). succ(5078,5079). succ(5079,5080). succ(5080,5081).
succ(5081,5082). succ(5082,5083). succ(5083,5084). succ(5084,5085). succ(5085,5086).
succ(6961,6962). succ(6962,6963). succ(6963,6964). succ(6964,6965). succ(6965,6966).
succ(7716,7717). succ(7717,7718). succ(7718,7719). succ(7719,7720). succ(7720,7721).
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