function [returned] = releaseID(series, varargin)

  % Check for parallel workers
  [opt, toPass] = FredFetch.parseVarargin_({'parworkers'}, varargin{:});

  % Dispatch the call
  returned = FredFetch.dispatch_(0, opt.parworkers, @FredFetch.releaseID_, series);

end
