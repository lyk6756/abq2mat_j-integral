function [ foundSet ] = findNodes( filename, NoLine, NoNextNSet )
% function [ foundSet ] = findNodes( filename, NoLine, NoNextNSet )
%------------------------------------------------------------------
% Purpose: Write a previously located data set (from function 
%          "findLines") in a text file and save the data set in 
%          <matrix double> form  
%------------------------------------------------------------------
% Input: filename    Name of the text file that the data set is 
%                    located (for instance an abaqus .inp file)
%        NoLine      Number of the line in filename that the 
%                    set sought for begins
%        NoNextSet   Number of the line in filename that the 
%                    next set after the one sought for begins
%------------------------------------------------------------------
% Output: foundSet   Vector containing the data set
%------------------------------------------------------------------
% Created by: Dimosthenis Floros, 20160816
%------------------------------------------------------------------

% Set counter of lines in the textfile that is being read

countLines = 1;

% Open the textfile with "read" permissions

fidIn = fopen( filename, 'r' );

% Create temporary text file to write the read data set in

temporaryFilename = 'Temporary.inp';

% Open the created temporary text file with "write" permissions

fidOut = fopen( temporaryFilename , 'w' );

% Read the textfile with "read" permissions line-by-line until
% the end-of-file has been reached

while ~feof( fidIn )
 
   % Read the current line string into currentLine variable
   currentLine = fgets( fidIn );
   
   % Check if the current line number lies between the line number
   % limits where the node-set sought for lies at. If the current line
   % lies within those line number limits, write the current line into
   % the temporary text file
   
   if countLines > NoLine && countLines < NoNextNSet 
    
      fprintf( fidOut, '%s \n', currentLine );
      
   end
   
   % Add one line number
   
   countLines = countLines + 1;
   
end

% Close both text files

fclose( fidIn );
fclose( fidOut );

% Read the data set written in the temporary text file into a variable
% in <matrix double> form

foundSet = dlmread( temporaryFilename, ',' );

% [~,~,v]= find(M);

% NodeSet = sort(v);

end