[X, Y] = meshgrid(  min(mesh_simple(1,:)):0.25:max(mesh_simple(1,:)),...
                    min(mesh_simple(2,:)):0.25:max(mesh_simple(2,:))...
                    );
   
               
        
                
            h = surf(X,Y,Vq);
 %%
 tic
 for i = 1:100
%  Vq = griddata( mesh_simple(1,:), mesh_simple(2,:), i*mesh_simple(3,:),...
%                 X,Y);
   Vq = griddata( mesh_simple(1,:), mesh_simple(2,:), mesh_simple(3,:),...
                X,Y);     
      set(h,'CData',Vq)
      drawnow
 end
 toc/100
%% 
tic
h = surf(X,Y,Vq);
view(2)
toc

h=surf(X,Y,repmat(1,76,76),Vq);view(2)