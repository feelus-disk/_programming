      integer comp_id, comp_pad
      character*32 comp_name
      common/comp/ comp_id, comp_pad, comp_name

      integer iewborn, iewsoft, iewvirt, iewhard, iewbrdq, iewbogg
      integer iqcdbrdg, iqcdinvg, iqcdbrd2
      parameter (iewborn = 0, iewsoft = 1, iewvirt = 2, 
     &iewhard = 3, iewbrdq = 4, iqcdbrdg=5, iqcdinvg=6, iqcdbrd2=7, iewbogg=8 )
