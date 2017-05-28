% using GA (Genetic Algorithm) to find the minimal point of function
% y=x+sin(2*x)+cos(3*x), x in [0,6]
clear;
x=0:0.01:6;
y=@func;

minimal_x=ga(y,x);  % GA

y0=y(x);
k=find(y0==min(y0));
min_x=x(k);
fprintf('==========================================\n');
fprintf('the gap between real minimal x and approximate minimal x is %f\n',abs(minimal_x-min_x));
fprintf('==========================================\n');

figure,plot(x,y(x));
hold on;
plot(minimal_x,y(minimal_x),'r*');