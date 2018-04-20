function  write_usrp_data_file( x )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    tmp = zeros(2*length(x),1);
    tmp(1:2:end) = real(x);
    tmp(2:2:end) = imag(x);

    f1 = fopen('tx_1.dat', 'w');
    fwrite(f1, tmp, 'float32');
    fclose(f1);

end