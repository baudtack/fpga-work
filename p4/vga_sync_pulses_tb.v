module vga_sync_pulses_tb();  

  reg clock = 1'b0;

  always #2 clock <= ~clock;

  wire [9:0] c, r;

  vga_sync_pulses vsp
   (.clock(clock),
   .ohsync(ohsync),
   .ovsync(ovsync),
   .col(c),
   .row(r));

   initial begin
     $dumpfile("vga_sync_pulses_tb.vcd");
     $dumpvars;
     $display("starting tb");
     #20000
     $finish();
   end

endmodule
