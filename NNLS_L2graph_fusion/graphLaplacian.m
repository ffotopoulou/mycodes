function [GL, GLsymmNorm,GLrandomNorm]=graphLaplacian(A)


A=A-diag(diag(A)); %no self loops 
D=diag(sum(A));%degree matrix
D=D+eps;
GL=D-A; % 1st eigenvector=stable

GLsymmNorm=D^(-0.5)*GL*D^(-0.5); % 1st eigenvector=sqrt(node_degree), 
% eigvalues=[0,2]

GLrandomNorm=D^(-1)*GL;% 1st eigenvector=stable, eigvalues=[0,2]