       copy SY000.
       Identification Division.
       Program-ID.         ADA000115S.
       copy SY103.
      **-------------------------------------------------------------**
      **‚  Convert CSV input from ADOS to formated files.           €**
      **                                                             **
      **   System  . . . . . :‚  Finance                            €**
      **   Program name  . . :‚  ADA000115S                         €**
      **   Author  . . . . . :‚  Maurice Mead                       €**
      **   Date written  . . :‚  10/07/2000                         €**
      **   Request/Incident  :‚  R:99176                            €**
      **                                                             **
      **   Description:                                              **
      **   The input file contains data from ADOS in CSV format,     **
      **     this needs to be reformated to load the header and      **
      **     detail ADOS interface files.                            **
      **-------------------------------------------------------------**
      **   Maintenance log:                                          **
      **   dd/mm/yy  request   programmer                            **
      **   description                                               **
      **                                                             **
      **-------------------------------------------------------------**
      /
       Environment Division.
       Configuration Section.
       Source-computer.    IBM-AS400.
       Object-computer.    IBM-AS400.

       Input-Output Section.
       File-control.

      *  Input accounts interface movements
           select ADOS-Upload
             assign        to database-ADA000115A.

      *  Output interface headers
           select Iface-Header
             assign        to database-ADIFCHDRL0
             organization  is indexed
             access        is random
             record key    is externally-described-key.

      *  Output interface details
           select Iface-Detail
             assign        to database-ADIFCDTLL0
             organization  is indexed
             access        is random
             record key    is externally-described-key.
      /
       Data Division.
       File Section.

       FD  ADOS-Upload.

       01  ADOS-Upload-R               pic x(250).
      /
       FD  Iface-Header.

       01  Iface-Header-R.
           copy dds-all-formats-i      of ADIFCHDRL0.
      /
       FD  Iface-Detail.

       01  Iface-Detail-R.
           copy dds-all-formats-i      of ADIFCDTLL0.
      /
       Working-Storage Section.
       01.
           05  ws-EOF-Flag             pic x          value space.
               88  ws-EOF                             value '1'.

           05  ws-1st-Time-Flag        pic x          value space.
               88  ws-1st-Time                        value space.
               88  ws-Next-Time                       value 'N'.

           05  ws-Header-Flag          pic x          value space.
               88  ws-Header-IK                       value '2'.

           05  ws-Detail-Flag          pic x          value space.
               88  ws-Detail-IK                       value '2'.

      *  Initial unstring results
       01.
           05  ws-Supplier-Invoice     pic x(20).
           05  ws-Invoice-No           pic x(7).
           05  ws-Currency-Code        pic x(3).
           05  ws-Account              pic x(25).
           05  ws-Amount               pic x(13).
           05  ws-Amount-Edited        redefines ws-Amount
                                       pic ----------.99.
           05  ws-Description          pic x(75).
           05  ws-DR-CR                pic x(3).
               88  ws-DR                              value 'DR'.
               88  ws-CR                              value 'CR'.

      *  Supplier account unstring results
           05  ws-Supplier-Loc         pic x(2).
           05  ws-Supplier-Acc         pic x(6).
           05  ws-Supplier-Nature      pic x.

      *  Account unstring results
           05  ws-Account-Loc          pic x(2).
           05  ws-Account-No           pic x(6).
           05  ws-Account-Tax          pic x(2).
           05  ws-Account-Dept         pic x(4).
           05  ws-Account-Anal         pic x(5).

       01.
           05  Save-Invoice-No         pic x(7).
           05  ws-Amount-Unedited      pic s9(11)v99.
           05  ws-General-DR-CR        pic x(2).
               88  ws-General-CR                      value 'CR'.
               88  ws-General-DR                      value 'DR'.

      /
       Linkage section.

      *  Output: Return code
       01  ls-Return-Code              pic x(7).
           88  ls-Return-Normal                       value space.
           88  ls-Return-Not-Numeric                  value 'MCH1202'.

      *  Input : Run number
       01  ls-Run-Number               pic s9(7)      comp-3.

      *  Output: Input record number
       01  ls-Record-Number            pic s9(5)      comp-3.

      *  Output: Run totals
       01  ls-Totals.
           05  ls-Supplier-DR-Total    pic s9(9)v99   comp-3.
           05  ls-Supplier-CR-Total    pic s9(9)v99   comp-3.
           05  ls-General-DR-Total     pic s9(9)v99   comp-3.
           05  ls-General-CR-Total     pic s9(9)v99   comp-3.
      /
       Procedure Division
           using ls-Return-Code
                 ls-Run-Number
                 ls-Record-Number
                 ls-Totals.

       a-Mainline Section.
       a-010.
           perform aa-Initialise.

           perform
             until ws-EOF  or  not ls-Return-Normal
               read ADOS-Upload
                 at end
                   set ws-EOF          to true
                 not at end
                   perform ba-Reformat-Input
               end-read
           end-perform.

           perform ab-Shutdown.

       a-990.
           goback.
      /
       aa-Initialise  section.
      **-------------------------------------------------------------**
      **   Open files, get the next run number and the date.         **
      **-------------------------------------------------------------**
       aa-010.
           set ls-Return-Normal        to true.
           move zeros                  to ls-Supplier-DR-Total
                                          ls-Supplier-CR-Total
                                          ls-General-DR-Total
                                          ls-General-CR-Total
                                          ls-Record-Number.

           open input    ADOS-Upload
                output   Iface-Header
                         Iface-Detail.

           move ls-Run-Number          to gaadRunNbr
                                          gbadRunNbr.

       aa-990.
           exit.
      /
       ab-Shutdown  section.
      **-------------------------------------------------------------**
      **   Close files and anything else I think of.                 **
      **-------------------------------------------------------------**
       ab-010.
           close   ADOS-Upload
                   Iface-Header
                   Iface-Detail.

       ab-990.
           exit.
      /
       ba-Reformat-Input  section.
      **-------------------------------------------------------------**
      **   Reformats the input from CSV to create interface header   **
      **     and detail records.                                     **
      **-------------------------------------------------------------**
       ba-010.
           add 1                       to ls-Record-Number.

           unstring ADOS-Upload-R
             delimited by ','
             into ws-Supplier-Invoice
                  ws-Invoice-No
                  ws-Currency-Code
                  ws-Account
                  ws-Amount
                  ws-Description
                  ws-DR-CR.

      *  1st record normally contains column headers, if so drop record
           if  ws-1st-Time
               set ws-Next-Time        to true
               if  ws-Supplier-Invoice(1:8) = 'Supplier'
                   go to ba-990.

           perform ga-Reformat-Amount.

      *  Load and write the header or detail record
           if  ws-Invoice-No  Not =  Save-Invoice-No
               move ws-Invoice-No      to Save-Invoice-No
               perform ca-Invoice-Header
           else
               perform cb-Invoice-Detail.

       ba-990.
           exit.
      /
       ca-Invoice-Header  section.
      **-------------------------------------------------------------**
      **   Load and write header record.                             **
      **-------------------------------------------------------------**
       ca-010.
      *  Insert leading zeros to invoice number
           perform
             until ws-Invoice-No(7:1)  not =  space
               move ws-Invoice-No(1:6) to ws-Invoice-No(2:6)
               move '0'                to ws-Invoice-No(1:1)
           end-perform.
           if  ws-Invoice-No  not numeric
               set ls-Return-Not-Numeric   to true
               go to ca-990.

      *  Unstring supplier account into location, account and nature.
           unstring ws-Account
             delimited by '.'
             into ws-Supplier-Loc
                  ws-Supplier-Acc
                  ws-Supplier-Nature.

           perform
             until ws-Supplier-Loc(2:1)  not =  spaces
               move ws-Supplier-Loc(1:1) to ws-Supplier-Loc(2:1)
               move '0'                  to ws-Supplier-Loc(1:1)
           end-perform.
           if  ws-Supplier-Loc  not numeric
               set ls-Return-Not-Numeric   to true
               go to ca-990.

           perform
             until ws-Supplier-Acc(6:1)  not =  space
               move ws-Supplier-Acc(1:5) to ws-Supplier-Acc(2:5)
               move '0'                  to ws-Supplier-Acc(1:1)
           end-perform.
           if  ws-Supplier-Acc  not numeric
               set ls-Return-Not-Numeric   to true
               go to ca-990.

           if  ws-Supplier-Nature  not numeric
               set ls-Return-Not-Numeric   to true
               go to ca-990.

      *  Remove leading space from DR/CR flag
           if  ws-DR-CR(1:1)  =  space
               move ws-DR-CR(2:2)      to ws-DR-CR.
      /
           move ws-Invoice-No          to gaadInvNo.
           move ws-Supplier-Invoice    to gaadSppInv.
           move ws-Currency-Code       to gaadCurCde.
           move ws-Supplier-Loc        to gaadSupLoc.
           move ws-Supplier-Acc        to gaadSupAcc.
           move ws-Supplier-Nature     to gaadSupNat.
           move ws-Description         to gaadInvCrd.

      *  If the amount is negative then it must be a credit.
           if  ws-Amount-Unedited  >  zero
               move ws-Amount-Unedited to gaadSupAmt
           else
               compute gaadSupAmt      = ws-Amount-Unedited * -1
               move 'CREDIT'           to gaadInvCrd
               set ws-DR               to true.

           move ws-DR-CR               to gaadDRCR.

           perform xa-Write-Header.

           if  ws-DR
               add gaadSupAmt          to ls-Supplier-DR-Total
               set ws-General-CR       to true
           else
               add gaadSupAmt          to ls-Supplier-CR-Total
               set ws-General-DR       to true.

      *  Reload invoice and line number on the detail file
           move gaadInvNo              to gbadInvNo.
           move zero                   to gbadLneNbr.

       ca-990.
           exit.
      /
       cb-Invoice-Detail  section.
      **-------------------------------------------------------------**
      **   Load and write the invoice details                        **
      **-------------------------------------------------------------**
       cb-010.
      *  Unstring the account location, number, tax code, department
      *  and analytical.
           unstring ws-Account
             delimited by '  ' or ' '
             into ws-Account-Loc
                  ws-Account-No
                  ws-Account-Tax
                  ws-Account-Dept
                  ws-Account-Anal.

      *  The format is normally correct but it is checked just in case
           perform
             until ws-Account-Loc(2:1)  not =  space
               move ws-Account-Loc(1:1)  to ws-Account-Loc(2:1)
               move '0'                  to ws-Account-Loc(1:1)
           end-perform.
           if  ws-Account-Loc  not numeric
               set ls-Return-Not-Numeric   to true
               go to cb-990.

           perform
             until ws-Account-No(6:1)  not =  space
               move ws-Account-No(1:5)   to ws-Account-No(2:5)
               move '0'                  to ws-Account-No(1:1)
           end-perform.
           if  ws-Account-No  not numeric
               set ls-Return-Not-Numeric   to true
               go to cb-990.

           perform
             until ws-Account-Tax(2:1)  not =  space
               move ws-Account-Tax(1:1)  to ws-Account-Tax(2:1)
               move '0'                  to  ws-Account-Tax(1:1)
           end-perform.
           if  ws-Account-Tax  not numeric
               set ls-Return-Not-Numeric   to true
               go to cb-990.

           perform
             until ws-Account-Dept(4:1)  not =  space
               move ws-Account-Dept(1:3) to ws-Account-Dept(2:3)
               move '0'                  to ws-Account-Dept(1:1)
           end-perform.
           if  ws-Account-Dept  not numeric
               set ls-Return-Not-Numeric   to true
               go to cb-990.

           perform
             until ws-Account-Anal(5:1)  not =  space
               move ws-Account-Anal(1:4) to ws-Account-Anal(2:4)
               move '0'                  to ws-Account-Anal(1:1)
           end-perform.
           if  ws-Account-Anal  not numeric
               set ls-Return-Not-Numeric   to true
               go to cb-990.

           add 1                       to gbadLneNbr.
           move ws-Account-Loc         to gbadAccLoc.
           move ws-Account-No          to gbadAccNo.
           move ws-Account-Tax         to gbadAccTax.
           move ws-Account-Dept        to gbadAccDpt.
           move ws-Account-Anal        to gbadAccAnl.
           move ws-Description         to gbadDsc.
           move ws-General-DR-CR       to gbadDRCR.
           if  ws-Amount-Unedited  >  Zero
               move ws-Amount-Unedited to gbadAmt
           else
               compute gbAdAmt         = ws-Amount-Unedited * -1.
           perform xb-Write-Detail.

           if ws-General-DR
               add gbAdAmt             to ls-General-DR-Total
           else
               add gbAdAmt             to ls-General-CR-Total.

       cb-990.
           exit.
      /
       ga-Reformat-Amount  section.
      **-------------------------------------------------------------**
      **   Reformat the amount into numerics and remove a leading    **
      **     space from the DR/CR flag.                              **
      **-------------------------------------------------------------**
       ga-010.
      *  Check 1st two characters looking for leading negatives
           evaluate true
             when ws-Amount(1:2)  =  ' -'
               move '-'                  to ws-Amount(1:1)
             when ws-Amount(1:1)  =  '-' or ' '
               continue
             when other
               if  ws-Amount(13:1)  =  space
                   move ws-Amount(1:12)  to ws-Amount(2:12)
                   move space            to ws-Amount(1:1)
               end-if
           end-evaluate.

      *  Now move values to the right side
           perform
             until ws-Amount(13:1)  not =  space
               move ws-Amount(1:12)    to ws-Amount(2:12)
           end-perform.

      *  and finally convert the value to numeric
           move ws-Amount-Edited       to ws-Amount-Unedited.

       ga-990.
           exit.
      /
       xa-Write-Header  section.
      **-------------------------------------------------------------**
      **   Write a record to the Interface Header file.              **
      **-------------------------------------------------------------**
       xa-010.
           write Iface-Header-R
             invalid key
               set ws-Header-IK        to true.

       xa-990.
           exit.
      /
       xb-Write-Detail  section.
      **-------------------------------------------------------------**
      **   Write a record to the Interface Detail file.              **
      **-------------------------------------------------------------**
       xb-010.
           write Iface-Detail-R
             invalid key
               set ws-Detail-IK        to true.

       xb-990.
           exit.
