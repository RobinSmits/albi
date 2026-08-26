:- use_module(library(clpfd)).
p11(100).

p3(p12(1,_)).

p2(p12(_,1)).

p1(p12(_,Y)):-
    p11(Y).
p4(p12(X,_)):-
    p11(X).

p6(p12(X1,Y),p12(X2,Y)):-
    p11(Size),
    X1 #< Size,
    X2 #= X1 + 1.

p5(p12(X1,Y),p12(X2,Y)):-
    X1 #> 1,
    X2 #= X1 - 1.

p7(p12(X,Y1),p12(X,Y2)):-
    p11(Size),
    Y1 #< Size,
    Y2 #= Y1 + 1.

p8(p12(X,Y1),p12(X,Y2)):-
    Y1 #> 1,
    Y2 #= Y1 - 1.

p13(Atom1):-
    Atom1=..[c4,A,B],
    Atom2=..[c4,A,C],
    p14(Atom2),
    B \= C.
