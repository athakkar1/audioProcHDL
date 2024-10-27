module i2s_tb(
);
bit mclk;
bit bclk;
bit pbdat;
bit pblrc;
bit recdat;
bit reclrc;
bit [23 : 0] pbword;
bit [23 : 0] recword_left;
bit [23 : 0] recword_right;
bit reset;
integer lrccnt = 0;
bit lrcinternal = 0;
bit [23 : 0] recdat_i = 0;
integer errnum = 0;

initial begin
  pbword = $urandom_range(0, 24'hFFFFFF);
  mclk = 0;
  forever begin
    #5ns mclk = ~mclk;
  end
end

initial begin
  #1000ns reset = 1;
  #1100ns reset = 0;
end



i2s #(
    .data_len(24)
  ) i2s_instance (
    .mclk(mclk),
    .bclk(bclk),
    .pbdat(pbdat),
    .pblrc(pblrc),
    .recdat(pbdat),
    .reclrc(reclrc),
    .pbword_left(pbword),
    .pbword_right(pbword),
    .recword_left(recword_left),
    .recword_right(recword_right),
    .reset(reset) 
  );

  always @(posedge bclk) begin
    if(lrccnt == 0) begin
      pbword = $urandom_range(0, 24'hFFFFFF);
      lrccnt = lrccnt + 1;
    end else if (lrccnt != 25) begin
      recdat_i[0] = recdat;
      recdat_i = {recdat_i[22:0], recdat};
      lrccnt = lrccnt + 1;
    end else if (lrccnt == 25) begin
      if(reclrc == 0) begin
        if(recdat_i != recword_left) begin
          errnum = errnum + 1;
        end
      end else begin
        if(recdat_i != recword_right) begin
          errnum = errnum + 1;
        end
      end
      lrccnt = 0;
    end
  end

  assign recdat = pbdat;
endmodule : i2s_tb
