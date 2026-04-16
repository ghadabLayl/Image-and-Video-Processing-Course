x = [1 2 3 4 5 6 7 8 9 10];

y = [1;2;3;4;5;6;7;8;9;10];

x = x';

x = 1:10;
y = 0:0.1:2;

x=linspace(0, pi/2, 10);

a = [1 2 3 ; 4 5 6 ; 7 8 9];

size(y) ;
length(y);

p1 = [1 -5 4];
p2 = [1 0 4];
p3 = [1 -5 0];

conv(p1,p2);

y1 = 2*x;
y2 = sqrt(x);  
b = sqrt(a) ;
y3 = y1 + y2 ;
c = a*b ;

d = a.^3; 
a3 = a^3; 
e = a.*b ;
f = a*b ;

x  = 0:0.5:10; 
y1= 2*x; 

y2= sqrt(x); 

plot(x,y1, x,y2);

plot(x,y1,'-.') 
hold  
plot(x,y2,'--') 
hold 

title('A boring plot') 
xlabel('The x-axis label'), ylabel('The y-axis label') 

grid 
legend('y1','y2')

text(1,9,'My two curves')

gtext('My two curves') 

axis([0 15 0 30]) 