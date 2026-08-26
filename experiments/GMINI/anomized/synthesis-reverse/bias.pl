

enable_recursion.

head_pred(p0,2).
body_pred(p1,2).
body_pred(p2,2).
body_pred(p3,3).
body_pred(p4,1).


type(p0,(list,list)).
type(p1,(list,element)).
type(p2,(list,list)).
type(p3,(list,element,list)).
type(p4,(list,)).

direction(p0,(in,out)).
direction(p1,(in,out)).
direction(p2,(in,out)).
direction(p3,(in,in,out)).
direction(p4,(out,)).