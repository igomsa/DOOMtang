/*=====================================================
File name: sequencer.sv
Author: igomsa
Description: Sequencer template
Date created: 18/12/25
=====================================================*/

class template_sequencer extends uvm_sequencer;
//#(sequence_item_template);
   `uvm_component_utils(template_sequencer)

   function new(string name = "template_sequencer", uvm_component parent = null);
      super.new(name, parent);
   endfunction // new

   function void build_phase(uvm_phase phase);
   endfunction // build_phase

   function void connect_phase(uvm_phase phase);
   endfunction // connect_phase

   task run_phase(uvm_phase phase);
   endtask // run_phase




endclass // sequencer
