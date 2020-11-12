<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr 	  	= 44100
ksmps 	= 32
nchnls 	= 1
0dbfs 	= 1

ginote = 220

instr 1

inote = ginote

k1	oscil	0.1, inote/1000
a1	oscil 	0.05, inote
a2	distort 	a1, 0.1 + k1, 1
a3 	exciter 	(a2+a1)/2, inote/2, inote * 2, 8, 5 * k1
a4	butterlp 	a1/2 + a3/4, inote
;a3	butterlp 	a1, inote
a5	nreverb 	a4, inote/1000, 0.1 + k1
	out	(a5+a1)/2
	
endin

instr 2

inote = ginote * (32/27)

k1	oscil	0.1, inote/1000
a1	oscil 	0.05, inote
a2	distort 	a1, 0.1 + k1, 1
a3 	exciter 	(a2+a1)/2, inote/2, inote * 2, 8, 5 * k1
a4	butterlp 	a1/2 + a3/4, inote
;a3	butterlp 	a1, inote
a5	nreverb 	a4, inote/1000, 0.1 + k1
	out	(a5+a1)/2
	
endin

instr 3

inote = ginote * (3/2)

k1	oscil	0.1, inote/1000
a1	oscil 	0.05, inote
a2	distort 	a1, 0.1 + k1, 1
a3 	exciter 	(a2+a1)/2, inote/2, inote * 2, 8, 5 * k1
a4	butterlp 	a1/2 + a3/4, inote
;a3	butterlp 	a1, inote
a5	nreverb 	a4, inote/1000, 0.1 + k1
	out	(a5+a1)/2
	
endin

instr 4

inote = ginote * 2.0

k1	oscil	0.1, inote/1000
a1	oscil 	0.05, inote
a2	distort 	a1, 0.1 + k1, 1
a3 	exciter 	(a2+a1)/2, inote/2, inote * 2, 8, 5 * k1
a4	butterlp 	a1/2 + a3/4, inote
;a3	butterlp 	a1, inote
a5	nreverb 	a4, inote/1000, 0.1 + k1
	out	(a5+a1)/2
	
endin

</CsInstruments>
<CsScore>
f1 0 2048 10 1 0 0.3 0 0.2

i1 0 20
i2 0 20
i3 0 10
i4 0 20

</CsScore>
</CsoundSynthesizer>
