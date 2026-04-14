module tb_KS64;

    reg  [63:0] x, y;
    reg         cin;
    wire [63:0] sum;
    wire        cout;

    wire [64:0] expected;
    assign expected = x + y + cin;

    KS64 uut (
        x, y, cin, sum, cout
    );

    integer errors = 0;
    integer tests  = 0;

    task check;
        input [63:0] a, b;
        input        c;
        begin
            x = a; y = b; cin = c;
            #20;
            tests = tests + 1;
            if ({cout, sum} !== expected) begin
                $display("FAIL: x=%h y=%h cin=%0b | got=%h cout=%0b | expected=%h",
                          a, b, c, sum, cout, expected);
                errors = errors + 1;
            end
        end
    endtask

    integer i;

    initial begin
        $display("=== KS64 Testbench ===");
        errors = 0; tests = 0;
        x = 0; y = 0; cin = 0;
        #10;

        $display("-- Corner Cases --");

        // Zeros
        check(64'h0000000000000000, 64'h0000000000000000, 0);
        check(64'h0000000000000000, 64'h0000000000000000, 1);

        // All ones
        check(64'hFFFFFFFFFFFFFFFF, 64'hFFFFFFFFFFFFFFFF, 0);
        check(64'hFFFFFFFFFFFFFFFF, 64'hFFFFFFFFFFFFFFFF, 1);

        // Max + 0
        check(64'hFFFFFFFFFFFFFFFF, 64'h0000000000000000, 0);
        check(64'hFFFFFFFFFFFFFFFF, 64'h0000000000000000, 1);
        check(64'h0000000000000000, 64'hFFFFFFFFFFFFFFFF, 0);
        check(64'h0000000000000000, 64'hFFFFFFFFFFFFFFFF, 1);

        // Overflow boundary
        check(64'hFFFFFFFFFFFFFFFF, 64'h0000000000000001, 0);
        check(64'h0000000000000001, 64'hFFFFFFFFFFFFFFFF, 0);
        check(64'h8000000000000000, 64'h8000000000000000, 0);
        check(64'h8000000000000000, 64'h7FFFFFFFFFFFFFFF, 0);
        check(64'h8000000000000000, 64'h7FFFFFFFFFFFFFFF, 1);
        check(64'h7FFFFFFFFFFFFFFF, 64'h0000000000000001, 0);
        check(64'h7FFFFFFFFFFFFFFF, 64'h0000000000000001, 1);

        // Alternating bits
        check(64'hAAAAAAAAAAAAAAAA, 64'h5555555555555555, 0);
        check(64'hAAAAAAAAAAAAAAAA, 64'h5555555555555555, 1);
        check(64'h5555555555555555, 64'hAAAAAAAAAAAAAAAA, 0);
        check(64'h5555555555555555, 64'hAAAAAAAAAAAAAAAA, 1);
        check(64'hAAAAAAAAAAAAAAAA, 64'hAAAAAAAAAAAAAAAA, 0);
        check(64'h5555555555555555, 64'h5555555555555555, 0);

        // Byte boundaries
        check(64'h00000000000000FF, 64'h0000000000000001, 0);
        check(64'h000000000000FF00, 64'h0000000000000100, 0);
        check(64'h0000000000FF0000, 64'h0000000000010000, 0);
        check(64'h00000000FF000000, 64'h0000000001000000, 0);
        check(64'h000000FF00000000, 64'h0000000100000000, 0);
        check(64'h0000FF0000000000, 64'h0000010000000000, 0);
        check(64'h00FF000000000000, 64'h0001000000000000, 0);
        check(64'hFF00000000000000, 64'h0100000000000000, 0);
        check(64'hFFFFFFFFFFFFFFFF, 64'h0000000000000001, 1);

        // Half-word and word boundaries
        check(64'h00000000FFFFFFFF, 64'h0000000000000001, 0);
        check(64'hFFFFFFFF00000000, 64'h0000000100000000, 0);
        check(64'h00000000FFFFFFFF, 64'h00000000FFFFFFFF, 0);
        check(64'hFFFFFFFF00000000, 64'hFFFFFFFF00000000, 0);
        check(64'h0000FFFFFFFFFFFF, 64'h0000000000000001, 0);
        check(64'hFFFF000000000000, 64'h0001000000000000, 0);

        $display("-- Powers of 2 --");
        for (i = 0; i < 64; i = i + 1) begin
            check(64'h1 << i, 64'h0000000000000000, 0);
            check(64'h0000000000000000, 64'h1 << i, 0);
            check(64'h1 << i, 64'h1 << i, 0);
            check(64'h1 << i, 64'h1 << i, 1);
        end

        $display("-- Carry Ripple --");
        check(64'h7FFFFFFFFFFFFFFF, 64'h7FFFFFFFFFFFFFFF, 0);
        check(64'h7FFFFFFFFFFFFFFF, 64'h7FFFFFFFFFFFFFFF, 1);
        check(64'hFFFFFFFFFFFFFFFE, 64'h0000000000000001, 0);
        check(64'hFFFFFFFFFFFFFFFE, 64'h0000000000000002, 0);
        check(64'h0FFFFFFFFFFFFFFF, 64'h0000000000000001, 0);
        check(64'h00FFFFFFFFFFFFFF, 64'h0000000000000001, 0);
        check(64'h000FFFFFFFFFFFFF, 64'h0000000000000001, 0);
        check(64'h0000FFFFFFFFFFFF, 64'h0000000000000001, 0);
        check(64'h00000FFFFFFFFFFF, 64'h0000000000000001, 0);
        check(64'h000000FFFFFFFFFF, 64'h0000000000000001, 0);
        check(64'h0000000FFFFFFFFF, 64'h0000000000000001, 0);
        check(64'h00000000FFFFFFFF, 64'h0000000000000001, 0);
        // Carry across each nibble boundary
        check(64'hEFFFFFFFFFFFFFFF, 64'h1000000000000000, 0);
        check(64'hFFFFFFFF00000000, 64'h0000000100000000, 0);
        check(64'hFFFFFFFFFFFF0000, 64'h0000000000010000, 0);

        $display("-- Random Tests (100000) --");
        repeat (100000) begin
            check({$random,$random}, {$random,$random}, $random % 2);
        end
	$display("-- Exhaustive 16-bit range (x,y = 0..65535) --");
        begin : sweep
            reg [16:0] a, b;
            for (a = 0; a < 256; a = a + 1) begin
                for (b = 0; b < 256 ; b = b + 1) begin
                    check(a, b, 0);
                    check(a, b, 1);
                end
            end
        end
        $display("==============================");
        $display("Total tests : %0d", tests);
        $display("Errors      : %0d", errors);
        if (errors == 0)
            $display("ALL TESTS PASSED ?");
        else
            $display("FAILURES DETECTED ?");
        $display("==============================");

        $finish;
    end

endmodule
