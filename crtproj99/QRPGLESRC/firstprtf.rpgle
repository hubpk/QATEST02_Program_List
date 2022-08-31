       Dcl-F FirstPrtf Printer OflInd(Overflow);
       Dcl-F DetOrd1 Disk Usage(*Input);

       Dcl-Pr SecPrtf    ExtPgm('SECPRTF');
         PrinterF        LikeFile(FirstPrtf);
         OverFlow        Ind;
       End-Pr;

          Write Rcd001;
          Write Rcd003;
          Read DetOrd1;
          Dow Not%Eof(DetOrd1);
            If OverFlow = *On;
            //Write Rcd001;
              Write Rcd003;
              OverFlow = *Off;
            EndIf;
            Write Rcd002;
            Read DetOrd1;
          EndDo;

          SecPrtF(FirstPrtF:Overflow);
          *InLr = *On;
