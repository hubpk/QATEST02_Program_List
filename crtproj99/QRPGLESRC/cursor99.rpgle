       ctl-opt NOMAIN;
       dcl-f QaPf99 Disk Usage(*Input) Keyed Rename(QaPF99:QaPf98)
             Template Block(*Yes);
        dcl-proc cursor99 export;
          dcl-pi *n char(10);
            Var1 Packed(5:2);
            Var2 Packed(5:2);
            Ds99 LikeFile(QaPf99);
          //Ds98 LikeRec(QaPf98);
          End-Pi;
          Dcl-Ds Ds98 LikeRec(QaPf98);
          Chain (Var1:Var2) Ds99 Ds98;
          If %Found(Ds99);
           Read Ds99 Ds98;
           return %char(Ds98.parm3);
          EndIf;
        End-proc;
