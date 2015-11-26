function plot_data(data,EEG_Settings,h)
len = (1:size(data,2))/EEG_Settings.Fs;

%decimation factor, to reduce amount of data plotted
dec_factor = 10;

for i = 1:EEG_Settings.N_elecs
    set(h(i),'YData',data(i,1:dec_factor:end)   ,'XData',len(1:dec_factor:end));
end
