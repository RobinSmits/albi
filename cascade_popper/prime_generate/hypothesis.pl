% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
f(N, P) :- inc(N, S), cipolla(S, X), prev_prime(X, P).
f(N, P) :- cipolla(N, X), prime_at_or_before(X, P), greater_than(N, 13).
f(N, P) :- rosser(N, X), prev_prime(X, Y), prev_prime(Y, P), greater_than(N, 12).
f(N, P) :- dusart_lower(N, X), next_prime(X, P), geq(X, N).
