p2([_|T],T).
p1([H|_],H).
p4([]).
p3(A,B,C):-
    p5(A,[B],C).
p5([],L,L).
p5([H|T],L,[H|R]) :- p5(T,L,R).
tail([_|T],T).
head([H|_],H).
empty([]).
my_append(A,B,C):-
    append(A,[B],C).