
module tb_VM8;

    reg  [7:0] x, y;
    wire [15:0] prod;

    // Reference
    wire [15:0] expected;
    assign expected = x * y;

    // DUT
    VM8 dut(
        x, y, prod
    );

    integer i, j;
    integer errors = 0;
    integer tests  = 0;

    initial begin
        $display("=== VM4 Exhaustive Testbench ===");

        errors = 0;
        tests  = 0;

        // Exhaustive: 16 × 16 = 256 cases
        for (i = 0; i < 256; i = i + 1) begin
            for (j = 0; j < 256; j = j + 1) begin
                
                x = i;
                y = j;
                #1;  // small delay

                tests = tests + 1;

                if (prod !== expected) begin
                    $display("FAIL: x=%0b y=%0b | got=%0b | expected=%0b",
                              x, y, prod, expected);
                    errors = errors + 1;
                end

            end
        end

        // Results
        $display("================================");
        $display("Total tests : %0d", tests);
        $display("Errors      : %0d", errors);

        if (errors == 0)
            $display("-- ALL TESTS PASSED --");
        else
            $display("-- FAILURES DETECTED --");

        $display("================================");

        $finish;
   end

endmodule