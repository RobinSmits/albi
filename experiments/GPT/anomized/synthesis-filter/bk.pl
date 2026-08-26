%% filter/keep the even elements of a list
%% f(V0,V1):- empty(V0),empty(V1).
%% f(V0,V1):- tail(V0,V3),head(V0,V2),odd(V2),f(V3,V1).
%% f(V0,V1):- head(V0,V3),tail(V0,V2),even(V3),f(V2,V4),prepend(V3,V4,V1).


p5([_|T],T).
p4([H|_],H).
p1([]).
p6(A,B,C):- p10([A],B,C).
p11(A,B):- B is A+1.

p2(1).
p2(3).
p2(5).
p2(7).
p2(9).

p3(2).
p3(4).
p3(6).
p3(8).
p3(10).