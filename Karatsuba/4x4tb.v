module tb_4x4;

reg [3:0] x, y;
wire [7:0] prod;

vedic_multiplier_4bit uut(x, y, prod);

initial begin
    repeat (10) begin
        x = $random % 16;
        y = $random % 16;
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