

// ============================================================
// CLA128 ? eight CLA16 blocks + top-level lookahead
// ============================================================
module CLA128 (
    input clk,
    input  [127:0] A, B,
    input          Cin,
    output [127:0] S,
    output         GG, GP
);

wire c16, c32, c48, c64, c80, c96, c112;
wire [7:0] GG16, GP16;

CLA16 blk0 (A[15:0],   B[15:0],   Cin,  S[15:0],   GG16[0], GP16[0]);
CLA16 blk1 (A[31:16],  B[31:16],  c16,  S[31:16],  GG16[1], GP16[1]);
CLA16 blk2 (A[47:32],  B[47:32],  c32,  S[47:32],  GG16[2], GP16[2]);
CLA16 blk3 (A[63:48],  B[63:48],  c48,  S[63:48],  GG16[3], GP16[3]);
CLA16 blk4 (A[79:64],  B[79:64],  c64,  S[79:64],  GG16[4], GP16[4]);
CLA16 blk5 (A[95:80],  B[95:80],  c80,  S[95:80],  GG16[5], GP16[5]);
CLA16 blk6 (A[111:96], B[111:96], c96,  S[111:96], GG16[6], GP16[6]);
CLA16 blk7 (A[127:112],B[127:112],c112, S[127:112],GG16[7], GP16[7]);

// Top-level lookahead for 8 groups
wire t0, t1a, t1b, t2a, t2b, t2c, t3a, t3b, t3c, t3d;
wire t4a, t4b, t4c, t4d, t4e;
wire t5a, t5b, t5c, t5d, t5e, t5f;
wire t6a, t6b, t6c, t6d, t6e, t6f, t6g;

// c16
and a160 (t0,   GP16[0], Cin);
or  o160 (c16,  GG16[0], t0);

// c32
and a320 (t1a, GP16[1], GG16[0]);
and a321 (t1b, GP16[1], GP16[0], Cin);
or  o320 (c32, GG16[1], t1a, t1b);

// c48
and a480 (t2a, GP16[2], GG16[1]);
and a481 (t2b, GP16[2], GP16[1], GG16[0]);
and a482 (t2c, GP16[2], GP16[1], GP16[0], Cin);
or  o480 (c48, GG16[2], t2a, t2b, t2c);

// c64
and a640 (t3a, GP16[3], GG16[2]);
and a641 (t3b, GP16[3], GP16[2], GG16[1]);
and a642 (t3c, GP16[3], GP16[2], GP16[1], GG16[0]);
and a643 (t3d, GP16[3], GP16[2], GP16[1], GP16[0], Cin);
or  o640 (c64, GG16[3], t3a, t3b, t3c, t3d);

// c80
and a800 (t4a, GP16[4], GG16[3]);
and a801 (t4b, GP16[4], GP16[3], GG16[2]);
and a802 (t4c, GP16[4], GP16[3], GP16[2], GG16[1]);
and a803 (t4d, GP16[4], GP16[3], GP16[2], GP16[1], GG16[0]);
and a804 (t4e, GP16[4], GP16[3], GP16[2], GP16[1], GP16[0], Cin);
or  o800 (c80, GG16[4], t4a, t4b, t4c, t4d, t4e);

// c96
and a960 (t5a, GP16[5], GG16[4]);
and a961 (t5b, GP16[5], GP16[4], GG16[3]);
and a962 (t5c, GP16[5], GP16[4], GP16[3], GG16[2]);
and a963 (t5d, GP16[5], GP16[4], GP16[3], GP16[2], GG16[1]);
and a964 (t5e, GP16[5], GP16[4], GP16[3], GP16[2], GP16[1], GG16[0]);
and a965 (t5f, GP16[5], GP16[4], GP16[3], GP16[2], GP16[1], GP16[0], Cin);
or  o960 (c96, GG16[5], t5a, t5b, t5c, t5d, t5e, t5f);

// c112
and a1120 (t6a, GP16[6], GG16[5]);
and a1121 (t6b, GP16[6], GP16[5], GG16[4]);
and a1122 (t6c, GP16[6], GP16[5], GP16[4], GG16[3]);
and a1123 (t6d, GP16[6], GP16[5], GP16[4], GP16[3], GG16[2]);
and a1124 (t6e, GP16[6], GP16[5], GP16[4], GP16[3], GP16[2], GG16[1]);
and a1125 (t6f, GP16[6], GP16[5], GP16[4], GP16[3], GP16[2], GP16[1], GG16[0]);
and a1126 (t6g, GP16[6], GP16[5], GP16[4], GP16[3], GP16[2], GP16[1], GP16[0], Cin);
or  o1120 (c112, GG16[6], t6a, t6b, t6c, t6d, t6e, t6f, t6g);

// Block GG and GP
wire bg0, bg1, bg2, bg3, bg4, bg5, bg6;
and bgg0 (bg0, GP16[7], GG16[6]);
and bgg1 (bg1, GP16[7], GP16[6], GG16[5]);
and bgg2 (bg2, GP16[7], GP16[6], GP16[5], GG16[4]);
and bgg3 (bg3, GP16[7], GP16[6], GP16[5], GP16[4], GG16[3]);
and bgg4 (bg4, GP16[7], GP16[6], GP16[5], GP16[4], GP16[3], GG16[2]);
and bgg5 (bg5, GP16[7], GP16[6], GP16[5], GP16[4], GP16[3], GP16[2], GG16[1]);
and bgg6 (bg6, GP16[7], GP16[6], GP16[5], GP16[4], GP16[3], GP16[2], GP16[1], GG16[0]);
or  obgg (GG,  GG16[7], bg0, bg1, bg2, bg3, bg4, bg5, bg6);
and abgp (GP,  GP16[7], GP16[6], GP16[5], GP16[4], GP16[3], GP16[2], GP16[1], GP16[0]);

endmodule
