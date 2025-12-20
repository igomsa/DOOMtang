/*=====================================================
File name: test.sv
Author: igomsa
Description: Top template
Date created: 18/12/25
=====================================================*/

class template_test extends uvm_test;
   `uvm_component_utils(template_test)

   //constructor
   function new (string name = "template_test", uvm_component parent = null);
      super.new(name, parent);
   endfunction // new

   function void build_phase(uvm_phase phase);
      //build other components
   endfunction // build_phase

   function void connect_phase(uvm_phase phase);
      //necessary connections
   endfunction // connect_phase

   task run_phase(uvm_phase phase);
      //Main logic
   endtask // run_phase


endclass // test_template
