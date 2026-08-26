% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
prime(X, Y) :- is_prime(X), is_prime(Y), no_prime_between(X, Y).
