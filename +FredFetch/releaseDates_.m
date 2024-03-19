function [returned] = releaseDates_(input)
% [returned] = releaseDates_(series) will return release dates for the
% given series.
%
% [returned] = releaseDates_(releaseNumber) will return dates for the
% given Fred release number.


  %% Get the release ID for the given series

    % It's a series name; get the release id number
    if ischar(input)
      release_id = FredFetch.releaseID_(input);
    else
      release_id = input;
    end

  %% Download the release dates for that release ID

    opt = FredFetch.GlobalOptions();
    datesURL = sprintf([...
            'https://api.stlouisfed.org/fred/release/dates?' ...
            'release_id=%d' ...
            '&api_key=%s' ...
            '&include_release_dates_with_no_data=true' ...
            '&file_type=json'],...
            release_id, ...
            opt.api);
    fromFred = FredFetch.ReadFredURL_(datesURL, 1, opt.max_attempt);
    fromFred = [fromFredFetch.release_dates{:}];


    returned.release_id = release_id;
    returned.date       = FredFetch.dtnum({fromFredFetch.date}, 1)';

end
