%this is a memo for the SHREC10 database

clear all; close all; clc;

% number of components 
pNNLS=100;
pL2=65;
% sparsity parameter
lamda=0.015;
% regulariser parameter 
alpha = 0.3;
%embedding dimension
embDim=10;

%load Data
% GPS data as GPS_sqrt
load('GPS_sqrt_shrec10_contest.mat')

%ideal clustering (to be used for the RI computation)
idealIdx=[ones(1,20),2*ones(1,20),3*ones(1,20),4*ones(1,20) ,5*ones(1,20),6*ones(1,20), 7*ones(1,20), 8*ones(1,20),9*ones(1,20),10*ones(1,20)]';

% L2graph

%exclude 1st component
XnL2=GPS_sqrt(:,2:pL2)';

%data modification
[p,N]=size(XnL2);
for i=1:p; Xnorm(i,:)=XnL2(i,:)*sqrt(i); end

% data normalization
for i=1:N; nData(:,i)=Xnorm(:,i)/norm(Xnorm(:,i)); end
XnL2=nData; 

%constructing  L2 graph
list=[1:N]; I_i=diag(ones(1,N-1)); 
W=zeros(N,N); 

for i=1:N
    list_i=setdiff(list,i); 
    Xn_i=XnL2(:,list_i); 
    P_i=inv(Xn_i'*Xn_i+lamda*I_i)*Xn_i';
    coeff_i= P_i*XnL2(:,i);  
    W(list_i,i)=coeff_i; 
end
Wsym1=0.5*(abs(W)+abs(W'));
%column normalization
for i=1:N; nWsym1(:,i)=Wsym1(:,i)/norm(Wsym1(:,i)); end
Wsym1=nWsym1;

% NNLS graph
%exclude 1st component
XnNNL=GPS_sqrt(:,2:pNNLS)';

%data modification
[p,N]=size(XnNNL);
for i=1:p; Xnorm_NNLS(i,:)=XnNNL(i,:)*sqrt(i); end

% data normalization
clear nData
for i=1:N; nData(:,i)=Xnorm_NNLS(:,i)/norm(Xnorm_NNLS(:,i)); end
XnNNL=nData; 


% Constructing NNLS-graph
W=zeros(N,N); 
for i=1:N
    list_i=setdiff(list,i); Xn_i=XnNNL(:,list_i);   
     coeff_i=lsqnonneg(Xn_i,XnNNL(:,i));    
     W(list_i,i)=coeff_i;
end
Wsym2=0.5*(W+W');
%column normalization
for i=1:N; nWsym2(:,i)=Wsym2(:,i)/norm(Wsym2(:,i)); end
Wsym2=nWsym2;

%--fusion
MatrixStruct(1).graph = Wsym1;
MatrixStruct(2).graph = Wsym2;


RIave=0;
%Clustering multilayer graph 
% 1000 repetitions - average 
for k=1:1000 
clusterIdx=spectral_clustering_multiLayerGraphs ...
    (MatrixStruct, embDim,alpha); 

[AR,RI,MI,HI]=RandIndex(clusterIdx,idealIdx);
RIave=RIave+RI/1000;
end
