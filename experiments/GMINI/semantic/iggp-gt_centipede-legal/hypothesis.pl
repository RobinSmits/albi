% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gemini-3-pro-preview
legal(A, B, C) :- true_control(A, B), action_continue(C).
legal(A, B, C) :- true_control(A, B), action_finish(C).
legal(A, B, C) :- true_control(A, D), agent_black(D), agent_white(B), action_noop(C).
legal(A, B, C) :- true_control(A, D), agent_white(D), agent_black(B), action_noop(C).
