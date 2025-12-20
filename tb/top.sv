/*=====================================================
File name: top.sv
Author: igomsa
Description: Top template
Date created: 18/12/25
=====================================================*/

`include "uvm_macros.svh"
import uvm_pkg::*;

module top();

   template_interface intf(); //Interface instantiated

   our_design uut(); //RTL instantiated

   initial begin
      //set
      uvm_config_db #(virtual template_interface)::set(null, "*", "intf", intf);

   end

   initial begin
      run_test("template_test");
   end

endmodule // top
