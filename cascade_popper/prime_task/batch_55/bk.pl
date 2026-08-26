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
integer(1531). integer(1532). integer(1533). integer(1534). integer(1535). integer(1536). integer(1537). integer(1538). integer(1539). integer(1540).
integer(1861). integer(1862). integer(1863). integer(1864). integer(1865). integer(1866). integer(1867). integer(1868). integer(1869). integer(1870).
integer(2621). integer(2622). integer(2623). integer(2624). integer(2625). integer(2626). integer(2627). integer(2628). integer(2629). integer(2630).
integer(3491). integer(3492). integer(3493). integer(3494). integer(3495). integer(3496). integer(3497). integer(3498). integer(3499). integer(3500).
integer(4831). integer(4832). integer(4833). integer(4834). integer(4835). integer(4836). integer(4837). integer(4838). integer(4839). integer(4840).
integer(4861). integer(4862). integer(4863). integer(4864). integer(4865). integer(4866). integer(4867). integer(4868). integer(4869). integer(4870).
integer(5791). integer(5792). integer(5793). integer(5794). integer(5795). integer(5796). integer(5797). integer(5798). integer(5799). integer(5800).
integer(5801). integer(5802). integer(5803). integer(5804). integer(5805). integer(5806). integer(5807). integer(5808). integer(5809). integer(5810).
integer(6131). integer(6132). integer(6133). integer(6134). integer(6135). integer(6136). integer(6137). integer(6138). integer(6139). integer(6140).
integer(6871). integer(6872). integer(6873). integer(6874). integer(6875). integer(6876). integer(6877). integer(6878). integer(6879). integer(6880).
succ(11,12). succ(12,13). succ(13,14). succ(14,15). succ(15,16).
succ(181,182). succ(182,183). succ(183,184). succ(184,185). succ(185,186).
succ(236,237). succ(237,238). succ(238,239). succ(239,240). succ(240,241).
succ(576,577). succ(577,578). succ(578,579). succ(579,580). succ(580,581).
succ(586,587). succ(587,588). succ(588,589). succ(589,590). succ(590,591).
succ(1096,1097). succ(1097,1098). succ(1098,1099). succ(1099,1100). succ(1100,1101).
succ(1326,1327). succ(1327,1328). succ(1328,1329). succ(1329,1330). succ(1330,1331).
succ(1531,1532). succ(1532,1533). succ(1533,1534). succ(1534,1535). succ(1535,1536).
succ(1861,1862). succ(1862,1863). succ(1863,1864). succ(1864,1865). succ(1865,1866).
succ(2466,2467). succ(2467,2468). succ(2468,2469). succ(2469,2470). succ(2470,2471).
succ(2476,2477). succ(2477,2478). succ(2478,2479). succ(2479,2480). succ(2480,2481).
succ(2621,2622). succ(2622,2623). succ(2623,2624). succ(2624,2625). succ(2625,2626).
succ(3066,3067). succ(3067,3068). succ(3068,3069). succ(3069,3070). succ(3070,3071).
succ(3491,3492). succ(3492,3493). succ(3493,3494). succ(3494,3495). succ(3495,3496).
succ(4831,4832). succ(4832,4833). succ(4833,4834). succ(4834,4835). succ(4835,4836).
succ(4861,4862). succ(4862,4863). succ(4863,4864). succ(4864,4865). succ(4865,4866).
succ(5791,5792). succ(5792,5793). succ(5793,5794). succ(5794,5795). succ(5795,5796).
succ(5801,5802). succ(5802,5803). succ(5803,5804). succ(5804,5805). succ(5805,5806).
succ(6131,6132). succ(6132,6133). succ(6133,6134). succ(6134,6135). succ(6135,6136).
succ(6871,6872). succ(6872,6873). succ(6873,6874). succ(6874,6875). succ(6875,6876).
is_prime(73). is_prime(79). is_prime(83). is_prime(89). is_prime(97). is_prime(101). is_prime(103). is_prime(107). is_prime(109). is_prime(113).
is_prime(353). is_prime(359). is_prime(367). is_prime(373). is_prime(379). is_prime(383). is_prime(389). is_prime(397). is_prime(401). is_prime(409).
is_prime(2621). is_prime(2633). is_prime(2647). is_prime(2657). is_prime(2659). is_prime(2663). is_prime(2671). is_prime(2677). is_prime(2683). is_prime(2687).
is_prime(4861). is_prime(4871). is_prime(4877). is_prime(4889). is_prime(4903). is_prime(4909). is_prime(4919). is_prime(4931). is_prime(4933). is_prime(4937).
is_prime(5801). is_prime(5807). is_prime(5813). is_prime(5821). is_prime(5827). is_prime(5839). is_prime(5843). is_prime(5849). is_prime(5851). is_prime(5857).
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