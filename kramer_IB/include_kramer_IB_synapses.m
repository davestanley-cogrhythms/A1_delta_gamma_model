
% % This script adds all the synaptic connections between cells % %

% % % % % % % % % % % %  Connections  % % % % % % % % % % % % % %
i=0;
%% IB Cells
% % % % %  IB Cells  % % % % %
% % IB->IB recurrent synaptic and gap connections
if include_IB
    i=i+1;
    spec.connections(i).direction = 'IB->IB';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iNMDADestexhe1998Markov','IBaIBaiGAP'};
    spec.connections(i).parameters = {'g_SYN',gAMPA_ibib,'E_SYN',EAMPA,'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        'gNMDA',gNMDA_ibib,'ENMDA',EAMPA,'Rd ', Rd, 'Rr', Rr, ...    
        'g_GAP',ggja,...
        };
end

% % IB->deepNG
if include_IB && include_deepNG
    i=i+1;
    spec.connections(i).direction = 'IB->deepNG';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iNMDADestexhe1998Markov'};
    spec.connections(i).parameters = {'g_SYN',gAMPA_IBdeepNG,'E_SYN',EAMPA,'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        'gNMDA',gNMDA_IBdeepNG,'ENMDA',EAMPA,'Rd ', Rd, 'Rr', Rr, ...    
        };
end

% % IB->NG
if include_IB && include_NG
    i=i+1;
    spec.connections(i).direction = 'IB->NG';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iNMDADestexhe1998Markov'};
    spec.connections(i).parameters = {'g_SYN',gAMPA_ibng,'E_SYN',EAMPA,'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        'gNMDA',gNMDA_ibng,'ENMDA',EAMPA,'Rd ', Rd, 'Rr', Rr, ...    
        };
end

% % IB->RS
if include_IB && include_RS
    i=i+1;
    spec.connections(i).direction = 'IB->RS';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iNMDADestexhe1998Markov'};
    spec.connections(i).parameters = {'g_SYN',gAMPA_ibrs,'E_SYN',EAMPA,'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        'gNMDA',gNMDA_ibrs,'ENMDA',EAMPA,'Rd ', Rd, 'Rr', Rr, ...    
        };
end

% % IB->LTS
if include_IB && include_LTS
    i=i+1;
    spec.connections(i).direction = 'IB->LTS';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iNMDADestexhe1998Markov'};
    spec.connections(i).parameters = {'g_SYN',gAMPA_ibLTS,'E_SYN',EAMPA,'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        'gNMDA',gNMDA_ibLTS,'ENMDA',EAMPA,'Rd ', Rd, 'Rr', Rr, ...    
        };
end

%% Deep NG Cells
% % % % %  NG Cells  % % % % %
% % deepNG->deepNG Synaptic connections
if include_deepNG
    i=i+1;
    spec.connections(i).direction = 'deepNG->deepNG';                  
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iGABABAustin'};
    spec.connections(i).parameters = {'g_SYN',gGABAa_deepNGdeepNG,'E_SYN',EGABA,'tauDx',tauGABAad,'tauRx',tauGABAar,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
        'gGABAB',gGABAb_deepNGdeepNG,'EGABAB',EGABA,'tauGABABd',tauGABAbd,'tauGABABr',tauGABAbr,'gGABAB_hetero',gsyn_hetero,  ...
        'TmaxGABAB',TmaxGABAB ...
        };
end

% % deepNG->IB Synaptic connections
if include_deepNG && include_IB
    i=i+1;
    spec.connections(i).direction = 'deepNG->IB';                  
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iGABABAustin'};
    spec.connections(i).parameters = {'g_SYN',gGABAa_deepNGIB,'E_SYN',EGABA,'tauDx',tauGABAad,'tauRx',tauGABAar,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
        'gGABAB',gGABAb_deepNGIB,'EGABAB',EGABA,'tauGABABd',tauGABAbd,'tauGABABr',tauGABAbr,'gGABAB_hetero',gsyn_hetero, ...
        'TmaxGABAB',TmaxGABAB ...
        };
end

%% (Superficial) NG Cells
% % % % %  NG Cells  % % % % %
% % NG->NG Synaptic connections
if include_NG
    i=i+1;
    spec.connections(i).direction = 'NG->NG';                  
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iGABABAustin'};
    spec.connections(i).parameters = {'g_SYN',gGABAa_ngng,'E_SYN',EGABA,'tauDx',tauGABAad,'tauRx',tauGABAar,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
        'gGABAB',gGABAb_ngng,'EGABAB',EGABA,'tauGABABd',tauGABAbd,'tauGABABr',tauGABAbr,'gGABAB_hetero',gsyn_hetero,  ...
        'TmaxGABAB',TmaxGABAB ...
        };
end

