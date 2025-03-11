A=[0 1 0
   0 0 0
   1 0 0];
B=[0
   1
   0];
C=[1 0 0];
D=[0];
system=ss(A,B,C,D);
Qx=[10 0 0
    0 1 0
    0 0 5];
Qu=[0.1];
[K,P]=lqr(A,B,Qx,Qu)
