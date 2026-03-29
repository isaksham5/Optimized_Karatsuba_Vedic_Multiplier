module KS16_tb;
reg [15:0] x, y;
reg cin;
wire [15:0] sum;
wire cout;

KS16 uut(x, y, cin, sum, cout);

initial begin
    repeat (10) begin
        x = $random % 64;
        y = $random % 64;
        cin = $random % 2;
        #1;

        if (~cout) begin
	if (sum != (x + y + cin))
            $display("? ERROR: x=%b y=%b cin=%b -> got=%b expected=%b",
                      x, y, cin, {cout,sum}, x+y+cin);
        else
            $display("? PASS: %b + %b + %b = %b",
                      x, y, cin, {cout,sum});
    	end
	else begin
	if ({cout,sum} != (x + y + cin))
            $display("? ERROR: x=%b y=%b cin=%b -> got=%b expected=%b",
                      x, y, cin, {cout,sum}, x+y+cin);
        else
            $display("? PASS: %b + %b + %b = %b",
                      x, y, cin, {cout,sum});
	end
end
end

endmodule
