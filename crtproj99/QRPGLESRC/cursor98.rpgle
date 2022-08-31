       ctl-opt NOMAIN;
       dcl-f QaPf99 Disk Rename(QaPF99:QaPf98) Template Block(*Yes);
       Dcl-Proc Cursor98 Export;
          Dcl-pi *n Char(10);
            Var1 Packed(5:2);
            Var2 Packed(5:2);
            Ds99 LikeFile(QaPf99);
          End-Pi;

          Dcl-Ds Ds98 LikeRec(QaPf98);
          Dcl-S Rst Char(10);
          Read Ds99 Ds98;
          rst = %char(ds98.parm3);

          Return rst;
       End-proc;
