/*=====================================================
File name: agent.sv
Author: igomsa
Description: Agent template
Date created: 18/12/25
=====================================================*/

class template_agent extends uvm_agent;
   `uvm_component_utils(template_agent)

   function new (string name = "template_agent", uvm_component parent = null);
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


endclass // agent
