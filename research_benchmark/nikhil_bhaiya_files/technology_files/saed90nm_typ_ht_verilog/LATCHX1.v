`timescale 1ns/1ps
`celldefine
module LATCHX1 (D, CLK, Q, QN);
input D;
input CLK;
output Q;
output QN;
reg notifier;

UDP_LATCHX1_Q U0 (Q, D, CLK, notifier);
not U1 (QN, Q);

specify
specparam
tdelay_D_Q_01_0=0.01,
tdelay_D_Q_10_0=0.01,
tdelay_CLK_Q_01_0=0.01,
tdelay_CLK_Q_10_0=0.01,
tdelay_D_QN_01_0=0.01,
tdelay_D_QN_10_0=0.01,
tdelay_CLK_QN_01_0=0.01,
tdelay_CLK_QN_10_0=0.01,
tsetup_D_CLK_0=0.01,
tsetup_D_CLK_1=0.01,
thold_CLK_D_0=0.01,
thold_CLK_D_1=0.01,
tpulsewidth_CLK_0=0.01;

(D +=> Q)=(tdelay_D_Q_01_0, tdelay_D_Q_10_0);
(posedge CLK => (Q : 1'b1))=(tdelay_CLK_Q_01_0, tdelay_CLK_Q_10_0);
(D -=> QN)=(tdelay_D_QN_01_0, tdelay_D_QN_10_0);
(posedge CLK => (QN : 1'b1))=(tdelay_CLK_QN_01_0, tdelay_CLK_QN_10_0);
$setup(posedge D , negedge CLK , tsetup_D_CLK_0 , notifier);
$setup(negedge D , negedge CLK , tsetup_D_CLK_1 , notifier);
$hold(negedge CLK , posedge D , thold_CLK_D_0 , notifier);
$hold(negedge CLK , negedge D , thold_CLK_D_1 , notifier);
$width(posedge CLK , tpulsewidth_CLK_0 ,0, notifier);
endspecify
endmodule
`endcelldefine
primitive UDP_LATCHX1_Q (q, in1, in2, notifier);
output q;
reg q;
input in1, in2, notifier;
table
//	D	CLK	notifier	: Q 	: Q+1 ;
	0	1	?		: ? 	: 0 ;
	1	1	?		: ? 	: 1 ;
	?	0	?		: ? 	: - ;
	0	x	?		: 0 	: 0 ;	//pessimism reduction
	1	x	?		: 1 	: 1 ;	//pessimism reduction
	*	0	?		: ? 	: - ;
	?	?	*		: ? 	: x ;
endtable
endprimitive

