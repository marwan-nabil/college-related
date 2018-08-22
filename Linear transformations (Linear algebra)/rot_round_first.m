function rot_round_first()
global polygon_;
x_disp_from_origin=polygon_(1,1);
y_disp_from_origin=polygon_(2,1);

polygon_=[polygon_(1,:)-x_disp_from_origin ;polygon_(2,:)-y_disp_from_origin]; % fisrt vertex now on origin
rotate_poly();  % rotation
polygon_=[polygon_(1,:)+x_disp_from_origin ;polygon_(2,:)+y_disp_from_origin]; % returned to position

end