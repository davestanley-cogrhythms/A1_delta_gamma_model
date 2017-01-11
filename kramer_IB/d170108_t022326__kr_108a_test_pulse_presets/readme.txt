108a_test_pulse_presets Wrote code and tested the 5 different pulse train modes.

Figs1-5 : Mode 0 - Default pulse train
	Fig1 - All sims average Vm
	Fig2 - All sims average RS Vm + synaptic variables
	Fig3 - Average activity with standard deviations
	Fig4-5 - Example of single simulation (sim 5)

Same pattern for remaining groups:
	Figs 6-10 : Mode 1 - AP pulse --> LTS activation
	Figs 11-15: Mode 2 - AP with reset --> no LTS activation (no doublet)
	Figs 16-20: Mode 3 - Dropped pulse --> weak LTS activation (no doublet, but LTS Vm does recover a bit; see also old folder, fig8)
	Figs 21-25: Mode 4 - Extra pulse --> yes LTS activation (triplet!)
	Figs 26-30: Mode 5 - Extra with resets --> yes LTS activation (doublet)

Conclusion - it’s the doublet that causes LTS activation, not due to the beta-frequency gap (25+11ms) between longer delays. However, the case of dropping a pulse entirely was sufficient, yielding a longer (50ms gap), was sufficient to get substantial LTS activation. 

