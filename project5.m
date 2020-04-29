% Project 5
% Group 15
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

parallel = reshape(serial,1024,[]);


% Parallel to serial
% Cyclic prefix insertion
% Output - CP Insertion (serial)
% Input: 
% Output name in workspace: 


% Add in channel noise
% Need to create noise, run through IFFT, add to CP Inseriton output
% Output - Additive Channel Noise (serial)
% Input: 
% Output name in workspace: 


% Cyclic prefix removal
% Output - CP Removal (serial)
% Input: 
% Output name in workspace: 

CPRemov = [];
counter = 1;
[M, N] = size(RxSymbStream);

%CP removal
for i = 1:N
    if(mod(i, 1094) >= 70)
        CPRemov(counter) = RxSymbStream(i+1);
        counter = counter + 1;
    end
end


% Serial to parallel
% FFT
% Parallel to serial
% Output - Modulation Symbol Recovery (serial)
% Input: 
% Output name in workspace: 

parallel = reshape(serial,1024,[]);


% Reverse QPSK
% Output - Modulation Symbol to Encrypted Bits (serial)
% Input: 
% Output name in workspace: 


% Decrypt Modulation Symbol to Encrypted Bits using Cipher Block Chaining
% Output - De-encrypted Bit Stream (serial)
% Input: 
% Output name in workspace: 

