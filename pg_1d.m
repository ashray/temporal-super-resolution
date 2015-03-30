% interpolation of 1D signal using papoulis gerchberg method
function g = pg_1d(f, bandwidth, interp, max_iter)
% f in the bandlimited signal to be interpolated
% bandwith - in multiple of pi (in the domain of upsampled signal)
% interp - number of samples to be inserted between two samples of f
% N -> N point fft/dft

g = upsample(f,interp); % setting new frame values as zero
length_g = length(g);

g_init = g; % for resetting the values
coord = find(g_init);

%F=fft(f, N);
F_iter = zeros(1,length_g);
bw_freq = floor(length_g * bandwidth/2);
% begining the iterations
for i=1:max_iter
    G = fft(g);
    
    % generate a new frequency spectrum F_iter by enforcing bandlimitedness
    F_iter = G;
    F_iter(bw_freq:length(g)-bw_freq) = zeros(1, length(g)-2*bw_freq+1);
    f_iter = ifft(F_iter);
    
    g = f_iter;
    g(coord) = g_init(coord);
end
g = real(g);

