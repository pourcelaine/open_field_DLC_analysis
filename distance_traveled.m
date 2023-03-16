function [z] = OS_dir_ID(x, y)
Xsq = diff(x).^2;
Ysq = diff(y).^2;
Zsq = Xsq + Ysq;
z = sum(sqrt(Zsq));

