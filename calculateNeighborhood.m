function [sequence]=calculateNeighborhood(visibilityMatrix,adjacencyMatrix)
% this function calculates sequences from which the neighborhood n is given, in order to
% constrain the visibility matrix, for 2D and 3D shapes.

% INPUTS:
% visibilityMatrix = a binary symmetric matrix, where each non zero element
% denotes the visibility between nodes (i,j)
% adjacencyMatrix = a binary matrix that denotes nodes connection -  optional 2D cases
% Notice that if it is not provided, then a 2D case procedure will be
% considered
% OUTPUTS
%sequence = 1D signal, the index of the max value of this sequence denotes the neighborhood

%Author: Foteini Fotopoulou
%Last revised: 11/6/2016
if nargin <2 %2D case
    
    N=length(visibilityMatrix);
    for n=1:N/2-1
        T=toeplitz([ones(1,n+1) zeros(1,N-(2*n+1)) ones(1,n)]);
        s(n)=sum(sum(visibilityMatrix.*T));
    end
    stem(diff(s))
    sequence=diff(s);
else %3D case
    
    N=length(adjacencyMatrix);
    M=ones(N,N)-(eye(N));
    occupied=adjacencyMatrix;
    An=adjacencyMatrix.*M; %do not allow self loops
    s(1)=sum(sum(An));
    
    for n=2:N/2-1
        An=adjacencyMatrix^n.*M;
        An(An>0)=1;
        An=An-occupied; %do not count paths that we have already reached in less steps
        An(An<0)=0;
        occupied=occupied+An;
        occupied(occupied>0)=1;
        s(n)=sum(sum(An.*visibilityMatrix));
    end
    stem(s)
    sequence=s;
end
%Note
%Having defined the appropriate neighborhood n_hat:
%for the 2D case
%constrainedMatrix=toeplitz([ones(1,n_hatn+1) zeros(1,N-(2*n_hat+1)) ones(1,n_hat)]).*initialVisibility;
% for the 3D case
% constrainedMatrix=binary(adjacencyMatrix^n_hat).*visibility_init

