module vga_sync_pulses
  #(parameter TOTAL_COLS = 800,
    parameter TOTAL_ROWS = 525,
    parameter ACTIVE_COLS = 640,
    parameter ACTIVE_ROWS = 480)
  (input clock,
   output hsync,
   output vsync,
   output reg [9:0] col = 0,
   output reg [9:0] row = 0);

  always @(posedge clock) begin
    if (col == TOTAL_COLS - 1) begin
      col <= 0;
      if (row == TOTAL_ROWS - 1) begin
        row <= 0;
      end else begin
        row <= row + 1;
      end
    end else begin
      col <= col + 1;
    end
  end

  assign hsync = col < ACTIVE_COLS ? 1'b1 : 1'b0;
  assign vsync = row < ACTIVE_ROWS ? 1'b1 : 1'b0;

endmodule
