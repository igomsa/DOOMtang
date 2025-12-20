/*=====================================================
File name: sequence.sv
Author: igomsa
Description: Sequence template
Date created: 18/12/25
=====================================================*/

class template_sequence extends uvm_sequence;
   `uvm_object_utils(template_sequence);

   function new (string name = "template_sequence");
     super.new(name);
   endfunction // new

   task body();
   endtask // body


endclass; // template_sequence
