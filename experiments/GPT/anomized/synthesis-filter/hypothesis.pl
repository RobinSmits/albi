% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gpt-5.4-pro
p0([],[]).
p0([A|B],C):- p2(A), p0(B,C).
p0([A|B],[A|C]):- p3(A), p0(B,C).
