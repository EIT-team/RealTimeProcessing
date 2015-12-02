%% Plot injections on the mesh/electrode map
function h = plot_prt (elec_pos,Freqs,Prt)

n_elecs = size(elec_pos,1);
n_freqs = size(Freqs);

%% plot electrode locations
h =scatter(elec_pos(:,1),elec_pos(:,2));

% % Add electrode numbers
% for i = 1:n_elecs
%     text(elec_pos(i,1),elec_pos(i,2),num2str(i))
% end
x_range = max(xlim);
y_range = max(ylim);

hold on
for i = 1:n_freqs
    
    e1 = elec_pos( Prt(i,1),: ); %electrodes used for injection
    e2 = elec_pos( Prt(i,2),: );
      
    %Draw arrow between injecting electrodes
    scribe.doublearrow( 'Parent',h,...
                        'X',    [e1(1) e2(1)],...
                        'Y',    [e1(2) e2(2)],...
                        'Head2Width',250 ,'Head2Length',250,...
                        'Head1Width',250 ,'Head1Length',250 ...
                        );
                    
   %Annotate injection frequency
      
    text(   e1(1)+0.025*x_range,e1(2)+0.025*y_range,[num2str(Freqs(i)) 'Hz'],...
            'FontName','Times New Roman','FontSize', 12) 
end 
end