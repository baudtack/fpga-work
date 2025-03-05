module sync_to_count
  #(parameter TOTAL_COLS = 800,
    parameter TOTAL_ROWS = 525)
  (input clock,
   input vgahsync,
   input vgavsync,
   output reg ohsync = 0,
   output reg ovsync = 0,
   output reg [9:0] col = 0, // 10 bits for 1024
   output reg [9:0] row = 0); 

  wire framestart;

  always @(posedge clock)
  begin
    ohsync <= vgahsync;
    ovsync <= vgavsync;
  end

  always @(posedge clock) begin
    if (framestart == 1'b1) begin
      col <= 0;
      row <= 0;
    end else begin
      if (col == TOTAL_COLS - 1) begin
        if (row == TOTAL_COLS - 1) begin
          row <= 0;
        end else begin
          row <= row + 1;
        end
        col <= 0;
      end else begin
        col <= col + 1;
      end
    end

    assign framestart = (~ovsync & vgavsync);
    
  end

endmodule
