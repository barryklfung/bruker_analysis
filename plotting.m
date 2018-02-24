clc;
clear;
close all;

ExperimentName = "Eu Phantom, FA = 1080, Recaptiulating Ashley's studies";
spacing_in_ppm = 1;


z = [30379.271
30028.285
29795.539
29633.646
29502.89
29484.457
29328.704
29197.609
29143.322
28984.749
28863.623
28699.628
28561.552
28382.826
28076.953
27737.224
27326.763
26714.316
25951.886
24952.335
23304.887
20975.037
17579.932
12764.155
4127.863
2515.63
4244.324
12507.047
17351.018
20711.557
22897.246
24518.868
25511.762
26258.361
26807.448
27142.314
27410.388
27591.771
27628.055
27639.155
27267.863
26424.069
24795.177
25042.601
26196.957
26188.254
24996.953
25351.327
27380.657
28190.734
28575.23
];

MTA = MT_asymm(z);
offset = 0:spacing_in_ppm:(length(MTA)-1)*spacing_in_ppm;
offset_full = -(length(z)-1)/2*spacing_in_ppm:spacing_in_ppm:(length(z)-1)/2*spacing_in_ppm;
z_normal = z/max(z);


plot(offset,MTA)
hold on
xlabel('offset (ppm)')
ylabel('MT_{asymm}')
title(['MT_{asymm} -' ExperimentName])
hold off

figure()
hold on
plot(offset_full,z_normal)
title (['Z-Spectra -' ExperimentName])
xlabel('offset (ppm)')
ylabel('Normalized Response')
hold off