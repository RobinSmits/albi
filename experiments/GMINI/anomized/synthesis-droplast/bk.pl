p2([_|T],T).
p1([H|_],H).
p9(A,B,C):- C is A+B.
p3([]).
p7(0).
p6(1).
p4(A):- 0 is A mod 2.
p5(A):- 1 is A mod 2.


p10([],L,L).
p10([H|T],L,[H|R]) :- p10(T,L,R).
 

p8(A,B,C):- p10([A],B,C).
