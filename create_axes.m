%Create axes for each of the channels being recorded.
%Tom Dowrick 16.11.15

function h = create_axes(EEG)

height = (1-0.05)/EEG.N_elecs;

for i = 1:EEG.N_elecs
    
    h(i) = axes('Position',[0.05, 0.05+(i-1)*height, 0.9, height*0.95]);
    ylabel([num2str(i)]);
    
    
    
end

set(h(:),'XLim', [0 EEG.Seconds_of_data])
set(h(2:end),'XTickLabel','')
set(h(:),'YTickLabel','', 'YLim', [-EEG.Max_voltage_uV EEG.Max_voltage_uV])
set(h(:),'NextPlot','replacechildren')

axes(h(1))

xlabel('Time (s)')

for i = 1:EEG.N_elecs
    
    h(i) = plot(h(i),[0 EEG.Max_voltage_uV],[0 EEG.Seconds_of_data]);
    %Create child object, so it can be updated when plotting real data 
    
end
