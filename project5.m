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

IV = round(rand([1 1024])); % generates a 1x1024 vector of random numbers (0 or 1)
key = round(rand([1 1024])); % key is generated randomly

plaintext = reshape(InputData, [20000,1024]);
ciphertext = zeros(20000,1024);

%encryption
for i =1:20000
    if(i == 1) % first 1024 xored with IV and encrypted with key
        ciphertext(i,:) = xor(key, xor(plaintext(i,:), IV));
    else % other blocks xored with pervious cipher block and encrypted with key
        ciphertext(i,:) = xor(key, xor(plaintext(i,:), ciphertext(i-1,:)));
    end
end
EncryptedBitStream = reshape(ciphertext,1, 20480000);
%EncryptedBitStream is the input encrypted and put back in serial


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

%serial to parallel
parallelForIFFT = reshape(BittoModulationSymbolMapping,1024,[]);

%IFFT
OFDMSymbolGeneration = ifft(parallelForIFFT,1024,1);


% Parallel to serial
% Cyclic prefix insertion
% Output - CP Insertion (serial)
% Input: OFDMSymbolGeneration
% Output name in workspace: CPInsertion

% parallel to serial
serialForCPInsertion = reshape(OFDMSymbolGeneration,1,[]);

%cp insertion
CPInsertion = zeros(1,10940000);
counter = 1;
for i=1:10000
    for j = (955 + 1024*(i-1)):1024*i % prefix
        CPInsertion(counter) = serialForCPInsertion(j);
        counter = counter + 1;
    end
    for k = (1 +(1024*(i-1))):1024*i % remaining
        CPInsertion(counter) = serialForCPInsertion(k);
        counter = counter + 1;
    end
end


% Add in channel noise
    % Need to create noise, run through IFFT, add to CP Inseriton output
% Output - Additive Channel Noise (serial)
% Input: CPInsertion, GaussNoise
% Output name in workspace: AdditiveChannelNoise
        
%create channel noise
additiveNoise = zeros(1, 10940000);
phase = normrnd(0,.384);
amplitude = normrnd(0,.25);

for i=1:10940000
     additiveNoise(i) = complex(amplitude*cos(phase), amplitude*sin(phase));
end

%convert noise from serial to parallel
parallelNoise = reshape(additiveNoise, 1094,10000);

%IFFT on noise
inverseNoise = ifft(parallelNoise,[],1);

%revert noise from parallel to serial
serialNoise = reshape(inverseNoise,1,[]);

%add the noise to CPInsertion

AdditiveChannelNoise = serialNoise + CPInsertion;

% Cyclic prefix removal
% Output - CP Removal (serial)
% Input: AdditiveChannelNoise
% Output name in workspace: CPRemoval

CPRemoval = zeros(1,10240000);
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

%serial to parallel
parallelForFFT = reshape(CPRemoval,1024,[]);

%FFT
outputFFT = fft(parallelForFFT,1024,1);

%parallel to serial
ModulationSymbolRecovery = reshape(outputFFT,1,[]);


% Reverse QPSK
% Output - Modulation Symbol to Encrypted Bits (serial)
% Input: ModulationSymbolRecovery
% Output name in workspace: ModulationSymboltoEncryptedBits

%reverse qpsk
[rows, columns] = size(ModulationSymbolRecovery);

ModulationSymbolstoEncryptedBits = zeros(1, columns);
iter = 1;

for x=1:columns
    b1 = real(ModulationSymbolRecovery(x));
    b2 = imag(ModulationSymbolRecovery(x));
    if b1 > 0
        b1 = 0;
    elseif b1 < 0
        b1 = 1;
    end
    if b2 > 0
        b2 = 0;
    elseif b2 < 0
        b2 = 1;
    end
    ModulationSymbolstoEncryptedBits(1, iter) = b1;
    ModulationSymbolstoEncryptedBits(1, iter + 1) = b2;
    iter = iter + 2;
end


% Decrypt Modulation Symbol to Encrypted Bits using Cipher Block Chaining
% Output - De-encrypted Bit Stream (serial)
% Input: ModulationSymboltoEncryptedBits
% Output name in workspace: DecryptedBitStream

decryptInput = reshape(ModulationSymbolstoEncryptedBits, [20000,1024]);

%decryption
plaintextPost = zeros(20000,1024);
for i=20000:-1:1
    if(i==1)
        plaintextPost(i,:) = xor(IV, xor(decryptInput(i,:),key));
    else
        plaintextPost(i,:) = xor(decryptInput(i-1,:), xor(key, decryptInput(i,:)));
    end
end
%plaintextPost is DecryptedBitStream before reshaping

DecryptedBitStream = reshape(plaintextPost,1, 20480000);


% how we found our bit error rate
% comment out when turn in
wrongbits = 0;

for p=1:20480000
    if InputData(1,i)~=DecryptedBitStream(1,i)
        wrongbits=wrongbits+1;
    end
end

BitError = wrongbits/20480000;
disp(BitError)
