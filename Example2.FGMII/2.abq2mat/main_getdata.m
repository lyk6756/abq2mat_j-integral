% Read nodal data from result file (.fil)
%
%     Record type         | Identifier | Record key | Type
%     Element definitions | -          | 1900       | -
%     Node definitions    | -          | 1901       | -
%     Displacements       | U          | 101        | node
%     Temperature         | NT         | 201        | node
%
% Add following command in the history data of the input file (.inp)
%     1|*FILE FORMAT, ASCII
%     2|*NODE FILE
%     3| U
%==============================================================================

% close all
clear

%------------------------------------------------------------------------------
%% Change the current directory
S = mfilename('fullpath');
f = filesep;
ind = strfind(S,f);
S1 = S(1:ind(end)-1);
cd(S1);

job_name = 'Job-1';

%------------------------------------------------------------------------------
%% Postprocess Abaqus input file with abaqusMesh2Matlab
% Extract node set 'crackFront'
seekString = '*Nset, nset=crackFront, instance=plate-1';
[~, NoLineSet, NoNextNSet] = findLines([job_name '.inp'], seekString);
connectivity = findNodes([job_name '.inp'], NoLineSet, NoNextNSet);
crackFront = reshape(connectivity',[],1);
crackFront(crackFront==0) = [];

%------------------------------------------------------------------------------
%% Postprocess Abaqus results file with Abaqus2Matlab
% Read the node field output
out = readFil([job_name '.fil'],[1900,1901,101,1911,1921],S1);
Elements = out{1};
Elements = cell2mat(Elements(:,3:end));
Nodes = out{2};
Nodes = Nodes(:,2:end);
U = out{3};
U = U(:,2:end);

%------------------------------------------------------------------------------
%% Save Variables to .mat file
save('data.mat', 'Nodes', 'Elements', 'U', 'crackFront');
