function [data] = latest(series, varargin)

  opt = FredFetch.parseVarargin_({'parworkers', 'pseudo', 'units'}, varargin{:});
  data = FredFetch.dispatch_(opt.toDatasetByVint, opt.parworkers, @FredFetch.latest_, series);

  % Maybe transform
  if iscell(opt.units) | ischar(opt.units)
    data = FredFetch.transform(data, opt.units);
  end

end
