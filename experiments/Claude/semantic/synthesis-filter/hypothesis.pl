% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
f(V0,V1):- empty(V0), empty(V1).
f(V0,V1):- head(V0,V2), tail(V0,V3), odd(V2), f(V3,V1).
f(V0,V1):- head(V0,V2), tail(V0,V3), even(V2), f(V3,V4), prepend(V2,V4,V1).
