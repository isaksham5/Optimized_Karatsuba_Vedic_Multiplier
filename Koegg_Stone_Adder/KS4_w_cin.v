module KS4_w_cin (
    input  [3:0] x, y,
    input  cin,
    output [3:0] sum,
    output cout
);

// Step 1: Generate & Propagate
wire [3:0] G, P;

genvar i;

generate
for(i=0; i<4; i=i+1) begin : and_xor
initialize ini(x[i],y[i],G[i],P[i]);
end
endgenerate

// Step 2: Stage 1 (distance = 1)
wire [2:0] G1, P1;

black_cell b0(G[1],P[1],G[0],P[0],G1[0],P1[0]);
black_cell b1(G[2],P[2],G[1],P[1],G1[1],P1[1]);
black_cell b2(G[3],P[3],G[2],P[2],G1[2],P1[2]);

// Step 3: Stage 2 (distance = 2)
wire [1:0] G2, P2;

black_cell b3(G1[1],P1[1],G1[0],P1[0],G2[0],P2[0]);
black_cell b4(G1[2],P1[2],G1[1],P1[1],G2[1],P2[1]);

// Step 4: Carry computation
wire c0, c1, c2, c3;

assign c0 = cin;
assign c1 = G[0]  | (P[0]  & cin);
assign c2 = G1[0] | (P1[0] & cin);
assign c3 = G2[0] | (P2[0] & cin);
assign cout = G2[1] | (P2[1] & cin);

// Step 5: Sum
assign sum[0] = P[0] ^ c0;
assign sum[1] = P[1] ^ c1;
assign sum[2] = P[2] ^ c2;
assign sum[3] = P[3] ^ c3;

endmodule