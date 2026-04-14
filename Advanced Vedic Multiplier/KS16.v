module KS16 (
    //input clk,
    input  [15:0] A, B,
    input cin,
    output [15:0] sum,
    output cout
);



// Stage 0: Generate & Propagate
wire [15:0] G, P;
genvar i;
generate
    for (i = 0; i < 16; i = i + 1) begin : gen_gp
        initialize ini(A[i], B[i], G[i], P[i]);
    end
endgenerate

// Stage 1 (distance=1)
wire [15:0] G1, P1;
grey_cell  b1 (G[0],  P[0],  cin,   G1[0]);

generate
    for (i = 0; i < 15; i = i + 1) begin : gen_1
         black_cell b(G[i+1], P[i+1], G[i], P[i], G1[i+1], P1[i+1]);
    end
endgenerate


// Stage 2 (distance=2)
// Each G2[k] covers k+1..0 fully including cin
wire [14:0] G2, P2;
grey_cell  b17(G1[1],  P1[1],  cin,    G2[0]);
grey_cell  b18(G1[2],  P1[2],  G1[0],  G2[1]);
black_cell b19(G1[3],  P1[3],  G2[0],  P1[1],  G2[2],  P2[2]);
black_cell b20(G1[4],  P1[4],  G2[1],  P1[2],  G2[3],  P2[3]);

generate
    for (i = 2; i < 13; i = i + 1) begin : gen_2
         black_cell b(G1[i+3], P1[i+3], G2[i], P2[i], G2[i+2], P2[i+2]);
    end
endgenerate


// Sum
xor(sum[0],  P[0],  cin);
xor(sum[1],  P[1],  G1[0]);
xor(sum[2],  P[2],  G2[0]);
xor(sum[3],  P[3],  G2[1]);
xor(sum[4],  P[4],  G2[2]);
xor(sum[5],  P[5],  G2[3]);
xor(sum[6],  P[6],  G2[4]);
xor(sum[7],  P[7],  G2[5]);
xor(sum[8],  P[8],  G2[6]);
xor(sum[9],  P[9],  G2[7]);
xor(sum[10], P[10], G2[8]);
xor(sum[11], P[11], G2[9]);
xor(sum[12], P[12], G2[10]);
xor(sum[13], P[13], G2[11]);
xor(sum[14], P[14], G2[12]);
xor(sum[15], P[15], G2[13]);

assign cout = G2[14];

endmodule
