% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
p0(L) :- p15(L, H), p17(L, T), p15(T, H2), p16(H), p13(H2), p14(H, H2), p8(K), p14(K, H2).
p0(L) :- p15(L, H), p17(L, T), p15(T, H2), p16(H), p13(H2), p14(H, H2), p3(K), p14(K, H2), p11(K2), p14(K2, H).
p0(L) :- p17(L, T), p0(T).
p0(L) :- p15(L, H), p17(L, T), p15(T, H2), p13(H), p16(H2), p14(H, H2), p17(T, T2), p15(T2, H3), p13(H3), p14(H, H3), p14(H3, H2).
p0(L) :- p15(L, H), p17(L, T), p15(T, H2), p16(H), p16(H2), p14(H2, H), p17(T, T2), p15(T2, H3), p14(H, H3).
p0(L) :- p15(L,H), p17(L,T), p15(T,H2), p17(T,T2), p15(T2,H3), p17(T2,T3), p15(T3,H4), p13(H), p16(H2), p13(H3), p13(H4), p14(H,H2), p14(H3,H), p14(H4,H2), p3(K), p14(H2,K).
p0(L) :- p15(L, H), p17(L, T), p15(T, H2), p11(K), p14(K, H), p17(T, T2), p15(T2, H3), p13(H3), p17(T2, T3), p15(T3, H4), p13(H4), \+ (p16(H), p13(H2)), \+ (p13(H), p16(H2)).
