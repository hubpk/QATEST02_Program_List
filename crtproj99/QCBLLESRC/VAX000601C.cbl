       IDENTIFICATION DIVISION.
        PROGRAM-ID.   VAX000601C.

      *********************************************************************
      *  VOR application. IRN-71740                                       *
      *    Adding line separators to DLL Extract file of VOR              *
      *                                                                   *
      *  Author: Michal Pelc (PC00439), Tàsk.Force, 11/2021               *
      *                                                                   *
      *  Change:                                                          *
      *                                                                   *
      *********************************************************************

       ENVIRONMENT DIVISION.
        CONFIGURATION SECTION.
         SOURCE-COMPUTER.      IBM-AS400.
         OBJECT-COMPUTER.      IBM-AS400.
         SPECIAL-NAMES.        DECIMAL-POINT IS COMMA.

        INPUT-OUTPUT SECTION.
         FILE-CONTROL.
           SELECT VOR01DLL ASSIGN        TO DATABASE-VOR01DLLG
                           ORGANIZATION  IS SEQUENTIAL
                           ACCESS        IS SEQUENTIAL
                           FILE STATUS   IS ST-VOR01DLL.

           SELECT VOR02DLL ASSIGN        TO DATABASE-VOR02DLLG
                           ORGANIZATION  IS SEQUENTIAL
                           ACCESS        IS SEQUENTIAL
                           FILE STATUS   IS ST-VOR02DLL.

       DATA DIVISION.
        FILE SECTION.
         FD VOR01DLL.
          01 VOR01DLLREC.
            COPY DDS-ALL-FORMATS OF VOR01DLLG.

         FD VOR02DLL.
          01 VOR02DLLREC.
            COPY DDS-ALL-FORMATS OF VOR02DLLG.

       WORKING-STORAGE SECTION.
        01  ST-VOR01DLL  PIC X(2).
        01  ST-VOR02DLL  PIC X(2).
        01  O-VOR01DLL   PIC 9 VALUE ZERO.
        01  O-VOR02DLL   PIC 9 VALUE ZERO.

        01 W-EOF        PIC 9.

       LINKAGE SECTION.

      ***************************************************************
       PROCEDURE DIVISION.
      * Main section of program
       MAIN SECTION.
       MAIN-B.

           PERFORM OPEN-FILES-B THRU OPEN-FILES-E.

      * VOR01DLLG
           MOVE 0 TO W-EOF.

           PERFORM UNTIL W-EOF = 1
             READ VOR01DLL NEXT
               AT END
                 MOVE 1 TO W-EOF
               NOT AT END
                 CONTINUE
             END-READ

             MOVE X"0D0A" TO VOR01DLLREC(149:2)

             REWRITE VOR01DLLREC

             END-REWRITE


           END-PERFORM.

      * Then Vehicles
           MOVE 0 TO W-EOF.

           PERFORM UNTIL W-EOF = 1
             READ VOR02DLL NEXT
               AT END
                 MOVE 1 TO W-EOF
               NOT AT END
                 CONTINUE
             END-READ

             MOVE X"0D0A" TO VOR02DLLREC(79:2)

             REWRITE VOR02DLLREC

             END-REWRITE

           END-PERFORM.

       MAIN-E.
           PERFORM PGM-END.

      ******************************************************************
      * Opening files
       OPEN-FILES SECTION.
       OPEN-FILES-B.
           OPEN I-O VOR01DLL.
           IF ST-VOR01DLL NOT = "00"
             PERFORM PGM-END
           END-IF.
           MOVE 1 TO O-VOR01DLL.

           OPEN I-O VOR02DLL.
           IF ST-VOR02DLL NOT = "00"
             PERFORM PGM-END
           END-IF.
           MOVE 1 TO O-VOR02DLL.

       OPEN-FILES-E.
           EXIT.

      ******************************************************************
      * Close files and return
       PGM-END SECTION.
       PGM-END-B.
           IF O-VOR01DLL = 1
             CLOSE VOR01DLL
           END-IF.

           IF O-VOR02DLL = 1
             CLOSE VOR02DLL
           END-IF.

           GOBACK.