% % NG->RS Synaptic connections
if include_NG && include_RS
    i=i+1;
    spec.connections(i).direction = 'NG->RS';                  
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iGABABAustin'};
    spec.connections(i).parameters = {'g_SYN',gGABAa_ngrs,'E_SYN',EGABA,'tauDx',tauGABAad,'tauRx',tauGABAar,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
        'gGABAB',gGABAb_ngrs,'EGABAB',EGABA,'tauGABABd',tauGABAbd,'tauGABABr',tauGABAbr,'gGABAB_hetero',gsyn_hetero, ...
        'TmaxGABAB',TmaxGABAB ...
        };
end

% % NG->FS Synaptic connections
if include_NG && include_FS
    i=i+1;
    spec.connections(i).direction = 'NG->FS';                  
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iGABABAustin'};
    spec.connections(i).parameters = {'g_SYN',gGABAa_ngfs,'E_SYN',EGABA,'tauDx',tauGABAad,'tauRx',tauGABAar,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
        'gGABAB',gGABAb_ngfs,'EGABAB',EGABA,'tauGABABd',tauGABAbd,'tauGABABr',tauGABAbr,'gGABAB_hetero',gsyn_hetero, ...
        'TmaxGABAB',TmaxGABAB ...
        };
end

% % NG->LTS Synaptic connections
if include_NG && include_LTS
    i=i+1;
    spec.connections(i).direction = 'NG->LTS';                  
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iGABABAustin'};
    spec.connections(i).parameters = {'g_SYN',gGABAa_nglts,'E_SYN',EGABA,'tauDx',tauGABAad,'tauRx',tauGABAar,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
        'gGABAB',gGABAb_nglts,'EGABAB',EGABA,'tauGABABd',tauGABAbd,'tauGABABr',tauGABAbr,'gGABAB_hetero',gsyn_hetero, ...
        'TmaxGABAB',TmaxGABAB ...
        };
end

%% RS Cells
% % % % %  RS Cells  % % % % %
% % RS->RS recurrent synaptic and gap connections
if include_RS
    i=i+1;
    spec.connections(i).direction = 'RS->RS';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','IBaIBaiGAP'};
    spec.connections(i).parameters = {'g_SYN',gAMPA_rsrs,'E_SYN',EAMPA,'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        'g_GAP',ggjaRS,...
        };
end

