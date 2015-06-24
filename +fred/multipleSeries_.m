function [data] = multipleSeries_(toDataset, parworkers, dl_fcn, series, varargin)


  %% Maybe open up parallel pool
  if parworkers
    poolcheck = gcp('nocreate')
    if isempty(poolcheck)
      poolobj = parpool(parworkers)
    else
      poolobj = poolcheck;
    end
  end


  %% Download the series individually using dl_fcn

    Nseries    = length(series);
    individual = cell(Nseries, 1);
    if parworkers
      parfor s = 1:Nseries
        individual{s} = feval(dl_fcn, series{s}, varargin{:});
      end
    else
      for s = 1:Nseries
        individual{s} = feval(dl_fcn, series{s}, varargin{:});
      end
    end
    not_empty = find(cellfun(@(s) ~isfield(s.info, 'url'), individual));


  %% Merge or Join the downloaded objects

    % Just stack the returned arrays
    if ~toDataset
      data = vertcat(individual{:});
      for n = 1:length(series)
        data(n).series = upper(series{n});
      end

    else % Merge into data matrix

      % Add info
      data.info      = cellfun(@(s) s.info, individual, 'un', 0);
      data.series    = cellfun(@upper, series, 'un', 0);
      data.frequency = repmat({''},Nseries,1);
      data.frequency(not_empty) = cellfun(@(s) s.info.frequency_short, individual(not_empty), 'un', 0);

      % Align the vintage datasets
      alldates       = cellfun(@(s) s.date, individual(not_empty), 'un', 0);
      data.date  = sort(unique(vertcat(alldates{:})));
      data.value = nan(length(data.date), Nseries);
      for n = 1:length(not_empty)
        s = not_empty(n);
        insert = arrayfun(@(t) find(data.date==t), individual{s}.date);
        data.value(insert,s) = individual{s}.value;
      end
    end


  %% Shut down parpool
  if parworkers
    delete(poolobj);
  end

end
