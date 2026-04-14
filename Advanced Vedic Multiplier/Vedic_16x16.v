module VM16(
input [15:0] x,y,
output [31:0] prod
);

wire[15:0] p0,p1,p2,p3;

VM8 v1(x[7:0],y[7:0],p0);
VM8 v2(x[7:0],y[15:8],p1);
VM8 v3(x[15:8],y[7:0],p2);
VM8 v4(x[15:8],y[15:8],p3);

wire [15:0] p12, p012;
wire c12, c012, cout;

KS16 a0(p1,p2,1'b0,p12,c12);
assign prod[7:0] = p0[7:0];

KS16 a1(p12,{8'b0,p0[15:8]},1'b0,p012,c012);
assign prod[15:8] = p012[7:0];

wire s,c;

half_adder HA1(c12,c012,s,c);
KS16 a2(p3,{6'b0,c,s,p012[15:8]},1'b0,prod[31:16],cout);

endmodule
