# model-dnsim-kramer_IB
DNSim model code for Kramer IB


kramer_IB
	This contains kramer_IB_single.m, which is a single compartment implementation of the
	kramer_IB cell. Just for playing around.


### Getting started (Mac / Linux)
=====

### Clone main repo

	git clone git@github.com:davestanley-cogrhythms/model-dnsim-kramer_IB.git


### Update submodules under master and dev
	git pull --recurse-submodules
	git checkout dev
	git pull --recurse-submodules
	git checkout master

### Clone necessary repos into src library

	mkdir ~/src
	cd ~/src
	git clone git@github.com:davestanley-cogrhythms/lib_dav
	git clone git@github.com:davestanley/SigProc-Plott.git
	cd SigProc-Plott
	git checkout dev
	git pull

Setup instructions are the same for Windows, but using Windows syntax

Branches
	140416_Kramer_IB_singlecomp - Single compartment version of kramerIB.
	140416_Kramer_IB_singlecomp_axon - Single compartment modeling just the Axon instead of just the soma.
	jungIB - Kramer IB model converted over to Jung's parameters (based on master_dynasim)
	master - Original master branch
	master_dynasim - Master branch for KramerIB converted over to Dynasim
	original_model - Original model as in zip file

