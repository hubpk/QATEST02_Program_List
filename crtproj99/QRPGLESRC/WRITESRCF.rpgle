        Ctl-Opt dftactgrp(*no) BndDir('QC2LE');

        Dcl-F QSqlSrc Disk Usage(*OutPut) Qualified;

        Dcl-Pi *N;
          SqlSt  Char(400);
        End-Pi;

        Dcl-S SqlStm Char(400);
        Dcl-Ds Src       LikeRec(QSqlSrc.QSqlSrc);

          SqlStm = SqlSt;
          Src.SrcSeq = *Zero;
          Dow %SubSt(SqlStm:1:80) <> *Blank;
            Src.SrcSeq = Src.SrcSeq + 1;
            Src.SrcDta = %SubSt(SqlStm:1:80);
            SqlStm     = %SubSt(SqlStm:81:80);

            Write QSqlSrc.QSqlSrc Src;

          EndDo;
        *Inlr= *On;
