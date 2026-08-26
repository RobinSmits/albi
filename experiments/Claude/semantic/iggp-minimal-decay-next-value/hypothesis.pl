% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
next_value(Ex, V) :- does(Ex, _, A), press_button(A), c5(V).
next_value(Ex, V) :- does(Ex, _, A), noop(A), true_value(Ex, V2), my_succ(V, V2).