% % RS->FS synaptic connection
if include_RS && include_FS
    i=i+1;
    spec.connections(i).direction = 'RS->FS';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
    spec.connections(i).parameters = {'g_SYN',gAMPA_rsfs,'E_SYN',EAMPA,'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        };
end

% % RS->FS synaptic connection
if include_RS && include_LTS
    i=i+1;
    spec.connections(i).direction = 'RS->LTS';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
    spec.connections(i).parameters = {'g_SYN',gAMPA_rsLTS,'E_SYN',EAMPA,'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        };
end

% % RS->NG synaptic connection
if include_RS && include_NG
    i=i+1;
    spec.connections(i).direction = 'RS->NG';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
    spec.connections(i).parameters = {'g_SYN',gAMPA_rsng,'E_SYN',EAMPA,'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        };
end

%% FS Cells
% % % % %  FS Cells  % % % % %
% % FS->FS Synaptic connections
if include_FS
    i=i+1;
    spec.connections(i).direction = 'FS->FS';                  
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','IBaIBaiGAP'};
    spec.connections(i).parameters = {'g_SYN',gGABAa_fsfs,'E_SYN',EGABA,'tauDx',tauGABAad,'tauRx',tauGABAar,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
        'g_GAP',ggjFS,...
        };
end


% % FS->IB Synaptic connections
if include_FS && include_IB
    i=i+1;
    spec.connections(i).direction = 'FS->IB';                  
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
    spec.connections(i).parameters = {'g_SYN',gGABAa_fsib,'E_SYN',EGABA,'tauDx',tauGABAad,'tauRx',tauGABAar,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
        };
end

% % FS->RS Synaptic connections
if include_FS && include_RS
    i=i+1;
    spec.connections(i).direction = 'FS->RS';                  
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
    spec.connections(i).parameters = {'g_SYN',gGABAa_fsrs,'E_SYN',EGABA,'tauDx',tauGABAad,'tauRx',tauGABAar,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
        };
end


% % FS->LTS Synaptic connections
if include_FS && include_LTS
    i=i+1;
    spec.connections(i).direction = 'FS->LTS';                  
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
    spec.connections(i).parameters = {'g_SYN',gGABAa_fsLTS,'E_SYN',EGABA,'tauDx',tauGABAad,'tauRx',tauGABAar,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
        };
end


%% LTS Cells
% % LTS->LTS Gap junction
if include_LTS
    i=i+1;
    spec.connections(i).direction = 'LTS->LTS';
    spec.connections(i).mechanism_list = {'IBaIBaiGAP'};
    spec.connections(i).parameters = {
        'g_GAP',ggjLTS,...
        };
end

% % LTS->IB Synaptic connections
if include_LTS && include_IB
    i=i+1;
    spec.connections(i).direction = 'LTS->IB';                  
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
    spec.connections(i).parameters = {'g_SYN',gGABAa_LTSib,'E_SYN',EGABA,'tauDx',tauGABAaLTSd,'tauRx',tauGABAaLTSr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
        };
end

% % LTS->RS Synaptic connections
if include_LTS && include_RS
    i=i+1;
    spec.connections(i).direction = 'LTS->RS';                  
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
    spec.connections(i).parameters = {'g_SYN',gGABAa_LTSrs,'E_SYN',EGABA,'tauDx',tauGABAaLTSd,'tauRx',tauGABAaLTSr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
        };
end


% % LTS->FS Synaptic connections
if include_LTS && include_FS
    i=i+1;
    spec.connections(i).direction = 'LTS->FS';                  
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
    spec.connections(i).parameters = {'g_SYN',gGABAa_LTSfs,'E_SYN',EGABA,'tauDx',tauGABAaLTSd,'tauRx',tauGABAaLTSr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
        };
end

%% Deep connections
% % % % % % % % % % % %  Deep connections (RS-FS) % % % % % % % % % % % % % 
% % % % %  deepRS Cells  % % % % %
% % deepRS->deepRS recurrent synaptic and gap connections
% if include_deepRS && NdeepRS > 1
%     i=i+1;
%     spec.connections(i).direction = 'deepRS->deepRS';
%     spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iNMDA','IBaIBaiGAP'};
%     spec.connections(i).parameters = {'g_SYN',gAMPA_deepRSdeepRS,'E_SYN',EAMPA,'tauDx',tauAMPAd,...
%         'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
%         'gNMDA',gNMDA_deepRSdeepRS,'ENMDA',EAMPA,'tauNMDAr',tauNMDAr,'tauNMDAd',tauNMDAd ...
%         'g_GAP',ggjadeepRS,...
%         };
% end

% % deepRS->deepFS synaptic connection
if include_deepRS && include_deepFS
    i=i+1;
    spec.connections(i).direction = 'deepRS->deepFS';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
    spec.connections(i).parameters = {'g_SYN',gAMPA_deepRSdeepFS,'E_SYN',EAMPA,'tauDx',tauAMPAd,...
        'tauRx',tauAMPAr,'fanout',0,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        };
end

% % % % %  deepFS Cells  % % % % %
% % deepFS->deepFS Synaptic connections
% if include_deepFS && NdeepFS > 1
%     i=i+1;
%     spec.connections(i).direction = 'deepFS->deepFS';                  
%     spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','IBaIBaiGAP'};
%     spec.connections(i).parameters = {'g_SYN',gGABA_deepFSdeepFS,'E_SYN',EGABA,'tauDx',tauGABAad,...
%         'tauRx',tauGABAar,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
%         'g_GAP',ggjdeepFS,...
%         };
% end

% % deepFS->deepRS Synaptic connections
if include_deepFS && include_deepRS
    i=i+1;
    spec.connections(i).direction = 'deepFS->deepRS';                  
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
    spec.connections(i).parameters = {'g_SYN',gGABAa_deepFSdeepRS,'E_SYN',EGABA,'tauDx',tauGABAad,...
        'tauRx',tauGABAar,'fanout',0,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
        };
end

% % % % % % % % % % % %  Delta <-> Theta connections % % % % % % % % % % % % % 
% % IB->deepRS
if include_IB && include_deepRS
    i=i+1;
    spec.connections(i).direction = 'IB->deepRS';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iNMDA'};
    spec.connections(i).parameters = {'g_SYN',gAMPA_IBdeepRS,'E_SYN',EAMPA,'tauDx',tauAMPAd,...
        'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        'gNMDA',gNMDA_IBdeepRS,'ENMDA',EAMPA,'tauNMDAr',tauNMDAr,'tauNMDAd',tauNMDAd ...
        };
end

% % deepFS->IB
if include_IB && include_deepFS
    i=i+1;
    spec.connections(i).direction = 'deepFS->IB';                  
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
    spec.connections(i).parameters = {'g_SYN',gGABAa_deepFSIB,'E_SYN',EGABA,'tauDx',tauGABAad,...
        'tauRx',tauGABAar,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
        };
end

% % % % % % % % % % % %  Theta <-> Gamma connections % % % % % % % % % % % % % 
% % deepRS->RS
if include_RS && include_deepRS
    i=i+1;
    spec.connections(i).direction = 'deepRS->RS';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
    spec.connections(i).parameters = {'g_SYN',gAMPA_deepRSRS,'E_SYN',EAMPA,'tauDx',tauAMPAd,...
        'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        };
end

% % deepRS->NG
if include_NG && include_deepRS
    i=i+1;
    spec.connections(i).direction = 'deepRS->NG';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
    spec.connections(i).parameters = {'g_SYN',gAMPA_deepRSNG,'E_SYN',EAMPA,'tauDx',tauAMPAd,...
        'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        };
end

% % RS->deepRS
if include_RS && include_deepRS
    i=i+1;
    spec.connections(i).direction = 'RS->deepRS';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
    spec.connections(i).parameters = {'g_SYN',gAMPA_RSdeepRS,'E_SYN',EAMPA,'tauDx',tauAMPAd,...
        'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        };
end

sim_spec = spec;