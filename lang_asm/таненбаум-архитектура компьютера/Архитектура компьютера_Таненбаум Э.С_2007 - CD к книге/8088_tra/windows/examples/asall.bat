echo off
as88 HlloWrld.s
as88 GenReg.s
as88 HlloLoop.s
as88 HlloPtrg.s
as88 InFilBuf.s
as88 correct1.s
as88 getargs.s
as88 inp.s
as88 jumptbl.s
as88 linumber.s
as88 reverspr.s
as88 sscanf.s
as88 strngcpy.s stringpr.s
as88 vecprod.s
echo '! The program arrayprt.s is supposed to print a'
echo '! vector, but it contains errors, which'
echo '! must be corrected first.'
echo '! See text section 9.8.4.'
as88 arrayprt.s
