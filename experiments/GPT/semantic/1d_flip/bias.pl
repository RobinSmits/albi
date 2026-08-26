



head_pred(out,3).
body_pred(in,3).
body_pred(my_succ,2).
body_pred(add,3).
body_pred(lt,2).
body_pred(empty,2).
body_pred(C,1):-constant(C,_).

pred_task_specific(in).
pred_task_specific(empty).

constant(v0, value).
constant(v1, value).
constant(v2, value).
constant(v3, value).
constant(v4, value).
constant(v5, value).
constant(v6, value).
constant(v7, value).
constant(v8, value).
constant(v9, value).

constant(c0, position).
constant(c1, position).
constant(c2, position).
constant(c3, position).
constant(c4, position).
constant(c5, position).
constant(c6, position).
constant(c7, position).
constant(c8, position).
constant(c9, position).

type(empty,(ex,position)).
type(out,(ex,position,value)).
type(in,(ex,position,value)).
type(my_succ,(position,position)).
type(add,(position,position,position)).
type(lt,(position,position)).
type(C,(T,)):- constant(C,T).

