% -------------------------------------------------------------------------
% Fast and Efficient Frequency Estimation of Multiple Sinusoids
% by Ahmet Serbes <ahmet.serbes@gmail.com> or <aserbes@yildiz.edu.tr>,
% Jan 2o21, Istanbul
% Ahmet Serbes
%
% This code may be used for scientific and educational purposes 
% provided that credit is given to the publications below:
%
% Ahmet Serbes, "Fast and Efficient Estimation of Frequencies," 
% IEEE Transactions on Communications.
%
% This Matlab function returns a very accurate estimation of the frequency 
% f of a multiple complex sinusoid in the form of 
% 'Sum A(k) exp (j 2 pi / Fs f(k) n)'
%
%
% function [f, A] = multFreqEst(s,K)
%      f    : Estimate of the frequency.
%      A    : Estimates of corresponding amplitudes.
%      s    : input noisy multiple complex sinusoidal in the form of 
%             'Sum A(k) exp(j 2 pi / Fs f(k) n) + w(n)', k=1,2,...,K,
%             where w(n) is noise.
%
%      The input s has to be an Nx1 or 1xN vector.
%
%      In this defaut form the default sampling frequency  Fs = N and 
%      minimum DFT spacing value minSep = 2 is taken.
%
% function [f, A] = multFreqEst(s, K, 'Fs', Fs)
%      f    : Estimates of the frequencies.
%      A    : Estimates of corresponding amplitudes
%      s    : input noisy multiple complex sinusoidal in the form of 
%             'Sum A(k) exp(j 2 pi / Fs f(k) n) + w(n)', k=1,2,...,K,
%             where w(n) is noise.
%      Fs   : The sampling frequency. 
%
%      The input s has to be an Nx1 or 1xN vector.
%
%      In this form minimum minimum DFT frequency separation default value 
%      minSep = 2 is taken.
%
% function [f, A] = multFreqEst(s, K, 'minSep', minSep)
%      f      : Estimates of the frequencies.
%      A      : Estimates of corresponding amplitudes
%      s      : input noisy multiple complex sinusoidal in the form of 
%               'Sum A(k) exp(j 2 pi / Fs f(k) n) + w(n)', k=1,2,...,K,
%               where w(n) is noise.
%      minSep : Minimum DFT frequency spacing. This value must be greater
%               than one, i.e., minSep>1
%
%      The input s has to be an Nx1 or 1xN vector.
%
%      In this form minimum the sampling frequency Fs is taken as Fs=N, 
%      where N is the signal length.
% function [f, A] = multFreqEst(s, K, 'zeroPad', z)
%      f      : Estimates of the frequencies.
%      A      : Estimates of corresponding amplitudes
%      s      : input noisy multiple complex sinusoidal in the form of 
%               'Sum A(k) exp(j 2 pi / Fs f(k) n) + w(n)', k=1,2,...,K,
%               where w(n) is noise.
%      Interp : DFT zero padding ratio z. The signal is padded with zero 
%               before the DFT such that if the length of the signal is N,
%               then the total length of the signal is zN after padding.
%               This value must be greater than or equal to 1, i.e. z>=1. 
%
%      The input s has to be an Nx1 or 1xN vector.
%
%      In this form minimum the sampling frequency Fs is taken as Fs=N, 
%      where N is the signal length and the minimum frequency separation 
%      value minSep = 2 by default.
%
% function [f, A] = multFreqEst(s, K, 'Fs', Fs, 'minSep', minSep)
%      f     : Estimates of the frequencies.
%      A     : Estimates of corresponding amplitudes
%      s     : input noisy multiple complex sinusoidal in the form of 
%              'Sum A(k) exp(j 2 pi / Fs f(k) n) + w(n)', k=1,2,...,K,
%              where w(n) is noise.
%      Fs    : The sampling frequency. 
%      minSep: Minimum DFT frequency spacing. This value must be greater
%              than one, i.e., minSep>1
%
% function [f, A] = multFreqEst(s, K, 'Fs', Fs, 'zeroPad', z)
%      f     : Estimates of the frequencies.
%      A     : Estimates of corresponding amplitudes
%      s     : input noisy multiple complex sinusoidal in the form of 
%              'Sum A(k) exp(j 2 pi / Fs f(k) n) + w(n)', k=1,2,...,K,
%              where w(n) is noise.
%      Fs    : The sampling frequency.
%      z     : DFT interpolation ratio. This value must be greater
%              than or equal to one, i.e., z>=1
%
% function [f, A] = multFreqEst(s, K, 'minSep', minSep, 'zeroPad', z)
%      f     : Estimates of the frequencies.
%      A     : Estimates of corresponding amplitudes
%      s     : input noisy multiple complex sinusoidal in the form of 
%              'Sum A(k) exp(j 2 pi / Fs f(k) n) + w(n)', k=1,2,...,K,
%              where w(n) is noise.
%      minSep: Minimum DFT frequency spacing. This value must be greater
%              than one, i.e., minSep>1
%      z     : DFT interpolation ratio. This value must be greater
%              than or equal to one, i.e., z>=1
%
% function [f, A] = multFreqEst(s,K,'Fs',Fs,'minSep',minSep,'zeroPad', z)
%      f     : Estimates of the frequencies.
%      A     : Estimates of corresponding amplitudes
%      s     : input noisy multiple complex sinusoidal in the form of 
%              'Sum A(k) exp(j 2 pi / Fs f(k) n) + w(n)', k=1,2,...,K,
%              where w(n) is noise.
%      Fs    : The sampling frequency.
%      minSep: Minimum DFT frequency spacing. This value must be greater
%              than one, i.e., minSep>1
%      z     : DFT interpolation ratio. This value must be greater
%              than or equal to one, i.e., z>=1
%
%   n = 0:512;
%   f1 = 15 + 0.27;  % Coarse frequency is 15, residual freq. is 0.27
%   f2 = 90 - 0.1;   % Coarse frequency is 90, residual freq. is 0.1
%   % Generate a sinusoidal with random phase
%   s = exp(1i * (2 * pi / 512 * f1 + 2 * pi * rand(1))) ...
%       + exp(1i * (2 * pi / 512 * f2 + 2 * pi * rand(1)));
%   sn = awgn(s, 10, 'measured'); % for example, add 10dB AWGN noise.
%   % retrieve estimated coarse frequency and residual frequency
%   [f, A] = multFreqEst(sn,2);
%  
%   or
% 
%   [f, A] = multFreqEst(sn, 2, 'minSep', 5);
%   
%   or 
%
%   [f, A] = multFreqEst(sn, 2, 'minSep', 5, 'zeroPad', 4);
%   
%   or 
%
% -------------------------------------------------------------------------

