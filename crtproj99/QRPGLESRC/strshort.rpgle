        Dcl-Pi *n;
          First_Var char(9);
        End-Pi;
        Dcl-S Var1     Char(5);
        Dcl-S ArrStr   Char(1)      Dim(9);
        Dcl-S ArrSrt   Char(3)      Dim(9);
        Dcl-S inx      Packed(2:0);
        Dcl-S inx1     Packed(2:0) Inz(1);
        Dcl-S Alpha_C  Char(26) Inz('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
        Dcl-S Alpha_S  Char(26) Inz('abcdefghijklmnopqrstuvwxyz');
      *
        For Inx =1 to %Len(First_Var);
      *
          ArrStr(Inx) = %SubSt(First_Var:Inx:1);
          If %SubSt(First_Var:Inx:1) <> *Blank;
      *
            If %Scan(ArrStr(Inx):Alpha_C) > *Zero;
              ArrSrt(Inx1) = %Char(%Scan(ArrStr(Inx):Alpha_C)) + ArrStr(Inx);
            ElseIf %Scan(ArrStr(Inx):Alpha_S) > *Zero;
              ArrSrt(Inx1) = %Char(%Scan(ArrStr(Inx):Alpha_S)) + ArrStr(Inx);
            EndIf;
      *
          EndIf;
          Inx1 +=1;

        EndFor;
      *
        SortA ArrStr;
        Clear First_Var;
        For Inx =1 to %Len(First_Var);
          If ArrStr(Inx) <> *Blank;
            First_Var   = %Trim(First_Var) + ArrStr(Inx);
          EndIf;
        EndFor;
      *
        Dsply First_Var;
        *Inlr = *On;
