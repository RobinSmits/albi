% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
f(N, P) :- cipolla(N, X), inc(X, P), modulo(P, 6, O), modulo(O, 4, 1).
f(N, P) :- cipolla(N, X), ln_ceil(N, L), add(X, L, P), modulo(P, 6, 5).
f(N, P) :- rosser(N, X), modulo(X, 6, R), sub(X, R, Y), inc(Y, P).
f(N, P) :- rosser(N, X), inc(X, P), modulo(N, 5, 2).
f(N, P) :- mult(N, 4, Y), sub(Y, 7, P), greater_than(N, 9).
f(N, P) :- mult(N, 4, Y), ln_floor(N, L), sub(Y, L, P), three(L).
f(N, P) :- inc(N, P), ln_ceil(N, 0).
