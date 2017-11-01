freqs = fliplr([.25 .5 1 1.5 2:23]);
axesObjs = get(gcf, 'Children');
for i = 1:26, label = get(axesObjs(2*i), 'YLabel'); set(label, 'String', sprintf('%g Hz', freqs(i))), end
for i = 1:52, set(axesObjs(i), 'YTick', []), end
for i = 1:52, set(axesObjs(i), 'XTickLabel', []), end
for i = 1:52, set(axesObjs(i), 'FontSize', 16), end
for i = 1:26, label = get(axesObjs(2*i), 'YLabel'); set(label, 'Rotation', 0), end
dataObjs = get(axesObjs, 'Children');
for i = 1:26, set(dataObjs{2*i - 1}, 'Color', 'r', 'LineWidth', 1), end
for i = 1:26, set(dataObjs{2*i}, 'LineWidth', 2), end
for i = 1:26, set(axesObjs(2*i - 1), 'YLim', [0 7]), end
for i = 1:52, label = get(axesObjs(i), 'XLabel'); set(label, 'String', ''), end
set(axesObjs(1), 'XTickLabel', 18:24)
set(get(axesObjs(1), 'XLabel'), 'String', 'Time (s)')
for i = 1:26, label = get(axesObjs(2*i), 'YLabel'); set(label, 'Color', 'r'), end