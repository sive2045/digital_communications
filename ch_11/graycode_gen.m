function graycode = graycode_gen(k)

% Generate k bit gray code set

M = 2^k;
decimal = 0:M-1;
bin_code = dec2bin(decimal) - 48;
bin_code = [ zeros(1,k-length(bin_code))   bin_code ];
for i=1:length(decimal)
    graycode(i,:) = bin_code(i,:);
    for j = 2:size(bin_code(i,:),2)
        graycode(i,j) = xor( bin_code(i,j-1), bin_code(i,j) ); 
    end
end