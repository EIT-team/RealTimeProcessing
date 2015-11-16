%Create axes for each of the channels being recorded.
%Tom Dowrick 16.11.15

function h = create_axes(EEG_Settings)

for i = 1:EEG_Settings.N_CHANNELS
    
    height = (1-0.05)/EEG_Settings.N_CHANNELS;
    h(i) = axes('Position',[0.05, 0.05+(i-1)*height, 0.9, height*0.95]);
    
    axes(h(i))
    ylabel([num2str(i) ' (uV)'])

end

set(h(1),'XLim', [0 EEG_Settings.Seconds_Of_Data])
set(h(2:end),'XTickLabel','')
set(h(:),'YTickLabel','', 'YLim', [0 EEG_Settings.Max_Voltage])
set(h(:),'NextPlot','replacechildren')

axes(h(1))
xlabel('Time (s)')