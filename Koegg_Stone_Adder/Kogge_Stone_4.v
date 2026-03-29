module Kogge_Stone_4(x,y,clk,sum,cout);
input [3:0] x,y;
output [3:0] sum;
input clk;
output cout;
wire [3:0] G,P;

genvar i;

generate
for(i=0; i<4; i=i+1) begin : and_xor
initialize ini(x[i],y[i],G[i],P[i]);
end
endgenerate

wire [3:0] G0_r,P0_r;

dff #(4) reg_p(clk,P,P0_r);
dff #(4) reg_g(clk,G,G0_r);

wire [2:0] G1,P1;

black_cell b0(G0_r[1],P0_r[1],G0_r[0],P0_r[0],G1[0],P1[0]);
black_cell b1(G0_r[2],P0_r[2],G0_r[1],P0_r[1],G1[1],P1[1]);
black_cell b2(G0_r[3],P0_r[3],G0_r[2],P0_r[2],G1[2],P1[2]);

wire [3:0] G1_r,P1_r;

dff #(4) reg_p1(clk,{P1,P0_r[0]},P1_r);
dff #(4) reg_g1(clk,{G1,G0_r[0]},G1_r);

wire [1:0] G2,P2;

black_cell b3(G1_r[2],P1_r[2],G1_r[0],P1_r[0],G2[0],P2[0]);
black_cell b4(G1_r[3],P1_r[3],G1_r[1],P1_r[1],G2[1],P2[1]);

wire [3:0] G2_r,P2_r;

dff #(4) reg_p2(clk,{P2,P1_r[1:0]},P2_r);
dff #(4) reg_g2(clk,{G2,G1_r[1:0]},G2_r);

wire c1, c2, c3;

assign c1 = G2_r[0];
assign c2 = G2_r[1];
assign c3 = G2_r[2];
assign cout = G2_r[3];

assign sum[0]=P2_r[0];
xor (sum[1], P2_r[1], c1);
xor (sum[2], P2_r[2], c2);
xor (sum[3], P2_r[3], c3);

endmodule