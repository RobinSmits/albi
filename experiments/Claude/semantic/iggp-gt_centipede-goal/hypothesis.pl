% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
goal(Ex, A, 0) :- role(A), true_control(Ex, _), \+ true_gameOver(Ex).
goal(Ex, white, V) :- true_gameOver(Ex), true_whitePayoff(Ex, V).
goal(Ex, black, V) :- true_gameOver(Ex), true_blackPayoff(Ex, V).
