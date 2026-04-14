module VM64(
input [63:0] x,y,
output [127:0] prod
);

wire[63:0] p0,p1,p2,p3;

VM32 v1(x[31:0],y[31:0],p0);
VM32 v2(x[31:0],y[63:32],p1);
VM32 v3(x[63:32],y[31:0],p2);
VM32 v4(x[63:32],y[63:32],p3);

wire [63:0] p12, p012;
wire c12, c012, cout;

KS64 a0(p1,p2,1'b0,p12,c12);
assign prod[31:0] = p0[31:0];

KS64 a1(p12,{32'b0,p0[63:32]},1'b0,p012,c012);
assign prod[63:32] = p012[31:0];

wire s,c;

half_adder HA1(c12,c012,s,c);
KS64 a2(p3,{30'b0,c,s,p012[63:32]},1'b0,prod[127:64],cout);

endmodule
