function [clusterIdx,GLsymmNorm,spectra_space_coord]=spectral_clustering(a_matrix, embedding_space, bias)
%INPUTS:
% a_matrix        : affinity matrix
% embedding_space : dimension of embedding space
% bias            : boolean, whether to multiply each eigenvector by its corresponding eigvalue
% OUPUT:
% cluster indices

% dependencies:
% graphLaplacian.m

if nargin<3
    bias=false;
end

[~, GLsymmNorm,~]=graphLaplacian(a_matrix);
[eigVectors,eigValues] = eig(GLsymmNorm);

% Sort co-ordinates in the spectral space of the k eigenvectors
if ~issorted(diag(eigValues))
    [sorted,I] = sort(diag(eigValues));
    eigVectors = eigVectors(:, I);
    if bias==true
        eigVectors=eigVectors./repmat(sqrt(sorted),1,size(eigValues,2));
    end
end

spectra_space_coord=eigVectors(:,1:embedding_space); %keep embedding_space eigenvectors that
%correspond to smallest eigenvalues

%ATTENTION: normalize rows only when using GLsymmNorm matrix (see
%graphLaplacian.m)
clusterIdx = kmeans(normr(spectra_space_coord),embedding_space); %normalize rows to unit length