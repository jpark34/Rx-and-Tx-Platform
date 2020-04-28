% Project 5
% Group 
% Members: Jarrett Parker, Liam Fitzpatrick, John Anderson

% Gives the input data given to us
% Name in workspace: InputData
load('Proj5InputData.mat');

% Encrypt InputData using Cipher Block Chaining
% Output - Encrpyted Bit Stream (serial)
% Input: InputData
% Ouput name in workspace: 


% QPSK on the Encrypted Bit Stream
% Output - Bit to Modulation Symbol Mapping (serial)
% Input: 
% Output name in workspace: 


% Serial to parallel
% IFFT
% Output - OFDM Symbol Generation (parallel)
% Input: 
% Output name in workspace: 


% Parallel to serial
% Cyclic prefix insertion
% Output - CP Insertion (serial)
% Input: 
% Output name in workspace: 


output = [];
counter = 1;
for i = 1:1094*1000 % replace upper bound with m
    if(mod(i,1094) < 1025)
        output[counter] = inputFile[i];
        counter = counter + 1;
    end
end

% Add in channel noise
% Need to create noise, run through IFFT, add to CP Inseriton output
% Output - Additive Channel Noise (serial)
% Input: 
% Output name in workspace: 


% Cyclic prefix removal
% Output - CP Removal (serial)
% Input: 
% Output name in workspace: 


% Serial to parallel
% FFT
% Parallel to serial
% Output - Modulation Symbol Recovery (serial)
% Input: 
% Output name in workspace: 


% Reverse QPSK
% Output - Modulation Symbol to Encrypted Bits (serial)
% Input: 
% Output name in workspace: 


% Decrypt Modulation Symbol to Encrypted Bits using Cipher Block Chaining
% Output - De-encrypted Bit Stream (serial)
% Input: 
% Output name in workspace: 

