
clc;
clear;
pathSC=['D:\boyi\snow depth water equivalent\1950-2021nc\','-65-65sc.nc'];
pathSWE=['D:\boyi\snow depth water equivalent\1950-2021nc\','-65-65swe.nc'];
SWE=ncread(pathSWE,'swe');
SWE=double(SWE);
SWE(SWE==-2.147483648000000e+09)=NaN;
Area(:,1252:1301)=NaN;
Area(:,1:50)=NaN;
datadir=['D:\boyi\snow depth water equivalent\1950-2021nc\'];%%æ–‡ä»¶è·¯å¾„
ncFilePath=[datadir,'North 65¡ã, West -180¡ã, South -65¡ã, East 180¡ã.nc'];
SD=ncread(ncFilePath,'sd');%%è¯»å–ncæ–‡ä»¶SDå€?
SD=Area+SD;
time=length(ncread(ncFilePath,'time'));
SD(SD==-32767)=NaN;
SWEI=NaN(3600,1301,time);
for s =1:3600
for t =1:1301
td=SD(s,t,:);%%ç»åº¦åºåˆ—kçº¬åº¦åºåˆ—iå¤?144ä¸ªæœˆSDå€?
td=td(:);
sc=3;
n=length(td);
SI=NaN(n,1);
if length(td(td>=0))/length(td)~=1
   SI(n,1)=nan;
   else
   SI(1:sc-1,1)=nan;        
   A1=[];
   for i=1:sc  
   A1=[A1,td(i:length(td)-sc+i)];
   end
   Y=sum(A1,2);
   % Compute the SPI or SSI
    nn=length(Y);
    SI1=NaN(nn,1);
    for k=1:12
    d=Y(k:12:nn);
    nnn=length(d);
	d(d==0)=rand()*1.525948758640539e-04;	
    %compute the empirical probability 
    bp=NaN(nnn,1);
    for i=1:nnn
    bp(i,1)=sum(d(:,1)<=d(i,1));
    end
    y=(bp-0.44)./(nnn+0.12);
    SI1(k:12:nn,1)=y;
    end
SI1(:,1)=norminv(SI1(:,1));
%output                   
SI(sc:end,1)=SI1;
end
SWEI(s,t,:)=SI;
end
end
