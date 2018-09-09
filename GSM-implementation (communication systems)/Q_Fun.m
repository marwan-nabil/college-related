%---------------------------
%definition of the Q-function
function ans = Q_Fun(x)
ans = 0.5*erfc(x/sqrt(2));
end