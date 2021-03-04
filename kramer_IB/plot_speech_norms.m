sentence3 = getSentence(0:.01:2000, 128, 0.5, 0, [], [], 2);

sentence2 = getSentence(0:.01:2000, 128, 0.5, 0, [], [], 1);

sentence1 = getSentence(0:.01:2000, 128, 0.5, 0, [], [], 0);

subplot(3, 1, 1), imagesc(sentence1.cochlear'), axis xy, colorbar, title('No Norm')

subplot(3, 1, 2), imagesc(sentence2.cochlear'), axis xy, colorbar, title('Sum = 1')

subplot(3, 1, 3), imagesc(sentence3.cochlear'), axis xy, colorbar, title('Max = 1')

saveas(gcf, 'speech_norms.fig')