module KS4 (
    input  [3:0] A, B,
    input cin,
    output [3:0] sum,
    output cout
);

wire [7:0] G, P;
genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin : gen_gp
        initialize ini(A[i], B[i], G[i], P[i]);
    end
endgenerate

// Stage 1 (distance=1)
wire [3:0] G1, P1;
grey_cell  b1(G[0], P[0], cin,   G1[0]);
black_cell b2(G[1], P[1], G[0], P[0], G1[1], P1[1]);
black_cell b3(G[2], P[2], G[1], P[1], G1[2], P1[2]);
black_cell b4(G[3], P[3], G[2], P[2], G1[3], P1[3]);

// Stage 2 (distance=2)
wire [2:0] G2, P2;
grey_cell  b9 (G1[1], P1[1], cin,    G2[0]);
grey_cell  b10(G1[2], P1[2], G1[0],  G2[1]);
black_cell b11(G1[3], P1[3], G2[0], P1[1], G2[2], P2[2]);

// Sum
xor(sum[0], P[0], cin);
xor(sum[1], P[1], G1[0]);
xor(sum[2], P[2], G2[0]);
xor(sum[3], P[3], G2[1]);

assign cout = G2[2];

/*// Step 1: Generate & Propagate
wire [3:0] G, P;

genvar i;

generate
for(i=0; i<4; i=i+1) begin : and_xor
initialize ini(x[i],y[i],G[i],P[i]);
end
endgenerate

// Step 2: Stage 1 (distance = 1)
wire [2:0] G1, P1;

grey_cell b0(G[1],P[1],G[0],G1[0]);
black_cell b1(G[2],P[2],G[1],P[1],G1[1],P1[1]);
black_cell b2(G[3],P[3],G[2],P[2],G1[2],P1[2]);

// Step 3: Stage 2 (distance = 2)
wire [1:0] G2, P2;

grey_cell b3(G1[1],P1[1],G1[0],G2[0]);
grey_cell b4(G1[2],P1[2],G1[1],G2[1]);


assign cout = G2[1];

// Step 5: Sum
assign sum[0] = P[0];
assign sum[1] = P[1] ^ c1;
assign sum[2] = P[2] ^ c2;
assign sum[3] = P[3] ^ c3;
*/
endmodule

