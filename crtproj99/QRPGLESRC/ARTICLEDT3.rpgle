       Ctl-Opt BndDir('MIXBND');

       Dcl-F Article3 disk usage(*Input) keyed;
       Dcl-F Custome3 disk usage(*Input) keyed;

       Dcl-Pi *n ;
         Country  Char(2);
         Art_Info Char(1520) Dim(50);
       End-Pi;

       /Include QcpySrc,Article
       /Include QcpySrc,Familly
       /Include QcpySrc,Country
       /Include QcpySrc,Customer
       /Include QcpySrc,Vat
       /Include QcpySrc,Order
       /copy qcpysrc,cpyprc

       Dcl-Ds Ord_Ds ExtName('DETORD') Qualified End-Ds;
       Dcl-S Inx Packed(2:0) Inz(1);

      * ------------------------------------------------------------------------
      * Validate the country and then fetch customers using country id
      * ------------------------------------------------------------------------
        If ExistCountry(Country);
          ExSr FindValidCustomers;
        EndIf;

       *Inlr = *On;

      * ------------------------------------------------------------------------
      * Validate the order against selected customers then get the order
      * details from DETORD file
      * ------------------------------------------------------------------------

       BegSr FindQualifiedArticle;
          If Ord_Ds.OdTot = (GetArtRefSalPrice(Ord_Ds.OdArid) * GetArtCusQty
                            (Ord_Ds.OdArid));
             ExSr FillDetailsOnArray;

          EndIf;
       EndSr;

      * ------------------------------------------------------------------------
      * Get the article details based on article id and fill the output array
      * using other details like country name, customer name, order numer etc
      * ------------------------------------------------------------------------
       BegSr FillDetailsOnArray;

         Art_Info(Inx) = GetArtFamDesc(GetArtFam(GetOrderArtId(Ord_Ds.OdOrid
                         :Ord_Ds.OdQty:Ord_Ds.OdQtyLiv:Ord_Ds.OdLine))) +
                         GetArtFam(GetOrderArtId(Ord_Ds.OdOrid:Ord_Ds.OdQty:
                         Ord_Ds.OdQtyLiv:Ord_Ds.OdLine));
         Inx = Inx +1;

       EndSr;
      * ------------------------------------------------------------------------
       BegSr FindValidCustomers;
         Setll Country Custome3;
         Reade Country Custome3;
         Dow Not%Eof(Custome3) And ExistCountry(Country);
           If ExistCus(CuId) And GetOrderNumber(Cuid) > *Zero And
             GetCusLimCredit(CuId) <=5000;

             Ord_Ds = GetOrderDetails(GetOrderNumber(Cuid));
             // Validate the Net Amount If Amount is Matched the it eligible for
             // further process
             ExSr FindQualifiedArticle;

           EndIf;
           Reade Country Custome3;
         EndDo;
         // Let's find out cities
         If ('Kanpur' in %List(Name_Of_The_City('Del'):
             Name_Of_The_City('Kol'):Name_Of_The_City('Noi')));
           Dsply 'City found';
         Else;
           Dsply 'City Not Found';
         EndIf;
       EndSr;
