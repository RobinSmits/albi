% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
legal(X, A, finish) :- true_control(X, A).
legal(X, A, continue) :- true_control(X, A).
legal(X, A, noop) :- true_control(X, B), agent_white(B), agent_black(A).
legal(X, A, noop) :- true_control(X, B), agent_black(B), agent_white(A).
