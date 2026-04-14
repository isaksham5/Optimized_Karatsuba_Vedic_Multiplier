
module KS8 (
    input  [7:0] x, y,
    input cin,
    output [7:0] sum,
    output cout
);

// Stage 0: G & P
wire [7:0] G, P;
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : gen_gp
        initialize ini(x[i], y[i], G[i], P[i]);
    end
endgenerate

// Stage 1 (distance=1)
wire [7:0] G1, P1;
grey_cell  b1(G[0], P[0], cin,   G1[0]);
black_cell b2(G[1], P[1], G[0], P[0], G1[1], P1[1]);
black_cell b3(G[2], P[2], G[1], P[1], G1[2], P1[2]);
black_cell b4(G[3], P[3], G[2], P[2], G1[3], P1[3]);
black_cell b5(G[4], P[4], G[3], P[3], G1[4], P1[4]);
black_cell b6(G[5], P[5], G[4], P[4], G1[5], P1[5]);
black_cell b7(G[6], P[6], G[5], P[5], G1[6], P1[6]);
black_cell b8(G[7], P[7], G[6], P[6], G1[7], P1[7]);

// Stage 2 (distance=2)
wire [6:0] G2, P2;
grey_cell  b9 (G1[1], P1[1], cin,    G2[0]);
grey_cell  b10(G1[2], P1[2], G1[0],  G2[1]);
black_cell b11(G1[3], P1[3], G2[0], P1[1], G2[2], P2[2]);
black_cell b12(G1[4], P1[4], G2[1], P1[2], G2[3], P2[3]);
black_cell b13(G1[5], P1[5], G2[2], P2[2], G2[4], P2[4]);
black_cell b14(G1[6], P1[6], G2[3], P2[3], G2[5], P2[5]);
black_cell b15(G1[7], P1[7], G2[4], P2[4], G2[6], P2[6]);

// Sum
xor(sum[0], P[0], cin);
xor(sum[1], P[1], G1[0]);
xor(sum[2], P[2], G2[0]);
xor(sum[3], P[3], G2[1]);
xor(sum[4], P[4], G2[2]);
xor(sum[5], P[5], G2[3]);
xor(sum[6], P[6], G2[4]);
xor(sum[7], P[7], G2[5]);

assign cout = G2[6];


endmodule