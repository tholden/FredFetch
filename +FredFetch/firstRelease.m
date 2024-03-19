function [returned] = firstRelease(series, varargin)

  [opt, toPass] = FredFetch.parseVarargin_({'parworkers', 'pseudo'}, varargin{:});
  returned = FredFetch.dispatch_(0, opt.parworkers, @FredFetch.firstRelease_, series, toPass{:});

end
