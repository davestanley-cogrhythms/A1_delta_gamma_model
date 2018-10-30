# model-dnsim-kramer_IB
DNSim model code for Kramer IB


kramer_IB
	This contains kramer_IB_single.m, which is a single compartment implementation of the
	kramer_IB cell. Just for playing around.


# Getting started (Mac / Linux)


### Clone main repo

	git clone --recursive git@github.com:davestanley-cogrhythms/model-dnsim-kramer_IB.git
	
OR

	git clone --recursive https://github.com/davestanley-cogrhythms/model-dnsim-kramer_IB.git


### Update submodules under master and dev
	cd model-dnsim-kramer_IB
	git checkout master
	git submodule update --init --recursive
	git checkout dev_dave_hcurrent6
	git submodule update --init --recursive

### Clone necessary repos into src folder

	mkdir ~/src
	cd ~/src
	git clone git@github.com:davestanley-cogrhythms/lib_dav
	git clone git@github.com:davestanley/SigProc-Plott.git
	cd SigProc-Plott
	git checkout dev
	git pull
	
### When pulling, be sure to also update submodules:
	git checkout master
	git pull --recurse-submodules	
	git checkout dev_dave_hcurrent6
	git pull --recurse-submodules

Setup instructions are the same for Windows, but using Windows syntax

Branches

	140416_Kramer_IB_singlecomp - Single compartment version of kramerIB.
	140416_Kramer_IB_singlecomp_axon - Single compartment modeling just the Axon instead of just the soma.
	jungIB - Kramer IB model converted over to Jung's parameters (based on master_dynasim)
	master - Original master branch
	master_dynasim - Master branch for KramerIB converted over to Dynasim
	original_model - Original model as in zip file

