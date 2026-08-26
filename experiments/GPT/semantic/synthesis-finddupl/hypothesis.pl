% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gpt-5.4-pro
f([B|T],B):- element(T,B).
f([_|T],B):- f(T,B).
