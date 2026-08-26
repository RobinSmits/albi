

enable_recursion.

head_pred(p0,1).
body_pred(p1,2).
body_pred(p2,2).
body_pred(p3,2).
body_pred(p4,1).
body_pred(p5,1).
body_pred(p6,1).


type(p0,(list,)).
type(p1,(list,list)).
type(p2,(list,element)).
type(p3,(list,element)).
type(p4,(list,)).
type(p5,(element,)).
type(p6,(element,)).

direction(p0,(in,)).
direction(p1,(in,out)).
direction(p2,(in,out)).
direction(p3,(in,out)).
direction(p4,(out,)).
direction(p5,(out,)).
direction(p6,(in,)).