/*module KS32 (
    input  [31:0] x, y,
    input         cin,
    output [31:0] sum,
    output        cout
);

// Stage 0: Generate & Propagate
wire [31:0] G, P;
genvar i;
generate
    for (i = 0; i < 32; i = i + 1) begin : gen_gp
        initialize ini(x[i], y[i], G[i], P[i]);
    end
endgenerate

// Stage 1 (distance=1)
// G1[0] folds in cin via grey cell
// G1[k] covers k..k-1 (raw, no cin except through G1[0])
wire [31:0] G1, P1;
grey_cell  b1 (G[0],  P[0],  cin,   G1[0]);
black_cell b2 (G[1],  P[1],  G[0],  P[0],  G1[1],  P1[1]);
black_cell b3 (G[2],  P[2],  G[1],  P[1],  G1[2],  P1[2]);
black_cell b4 (G[3],  P[3],  G[2],  P[2],  G1[3],  P1[3]);
black_cell b5 (G[4],  P[4],  G[3],  P[3],  G1[4],  P1[4]);
black_cell b6 (G[5],  P[5],  G[4],  P[4],  G1[5],  P1[5]);
black_cell b7 (G[6],  P[6],  G[5],  P[5],  G1[6],  P1[6]);
black_cell b8 (G[7],  P[7],  G[6],  P[6],  G1[7],  P1[7]);
black_cell b9 (G[8],  P[8],  G[7],  P[7],  G1[8],  P1[8]);
black_cell b10(G[9],  P[9],  G[8],  P[8],  G1[9],  P1[9]);
black_cell b11(G[10], P[10], G[9],  P[9],  G1[10], P1[10]);
black_cell b12(G[11], P[11], G[10], P[10], G1[11], P1[11]);
black_cell b13(G[12], P[12], G[11], P[11], G1[12], P1[12]);
black_cell b14(G[13], P[13], G[12], P[12], G1[13], P1[13]);
black_cell b15(G[14], P[14], G[13], P[13], G1[14], P1[14]);
black_cell b16(G[15], P[15], G[14], P[14], G1[15], P1[15]);
black_cell b17(G[16], P[16], G[15], P[15], G1[16], P1[16]);
black_cell b18(G[17], P[17], G[16], P[16], G1[17], P1[17]);
black_cell b19(G[18], P[18], G[17], P[17], G1[18], P1[18]);
black_cell b20(G[19], P[19], G[18], P[18], G1[19], P1[19]);
black_cell b21(G[20], P[20], G[19], P[19], G1[20], P1[20]);
black_cell b22(G[21], P[21], G[20], P[20], G1[21], P1[21]);
black_cell b23(G[22], P[22], G[21], P[21], G1[22], P1[22]);
black_cell b24(G[23], P[23], G[22], P[22], G1[23], P1[23]);
black_cell b25(G[24], P[24], G[23], P[23], G1[24], P1[24]);
black_cell b26(G[25], P[25], G[24], P[24], G1[25], P1[25]);
black_cell b27(G[26], P[26], G[25], P[25], G1[26], P1[26]);
black_cell b28(G[27], P[27], G[26], P[26], G1[27], P1[27]);
black_cell b29(G[28], P[28], G[27], P[27], G1[28], P1[28]);
black_cell b30(G[29], P[29], G[28], P[28], G1[29], P1[29]);
black_cell b31(G[30], P[30], G[29], P[29], G1[30], P1[30]);
black_cell b32(G[31], P[31], G[30], P[30], G1[31], P1[31]);

// Stage 2 (distance=2)
// G2[0] covers 1..0, G2[1] covers 2..0
// From G2[2] onwards, right input chains through resolved G2 nodes
wire [30:0] G2, P2;
grey_cell  b33(G1[1],  P1[1],  cin,    G2[0]);
grey_cell  b34(G1[2],  P1[2],  G1[0],  G2[1]);
black_cell b35(G1[3],  P1[3],  G2[0],  P1[1],  G2[2],  P2[2]);
black_cell b36(G1[4],  P1[4],  G2[1],  P1[2],  G2[3],  P2[3]);
black_cell b37(G1[5],  P1[5],  G2[2],  P2[2],  G2[4],  P2[4]);
black_cell b38(G1[6],  P1[6],  G2[3],  P2[3],  G2[5],  P2[5]);
black_cell b39(G1[7],  P1[7],  G2[4],  P2[4],  G2[6],  P2[6]);
black_cell b40(G1[8],  P1[8],  G2[5],  P2[5],  G2[7],  P2[7]);
black_cell b41(G1[9],  P1[9],  G2[6],  P2[6],  G2[8],  P2[8]);
black_cell b42(G1[10], P1[10], G2[7],  P2[7],  G2[9],  P2[9]);
black_cell b43(G1[11], P1[11], G2[8],  P2[8],  G2[10], P2[10]);
black_cell b44(G1[12], P1[12], G2[9],  P2[9],  G2[11], P2[11]);
black_cell b45(G1[13], P1[13], G2[10], P2[10], G2[12], P2[12]);
black_cell b46(G1[14], P1[14], G2[11], P2[11], G2[13], P2[13]);
black_cell b47(G1[15], P1[15], G2[12], P2[12], G2[14], P2[14]);
black_cell b48(G1[16], P1[16], G2[13], P2[13], G2[15], P2[15]);
black_cell b49(G1[17], P1[17], G2[14], P2[14], G2[16], P2[16]);
black_cell b50(G1[18], P1[18], G2[15], P2[15], G2[17], P2[17]);
black_cell b51(G1[19], P1[19], G2[16], P2[16], G2[18], P2[18]);
black_cell b52(G1[20], P1[20], G2[17], P2[17], G2[19], P2[19]);
black_cell b53(G1[21], P1[21], G2[18], P2[18], G2[20], P2[20]);
black_cell b54(G1[22], P1[22], G2[19], P2[19], G2[21], P2[21]);
black_cell b55(G1[23], P1[23], G2[20], P2[20], G2[22], P2[22]);
black_cell b56(G1[24], P1[24], G2[21], P2[21], G2[23], P2[23]);
black_cell b57(G1[25], P1[25], G2[22], P2[22], G2[24], P2[24]);
black_cell b58(G1[26], P1[26], G2[23], P2[23], G2[25], P2[25]);
black_cell b59(G1[27], P1[27], G2[24], P2[24], G2[26], P2[26]);
black_cell b60(G1[28], P1[28], G2[25], P2[25], G2[27], P2[27]);
black_cell b61(G1[29], P1[29], G2[26], P2[26], G2[28], P2[28]);
black_cell b62(G1[30], P1[30], G2[27], P2[27], G2[29], P2[29]);
black_cell b63(G1[31], P1[31], G2[28], P2[28], G2[30], P2[30]);

// Stage 3 (distance=4)
// Right input = G2[k-4] which is already fully resolved from Stage 2
wire [27:0] G3, P3;
grey_cell  b64(G2[3],  P2[3],  G2[0],  G3[0]);   // covers 4..0
grey_cell  b65(G2[4],  P2[4],  G2[1],  G3[1]);   // covers 5..0
grey_cell  b66(G2[5],  P2[5],  G2[2],  G3[2]);   // covers 6..0
grey_cell  b67(G2[6],  P2[6],  G2[3],  G3[3]);   // covers 7..0
black_cell b68(G2[7],  P2[7],  G2[4],  P2[4],  G3[4],  P3[4]);   // covers 8..0
black_cell b69(G2[8],  P2[8],  G2[5],  P2[5],  G3[5],  P3[5]);   // covers 9..0
black_cell b70(G2[9],  P2[9],  G2[6],  P2[6],  G3[6],  P3[6]);   // covers 10..0
black_cell b71(G2[10], P2[10], G2[7],  P2[7],  G3[7],  P3[7]);   // covers 11..0
black_cell b72(G2[11], P2[11], G2[8],  P2[8],  G3[8],  P3[8]);   // covers 12..0
black_cell b73(G2[12], P2[12], G2[9],  P2[9],  G3[9],  P3[9]);   // covers 13..0
black_cell b74(G2[13], P2[13], G2[10], P2[10], G3[10], P3[10]);  // covers 14..0
black_cell b75(G2[14], P2[14], G2[11], P2[11], G3[11], P3[11]);  // covers 15..0
black_cell b76(G2[15], P2[15], G2[12], P2[12], G3[12], P3[12]);  // covers 16..0
black_cell b77(G2[16], P2[16], G2[13], P2[13], G3[13], P3[13]);  // covers 17..0
black_cell b78(G2[17], P2[17], G2[14], P2[14], G3[14], P3[14]);  // covers 18..0
black_cell b79(G2[18], P2[18], G2[15], P2[15], G3[15], P3[15]);  // covers 19..0
black_cell b80(G2[19], P2[19], G2[16], P2[16], G3[16], P3[16]);  // covers 20..0
black_cell b81(G2[20], P2[20], G2[17], P2[17], G3[17], P3[17]);  // covers 21..0
black_cell b82(G2[21], P2[21], G2[18], P2[18], G3[18], P3[18]);  // covers 22..0
black_cell b83(G2[22], P2[22], G2[19], P2[19], G3[19], P3[19]);  // covers 23..0
black_cell b84(G2[23], P2[23], G2[20], P2[20], G3[20], P3[20]);  // covers 24..0
black_cell b85(G2[24], P2[24], G2[21], P2[21], G3[21], P3[21]);  // covers 25..0
black_cell b86(G2[25], P2[25], G2[22], P2[22], G3[22], P3[22]);  // covers 26..0
black_cell b87(G2[26], P2[26], G2[23], P2[23], G3[23], P3[23]);  // covers 27..0
black_cell b88(G2[27], P2[27], G2[24], P2[24], G3[24], P3[24]);  // covers 28..0
black_cell b89(G2[28], P2[28], G2[25], P2[25], G3[25], P3[25]);  // covers 29..0
black_cell b90(G2[29], P2[29], G2[26], P2[26], G3[26], P3[26]);  // covers 30..0
black_cell b91(G2[30], P2[30], G2[27], P2[27], G3[27], P3[27]);  // covers 31..0

// Stage 3 fully resolves all prefixes for 32 bits
// G3[27] covers 31..0 = cout
// sum[k] uses G3[k-5] for k>=5, G2[k-2] for k>=2, G1[0] for k=1

// Sum
xor(sum[0],  P[0],  cin);
xor(sum[1],  P[1],  G1[0]);
xor(sum[2],  P[2],  G2[0]);
xor(sum[3],  P[3],  G2[1]);
xor(sum[4],  P[4],  G2[2]);
xor(sum[5],  P[5],  G2[3]);
xor(sum[6],  P[6],  G2[4]);
xor(sum[7],  P[7],  G2[5]);
xor(sum[8],  P[8],  G3[4]);
xor(sum[9],  P[9],  G3[5]);
xor(sum[10], P[10], G3[6]);
xor(sum[11], P[11], G3[7]);
xor(sum[12], P[12], G3[8]);
xor(sum[13], P[13], G3[9]);
xor(sum[14], P[14], G3[10]);
xor(sum[15], P[15], G3[11]);
xor(sum[16], P[16], G3[12]);
xor(sum[17], P[17], G3[13]);
xor(sum[18], P[18], G3[14]);
xor(sum[19], P[19], G3[15]);
xor(sum[20], P[20], G3[16]);
xor(sum[21], P[21], G3[17]);
xor(sum[22], P[22], G3[18]);
xor(sum[23], P[23], G3[19]);
xor(sum[24], P[24], G3[20]);
xor(sum[25], P[25], G3[21]);
xor(sum[26], P[26], G3[22]);
xor(sum[27], P[27], G3[23]);
xor(sum[28], P[28], G3[24]);
xor(sum[29], P[29], G3[25]);
xor(sum[30], P[30], G3[26]);
xor(sum[31], P[31], G3[27]);

assign cout = G3[27];

endmodule
*/
module KS32 (
    //input clk,
    input  [31:0] A, B,
    input cin,
    output [31:0] sum,
    output cout
);



