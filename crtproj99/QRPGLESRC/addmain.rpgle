        Dcl-F QaPf99 Disk Usage(*Input) ReName(QaPf99:QaPf98) Block(*Yes);

        dcl-pi *n;
          dcl-parm  p_fldx Char(10);
        End-pi;

        //dcl-pr Cursor99 Char(10);
        dcl-pr Cursor98 Char(10);
          dcl-parm  Var1   packed(5:2);
          dcl-parm  Var2   packed(5:2);
          dcl-parm  Var3   LikeFile(QaPf99);
        End-Pr;

        dcl-s p_result packed(5:2);
        dcl-s p_result1 Char(10);

        dcl-s p_fld1 packed(5:2);
        dcl-s p_fld2 packed(5:2);

        dcl-s Var1   packed(5:2);
        dcl-s Var2   packed(5:2);
        dcl-ds Var3   LikeRec(QaPf98);


          p_fld1 = 5;
          p_fld2 = 3;
          var1   = .01;
          var2   = .02;
          var3   = *blank;
          //p_result  = subtract(p_fld1:p_fld2);
          read Qapf99 var3;
          p_fldx    = Cursor98(var1:var2:QAPF99);
          read Qapf99 var3;
          dsply p_result;
        *inlr = *on;
