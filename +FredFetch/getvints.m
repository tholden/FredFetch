function [vints] = getvints(series)

  vints = FredFetch.dispatch_(0, 0, @FredFetch.getvints_, series);

end
