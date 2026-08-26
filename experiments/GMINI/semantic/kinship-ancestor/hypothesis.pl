% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gemini-3-pro-preview
ancestor(A, B) :- mother(A, B).
ancestor(A, B) :- father(A, B).
ancestor(A, B) :- ancestor(A, C), ancestor(C, B).
