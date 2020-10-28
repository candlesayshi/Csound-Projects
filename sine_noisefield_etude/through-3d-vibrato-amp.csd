<CsoundSynthesizer>
<CsOptions>
-n -d 
</CsOptions>
<CsInstruments>
; Initialize the global variables.

nchnls = 1
0dbfs = 1

gkpitch init 0
gkamp init 0
gidur init 0

instr 1 ; PITCH CONTROL

gkpitch = p5
gkamp = p4
gidur = p3

endin

instr 2 ; SINE NOISE

kdec	linen 1, gidur, p3, gidur*4
asin	oscil gkamp * kdec, gkpitch
out 	asin

endin

</CsInstruments>
<CsScore>
i2 0.0 20.0
i1 0.0 0.27272728 0.55538034 341.57883
i1 0.27272728 0.27272728 0.5555458 341.67627
i1 0.54545456 0.27272728 0.55613613 341.89395
i1 0.8181819 0.27272728 0.55687255 342.16406
i1 1.0909091 0.27272728 0.55775166 342.4743
i1 1.3636364 0.27272728 0.55896974 342.87454
i1 1.6363636 0.27272728 0.56001204 343.2282
i1 1.9090909 0.27272728 0.56117797 343.60632
i1 2.1818182 0.27272728 0.5621711 343.93634
i1 2.4545455 0.27272728 0.5629401 344.19373
i1 2.7272727 0.27272728 0.563764 344.451
i1 3.0 0.27272728 0.5640912 344.56448
i1 3.2727273 0.27272728 0.5643619 344.6567
i1 3.5454545 0.27272728 0.5642411 344.6509
i1 3.8181818 0.27272728 0.5637889 344.55725
i1 4.090909 0.27272728 0.5633668 344.47092
i1 4.3636365 0.27272728 0.56248355 344.26495
i1 4.636364 0.27272728 0.5616898 344.08032
i1 4.9090915 0.27272728 0.56060445 343.82074
i1 5.181819 0.27272728 0.55941856 343.53168
i1 5.4545465 0.27272728 0.55847454 343.3023
i1 5.727274 0.27272728 0.55733603 343.0201
i1 6.0000014 0.27272728 0.5565068 342.8141
i1 6.272729 0.27272728 0.55556536 342.57648
i1 6.5454564 0.27272728 0.55459493 342.32867
i1 6.818184 0.27272728 0.55310327 341.95282
i1 7.0909114 0.27272728 0.550711 341.34973
i1 7.363639 0.27272728 0.5478188 340.62845
i1 7.6363664 0.27272728 0.5437635 339.62796
i1 7.909094 0.27272728 0.5392885 338.526
i1 8.181821 0.27272728 0.53411984 337.2764
i1 8.454548 0.27272728 0.52845556 335.91302
i1 8.727275 0.27272728 0.5224947 334.50378
i1 9.000002 0.27272728 0.515408 332.85147
i1 9.272729 0.27272728 0.50843465 331.2426
i1 9.545456 0.27272728 0.50098056 329.55835
i1 9.818183 0.27272728 0.49353108 327.89172
i1 10.09091 0.27272728 0.48589998 326.20544
i1 10.363637 0.27272728 0.47702828 324.24554
i1 10.636364 0.27272728 0.4683835 322.33987
i1 10.909091 0.27272728 0.45940137 320.37115
i1 11.181818 0.27272728 0.45063564 318.44534
i1 11.454545 0.27272728 0.44235033 316.63214
i1 11.727272 0.27272728 0.4337871 314.75232
i1 11.999999 0.27272728 0.42635015 313.11823
i1 12.272726 0.27272728 0.4197292 311.66684
i1 12.545453 0.27272728 0.41413727 310.43115
i1 12.81818 0.27272728 0.40983927 309.48026
i1 13.090907 0.27272728 0.4063009 308.6852
i1 13.363634 0.27272728 0.40424737 308.2152
i1 13.636361 0.27272728 0.40328258 308.00787
i1 13.909088 0.27272728 0.40303254 307.97144
i1 14.181815 0.27272728 0.40356362 308.126
i1 14.454542 0.27272728 0.40441808 308.36157
i1 14.727269 0.27272728 0.40589467 308.74304
i1 14.999996 0.27272728 0.4076652 309.19772
i1 15.272723 0.27272728 0.4092871 309.61462
i1 15.54545 0.27272728 0.41064993 309.9706
i1 15.818177 0.27272728 0.41137847 310.17593
i1 16.090904 0.27272728 0.4116838 310.27466
i1 16.363632 0.27272728 0.4113143 310.2119
i1 16.63636 0.27272728 0.41004813 309.9305
i1 16.909088 0.27272728 0.4082363 309.52252
i1 17.181816 0.27272728 0.40571204 308.95184
i1 17.454544 0.27272728 0.40292722 308.32108
i1 17.727272 0.27272728 0.399867 307.6298
i1 18.0 0.27272728 0.39656627 306.88196
i1 18.272728 0.27272728 0.3933446 306.15338
i1 18.545456 0.27272728 0.39001557 305.39957
i1 18.818184 0.27272728 0.38704282 304.7259
i1 19.090912 0.27272728 0.3844955 304.14948
i1 19.36364 0.27272728 0.38246435 303.6891
i1 19.636368 0.27272728 0.38111457 303.38354
i1 19.909096 0.27272728 0.38040492 303.22272


</CsScore>
</CsoundSynthesizer>