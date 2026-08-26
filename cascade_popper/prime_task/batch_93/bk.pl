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
integer(181). integer(182). integer(183). integer(184). integer(185). integer(186). integer(187). integer(188). integer(189). integer(190).
integer(281). integer(282). integer(283). integer(284). integer(285). integer(286). integer(287). integer(288). integer(289). integer(290).
integer(401). integer(402). integer(403). integer(404). integer(405). integer(406). integer(407). integer(408). integer(409). integer(410).
integer(2131). integer(2132). integer(2133). integer(2134). integer(2135). integer(2136). integer(2137). integer(2138). integer(2139). integer(2140).
integer(2621). integer(2622). integer(2623). integer(2624). integer(2625). integer(2626). integer(2627). integer(2628). integer(2629). integer(2630).
integer(5011). integer(5012). integer(5013). integer(5014). integer(5015). integer(5016). integer(5017). integer(5018). integer(5019). integer(5020).
integer(5021). integer(5022). integer(5023). integer(5024). integer(5025). integer(5026). integer(5027). integer(5028). integer(5029). integer(5030).
integer(5821). integer(5822). integer(5823). integer(5824). integer(5825). integer(5826). integer(5827). integer(5828). integer(5829). integer(5830).
integer(7411). integer(7412). integer(7413). integer(7414). integer(7415). integer(7416). integer(7417). integer(7418). integer(7419). integer(7420).
succ(11,12). succ(12,13). succ(13,14). succ(14,15). succ(15,16).
succ(16,17). succ(17,18). succ(18,19). succ(19,20). succ(20,21).
succ(181,182). succ(182,183). succ(183,184). succ(184,185). succ(185,186).
succ(231,232). succ(232,233). succ(233,234). succ(234,235). succ(235,236).
succ(281,282). succ(282,283). succ(283,284). succ(284,285). succ(285,286).
succ(401,402). succ(402,403). succ(403,404). succ(404,405). succ(405,406).
succ(2131,2132). succ(2132,2133). succ(2133,2134). succ(2134,2135). succ(2135,2136).
succ(2136,2137). succ(2137,2138). succ(2138,2139). succ(2139,2140). succ(2140,2141).
succ(2621,2622). succ(2622,2623). succ(2623,2624). succ(2624,2625). succ(2625,2626).
succ(2686,2687). succ(2687,2688). succ(2688,2689). succ(2689,2690). succ(2690,2691).
succ(5011,5012). succ(5012,5013). succ(5013,5014). succ(5014,5015). succ(5015,5016).
succ(5021,5022). succ(5022,5023). succ(5023,5024). succ(5024,5025). succ(5025,5026).
succ(5821,5822). succ(5822,5823). succ(5823,5824). succ(5824,5825). succ(5825,5826).
succ(7411,7412). succ(7412,7413). succ(7413,7414). succ(7414,7415). succ(7415,7416).
is_prime(233). is_prime(239). is_prime(241). is_prime(251). is_prime(257). is_prime(263). is_prime(269). is_prime(271). is_prime(277). is_prime(281).
is_prime(283). is_prime(293). is_prime(307). is_prime(311). is_prime(313). is_prime(317). is_prime(331). is_prime(337). is_prime(347). is_prime(349).
is_prime(419). is_prime(421). is_prime(431). is_prime(433). is_prime(439). is_prime(443). is_prime(449). is_prime(457). is_prime(461). is_prime(463).
is_prime(2131). is_prime(2137). is_prime(2141). is_prime(2143). is_prime(2153). is_prime(2161). is_prime(2179). is_prime(2203). is_prime(2207). is_prime(2213).
is_prime(2621). is_prime(2633). is_prime(2647). is_prime(2657). is_prime(2659). is_prime(2663). is_prime(2671). is_prime(2677). is_prime(2683). is_prime(2687).
is_prime(2689). is_prime(2693). is_prime(2699). is_prime(2707). is_prime(2711). is_prime(2713). is_prime(2719). is_prime(2729). is_prime(2731). is_prime(2741).
is_composite(232). is_composite(234). is_composite(235). is_composite(236). is_composite(237). is_composite(238). is_composite(240). is_composite(242). is_composite(243). is_composite(244).
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