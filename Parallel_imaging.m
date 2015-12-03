clear all
close all
warning('off','MATLAB:colon:nonIntegerIndex')
warning('off','MATLAB:NonIntegerInput')
Biosemi_tcp %Creates structure with paremeters and TCP object to stream data from BioSemi


%% Try to connect to BioSemi, Actiview must be running
fclose(EEG.tcp_obj);

try
    fopen(EEG.tcp_obj)
catch
    disp('Unable to open TCP connection with BioSemi, check ActiView is running')
end


%% Load mesh and
% still need to implement this properly

Mesh = load('D:\Documents\Experimental Data\SA060.mat');
load('D:\Documents\Experimental Data\SA060-elecs.mat');
%Convert to 'simple' mesh that can be used in MATLAB scatter plots


[mesh_simple, centre_inds] = cylindrical_tank_mesh_simplify(Mesh, 0.05);

%Use only the mesh elements that are close to 0 on the z axis to reduce
%number of elements and improve computation time later.
mesh_simple = mesh_simple(:,centre_inds);

%Create grid data for plotting surface
step_size = 0.25;
[Xg, Yg] = meshgrid(  min(mesh_simple(1,:)):step_size:max(mesh_simple(1,:)),...
                    min(mesh_simple(2,:)):step_size:max(mesh_simple(2,:))...
                    );
                
Vq = griddata(  mesh_simple(1,:), mesh_simple(2,:), mesh_simple(3,:),...
                Xg,Yg); 
            
%Create inital plot of the tank
h = surf(Xg,Yg,Vq);
view(2)
plot_text = text(   0.8,0.9,'Time','Units','normalized',...
                    'FontSize',16,'FontName','Times New Roman')

%% construct the Jacobian
load('D:\Documents\Experimental Data\Parallel Current Source\Evaluation Data\Tank 32 Channel\Jacobian.mat');
load('D:\Documents\Experimental Data\Parallel Current Source\Evaluation Data\Tank 32 Channel\prtfull.mat');

%remove unused from jac/prt/bv0
prt_keep = [1:30 61:120];
J = J (prt_keep, centre_inds);
BV0 = BV0(prt_keep);

%% Gather small (1s or so) amount of data to detect injection electrodes and frequencies
Data  = get_x_seconds_of_data(EEG)';
[Prt Freqs] = Find_Injection_Freqs_And_Elecs(Data,EEG.Fs);
Freqs = [994 ;1985; 2989];
Prt = [5 21; 1 17; 9 25];

figure
h_prt = plot_prt(elec_pos,Freqs,Prt);

% Generate full protocol
prtfull = gen_prt(Prt,EEG.N_elecs);

%% precompute SVD to save time
tic
[U,S,V] = svd(J,'econ');
disp 'Time to compute SVD of Jacobian'
toc

%% Setup filter
Filt.Order = 5;
Filt.Band = 500;

%% Generate baseline data set
Baseline = get_BV(Data,EEG,Filt,Freqs,Prt);

%% Get data from BioSemi and reconstruct


drawnow
% How much data to collect for each image
EEG.Seconds_of_data = (250*EEG.Fs/min(Freqs))/EEG.Fs;

    fclose(EEG.tcp_obj) %For some reason data collection doesn't work properly if don't do this
    fopen(EEG.tcp_obj)  %Think it happens if there is too long a delay between read calls.
while(1)
    tic
    %disp(['TCP Bytes: ' num2str(EEG.tcp_obj.BytesAvailable)])
    Data  = get_x_seconds_of_data(EEG)';
    %disp ( ['Load Data ' num2str(toc)]); tic

    Pert = get_BV(Data,EEG,Filt,Freqs,Prt);
    dV = Pert - Baseline;
    
    X=Reconstruct(dV,BV0,J,U,S,V);
    
        %disp ( ['Recon ' num2str(toc)]); tic

 Vq = griddata(  mesh_simple(1,:), mesh_simple(2,:), X,...
                Xg,Yg); 
            
 set(h,'CData',Vq)
drawnow

 set(plot_text,'String',toc)
       

    
end

%to do:
%better plot of recon
%Speed up recon - fixed lamba? Look at Noise correction
