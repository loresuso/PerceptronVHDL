%===========================================
%       TESTING ACTIVATION FUNCTION
%===========================================

bin = 21; % number of bits coming from the arith unit
bout = 16; % imposed by the text of the project (truncation will be needed)

% the output of the activation function is always a positive number in the
% range [0, 1].
% if a <= -2 -> output is 0
% if a >= 2 -> output is 1
% else output is a/4 + 1/2
% we need to use the integers representig 2, -2 and 0.5 

repr_2 = getCorrespondingInteger(2, lsbsum); %65536
repr_minus_2 = getCorrespondingInteger(-2, lsbsum);%-65536
repr_dot5 = getCorrespondingInteger(0.5, lsbsum); %16384

x = (-3 : 0.1 : 3);
x = x';
repr_x = zeros(size(x));
computed_af = zeros(size(x));
expected_af = zeros(size(x));
for i=1:size(x)
    repr_x(i) = getCorrespondingInteger(x(i), lsbsum);
    if(repr_x(i) <= repr_minus_2)
        computed_af(i) = 0; %0
    elseif(repr_x(i) >= repr_2)
        computed_af(i) = getCorrespondingInteger(1, lsbsum); %32768
    else
        computed_af(i) = floor(repr_x(i)/4) + repr_dot5; 
    end       
    expected_af(i) = activationFunction(x(i));
    % then you will have to truncate in vhdl to fit on 16 bits
end
f1 = figure('Name', 'Computed_af against Expected_af');
figure(f1);
plot(computed_af.*lsbsum, expected_af) % we get the straight line, meaning that they're equal
f2 = figure('Name', 'x against Computed_af');
figure(f2);
plot(x, computed_af.*lsbsum) % we get the activation function 
% then in the vhdl we will have to truncate the 5 least significant bits
% because bsum is 21 and bout must be 16
