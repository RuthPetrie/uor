%% Reference dispersion curves  

nlongs = 360;
nlevels = 60;
c_gr_h_ref = load('hoz_grav_speed_ref.dat'); %% (60, 359)
c_gr_v_ref = load('vert_grav_speed_ref.dat'); %% (360, 59)
c_ac_h_ref = load('hoz_ac_speed_ref.dat'); %% (60, 359)
c_ac_v_ref = load('vert_ac_speed_ref.dat'); %% (360, 59)

figure
plot(c_gr_h_ref(2,:), 'k'),hold on
plot(c_gr_h_ref(3,:), 'b'),hold on
plot(c_gr_h_ref(4,:), 'r'),hold on
plot(c_gr_h_ref(5,:), 'g'),hold on
plot(c_gr_h_ref(6,:), 'm')

axis tight 

%,ylim([0 50]) 
%xlabel(['l',10,'horizontal wavenumber index'],'FontSize',12 )


% gs3_m = reshape(gs3_m, [nlongs, niterat, nlevels-1]);
% gs3_k = load('/home/wx019276/DATA/MODEL/WAVES/gs3k_c.dat'); %% (60, 359)
% gs3_k = reshape(gs3_k, [nlevels, niterat, nlongs-1]);
% gs5_m = load('/home/wx019276/DATA/MODEL/WAVES/gs5m_c.dat'); %% (360, 59)
% gs5_m = reshape(gs5_m, [nlongs, niterat, nlevels-1]);
% gs5_k = load('/home/wx019276/DATA/MODEL/WAVES/gs5k_c.dat'); %% (60, 359)
% gs5_k = reshape(gs5_k, [nlevels, niterat, nlongs-1]);
% 


k = 330;
m = 3;

figure
plot(squeeze(gs3_k(m,1,:),'k'), hold on 
plot(squeeze(gs3_k(m,2,:),'k:')
plot(squeeze(gs3_k(m,3,:),'k--')
plot(squeeze(gs3_k(m,4,:),'k-.')
%plot(squeeze(gs3_k(m,5,1:200)),'b')

axis tight  ,ylim([0 50]) 
xlabel(['l',10,'horizontal wavenumber index'],'FontSize',12 )

y=ylabel( ['c_g',10, 'ms^{-1}'],'FontSize',12,'Rotation',00);
pos = get(y,'pos'); % Read position [x y z]
set(y,'pos',pos+[-5 0 0]) % Move label to right 


legend('BC = 10^{5}','BC = 10^{4}','BC = 10^{3}','BC = 10^{2}')%,'C = 10^{1}')%,'C = 10^{2}')
set(legend,'EdgeColor','white','FontSize',14)

figure

plot(squeeze(gs5_k(m,1,1:200)),'k'),hold on 
plot(squeeze(gs5_k(m,2,1:200)),'k:'),hold on
plot(squeeze(gs5_k(m,3,1:200)),'k--')
plot(squeeze(gs5_k(m,4,1:200)),'k-.')
%plot(squeeze(gs5_k(m,5,1:200)),'b')

axis tight  ,ylim([0 315]) 
xlabel(['l',10,'horizontal wavenumber index'],'FontSize',12 )

y=ylabel( ['c_g',10, 'ms^{-1}'],'FontSize',10,'Rotation',00);
pos = get(y,'pos'); % Read position [x y z]
set(y,'pos',pos+[-5 0 0]) % Move label to right 



legend('BC = 10^{5}','BC = 10^{4}','BC = 10^{3}','BC = 10^{2}')%,'C = 10^{1}')%,'C = 10^{2}')
set(legend,'EdgeColor','white','FontSize',14)


% 
% %k = input('Choose low horizontal wave number, k:  ') ;
% %m = input('Choose low horizontal wave number, m:  ') ;
% k = 5;
% m = 5;
% %kk = input('Choose mid horizontal wave number, k:  ') ;
% %mm = input('Choose mid horizontal wave number, m:  ') ;
% kk = 100;
% mm = 30;
% %kkk = input('Choose high horizontal wave number, k:  ') ;
% %mmm = input('Choose high horizontal wave number, m:  ') ;
% kkk = 330;
% mmm = 58;
% 
% %figure
% %subplot(2,2,1),plot(squeeze(gs3_k(m,1,:)),'b'), hold on
% %plot(squeeze(gs3_k(m,2,:)),'r'), plot(squeeze(gs3_k(m,3,:)),'k'), axis tight, title('GS3(k)')
% %subplot(2,2,2),plot(squeeze(gs5_k(m,1,:)),'b'),hold on
% %plot(squeeze(gs5_k(m,2,:)),'r'),plot(squeeze(gs5_k(m,3,:)),'k'), axis tight, title('GS5(k)')
% %subplot(2,2,3),plot(squeeze(gs3_m(k,1,:)),'b'), hold on
% %plot(squeeze(gs3_m(k,2,:)),'r'),plot(squeeze(gs3_m(k,3,:)),'k'), axis tight, title('GS3(m)')
% %subplot(2,2,4),plot(squeeze(gs5_m(k,1,:)),'b'), hold on
% %plot(squeeze(gs5_m(k,2,:)),'r'),plot(squeeze(gs5_m(k,3,:)),'k'), axis tight, title('GS5(m)')
% 
% %legend('Cz = 100,000', 'Cz = 150,000','Cz = 200,000')
% 
% figure
% subplot(1,2,1), plot(squeeze(gs5_k(m,2,:)),'b'), hold on
% plot(squeeze(gs5_k(mm,2,:)), 'r'), plot(squeeze(gs5_k(mmm,2,:)), 'k'), axis tight, title('GS5(k)')
% 
% %legend ( num2str(m),num2str(mm),num2str(mmm) )
% 
% subplot(1,2,2),  plot(squeeze(gs5_m(k,2,:)),'b'), hold on
% plot(squeeze(gs5_m(kk,2,:)), 'r'), plot(squeeze(gs5_m(kkk,2,:)), 'k'), axis tight, title('GS5(m)')
% %M = [ 'k = ' 'k = ' 'k = ']
% 
% legTxt = [ {'k = '}  {'k = ' } {'k = '}]
% legNum = [{num2str(k)} {num2str(kk)} {num2str(kkk)}]
% legText = [ {legTxt(1) legNum(1)} {legTxt(2) legNum(2)} {legTxt(3) legNum(3)}];
% %legTxt(1) = {'k'  num2str(k) };
% %%legTxt(2) = {'k'  num2str(kk) };
% %legTxt(3) = {'k'  num2str(kkk) };
% 
% % legend(M(1) num2str(k), M(2) num2str(kk), M(3) num2str(kkk))
% %legend ({'k ' + num2str(k),num2str(kk),num2str(kkk)} )
% %legend(M(1), M(2), M(3))
% legend (legText)
% 

