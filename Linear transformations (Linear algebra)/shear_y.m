
function shear_y()
global polygon_;
shear=input('enter the shear in y direction >>');
r=[1 0;shear 1];
polygon_=r*polygon_;
end

