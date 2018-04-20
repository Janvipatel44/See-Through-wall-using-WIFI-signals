
clear;
clc;

N = 64;  % IFFT length
L = 16;  % CP length
Error=0;    % Error intialization

OFDM_len = (N+L); % this is the length of an OFDM symbol
tr_len = 640; % training signal length, assume this is known at receiver
dat_len = 1280; % data length

 %loading File
 load p.mat
 load x.mat
 
x_tr = reshape(x,[64,40]);

x_tran = p*x_tr;

x_trans = reshape(x_tran,[2560,1]);

%Writing data to USRP and file
write_usrp_data_file(x_trans./10);
