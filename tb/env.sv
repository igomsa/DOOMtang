/*=====================================================
File name: env.sv
Author: igomsa
Description: Env template
Date created: 18/12/25
=====================================================*/

class template_env extends uvm_env;

   `uvm_component_utils(template_env)

   function new (string name = "template_env", uvm_component parent = null);
      super.new(name, paremt);
   endfunction // new

   function void build_phase(uvm_phase phase);
   endfunction // build_phase

   function void connect_phase(uvm_phase phase);
   endfunction // connect_phase

   task run_phase(uvm_phase phase);
   endtask // run_phase



endclass // env