function [f, A] = multFreqEst(s, K, varargin)

% Convert the signal to Nx1 vector
s = s(:);

% Check that the input is a vector and that the number of components K is a
% pozitive integer. 
if ~isvector(s)
    error('Input signal must be an NX1 or 1XN complex vector.');
end

% A function handle to find positive integers
ispositiveinteger = @(inp) ((isscalar(inp)) && (~logical(imag(inp))) ...
                 && (isnumeric(inp)) && (inp>0) && (~logical(mod(inp,1))));

if ~ispositiveinteger(K)
    error('Number of sinusoidal components must be a positive scalar number');
end

% Length of the input vector. 
N = length(s);

% Set the default values
DefaultFs       = N;    % The default sampling rate
DefaultMinSep   = 2;    % The default minimum DFT frequency spacing
Defaultz        = 2;    % The default DFT zero-padding ratio

% Parse Fs, minSep, and z if the inputs are correctly given
params = inputParser;
addOptional(params, 'Fs',     DefaultFs,    ispositiveinteger);
addOptional(params, 'minSep', DefaultMinSep,@(ch) ch > 1);
addOptional(params, 'zeroPad',Defaultz,     @(ch) ch >= 1);

parse(params, varargin{:});

% Set Fs, minimum DFT spacing, and the zero-padding ratio
Fs      = params.Results.Fs;
minSep  = params.Results.minSep;
z       = params.Results.zeroPad;

