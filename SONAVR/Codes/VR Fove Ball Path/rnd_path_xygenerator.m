Nsteps = input('how many steps do you want?')
x = zeros(1,Nsteps);

for k = 1:Nsteps 
    x(1,k+1)= x(k)+ randn(1,1);
    if x(1,k+1)> x_bounds(k+1,1)
        x(1,k+1)=x_bounds(k+1,1)-abs(x_bounds(k+1,1)-x(1,k+1));
    else
        x(1,k+1)=-x_bounds(k+1,1)+abs(-x_bounds(k+1,1)-x(1,k+1));
    end
end


    