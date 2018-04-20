function  y = read_usrp_data_file
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    f1 = fopen('rx.dat', 'r');
    tmp = fread(f1,'float32');
    fclose(f1);
    y = tmp(1:2:end)+1i*tmp(2:2:end);
    
end