% The interpolation ratio z is any real number greater than one.
% Set the interpolation ratio z correctly if zN is not an integer
N_FFT = round(z*N);
z = N_FFT / N;

% Build the discrete indexes
n = (0:N-1)';

% Select the minimum optimum value of q (Section III.D)
q = min((1/sqrt(N)),0.25);

% Form c(q) accordingly
cq = (1 - pi * q * cot(pi * q)) / (q * cos(pi * q)^2);

% Select the optimum value of Qopt (Section III. C)
Q1opt = ceil(log(log2(N / log(N))) / log(3));
Q1opt = max(2,Q1opt);
Q2opt = ceil(log(N / log(N)) / log(minSep));
Qopt = max(Q1opt, Q2opt);

% Initialize coarse frequencies, residual frequencies, and amplitudes.
p = zeros(K, 1);        % coarse frq. initialization
delta = zeros(K, 1);    % fractional frq. initialization
A = zeros(K, 1)';       % amplitudes initialization

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                  START COARSE ESTIMATION                          %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

X = fft(s, N_FFT);

m = (0:(N_FFT-1))';

for k = 1:K
    
    [~, p(k)] = max(abs(X).^2);    
    
    % Matlab index starts from 1, therefore we remove it.
    p(k) = (p(k) - 1) / z;
    
    % Form S_{+q}=Sq and S_{-q}=Snq
    Sq  = sum(s .* exp(-1i * 2 * pi / N * (p(k) + q) * n));
    Snq = sum(s .* exp(-1i * 2 * pi / N * (p(k) - q) * n));
    
    % Estimate fractional frequencies
    delta(k) = real( (1/cq) * (Sq - Snq) / (Sq + Snq) );
    
    % Estimate the amplitudes
    A(k) = exp(-1i * 2 * pi * (p(k) + delta(k)) * n' / N ) * s / N;
    
    % Find the estimate of (K-k) component sinusoid
    X = X-A(k)*(1-exp(1i*2*pi*(p(k)+delta(k)-m/z))) ./ ...
                                    (1-exp(1i*2*pi/N*(p(k)+delta(k)-m/z)));
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% A small trick, here f represents kp + \delta
f = p + delta;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                  START FINE ESTIMATION STEP                       %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for t = 1:Qopt
    for k = 1:K
        
        % A small trick to find \hat{s}, where all the amplitudes and the 
        % frequencies, but the k-th one are taken out
        at  = [A(1:k-1)  A(k+1:end)];
        ft =  [f(1:k-1); f(k+1:end)];
        
        % Calculate s^
        shat = s;
        for m = 1:K-1
            %Calculate \hat{s}, which is an estimate of a single sinusoid
            shat = shat - at(m) * exp(1i * 2 * pi / N * (ft(m)) * n);
        end
        
        % Form S_{+q}=Sq and S_{-q}=Snq
        Sq  = sum(shat .* exp(-1i * 2 * pi / N * (f(k)  + q) * n));
        Snq = sum(shat .* exp(-1i * 2 * pi / N * (f(k)  - q) * n));
        
        % Refine \delta_k
        delta(k) = real( (1/cq) *(Sq - Snq) / (Sq + Snq));
        
        % f(k) = kp + delta;
        f(k) = f(k) +  delta(k) ;
        
        % Estimate refined amplitude
        A(k) = exp(-1i * 2 * pi * (f(k)) * n' / N ) * shat / N;
    end    
end

% Normalize the estimated frequency according to the sampling frequency.
f = f * Fs / N;

% Sort the frequencies in a descending order and sort the amplitudes
% accordingly.

w = sortrows([f, transpose(A)],'descend');
f = w(:,1); A = w(:,2);

end
