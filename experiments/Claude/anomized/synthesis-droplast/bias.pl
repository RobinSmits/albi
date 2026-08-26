

enable_recursion.

head_pred(p0,2).
body_pred(p1,2).
body_pred(p2,2).
body_pred(p3,1).
body_pred(p4,1).
body_pred(p5,1).
body_pred(p6,1).
body_pred(p7,1).
body_pred(p8,3).


type(p0,(list,list)).
type(p1,(list,element)).
type(p2,(list,list)).
type(p3,(list,)).
type(p4,(element,)).
type(p5,(element,)).
type(p6,(element,)).
type(p7,(element,)).
type(p8,(element,list,list)).

direction(p0,(in,out)).
direction(p1,(in,out)).
direction(p2,(in,out)).
direction(p2,(out,)).
direction(p3,(in,)).
direction(p4,(in,)).
direction(p5,(out,)).
direction(p6,(out,)).
direction(p7,(in,in,out)).