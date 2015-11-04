      integer maxKinCuts
      parameter (maxKinCuts=50)
      integer nkincuts, kin_cuts_pad
      character*32 cutName(maxKinCuts)
      integer cutFlag(maxKinCuts)
      double precision cutLow(maxKinCuts), cutUp(maxKinCuts)
      common/nml_cuts/cutName, cutFlag, cutLow, cutUp

      double precision min_m34, max_m34, min_y34, max_y34, 
     $  min_pt3, max_pt3, min_pt4, max_pt4,
     $  min_eta3, max_eta3, min_eta4, max_eta4,
     $  min_mtr, max_mtr,
     $  min_m345, max_m345, min_y345, max_y345,
     $  min_dR, max_dR

      common/kin_cuts/ min_m34, max_m34, min_y34, max_y34, 
     $  min_pt3, max_pt3, min_pt4, max_pt4,
     $  min_eta3, max_eta3, min_eta4, max_eta4,
     $  min_mtr, max_mtr,
     $  min_m345, max_m345, min_y345, max_y345,
     $  min_dR, max_dR, nkincuts, kin_cuts_pad


      double precision xmin, xmax, q2min, q2max
      common/pdf_cuts/xmin, xmax, q2min, q2max
