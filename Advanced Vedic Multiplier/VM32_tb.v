module tb_VM32;

    reg  [31:0] x, y;
    wire [63:0] prod;

    wire [63:0] expected;
    assign expected = x * y;

    VM32 dut(x, y, prod);

    integer errors = 0;
    integer tests  = 0;

    task check;
        input [31:0] a, b;
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
        $display("=== VM32 Testbench ===");
        errors = 0; tests = 0;
        x = 0; y = 0;
        #10;

        $display("-- Corner Cases --");
        check(0, 0);
        check(1, 0);
        check(0, 1);
        check(1, 1);
        check(32'hFFFFFFFF, 1);
        check(1, 32'hFFFFFFFF);
        check(32'hFFFFFFFF, 32'hFFFFFFFF);
        check(32'hFFFF0000, 32'hFFFF0000);
        check(32'h0000FFFF, 32'h0000FFFF);
        check(32'hFFFF0000, 32'h0000FFFF);
        check(32'h0000FFFF, 32'hFFFF0000);
        check(32'hAAAAAAAA, 32'h55555555);
        check(32'h55555555, 32'hAAAAAAAA);
        check(32'hAAAAAAAA, 32'hAAAAAAAA);
        check(32'h55555555, 32'h55555555);

        $display("-- Powers of 2 --");
        for (i = 0; i < 32; i = i + 1) begin
            check(32'h1 << i, 1);
            check(1, 32'h1 << i);
            check(32'h1 << i, 32'h1 << i);
        end

        $display("-- Boundary: 16-bit split points --");
        check(32'h00010000, 32'h00010000);
        check(32'hFFFF0000, 32'h00010000);
        check(32'h0000FFFF, 32'h00010000);
        check(32'h00010000, 32'hFFFF0000);
        check(32'h00010000, 32'h0000FFFF);
        check(32'hFFFFFFFF, 32'h00010000);
        check(32'h00010000, 32'hFFFFFFFF);

        $display("-- Small exhaustive (0..255 x 0..255) --");
        for (i = 0; i < 256; i = i + 1)
            for (j = 0; j < 256; j = j + 1)
                check(i, j);

        $display("-- Random Tests (100000) --");
        repeat (100000)
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