// Stage 0: Generate & Propagate
wire [31:0] G, P;
genvar i;
generate
    for (i = 0; i < 32; i = i + 1) begin : gen_gp
        initialize ini(A[i], B[i], G[i], P[i]);
    end
endgenerate

// Stage 1 (distance=1)
wire [31:0] G1, P1;
grey_cell  b1 (G[0],  P[0],  cin,   G1[0]);

generate
    for (i = 0; i < 31; i = i + 1) begin : gen_1
         black_cell b(G[i+1], P[i+1], G[i], P[i], G1[i+1], P1[i+1]);
    end
endgenerate


// Stage 2 (distance=2)
// Each G2[k] covers k+1..0 fully including cin
wire [30:0] G2, P2;
grey_cell  b17(G1[1],  P1[1],  cin,    G2[0]);
grey_cell  b18(G1[2],  P1[2],  G1[0],  G2[1]);
black_cell b19(G1[3],  P1[3],  G2[0],  P1[1],  G2[2],  P2[2]);
black_cell b20(G1[4],  P1[4],  G2[1],  P1[2],  G2[3],  P2[3]);

generate
    for (i = 2; i < 29; i = i + 1) begin : gen_2
         black_cell b(G1[i+3], P1[i+3], G2[i], P2[i], G2[i+2], P2[i+2]);
    end
endgenerate


// Sum
xor(sum[0],  P[0],  cin);
xor(sum[1],  P[1],  G1[0]);

generate
    for (i = 0; i < 30; i = i + 1) begin : gen_3
        xor x(sum[i+2], P[i+2], G2[i]);
    end
endgenerate

assign cout = G2[30];

endmodule
