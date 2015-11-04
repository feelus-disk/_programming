require "lib/config_gen"
# Class for generation of MCSANC *ewparam.cfg* file using *ewparam.cfg.erb* template. 
# It inherits methods from +Config_gen+ class.
# By default the standard *ewparam.cfg* is generated, use #add method to override it.
# One can also wrap config in Module and later extend config with it. 
# See *bins.rb* example and 
# *ewparam.cfg_all.rb* for details.
#
# All config variables have corresponding get/set methods, for example
#   config.fscale=-1 # set fscale
#   puts config.alpha # print alpha
class MCSANCewparam < Config_gen
  
  attr_accessor :gfscheme, :fscale, :rscale, :ome, :alpha, :gf, :alphas, :conhc, :mw, \
      :mz, :mh, :ma, :mv, :wz, :ww, :wh, :wtp, :vud, :vus, :vub, :vcd, :vcs, :vcb, :men, \
      :mel, :mmn, :mmo, :mtn, :mta, :mdn, :mup, :mst, :mch, :mbt, :mtp, :rmf1
# Initialize new ewparam config, takes block as argument and pass it to #add.
#   ewparam=MCSANCewparam.new
#   ewparam=MCSANCewparam.new {
#     @gfscheme=0 #override default gfscheme
#   }

# comment header in config
#  ewparam=MCSANCewparam.new
#  ewparam.comment= "This is the head of ewparam.cfg, 
#  it can be used to describe your job"
  attr_accessor :comment
  def initialize(&blk)
    #--------------------------- Config ---------------------------
    #
    #  Electroweak parameters
    #

    #... Taken from PDG-2012

    #EWPars
    #   Choice of EW scheme: 0 - alpha(0), 2 - G_mu, 4 - alpha(mz)
    gfscheme		= 2

    #   scales. -1e0 sets to invariant mass of products (sqspr for hard)
    fscale                = -1e0
    rscale                = -1e0
    ome                   = 1e-5

    #   1/137.035999679e0 = 7.29735253759924464E-003
    alpha 		= 7.29735253759924464e-3
    gf			= 1.16637e-5
    alphas                = 0.1176e0
    conhc 		= 0.389379323e9

    #   boson masses
    mw			= 80.399e0
    mz			= 91.1876e0
    mh			= 120e0
    ma                    = 0e0
    mv                    = 91.1876e0

    #   widths
    wz			= 2.4952e0
    ww			= 2.085e0
    wh			= 1e-3
    wtp			= 2e0

    #   CKM
    vud			= 0.9738e0
    vus			= 0.2272e0
    vub			= 0e0
    vcd			= 0.2271e0
    vcs			= 0.9730e0
    vcb			= 0e0

    #  fermion masses

    #  Lepton masses
    men			= 1e-10
    mel			= 0.510998910e-3
    mmn			= 1e-10
    mmo			= 0.105658367e0
    mtn			= 1e-10
    mta			= 1.77682e0

    #  Quark masses:
    #  masses of four light quarks are taken from 0911.2329v2
    #  all other parameters are from PDG 2011 (on 16/05/2012)
    mdn			= 0.066e0
    mup			= 0.066e0
    mst			= 0.150e0
    mch			= 1.2e0   
    mbt			= 4.67e0  
    mtp			= 172.9e0   

    # rmf1 fermion mass array, for technical use
    rmf1 = [0e0, 0e0, 0e0, 0e0, 0e0, 0e0, 0e0, 0e0, 0e0, 0e0, 0e0, 0e0]

#   ---------------------------------------------------------------------

    @gfscheme = gfscheme
    @fscale = fscale
    @rscale = rscale
    @ome = ome
    @alpha = alpha
    @gf = gf
    @alphas = alphas
    @conhc = conhc
    @mw = mw
    @mz = mz
    @mh = mh
    @ma = ma
    @mv = mv
    @wz = wz
    @ww = ww
    @wh = wh
    @wtp = wtp
    @vud = vud
    @vus = vus
    @vub = vub
    @vcd = vcd
    @vcs = vcs
    @vcb = vcb
    @men = men
    @mel = mel
    @mmn = mmn
    @mmo = mmo
    @mtn = mtn
    @mta = mta
    @mdn = mdn
    @mup = mup
    @mst = mst
    @mch = mch
    @mbt = mbt
    @mtp = mtp
    @rmf1 = rmf1
    @comment=""
    super
    @template="#{File::dirname __FILE__}/ewparam.cfg.erb"
    @filename="ewparam.cfg"
  end
end
