%implementation of the papoulis gerchberg cadzow algorithm 
%for extrapolation of b - bandlimted functions
%based on f(x)=sin(2*pi*x)/2*pi*x
%
%call: pgsin(i1,i2,p,w) ,maximize the window and wait 5 sec
%
%where:
%
%i1 ... limit1 = i1*pi
%i2 ... limit2 = i2*pi
%i1>i2!
%p  ... number of points 2^p
%w  ... number of iterations
%
%example:  pgsin(4,3,9,300)

function pgsin(i1,i2,p,w)
close all

%Zuweisung der Eingabeparameter

int1=i1*pi;
int2=i2*pi;
pt=2^p;
wh=w;

%Basisvariablen

x=linspace(-int1,int1,pt);
delta=2*int1/(pt-1);
diff=floor((int1-int2)/delta)+1; %Ursprungsfunktion ist mindestens im offenen Intervall (-int2,int2) gegeben

 
% Hilfsvariablen

test1=0;     %% Testvariable
tit=[num2str(w),' Iterationen'];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Definition der b-bandbeschraenkten Funktion y

band=1;
y=sin(2*pi*x)./(2*pi*x);
%y=cos(2*pi*x);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

org=y;

%Bilde die Hintereinanderausf¸hrung von f und der 
%charakteristischen Funktion im Intervall (-int2,int2)

for i=1:diff
y(i)=0;
end

for i=pt:-1:pt-diff+1  % 1 nicht vergessen!
y(i)=0;
end

figure
handle=plot(x,y,'EraseMode','background');
pause(5)
title(tit)

%Beginn des Algorithmus

for v=1:wh

%if test1== 1  %%%%%%%%%%%%%%%% beginne test1

%Fouriertransformation

Y=fft(y);
n=length(Y);

power=abs(Y(1:n)).^2;
powerh=abs(Y(1:n/2+1)).^2; %positive Frequenzen einschlieﬂlich der Nyquistfrequenz

nyquist=1/(2*delta);
freqh = (1:n/2+1)/(n/2+1)*nyquist;
absch=(floor((band/(nyquist/(pt/2))))+1)+1; 

% In den meisten Faellen ist es aufgrund der Diskretisierung nicht mˆglich exakt auﬂerhalb des Bandes abzuschneiden. In diesem Fall wird erst ab der n‰chsten Frequenz auﬂerhalb des Bandes abgeschnitten [ ((((+++))))+1 ]. Auﬂerdem muss beachtet werden dass in Matlab die Indizierung mit 1 und nicht mit 0 beginnt [ (((((+++))))+1) ]!


%figure
%%plot(power)
%plot(freqh,powerh)

%Abschneiden der Frequenzen auﬂerhalb des Bandes

Y1=zeros(size(Y));
for i=1:absch
Y1(i)=Y(i);
end

for i=length(Y):-1:length(Y)-absch+1+1 % Frequenz 0 hat hat den Index 1! 
Y1(i)=Y(i);
end

powerred=abs(Y1(1:n)).^2;
powerredh=abs(Y1(1:n/2+1)).^2;

%figure
%%plot(powerred)
%plot(freqh,powerredh)

%Inverse Fouriertransformation

z=ifft(Y1);

%figure
%plot(x,z)


%Innerhalb des Intervalls (-int2,int2)  wird z durch die Ursprungsfunktion y ersetzt

for i=1:diff
y(i)=z(i);
end

for i=pt:-1:pt-diff+1
y(i)=z(i);
end

%figure
%plot(x,y)

%Zeichnen der Funktion

set(handle,'XData',x,'YData',y)
drawnow

end

%hold on 
%plot(x,org,'r')

%clear
%end                    %%%%%%%%% ende case test1 
