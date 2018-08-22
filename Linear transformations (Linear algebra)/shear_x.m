
function shear_x()
global polygon_;
shear=input('enter the shear in x direction >>');
R=[1 shear;0 1];
polygon_=r*polygon_;
end
