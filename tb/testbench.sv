// TOP MODULE --------------------------------------------------------
module verilog_testbench();

   //Inputs
   reg IN_A, IN_B, IN_CLK, IN_EN;

   //Outputs
   reg OUT_Z, OUT_EN;

   //UUT instance
   simple_adder uut(


                    );

   always #1 IN_CLK = ~IN_CLK;

   // TEST MODULE --------------------------------------------------------
   initial begin
      // DRIVER MODULE --------------------------------------------------------
      IN_CLK = 1'b0;

      #10;

      IN_A  = 1'b0;
      IN_B  = 1'b0;
      IN_EN = 1'b0;

      #10;

      // SEQUENCE MODULE --------------------------------------------------------
      repeat(100)
        begin
           // PACKET MODULE --------------------------------------------------------
           IN_A  = $random;
           IN_B  = $random;
           IN_EN = $random;
           // PACKET MODULE --------------------------------------------------------
           #5;
        end
      // SEQUENCE MODULE --------------------------------------------------------
      // DRIVER MODULE --------------------------------------------------------

      #30;
      $finish;

   end
   // TEST MODULE --------------------------------------------------------


endmodule
// TOP MODULE --------------------------------------------------------
