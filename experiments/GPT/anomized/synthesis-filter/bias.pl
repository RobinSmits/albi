
enable_recursion.



head_pred(p0,2).
body_pred(p1,1).
body_pred(p2,1).
body_pred(p3,1).
body_pred(p4,2).
body_pred(p5,2).
body_pred(p6,3).



type(p0,(list,list)).
type(p1,(list,element)).
type(p2,(list,list)).
type(p3,(list,)).
type(p4,(element,)).
type(p5,(element,)).
type(p6,(element,list,list)).

direction(p0,(in,out)).
direction(p1,(out,)).
direction(p2,(in,out)).
direction(p3,(in,out)).
direction(p4,(in,)).
direction(p5,(in,)).
direction(p6,(in,in,out)).
