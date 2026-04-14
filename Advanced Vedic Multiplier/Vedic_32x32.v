module VM32(
input [31:0] x,y,
output [63:0] prod
);

wire[31:0] p0,p1,p2,p3;

VM16 v1(x[15:0],y[15:0],p0);
VM16 v2(x[15:0],y[31:16],p1);
VM16 v3(x[31:16],y[15:0],p2);
VM16 v4(x[31:16],y[31:16],p3);

wire [31:0] p12, p012;
wire c12, c012, cout;

KS32 a0(p1,p2,1'b0,p12,c12);
assign prod[15:0] = p0[15:0];

KS32 a1(p12,{16'b0,p0[31:16]},1'b0,p012,c012);
assign prod[31:16] = p012[15:0];

wire s,c;

half_adder HA1(c12,c012,s,c);
KS32 a2(p3,{14'b0,c,s,p012[31:16]},1'b0,prod[63:32],cout);

endmodule
