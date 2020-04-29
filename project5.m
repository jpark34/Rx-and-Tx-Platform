% Project 5
% Group 15
% Members: Jarrett Parker, Liam Fitzpatrick, John Anderson

% Gives the input data given to us
% Name in workspace: InputData
load('Proj5InputData.mat');

% Encrypt InputData using Cipher Block Chaining
% Output - Encrpyted Bit Stream (serial)
% Input: InputData
% Ouput name in workspace: EncryptedBitStream


% QPSK on the Encrypted Bit Stream
% Output - Bit to Modulation Symbol Mapping (serial)
% Input: EncryptedBitStream
% Output name in workspace: BittoModulationSymbolMapping

%QPSK Mapping
N = 10240000; %Size of QPSK
j = 1;

b1 = 0;
b2 = 0;

I = 0;
Q = 0;

BittoModulationSymbolMapping = zeros(1, 10240000);

for i=1:2:N
   b1 = EncryptedBitStream(1, i);
   b2 = EncryptedBitStream(1, i+1);
   if b1 == 0 && b2 == 0
       I = 1/sqrt(2);
       Q = 1/sqrt(2);
   end
   if b1 == 0 && b2 == 1
       I = 1/sqrt(2);
       Q = -1/sqrt(2);
   end
   if b1 == 1 && b2 == 0
       I = -1/sqrt(2);
       Q = 1/sqrt(2);
   end
   if b1 == 1 && b2 == 1
       I = -1/sqrt(2);
       Q = -1/sqrt(2);
   end
   BittoModulationSymbolMapping(j) = complex(I, Q);
   j = j + 1;
end

% Serial to parallel
% IFFT
% Output - OFDM Symbol Generation (parallel)
% Input: BittoModulationSymbolMapping
% Output name in workspace: OFDMSymbolGeneration

parallel = reshape(BittoModulationSymbolMapping,1024,[]);


% Parallel to serial
% Cyclic prefix insertion
% Output - CP Insertion (serial)
% Input: OFDMSymbolGeneration
% Output name in workspace: CPInsertion

serial = reshape(OFDMSymbolGeneration,1,[]);


% Add in channel noise
    % Need to create noise, run through IFFT, add to CP Inseriton output
% Output - Additive Channel Noise (serial)
% Input: CPInsertion, GaussNoise
% Output name in workspace: AdditiveChannelNoise


% Cyclic prefix removal
% Output - CP Removal (serial)
% Input: AdditiveChannelNoise
% Output name in workspace: CPRemoval

CPRemoval = zeros(2024,10000);
counter = 1;
[M, N] = size(AdditiveChannelNoise);

%CP removal
for i = 1:N
    if(mod(i, 1094) >= 70)
        CPRemoval(counter) = AdditiveChannelNoise(i+1);
        counter = counter + 1;
    end
end


% Serial to parallel
% FFT
% Parallel to serial
% Output - Modulation Symbol Recovery (serial)
% Input: CPRemoval
% Output name in workspace: ModulationSymbolRecovery

parallel = reshape(CPRemoval,1024,[]);



% change parallel to output of FFT
ModulationSymbolRecovery = reshape(parallel,1,[]);


% Reverse QPSK
% Output - Modulation Symbol to Encrypted Bits (serial)
% Input: ModulationSymbolRecovery
% Output name in workspace: ModulationSymboltoEncryptedBits


% Decrypt Modulation Symbol to Encrypted Bits using Cipher Block Chaining
% Output - De-encrypted Bit Stream (serial)
% Input: ModulationSymboltoEncryptedBits
% Output name in workspace: De-encrpyredBitStream

