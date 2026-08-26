%% ============================================================
%% BIAS: f(N, P) - CLOSED-FORM for Nth prime
%%
%% Uses ALL known results from the literature:
%%   - Wilson's theorem / Willans' formula components
%%   - Prime counting function pi(X, C)
%%   - Dusart/Rosser/Cipolla approximations
%%   - Divisibility testing
%%   - NO recursion needed
%%
%% Target closed-form hypotheses:
%%   f(N, P) :- pi(P, N), is_prime(P).
%%   f(N, P) :- dusart_lower(N, L), prime_at_or_after(L, P), pi(P, N).
%%   f(N, P) :- wilson_prime(P), pi(P, N).
%% ============================================================

%% --- Search Bounds ---
max_body(5).
max_vars(6).
max_clauses(2).

%% --- Target ---
head_pred(f, 2).

%% --- Prime Counting (Willans/Literature) ---
body_pred(pi, 2).
body_pred(pi_approx, 2).

%% --- Primality Testing (Wilson's theorem based) ---
body_pred(is_prime, 1).
body_pred(wilson_prime, 1).
body_pred(not_prime, 1).

%% --- Divisibility ---
body_pred(has_factor, 2).
body_pred(no_small_factor, 1).
body_pred(divisible, 2).
body_pred(not_divisible, 2).

%% --- Prime Navigation ---
body_pred(next_prime, 2).
body_pred(prev_prime, 2).
body_pred(prime_at_or_after, 2).

%% --- Approximation Functions (Literature) ---
body_pred(n_ln_n, 2).
body_pred(n_ln_n_ln_ln_n, 2).
body_pred(cipolla, 2).
body_pred(rosser, 2).
body_pred(dusart_lower, 2).
body_pred(dusart_upper, 2).

%% --- Arithmetic ---
body_pred(add, 3).
body_pred(sub, 3).
body_pred(mult, 3).
body_pred(int_div, 3).
body_pred(modulo, 3).
body_pred(inc, 2).
body_pred(dec, 2).
body_pred(double, 2).
body_pred(square, 2).
body_pred(succ, 2).
body_pred(prec, 2).

%% --- Comparison ---
body_pred(greater_than, 2).
body_pred(less_than, 2).
body_pred(geq, 2).
body_pred(leq, 2).

%% --- Constants ---
body_pred(num, 1).
body_pred(one, 1).
body_pred(two, 1).
body_pred(three, 1).
body_pred(six, 1).

%% --- Types ---
type(f, (int, int)).
type(pi, (int, int)).
type(pi_approx, (int, int)).
type(is_prime, (int,)).
type(wilson_prime, (int,)).
type(not_prime, (int,)).
type(has_factor, (int, int)).
type(no_small_factor, (int,)).
type(divisible, (int, int)).
type(not_divisible, (int, int)).
type(next_prime, (int, int)).
type(prev_prime, (int, int)).
type(prime_at_or_after, (int, int)).
type(n_ln_n, (int, int)).
type(n_ln_n_ln_ln_n, (int, int)).
type(cipolla, (int, int)).
type(rosser, (int, int)).
type(dusart_lower, (int, int)).
type(dusart_upper, (int, int)).
type(add, (int, int, int)).
type(sub, (int, int, int)).
type(mult, (int, int, int)).
type(int_div, (int, int, int)).
type(modulo, (int, int, int)).
type(inc, (int, int)).
type(dec, (int, int)).
type(double, (int, int)).
type(square, (int, int)).
type(succ, (int, int)).
type(prec, (int, int)).
type(greater_than, (int, int)).
type(less_than, (int, int)).
type(geq, (int, int)).
type(leq, (int, int)).
type(num, (int,)).
type(one, (int,)).
type(two, (int,)).
type(three, (int,)).
type(six, (int,)).

%% --- Directions ---
direction(f, (in, out)).
direction(pi, (in, out)).
direction(pi_approx, (in, out)).
direction(is_prime, (in,)).
direction(wilson_prime, (in,)).
direction(not_prime, (in,)).
direction(has_factor, (in, in)).
direction(no_small_factor, (in,)).
direction(divisible, (in, in)).
direction(not_divisible, (in, in)).
direction(next_prime, (in, out)).
direction(prev_prime, (in, out)).
direction(prime_at_or_after, (in, out)).
direction(n_ln_n, (in, out)).
direction(n_ln_n_ln_ln_n, (in, out)).
direction(cipolla, (in, out)).
direction(rosser, (in, out)).
direction(dusart_lower, (in, out)).
direction(dusart_upper, (in, out)).
direction(add, (in, in, out)).
direction(sub, (in, in, out)).
direction(mult, (in, in, out)).
direction(int_div, (in, in, out)).
direction(modulo, (in, in, out)).
direction(inc, (in, out)).
direction(dec, (in, out)).
direction(double, (in, out)).
direction(square, (in, out)).
direction(succ, (in, out)).
direction(prec, (in, out)).
direction(greater_than, (in, in)).
direction(less_than, (in, in)).
direction(geq, (in, in)).
direction(leq, (in, in)).
direction(num, (in,)).
direction(one, (out,)).
direction(two, (out,)).
direction(three, (out,)).
direction(six, (out,)).

