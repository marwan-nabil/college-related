function ref_on_line_negx
global polygon_
    r=[0 -1;-1 0];
    polygon_=r*polygon_;
end