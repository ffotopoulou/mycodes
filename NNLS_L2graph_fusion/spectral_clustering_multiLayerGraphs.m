% spectral clustering on multilayer graphs
% Clustering on Multi-Layer Graphs via Subspace Analysis on Grassmann Manifolds
%INPUTS
%MatrixStruct(i).graph: i = 1,2,3, ... , the graphs that will be fused.
%                       Make sure they all share the same number of nodes
%embeddingSpace       : embedding dimension for the spectral clustering
%regulParam           : regulariser parameter that belongs to set [0,1] and 
%              affects the correlation between the graphs and the corresponding subspaces  
% OUTPUT:
% clusterIdx: index to clustering on the embeddingSpace clusters

%dependencies
% spectral_clustering.m

function clusterIdx=spectral_clustering_multiLayerGraphs ...
    (MatrixStruct, embeddingSpace,regulParam)

Lall=zeros(size(MatrixStruct(1).graph));
subSpaceCoordsAll=Lall; 
for graphIdx=1:length(MatrixStruct)
    
    [~,GLsymmNorm,subSpaceCoords]=spectral_clustering(MatrixStruct(graphIdx).graph, embeddingSpace, false);
    Lall=Lall+GLsymmNorm;
    subSpaceCoordsAll=subSpaceCoordsAll+subSpaceCoords*subSpaceCoords';
    
end

normlaplacianModif=Lall-regulParam*subSpaceCoordsAll;

[eigVectorsLmod,eigValuesLmod] = eig(normlaplacianModif);

if ~issorted(diag(eigValuesLmod))
    [~,I] = sort(diag(eigValuesLmod));
    eigVectorsLmod = eigVectorsLmod(:, I);
end

spectraSpaceCoordLmod=eigVectorsLmod(:,1:embeddingSpace); %keep embedding_space eigenvectors that
clusterIdx = kmeans(normr(spectraSpaceCoordLmod),embeddingSpace); %normalize rows to unit length

