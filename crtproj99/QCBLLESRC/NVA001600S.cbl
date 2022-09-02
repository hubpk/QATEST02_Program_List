       IDENTIFICATION DIVISION.
       PROGRAM-ID. NVA001600S.

      **************************************************************************
      *  VFS-UK application. IRN-7375                                          *
      *                                                                        *
      *  Author: PC00066 2017-05-24 BZ61579                                    *
      *                                                                        *
      *  Change:                                                               *
      *  IPNxxxx yyyy/mm/dd BZxxx Comment                                      *
      **************************************************************************

       ENVIRONMENT DIVISION.
        CONFIGURATION SECTION.
         SOURCE-COMPUTER.      IBM-AS400.
         OBJECT-COMPUTER.      IBM-AS400.

        INPUT-OUTPUT SECTION.
         FILE-CONTROL.
      * QTEMP/UNINVOICED created by previous query
           SELECT UNIN   ASSIGN        TO DATABASE-UNINVOICED
                         ORGANIZATION  IS SEQUENTIAL
                         ACCESS        IS SEQUENTIAL
                         FILE STATUS   IS ST-UNIN.

      * CDLIV/UNINVOICEO output file w/ AOL, w/o InvBCV
           SELECT UNOUT  ASSIGN        TO DATABASE-UNINVOICEO
                         ORGANIZATION  IS SEQUENTIAL
                         ACCESS        IS SEQUENTIAL
                         FILE STATUS   IS ST-UNOUT.

      * AOL codes added from here
           SELECT PFORD  ASSIGN        TO DATABASE-PFORDPACL1
                         ORGANIZATION  IS INDEXED
                         ACCESS        IS DYNAMIC
                         RECORD KEY    IS EXTERNALLY-DESCRIBED-KEY
                         FILE STATUS   IS ST-PFORD.

       DATA DIVISION.
        FILE SECTION.
         FD UNIN.
          01 UNINREC.
            COPY DDS-ALL-FORMATS OF UNINVOICED.

         FD UNOUT.
          01 UNOUTREC.
            COPY DDS-ALL-FORMATS OF UNINVOICEO.

         FD PFORD.
          01 PFORDREC.
            COPY DDS-ALL-FORMATS OF PFORDPACL1.

       WORKING-STORAGE SECTION.
        01  ST-UNIN     PIC X(2).
        01  ST-UNOUT    PIC X(2).
        01  ST-PFORD    PIC X(2).
        01  O-UNIN      PIC 9 VALUE ZERO.
        01  O-UNOUT     PIC 9 VALUE ZERO.
        01  O-PFORD     PIC 9 VALUE ZERO.

        01 W-COUNT      PIC 9(6)  VALUE ZEROES.
        01 W-EOF        PIC 9.
        01 W-FIRSTRUN   PIC 9.

      ***************************************************************
       PROCEDURE DIVISION.
       MAIN SECTION.
       MAIN-B.
           OPEN INPUT UNIN.
           IF ST-UNIN NOT = "00"
             GO TO MAIN-E
           END-IF.
           MOVE 1 TO O-UNIN.

           OPEN INPUT PFORD.
           IF ST-PFORD NOT = "00"
             GO TO MAIN-E
           END-IF.
           MOVE 1 TO O-PFORD.

           OPEN OUTPUT UNOUT.
           IF ST-UNOUT NOT = "00"
             GO TO MAIN-E
           END-IF.
           MOVE 1 TO O-UNOUT.

           PERFORM PROCESS-DATA.

       MAIN-E.
           GO TO PGM-END.

      ******************************************************************
       PROCESS-DATA SECTION.
       PROCESS-DATA-B.
      * Process whole input file
           MOVE 0 TO W-EOF.
           PERFORM UNTIL W-EOF = 1
             READ UNIN NEXT
               AT END
                 MOVE 1 TO W-EOF
               NOT AT END
      * Fill corresponding fields to output
                 INITIALIZE UNINVOICEO
                 MOVE CORR UNINVOICED TO UNINVOICEO
      * and add AOL field
                 PERFORM ADD-AOL
                 WRITE UNOUTREC
                 END-WRITE
             END-READ
           END-PERFORM.

       PROCESS-DATA-E.
           EXIT.

      ******************************************************************
       ADD-AOL SECTION.
       ADD-AOL-B.
           MOVE SPACES TO AOL OF UNOUT.
           MOVE 1 TO W-FIRSTRUN.

      * There may by multiple AOL codes for one InvBCV
           MOVE J6INVBCV OF UNIN TO HXIOINVBCV OF PFORD.
           MOVE SPACES           TO HXIOPACCDE OF PFORD.

           START PFORD KEY >= EXTERNALLY-DESCRIBED-KEY
             INVALID KEY
               GO TO ADD-AOL-E
           END-START.

       READ-PFORD-NEXT.
           READ PFORD NEXT
             AT END
               GO TO ADD-AOL-E
             NOT AT END
      * Check correct InvBCV
               IF HXIOINVBCV OF PFORD = J6INVBCV OF UNIN
      * AOL code must be filled and not in CANCELED state
                 IF  HXIOPACCDE OF PFORD NOT = SPACES
                 AND HXICPACSTS OF PFORD NOT = "C"
                   IF W-FIRSTRUN = 1
                     MOVE HXIOPACCDE OF PFORD TO AOL OF UNOUT
                     MOVE 0 TO W-FIRSTRUN
                   ELSE
      * More codes are stringed to AOL field separated by space
                     STRING FUNCTION TRIM(AOL OF UNOUT)
                              DELIMITED BY SIZE
                            " "                 DELIMITED BY SIZE
                            FUNCTION TRIM(HXIOPACCDE OF PFORD)
                              DELIMITED BY SIZE
                       INTO AOL OF UNOUT
                     END-STRING
                   END-IF
                 END-IF
                 GO TO READ-PFORD-NEXT
               ELSE
                 GO TO ADD-AOL-E
               END-IF
           END-READ.

       ADD-AOL-E.
           EXIT.

      ******************************************************************
       PGM-END SECTION.
       PGM-END-B.
           IF O-UNIN = 1
             CLOSE UNIN
             MOVE 0 TO O-UNIN
           END-IF.

           IF O-UNOUT = 1
             CLOSE UNOUT
             MOVE 0 TO O-UNOUT
           END-IF.

           IF O-PFORD = 1
             CLOSE PFORD
             MOVE 0 TO O-PFORD
           END-IF.

           GOBACK.

