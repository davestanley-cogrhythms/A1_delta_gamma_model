function check_timit_phase(si, modes)

name = sprintf('timit_phase_%g%s', si, make_label('modes', modes));

if exist([name, '.mat'], 'file')
    
    load([name, '.mat'])
    
else  
    
    time = 0:.01:3500;
    
    sentence = getSentence(0:.01:3500, 128, si, 100);
    
    sentence = sentence.cochlear(:, 4:8:end);
    
    if modes == -1
        
        sentence_wr = wavelet_spectrogram(sentence, 10^5, 7, 5);
        
    elseif ~modes
        
        sentence_wr = hilbert(detrend(sentence));
        
    else
    
        sentence_wr = wavelet_reduce(sentence, 10^5, modes, 2);
    
    end

    save([name, '.mat'], 'time', 'sentence', 'sentence_wr')
    
end
        
sentence_phase = angle(sentence_wr);

figure

for c = 1:size(sentence, 2)
    
    subplot(4, 4, c)
    
    [ax, h1, h2] = plotyy(time, sentence_phase(:, c), time, real(sentence_wr(:, c)));
    
    set(h1, 'LineWidth', 1)
    
    set(h2, 'LineWidth', 1.5)
    
    axis(ax, 'tight')
    
    xlim(ax, [0 2200])
    
    box off
    
    new_ax = axes('Position', get(gca, 'Position'), 'Units', 'normalized');
    
    plot(new_ax, time, sentence(:, c), 'k', 'LineWidth', 1.5)
    
    axis(new_ax, 'tight')
    
    xlim(new_ax, [0 2200])
    
    set(new_ax, 'Visible', 'off')
    
end

saveas(gcf, [name, '.fig'])

end