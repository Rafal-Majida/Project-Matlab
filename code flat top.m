% ASK Demodulation

% Assume 'ask_signal' is the received ASK modulated signal
% Assume 'carrier_signal' is the locally generated carrier signal
% Assume 'Tb' is the bit duration
% Assume 'N' is the number of bits

% Parameters (example values, replace with your actual values)
fc = 10; % Carrier frequency
Tb = 1; % Bit duration
t = 0:Tb/100:Tb; % Time vector for one bit duration
carrier_signal = sqrt(2/Tb)*sin(2*pi*fc*t); % Carrier signal for one bit

% Example ASK signal (for demonstration purposes, replace with your received signal)
% This assumes 'ask_signal' is a concatenation of individual modulated bits
% For example, if your original message was [1 0 1], ask_signal would be
% [carrier_signal zeros(1,length(t)) carrier_signal]
% Let's create a sample ask_signal for illustration
N = 3; % Number of bits
message_bits = [1 0 1]; % Original message bits
ask_signal = [];
for i = 1:N
    if message_bits(i) == 1
        ask_signal = [ask_signal, carrier_signal];
    else
        ask_signal = [ask_signal, zeros(1, length(t))];
    end
end

demodulated_bits = zeros(1, N);
for i = 1:N
    % Extract one symbol from the received ASK signal
    symbol_start_index = (i-1)*length(t) + 1;
    symbol_end_index = i*length(t);
    current_symbol = ask_signal(symbol_start_index:symbol_end_index);
    
    % Perform correlation
    correlated_output = current_symbol .* carrier_signal;
    
    % Integrate (sum in this discrete case) over the symbol duration
    decision_variable = sum(correlated_output);
    
    % Decision making
    if decision_variable > (sum(carrier_signal.*carrier_signal)/2) % Threshold can be half the energy of the carrier
        demodulated_bits(i) = 1;
    else
        demodulated_bits(i) = 0;
    end
end

disp('Original message bits:');
disp(message_bits);
disp('Demodulated bits:');
disp(demodulated_bits);

