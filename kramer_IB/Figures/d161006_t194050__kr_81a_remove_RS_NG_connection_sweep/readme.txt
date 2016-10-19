81a_remove_RS_NG_connection_sweep Swept through IB PPStim and FS->IB synapse strength. Investigating failure of this method of getting AP pulse. Seems to be a combination of NMDA in IB cells, too slow ramp up of gamma, and insufficient gap in activity via AP pulse.
	IB PPStim [-5, -4, -3]
	FS->IB synapse strength [.5,.6,.7,.8]

	Fig5 shows NMDA activity
	Figs 6-8: sample plots taken from position (4,2) (bottom middle!)
	Fig8 shows GABA A activity FS->IB

	Bonus Figs:
	Bonus1&2 - Taken from a different simulation (with IB->RS unblocked) and showing how even though firing activity is strangely quenched during the AP pulse. Not sure the reason for this. Interestingly, it seems from (d161006_t153729__kr_79g_adjust_IBPPStim_g_FSRS) that having higher IB PPStim actually INHIBITS the system during the AP pulse. What’s up with this!?
 