%Create axes for each of the channels being recorded.
%Tom Dowrick 16.11.15

function h = create_axes(EEG_Settings)

height = (1-0.05)/EEG_Settings.N_elecs;

for i = 1:EEG_Settings.N_elecs
    
    h(i) = axes('Position',[0.05, 0.05+(i-1)*height, 0.9, height*0.95]);
    ylabel([num2str(i)]);
    
    
    
end

set(h(:),'XLim', [0 EEG_Settings.Seconds_Of_Data])
set(h(2:end),'XTickLabel','')
set(h(:),'YTickLabel','', 'YLim', [-EEG_Settings.Max_Voltage EEG_Settings.Max_Voltage])
set(h(:),'NextPlot','replacechildren')

axes(h(1))

xlabel('Time (s)')

for i = 1:EEG_Settings.N_elecs
    
    h(i) = plot(h(i),[0 EEG_Settings.Max_Voltage],[0 EEG_Settings.Seconds_Of_Data]);
    %Create child object, so it can be updated when plotting real data 
    
end
