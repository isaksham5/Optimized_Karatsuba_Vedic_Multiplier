
// ============================================================
// CLA Group Block (4-bit)
// Inputs : A[3:0], B[3:0], Cin
// Outputs: S[3:0], GG (group generate), GP (group propagate)
// ============================================================
module CLA4 (
    input  [3:0] A, B,
    input Cin,
    output [3:0] S,
    output       GG, GP
);

// Bit-level G and P
wire [3:0] G, P;
initialize ini0 (A[0], B[0], G[0], P[0]);
initialize ini1 (A[1], B[1], G[1], P[1]);
initialize ini2 (A[2], B[2], G[2], P[2]);
initialize ini3 (A[3], B[3], G[3], P[3]);

// Internal carries
// c1 = G0 + P0.Cin
// c2 = G1 + P1.G0 + P1.P0.Cin
// c3 = G2 + P2.G1 + P2.P1.G0 + P2.P1.P0.Cin
wire c1, c2, c3;

// c1
wire t_p0cin;
and a10 (t_p0cin, P[0], Cin);
or  o10 (c1, G[0], t_p0cin);

// c2
wire t_p1g0, t_p1p0cin;
and a20 (t_p1g0,   P[1], G[0]);
and a21 (t_p1p0cin, P[1], P[0], Cin);
or  o20 (c2, G[1], t_p1g0, t_p1p0cin);

// c3
wire t_p2g1, t_p2p1g0, t_p2p1p0cin;
and a30 (t_p2g1,      P[2], G[1]);
and a31 (t_p2p1g0,    P[2], P[1], G[0]);
and a32 (t_p2p1p0cin, P[2], P[1], P[0], Cin);
or  o30 (c3, G[2], t_p2g1, t_p2p1g0, t_p2p1p0cin);

// Sum
xor x0 (S[0], P[0], Cin);
xor x1 (S[1], P[1], c1);
xor x2 (S[2], P[2], c2);
xor x3 (S[3], P[3], c3);

// Group Generate: GG = G3 + P3.G2 + P3.P2.G1 + P3.P2.P1.G0
// Group Propagate: GP = P3.P2.P1.P0
wire tg0, tg1, tg2;
and ag0 (tg0, P[3], G[2]);
and ag1 (tg1, P[3], P[2], G[1]);
and ag2 (tg2, P[3], P[2], P[1], G[0]);
or  ogg (GG,  G[3], tg0, tg1, tg2);
and agp (GP,  P[3], P[2], P[1], P[0]);

endmodule


