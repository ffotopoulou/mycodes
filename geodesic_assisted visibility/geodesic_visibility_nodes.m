%define geodesic visibility matrix using volumetric visibility matrix

function [geodesic_v_mtx, visibility_paths]=geodesic_visibility_nodes(volumetric_visibility_mtx, elem,node, visibilityRadius,zeroNum)

%visibilityRadius: positive integer, radius of calculating visibility among the visibility path, that is we calculate
%visibility between node i and node i+visibilityRadius.
%zeroNum: least number of zeros in the visibility path that are enough for
% defining the face-pair as concave
% elem: 3 x faceNo
% node: 3 x nodeNo
% volumetric_visibility_mtx: nodeNo x nodeNo binary matrix

v_mtx=volumetric_visibility_mtx;

 nodeNo=max(size(node));
        node_A=full(triangulation2adjacency(elem,node));
        
        visibility_concavity=zeros(nodeNo,nodeNo);%assume all concave
        
        visibility_path_cell=cell(nodeNo);
        

for i=1:nodeNo
    
     [dists,node_paths] = graphshortestpath(sparse(node_A),i);

    for j=1:nodeNo
        if j>i
            node_path=node_paths{1,j};
            dist=dists(j);
            %define visibility path
            visibility_path=[];
            for p=1:length(node_path)-visibilityRadius
                visibility_path(p)=v_mtx(node_path(p),node_path(p+visibilityRadius));
            end
            
            if length(find(visibility_path==0))>=zeroNum %if there exists at least n non visible segment
                
                visibility_concavity(i,j)=0; %concave
                visibility_path_cell{i,j}=visibility_path;
                
            else
                visibility_concavity(i,j)=1; %convex
            end
            
            
            
            visibility_concavity(j,i)=visibility_concavity(i,j);
        end
    end
end

visibility_concavity=visibility_concavity+node_A;%adjacent faces are visible
visibility_concavity(visibility_concavity>0)=1;
geodesic_v_mtx=visibility_concavity;
visibility_paths=visibility_path_cell;





