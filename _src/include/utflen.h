int utflen(const char * s)
{
  int cnt=0;
#ifdef UTFLEN_DEBUG
  const char * start=s;
#endif
  while(*s){
    cnt++;
#ifdef UTFLEN_DEBUG
    printf("pos = %d (%d)  '%c' (0x%x)\n",s-start,cnt,*s,(unsigned char)*s);
#endif

    if(! (0x80 &*s)){
      s++;
      continue;
    }
    
    if(! (0x40 &*s)){
#ifdef UTFLEN_DEBUG
      fprintf(stderr,"error in strutf8len in pos = %d (%d) (unexpected center of symbol)\n",s-start,cnt);
#endif
      cnt--;
      s++;
      continue;
    }
    
    if(! (0x20 &*s)){
#ifdef UTFLEN_DEBUG
      s++;
      if(!*s){
	fprintf(stderr,"error in strutf8len in pos = %d (%d) (unexpected end in 2 byte symbol)\n",s-start,cnt);
	break;
      }
      s++;
#else
      s+=2;
#endif
      continue;
    }
    
    if(! (0x10 &*s)){
#ifdef UTFLEN_DEBUG
      s++;
      if(!*s){
	fprintf(stderr,"error in strutf8len in pos = %d (%d) (unexpected end in 3 byte symbol (1))\n",s-start,cnt);
	break;
      }
      s++;
      if(!*s){
	fprintf(stderr,"error in strutf8len in pos = %d (%d) (unexpected end in 3 byte symbol (2))\n",s-start,cnt);
	break;
      }
      s++;
#else
      s+=3;
#endif
      continue;
    }
    
    if(! 0x08 &*s){
#ifdef UTFLEN_DEBUG
      s++;
      if(!*s){
	fprintf(stderr,"error in strutf8len in pos = %d (%d) (unexpected end in 4 byte symbol (1))\n",s-start,cnt);
	break;
      }
      s++;
      if(!*s){
	fprintf(stderr,"error in strutf8len in pos = %d (%d) (unexpected end in 4 byte symbol (2))\n",s-start,cnt);
	break;
      }
      s++;
      if(!*s){
	fprintf(stderr,"error in strutf8len in pos = %d (%d) (unexpected end in 4 byte symbol (3))\n",s-start,cnt);
	break;
      }
      s++;
#else
      s+=4;
#endif
      continue;
    }
    
    if(! (0x04 &*s)){
#ifdef UTFLEN_DEBUG
      s++;
      if(!*s){
	fprintf(stderr,"error in strutf8len in pos = %d (%d) (unexpected end in 4 byte symbol (1))\n",s-start,cnt);
	break;
      }
      s++;
      if(!*s){
	fprintf(stderr,"error in strutf8len in pos = %d (%d) (unexpected end in 4 byte symbol (2))\n",s-start,cnt);
	break;
      }
      s++;
      if(!*s){
	fprintf(stderr,"error in strutf8len in pos = %d (%d) (unexpected end in 4 byte symbol (3))\n",s-start,cnt);
	break;
      }
      s++;
#else
      s+=4;
#endif
      continue;
    }
    s++;
#ifdef UTFLEN_DEBUG
    fprintf(stderr,"error in strutf8len in pos = %d (%d) (very long character)",s-start,cnt);
#endif
  }
  return cnt;
}
