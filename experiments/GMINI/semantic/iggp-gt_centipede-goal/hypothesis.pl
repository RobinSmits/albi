% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gemini-3-pro-preview
goal(A, white, C) :- true_control(A, black), true_whitePayoff(A, C), true_blackPayoff(A, B), succ(B, C).
goal(A, black, C) :- true_control(A, black), true_blackPayoff(A, C), true_whitePayoff(A, W), succ(C, W).
goal(A, white, 0) :- true_control(A, white), true_whitePayoff(A, 0).
goal(A, black, C) :- true_control(A, white), true_blackPayoff(A, C), true_whitePayoff(A, 0).
goal(A, B, 0) :- true_control(A, black), true_whitePayoff(A, W), succ(W, X), succ(X, Y), succ(Y, BP), true_blackPayoff(A, BP), role(B).
goal(A, B, 0) :- true_control(A, white), true_blackPayoff(A, BP), true_whitePayoff(A, WP), succ(BP, WP), role(B).
