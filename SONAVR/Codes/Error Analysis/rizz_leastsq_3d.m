function v = rizz_leastsq_3d(p0,p1,ray0,ray1)

R0 = eye(3)-[ray0*ray0']; %Subtract Identity matrix with Outer product
R1 = eye(3)-[ray1*ray1'];

v = linsolve(R0+R1,[(R0'*p0)+(R1'*p1)]);