      Ctl-Opt NOMAIN option(*nodebugio:*srcstmt);                      
                                                                 
      Dcl-Proc RdmNumChar_5 Export;                                    
        Dcl-Pi *N Char(5);                                             
        End-Pi;                                                        
        Dcl-Pr Random ExtProc('CEERAN0');                              
          *n  Packed(10:0);                                            
          *n  Float(8);                                                
          *n  Char(12) Options(*Omit);                                 
        End-Pr;                                                        
                                                                 
        Dcl-S Seed          Packed(10:0);                              
        Dcl-S RanNo         Float(8);                                  
        Dcl-S FC            Char(12);                                  
        Dcl-S RandomChar_5  Char(5);                                   
        Dcl-S Inx           Packed(3:0);                               
        Dcl-S Alpha         Char(26) Inz('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
        For Inx = 1 to 5;                                              
          Random( Seed: RanNo : fc );                                  
          %SubSt( RandomChar_5 : Inx : 1 ) =                           
          %SubSt( Alpha : %Int(RanNo * 26 + 1) : 1 );                  
        EndFor;                                                        
        Return RandomChar_5;                                           
      End-Proc;                                                               
*----------------------------------------------------------------------- 
      Dcl-Proc RdmNumChar_10 Export;                                          
        Dcl-Pi *N Char(10);                                                   
        End-Pi;                                                               
        Dcl-Pr Random ExtProc('CEERAN0');                                     
         *n  Packed(10:0);                                                   
         *n  Float(8);                                                       
         *n  Char(12) Options(*Omit);                                        
        End-Pr;                                                               
                                                                         
        Dcl-S Seed          Packed(10:0);                                     
        Dcl-S RanNo         Float(8);                                         
        Dcl-S FC            Char(12);                                         
        Dcl-S RandomChar_10 Char(10);                                         
        Dcl-S Inx           Packed(3:0);                                      
        Dcl-S Alpha         Char(26) Inz('ABCDEFGHIJKLMNOPQRSTUVWXYZ');       
        For Inx = 1 to 10;                                                    
          Random( Seed: RanNo : fc );                                         
          %SubSt( RandomChar_10 : Inx : 1 ) =                                 
          %SubSt( Alpha : %Int(RanNo * 26 + 1) : 1 );                         
        EndFor;                                                               
        Return RandomChar_10;                                                 
      End-Proc;                                                         
*------------------------------------------------------------------
      Dcl-Proc RdmNumChar_15 Export;                                    
        Dcl-Pi *N Char(15);                                             
        End-Pi;                                                         
        Dcl-Pr Random ExtProc('CEERAN0');                               
         *n  Packed(10:0);                                             
         *n  Float(8);                                                 
         *n  Char(12) Options(*Omit);                                  
        End-Pr;                                                         
                                                                   
        Dcl-S Seed          Packed(10:0);                               
        Dcl-S RanNo         Float(8);                                   
        Dcl-S FC            Char(12);                                   
        Dcl-S RandomChar_15 Char(15);                                   
        Dcl-S Inx           Packed(3:0);                                
        Dcl-S Alpha         Char(26) Inz('ABCDEFGHIJKLMNOPQRSTUVWXYZ'); 
        For Inx = 1 to 15;                                              
          Random( Seed: RanNo : fc );                                   
          %SubSt( RandomChar_15 : Inx : 1 ) =                           
          %SubSt( Alpha : %Int(RanNo * 26 + 1) : 1 );                   
        EndFor;                                                         
        Return RandomChar_15;                                           
      End-Proc;                                                          
*-----------------------------------------------------------        
      Dcl-Proc RdmNumChar_20 Export;                                     
        Dcl-Pi *N Char(20);                                              
        End-Pi;                                                          
        Dcl-Pr Random ExtProc('CEERAN0');                                
          *n  Packed(10:0);                                              
          *n  Float(8);                                                  
          *n  Char(12) Options(*Omit);                                   
        End-Pr;                                                          
                                                                    
        Dcl-S Seed          Packed(10:0);                                
        Dcl-S RanNo         Float(8);                                    
        Dcl-S FC            Char(12);                                    
        Dcl-S RandomChar_20 Char(20);                                    
        Dcl-S Inx           Packed(3:0);                                 
        Dcl-S Alpha         Char(26) Inz('ABCDEFGHIJKLMNOPQRSTUVWXYZ');  
        For Inx = 1 to 20;                                               
          Random( Seed: RanNo : fc );                                    
          %SubSt( RandomChar_20 : Inx : 1 ) =                            
          %SubSt( Alpha : %Int(RanNo * 26 + 1) : 1 );                    
        EndFor;                                                          
        Return RandomChar_20;                                            
      End-Proc; 