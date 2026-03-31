`timescale 1ns/1ps

module tb_vedic_4x4;

reg  [3:0] x, y;
wire [7:0] prod;

integer i, j;
integer errors;

// Instantiate DUT
karatsuba_4x4_struct uut (x,y,prod);

initial begin
    errors = 0;

    // Loop through all combinations (0 to 15)
    for(i = 0; i < 16; i = i + 1) begin
        for(j = 0; j < 16; j = j + 1) begin
            
            x = i;
            y = j;
            #5;  // wait for propagation
            
            if (prod !== (i * j)) begin
                $display("? ERROR: x=%b y=%b -> got=%b expected=%b (%0d)",
                          x, y, prod, (i*j), (i*j));
                errors = errors + 1;
            end
            else begin
                $display("? PASS: x=%b y=%b -> prod=%b (%0d)",
                          x, y, prod, prod);
            end
        end
    end

    // Final result
    if (errors == 0)
        $display("\n?? ALL TESTS PASSED!");
    else
        $display("\n?? TOTAL ERRORS = %0d", errors);

    $finish;
end

endmodule
