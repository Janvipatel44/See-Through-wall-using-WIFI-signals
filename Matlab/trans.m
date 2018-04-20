

clear;
clc;

N = 64;  % IFFT length
L = 16;  % CP length
Error=0;    % Error intialization

OFDM_len = (N+L); % this is the length of an OFDM symbol
tr_len = 640; % training signal length, assume this is known at receiver
dat_len = 1280; % data length

tr = sign(randn(tr_len,1)); % generate some training data
dat = sign(randn(dat_len,1)); % generate random data

save dat.mat dat
save training.mat tr

x = zeros((tr_len + dat_len)*(OFDM_len)/N, 1);  % make an empty 
                                     % vector to store the time domain 
                                     % signal
symbol_counter = 1;
per=sign(randn(64,1));

% first we process and put the training data into the transmitted signal
% vector
for k = 1:tr_len/N
    tmp = ifft(fftshift(tr((k-1)*N+1:k*N))); % take ifft of k-th block in training signal
    tmp2 = [tmp(end-L+1:end); tmp]; % insert CP
    x((symbol_counter-1)*OFDM_len+1:symbol_counter*OFDM_len) = tmp2; % store in the correct place in the x vector
    symbol_counter = symbol_counter + 1; % increment counter
end

% Next we process and put the actual data into the transmitted signal
% vector
for k = 1:dat_len/N
    tmp = ifft(fftshift(dat((k-1)*N+1:k*N))); % take ifft of k-th block in training signal
    tmp2 = [tmp(end-L+1:end); tmp]; % insert CP
    x((symbol_counter-1)*OFDM_len+1:symbol_counter*OFDM_len) = tmp2; % store in the correct place in the x vector
    symbol_counter = symbol_counter + 1; % increment counter
end

% normalize signal to have unit power
x=x./std(x);

%concating preamble
x= cat(1,per(33:64),per,per(1:64),x);

preamble = x(1:160);
save preamble.mat preamble
save('x.mat','x');

%Writing data to USRP and file
write_usrp_data_file(x./10);
