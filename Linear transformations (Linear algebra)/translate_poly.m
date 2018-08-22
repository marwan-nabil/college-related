
function translate_poly()
global polygon_;
xtrans=input('translation amount in x-direction >>');
ytrans=input('translation amount in y-direction >>');
polygon_=[polygon_(1,:)+xtrans ;polygon_(2,:)+ytrans];
end