function integer clog2(input integer x);
  begin
    x = x - 1;
    for (clog2 = 0; x > 0; clog2 = clog2 + 1) begin
      x = x >> 1;
    end
  end
endfunction
