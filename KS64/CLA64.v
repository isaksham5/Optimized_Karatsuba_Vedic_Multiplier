

// ============================================================
// CLA64 ? four CLA16 blocks + top-level lookahead
// ============================================================
module CLA64 (
    input clk,
    input  [63:0] A, B,
    input         Cin,
    output [63:0] S,
    output        GG, GP
);

wire c16, c32, c48;
wire [3:0] GG16, GP16;

CLA16 blk0 (A[15:0],  B[15:0],  Cin, S[15:0],  GG16[0], GP16[0]);
CLA16 blk1 (A[31:16], B[31:16], c16, S[31:16], GG16[1], GP16[1]);
CLA16 blk2 (A[47:32], B[47:32], c32, S[47:32], GG16[2], GP16[2]);
CLA16 blk3 (A[63:48], B[63:48], c48, S[63:48], GG16[3], GP16[3]);

// Top-level lookahead
wire t_c16;
and a160 (t_c16, GP16[0], Cin);
or  o160 (c16,   GG16[0], t_c16);

wire t_c32a, t_c32b;
and a320 (t_c32a, GP16[1], GG16[0]);
and a321 (t_c32b, GP16[1], GP16[0], Cin);
or  o320 (c32,    GG16[1], t_c32a, t_c32b);

wire t_c48a, t_c48b, t_c48c;
and a480 (t_c48a, GP16[2], GG16[1]);
and a481 (t_c48b, GP16[2], GP16[1], GG16[0]);
and a482 (t_c48c, GP16[2], GP16[1], GP16[0], Cin);
or  o480 (c48,    GG16[2], t_c48a, t_c48b, t_c48c);

// Block GG and GP
wire tg0, tg1, tg2;
and ag0 (tg0, GP16[3], GG16[2]);
and ag1 (tg1, GP16[3], GP16[2], GG16[1]);
and ag2 (tg2, GP16[3], GP16[2], GP16[1], GG16[0]);
or  ogg (GG,  GG16[3], tg0, tg1, tg2);
and agp (GP,  GP16[3], GP16[2], GP16[1], GP16[0]);

endmodule

