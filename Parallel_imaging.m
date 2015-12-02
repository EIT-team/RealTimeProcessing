clear all
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


%% Load mesh and construct the Jacobian
% still need to implement this properly

Mesh = load('D:\Documents\Experimental Data\SA060.mat');
load('D:\Documents\Experimental Data\SA060-elecs.mat');
%Convert to 'simple' mesh that can be used in MATLAB scatter plots

[mesh_simple, centre_inds] = cylindrical_tank_mesh_simplify(Mesh, 0.5);

load('D:\Documents\Experimental Data\Parallel Current Source\Evaluation Data\Tank 32 Channel\Jacobian.mat');
load('D:\Documents\Experimental Data\Parallel Current Source\Evaluation Data\Tank 32 Channel\prtfull.mat');

%Use only the mesh elements that are close to 0 on the z axis to reduce
%number of elements and improve computation time later.
mesh_simple = mesh_simple(:,centre_inds);

%remove unused from jac/prt/bv0
prt_keep = [1:30 61:120];
J = J (prt_keep, centre_inds);
BV0 = BV0(prt_keep);

%% Gather small (1s or so) amount of data to detect injection electrodes and frequencies
Data  = get_x_seconds_of_data(EEG)';
[Prt Freqs] = Find_Injection_Freqs_And_Elecs(Data,EEG.Fs);
Freqs = [994 ;1985; 2989];
Prt = [5 21; 1 17; 9 25];

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

%h=scatter(mesh_simple(1,:),mesh_simple(2,:),1); %handle to scatter plot
props = {'LineStyle','none','Marker','o','MarkerEdge','b','MarkerSize',6}; % axes properties
cla;

h=line([mesh_simple(1,:),mesh_simple(1,:)],[mesh_simple(2,:),mesh_simple(2,:)],props{:});
h1 = get(h);

set(h1.Parent,'XLim',[-10 10],'YLim',[-10 10],'XTickLabel','','YTickLabel','');
set(h1.Parent,'NextPlot','replacechildren');

drawnow
% How much data to collect for each image
EEG.Seconds_of_data = (250*EEG.Fs/min(Freqs))/EEG.Fs;

    fclose(EEG.tcp_obj) %For some reason data collection doesn't work properly if don't do this
    fopen(EEG.tcp_obj)  %Think it happens if there is too long a delay between read calls.
while(1)
    tic
        
    Data  = get_x_seconds_of_data(EEG)';
    %disp ( ['Load Data ' num2str(toc)]); tic

    Pert = get_BV(Data,EEG,Filt,Freqs,Prt);
    dV = Pert - Baseline;
    
    X=Reconstruct(dV,BV0,J,U,S,V);
    
        %disp ( ['Recon ' num2str(toc)]); tic

 
  A = abs(X)>0.25e-2;
set(h,'XData',mesh_simple(1,A),'YData',mesh_simple(2,A));
drawnow

toc
        %disp ( ['Draw ' num2str(toc)]);

    
end

%to do:
%better plot of recon
%Speed up recon - fixed lamba? Look at Noise correction