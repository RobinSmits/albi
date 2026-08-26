%% ============================================================
%% BIAS: f(N, P) - CLOSED-FORM formula for N-th prime
%%
%% CONSTRAINTS:
%%   - NO recursion allowed (no allow_recursion)
%%   - NO primality testing (no has_factor/no_factor)
%%   - NO next_prime stepping
%%   - ONLY arithmetic composition: P = g(N)
%%   - Single clause (max_clauses = 1)
%%
%% The system must find something like:
%%   f(N, P) :- n_ln_n(N, X), add(X, N, P).
%%   f(N, P) :- cipolla(N, P).
%%   f(N, P) :- n_ln_n_ln_ln_n(N, X), sub(X, N, P).
%% ============================================================

%% --- Target ---
head_pred(f, 2).

%% --- Arithmetic predicates ---
body_pred(add, 3).
body_pred(sub, 3).
body_pred(mult, 3).
body_pred(int_div, 3).
body_pred(modulo, 3).
body_pred(double, 2).
body_pred(triple, 2).
body_pred(square, 2).
body_pred(inc, 2).
body_pred(dec, 2).

%% --- Approximation functions (from number theory) ---
body_pred(ln_floor, 2).
body_pred(ln_ceil, 2).
body_pred(n_ln_n, 2).
body_pred(n_ln_n_ln_ln_n, 2).
body_pred(cipolla, 2).

%% --- Structural ---
body_pred(succ, 2).
body_pred(num, 1).
body_pred(greater_than, 2).
body_pred(less_than, 2).
body_pred(one, 1).
body_pred(two, 1).
body_pred(three, 1).
body_pred(six, 1).

%% --- Types ---
type(f, (int, int)).
type(add, (int, int, int)).
type(sub, (int, int, int)).
type(mult, (int, int, int)).
type(int_div, (int, int, int)).
type(modulo, (int, int, int)).
type(double, (int, int)).
type(triple, (int, int)).
type(square, (int, int)).
type(inc, (int, int)).
type(dec, (int, int)).
type(ln_floor, (int, int)).
type(ln_ceil, (int, int)).
type(n_ln_n, (int, int)).
type(n_ln_n_ln_ln_n, (int, int)).
type(cipolla, (int, int)).
type(succ, (int, int)).
type(num, (int,)).
type(greater_than, (int, int)).
type(less_than, (int, int)).
type(one, (int,)).
type(two, (int,)).
type(three, (int,)).
type(six, (int,)).

%% --- Directions ---
direction(f, (in, out)).
direction(add, (in, in, out)).
direction(sub, (in, in, out)).
direction(mult, (in, in, out)).
direction(int_div, (in, in, out)).
direction(modulo, (in, in, out)).
direction(double, (in, out)).
direction(triple, (in, out)).
direction(square, (in, out)).
direction(inc, (in, out)).
direction(dec, (in, out)).
direction(ln_floor, (in, out)).
direction(ln_ceil, (in, out)).
direction(n_ln_n, (in, out)).
direction(n_ln_n_ln_ln_n, (in, out)).
direction(cipolla, (in, out)).
direction(succ, (in, out)).
direction(num, (in,)).
direction(greater_than, (in, in)).
direction(less_than, (in, in)).
direction(one, (out,)).
direction(two, (out,)).
direction(three, (out,)).
direction(six, (out,)).


