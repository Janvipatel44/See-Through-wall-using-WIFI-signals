clear;
clc;

tr_len = 640; % training signal length, assume this is known at receiver
dat_len = 1280; % data length
N = 64;  % IFFT length
L = 16;  % CP length
Error = 0;
 
 %loading File
 load training.mat
 load preamble.mat
 load dat.mat
 
 %Reading Data from usrp
 Y_usrp = read_usrp_data_file;
 
 %Coefficient to training
 delay = finddelay(preamble,Y_usrp);
 
 %Preamble+data+Training whole y
 y = Y_usrp(abs(delay):(abs(delay)+160+tr_len+dat_len+(tr_len/N + dat_len/N)*L));   
 
y_temp = 0;

%Conjiguting Y
for i=33:96
    y_fi(i-32) = conj(y(i))*y(i+64);
    y_ang(i-32) = angle(y_fi(i-32));

    y_temp = y_temp + y_ang(i-32);
    
end

y_avg = -y_temp/(64*64);
display(y_avg);

%Removing exp()
for i=1:(length(y)-1)
    y_rmv(i) = y(i)*(exp(1i*y_avg*i));
end

%Transposing the tr
Tr = transpose(tr);
H_tmp = zeros(1,64);

%Frequency Domain
for i=3:(tr_len/N+2)
    
    Y_tr((i-3)*64+1:(i-2)*64) = fftshift(fft(y_rmv((i-1)*80+17:i*80)));
    
    %Getting H Estimation
    H = Y_tr((i-3)*64+1:(i-2)*64)./Tr((i-3)*64+1:(i-2)*64);
    H_tmp = H_tmp + H;
end

avg_h = H_tmp./10;
%save h_200-209.mat avg_h
figure,plot(abs(avg_h));

for i=13:(dat_len/N+12)
    %Taking FFT per block
    y_data((i-13)*64+1:(i-12)*64) = fftshift(fft(y_rmv((i-1)*80+17:i*80)));  %freq domain
  
    %Getting x from Y and H
    X((i-13)*64+1:(i-12)*64) = y_data((i-13)*64+1:(i-12)*64)./avg_h;
end

x_sign = sign(real(X));

%checking Error
for k=1:dat_len
    if((x_sign(k)>0 && dat(k)<0)||(x_sign(k)<0 && dat(k)>0))
        Error = Error+1;
    end
end
%Error bit
   error = Error/dat_len;
   display(error);
