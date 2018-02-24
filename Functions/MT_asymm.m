function [MTA] = MT_asymm(z_spectra)
%MT_asymm Given a symmetric z-spectra, calculates MT_asymm
%   Detailed explanation goes here
diff = z_spectra - flip(z_spectra);
MTA = (diff./z_spectra);
MTA = flip(MTA(1:ceil(length(z_spectra)/2)));
end

