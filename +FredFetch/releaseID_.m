function [returned] = releaseID_(series, parworkers)
% [release_id] = FredFetch.releaseID_(series) will return the FRED release ID
% number for a given series.

  opt = FredFetch.GlobalOptions();
  releaseURL = sprintf([...
          'https://api.stlouisfed.org/fred/series/release?' ...
          'series_id=%s' ...
          '&api_key=%s' ...
          '&realtime_start=1776-07-04',...
          '&realtime_end=9999-12-31',...
          '&file_type=json'],...
          series, ...
          opt.api);

  % Download
  fromFred = FredFetch.ReadFredURL_(releaseURL, 1, opt.max_attempt);

  % Extract
  release_id = unique(cellfun(@(d) d.id, fromFredFetch.releases));;

  % Make sure there's only one release ID for that series (seems like
  % there should be, but we check for that just in case)
  if length(release_id) > 1
    error(sprintf('Multiple release IDs for series %s', series))
  end

  returned.series       = series;
  returned.release_id   = release_id;
  returned.release_name = fromFredFetch.releases{end}.name;
  returned.release_link = fromFredFetch.releases{end}.link;

end
