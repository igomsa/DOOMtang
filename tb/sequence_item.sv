/*=====================================================
File name: sequence_item.sv
Author: igomsa
Description: Sequence Item template
Date created: 18/12/25
=====================================================*/

class template_packet extends uvm_sequence_item;
   `uvm_object_utils(template_packet)

   //request
   rand bit [7:0] input_1;
   rand bit [7:0] input_2;

   //response
   bit [15:0]     output;

   function new(string name = "template_packet")
     super.new(name);
   endfunction // new


endclass // template_packet
