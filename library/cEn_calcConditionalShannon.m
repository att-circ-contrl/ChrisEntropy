function bits = cEn_calcConditionalShannon( dataseries, bins, exparams )

% function bits = cEn_calcConditionalShannon( dataseries, bins, exparams )
%
% This calculates the conditional entropy associated with a set of signals.
% This is the average amount of additional information that a sample from
% variable Y gives you when you already know variables X_1..X_k.
%
% This needs a large number of samples to generate accurate results. To
% compensate for smaller sample counts, this may optionally use the
% extrapolation method described in EXTRAPOLATION.txt.
%
% "dataseries" is a (Nchans,Nsamples) matrix containing several data series.
%   The first series (chan = 1) is the variable Y; remaining series are X_k.
% "bins" is a scalar or vector (to generate histogram bins) or a cell array
%   (to supply bin edge lists). If it's a vector of length Nchans or a
%   scalar, it indicates how many bins to use for each channel's data. If
%   it's a cell array, bins{chanidx} provides the list of edges used for
%   binning each channel's data.
% "exparams" is a an optional structure containing extrapolation tuning
%   parameters, per EXTRAPOLATION.txt. If this is empty, default parameters
%   are used. If this is absent, no extrapolation is performed.
%
% "bits" is a scalar with the average additional entropy provided by an
%   observation of Y, when all X_k are known.


% Use consistent bin definitions.

if iscell(bins)
  % We were given edge lists.
  edges = bins;
else
  % We were given one or more bin counts; generate edge lists.
  edges = cEn_getMultivariateHistBins( dataseries, bins );
end


% Wrap the binning and conditional entropy calculation functions.
datafunc = @(funcdata) helper_calcConditionalShannon( funcdata, edges );

if exist('exparams', 'var')
  % We were given an extrapolation configuration; perform extrapolation.
  bits = cEn_calcExtrapWrapper( dataseries, datafunc, exparams );
else
  % We were not given an extrapolation configuration; don't extrapolate.
  bits = datafunc(dataseries);
end


% Done.
end


%
% Helper Functions

function thisentropy = helper_calcConditionalShannon( rawdata, edges )
  [ thisbinned scratch ] = cEn_getBinnedMultivariate( rawdata, edges );
  thisentropy = cEn_calcConditionalShannonHist( thisbinned );
end


%
% This is the end of the file.
