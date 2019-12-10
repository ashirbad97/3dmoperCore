function foverecordedresultsv2114 = import_eyedata(filename, dataLines)
%IMPORTFILE Import data from a text file
%  FOVERECORDEDRESULTSV2114 = IMPORTFILE(FILENAME) reads data from text
%  file FILENAME for the default selection.  Returns the data as a table.
%
%  FOVERECORDEDRESULTSV2114 = IMPORTFILE(FILE, DATALINES) reads data for
%  the specified row interval(s) of text file FILENAME. Specify
%  DATALINES as a positive scalar integer or a N-by-2 array of positive
%  scalar integers for dis-contiguous row intervals.
%
%  Example:
%  foverecordedresultsv2114 = importfile("D:\Rijul\SONA VR Postprocessing\Results\001\fove_recorded_results_v2_1_14.csv", [2, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 28-Aug-2019 14:14:43

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [2, Inf];
end

%% Setup the Import Options
opts = delimitedTextImportOptions("NumVariables", 10);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["frameTime", "leftGazedirectionx", "leftGazedirectiony", "leftGazedirectionz", "rightGazedirectionx", "rightGazedirectiony", "rightGazedirectionz", "eyePos3Dx", "eyePos3Dy", "eyePos3Dz"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
foverecordedresultsv2114 = readtable(filename, opts);

end