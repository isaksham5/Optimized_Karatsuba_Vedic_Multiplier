
// ============================================================
// CLA16 ? four CLA4 blocks + top-level lookahead
// ============================================================
module CLA16 (
    input  [15:0] A, B,
    input Cin,
    output [15:0] S,
    output        GG, GP
);


// Group carries
// Cout of group k = Cin of group k+1
wire c4, c8, c12;

// Group G and P from each CLA4
wire [3:0] GG4, GP4;

CLA4 grp0 (A[3:0],   B[3:0],   Cin, S[3:0],   GG4[0], GP4[0]);
CLA4 grp1 (A[7:4],   B[7:4],   c4,  S[7:4],   GG4[1], GP4[1]);
CLA4 grp2 (A[11:8],  B[11:8],  c8,  S[11:8],  GG4[2], GP4[2]);
CLA4 grp3 (A[15:12], B[15:12], c12, S[15:12], GG4[3], GP4[3]);

// Top-level carry lookahead
// c4  = GG0 + GP0.Cin
// c8  = GG1 + GP1.GG0 + GP1.GP0.Cin
// c12 = GG2 + GP2.GG1 + GP2.GP1.GG0 + GP2.GP1.GP0.Cin

wire t_c4;
and a40 (t_c4, GP4[0], Cin);
or  o40 (c4,   GG4[0], t_c4);

wire t_c8a, t_c8b;
and a80 (t_c8a, GP4[1], GG4[0]);
and a81 (t_c8b, GP4[1], GP4[0], Cin);
or  o80 (c8,    GG4[1], t_c8a, t_c8b);

wire t_c12a, t_c12b, t_c12c;
and a120 (t_c12a, GP4[2], GG4[1]);
and a121 (t_c12b, GP4[2], GP4[1], GG4[0]);
and a122 (t_c12c, GP4[2], GP4[1], GP4[0], Cin);
or  o120 (c12,    GG4[2], t_c12a, t_c12b, t_c12c);

// Block-level Group Generate and Propagate (for cascading)
// GG = GG3 + GP3.GG2 + GP3.GP2.GG1 + GP3.GP2.GP1.GG0
// GP = GP3.GP2.GP1.GP0
wire tg0, tg1, tg2;
and ag0 (tg0, GP4[3], GG4[2]);
and ag1 (tg1, GP4[3], GP4[2], GG4[1]);
and ag2 (tg2, GP4[3], GP4[2], GP4[1], GG4[0]);
or  ogg (GG,  GG4[3], tg0, tg1, tg2);
and agp (GP,  GP4[3], GP4[2], GP4[1], GP4[0]);

endmodule

