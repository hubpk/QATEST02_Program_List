     **.........................................................................
     ** Function   : Rtn Calc 'NOTE NUMBER'    Execute user source
     ** System     : Finance - batch accounting
     ** Programmer : Maurice Mead
     ** Date       : 19/05/97
     ** Request    : R95141
     **.........................................................................
       WORKING-STORAGE SECTION.
     **
      * Rtn Calc 'NOTE NUMBER'    Execute user source
      *.Start.of.user.source...........................................
       01  WS-ACFNTENBRS-STR.
           05  WS-ACFNTENBRS-DATE      PIC 9(8).
           05  WS-ACFNTENBRS-FIELDS    REDEFINES WS-ACFNTENBRS-DATE.
               10  FILLER              PIC 9(5).
               10  WS-ACFNTENBRS-M     PIC 9.
               10  WS-ACFNTENBRS-DD    PIC 9(2).
      *.End.of.user.source.............................................
     **
       PROCEDURE DIVISION.
     **
      *.Start.of.user.source...........................................
           MOVE USR-PARM-I-ACIFINVD
             TO WS-ACFNTENBRS-DATE     OF WS-ACFNTENBRS-STR
           COMPUTE USR-PARM-O-TCNOTNBR
             = (WS-ACFNTENBRS-DD       OF WS-ACFNTENBRS-STR  * 10)
              + WS-ACFNTENBRS-M
      *.End.of.user.source.............................................
