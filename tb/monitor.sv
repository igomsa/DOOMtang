/*=====================================================
File name: monitor.sv
Author: igomsa
Description: Monitor template
Date created: 18/12/25
=====================================================*/
class template_monitor extends uvm_monitor;

   `uvm_component_utils(template_monitor)

   template_interface intf();

   function new(string name = "template_monitor", uvm_component parent = null);
      super.new(name, parent);
   endfunction // new

   function void build_phase(uvm_phase phase);
      // get  method
      uvm_config_db #(virtual template_interface)::get(null, "*", "intf",intf)
   endfunction // build_phase

   function void connect_phase(uvm_phase phase);
   endfunction // connect_phase

   task run_phase(uvm_phase phase);
   endtask // run_phase


endclass // monitor
