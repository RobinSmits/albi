% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gemini-3-pro-preview
next_value(A, B) :- does(A, _, C), press_button(C), c5(B).
next_value(A, B) :- does(A, _, C), noop(C), true_value(A, D), my_succ(B, D).
