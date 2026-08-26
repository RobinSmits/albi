:- use_module(library(clpfd)).

p7(10).

p8(p9(1,_)).

p10(p9(_,1)).

p11(p9(_,Y)):-
    p7(Y).
p12(p9(X,_)):-
    p7(X).

p4(p9(X1,Y),p9(X2,Y)):-
    p7(Size),
    X1 #< Size,
    X2 #= X1 + 1.

p3(p9(X1,Y),p9(X2,Y)):-
    X1 #> 1,
    X2 #= X1 - 1.

p1(p9(X,Y1),p9(X,Y2)):-
    p7(Size),
    Y1 #< Size,
    Y2 #= Y1 + 1.

p2(p9(X,Y1),p9(X,Y2)):-
    Y1 #> 1,
    Y2 #= Y1 - 1.