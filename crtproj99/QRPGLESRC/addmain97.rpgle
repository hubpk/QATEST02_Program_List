        Dcl-F QaPf99 Disk Usage(*Input) ReName(QaPf99:QaPf98) Block(*Yes);

        dcl-pi *n;
          dcl-parm  p_fldx Char(10);
        End-pi;

        //dcl-pr Cursor99 Char(10);
        dcl-pr Cursor97 ExtPgm('CURSOR97');
          dcl-parm  Var1   packed(5:2);
          dcl-parm  Var2   packed(5:2);
          dcl-parm  Var3   LikeFile(QaPf98);
        End-Pr;

        dcl-s Var1   packed(5:2);
        dcl-s Var2   packed(5:2);
        dcl-ds Var3   LikeRec(QaPf98);
          var1   = .01;
          var2   = .02;
          var3   = *blank;
          Cursor97(var1:var2:QAPF99);
        *inlr = *on;
