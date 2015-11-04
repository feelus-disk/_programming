/*
	cache.c
		caching of tensor coefficients in
		dynamically allocated memory
		this file is part of LoopTools
		last modified 14 Dec 06 th
*/


#include <stdlib.h>
#include <stdio.h>
#include <string.h>


typedef struct { double re, im; } Complex;

static int SignBit(const int i)
{
  return (unsigned)i >> (8*sizeof(i) - 1);
}

static long PtrDiff(const void *a, const void *b)
{
  return (char *)a - (char *)b;
}


long cachelookup_(const double *para, double *base,
  void (*calc)(const double *, Complex *, const long *),
  const long *npara, const long *nval)
{
  typedef struct node {
    struct node *next[2], *succ;
    long serial;
    double para[*npara];
    Complex val[*nval];
  } Node;

#define base_valid (long *)&base[0]
#define base_last (Node ***)&base[1]
#define base_first (Node **)&base[2]

  const long valid = *base_valid;
  Node **last = *base_last;
  Node **next = base_first;
  Node *node = NULL;

  if( last == NULL ) last = next;

  while( (node = *next) && node->serial < valid ) {
    const int i = memcmp(para, node->para, sizeof(node->para));
    if( i == 0 ) goto found;
    next = &node->next[SignBit(i)];
  }

  node = *last;

  if( node == NULL ) {
	/* MUST have extra Complex for alignment so that node
	   can be reached with an integer index into base */
    node = malloc(sizeof(Node) + sizeof(Complex));
    if( node == NULL ) {
      fputs("Out of memory for LoopTools cache.\n", stderr);
      exit(1);
    }
    node = (Node *)((char *)node +
      (PtrDiff(base, node->val) & (sizeof(Complex) - 1)));
    node->succ = NULL;
    node->serial = valid;
    *last = node;
  }

  *next = node;
  *base_last = &node->succ;
  *base_valid = valid + 1;

  node->next[0] = NULL;
  node->next[1] = NULL;

  memcpy(node->para, para, sizeof(node->para));
  static const long one = 1;
  calc(node->para, node->val, &one);

found:
  return PtrDiff(node->val, base)/sizeof(Complex);
}

