clc;clear all;
r=5;
N=2^r-1;%周期31
a=ones(1,r);   
m=zeros(1,N);  
for i=1:(2^r-1) 
    temp= mod((a(5)+a(2)),2); 
    for j=r:-1:2
        a(j)=a(j-1);
    end 
    a(1)=temp;
    m(i)=a(r); 
end
m=m*2-1;%双极性码
%产生随机发送信息，并进行BPSK/QPSK调制
n=1000;
Y_BIT_sum=zeros(1,36);
for jj=1:100%跑100次，得到平滑曲线
    source=randi([0 1],1,n);
    % s_imag=randi(1,n);
    s_BPSK=2*source-1;
    % s=source+j*s_imag;
    % j=sqrt(-1);
    % s_QPSK=s*2-(1+j);
    %产生扩频信号：
    % for z=1:1:100
    %     y_QPSK(31*(z-1)+(1:31))=m*s_QPSK(z);
    % end
    for z=1:1000
        y_BPSK(31*(z-1)+(1:31))=m*s_BPSK(z);
    end
    %加入高斯白噪声
    SNR=-30:5;
    for i=1:length(SNR)
        y(i,:)=awgn(y_BPSK,SNR(i));
    end
    %解扩
    for z=1:1000
        for i=1:length(SNR)
            o_BPSK(i,z)=y(i,31*(z-1)+(1:31))/m;
        end
    end
    Y_RE=o_BPSK;
    %判决
    Y_RE(o_BPSK>0)=1;
    Y_RE(o_BPSK<0)=0;
    Y_ERRO=zeros(length(SNR),1000);
    Y_BIT=zeros(1,length(SNR));
    for i=1:length(SNR)
        Y_ERRO(i,:)=abs(Y_RE(i,:)-source);
        Y_BIT(i)=sum(Y_ERRO(i,:))/n;
    end
    Y_BIT_sum=Y_BIT_sum+Y_BIT;
end
Y_BIT_av=Y_BIT_sum/100;
semilogy(SNR,Y_BIT_av);
xlabel('SNR');ylabel('误码率');
grid on;
title('wml');