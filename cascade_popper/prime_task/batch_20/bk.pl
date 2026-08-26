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

integer(1511). integer(1512). integer(1513). integer(1514). integer(1515). integer(1516). integer(1517). integer(1518). integer(1519). integer(1520).
integer(3331). integer(3332). integer(3333). integer(3334). integer(3335). integer(3336). integer(3337). integer(3338). integer(3339). integer(3340).
integer(5081). integer(5082). integer(5083). integer(5084). integer(5085). integer(5086). integer(5087). integer(5088). integer(5089). integer(5090).
integer(6011). integer(6012). integer(6013). integer(6014). integer(6015). integer(6016). integer(6017). integer(6018). integer(6019). integer(6020).
succ(1096,1097). succ(1097,1098). succ(1098,1099). succ(1099,1100). succ(1100,1101).
succ(1511,1512). succ(1512,1513). succ(1513,1514). succ(1514,1515). succ(1515,1516).
succ(2556,2557). succ(2557,2558). succ(2558,2559). succ(2559,2560). succ(2560,2561).
succ(3331,3332). succ(3332,3333). succ(3333,3334). succ(3334,3335). succ(3335,3336).
succ(3876,3877). succ(3877,3878). succ(3878,3879). succ(3879,3880). succ(3880,3881).
succ(3966,3967). succ(3967,3968). succ(3968,3969). succ(3969,3970). succ(3970,3971).
succ(5081,5082). succ(5082,5083). succ(5083,5084). succ(5084,5085). succ(5085,5086).
succ(5086,5087). succ(5087,5088). succ(5088,5089). succ(5089,5090). succ(5090,5091).
succ(6011,6012). succ(6012,6013). succ(6013,6014). succ(6014,6015). succ(6015,6016).
succ(6336,6337). succ(6337,6338). succ(6338,6339). succ(6339,6340). succ(6340,6341).
succ(6906,6907). succ(6907,6908). succ(6908,6909). succ(6909,6910). succ(6910,6911).
is_prime(5189). is_prime(5197). is_prime(5209). is_prime(5227). is_prime(5231). is_prime(5233). is_prime(5237). is_prime(5261). is_prime(5273). is_prime(5279).
is_composite(294). is_composite(295). is_composite(296). is_composite(297). is_composite(298). is_composite(299). is_composite(300). is_composite(301). is_composite(302). is_composite(303).
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