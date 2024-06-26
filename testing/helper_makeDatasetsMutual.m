function datasets = helper_makeDatasetsMutual( sampcount, signaltype )

% function datasets = helper_makeDatasetsMutual( sampcount, signaltype )
%
% This builds data series used for testing calculation of mutual information
% and conditional Shannon entropy.
% All sample values are in the range 0..1.
%
% Data matrices have Nchans x Nsamples elements. data(1,:) is the dependent
% series (for conditional entropy) and data(k,:) are the independent series.
%
% "sampcount" is the desired number of samples per series.
% "signaltype" is 'noise', 'sine', or 'counts'.
%
% "datasets" is a Nx3 cell array. Element {k,1} is a Nchans x Nsamples
%   matrix containing data samples, element {k,2} is a short plot- and
%   filename-safe label, and element {k,3} is a plot-safe verbose label for
%   data series k.


% Make several uncorrelated noise series. One of them's our "signal".

data_signal = helper_makeDataSignal(sampcount, signaltype);

data_noise1 = helper_makeDataSignal(sampcount, signaltype);
data_noise2 = helper_makeDataSignal(sampcount, signaltype);


% Get signal-plus-noise series.

data_noisysignal1 = data_signal + data_noise1;
data_noisysignal2 = data_signal + data_noise2;

if ~strcmp(signaltype, 'counts')
  % Continuous data, so normalize it back to 0..1.
  data_noisysignal1 = 0.5 * data_noisysignal1;
  data_noisysignal2 = 0.5 * data_noisysignal2;
end


% Build test cases.

data_2ch_corr = [ data_signal ; data_signal ];
data_2ch_semicorr = [ data_signal; data_noisysignal1 ];
data_2ch_uncorr = [ data_signal ; data_noise1 ];

data_3ch_bothcorr = [ data_signal; data_noisysignal1; data_noisysignal2 ];
data_3ch_onecorr = [ data_signal ; data_noisysignal1 ; data_noise2 ];
data_3ch_uncorr = [ data_signal ; data_noise1 ; data_noise2 ];

datasets = ...
{ data_2ch_corr,     'cond2corr',  '2ch Strong' ; ...
  data_2ch_semicorr, 'cond2semi',  '2ch Weak' ; ...
  data_2ch_uncorr,   'cond2indep', '2ch None' ; ...
  data_3ch_bothcorr, 'cond3both',  '3ch Both' ; ...
  data_3ch_onecorr,  'cond3one',   '3ch One' ; ...
  data_3ch_uncorr, 'cond3indep',  '3ch None' };


% Done.
end


%
% This is the end of the file.
