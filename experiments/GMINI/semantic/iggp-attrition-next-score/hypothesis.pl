% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gemini-3-pro-preview
next_score(A, B, C) :- does(A, B, lay_claim), my_true_score(A, B, D), my_succ(C, D).
next_score(A, B, C) :- does(A, B, end_game), my_true_score(A, B, C).
next_score(A, B, C) :- does(A, D, lay_claim), opponent(B, D), my_true_score(A, B, C).
