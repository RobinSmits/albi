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

integer(211). integer(212). integer(213). integer(214). integer(215). integer(216). integer(217). integer(218). integer(219). integer(220).
integer(251). integer(252). integer(253). integer(254). integer(255). integer(256). integer(257). integer(258). integer(259). integer(260).
integer(1811). integer(1812). integer(1813). integer(1814). integer(1815). integer(1816). integer(1817). integer(1818). integer(1819). integer(1820).
integer(3511). integer(3512). integer(3513). integer(3514). integer(3515). integer(3516). integer(3517). integer(3518). integer(3519). integer(3520).
integer(4051). integer(4052). integer(4053). integer(4054). integer(4055). integer(4056). integer(4057). integer(4058). integer(4059). integer(4060).
integer(4831). integer(4832). integer(4833). integer(4834). integer(4835). integer(4836). integer(4837). integer(4838). integer(4839). integer(4840).
integer(6551). integer(6552). integer(6553). integer(6554). integer(6555). integer(6556). integer(6557). integer(6558). integer(6559). integer(6560).
succ(211,212). succ(212,213). succ(213,214). succ(214,215). succ(215,216).
succ(251,252). succ(252,253). succ(253,254). succ(254,255). succ(255,256).
succ(606,607). succ(607,608). succ(608,609). succ(609,610). succ(610,611).
succ(646,647). succ(647,648). succ(648,649). succ(649,650). succ(650,651).
succ(1811,1812). succ(1812,1813). succ(1813,1814). succ(1814,1815). succ(1815,1816).
succ(2896,2897). succ(2897,2898). succ(2898,2899). succ(2899,2900). succ(2900,2901).
succ(3511,3512). succ(3512,3513). succ(3513,3514). succ(3514,3515). succ(3515,3516).
succ(3516,3517). succ(3517,3518). succ(3518,3519). succ(3519,3520). succ(3520,3521).
succ(4051,4052). succ(4052,4053). succ(4053,4054). succ(4054,4055). succ(4055,4056).
succ(4056,4057). succ(4057,4058). succ(4058,4059). succ(4059,4060). succ(4060,4061).
succ(4816,4817). succ(4817,4818). succ(4818,4819). succ(4819,4820). succ(4820,4821).
succ(4831,4832). succ(4832,4833). succ(4833,4834). succ(4834,4835). succ(4835,4836).
succ(6551,6552). succ(6552,6553). succ(6553,6554). succ(6554,6555). succ(6555,6556).
succ(6976,6977). succ(6977,6978). succ(6978,6979). succ(6979,6980). succ(6980,6981).
is_prime(607). is_prime(613). is_prime(617). is_prime(619). is_prime(631). is_prime(641). is_prime(643). is_prime(647). is_prime(653). is_prime(659).
is_prime(3517). is_prime(3527). is_prime(3529). is_prime(3533). is_prime(3539). is_prime(3541). is_prime(3547). is_prime(3557). is_prime(3559). is_prime(3571).
is_composite(20). is_composite(21). is_composite(22). is_composite(24). is_composite(25). is_composite(26). is_composite(27). is_composite(28). is_composite(30). is_composite(32).
is_composite(1812). is_composite(1813). is_composite(1814). is_composite(1815). is_composite(1816). is_composite(1817). is_composite(1818). is_composite(1819). is_composite(1820). is_composite(1821).
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