!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!> Initializes s2n package variables, scales etc
!<-------------------------------------------------------------
      subroutine s2n_init()
      implicit none!
      include 's2n_declare.h'
      real*8 gf_gf,alphaz,alpha0

      pi = 4d0*datan(1d0)
      sr2 = dsqrt(2d0)
      i_ = dcmplx(0d0,1d0)
      cfl = 1d0
      cfq = 3d0

      if (ichep.eq.1) then
         e   = 0.31345d0
         alphas = 0.1172d0
         stw = 0.48076d0
         mz  = 91.1876d0
         wz  = 2.43631d0
         ww  = 2.02798d0
         mmo = 0.10566d0
         mta = 1.77699d0
         mch = 1.65d0
         mst = 0.177d0
         mtp = 174.3d0
         wtp = 1.54688d0
         mbt = 4.85d0
         mh  = 115d0
         wh  = 0.0061744d0
         stw2 = stw**2
         ctw2 = 1d0-stw2
         ctw  = dsqrt(ctw2)
         mw  = mz*ctw
         alpha = e**2/4d0/pi
         alphai = 1d0/alpha
      endif

      qf( 1) =  0d0
      qf( 2) = -1d0
      qf( 3) =  0d0
      qf( 4) = -1d0
      qf( 5) =  0d0
      qf( 6) = -1d0
      qf( 7) =  2d0/3d0
      qf( 8) = -1d0/3d0
      qf( 9) =  2d0/3d0
      qf(10) = -1d0/3d0
      qf(11) =  2d0/3d0
      qf(12) = -1d0/3d0

      i3f( 1) =  .5d0
      i3f( 2) = -.5d0
      i3f( 3) =  .5d0
      i3f( 4) = -.5d0
      i3f( 5) =  .5d0
      i3f( 6) = -.5d0
      i3f( 7) =  .5d0
      i3f( 8) = -.5d0
      i3f( 9) =  .5d0
      i3f(10) = -.5d0
      i3f(11) =  .5d0
      i3f(12) = -.5d0

      ram2 = ma**2
      rvm2 = mv**2
      rhm2 = mh**2
      rzm2 = mz**2
      rwm2 = mw**2
      renm2 = men**2
      relm2 = mel**2
      rupm2 = mup**2
      rdnm2 = mdn**2
      rmnm2 = mmn**2
      rmom2 = mmo**2
      rchm2 = mch**2
      rstm2 = mst**2
      rtnm2 = mtn**2
      rtam2 = mta**2
      rtpm2 = mtp**2
      rbtm2 = mbt**2

      ctw2 = rwm2/rzm2
      stw2 = 1d0-ctw2
      ctw4 = ctw2**2
      stw4 = stw2**2
      ctw6 = ctw2**3
      stw6 = stw2**3
      ctw = mw/mz
      stw = sqrt(1d0-ctw2)

      rwz = ctw2
      rhz = rhm2/rzm2
      rhw = rhm2/rwm2
      renh = renm2/rhm2
      relh = relm2/rhm2
      ruph = rupm2/rhm2
      rdnh = rdnm2/rhm2
      rmnh = rmnm2/rhm2
      rmoh = rmom2/rhm2
      rchh = rchm2/rhm2
      rsth = rstm2/rhm2
      rtnh = rtnm2/rhm2
      rtah = rtam2/rhm2
      rtph = rtpm2/rhm2
      rbth = rbtm2/rhm2
      renz = renm2/rzm2
      relz = relm2/rzm2
      rupz = rupm2/rzm2
      rdnz = rdnm2/rzm2
      rmnz = rmnm2/rzm2
      rmoz = rmom2/rzm2
      rchz = rchm2/rzm2
      rstz = rstm2/rzm2
      rtnz = rtnm2/rzm2
      rtaz = rtam2/rzm2
      rtpz = rtpm2/rzm2
      rbtz = rbtm2/rzm2
      renw = renm2/rwm2
      relw = relm2/rwm2
      rupw = rupm2/rwm2
      rdnw = rdnm2/rwm2
      rmnw = rmnm2/rwm2
      rmow = rmom2/rwm2
      rchw = rchm2/rwm2
      rstw = rstm2/rwm2
      rtnw = rtnm2/rwm2
      rtaw = rtam2/rwm2
      rtpw = rtpm2/rwm2
      rbtw = rbtm2/rwm2

      cm2 = dcmplx(0d0, -1d-30)
      vm2 = dcmplx(rvm2,-1d-30)
      hm2 = dcmplx(rhm2,-1d-30)
      zm2 = dcmplx(rzm2,-1d-30)
      wm2 = dcmplx(rwm2,-1d-30)
      enm2 = dcmplx(renm2,-1d-30)
      elm2 = dcmplx(relm2,-1d-30)
      upm2 = dcmplx(rupm2,-1d-30)
      dnm2 = dcmplx(rdnm2,-1d-30)
      mnm2 = dcmplx(rmnm2,-1d-30)
      mom2 = dcmplx(rmom2,-1d-30)
      chm2 = dcmplx(rchm2,-1d-30)
      stm2 = dcmplx(rstm2,-1d-30)
      tnm2 = dcmplx(rtnm2,-1d-30)
      tam2 = dcmplx(rtam2,-1d-30)
      tpm2 = dcmplx(rtpm2,-1d-30)
      btm2 = dcmplx(rbtm2,-1d-30)

      qen = qf(1)
      qel = qf(2)
      qup = qf(7)
      qdn = qf(8)
      qmn = qf(3)
      qmo = qf(4)
      qch = qf(9)
      qst = qf(10)
      qtn = qf(5)
      qta = qf(6)
      qtp = qf(11)
      qbt = qf(12)

      aen = i3f(1)
      ael = i3f(2)
      aup = i3f(7)
      adn = i3f(8)
      amn = i3f(3)
      amo = i3f(4)
      ach = i3f(9)
      ast = i3f(10)
      atn = i3f(5)
      ata = i3f(6)
      atp = i3f(11)
      abt = i3f(12)

      ven = aen-2d0*qen*stw2
      vel = ael-2d0*qel*stw2
      vup = aup-2d0*qup*stw2
      vdn = adn-2d0*qdn*stw2
      vmn = amn-2d0*qmn*stw2
      vmo = amo-2d0*qmo*stw2
      vch = ach-2d0*qch*stw2
      vst = ast-2d0*qst*stw2
      vtn = atn-2d0*qtn*stw2
      vta = ata-2d0*qta*stw2
      vtp = atp-2d0*qtp*stw2
      vbt = abt-2d0*qbt*stw2

      dfen = (ven-aen)/aen
      dfel = (vel-ael)/ael
      dfup = (vup-aup)/aup
      dfdn = (vdn-adn)/adn
      dfmn = (vmn-amn)/amn
      dfmo = (vmo-amo)/amo
      dfch = (vch-ach)/ach
      dfst = (vst-ast)/ast
      dftn = (vtn-atn)/atn
      dfta = (vta-ata)/ata
      dftp = (vtp-atp)/atp
      dfbt = (vbt-abt)/abt

      vpaen = ven+aen
      vmaen = ven-aen
      vpael = vel+ael
      vmael = vel-ael
      vpaup = vup+aup
      vmaup = vup-aup
      vpadn = vdn+adn
      vmadn = vdn-adn
      vpamn = vmn+amn
      vmamn = vmn-amn
      vpamo = vmo+amo
      vmamo = vmo-amo
      vpach = vch+ach
      vmach = vch-ach
      vpast = vst+ast
      vmast = vst-ast
      vpatn = vtn+atn
      vmatn = vtn-atn
      vpata = vta+ata
      vmata = vta-ata
      vpatp = vtp+atp
      vmatp = vtp-atp
      vpabt = vbt+abt
      vmabt = vbt-abt

      gz    = mz*wz
      mz2   = dcmplx(rzm2,-gz)
      mz2c  = dconjg(mz2)
      gw    = mw*ww
      mw2   = dcmplx(rwm2,-gw)
      mw2c  = dconjg(mw2)
      gh    = mh*wh
      mh2   = dcmplx(rhm2,-gh)
      mh2c  = dconjg(mh2)
      gtp   = mtp*wtp
      mtp2  = dcmplx(rtpm2,-gtp)
      mtp2c = dconjg(mtp2)

      gf_gf = gf
      gf = pi/alphai/sqrt(2d0)/stw2/ctw2/rzm2      
      cfscheme = gf/gf_gf
      cfprime = cfscheme
      alpha0 = 1/alphai
      if (gfscheme.eq.0) then
         cfscheme = 1d0
         cfprime = 1d0
         print *, "Alpha (0) scheme"
      elseif (gfscheme.eq.1) then
         gf = gf_gf
         cfprime = 1d0
         print *, "GFermi scheme"
      elseif (gfscheme.eq.2) then
         gf = gf_gf
         alphai = pi/gf/sqrt(2d0)/stw2/ctw2/rzm2
         cfscheme = 1d0
         print *, "GFermi prime scheme"
      elseif (gfscheme.eq.3) then
         gf = gf_gf
         alphai = pi/gf/sqrt(2d0)/stw2/ctw2/rzm2
         cfscheme = 1d0
         cfprime = 1d0
         print *, "GFermi prime-2 scheme"
      elseif (gfscheme.eq.4) then
         alphai  = 1d0/alphaz(alpha0,mz)
         gf = pi/alphai/sqrt(2d0)/stw2/ctw2/rzm2
         cfprime = alpha0*alphai
         print *, 1-cfprime
         cfscheme = 1d0/cfprime
         print *, "Alpha (mz^2) scheme"
      endif
      alpha = 1d0/alphai
      e = sqrt(4d0*pi*alpha)
      g = sqrt(gf/sr2*8d0*rzm2*ctw2)
      gs = sqrt(4d0*pi*alphas)

c$$$      print *, "stw2",stw2
c$$$      print *, "ctw2",ctw2
c$$$      print *, "vel ",2*vel
c$$$      print *, "vup ",2*vup
c$$$      print *, "vdn ",2*vdn
c$$$      stop

      return
      end
