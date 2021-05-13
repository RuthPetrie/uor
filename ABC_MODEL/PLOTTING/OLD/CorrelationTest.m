%% Test correlation of normal modes
%% CorrelationTest

%% Load data

% choose k: horizontal wavenumber



%for en = 1:2
%  filename = ({['/export/carrot/raid2/wx019276/DATA/CVT/CTRLVECTS/eigvecs_0',num2str(en),'.dat']})
%  load(filename)
%end


cvtmp1 = load('/export/carrot/raid2/wx019276/DATA/CVT/CTRLVECTS/eigvecs_001.dat');
cvtmp1 = reshape(cvtmp1,[300,360,2]);
for k = 1:360
 for n = 1:300
    cv(1,k,n) = complex(cvtmp1(n,k,1), cvtmp1(n,k,2));
 end
end
cvtmp2 = load('/export/carrot/raid2/wx019276/DATA/CVT/CTRLVECTS/eigvecs_002.dat');
cvtmp2 = reshape(cvtmp2,[300,360,2]);
for k = 1:360
 for n = 1:300
    cv(2,k,n) = complex(cvtmp2(n,k,1), cvtmp2(n,k,2));
 end
end
cvtmp3 = load('/export/carrot/raid2/wx019276/DATA/CVT/CTRLVECTS/eigvecs_003.dat');
cvtmp3 = reshape(cvtmp3,[300,360,2]);
for k = 1:360
 for n = 1:300
    cv(3,k,n) = complex(cvtmp3(n,k,1), cvtmp3(n,k,2));
 end
end
cvtmp4 = load('/export/carrot/raid2/wx019276/DATA/CVT/CTRLVECTS/eigvecs_004.dat');
cvtmp4 = reshape(cvtmp4,[300,360,2]);
for k = 1:360
 for n = 1:300
    cv(4,k,n) = complex(cvtmp4(n,k,1), cvtmp4(n,k,2));
 end
end
cvtmp5 = load('/export/carrot/raid2/wx019276/DATA/CVT/CTRLVECTS/eigvecs_005.dat');
cvtmp5 = reshape(cvtmp5,[300,360,2]);
for k = 1:360
 for n = 1:300
    cv(5,k,n) = complex(cvtmp5(n,k,1), cvtmp5(n,k,2));
 end
end
cvtmp6 = load('/export/carrot/raid2/wx019276/DATA/CVT/CTRLVECTS/eigvecs_006.dat');
cvtmp6 = reshape(cvtmp6,[300,360,2]);
for k = 1:360
 for n = 1:300
    cv(6,k,n) = complex(cvtmp6(n,k,1), cvtmp6(n,k,2));
 end
end
cvtmp7 = load('/export/carrot/raid2/wx019276/DATA/CVT/CTRLVECTS/eigvecs_007.dat');
cvtmp7 = reshape(cvtmp7,[300,360,2]);
for k = 1:360
 for n = 1:300
    cv(7,k,n) = complex(cvtmp7(n,k,1), cvtmp7(n,k,2));
 end
end
cvtmp8 = load('/export/carrot/raid2/wx019276/DATA/CVT/CTRLVECTS/eigvecs_008.dat');
cvtmp8 = reshape(cvtmp8,[300,360,2]);
for k = 1:360
 for n = 1:300
    cv(8,k,n) = complex(cvtmp8(n,k,1), cvtmp8(n,k,2));
 end
end
cvtmp9 = load('/export/carrot/raid2/wx019276/DATA/CVT/CTRLVECTS/eigvecs_009.dat');
cvtmp9 = reshape(cvtmp9,[300,360,2]);
for k = 1:360
 for n = 1:300
    cv(9,k,n) = complex(cvtmp9(n,k,1), cvtmp9(n,k,2));
 end
end
cvtmp10 = load('/export/carrot/raid2/wx019276/DATA/CVT/CTRLVECTS/eigvecs_010.dat');
cvtmp10 = reshape(cvtmp10,[300,360,2]);
for k = 1:360
 for n = 1:300
    cv(10,k,n) = complex(cvtmp10(n,k,1), cvtmp10(n,k,2));
 end
end
cvtmp11 = load('/export/carrot/raid2/wx019276/DATA/CVT/CTRLVECTS/eigvecs_011.dat');
cvtmp11 = reshape(cvtmp11,[300,360,2]);
for k = 1:360
 for n = 1:300
    cv(11,k,n) = complex(cvtmp11(n,k,1), cvtmp11(n,k,2));
 end
end
cvtmp12 = load('/export/carrot/raid2/wx019276/DATA/CVT/CTRLVECTS/eigvecs_012.dat');
cvtmp12 = reshape(cvtmp12,[300,360,2]);
for k = 1:360
 for n = 1:300
    cv(12,k,n) = complex(cvtmp12(n,k,1), cvtmp12(n,k,2));
 end
end
cvtmp13 = load('/export/carrot/raid2/wx019276/DATA/CVT/CTRLVECTS/eigvecs_013.dat');
cvtmp13 = reshape(cvtmp13,[300,360,2]);
for k = 1:360
 for n = 1:300
    cv(13,k,n) = complex(cvtmp13(n,k,1), cvtmp13(n,k,2));
 end
end
cvtmp14 = load('/export/carrot/raid2/wx019276/DATA/CVT/CTRLVECTS/eigvecs_014.dat');
cvtmp14 = reshape(cvtmp14,[300,360,2]);
for k = 1:360
 for n = 1:300
    cv(14,k,n) = complex(cvtmp14(n,k,1), cvtmp14(n,k,2));
 end
end
cvtmp15 = load('/export/carrot/raid2/wx019276/DATA/CVT/CTRLVECTS/eigvecs_015.dat');
cvtmp15 = reshape(cvtmp15,[300,360,2]);
for k = 1:360
 for n = 1:300
    cv(15,k,n) = complex(cvtmp15(n,k,1), cvtmp15(n,k,2));
 end
end
cvtmp16 = load('/export/carrot/raid2/wx019276/DATA/CVT/CTRLVECTS/eigvecs_016.dat');
cvtmp16 = reshape(cvtmp16,[300,360,2]);
for k = 1:360
 for n = 1:300
    cv(16,k,n) = complex(cvtmp16(n,k,1), cvtmp16(n,k,2));
 end
end

%cvtmp = load('/export/carrot/raid2/wx019276/DATA/CVT/CTRLVECTS/eigvecs_001.dat')


%nems = 16
%for en = 1:nems
% if en<10
%  filename = {[/export/carrot/raid2/wx019276/DATA/CVT/CTRLVECTS/eigvecs_00,num2str(en),.dat]}
%  cvtmp = load('filename')
% cvtmp = load({['/export/carrot/raid2/wx019276/DATA/CVT/CTRLVECTS/eigvecs_00',num2str(en),'.dat']})
% elseif en >= 10
%  cvtmp = load{['/export/carrot/raid2/wx019276/DATA/CVT/CTRLVECTS/eigvecs_0',num2str(en),'.dat']}
% end 
%end
%cvtmp = reshape(cvtmp,[300,360,2]);

%for k = 1:360
% for n = 1:300
%    cv(en,k,n) = complex(cvtmp(n,k,1), cvtmp(n,k,2));
% end
%end
%send
