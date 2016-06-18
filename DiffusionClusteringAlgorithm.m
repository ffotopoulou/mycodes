function [clusteringMatrix]=DiffusionClusteringAlgorithm(visibilityMatrix,diffusion, shrinking, noIters)
%This function is the main function of the unspervised Diffusion
%Clustering Algorithm. The input matrix is iteratively converted to a
%clustering matrix, using the notion of diffusion and shrinking the
%visibility information provided.
%Proposed by F.Fotopoulou and E.Z. Psarakis

% INPUTS
% visibilityMatrix: a binary symmetric matrix, where each non-zero element
%       denotes the visibility between nodes (i,j). Neighborhood constraints are
%       essential, that is set to zero distant nodes' visibility.
% diffusion: a positive integer that defines the degree of visibility diffusion
% shrinking: a real number between [0,1] that sets the threshold to the
%       martix, after the diffusion process
% noIters: the number of iterations that will be used for the iterative
%       procedure.

% OUTPUTS
% clusteringMatrix: a binary matrix of same size as input
% visibilityMatrix, which contains clustering information: same lines(or
% columns) form a cluster.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%iterative calculation of ClusteringMatrix
if nargin<4
    noIters=25;
end
if nargin<3
    shrinking=0.5;
end
if nargin<2
    diffusion=2;
end
if nargin<1
    error('please provide at least the visibility matrix to cluster')
end
clusteringMatrix_th=zeros(size(visibilityMatrix)); %initialization

for iter=1:noIters
    
    diffusedMatrix=(visibilityMatrix^diffusion);
    %thresholding diffusedMatrix according to nodes' degree
    D=diag(diffusedMatrix);
    for i=1:length(diffusedMatrix)
        for j=1:length(diffusedMatrix)
            clusteringMatrix_th(i,j)=diffusedMatrix(i,j)./sqrt(D(i)*D(j)); %clusteringMatrix_th (i,j) actually tabulates the angle
            %between Visibility row i and j
        end
    end
    
    clusteringMatrix_th(clusteringMatrix_th>=shrinking)=1; % keep angles that are below 60 degrees. Angles that are 90 deg denote
    %orthogonal vectors, i.e. not similar. We want to discard the
    %non-similar ones
    clusteringMatrix_th(clusteringMatrix_th<shrinking)=0;
    visibilityMatrix=clusteringMatrix_th; %set the new VisibilityMatrix
    
end
clusteringMatrix=visibilityMatrix;


end
