

enable_recursion.

head_pred(p0,2).
body_pred(p1,2).
body_pred(p2,2).
body_pred(p3,2).
body_pred(p4,1).
body_pred(p5,1).
body_pred(p6,1).


type(p0,(list,integer)).
type(p1,(list,element)).
type(p2,(list,list)).
type(p3,(integer,integer)).
type(p4,(list,)).
type(p5,(integer,)).
type(p6,(integer,)).

direction(p0,(in,out)).
direction(p1,(in,out)).
direction(p2,(in,out)).
direction(p3,(in,out)).
direction(p4,(in,)).
direction(p5,(out,)).
direction(p6,(out,)).