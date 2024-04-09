function milist = ...
  cEn_calcLaggedMutualInfo( dataseries, laglist, bins, exparams)

% function milist = ...
%   cEn_calcLaggedMutualInfo( dataseries, laglist, bins, exparams)
%
% This calculates the mutual information between a destination signal and
% time-lagged source signals. This is the amount of information shared
% between the variables, as measured by comparing the joint probability
% distribution with the distribution expected for independent variables.
%
% This is less informative than transfer entropy but can be faster to
% calculate.
%
% This needs a large number of samples to generate accurate results. To
% compensate for samller sample counts, this may optionally use the
% extrapolation method described in EXTRAPOLATION.txt.
%
% "dataseries" is a cell array of length Nchans containing data series. The
%   first series (chan = 1) is the destination signal; remaining series are
%   source signals. Each series is either a vector of length Nsamples or a
%   matrix of size Ntrials x Nsamples.
% "laglist" is a vector containing sample time lags to test. These are
%   applied to the "source" signals. These may be negative (future times).
% "bins" is a scalar or vector (to generate bins) or a cell array (to supply
%   bin definitions). If it's a vector of length Nchans or a scalar, it
%   indicates how many bins to use for each channel's data. If it's a cell
%   array, bins{chanidx} provides the list of edges used for binning each
%   channel's data.
% "exparams" is an optional structure containing extrapolation tuning
%   parameters, per EXTRAPOLATION.txt. If this is empty, default parameters
%   are used. If this is absent, no extrapolation is performed.
%
% "milist" is a vector with the same dimensions as laglist containing
%   mutual information estimates for each time lag.


% Metadata.

want_extrap = exist('exparams', 'var');

xcount = length(dataseries) - 1;
lagcount = length(laglist);

% Unpack source and destination series.
dstseries = dataseries{1};
srcseries = dataseries(2:(xcount+1));



%
% Walk through the lag list, building mutual information estimates.

milist = nan(size(laglist));

for lidx = 1:lagcount

  thislag = laglist(lidx);

  % Shift, crop, and concatenate the data trials.
  [ dstpresent dstpast srcpast ] = ...
    cEn_teHelperShiftAndLinearize( dstseries, srcseries, thislag, laglist );

  % We don't care about "dstpast".
  datamatrix = dstpresent;
  for xidx = 1:xcount
    datamatrix = [ datamatrix ; srcpast{xidx} ];
  end

  if want_extrap
    % We were given an extrapolation configuration.
    milist(lidx) = cEn_calcMutualInfo( datamatrix, bins, exparams );
  else
    % We were not given an extrapolation configuration.
    milist(lidx) = cEn_calcMutualInfo( datamatrix, bins );
  end

end


% Done.
end


%
% This is the end of the file.
