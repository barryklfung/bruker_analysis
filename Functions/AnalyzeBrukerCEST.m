function [freq,Z_spectra,half_freq,MTA,stats] = AnalyzeBrukerCEST(folder,threshold,edge, Automated_ROI)
%ANALYZEBRUKERCEST Accepts a path to a bruker file and spits out the Z
%spectra, MT_asym, and a box of stats on the results.
%   Detailed explanation goes here

plot = 0;
if nargin > 4
    return
end
if nargin == 1
    threshold = 10000;
    edge = 6;
    Automated_ROI = 1;
end
path_to_data = '/pdata/1/2dseq';
path_to_method = '/method';
method = fileread([folder path_to_method]);

%matches the Cest Offset line, but does not capture it. Captures everything
%else afterwards.
freq_REGEX = '(?<=##\$Cest\_Offsets\=\(\s[0-9]+\s\)\n)[-*[0-9]+\s]+\s+';
freqstring = regexp(method,freq_REGEX,'match');
freq = str2num(strrep(freqstring{1},newline,''));

rowcol_REGEX = '(?<=##\$PVM\_Matrix\=\(\s[0-9]+\s\)\n)\s*[0-9]+\s*[0-9]+';
RC_string =  regexp(method,rowcol_REGEX,'match');
rowcol = str2num(strrep(RC_string{1},newline,''));
rows = rowcol(1);
columns = rowcol(2);

%Import all the data, and return the number of images and the stack
[stack, n] = import_2dseq([folder path_to_data],rows,columns);

%Automatic ROI:
if Automated_ROI
    first_image = squeeze(stack(:,:,1));
    thresholded = first_image > threshold;
    stats = regionprops('table',thresholded,'Centroid',...
        'MajorAxisLength','MinorAxisLength');
    center = stats.Centroid; 
    diameter = max(mean([stats.MajorAxisLength stats.MinorAxisLength],2));
    ROI_indices = CircleROI(rows,columns, center(1),center(2), diameter - edge) == 1;
    if plot
        figure()
        subplot(211)
        imshow(ROI_indices)
        subplot(212)
        imshow(first_image,[min(min(first_image)),max(max(first_image))])
    end
end

%Stats
average = zeros([1,n]);
stdev = zeros([1,n]);
low = zeros([1,n]);
high = zeros([1,n]);
for i = 1:n
    img = squeeze(stack(:,:,i));
    average(i) = mean2(img(ROI_indices));
    stdev(i) = std2(img(ROI_indices));
    low(i) = max(max(img(ROI_indices)));
    high(i) = min(img(ROI_indices));
end

%Convert to CEST terminology
Z_spectra = average;
half_freq = freq(int16((length(freq)+1)/2):end);
MTA = MT_asymm(Z_spectra);
stats = [average;stdev;low;high];