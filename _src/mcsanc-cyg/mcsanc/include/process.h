      integer processId, beams(2), iflew(6), iflqcd, PDFMember, imsb
      integer irecomb
      double precision sqs0
      character*256 run_tag, PDFSet

      common/process/ sqs0, processId, irecomb, beams, 
     $  iflew, iflqcd, imsb, PDFMember, PDFSet, run_tag

      integer npid
      data npid/16/
      integer pid_array(16)
      data pid_array/-106,-105,-104,-103,-102,-101,1,2,3,4,101,102,103,104,105,106/
      character*128 pnames(16)
      data pnames/'f1(p1) + f2(p2) --> tbar(p3) + q(p4) (t-channel)',
     $            'f1(p1) + f2(p2) --> tbar(p3) + b(p4) (s-channel)',
     $            'f1(p1) + f2(p2) --> W-(p3) + H(p4)',
     $            'f1(p1) + f2(p2) --> tau-(p3) + nubar_tau(p4)',
     $            'f1(p1) + f2(p2) --> mu-(p3) + nubar_mu(p4)',
     $            'f1(p1) + f2(p2) --> e-(p3) + nubar_e(p4)',
     $            'f1(p1) + f2(p2) --> e+(p3) + e-(p4)',
     $            'f1(p1) + f2(p2) --> mu+(p3) + mu-(p4)',
     $            'f1(p1) + f2(p2) --> tau+(p3) + tau-(p4)',
     $            'f1(p1) + f2(p2) --> Z0(p3) + H(p4)',
     $            'f1(p1) + f2(p2) --> e+(p3) + nu_e(p4)',
     $            'f1(p1) + f2(p2) --> mu+(p3) + nu_mu(p4)',
     $            'f1(p1) + f2(p2) --> tau+(p3) + nu_tau(p4)',
     $            'f1(p1) + f2(p2) --> W+(p3) + H(p4)',
     $            'f1(p1) + f2(p2) --> t(p3) + bbar(p4) (s-channel)',
     $            'f1(p1) + f2(p2) --> t(p3) + q(p4) (t-channel)'/
