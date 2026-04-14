module VM8(
input [7:0] x,y,
output [15:0] prod
);

wire[7:0] p0,p1,p2,p3;

VM4 v1(x[3:0],y[3:0],p0);
VM4 v2(x[3:0],y[7:4],p1);
VM4 v3(x[7:4],y[3:0],p2);
VM4 v4(x[7:4],y[7:4],p3);

wire [7:0] p12, p012;
wire c12, c012, cout;

KS8 a0(p1,p2,1'b0,p12,c12);
assign prod[3:0] = p0[3:0];

KS8 a1(p12,{4'b0,p0[7:4]},1'b0,p012,c012);
assign prod[7:4] = p012[3:0];

wire s,c;
half_adder HA1(c12,c012,s,c);
KS8 a2(p3,{2'b0,c,s,p012[7:4]},1'b0,prod[15:8],cout);

endmodule
