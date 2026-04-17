
// ============================================================
// CLA32 ? two CLA16 blocks + top-level lookahead
// ============================================================
module CLA32 (
    input  [31:0] A, B,
    input         Cin,
    output [31:0] S,
    output        GG, GP
);

wire c16;
wire [1:0] GG16, GP16;

CLA16 blk0 (A[15:0],  B[15:0],  Cin, S[15:0],  GG16[0], GP16[0]);
CLA16 blk1 (A[31:16], B[31:16], c16, S[31:16], GG16[1], GP16[1]);

// c16 = GG16[0] + GP16[0].Cin
wire t_c16;
and a0 (t_c16, GP16[0], Cin);
or  o0 (c16,   GG16[0], t_c16);

// Block GG and GP
wire tg0;
and ag0 (tg0, GP16[1], GG16[0]);
or  ogg (GG,  GG16[1], tg0);
and agp (GP,  GP16[1], GP16[0]);

endmodule

