
% % This script adds all the synaptic connections between cells % %

% % % % % % % % % % % %  Connections  % % % % % % % % % % % % % %
i=0;
%% IB Cells
% % % % %  IB Cells  % % % % %
% % IB->IB recurrent synaptic and gap connections
if include_IB
    i=i+1;
    spec.connections(i).direction = 'IB->IB';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iNMDA','IBaIBaiGAP'};
    spec.connections(i).parameters = {'g_SYN',gAMPA_ibib,'E_SYN',EAMPA,'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        'gNMDA',gNMDA_ibib,'ENMDA',EAMPA,'Rd ', Rd, 'Rr', Rr, ...    
        'g_GAP',ggja,...
        };
end

% % IB->NG
if include_IB && include_NG
    i=i+1;
    spec.connections(i).direction = 'IB->NG';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iNMDA'};
    spec.connections(i).parameters = {'g_SYN',gAMPA_ibng,'E_SYN',EAMPA,'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        'gNMDA',gNMDA_ibng,'ENMDA',EAMPA,'Rd ', Rd, 'Rr', Rr, ...    
        };
end

% % IB->RS
if include_IB && include_RS
    i=i+1;
    spec.connections(i).direction = 'IB->RS';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iNMDA'};
    spec.connections(i).parameters = {'g_SYN',gAMPA_ibrs,'E_SYN',EAMPA,'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        'gNMDA',gNMDA_ibrs,'ENMDA',EAMPA,'Rd ', Rd, 'Rr', Rr, ...    
        };
end

% % IB->LTS
if include_IB && include_LTS
    i=i+1;
    spec.connections(i).direction = 'IB->LTS';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iNMDA'};
    spec.connections(i).parameters = {'g_SYN',gAMPA_ibLTS,'E_SYN',EAMPA,'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        'gNMDA',gNMDA_ibLTS,'ENMDA',EAMPA,'Rd ', Rd, 'Rr', Rr, ...    
        };
end

%% NG Cells
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

