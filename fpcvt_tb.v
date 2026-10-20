`timescale 1ns / 1ps
module tb;
  // 1. Declare inputs (reg) and outputs (wire)
  reg [11:0] D_in;
  wire S_out;
  wire [2:0] E_out;
  wire [3:0] F_out;

  // 2. Instantiate UUT (FPCVT)
  fpcvt uut ( .D(D_in), .S(S_out), .E(E_out), .F(F_out) );

  // 3. Test sequence
  initial begin
    $display("Time\t D_in\t\t S_out\t E_out\t F_out");
    $display("----------------------------------------");

    // Test Case: Apply stimulus, wait, then display
    D_in = 12'b000001111101; #10;
    $display("%d\t %b\t %b\t %b\t %b\t", $time, D_in, S_out, E_out, F_out);

    // TODO: Add additional test cases here...
    
     D_in = 12'b000000000110; #10;
     $display("%d\t %b\t %b\t %b\t %b\t", $time, D_in, S_out, E_out, F_out);
     
     
      D_in = 12'b100000000000; #10;
       $display("%d\t %b\t %b\t %b\t %b\t", $time, D_in, S_out, E_out, F_out);
       
       D_in = 12'b000000101100; #10;
       $display("%d\t %b\t %b\t %b\t %b\t", $time, D_in, S_out, E_out, F_out);
       
       D_in = 12'b000000101110; #10;
       $display("%d\t %b\t %b\t %b\t %b\t", $time, D_in, S_out, E_out, F_out);
       
        D_in = 12'b000001111101; #10;
        $display("%d\t %b\t %b\t %b\t %b\t", $time, D_in, S_out, E_out, F_out);
        
        
        D_in = 12'b011111111111; #10;
        $display("%d\t %b\t %b\t %b\t %b\t", $time, D_in, S_out, E_out, F_out);
    
    

    $stop; // 4. End simulation
  end
endmodule
