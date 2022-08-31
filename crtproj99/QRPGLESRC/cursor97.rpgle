       //ctl-opt NOMAIN;
       dcl-f QaPf99 Disk Usage(*OutPut) Qualified Block(*Yes);
          Dcl-pi *n;
            Var1 Packed(5:2);
            Var2 Packed(5:2);
            Ds99 LikeFile(QaPf99);
          End-Pi;

          Dcl-Ds Ds98 LikeRec(QaPf99.QaPf99);
          Dcl-S Rst Char(10);

          Ds98.parm1 = 1.99;
          Ds98.parm2 = 2.99;
          Ds98.parm3 = 3.99;
          Write QaPf99.QaPf99 Ds98;
          *Inlr = *On;
       //End-proc;
