module tb_2x2;

reg [1:0] x, y;
wire [3:0] prod;

karatsuba_2x2_struct uut(x, y, prod);

initial begin
    repeat (10) begin
        x = $random % 4;
        y = $random % 4;
        #1;

        if (prod !== (x * y))
            $display("? ERROR: x=%b y=%b -> got=%b expected=%b",
                      x, y, prod, x*y);
        else
            $display("? PASS: %b * %b = %b",
                      x, y, prod);
    end
end

endmodule