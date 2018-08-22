
function rotate_poly()
global polygon_;
angle=input('rotation angle in degrees >>');
r=[cos(angle)  -sin(angle); sin(angle)  cos(angle)];
polygon_=r*polygon_;
end