%======================================
%       TESTING SUM OF PRODUCTS
%======================================

N_in = 10; % number of inputs
bx = 8; % number of bits of an input
bw = 9; % number of bits of weigths and bias 
bout = 16; % number of bits of the output (we are imposing it)

trials = 1000; % number of for cycle to compute errors. Then we will see the MSE

% xi, wi and b are in the range [-1,1], so we can find LSBs 
lsbx = 1/(2^(bx-1));
lsbw = 1/(2^(bw-1));
lsbb = lsbw;

% product of xi and wi
bproduct = bx + bw; % number of bits of the product between each input and its weight
lsbproduct = lsbx * lsbw; %lsb of the product

% now we have to sum up 10 terms that are on the same bits + bias (9 bits)
bsum = bproduct + ceil(log2(10));
lsbsum = lsbproduct; % since they are already aligned in the right way 

x = zeros(N_in, 1);
w = zeros(N_in, 1);
repr_x = zeros(N_in, 1);
repr_w = zeros(N_in, 1);
ai = zeros(N_in, 1); % will contain products of xi,wi

computed_output = zeros(trials, 1);
expected_output = zeros(trials, 1);

for k = 1:trials
    for i = 1:N_in 
        % generating numbers between -1 and 1
        x(i) = rand();
        w(i) = rand();
        if(rand() < 0.5)
            x(i) = -1 * x(i);
        end
        if(rand() < 0.5)
            w(i) = -1 * w(i);
        end
        
        % getting their corresponding integers 
        repr_x(i) = getCorrespondingInteger(x(i), lsbx);
        repr_w(i) = getCorrespondingInteger(w(i), lsbw);
        % computing products
        ai(i) = repr_x(i) * repr_w(i);
    end
    
    a = sum(ai); % sum up each previous product

    % ==============================================
    %       how to deal with the BIAS 
    % ==============================================
    % now we have to perform operations on the bias
    % in particular, it has to be aligned to the sum stored in the variable a
    bias = rand();
    if(rand() < 0.5) 
        bias = -1 * bias;
    end
    repr_b = getCorrespondingInteger(bias, lsbb);
    flag = false;
    if(repr_b < 0)
        repr_b = 2^bw + repr_b;
        flag = true;
    end
    binary_b = dec2bin(repr_b, bw);
    % alignment (7 zeros at the tail) and extension (5 times MSB at the head
    % in fact 7 + 5 + 9 = 21 bits that are the bits needed for sum 
    % this line of code will be directly placed in VHDL!
    binary_b_ext = [ binary_b(1), binary_b(1), binary_b(1), binary_b(1), binary_b(1), binary_b(1:end), '0', '0', '0', '0', '0', '0', '0' ];
    
    %converting b_ext_dec 
    b_ext_dec = bin2dec(binary_b_ext);
    if(flag == true)
        b_ext_dec = b_ext_dec - 2^21;
    end

    % ===================================================
    % ===================================================
    
    % now we have all the ingredients to see what we have just computed 
    a = a + b_ext_dec;
    
    computed_output(k) = (a) * lsbsum;
    expected_output(k) = bias;
    for i = 1:N_in
        expected_output(k) = expected_output(k) + x(i)*w(i);
    end
 
end
f = figure('Name', 'Errors of SOP(sum of products)');
figure(f);
plot(computed_output-expected_output);
mse = mean((computed_output-expected_output).^2)
max_value = max(computed_output-expected_output)
min_value = min(computed_output-expected_output)
