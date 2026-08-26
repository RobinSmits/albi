% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gpt-5.4-pro
f([],0).
f([_|A],B) :- f(A,C), succ(C,B).
