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

integer(521). integer(522). integer(523). integer(524). integer(525). integer(526). integer(527). integer(528). integer(529). integer(530).
integer(3011). integer(3012). integer(3013). integer(3014). integer(3015). integer(3016). integer(3017). integer(3018). integer(3019). integer(3020).
integer(4091). integer(4092). integer(4093). integer(4094). integer(4095). integer(4096). integer(4097). integer(4098). integer(4099). integer(4100).
integer(4421). integer(4422). integer(4423). integer(4424). integer(4425). integer(4426). integer(4427). integer(4428). integer(4429). integer(4430).
integer(4481). integer(4482). integer(4483). integer(4484). integer(4485). integer(4486). integer(4487). integer(4488). integer(4489). integer(4490).
integer(4861). integer(4862). integer(4863). integer(4864). integer(4865). integer(4866). integer(4867). integer(4868). integer(4869). integer(4870).
integer(4871). integer(4872). integer(4873). integer(4874). integer(4875). integer(4876). integer(4877). integer(4878). integer(4879). integer(4880).
integer(6691). integer(6692). integer(6693). integer(6694). integer(6695). integer(6696). integer(6697). integer(6698). integer(6699). integer(6700).
integer(7681). integer(7682). integer(7683). integer(7684). integer(7685). integer(7686). integer(7687). integer(7688). integer(7689). integer(7690).
succ(81,82). succ(82,83). succ(83,84). succ(84,85). succ(85,86).
succ(521,522). succ(522,523). succ(523,524). succ(524,525). succ(525,526).
succ(3011,3012). succ(3012,3013). succ(3013,3014). succ(3014,3015). succ(3015,3016).
succ(3556,3557). succ(3557,3558). succ(3558,3559). succ(3559,3560). succ(3560,3561).
succ(4091,4092). succ(4092,4093). succ(4093,4094). succ(4094,4095). succ(4095,4096).
succ(4421,4422). succ(4422,4423). succ(4423,4424). succ(4424,4425). succ(4425,4426).
succ(4481,4482). succ(4482,4483). succ(4483,4484). succ(4484,4485). succ(4485,4486).
succ(4861,4862). succ(4862,4863). succ(4863,4864). succ(4864,4865). succ(4865,4866).
succ(4871,4872). succ(4872,4873). succ(4873,4874). succ(4874,4875). succ(4875,4876).
succ(6691,6692). succ(6692,6693). succ(6693,6694). succ(6694,6695). succ(6695,6696).
succ(6736,6737). succ(6737,6738). succ(6738,6739). succ(6739,6740). succ(6740,6741).
succ(7681,7682). succ(7682,7683). succ(7683,7684). succ(7684,7685). succ(7685,7686).
succ(7686,7687). succ(7687,7688). succ(7688,7689). succ(7689,7690). succ(7690,7691).
is_prime(4421). is_prime(4423). is_prime(4441). is_prime(4447). is_prime(4451). is_prime(4457). is_prime(4463). is_prime(4481). is_prime(4483). is_prime(4493).
is_prime(4861). is_prime(4871). is_prime(4877). is_prime(4889). is_prime(4903). is_prime(4909). is_prime(4919). is_prime(4931). is_prime(4933). is_prime(4937).
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