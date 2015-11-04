module EW_BinByBin_def
  def self.extended(base) 
    base.add {
      #
      #  Electroweak parameters
      #

      #... Prepared for inclusive Z,W tasks

      #&EWPars
      #   Choice of EW scheme: 0 - alpha, 1 - G_mu, 2 - G_mu^pr
      @gfscheme= 1

      #   scales. -1e0 sets to invariant mass of products (sqspr for hard)
      @fscale= -1e0
      @rscale= -1e0
      @ome= 1e-4

      #     1/137.035999679e0
      @alpha= 7.297353e-3
      @gf= 1.16637e-5
      @alphas= 0.1176e0
      @conhc= 0.389379323e9

      #   boson masses
      @mw= 80.425e0
      @mz= 91.1876e0
      @mh= 115e0
      @ma= 0e0
      @mv= 91.1876e0

      #   widths
      @wz= 2.4952e0
      @ww= 2.124e0
      @wh= 1e-3
      @wtp= 2e0

      #   CKM
      @vud= 0.975e0
      @vus= 0.222e0
      @vub= 0e0
      @vcd= 0.222e0
      @vcs= 0.975e0
      @vcb= 0e0

      #  *** fermion masses

      #   Lepton masses
      @men= 1e-10
      @mel= 0.510998928e-3
      @mmn= 1e-10
      @mmo= 0.105658369e0 #0.1056583715e0
      @mtn= 1e-10
      @mta= 1.77682e0

      # Quark masses:
      # masses of five light quarks taken from Dittmaier&Huber 0911.2329v2
      @mdn= 0.066e0
      @mup= 0.066e0
      @mst= 0.150e0
      @mch= 1.2e0  
      @mbt= 4.3e0  
      @mtp= 178e0   

      # rmf1 fermion mass array, for technical use
      @rmf1 = [ 0e0, 0e0, 0e0, 0e0, 0e0, 0e0, 0e0, 0e0, 0e0, 0e0, 0e0, 0e0 ]
    }
  end
end
