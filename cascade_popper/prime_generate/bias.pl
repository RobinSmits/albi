%% ============================================================
%% BIAS: f(N, P) - GENERATIVE closed-form for Nth prime
%%
%% Goal: Find a formula that can PREDICT/GENERATE primes
%% NOT a lookup table — must use approximation + correction
%%
%% Target hypotheses (generative):
%%   f(N, P) :- dusart_lower(N, L), prime_at_or_after(L, P).
%%   f(N, P) :- cipolla(N, X), prime_at_or_after(X, P).
%%   f(N, P) :- rosser(N, X), prime_at_or_after(X, P).
%%   f(N, P) :- n_ln_n(N, X), next_prime(X, P).
%%   f(N, P) :- n_ln_n(N, X), add(X, N, Y), prime_at_or_after(Y, P).
%%
%% These work because:
%%   1. Approximation gives a starting point near the actual prime
%%   2. prime_at_or_after/next_prime corrects to exact prime
%% ============================================================

%% --- Search Bounds ---
max_body(5).
max_vars(6).
max_clauses(2).

%% --- Target ---
head_pred(f, 2).

%% --- Approximation Functions (the "generator" part) ---
body_pred(n_ln_n, 2).
body_pred(n_ln_n_ln_ln_n, 2).
body_pred(cipolla, 2).
body_pred(rosser, 2).
body_pred(dusart_lower, 2).
body_pred(dusart_upper, 2).

%% --- Prime Correction (the "snap to prime" part) ---
body_pred(prime_at_or_after, 2).
body_pred(prime_at_or_before, 2).
body_pred(next_prime, 2).
body_pred(prev_prime, 2).

%% --- Primality Testing ---
body_pred(is_prime, 1).

%% --- Arithmetic ---
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

%% --- Structural ---
body_pred(succ, 2).
body_pred(prec, 2).
body_pred(num, 1).
body_pred(one, 1).
body_pred(two, 1).

%% --- Types ---
type(f, (int, int)).
type(n_ln_n, (int, int)).
type(n_ln_n_ln_ln_n, (int, int)).
type(cipolla, (int, int)).
type(rosser, (int, int)).
type(dusart_lower, (int, int)).
type(dusart_upper, (int, int)).
type(prime_at_or_after, (int, int)).
type(prime_at_or_before, (int, int)).
type(next_prime, (int, int)).
type(prev_prime, (int, int)).
type(is_prime, (int,)).
type(add, (int, int, int)).
type(sub, (int, int, int)).
type(inc, (int, int)).
type(dec, (int, int)).
type(double, (int, int)).
type(modulo, (int, int, int)).
type(greater_than, (int, int)).
type(less_than, (int, int)).
type(geq, (int, int)).
type(succ, (int, int)).
type(prec, (int, int)).
type(num, (int,)).
type(one, (int,)).
type(two, (int,)).

%% --- Directions ---
direction(f, (in, out)).
direction(n_ln_n, (in, out)).
direction(n_ln_n_ln_ln_n, (in, out)).
direction(cipolla, (in, out)).
direction(rosser, (in, out)).
direction(dusart_lower, (in, out)).
direction(dusart_upper, (in, out)).
direction(prime_at_or_after, (in, out)).
direction(prime_at_or_before, (in, out)).
direction(next_prime, (in, out)).
direction(prev_prime, (in, out)).
direction(is_prime, (in,)).
direction(add, (in, in, out)).
direction(sub, (in, in, out)).
direction(inc, (in, out)).
direction(dec, (in, out)).
direction(double, (in, out)).
direction(modulo, (in, in, out)).
direction(greater_than, (in, in)).
direction(less_than, (in, in)).
direction(geq, (in, in)).
direction(succ, (in, out)).
direction(prec, (in, out)).
direction(num, (in,)).
direction(one, (out,)).
direction(two, (out,)).

