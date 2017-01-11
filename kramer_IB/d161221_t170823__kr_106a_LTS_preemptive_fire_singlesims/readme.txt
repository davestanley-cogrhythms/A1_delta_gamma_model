106a_LTS_preemptive_fire_singlesims Used different parameter regime so that LTS cells fire before the 4th pulse in the AP series.

Connectivity:
	RS->LTS = 0.15
	FS->LTS = 0.20

Folder ./1_unconnected
	Figs 1-3 Shuffle
	Figs 4-6 Seed 0
	Figs 7-9 Seed 1
	Fig 10-12 Seed 2

Folder other: Added LTS->RS synapse; keep using seed 2 
Fig 13-15 gLTS->RS = 3; seed=3
Fig 16-18 gLTS->RS = 2; seed=3

Folder ./2_add_LTS_RS_g_2
	Do a bunch with gLTS->RS = 2 and seed = shuffle

Folder ./3_LTS_RS_g_3
	Do a bunch with gLTS->RS = 3 and seed = shuffle

