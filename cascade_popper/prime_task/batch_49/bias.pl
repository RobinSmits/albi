%% ============================================================
%% BIAS: prime(X, Y) - Y is the next prime after X
%% Defines the hypothesis search space for Popper
%% ============================================================

%% --- Target predicate ---
head_pred(prime, 2).

%% --- Body predicates available for hypothesis construction ---
body_pred(is_prime, 1).
body_pred(is_composite, 1).
body_pred(integer, 1).
body_pred(succ, 2).
body_pred(greater_than, 2).
body_pred(less_than, 2).
body_pred(geq, 2).
body_pred(leq, 2).
body_pred(plus, 3).
body_pred(minus, 3).
body_pred(times, 3).
body_pred(modulo, 3).
body_pred(int_div, 3).
body_pred(divides, 2).
body_pred(not_divides, 2).
body_pred(even, 1).
body_pred(odd, 1).
body_pred(one, 1).
body_pred(two, 1).
body_pred(no_prime_between, 2).

%% --- Type declarations ---
type(prime, (int, int)).
type(is_prime, (int,)).
type(is_composite, (int,)).
type(integer, (int,)).
type(succ, (int, int)).
type(greater_than, (int, int)).
type(less_than, (int, int)).
type(geq, (int, int)).
type(leq, (int, int)).
type(plus, (int, int, int)).
type(minus, (int, int, int)).
type(times, (int, int, int)).
type(modulo, (int, int, int)).
type(int_div, (int, int, int)).
type(divides, (int, int)).
type(not_divides, (int, int)).
type(even, (int,)).
type(odd, (int,)).
type(one, (int,)).
type(two, (int,)).
type(no_prime_between, (int, int)).

%% --- Direction (input/output modes) ---
direction(prime, (in, out)).
direction(is_prime, (in,)).
direction(is_composite, (in,)).
direction(integer, (in,)).
direction(succ, (in, out)).
direction(greater_than, (in, in)).
direction(less_than, (in, in)).
direction(geq, (in, in)).
direction(leq, (in, in)).
direction(plus, (in, in, out)).
direction(minus, (in, in, out)).
direction(times, (in, in, out)).
direction(modulo, (in, in, out)).
direction(int_div, (in, in, out)).
direction(divides, (in, in)).
direction(not_divides, (in, in)).
direction(even, (in,)).
direction(odd, (in,)).
direction(one, (out,)).
direction(two, (out,)).
direction(no_prime_between, (in, in)).

%% --- Hypothesis space constraints ---
max_vars(6).
max_body(6).
max_clauses(3).

%% --- Allow recursion (essential for stepping through composites) ---
allow_recursion.
