function combined_visibility=visibility_geod_volum(visib_vol, visib_geod,vis_path,possibilityOnlyConvex,alpha,hta,delta)
% given the volumetric visibility and the geodesic visibility matrix compute the combned matrix, following certain rules

%INPUTS
% visib_vol=nodesNo x nodesNo symmetric,binary matrix of volumetric visibility
% visib_geod= nodesNo x nodesNo symmetric,binary matrix of geodesic visibility
% vis_path= nodesNo x nonodesNodes symmetric cell of visibility binary paths
% alpha, hta, delta parameters denoting the possibility of connection
% between nodes

%OUTPUTS
% combined_visibility= nodesNo x nodesNo fusion matrix, using the following rules:
% i) if nodei,nodej are both visible and convex -> output value = 1
% ii) if nodei,nodej are both non-visible and concave -> 0
% iii) if nodei,nodej are non-visible but convex -> alpha
% iv) if nodei,nodej are visible and concave ->1 if zero to one alternations percentqage > hta,
% else -> delta

%Note: It can directly work in case of faces, instead of nodes

nodeNo=(size(visib_vol,1));
combined_visibility=zeros(nodeNo,nodeNo);
for i=1:nodeNo
    
    for j=1:nodeNo
        %         if j>i
        
        if visib_geod(i,j)==0 && visib_vol(i,j)==0
            combined_visibility(i,j)=0;
            combined_visibility(j,i)=0;
            
        elseif visib_geod(i,j)==1 && visib_vol(i,j)==1
            combined_visibility(i,j)=1;
            combined_visibility(j,1)=1;
            
        elseif visib_geod(i,j)==1 && visib_vol(i,j)==0
            combined_visibility(i,j)=alpha;
            combined_visibility(j,i)=alpha;
            
        elseif visib_geod(i,j)==0 && visib_vol(i,j)== 1
            %count percentage of 1-0 changes
            vis_path{j,i}=vis_path{i,j};
            l_path=length(vis_path{i,j});
            changesNo=sum(abs(diff( vis_path{i,j})));
            if changesNo/(l_path-1) >= hta  && l_path>4 % (4 is related to selected R value)
                combined_visibility(i,j) = 1;
                combined_visibility(j,i) = 1;
            else
                combined_visibility(i,j) = delta;
                combined_visibility(j,i) = delta;
            end
        end
        %         end
    end
end