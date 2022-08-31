       Dcl-F FirstPrtf Printer TemPlate;

       Dcl-Pi *n;
         PrinterF        LikeFile(FirstPrtf);
         OverFlow        Ind;
       End-Pi;

       Dcl-Ds PriviousLoad   LikeRec(PrinterF.Rcd002:*OutPut);
       Dcl-Ds HeaderRcd      LikeRec(PrinterF.Rcd003:*OutPut);

       Dcl-Ds Calculation    Qualified;
         ODYEAR        Packed(4:0);
         ODPRICE       Packed(7:2);
         ODQTY         Packed(5);
         ODTOT         Packed(9:2);
       End-Ds;

       Exec Sql
         Declare C1 Cursor For
           SELECT ODYEAR, SUM(ODPRICE),SUM(ODQTY),SUM(ODTOT)
             FROM DETORD1 GROUP BY ODYEAR;
       Exec Sql
         Open C1;

       Write PrinterF.Rcd003 HeaderRcd;
       Exec Sql
         Fetch C1 into :Calculation;

       Dow SqlCode = *Zero;
         If OverFlow = *On;
           Write PrinterF.Rcd003 HeaderRcd;
           OverFlow = *Off;
         EndIf;

         Eval-Corr PriviousLoad = Calculation;
         Write PrinterF.Rcd002 PriviousLoad;

         Exec Sql
           Fetch C1 into :Calculation;
       EndDo;

       *InLr = *On;
