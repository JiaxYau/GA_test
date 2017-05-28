function opt=ga(y,x)
% solve the minimal value of y.
% y: loss function
% x is the interval
% 结果精确到第四位小数点

xmin=x(1);
xmax=x(2);
global dx;
dx=1e-4;
N=ceil(xmax-xmin)/dx;
K=1;
while power(2,K)<N
    K=K+1;
end

popu=16; % population size
global mutate_rate;
mutate_rate=0.1;
global cross_rate;
cross_rate=0.99;
% initial chromosome, represent chromosome in string
num=randi(2,popu,K)-1;    
temp=num2str(num);
chrom=[];
for i=1:popu
    a=temp(i,:);
    a(a==' ')=[];
    chrom=[chrom;a];
end

loss=zeros(1,popu);
y_min=1e6;
for i=1:popu
    x=decode(chrom(i,:));
    loss(i)=y(x);
    if loss(i)<y_min
        y_min=loss(i);
        elite=chrom(i,:);
    end
end

% termination conditions
delta=1e-6;
max_iter=100;
it=1;
dy=1;
min_loss=zeros(1,max_iter);
while it<=max_iter && dy>delta
    % the probability that each chromosome is selected to do crossover
    prob=10-loss;
    prob=cumsum(prob);
    prob=prob/prob(end);
    % crossover and mutation
    for i=1:popu/2
        r1=rand;
        k1=0;
        while r1>=0
            k1=k1+1;
            r1=r1-prob(k1);
        end
        r2=rand;
        k2=0;
        while r2>=0
            k2=k2+1;
            r2=r2-prob(k2);
        end

        [off(2*i-1,:),off(2*i,:)]=crossover(chrom(k1,:),chrom(k2,:));
        off(2*i-1,:)=mutation(off(2*i-1,:));
        off(2*i,:)=mutation(off(2*i,:));
    end
    
    for i=1:popu
        x=decode(off(i,:));
        loss(i)=y(x);
    end
    y_max=max(loss);
    ind_max=find(loss==y_max,1);
    y_elite=y(decode(elite));
    off(ind_max,:)=elite;
    loss(ind_max)=y_elite;
    
    y_min=min(loss);
    ind_min=find(loss==y_min,1);
    elite=off(ind_min,:);
    opt=decode(elite);
    min_loss(it)=y(opt);
    
    chrom=off;
    if it>20    % 连续20次迭代，最优解基本不变，则结束
        dy=min_loss(it-20)-min_loss(it);
    end
    fprintf('iteration %d: loss = %f...\n',it,y(opt));
    it=it+1;
end


function [off1,off2]=crossover(ch1,ch2)
% mutation, generate two offsprings
% off: offspring
global cross_rate;
if(rand>cross_rate)
    off1=ch1;
    off2=ch2;
    return
end
length=numel(ch1);
split=randi([2,length]);
off1=[ch1(1:split-1),ch2(split:end)];
off2=[ch2(1:split-1),ch1(split:end)];


function ch2=mutation(ch1)
% crossover, randomly flip one bit in ch1
global mutate_rate;
if(rand>mutate_rate)
    ch2=ch1;
    return;
end
len=numel(ch1);
p=randi(len);
num=str2num(ch1(p));
num=num2str(1-num);
ch2=ch1;
ch2(p)=num;


function dec=decode(bin)
% decode binary sequence to decimal
global dx;
dec1=bin2dec(bin);
dec=dec1*dx;

function bin=encode(dec)
% encode decimal to binary sequence
global dx;
num=dec/dx;
bin=dec2bin(num);





