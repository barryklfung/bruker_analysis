clear;
clc;
close all;
plots = 1;
ExamFolder = 'C:\Work\Vandsburger Lab\MRI\2018-02-23_CEST_expt';
% Get a list of all files and folders in this folder.
files = dir(ExamFolder);
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subFolders = files(dirFlags);

results = containers.Map;

for k = 1 : length(subFolders)
    %Check that it is a study folder
    if ~(strcmp(subFolders(k).name,'.') || strcmp(subFolders(k).name, '..'))
        %Check that there is an image:
        if exist([ExamFolder '\' subFolders(k).name '\pdata\1\2dseq'], 'file') == 2
            methodName=[ExamFolder '\' subFolders(k).name '\method'];
            %check that it is a cest folder
            if regexp(fileread(methodName),'Cest')
                result = containers.Map;
                [freq,Z_spectra,half_freq,MTA,stats] = AnalyzeBrukerCEST([ExamFolder '\' subFolders(k).name]);
                result('freq') = freq;
                result('Z_spectra') = Z_spectra;
                result('half_freq') = half_freq;
                result('MTA') = MTA;
                result('stats') = stats;
                results(subFolders(k).name) = result;
                if plots
                    figure()
                    plot(freq,Z_spectra/max(Z_spectra))
                    hold on
                    title(['Z-spectra from Study from Subfolder "' subFolders(k).name '"'])
                    xlabel('Frequency Offset (Hz)')
                    ylabel('Normalized Response')
                    hold off
                    
                    figure()
                    plot(half_freq,MTA)
                    hold on
                    title(['MTA from Study from Subfolder "' subFolders(k).name '"'])
                    xlabel('Frequency Offset (Hz)')
                    ylabel('MT_{asym}')
                    hold off
                end
            end
        end             
    end
end
save([ExamFolder '\results.mat'],'results')