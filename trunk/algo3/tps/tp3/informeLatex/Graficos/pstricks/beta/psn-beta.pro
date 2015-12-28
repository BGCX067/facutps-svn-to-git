%!
% PostScript prologue for psn-beta.tex.
% Created 1993/4/16. Source file was psn-beta.doc
% Version 0.93a, 93/03/12.
% For use with Rokicki's dvips.
/tx@NodeDict 400 dict def tx@NodeDict begin
tx@Dict begin /T /translate load def end
/NewNode { dict dup 3 -1 roll ED begin /NodeMtrx CM def } def
/InitPnode { /Y ED /X ED /NodePos { Nodesep Cos mul Nodesep Sin mul } def
} def
/InitCnode { /r ED /Y ED /X ED /NodePos { Nodesep r add dup Cos mul exch
Sin mul } def } def
/GetRnodePos { Cos 0 gt { /dx r Nodesep add def } { /dx l Nodesep sub def
} ifelse Sin 0 gt { /dy u Nodesep add def } { /dy d Nodesep sub def }
ifelse dx Sin mul abs dy Cos mul abs gt { dy Cos mul Sin div dy } { dx
dup Sin mul Cos Div } ifelse } def
/InitRnode { /Y ED /X ED X sub /r ED /l X neg def Y add neg /d ED Y sub
/u ED /NodePos { GetRnodePos } def } def
/DiaNodePos { w h mul w Sin mul abs h Cos mul abs add Div Nodesep add dup
Cos mul exch Sin mul } def
/TriNodePos { Sin s lt { d Nodesep sub dup Cos mul Sin Div exch } { w h
mul w Sin mul h Cos abs mul add Div Nodesep add dup Cos mul exch Sin mul
} ifelse } def
/InitTriNode { sub 2 div exch 2 div exch 2 copy T 2 copy 4 index index /d
ED pop pop pop pop -90 mul rotate /NodeMtrx CM def /X 0 def /Y 0 def d
sub abs neg /d ED d add /h ED 2 div h mul h d sub Div /w ED /s d w Atan
sin def /NodePos { TriNodePos } def } def
/OvalNodePos { /ww w Nodesep add def /hh h Nodesep add def Sin ww mul Cos
hh mul Atan dup cos ww mul exch sin hh mul } def
/GetCenter { begin X Y NodeMtrx transform CM itransform end } def
/AddOffset { 1 index 0 eq { pop pop } { 2 copy 5 2 roll cos mul add 4 1
roll sin mul sub exch } ifelse } def
/GetEdge { begin /Nodesep ED dup 1 0 NodeMtrx dtransform CM idtransform
exch atan sub dup sin /Sin ED cos /Cos ED Nodesep 0 ge { NodePos } {
Nodesep neg dup Cos mul exch Sin mul } ifelse Y add exch X add exch
NodeMtrx transform CM itransform end 4 2 roll AddOffset  } def
/GetPos { OffsetA AngleA NodesepA nodeA GetEdge /y1 ED /x1 ED OffsetB
AngleB NodesepB nodeB GetEdge /y2 ED /x2 ED } def
/GetArmA { armA 0 lt { xA yA OffsetA AngleA AddOffset } { x1 y1 } ifelse
armA abs AngleA sin mul add /y1a ED armA abs AngleA cos mul add /x1a ED
} def
/GetArmB { armB 0 lt { xB yB OffsetB AngleB AddOffset } { x2 y2 } ifelse
armB abs AngleB sin mul add /y2a ED armB abs AngleB cos mul add /x2a ED
} def
/InitNC { /b ED /a ED /NodesepB ED /NodesepA ED /OffsetB ED /OffsetA ED
tx@NodeDict a known tx@NodeDict b known and dup { /nodeA a load def
/nodeB b load def nodeA GetCenter /yA ED /xA ED nodeB GetCenter /yB ED
/xB ED } if } def
/LPutLine { 4 copy 3 -1 roll sub neg 3 1 roll sub Atan /NAngle ED 1 t sub
mul 3 1 roll 1 t sub mul 4 1 roll t mul add /Y ED t mul add /X ED } def
/LPutLines { mark LPutVar counttomark 2 div 1 sub /n ED t floor dup n gt
{ pop n 1 sub /t 1 def } { dup t sub neg /t ED } ifelse cvi 2 mul { pop
} repeat LPutLine cleartomark } def
/BezierMidpoint { /y3 ED /x3 ED /y2 ED /x2 ED /y1 ED /x1 ED /y0 ED /x0 ED
/t ED /cx x1 x0 sub 3 mul def /cy y1 y0 sub 3 mul def /bx x2 x1 sub 3
mul cx sub def /by y2 y1 sub 3 mul cy sub def /ax x3 x0 sub cx sub bx
sub def /ay y3 y0 sub cy sub by sub def ax t 3 exp mul bx t t mul mul
add cx t mul add x0 add ay t 3 exp mul by t t mul mul add cy t mul add
y0 add 3 ay t t mul mul mul 2 by t mul mul add cy add 3 ax t t mul mul
mul 2 bx t mul mul add cx add atan /NAngle ED /Y ED /X ED } def
/HPosBegin { yB yA ge { /t 1 t sub def } if /Y yB yA sub t mul yA add def
} def
/HPosEnd { /X Y yA sub yB yA sub Div xB xA sub mul xA add def /NAngle yB
yA sub xB xA sub Atan def } def
/HPutLine { HPosBegin /yA ED /xA ED /yB ED /xB ED HPosEnd  } def
/HPutLines { HPosBegin yB yA ge { /check { ge } def } { /check { lt } def
} ifelse mark xB yB LPutVar { dup Y check { exit } { /yA ED /xA ED }
ifelse } loop /yB ED /xB ED cleartomark HPosEnd  } def
/VPosBegin { xB xA lt { /t 1 t sub def } if /X xB xA sub t mul xA add def
} def
/VPosEnd { /Y X xA sub xB xA sub Div yB yA sub mul yA add def /NAngle yB
yA sub xB xA sub Atan def } def
/VPutLine { VPosBegin /yA ED /xA ED /yB ED /xB ED VPosEnd  } def
/VPutLines { VPosBegin xB xA ge { /check { ge } def } { /check { lt } def
} ifelse mark xB yB LPutVar { 1 index X check { exit } { /yA ED /xA ED }
ifelse } loop /yB ED /xB ED cleartomark VPosEnd  } def
/HPutCurve { gsave newpath /SaveLPutVar /LPutVar load def LPutVar 8 -2
roll moveto curveto flattenpath /LPutVar [ {} {} {} {} pathforall ] cvx
def grestore exec /LPutVar /SaveLPutVar load def } def
/NCCoor { /AngleA yB yA sub xB xA sub Atan def /AngleB AngleA 180 add def
GetPos /LPutVar [ x2 y2 x1 y1 ] cvx def /LPutPos { LPutVar LPutLine }
def /HPutPos { LPutVar HPutLine } def /VPutPos { LPutVar VPutLine } def
LPutVar } def
/NCLine { NCCoor tx@Dict begin ArrowA CP 4 2 roll ArrowB lineto pop pop
end } def
/NCCurve { GetPos x1 x2 sub y1 y2 sub Pyth 2 div dup 3 -1 roll mul /armA
ED mul /armB ED GetArmA GetArmB x1a y1a x1 y1 tx@Dict begin ArrowA end
x2a y2a x2 y2 tx@Dict begin ArrowB end curveto /LPutVar [ x1 y1 x1a y1a
x2a y2a x2 y2 ] cvx def /LPutPos { t LPutVar BezierMidpoint } def
/HPutPos { { HPutLines } HPutCurve } def /VPutPos { { VPutLines }
HPutCurve } def } def
/NCAngles { GetPos GetArmA GetArmB /mtrx AngleA matrix rotate def x1a y1a
mtrx transform pop x2a y2a mtrx transform exch pop mtrx itransform /y0
ED /x0 ED mark armB 0 ne { x2 y2 } if x2a y2a x0 y0 x1a y1a armA 0 ne {
x1 y1 } if tx@Dict begin false Line end /LPutVar [ x2 y2 x2a y2a x0 y0
x1a y1a x1 y1 ] cvx def /LPutPos { LPutLines } def /HPutPos { HPutLines
} def /VPutPos { VPutLines } def } def
/NCAngle { GetPos GetArmB /mtrx AngleA matrix rotate def x2a y2a mtrx
itransform pop x1 y1 mtrx itransform exch pop mtrx transform /y0 ED /x0
ED mark armB 0 ne { x2 y2 } if x2a y2a x0 y0 x1 y1 tx@Dict begin false
Line end /LPutVar [ x2 y2 x2a y2a x0 y0 x1 y1 ] cvx def /LPutPos {
LPutLines } def /HPutPos { HPutLines } def /VPutPos { VPutLines } def }
def
/NCBar { GetPos GetArmA GetArmB /mtrx AngleA matrix rotate def x1a y1a
mtrx itransform pop x2a y2a mtrx itransform pop sub dup 0 mtrx transform
3 -1 roll 0 gt { /y2a exch y2a add def /x2a exch x2a add def } { /y1a
exch neg y1a add def /x1a exch neg x1a add def } ifelse mark armB 0 ne {
x2 y2 } if x2a y2a x1a y1a armA 0 ne { x1 y1 } if tx@Dict begin false
Line end /LPutVar [ x2 y2 x2a y2a x1a y1a x1 y1 ] cvx def /LPutPos {
LPutVar LPutLines } def /HPutPos { HPutLines } def /VPutPos { VPutLines
} def } def
/NCDiag { GetPos GetArmA GetArmB mark armB 0 ne { x2 y2 } if x2a y2a x1a
y1a armA 0 ne { x1 y1 } if tx@Dict begin false Line end /LPutVar [ x2 y2
x2a y2a x1a y1a x1 y1 ] cvx def /LPutPos { LPutLines } def /HPutPos {
HPutLines } def /VPutPos { VPutLines } def } def
/NCDiagg { OffsetA AngleA NodesepA nodeA GetEdge /y1 ED /x1 ED GetArmA yB
y1a sub xB x1a sub Atan 180 add /AngleB ED OffsetB AngleB NodesepB nodeB
GetEdge /y2 ED /x2 ED mark x2 y2 x1a y1a armA 0 ne { x1 y1 } if tx@Dict
begin false Line end /LPutVar [ x2 y2 x1a y1a x1 y1] cvx def /LPutPos {
LPutLines } def /HPutPos { HPutLines } def /VPutPos { VPutLines } def }
def
/NCLoop { GetPos GetArmA GetArmB /mtrx AngleA matrix rotate def x1a y1a
mtrx transform loopsize add /y1b ED /x1b ED /x2b x2a y2a mtrx transform
pop def x2b y1b mtrx itransform /y2b ED /x2b ED x1b y1b mtrx itransform
/y1b ED /x1b ED mark armB 0 ne { x2 y2 } if x2a y2a x2b y2b x1b y1b x1a
y1a armA 0 ne { x1 y1 } if tx@Dict begin false Line end /LPutVar [ x2 y2
x2a y2a x2b y2b x1b y1b x1a y1a x1 y1 ] cvx def /LPutPos { LPutLines }
def /HPutPos { HPutLines } def /VPutPos { VPutLines } def } def
/NCCircle { 0 0 NodesepA nodeA GetEdge pop xA sub 2 div dup 2 exp r r mul
sub abs sqrt atan 2 mul /a ED r AngleA 90 add PtoC yA add exch xA add
exch 2 copy /LPutVar [ 4 2 roll r a ] def /LPutPos { LPutVar aload pop t
360 mul add dup 5 1 roll 90 sub PtoC 3 -1 roll add 3 1 roll add exch 3
-1 roll } def /HPutPos { LPutPos } def /VPutPos { LPutPos } def r AngleA
90 sub a add AngleA 270 add a sub tx@Dict begin /angleB ED /angleA ED /r
ED /c 57.2957 r Div def /y ED /x ED } def
/NCBox { /d ED /h ED /AngleB yB yA sub xB xA sub Atan def /AngleA AngleB
180 add def GetPos /dx d AngleB sin mul def /dy d AngleB cos mul neg def
/hx h AngleB sin mul neg def /hy h AngleB cos mul def /LPutVar [ x1 hx
add y1 hy add x2 hx add y2 hy add x2 dx add y2 dy add x1 dx add y1 dy
add ] cvx def /LPutPos { LPutLines } def /HPutPos { xB yB xA yA LPutLine
} def /VPutPos { HPutPos } def mark LPutVar tx@Dict begin false Polygon
end } def
/NCArcBox { /l ED neg /d ED /h ED /a ED /AngleA yB yA sub xB xA sub Atan
def /AngleB AngleA 180 add def /tA AngleA a sub 90 add def /tB tA a 2
mul add def /r xB xA sub tA cos tB cos sub Div dup 0 eq { pop 1 } if def
/x0 xA r tA cos mul add def /y0 yA r tA sin mul add def /c 57.2958 r div
def /AngleA AngleA a sub 180 add def /AngleB AngleB a add 180 add def
GetPos /AngleA tA 180 add yA y1 sub xA x1 sub Pyth c mul sub def /AngleB
tB 180 add yB y2 sub xB x2 sub Pyth c mul add def l 0 eq { x0 y0 r h add
AngleA AngleB arc x0 y0 r d add AngleB AngleA arcn } { x0 y0 translate
/tA AngleA l c mul add def /tB AngleB l c mul sub def 0 0 r h add tA tB
arc r h add AngleB PtoC r d add AngleB PtoC 2 copy 6 2 roll l arcto 4 {
pop } repeat r d add tB PtoC l arcto 4 { pop } repeat 0 0 r d add tB tA
arcn r d add AngleA PtoC r h add AngleA PtoC 2 copy 6 2 roll l arcto 4 {
pop } repeat r h add tA PtoC l arcto 4 { pop } repeat } ifelse closepath
/LPutVar [ x0 y0 r AngleA AngleB h d ] cvx def /LPutPos { LPutVar /d ED
/h ED /AngleB ED /AngleA ED /r ED /y0 ED /x0 ED t 1 le { r h add AngleA
1 t sub mul AngleB t mul add dup 90 add /NAngle ED PtoC } { t 2 lt {
/NAngle AngleB 180 add def r 2 t sub h mul t 1 sub d mul add add AngleB
PtoC } { t 3 lt { r d add AngleB 3 t sub mul AngleA 2 t sub mul add dup
90 sub /NAngle ED PtoC } { /NAngle AngleA 180 add def r 4 t sub d mul t
3 sub h mul add add AngleA PtoC } ifelse } ifelse } ifelse y0 add /Y ED
x0 add /X ED } def /HPutPos { LPutPos } def /VPutPos { LPutPos } def }
def
/Tfan { /AngleA yB yA sub xB xA sub Atan def OffsetA AngleA NodesepA
nodeA GetEdge /y1 ED /x1 ED w x1 xB sub y1 yB sub Pyth Pyth w Div CLW 2
div mul 2 div dup AngleA sin mul y1 add /y1 ED AngleA cos mul x1 add /x1
ED /LPutVar [ x1 y1 m { xB w add yB xB w sub yB } { xB yB w sub xB yB w
add } ifelse x1 y1 ] cvx def /LPutPos { LPutLines } def /VPutPos@ {
LPutVar flag { 8 4 roll pop pop pop pop } { pop pop pop pop 4 2 roll }
ifelse } def /VPutPos { VPutPos@ VPutLine } def /HPutPos { VPutPos@
HPutLine } def mark LPutVar tx@Dict begin /ArrowA { moveto } def /ArrowB
{ } def false Line closepath end } def
/LPutCoor { NAngle tx@Dict begin /NAngle ED end gsave CM STV CP Y sub neg
exch X sub neg exch moveto setmatrix CP grestore } def
/LPut { tx@NodeDict /LPutPos known { LPutPos } { CP /Y ED /X ED /NAngle 0
def } ifelse LPutCoor  } def
/HPutAdjust { Sin Cos mul 0 eq { 0 } { d Cos mul Sin div flag not { neg }
if h Cos mul Sin div flag { neg } if 2 copy gt { pop } { exch pop }
ifelse } ifelse s add flag { r add neg } { l add } ifelse X add /X ED }
def
/VPutAdjust { Sin Cos mul 0 eq { 0 } { l Sin mul Cos div flag { neg } if
r Sin mul Cos div flag not { neg } if 2 copy gt { pop } { exch pop }
ifelse } ifelse s add flag { d add } { h add neg } ifelse Y add /Y ED }
def
end
