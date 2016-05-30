function [T,IBda_V,IBda_IBiNaF_hNaF,IBda_IBiKDR_mKDR,IBda_IBiMMich_mM,IBda_IBiCaH_mCaH,IBs_V,IBs_IBiNaF_hNaF,IBs_IBiKDR_mKDR,IBa_V,IBa_IBiNaF_hNaF,IBa_IBiKDR_mKDR,IBa_IBiMMich_mM,IBda_IBdbiPoissonExp_G,IBs_IBda_IBiCOM_UB,IBs_IBda_IBiCOM_Xpre,IBs_IBda_IBiCOM_Xpost,IBs_IBda_IBiCOM_mask,IBda_IBs_IBiCOM_UB,IBda_IBs_IBiCOM_Xpre,IBda_IBs_IBiCOM_Xpost,IBda_IBs_IBiCOM_mask,IBa_IBs_IBiCOM_UB,IBa_IBs_IBiCOM_Xpre,IBa_IBs_IBiCOM_Xpost,IBa_IBs_IBiCOM_mask,IBs_IBa_IBiCOM_UB,IBs_IBa_IBiCOM_Xpre,IBs_IBa_IBiCOM_Xpost,IBs_IBa_IBiCOM_mask]=solve_ode_20160527180955_514
% ------------------------------------------------------------
% Parameters:
% ------------------------------------------------------------
p=load('params.mat','p'); p=p.p;
downsample_factor=p.downsample_factor;
dt=p.dt;
T=(p.tspan(1):dt:p.tspan(2))';
ntime=length(T);
nsamp=length(1:downsample_factor:ntime);
% ------------------------------------------------------------
% Fixed variables:
% ------------------------------------------------------------
IBda_IBdbiPoissonExp_G =  getPoissonExp(p.IBda_IBdbiPoissonExp_lambda,p.IBda_IBdbiPoissonExp_tauRAN,p.IBda_IBdbiPoissonExp_Pmax,p.IBda_Npop,p.IBda_IBdbiPoissonExp_T,dt,p.IBda_IBdbiPoissonExp_overwrite_flag,p.IBda_IBdbiPoissonExp_poiss_id);
IBs_IBda_IBiCOM_UB =  max(p.IBda_Npop,p.IBs_Npop);
IBs_IBda_IBiCOM_Xpre =  linspace(1,IBs_IBda_IBiCOM_UB,p.IBda_Npop)'*ones(1,p.IBs_Npop);
IBs_IBda_IBiCOM_Xpost =  (linspace(1,IBs_IBda_IBiCOM_UB,p.IBs_Npop)'*ones(1,p.IBda_Npop))';
IBs_IBda_IBiCOM_mask =  abs(IBs_IBda_IBiCOM_Xpre-IBs_IBda_IBiCOM_Xpost)<=p.IBs_IBda_IBiCOM_comspan;
IBda_IBs_IBiCOM_UB =  max(p.IBs_Npop,p.IBda_Npop);
IBda_IBs_IBiCOM_Xpre =  linspace(1,IBda_IBs_IBiCOM_UB,p.IBs_Npop)'*ones(1,p.IBda_Npop);
IBda_IBs_IBiCOM_Xpost =  (linspace(1,IBda_IBs_IBiCOM_UB,p.IBda_Npop)'*ones(1,p.IBs_Npop))';
IBda_IBs_IBiCOM_mask =  abs(IBda_IBs_IBiCOM_Xpre-IBda_IBs_IBiCOM_Xpost)<=p.IBda_IBs_IBiCOM_comspan;
IBa_IBs_IBiCOM_UB =  max(p.IBs_Npop,p.IBa_Npop);
IBa_IBs_IBiCOM_Xpre =  linspace(1,IBa_IBs_IBiCOM_UB,p.IBs_Npop)'*ones(1,p.IBa_Npop);
IBa_IBs_IBiCOM_Xpost =  (linspace(1,IBa_IBs_IBiCOM_UB,p.IBa_Npop)'*ones(1,p.IBs_Npop))';
IBa_IBs_IBiCOM_mask =  abs(IBa_IBs_IBiCOM_Xpre-IBa_IBs_IBiCOM_Xpost)<=p.IBa_IBs_IBiCOM_comspan;
IBs_IBa_IBiCOM_UB =  max(p.IBa_Npop,p.IBs_Npop);
IBs_IBa_IBiCOM_Xpre =  linspace(1,IBs_IBa_IBiCOM_UB,p.IBa_Npop)'*ones(1,p.IBs_Npop);
IBs_IBa_IBiCOM_Xpost =  (linspace(1,IBs_IBa_IBiCOM_UB,p.IBs_Npop)'*ones(1,p.IBa_Npop))';
IBs_IBa_IBiCOM_mask =  abs(IBs_IBa_IBiCOM_Xpre-IBs_IBa_IBiCOM_Xpost)<=p.IBs_IBa_IBiCOM_comspan;
% ------------------------------------------------------------
% Initial conditions:
% ------------------------------------------------------------
% seed the random number generator
rng(p.random_seed);
t=0; k=1;
% STATE_VARIABLES:
IBda_V = zeros(nsamp,p.IBda_Npop);
  IBda_V(1,:) = -65*ones(1,p.IBda_Npop);
IBda_IBiNaF_hNaF = zeros(nsamp,p.IBda_Npop);
  IBda_IBiNaF_hNaF(1,:) =  p.IBda_IBiNaF_IC+p.IBda_IBiNaF_IC_noise.*rand(1,p.IBda_Npop);
IBda_IBiKDR_mKDR = zeros(nsamp,p.IBda_Npop);
  IBda_IBiKDR_mKDR(1,:) =  p.IBda_IBiKDR_IC+p.IBda_IBiKDR_IC_noise.*rand(1,p.IBda_Npop);
IBda_IBiMMich_mM = zeros(nsamp,p.IBda_Npop);
  IBda_IBiMMich_mM(1,:) =  p.IBda_IBiMMich_IC+p.IBda_IBiMMich_IC_noise.*rand(1,p.IBda_Npop);
IBda_IBiCaH_mCaH = zeros(nsamp,p.IBda_Npop);
  IBda_IBiCaH_mCaH(1,:) =  p.IBda_IBiCaH_IC+p.IBda_IBiCaH_IC_noise.*rand(1,p.IBda_Npop);
IBs_V = zeros(nsamp,p.IBs_Npop);
  IBs_V(1,:) = -65*ones(1,p.IBs_Npop);
IBs_IBiNaF_hNaF = zeros(nsamp,p.IBs_Npop);
  IBs_IBiNaF_hNaF(1,:) =  p.IBs_IBiNaF_IC+p.IBs_IBiNaF_IC_noise.*rand(1,p.IBs_Npop);
IBs_IBiKDR_mKDR = zeros(nsamp,p.IBs_Npop);
  IBs_IBiKDR_mKDR(1,:) =  p.IBs_IBiKDR_IC+p.IBs_IBiKDR_IC_noise.*rand(1,p.IBs_Npop);
IBa_V = zeros(nsamp,p.IBa_Npop);
  IBa_V(1,:) = -65*ones(1,p.IBa_Npop);
IBa_IBiNaF_hNaF = zeros(nsamp,p.IBa_Npop);
  IBa_IBiNaF_hNaF(1,:) =  p.IBa_IBiNaF_IC+p.IBa_IBiNaF_IC_noise.*rand(1,p.IBa_Npop);
IBa_IBiKDR_mKDR = zeros(nsamp,p.IBa_Npop);
  IBa_IBiKDR_mKDR(1,:) =  p.IBa_IBiKDR_IC+p.IBa_IBiKDR_IC_noise.*rand(1,p.IBa_Npop);
IBa_IBiMMich_mM = zeros(nsamp,p.IBa_Npop);
  IBa_IBiMMich_mM(1,:) =  p.IBa_IBiMMich_IC+p.IBa_IBiMMich_IC_noise.*rand(1,p.IBa_Npop);
% ###########################################################
% Numerical integration:
% ###########################################################
n=2;
for k=2:ntime
  t=T(k-1);
  IBda_V_k1=(((-(( (( p.IBda_IBdbiPoissonExp_gRAN.*IBda_IBdbiPoissonExp_G(:,max(1,round(t/dt)))')).*(IBda_V(n-1,:)-p.IBda_IBdbiPoissonExp_ERAN))))+((-(( p.IBda_IBitonic_stim*(t>p.IBda_IBitonic_onset & t<p.IBda_IBitonic_offset))))+((p.IBda_IBnoise_V_noise.*randn(1,p.IBda_Npop))+((-(( p.IBda_IBiNaF_gNaF.*(( 1./(1+exp((-IBda_V(n-1,:)-p.IBda_IBiNaF_NaF_V0)/10)))).^3.*IBda_IBiNaF_hNaF(n-1,:).*(IBda_V(n-1,:)-p.IBda_IBiNaF_E_NaF))))+((-(( p.IBda_IBiKDR_gKDR.*IBda_IBiKDR_mKDR(n-1,:).^4.*(IBda_V(n-1,:)-p.IBda_IBiKDR_E_KDR))))+((-(( p.IBda_IBiMMich_gM.*IBda_IBiMMich_mM(n-1,:).*(IBda_V(n-1,:)-p.IBda_IBiMMich_E_M))))+((-(( p.IBda_IBiCaH_gCaH.*IBda_IBiCaH_mCaH(n-1,:).^2.*(IBda_V(n-1,:)-p.IBda_IBiCaH_E_CaH))))+((-(( p.IBda_IBleak_g_l.*(IBda_V(n-1,:)-p.IBda_IBleak_E_l))))+((-(( p.IBda_IBs_IBiCOM_g_COM.*sum(((IBda_V(n-1,:)'*ones(1,size(IBda_V(n-1,:)',1)))'-(IBs_V(n-1,:)'*ones(1,size(IBs_V(n-1,:)',1)))).*IBda_IBs_IBiCOM_mask,2)')))))))))))))/p.IBda_Cm;
  IBda_IBiNaF_hNaF_k1= (( (( 1./(1+exp((IBda_V(n-1,:)+p.IBda_IBiNaF_NaF_V1)/p.IBda_IBiNaF_NaF_d1)))) ./ (( p.IBda_IBiNaF_NaF_c0 + p.IBda_IBiNaF_NaF_c1./(1+exp((IBda_V(n-1,:)+p.IBda_IBiNaF_NaF_V2)/p.IBda_IBiNaF_NaF_d2)))))).*(1-IBda_IBiNaF_hNaF(n-1,:))-(( (1-(( 1./(1+exp((IBda_V(n-1,:)+p.IBda_IBiNaF_NaF_V1)/p.IBda_IBiNaF_NaF_d1)))))./(( p.IBda_IBiNaF_NaF_c0 + p.IBda_IBiNaF_NaF_c1./(1+exp((IBda_V(n-1,:)+p.IBda_IBiNaF_NaF_V2)/p.IBda_IBiNaF_NaF_d2)))))).*IBda_IBiNaF_hNaF(n-1,:);
  IBda_IBiKDR_mKDR_k1= (( (( 1./(1+exp((-IBda_V(n-1,:)-p.IBda_IBiKDR_KDR_V1)/p.IBda_IBiKDR_KDR_d1)))) ./ (( .25+4.35*exp(-abs(IBda_V(n-1,:)+p.IBda_IBiKDR_KDR_V2)/p.IBda_IBiKDR_KDR_d2))))).*(1-IBda_IBiKDR_mKDR(n-1,:))-(( (1-(( 1./(1+exp((-IBda_V(n-1,:)-p.IBda_IBiKDR_KDR_V1)/p.IBda_IBiKDR_KDR_d1)))))./(( .25+4.35*exp(-abs(IBda_V(n-1,:)+p.IBda_IBiKDR_KDR_V2)/p.IBda_IBiKDR_KDR_d2))))).*IBda_IBiKDR_mKDR(n-1,:);
  IBda_IBiMMich_mM_k1= ((( p.IBda_IBiMMich_c_MaM.*(0.0001*p.IBda_IBiMMich_Qs*(IBda_V(n-1,:)+30)) ./ (1-exp(-(IBda_V(n-1,:)+30)/9)))).*(1-IBda_IBiMMich_mM(n-1,:))-(( p.IBda_IBiMMich_c_MbM.*(-0.0001*p.IBda_IBiMMich_Qs*(IBda_V(n-1,:)+30)) ./ (1-exp((IBda_V(n-1,:)+30)/9)))).*IBda_IBiMMich_mM(n-1,:));
  IBda_IBiCaH_mCaH_k1= ((( p.IBda_IBiCaH_c_CaHaM.*(1.6./(1+exp(-.072*(IBda_V(n-1,:)-5)))))).*(1-IBda_IBiCaH_mCaH(n-1,:))-(( p.IBda_IBiCaH_c_CaHbM.*(.02*(IBda_V(n-1,:)+8.9)./(exp((IBda_V(n-1,:)+8.9)/5)-1)))).*IBda_IBiCaH_mCaH(n-1,:))/p.IBda_IBiCaH_tauCaH;
  IBs_V_k1=(((-(( p.IBs_IBitonic_stim*(t>p.IBs_IBitonic_onset & t<p.IBs_IBitonic_offset))))+((p.IBs_IBnoise_V_noise.*randn(1,p.IBs_Npop))+((-(( p.IBs_IBiNaF_gNaF.*(( 1./(1+exp((-IBs_V(n-1,:)-p.IBs_IBiNaF_NaF_V0)/10)))).^3.*IBs_IBiNaF_hNaF(n-1,:).*(IBs_V(n-1,:)-p.IBs_IBiNaF_E_NaF))))+((-(( p.IBs_IBiKDR_gKDR.*IBs_IBiKDR_mKDR(n-1,:).^4.*(IBs_V(n-1,:)-p.IBs_IBiKDR_E_KDR))))+((-(( p.IBs_IBleak_g_l.*(IBs_V(n-1,:)-p.IBs_IBleak_E_l))))+((-(( p.IBs_IBda_IBiCOM_g_COM.*sum(((IBs_V(n-1,:)'*ones(1,size(IBs_V(n-1,:)',1)))'-(IBda_V(n-1,:)'*ones(1,size(IBda_V(n-1,:)',1)))).*IBs_IBda_IBiCOM_mask,2)')))+((-(( p.IBs_IBa_IBiCOM_g_COM.*sum(((IBs_V(n-1,:)'*ones(1,size(IBs_V(n-1,:)',1)))'-(IBa_V(n-1,:)'*ones(1,size(IBa_V(n-1,:)',1)))).*IBs_IBa_IBiCOM_mask,2)')))))))))))/p.IBs_Cm;
  IBs_IBiNaF_hNaF_k1= (( (( 1./(1+exp((IBs_V(n-1,:)+p.IBs_IBiNaF_NaF_V1)/p.IBs_IBiNaF_NaF_d1)))) ./ (( p.IBs_IBiNaF_NaF_c0 + p.IBs_IBiNaF_NaF_c1./(1+exp((IBs_V(n-1,:)+p.IBs_IBiNaF_NaF_V2)/p.IBs_IBiNaF_NaF_d2)))))).*(1-IBs_IBiNaF_hNaF(n-1,:))-(( (1-(( 1./(1+exp((IBs_V(n-1,:)+p.IBs_IBiNaF_NaF_V1)/p.IBs_IBiNaF_NaF_d1)))))./(( p.IBs_IBiNaF_NaF_c0 + p.IBs_IBiNaF_NaF_c1./(1+exp((IBs_V(n-1,:)+p.IBs_IBiNaF_NaF_V2)/p.IBs_IBiNaF_NaF_d2)))))).*IBs_IBiNaF_hNaF(n-1,:);
  IBs_IBiKDR_mKDR_k1= (( (( 1./(1+exp((-IBs_V(n-1,:)-p.IBs_IBiKDR_KDR_V1)/p.IBs_IBiKDR_KDR_d1)))) ./ (( .25+4.35*exp(-abs(IBs_V(n-1,:)+p.IBs_IBiKDR_KDR_V2)/p.IBs_IBiKDR_KDR_d2))))).*(1-IBs_IBiKDR_mKDR(n-1,:))-(( (1-(( 1./(1+exp((-IBs_V(n-1,:)-p.IBs_IBiKDR_KDR_V1)/p.IBs_IBiKDR_KDR_d1)))))./(( .25+4.35*exp(-abs(IBs_V(n-1,:)+p.IBs_IBiKDR_KDR_V2)/p.IBs_IBiKDR_KDR_d2))))).*IBs_IBiKDR_mKDR(n-1,:);
  IBa_V_k1=(((-(( p.IBa_IBitonic_stim*(t>p.IBa_IBitonic_onset & t<p.IBa_IBitonic_offset))))+((p.IBa_IBnoise_V_noise.*randn(1,p.IBa_Npop))+((-(( p.IBa_IBiNaF_gNaF.*(( 1./(1+exp((-IBa_V(n-1,:)-p.IBa_IBiNaF_NaF_V0)/10)))).^3.*IBa_IBiNaF_hNaF(n-1,:).*(IBa_V(n-1,:)-p.IBa_IBiNaF_E_NaF))))+((-(( p.IBa_IBiKDR_gKDR.*IBa_IBiKDR_mKDR(n-1,:).^4.*(IBa_V(n-1,:)-p.IBa_IBiKDR_E_KDR))))+((-(( p.IBa_IBiMMich_gM.*IBa_IBiMMich_mM(n-1,:).*(IBa_V(n-1,:)-p.IBa_IBiMMich_E_M))))+((-(( p.IBa_IBleak_g_l.*(IBa_V(n-1,:)-p.IBa_IBleak_E_l))))+((-(( p.IBa_IBs_IBiCOM_g_COM.*sum(((IBa_V(n-1,:)'*ones(1,size(IBa_V(n-1,:)',1)))'-(IBs_V(n-1,:)'*ones(1,size(IBs_V(n-1,:)',1)))).*IBa_IBs_IBiCOM_mask,2)')))))))))))/p.IBa_Cm;
  IBa_IBiNaF_hNaF_k1= (( (( 1./(1+exp((IBa_V(n-1,:)+p.IBa_IBiNaF_NaF_V1)/p.IBa_IBiNaF_NaF_d1)))) ./ (( p.IBa_IBiNaF_NaF_c0 + p.IBa_IBiNaF_NaF_c1./(1+exp((IBa_V(n-1,:)+p.IBa_IBiNaF_NaF_V2)/p.IBa_IBiNaF_NaF_d2)))))).*(1-IBa_IBiNaF_hNaF(n-1,:))-(( (1-(( 1./(1+exp((IBa_V(n-1,:)+p.IBa_IBiNaF_NaF_V1)/p.IBa_IBiNaF_NaF_d1)))))./(( p.IBa_IBiNaF_NaF_c0 + p.IBa_IBiNaF_NaF_c1./(1+exp((IBa_V(n-1,:)+p.IBa_IBiNaF_NaF_V2)/p.IBa_IBiNaF_NaF_d2)))))).*IBa_IBiNaF_hNaF(n-1,:);
  IBa_IBiKDR_mKDR_k1= (( (( 1./(1+exp((-IBa_V(n-1,:)-p.IBa_IBiKDR_KDR_V1)/p.IBa_IBiKDR_KDR_d1)))) ./ (( .25+4.35*exp(-abs(IBa_V(n-1,:)+p.IBa_IBiKDR_KDR_V2)/p.IBa_IBiKDR_KDR_d2))))).*(1-IBa_IBiKDR_mKDR(n-1,:))-(( (1-(( 1./(1+exp((-IBa_V(n-1,:)-p.IBa_IBiKDR_KDR_V1)/p.IBa_IBiKDR_KDR_d1)))))./(( .25+4.35*exp(-abs(IBa_V(n-1,:)+p.IBa_IBiKDR_KDR_V2)/p.IBa_IBiKDR_KDR_d2))))).*IBa_IBiKDR_mKDR(n-1,:);
  IBa_IBiMMich_mM_k1= ((( p.IBa_IBiMMich_c_MaM.*(0.0001*p.IBa_IBiMMich_Qs*(IBa_V(n-1,:)+30)) ./ (1-exp(-(IBa_V(n-1,:)+30)/9)))).*(1-IBa_IBiMMich_mM(n-1,:))-(( p.IBa_IBiMMich_c_MbM.*(-0.0001*p.IBa_IBiMMich_Qs*(IBa_V(n-1,:)+30)) ./ (1-exp((IBa_V(n-1,:)+30)/9)))).*IBa_IBiMMich_mM(n-1,:));
  % ------------------------------------------------------------
  % Update state variables:
  % ------------------------------------------------------------
  IBda_V(n,:)=IBda_V(n-1,:)+dt*IBda_V_k1;
  IBda_IBiNaF_hNaF(n,:)=IBda_IBiNaF_hNaF(n-1,:)+dt*IBda_IBiNaF_hNaF_k1;
  IBda_IBiKDR_mKDR(n,:)=IBda_IBiKDR_mKDR(n-1,:)+dt*IBda_IBiKDR_mKDR_k1;
  IBda_IBiMMich_mM(n,:)=IBda_IBiMMich_mM(n-1,:)+dt*IBda_IBiMMich_mM_k1;
  IBda_IBiCaH_mCaH(n,:)=IBda_IBiCaH_mCaH(n-1,:)+dt*IBda_IBiCaH_mCaH_k1;
  IBs_V(n,:)=IBs_V(n-1,:)+dt*IBs_V_k1;
  IBs_IBiNaF_hNaF(n,:)=IBs_IBiNaF_hNaF(n-1,:)+dt*IBs_IBiNaF_hNaF_k1;
  IBs_IBiKDR_mKDR(n,:)=IBs_IBiKDR_mKDR(n-1,:)+dt*IBs_IBiKDR_mKDR_k1;
  IBa_V(n,:)=IBa_V(n-1,:)+dt*IBa_V_k1;
  IBa_IBiNaF_hNaF(n,:)=IBa_IBiNaF_hNaF(n-1,:)+dt*IBa_IBiNaF_hNaF_k1;
  IBa_IBiKDR_mKDR(n,:)=IBa_IBiKDR_mKDR(n-1,:)+dt*IBa_IBiKDR_mKDR_k1;
  IBa_IBiMMich_mM(n,:)=IBa_IBiMMich_mM(n-1,:)+dt*IBa_IBiMMich_mM_k1;
  n=n+1;
end
T=T(1:downsample_factor:ntime);
