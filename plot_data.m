function plot_data(data,EEG_Settings,h)
len = (1:size(data,2))/EEG_Settings.Fs;

for i = 1:EEG_Settings.N_CHANNELS
    axes(h(i));
    plot(len,data(i,:));
    
end
