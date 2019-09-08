function y = piecewiseLine(x,u,a,s1,s2,w)
% PIECEWISELINE   A line made of two pieces
% that is not continuous.
% f = zeros(141,1);
% Free parameters - u,s1,w,s2
% This example includes a for-loop and if statement
% purely for example purposes.
% for i = 1:length(x)
%     if x(i)>= u
%         f(i) = a*exp((-(x(i)-u)^2)/2*s1^2)*sin((2*pi*w)*(x(i)-u));
%     else
%         f(i) = a*exp((-(x(i)-u)^2)/2*s2^2)*sin((2*pi*w)*(x(i)-u));
%     end
% end

for i = 1:length(x)
    if x>= u
        y = a*exp(-((x-u)^2)/2*s1^2)*sin((2*pi*w)*(x-u));
    else
        y = a*exp(-((x-u)^2)/2*s2^2)*sin((2*pi*w)*(x-u));
    end
end

end