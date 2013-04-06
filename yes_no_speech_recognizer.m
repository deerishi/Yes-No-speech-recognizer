function [ res ] = speech(v,N,M  )
%yes/no classifier
%   the above function classifies the given speech into yes/no.For the sake
%   of simplicity we have just taken sppech inputs as yes/no.
energy=0.035;
zeroth=0.06;
blocked_data=block(v,N,M);
useful_data=segregate(blocked_data,energy,zeroth);
zero_crossing=cross(useful_data);

max_cross=max(zero_crossing);
if(max_cross<5)
    f='Insufficient data';
elseif(max_cross>100)
    f='Yes';
else
    f='No';
end
res=f;
end

function [d]=block(v,N,M)
%divides the data into blocks,of length N and repeted after M
l=length(v);
max_index=l-N+1;
last_index=max_index - mod(max_index-1,M);
no_of_blocks=((last_index-1)/M)+1;
d=zeros(no_of_blocks,N);
for i=1:no_of_blocks
    for j=1:N
        d(i,j)=v((i-1)*M+j);
    end
end
end

function [num]=crossing(vector)
%this function calculates the number of zero crossing in a given vector
cur_sign=0;
prev=0;
l=length(vector);
sum=0;
for i=2:l
    cur_sign=sign(vector(i));
    if(prev*cur_sign==-1)
        sum=sum+1;
    end
    if(cur_sign~=0)
        prev=cur_sign;
    end
end
num=sum;
end

function [zeros_per_block]=cross(block)
%returns the number of zeros in each vector of a block
[m,n]=size(block);
for i=1:m
    zeros_per_block(i)=crossing(block(i,1:n));
end
end

function [data]=segregate(block,energy,zeroth)
[m,n]=size(block);
min=0;
max=m+1;
for i=1:m
    cursum=sum(abs(block(i,1:n)));
    curzero=crossing(block(i,1:n));
    if(cursum>energy | curzero>zeroth)
        if(i>min)
            min=i;
            break;
        end
    end
end
for i=m:-1:1
    cursum=sum(abs(block(i,1:n)));
    curzero=crossing(block(i,1:n));
    if(cursum>energy | curzero>zeroth)
        if(i<max)
            max=i;
            break;
        end
    end
end
data=block(min:max,1:n);
end


        




    

