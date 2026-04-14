module VM128(
input [127:0] x,y,
output [255:0] prod
);

wire[127:0] p0,p1,p2,p3;

VM64 v1(x[63:0],y[63:0],p0);
VM64 v2(x[63:0],y[127:64],p1);
VM64 v3(x[127:64],y[63:0],p2);
VM64 v4(x[127:64],y[127:64],p3);

wire [127:0] p12, p012;
wire c12, c012, cout;

KS128 a0(p1,p2,1'b0,p12,c12);
assign prod[63:0] = p0[63:0];

KS128 a1(p12,{64'b0,p0[127:64]},1'b0,p012,c012);
assign prod[127:64] = p012[63:0];

wire s,c;

half_adder HA1(c12,c012,s,c);
KS128 a2(p3,{62'b0,c,s,p012[127:64]},1'b0,prod[255:128],cout);

endmodule
