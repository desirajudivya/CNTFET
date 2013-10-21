***************************************************
*For optimal accuracy, convergence, and runtime
***************************************************
.options POST
.options AUTOSTOP
.options INGOLD=2     DCON=1
.options GSHUNT=1e-12 RMIN=1e-15 
.options ABSTOL=1e-5  ABSVDC=1e-4 
.options RELTOL=1e-2  RELVDC=1e-2 
.options NUMDGT=4     PIVOT=13
.param   TEMP=27
***************************************************
*Include relevant model files
***************************************************
.lib 'CNFET.lib' CNFET
***************************************************
*Beginning of circuit and device definitions
***************************************************
*Supplies and voltage params:
.param Supply=0.9  
.param Vg='Supply'
.param Vd='Supply'
*Some CNFET parameters:
.param Ccsd=0      CoupleRatio=0
.param m_cnt=1     Efo=0.6     
.param Wg=0        Cb=40e-12
.param Lg=32e-9    Lgef=100e-9
.param Vfn=0       Vfp=0
.param m=19        n=0        
.param Hox=4e-9    Kox=16 

***********************************************************************
* Define power supply
***********************************************************************
Vd1 Vdd Gnd Vd
Vs1 Vss Gnd 0
Vg1 Vgg Gnd Vg
Vsub Sub Gnd 0
VA in Gnd 0 0 PULSE(0 'Supply' 0 0.01p 0.01p 1n 2n)
***************************************************************************
*Sub-Circuits
***********************************************************************
.subckt inverter in out vh vl
X1 out in vl vl NCNFET Lch=Lg  Lgeff='Lgef' Lss=32e-9  Ldd=32e-9  
+ Kgate='Kox' Tox='Hox' Csub='Cb' Vfbn='Vfn' Dout=0  Sout=0  Pitch=20e-9  n1=m  n2=n  tubes=3
X2 out in vh vh PCNFET Lch=Lg  Lgeff='Lgef' Lss=32e-9  Ldd=32e-9  
+ Kgate='Kox' Tox='Hox' Csub='Cb' Vfbp='Vfp' Dout=0  Sout=0  Pitch=20e-9  n1=m  n2=n  tubes=3
.ends
***********************************************************************
* Main Circuits
***********************************************************************
* implement inverter
X4 in out Vdd Gnd inverter
***********************************************************************
* Measurements
***********************************************************************
.TRAN 1p 3n
.print V(out)
.end