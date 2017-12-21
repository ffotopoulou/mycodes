function combined_visibility=visibility_geod_volum(visib_vol, visib_geod,vis_path)
% given the volumetric visibility and the geodesic visibility matrix compute the combned matrix, following certain rules

%INPUTS
% visib_vol=nodes x nodes symmetric,binary matrix of volumetric visibility
% visib_geod= nodes x nodes symmetric,binary matrix of geodesic visibility
% vis_path= nodes x nodes symmetric cell of visibility binary paths
%note: we have saved only the upper triangle part of the vis_path
%OUTPUTS
% combined_visibility= nodes x nodes fusion matrix, using the following rules:
% i) if nodei,nodej are both visible and convex -> 1
% ii) if nodei,nodej are both non-visible and concave -> 0
% iii) if nodei,nodej are non-visible and convex -> 0.5
% iv) if nodei,nodej are visible and concave ->0.1 if in the path there exists
% more than 4 concavities, then we set te fusion matrix to 0, else to 1

%Note: It can directly work in case of faces, instead of nodes
% Mind that the cell contains non zero elements only in cases where nodes or faces i-j are concave.
nodeNo=(size(visib_vol,1));
combined_visibility=zeros(nodeNo,nodeNo);
for i=1:nodeNo
%     i
    for j=1:nodeNo
%         if j>i
            
            if visib_geod(i,j)==0 && visib_vol(i,j)==0
                combined_visibility(i,j)=0;
                combined_visibility(j,i)=0;
                
            elseif visib_geod(i,j)==1 && visib_vol(i,j)==1
                combined_visibility(i,j)=1;
                combined_visibility(j,1)=1;
                
            elseif visib_geod(i,j)==1 && visib_vol(i,j)==0
                combined_visibility(i,j)=0.5; %cup-like
                combined_visibility(j,i)=0.5; %cup-like
                
            elseif visib_geod(i,j)==0 && visib_vol(i,j)==1
                vis_path{i,j}=vis_path{j,i};
                l_path=length(vis_path{i,j});
                zeroNo=length(find(vis_path{i,j}==0));
                if zeroNo>0.6*l_path && l_path>4
                    combined_visibility(i,j)=1; %flat parallel surfaces areas
                    combined_visibility(j,i)=1;
                else
                    combined_visibility(i,j)=0.1;%probably different segments, or noisy tubular
                    combined_visibility(j,i)=0.1;
                end              
            end
%         end
    end
end