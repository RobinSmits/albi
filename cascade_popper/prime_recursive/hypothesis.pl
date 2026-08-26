% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
f(N, P) :- one(N), two(P).
f(N, P) :- prec(N, N1), f(N1, Q), next_prime(Q, P).
