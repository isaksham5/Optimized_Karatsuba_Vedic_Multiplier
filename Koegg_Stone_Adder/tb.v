
module tb;

reg [3:0] x, y;
wire [3:0] sum;
wire cout;

KS4 uut(x, y, sum, cout);

initial begin
    repeat (10) begin
        x = $random % 16;
        y = $random % 16;
        #1;

        if ({cout, sum} !== (x + y ))
            $display("? ERROR: x=%b y=%b -> got=%b expected=%b",
                      x, y, {cout,sum}, x+y);
        else
            $display("? PASS: %b + %b = %b",
                      x, y, {cout,sum});
    end
end

endmodule