% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gpt-5.4-pro
p0([c5,B|_],B).
p0([_|T],B):-p0(T,B).
