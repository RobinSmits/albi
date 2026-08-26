% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gpt-5.4-pro
f(A,0,A).
f([_|T],B,C):- decrement(B,B1), f(T,B1,C).