% % NG->IB Synaptic connections
if include_NG && include_IB
    i=i+1;
    spec.connections(i).direction = 'NG->IB';                  
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iGABABAustin'};
    spec.connections(i).parameters = {'g_SYN',gGABAa_ngib,'E_SYN',EGABA,'tauDx',tauGABAad,'tauRx',tauGABAar,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
        'gGABAB',gGABAb_ngib,'EGABAB',EGABA,'tauGABABd',tauGABAbd,'tauGABABr',tauGABAbr,'gGABAB_hetero',gsyn_hetero, ...
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
if include_NG && include_FS
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
    
    if do_jason_sPING_syn
        js_conn_E_I.direction='RS->FS';
        js_conn_E_I.mechanism_list={'iAMPA'};
        js_conn_E_I.parameters={'tauD',2,'gSYN',.1*80/Nrs,'netcon','ones(N_pre,N_post)'};
        spec.connections(i) = js_conn_E_I;
    end

end

% % RS->LTS synaptic connection
if include_RS && include_LTS
    i=i+1;
    spec.connections(i).direction = 'RS->LTS';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
    spec.connections(i).parameters = {'g_SYN',gAMPA_rsLTS,'E_SYN',EAMPA,'tauDx',tauAMPAd_LTS,'tauRx',tauAMPAr_LTS,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
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
    
    if do_jason_sPING_syn
        js_conn_I_E.direction='FS->RS';
        js_conn_I_E.mechanism_list={'iGABAa'};
        js_conn_I_E.parameters={'tauD',10,'gSYN',.1*20/Nfs,'netcon','ones(N_pre,N_post)'};
        spec.connections(i) = js_conn_I_E;
    end
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
    spec.connections(i).parameters = {'g_SYN',gGABAa_LTSib,'E_SYN',EGABA,'tauDx',tauGABAaLTSd_IB,'tauRx',tauGABAaLTSr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
        };
end

% % LTS->RS Synaptic connections
if include_LTS && include_RS
    i=i+1;
    spec.connections(i).direction = 'LTS->RS';                  
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
    spec.connections(i).parameters = {'g_SYN',gGABAa_LTSrs,'E_SYN',EGABA,'tauDx',tauGABAaLTSd_RS,'tauRx',tauGABAaLTSr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
        };
end


% % LTS->FS Synaptic connections
if include_LTS && include_FS
    i=i+1;
    spec.connections(i).direction = 'LTS->FS';                  
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
    spec.connections(i).parameters = {'g_SYN',gGABAa_LTSfs,'E_SYN',EGABA,'tauDx',tauGABAaLTSd_FS,'tauRx',tauGABAaLTSr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
        };
end

%% Deep connections
% % % % % % % % % % % %  Deep connections (RS-FS) % % % % % % % % % % % % % 
% % % % %  deepRS Cells  % % % % %
% % deepRS->deepRS recurrent synaptic and gap connections
if include_deepRS && NdeepRS > 1
    i=i+1;
    spec.connections(i).direction = 'deepRS->deepRS';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iNMDA','IBaIBaiGAP'};
    spec.connections(i).parameters = {'g_SYN',gAMPA_deepRSdeepRS,'E_SYN',EAMPA,'tauDx',tauAMPAd,...
        'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        'gNMDA',gNMDA_deepRSdeepRS,'ENMDA',EAMPA,'tauNMDAr',tauNMDAr,'tauNMDAd',tauNMDAd ...
        'g_GAP',ggjadeepRS,...
        };
end

% % deepRS->deepFS synaptic connection
if include_deepRS && include_deepFS
    i=i+1;
    spec.connections(i).direction = 'deepRS->deepFS';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
    spec.connections(i).parameters = {'g_SYN',gAMPA_deepRSdeepFS,'E_SYN',EAMPA,'tauDx',tauAMPAd,...
        'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        };
end

% % % % %  deepFS Cells  % % % % %
% % deepFS->deepFS Synaptic connections
if include_deepFS && NdeepFS > 1
    i=i+1;
    spec.connections(i).direction = 'deepFS->deepFS';                  
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','IBaIBaiGAP'};
    spec.connections(i).parameters = {'g_SYN',gGABA_deepFSdeepFS,'E_SYN',EGABA,'tauDx',tauGABAad,...
        'tauRx',tauGABAar,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
        'g_GAP',ggjdeepFS,...
        };
end

% % deepFS->deepRS Synaptic connections
if include_deepFS && include_deepRS
    i=i+1;
    spec.connections(i).direction = 'deepFS->deepRS';                  
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
    spec.connections(i).parameters = {'g_SYN',gGABAa_deepFSdeepRS,'E_SYN',EGABA,'tauDx',tauGABAad,...
        'tauRx',tauGABAar,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
        };
end


% % NG->deepRS Synaptic connections           % Exactly the same as Deep NG->RS connection
if include_NG && include_deepRS
    i=i+1;
    spec.connections(i).direction = 'NG->deepRS';                  
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iGABABAustin'};
    spec.connections(i).parameters = {'g_SYN',gGABAa_NGdeepRS,'E_SYN',EGABA,'tauDx',tauGABAad,...
        'tauRx',tauGABAar,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
        'gGABAB',gGABAb_NGdeepRS,'EGABAB',EGABA,'gGABAB_hetero',gsyn_hetero,... % 'tauGABABd',tauGABAbd,'tauGABABr',tauGABAbr,
        'TmaxGABAB',TmaxGABAB ...
        };
end

% % % % % % % % % % % %  Delta -> Theta connections % % % % % % % % % % % % % 
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

% % IB->deepFS
if include_IB && include_deepFS
    i=i+1;
    spec.connections(i).direction = 'IB->deepFS';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iNMDA'};
    spec.connections(i).parameters = {'g_SYN',gAMPA_IBdeepFS,'E_SYN',EAMPA,'tauDx',tauAMPAd,...
        'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        'gNMDA',gNMDA_IBdeepFS,'ENMDA',EAMPA,'tauNMDAr',tauNMDAr,'tauNMDAd',tauNMDAd ...
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

% % % % % % % % % % % %  Theta -> Delta/Gamma connections % % % % % % % % % % % % % 
% % deepRS->RS
if include_RS && include_deepRS
    i=i+1;
    spec.connections(i).direction = 'deepRS->RS';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
    spec.connections(i).parameters = {'g_SYN',gAMPA_deepRSRS,'E_SYN',EAMPA,'tauDx',tauAMPAd,...
        'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        };
end

% % deepRS->IB
if include_RS && include_deepRS
    i=i+1;
    spec.connections(i).direction = 'deepRS->IB';
    spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
    spec.connections(i).parameters = {'g_SYN',gAMPA_deepRSIB,'E_SYN',EAMPA,'tauDx',tauAMPAd,...
        'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
        };
end

sim_spec = spec;

% %% Supraficial connections
% % % % % % % % % % % % %  Supraficial connections (RS-FS) % % % % % % % % % % % % % 
% % % % % %  supRS Cells  % % % % %
% % % supRS->supRS recurrent synaptic and gap connections
% if include_supRS
%     i=i+1;
%     spec.connections(i).direction = 'supRS->supRS';
%     spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iNMDA','IBaIBaiGAP'};
%     spec.connections(i).parameters = {'g_SYN',gAMPA_supRSsupRS,'E_SYN',EAMPA,'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
%         'gNMDA',gNMDA_supRSsupRS,'ENMDA',EAMPA,'tauNMDAr',tauNMDAr,'tauNMDAd',tauNMDAd ...
%         'g_GAP',ggjasupRS,...
%         };
% end
% 
% % % supRS->supFS synaptic connection
% if include_supRS && include_supFS
%     i=i+1;
%     spec.connections(i).direction = 'supRS->supFS';
%     spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
%     spec.connections(i).parameters = {'g_SYN',gAMPA_supRSsupFS,'E_SYN',EAMPA,'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
%         };
% end
% 
% % % % % %  supFS Cells  % % % % %
% % % supFS->supFS Synaptic connections
% if include_supFS
%     i=i+1;
%     spec.connections(i).direction = 'supFS->supFS';                  
%     spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','IBaIBaiGAP'};
%     spec.connections(i).parameters = {'g_SYN',gGABA_supFSsupFS,'E_SYN',EGABA,'tauDx',tauGABAad,'tauRx',tauGABAar,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
%         'g_GAP',ggjsupFS,...
%         };
% end
% 
% % % supFS->supRS Synaptic connections
% if include_supFS && include_supRS
%     i=i+1;
%     spec.connections(i).direction = 'supFS->supRS';                  
%     spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
%     spec.connections(i).parameters = {'g_SYN',gGABAa_supFSsupRS,'E_SYN',EGABA,'tauDx',tauGABAad,'tauRx',tauGABAar,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
%         };
% end
% 
% 
% % % NG->supRS Synaptic connections           % Exactly the same as Deep NG->RS connection
% if include_NG && include_supRS
%     i=i+1;
%     spec.connections(i).direction = 'NG->supRS';                  
%     spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iGABABAustin'};
%     spec.connections(i).parameters = {'g_SYN',gGABAa_NGsupRS,'E_SYN',EGABA,'tauDx',tauGABAad,'tauRx',tauGABAar,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero,...
%         'gGABAB',gGABAb_NGsupRS,'EGABAB',EGABA,'tauGABABd',tauGABAbd,'tauGABABr',tauGABAbr,'gGABAB_hetero',gsyn_hetero, ...
%         'TmaxGABAB',TmaxGABAB ...
%         };
% end
% 
% % % % % % % % % % % % %  Deep->Supraficial connections % % % % % % % % % % % % % 
% % % IB->supRS
% if include_IB && include_supRS
%     i=i+1;
%     spec.connections(i).direction = 'IB->supRS';
%     spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iNMDA'};
%     spec.connections(i).parameters = {'g_SYN',gAMPA_IBsupRS,'E_SYN',EAMPA,'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
%         'gNMDA',gNMDA_IBsupRS,'ENMDA',EAMPA,'tauNMDAr',tauNMDAr,'tauNMDAd',tauNMDAd ...
%         };
% end
% 
% % % IB->supFS
% if include_IB && include_supFS
%     i=i+1;
%     spec.connections(i).direction = 'IB->supFS';
%     spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','iNMDA'};
%     spec.connections(i).parameters = {'g_SYN',gAMPA_IBsupFS,'E_SYN',EAMPA,'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
%         'gNMDA',gNMDA_IBsupFS,'ENMDA',EAMPA,'tauNMDAr',tauNMDAr,'tauNMDAd',tauNMDAd ...
%         };
% end
% 
% % % RS->supRS
% if include_RS && include_supRS
%     i=i+1;
%     spec.connections(i).direction = 'RS->supRS';
%     spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
%     spec.connections(i).parameters = {'g_SYN',gAMPA_RSsupRS,'E_SYN',EAMPA,'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
%         };
% end
% 
% 
% 
% 
% % % % % % % % % % % % %  Supraficial->Deep connections % % % % % % % % % % % % % 
% % % supRS->RS
% if include_RS && include_supRS
%     i=i+1;
%     spec.connections(i).direction = 'supRS->RS';
%     spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
%     spec.connections(i).parameters = {'g_SYN',gAMPA_supRSRS,'E_SYN',EAMPA,'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
%         };
% end
% 
% % % supRS->IB
% if include_RS && include_supRS
%     i=i+1;
%     spec.connections(i).direction = 'supRS->IB';
%     spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
%     spec.connections(i).parameters = {'g_SYN',gAMPA_supRSIB,'E_SYN',EAMPA,'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,'g_SYN_hetero',gsyn_hetero, ...
%         };
% end
