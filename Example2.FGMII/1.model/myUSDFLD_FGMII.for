C ======================================================================
C ABAQUS user subroutine for Functionally Graded Materials (FGMs)
C Field fitting equation:
C     F(X) = B4*X^4 + B3*X^3 + B2*X^2 + B1*X^1 + B0
C Units:
C     Position X (mm)
C     FIELD(1) = Young's modulus E (MPa)
C     FIELD(2) = Failure stress Sf (MPa)
C ======================================================================
      SUBROUTINE USDFLD(FIELD,STATEV,PNEWDT,DIRECT,T,CELENT,
     1 TIME,DTIME,CMNAME,ORNAME,NFIELD,NSTATV,NOEL,NPT,LAYER,
     2 KSPT,KSTEP,KINC,NDI,NSHR,COORD,JMAC,JMATYP,MATLAYO,LACCFLA)
C
      INCLUDE 'ABA_PARAM.INC'
C
      CHARACTER*80 CMNAME,ORNAME
      CHARACTER*3  FLGRAY(15)
      DIMENSION FIELD(NFIELD),STATEV(NSTATV),DIRECT(3,3),
     1 T(3,3),TIME(2)
      DIMENSION ARRAY(15),JARRAY(15),JMAC(*),JMATYP(*),COORD(*)
C
      X=COORD(l)
      Y=COORD(2)
C
      FIELD(1) = - 9.16659619630745E-7*X**4 +
     1 0.000410881971401150*X**3 - 0.0498753879242135*X**2 -
     2 0.185636233064349*X + 437.202232184739
C       FIELD(2) = - 3.35004125427684E-8*X**4 +
C      1 1.39263499165308E-5*X**3 - 0.00177635797332515*X**2 +
C      2 0.0561449984496036*X + 10.2799900585760
C
C     If error, write comment to .DAT file:
      IF(JRCD.NE.0)THEN
      WRITE(6,*) 'REQUEST ERROR IN USDFLD FOR ELEMENT NUMBER ',
     1    NOEL,'INTEGRATION POINT NUMBER ',NPT
      ENDIF
C
      RETURN
      END
C
C ======================================================================
C UFIELD subroutine is only necessary when computing J-integral or SIFs,
C since the elastic properties in the crack tip must be defined.
C
C Add following keywords after MATERIALS module:
C     1|*INITIAL CONDITIONS, TYPE=FIELD, VARIABLE=1
C     2|All, 100
C where All is a node set including all nodes for FGMs, 100 is the initial value
C
C Then, add following keywords in STEP module:
C     1|*FIELD, USER
C     2|All,
C ======================================================================
      SUBROUTINE UFIELD(FIELD,KFIELD,NSECPT,KSTEP,KINC,TIME,NODE,
     1 COORDS,TEMP,DTEMP,NFIELD)
C
      INCLUDE 'ABA_PARAM.INC'
C
      DIMENSION FIELD(NSECPT,NFIELD), TIME(2), COORDS(3),
     1 TEMP(NSECPT), DTEMP(NSECPT)
C
      X=COORDS(l)
      Y=COORDS(2)
C
      FIELD(1,1) = - 9.16659619630745E-7*X**4 +
     1 0.000410881971401150*X**3 - 0.0498753879242135*X**2 -
     2 0.185636233064349*X + 437.202232184739
C
      RETURN
      END