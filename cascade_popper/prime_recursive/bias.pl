%% ============================================================
%% BIAS: f(N, P) - P is the N-th prime number
%%
%% UNRESTRICTED: Recursion allowed, multiple clauses allowed.
%% The ILP should discover something like:
%%   f(1, 2).
%%   f(N, P) :- succ(N1, N), f(N1, Q), next_prime(Q, P).
%% ============================================================

%% --- Search Bounds ---
max_body(5).
max_vars(6).
max_clauses(3).
enable_recursion.

%% --- Target ---
head_pred(f, 2).

%% --- Prime-related predicates ---
body_pred(is_prime, 1).
body_pred(next_prime, 2).
body_pred(prime_between, 3).

%% --- Arithmetic ---
body_pred(succ, 2).
body_pred(prec, 2).
body_pred(add, 3).
body_pred(sub, 3).
body_pred(inc, 2).
body_pred(dec, 2).
body_pred(double, 2).
body_pred(modulo, 3).

%% --- Comparison ---
body_pred(greater_than, 2).
body_pred(less_than, 2).
body_pred(geq, 2).

%% --- Constants ---
body_pred(one, 1).
body_pred(two, 1).
body_pred(zero, 1).
body_pred(num, 1).

%% --- Types ---
type(f, (int, int)).
type(is_prime, (int,)).
type(next_prime, (int, int)).
type(prime_between, (int, int, int)).
type(succ, (int, int)).
type(prec, (int, int)).
type(add, (int, int, int)).
type(sub, (int, int, int)).
type(inc, (int, int)).
type(dec, (int, int)).
type(double, (int, int)).
type(modulo, (int, int, int)).
type(greater_than, (int, int)).
type(less_than, (int, int)).
type(geq, (int, int)).
type(one, (int,)).
type(two, (int,)).
type(zero, (int,)).
type(num, (int,)).

%% --- Directions ---
direction(f, (in, out)).
direction(is_prime, (in,)).
direction(next_prime, (in, out)).
direction(prime_between, (in, in, out)).
direction(succ, (in, out)).
direction(prec, (in, out)).
direction(add, (in, in, out)).
direction(sub, (in, in, out)).
direction(inc, (in, out)).
direction(dec, (in, out)).
direction(double, (in, out)).
direction(modulo, (in, in, out)).
direction(greater_than, (in, in)).
direction(less_than, (in, in)).
direction(geq, (in, in)).
direction(one, (out,)).
direction(two, (out,)).
direction(zero, (out,)).
direction(num, (in,)).

