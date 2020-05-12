sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

instr 1

ifb	= p5
a2 	init 0

;wet delayed pluck
a1 	pluck 0.3*p6, p4/4, p4/4, 0, 1
al 	pluck 0.00001, p4, p4, 0, 2, 2

;low doubled drone
k1 	oscil 1, p3/2
a4 	oscil 0.3*p6*k1, p4/4
a5 	distort1 a4, 1.5, 0.5, 0, 0
a2 	delay (a1+(al/1000000))+(a2*ifb), p3/6
a3 	reverb (a1/2+a2/2+a5/8), p3
 			out ((a1/6)+a2+(a3/10)), ((a1/6)+a2+(a3/10))
 			
endin


