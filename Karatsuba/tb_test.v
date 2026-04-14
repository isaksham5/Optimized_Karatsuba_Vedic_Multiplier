module tb_ks4;

reg [3:0] a, b;
wire [3:0] sum;
wire cout;

KS4 uut(a,b,1'b0,sum,cout);

initial begin
    a = 4'b1111;
    b = 4'b1111;
    #5;
    $display("sum=%b cout=%b", sum, cout); // should be 1110,1
end

endmodule
