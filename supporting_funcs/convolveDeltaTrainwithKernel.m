
function s3 = convolveDeltaTrainwithKernel(s,dt,width,Npop,kernel_type,width2_rise)
% dt - timestep
% width - kernel width in units of dt
% Npop - number of cells in population
% kernel_type - code for which type of kernel to use
% width2_rise - second parameter for shapping kernel. Only used for kernel mode 2.


plot_demo_on = 0;  % Plot if desired




% Build kernel
if kernel_type < 1.5                                % Kernel mode 1 - Gaussian
        % Build kernel time series
        kernel_length=4*width;                      % Length of kernel time series
        t2a = [0:-dt:-kernel_length];
        t2b = [0:dt:kernel_length-dt];
        t2 = [fliplr(t2a(2:end)), 0, t2b(2:end)];   % This affords us a bit more control over the time values, ensuring it is centered at zero.
        %t2 = -kernel_length:dt:kernel_length-dt;    % Generate time vector
        
        % Build kernel
        kernel = 1 * exp(-t2.^2/2/width^2);      % Build kernel. Peaks at 1.0.
        
elseif kernel_type < 2.5                         % Kernel mode 2 - Dual exponential
        % Build kernel time series
        kernel_length=8*width;                   
        t2a = [0:-dt:-kernel_length];
        t2a = zeros(size(t2a));                  % This applies the heaviside function; no negative times. 
        t2b = [0:dt:kernel_length-dt];
        t2 = [fliplr(t2a(2:end)), 0, t2b(2:end)];
        
        % Build kernel
        kernel = (exp(-t2/width) - exp(-t2/width2_rise)) * (width*width2_rise)/(width-width2_rise);     % This normalization constant is wrong
        kernel = kernel / max(kernel);          % Do normalization manually for now.
else
        % For debugging; should not reach this!!
        error ('Should not reach');
end

kernel = kernel(:);

Nnegatives = length(t2a)-1;
Npositives = length(t2b)-1;
kernel_center = Nnegatives + 1;


% Instead of doing convolution, cycle through the pulse train and find all
% the "1's". Then add the kernel centered at these 1's
N = length(s);
ind = find(s > 0.9);    % Find deltas, record indices
s2=zeros(length(s),1);       % ReSet all deltas to zero; elongate array
for i = 1:length(ind)
    icurr = ind(i);
    istart = max(1,icurr - Nnegatives);     % Dont allow it to be outside array bounds
    istop = min(N,icurr + Npositives);
    
    s2(istart:istop) = s2(istart:istop) + kernel([istart-icurr+kernel_center]:[istop-icurr+kernel_center]);
    
end

s3=s2;

% % Convolve kernel with deltas
% s2=conv(s,kernel(:));
% N2=length(s2); N=length(s);
% starting = round((N2-N)/2);
% s3=s2(1+starting:N+starting);       % Each edge we're dropping should be half the difference in the length of the two vectors.
% %s2=wkeep(s2,length(s),'c');        % wkeep doesn't work with compiled code


if plot_demo_on                 % Plot if desired
    figure; 
    subplot(211); plot(t,s);
    t2=[1:length(s2)]*dt;
    t3=t2(1+starting:N+starting);
    legend('Delta train');
    subplot(212); plot(t2,s2);
    hold on; plot(t3,s3);
    legend('Original convolution','Keep only center');
end


s3 = repmat(s3(:),[1,Npop]);
    
end
