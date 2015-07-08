FILE *bituit;
 
int pfildes[2], pnr;
char bmbuf[9000];
/*file descriptor and procedure number to create a pipe for the bitmap*/
 
bitmapdump(b,h,buff) int b,h; char *buff;{
  if ((bituit=fopen("tERMbITmAP","w")) == NULL) {
	fprintf(stderr,"Kan tERMbITmAP niet openen\n"); exit(1);}
  schrijfmap(b,h,buff,bituit);
  fclose(bituit);
  sprintf(bmbuf," %c.c configure -bitmap @lEEGbITMAP%c\n",'"','"'); schrijf();
  system("sleep 1");
  sprintf(bmbuf," %c.c configure -bitmap @tERMbITMAP%c\n",'"','"'); schrijf();
  system("sleep 1");
}
 
bitmapopen(b,h) int b,h; {
  /*FAKE SYSTEM CALL TO OPEN A BITMAP FOR OPGAVE 1 */
  int i;
  if(pipe(pfildes)< 0) {fprintf(stderr,"Kan geen pipe creeren\n"); exit(1);}
  if((pnr = fork()) < 0) {fprintf(stderr,"Kan niet vorken\n"); exit(1);}
  if(pnr == 0){dup2(pfildes[0],0); system("exec /usr/local/bin/wish"); exit(0);}

  if ((bituit=fopen("lEEGbITmAP","w")) == NULL) {
	fprintf(stderr,"Kan lEEGbITmAP niet openen\n"); exit(1);}
  schrijfmap(b,h,bmbuf,bituit);
  fclose(bituit);

  sprintf(bmbuf,"#!/usr/local/bin/wish -f\n. configure -background gray\n");
  schrijf();
  sprintf(bmbuf,". configure -width 302\n. configure -height 266\n"); schrijf();
  sprintf(bmbuf,"button .b -text %cexit window %c",'"','"'); schrijf();
  sprintf(bmbuf," -command %cdestroy .%c\n",'"','"'); schrijf();
  sprintf(bmbuf,"place .b -x 2 -y 2 -relwidth 0.32 -height 0.7c\n"); schrijf();
  sprintf(bmbuf,"label .c -bitmap @lEEGbITmAP\nplace .c -x 3 -y 0.9c\n");schrijf();
  sprintf(bmbuf,".c configure -background black -foreground white\n"); schrijf();
  sprintf(bmbuf,".b configure -background black -foreground white\n"); schrijf();
  sprintf(bmbuf,"button .d -text %cdisplay new%c -command",'"','"'); schrijf();
  sprintf(bmbuf," %c.c configure -bitmap @tERMbITmAP%c\n",'"','"'); schrijf();
  sprintf(bmbuf,"place .d -x 101 -y 3 -relwidth 0.32 -height 0.7c\n"); schrijf();
  sprintf(bmbuf,".d configure -background black -foreground white\n"); schrijf();
  sprintf(bmbuf,"button .e -text %cclear window %c -command",'"','"'); schrijf();
  sprintf(bmbuf," %c.c configure -bitmap @lEEGbITMAP%c\n",'"','"'); schrijf();
  sprintf(bmbuf,"place .e -x 200 -y 3 -relwidth 0.32 -height 0.7c\n"); schrijf();
  sprintf(bmbuf,".e configure -background black -foreground white\n"); schrijf();
  system("sleep 1");
}
 

schrijf(){
  int j;
  char *p;
  p = buf;
  j = 0;
  while(*p++ > '\0') j++;
  write(pfildes[1],buf,j);
}

  
spiegel(n) int n;{
  int i,j,k,l;
  i = 1; j = 128; l = 0; for(k=0;k<8;k++) {if((i&n)>0) l |= j; i <<= 1; j >>= 1;}
  return(l);
} 

schrijfmap(b,h,buf,uitf) int b,h; char *buf; FILE *uitf; {
  int i,j,k;
  char *p;
  if(b%8!=0){
	fprintf(stderr,"Bitmap breedte hoort een heel aantal bytes te zijn\n");
	exit(1);}
  fprintf(uitf,"#define noname_width %d\n",b);
  fprintf(uitf,"#define noname_height %d\n",h);
  fprintf(uitf,"static char noname_bits[] = {\n");
  p = buf; b >>= 3; putc(' ',uitf);
  for(i=1;i<b*h;i++) { j = *p++; fprintf(uitf,"0x%02x,",(0Xff&spiegel(j)));
  	if(i%15==0) fprintf(uitf,"\n ");}
  j = *p++; fprintf(uitf,"0x%02x};\n",spiegel(j));
}
