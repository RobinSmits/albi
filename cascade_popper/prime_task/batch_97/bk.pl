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

integer(491). integer(492). integer(493). integer(494). integer(495). integer(496). integer(497). integer(498). integer(499). integer(500).
integer(661). integer(662). integer(663). integer(664). integer(665). integer(666). integer(667). integer(668). integer(669). integer(670).
integer(691). integer(692). integer(693). integer(694). integer(695). integer(696). integer(697). integer(698). integer(699). integer(700).
integer(761). integer(762). integer(763). integer(764). integer(765). integer(766). integer(767). integer(768). integer(769). integer(770).
integer(1031). integer(1032). integer(1033). integer(1034). integer(1035). integer(1036). integer(1037). integer(1038). integer(1039). integer(1040).
integer(1321). integer(1322). integer(1323). integer(1324). integer(1325). integer(1326). integer(1327). integer(1328). integer(1329). integer(1330).
integer(1901). integer(1902). integer(1903). integer(1904). integer(1905). integer(1906). integer(1907). integer(1908). integer(1909). integer(1910).
integer(3041). integer(3042). integer(3043). integer(3044). integer(3045). integer(3046). integer(3047). integer(3048). integer(3049). integer(3050).
integer(3671). integer(3672). integer(3673). integer(3674). integer(3675). integer(3676). integer(3677). integer(3678). integer(3679). integer(3680).
integer(5051). integer(5052). integer(5053). integer(5054). integer(5055). integer(5056). integer(5057). integer(5058). integer(5059). integer(5060).
integer(5581). integer(5582). integer(5583). integer(5584). integer(5585). integer(5586). integer(5587). integer(5588). integer(5589). integer(5590).
integer(5591). integer(5592). integer(5593). integer(5594). integer(5595). integer(5596). integer(5597). integer(5598). integer(5599). integer(5600).
integer(5651). integer(5652). integer(5653). integer(5654). integer(5655). integer(5656). integer(5657). integer(5658). integer(5659). integer(5660).
succ(126,127). succ(127,128). succ(128,129). succ(129,130). succ(130,131).
succ(491,492). succ(492,493). succ(493,494). succ(494,495). succ(495,496).
succ(646,647). succ(647,648). succ(648,649). succ(649,650). succ(650,651).
succ(661,662). succ(662,663). succ(663,664). succ(664,665). succ(665,666).
succ(691,692). succ(692,693). succ(693,694). succ(694,695). succ(695,696).
succ(761,762). succ(762,763). succ(763,764). succ(764,765). succ(765,766).
succ(1031,1032). succ(1032,1033). succ(1033,1034). succ(1034,1035). succ(1035,1036).
succ(1321,1322). succ(1322,1323). succ(1323,1324). succ(1324,1325). succ(1325,1326).
succ(1326,1327). succ(1327,1328). succ(1328,1329). succ(1329,1330). succ(1330,1331).
succ(1901,1902). succ(1902,1903). succ(1903,1904). succ(1904,1905). succ(1905,1906).
succ(3041,3042). succ(3042,3043). succ(3043,3044). succ(3044,3045). succ(3045,3046).
succ(3671,3672). succ(3672,3673). succ(3673,3674). succ(3674,3675). succ(3675,3676).
succ(3916,3917). succ(3917,3918). succ(3918,3919). succ(3919,3920). succ(3920,3921).
succ(5051,5052). succ(5052,5053). succ(5053,5054). succ(5054,5055). succ(5055,5056).
succ(5581,5582). succ(5582,5583). succ(5583,5584). succ(5584,5585). succ(5585,5586).
succ(5591,5592). succ(5592,5593). succ(5593,5594). succ(5594,5595). succ(5595,5596).
succ(5651,5652). succ(5652,5653). succ(5653,5654). succ(5654,5655). succ(5655,5656).
succ(7866,7867). succ(7867,7868). succ(7868,7869). succ(7869,7870). succ(7870,7871).
is_prime(127). is_prime(131). is_prime(137). is_prime(139). is_prime(149). is_prime(151). is_prime(157). is_prime(163). is_prime(167). is_prime(173).
is_prime(661). is_prime(673). is_prime(677). is_prime(683). is_prime(691). is_prime(701). is_prime(709). is_prime(719). is_prime(727). is_prime(733).
is_prime(1019). is_prime(1021). is_prime(1031). is_prime(1033). is_prime(1039). is_prime(1049). is_prime(1051). is_prime(1061). is_prime(1063). is_prime(1069).
is_prime(1901). is_prime(1907). is_prime(1913). is_prime(1931). is_prime(1933). is_prime(1949). is_prime(1951). is_prime(1973). is_prime(1979). is_prime(1987).
is_prime(3659). is_prime(3671). is_prime(3673). is_prime(3677). is_prime(3691). is_prime(3697). is_prime(3701). is_prime(3709). is_prime(3719). is_prime(3727).
is_prime(5953). is_prime(5981). is_prime(5987). is_prime(6007). is_prime(6011). is_prime(6029). is_prime(6037). is_prime(6043). is_prime(6047). is_prime(6053).
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