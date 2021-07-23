function [ NoTotal, NoLine, NoNextNSet, checkGenerate ] = ...
           findLines( filename, seekString )
% function [ NoTotal, NoLine, NoNextNSet ] = ...
%            findLines( filename, seekString, setName )
%--------------------------------------------------------------
% Purpose: Find the location (lines) of a data set in a text
%          file. The data set must lie between two strings, 
%          namely between seekString and setName
%--------------------------------------------------------------
% Input: filename    Name of the text file
%        seekString  Name of the data set sought for
%        setName     Name of the set after the data set sought
%                    for
%--------------------------------------------------------------
% Output: NoLine      Number of the line in filename that the 
%                     set sought for begins
%         NoNextSet   Number of the line in filename that the 
%                     next set after the one sought for begins
%--------------------------------------------------------------
% Created by: Dimosthenis Floros, 20160816
%--------------------------------------------------------------
% Modified by: 1) Dimosthenis Floros, 20170815:
%                 a) Completed documentation
%                 b) Variable "setName" needs to be removed in 
%                    a subsequent modification
%--------------------------------------------------------------

% Open a text file to process

fid = fopen( filename );

% Initialize counter of the lines

NoTotal = 0;
NoLine  = 0;

Occur = 0; % Flag accounting for the occurences of the set sought for

% Initialize variable for checking existence of "generate"

checkGenerate = 0;

% Read the text file line-by-line until the end of file is reached

while ~feof( fid )
    
    % Read the current line in the text file
    
    thisLine = fgetl( fid );
    
    % Check if the string read from the current line matches the name
    % of the node-set sought for
    
    matches = strfind( thisLine, seekString );
    
    % numNode = 1 if there is a match, else numNode = 0
    
    numNode = length( matches );
    
    % Add the current line number in the text file that is being read
    
    NoTotal = NoTotal + 1;
    
    % Check if the node-set sought for appears for the first time 
    % and give a flag = 1 to the result
    
    if numNode > 0 && Occur == 0
     
       NoLine = NoTotal;
       Occur  = 1;
       
       % Check for generate rule in node set
       
       existGenerate = strfind( thisLine, 'generate' );
       
       if isempty( existGenerate ) == 0
        
          checkGenerate = 1;
       
       end
       
    end    
        
    % Check if the string of the current line matches with the name
    % of the set with comes after the set sought for
    
    matchesNset = strfind( thisLine, '*' );
    numNodeNset = length( matchesNset );
    
    % Check if seekString has been read in the previous line && if
    % there is a match between setName and the current line. 
    % If there is match, set a flag = 2
       
    if Occur == 1 && numNodeNset > 0 && NoLine < NoTotal 
     
        NoNextNSet = NoTotal;
        Occur      = 2;
        
    end
    
end

% Close the text file being read

fclose( fid );

end
