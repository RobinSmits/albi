% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gpt-5.4-pro
next_list([C,B|_],B):-x(C).
next_list([_|T],B):-next_list(T,B).
