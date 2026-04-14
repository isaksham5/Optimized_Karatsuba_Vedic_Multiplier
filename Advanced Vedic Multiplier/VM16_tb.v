module tb_VM16;

    reg  [15:0] x, y;
    wire [31:0] prod;

    wire [31:0] expected;
    assign expected = x * y;

    VM16 dut(x, y, prod);

    integer errors = 0;
    integer tests  = 0;

    task check;
        input [15:0] a, b;
        begin
            x = a; y = b;
            #20;
            tests = tests + 1;
            if (prod !== expected) begin
                $display("ERROR: A=%0d B=%0d -> P=%0d Expected=%0d", a, b, prod, expected);
                errors = errors + 1;
            end
        end
    endtask

    integer i, j;

    initial begin
        $display("=== VM16 Testbench ===");
        errors = 0; tests = 0;
        x = 0; y = 0;
        #10;

        $display("-- Corner Cases --");
        check(0, 0);
        check(1, 0);
        check(0, 1);
        check(1, 1);
        check(16'hFFFF, 1);
        check(1, 16'hFFFF);
        check(16'hFFFF, 16'hFFFF);
        check(16'hFF00, 16'hFF00);
        check(16'h00FF, 16'h00FF);
        check(16'hFF00, 16'h00FF);
        check(16'h00FF, 16'hFF00);
        check(16'hAAAA, 16'h5555);
        check(16'h5555, 16'hAAAA);
        check(16'hAAAA, 16'hAAAA);
        check(16'h5555, 16'h5555);

        $display("-- Powers of 2 --");
        for (i = 0; i < 16; i = i + 1) begin
            check(16'h1 << i, 1);
            check(1, 16'h1 << i);
            check(16'h1 << i, 16'h1 << i);
        end

        $display("-- Boundary: 8-bit split points --");
        check(16'h0100, 16'h0100);
        check(16'hFF00, 16'h0100);
        check(16'h00FF, 16'h0100);
        check(16'h0100, 16'hFF00);
        check(16'h0100, 16'h00FF);
        check(16'hFFFF, 16'h0100);
        check(16'h0100, 16'hFFFF);

         $display("-- Random Tests (200000) --");
        repeat (200000)
            check($random, $random);
        $display("==============================");
        $display("Total tests : %0d", tests);
        $display("Errors      : %0d", errors);
        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("FAILURES DETECTED");
        $display("==============================");

        $finish;
    end

endmodule
