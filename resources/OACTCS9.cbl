CBL NODYNAM,OBJECT,APOST,NOSEQ
      **************************************************************
      * OACTCS9 - OPEN ACCOUNT FOR CICS AND DB2.
      **************************************************************
        IDENTIFICATION DIVISION.
        PROGRAM-ID. OACTCS9.
        DATA DIVISION.
      **************************************************************
        WORKING-STORAGE SECTION.
      **************************************************************
            EXEC SQL
              INCLUDE SQLCA
            END-EXEC.
      **************************************************************
       01  DCLACCOUNT.
           10 ACCT_ACCOUNT_ID      PIC X(11).
           10 ACCT_CUSTOMER_ID     PIC X(16).
           10 ACCT_CUSTOMER_NAME   PIC X(16).
           10 ACCT_IBAN            PIC X(32).
           10 ACCT_BNK_ID          PIC X(4).
           10 ACCT_BRNCH_ID        PIC S9(9) COMP.
           10 ACCT_CNTRY_CD        PIC X(2).
           10 ACCT_TYPCD           PIC X(1).
           10 ACCT_SUB_TYPCD       PIC X(3).
           10 ACCT_TYPE_NAME       PIC X(12).
           10 ACCT_TYPE_DESCRIPTION  PIC X(40).
           10 ACCT_BALANCE         PIC S9(11)V9(3) USAGE COMP-3.
           10 ACCT_CURRENCY        PIC X(3).
           10 ACCT_CRT_DT          PIC X(8).
           10 ACCT_UPDT_DT         PIC X(8).
           10 ACCT_LOCKED          PIC X(1).
      **************************************************************
        01 IN-PUT-WS.
            07 ACTW-ACCOUNT-ID                PIC X(11).
            07 ACTW-CUSTOMER-ID               PIC X(16).
            07 ACTW-CUSTOMER-NAME             PIC X(16).
            07 ACTW-TYPCD                     PIC X.
            07 ACTW-SUB-TYPCD                 PIC X(3).
            07 ACTW-CNTRY-CD                  PIC X(2).
            07 ACTW-BNK-ID                    PIC X(4).
            07 ACTW-BRNCH-ID                  PIC S9(9) COMP.
            07 ACTW-INITIAL-DEPOSIT
                     PIC S9(11)V9(3) USAGE COMP-3.
            07 ACTW-BALANCE                   PIC S9(11)V9(3) COMP-3.
            07 ACTW-CURRENCY                  PIC X(3).
            07 ACTW-IBAN                      PIC X(32).
            07 ACTW-TYPE-NAME                 PIC X(12).
            07 ACTW-TYPE-DESCRIPTION          PIC X(40).
            07 ACTW-CRT-DT                    PIC X(8).
            07 ACTW-UPDT-DT                   PIC X(8).
            07 ACTW-LOCKED                    PIC X.
      **************************************************************
        01 WS-CURRENT-DATE-DATA.
          03 WS-CURRENT-DATE.
            05 WS-CURRENT-YEAR                PIC 9(04).
            05 WS-CURRENT-MONTH               PIC 9(02).
            05 WS-CURRENT-DAY                 PIC 9(02).
          03 WS-CURRENT-TIME.
            05 WS-CURRENT-HOURS               PIC 9(02).
            05 WS-CURRENT-MINUTE              PIC 9(02).
            05 WS-CURRENT-SECOND              PIC 9(02).
            05 WS-CURRENT-MILLISECONDS        PIC 9(02).
        01 IBAN-STRC.
          03 IBAN-CNTRY-CD                    PIC X(2).
          03 IBAN-CHECK-DIGITS                PIC S9(2).
          03 IBAN-BNK-ID                      PIC X(4).
          03 IBAN-BRNCH-ID                    PIC X(6).
          03 FILLER                           PIC X(7) VALUE SPACES.
        01 SPACE-COUNT                        PIC S9.
        01 TXT-SQLCODE                        PIC X(12) VALUE SPACES.
        01 TXT-SQLSTATE                       PIC X(12) VALUE SPACES.
        01 TXT-SQLERRMC                       PIC X(70) VALUE SPACES.
      **************************************************************
        LINKAGE SECTION.
      **************************************************************
        01 DFHCOMMAREA.
          03 IN-PUT.
             05 ACTI-ACCOUNT-ID                  PIC X(11).
             05 ACTI-CUSTOMER-ID                 PIC X(16).
             05 ACTI-CUSTOMER-NAME               PIC X(16).
             05 ACTI-TYPCD                       PIC X.
               88 ACTI-TYPCD-BUSINESS            VALUE 'B'.
               88 ACTI-TYPCD-PERSONAL            VALUE 'P'.
             05 ACTI-SUB-TYPCD                   PIC X(3).
               88 BASIC-CHECKING-ACT             VALUE 'BC'.
               88 SAVINGS-ACT                    VALUE 'S'.
               88 INTEREST-BEARING-CHECKING-ACT  VALUE 'IBC'.
               88 MONEY-MARKET-ACT               VALUE 'MM'.
               88 IRA-ACT                        VALUE 'IRA'.
               88 BROKERAGE-ACT                  VALUE 'B'.
             05 ACTI-CNTRY-CD                    PIC X(2).
             05 ACTI-BNK-ID                      PIC X(4).
             05 ACTI-BRNCH-ID                    PIC S9(9) COMP.
             05 ACTI-INITIAL-DEPOSIT             PIC S9(11)V9(3) COMP-3
                                                VALUE 0.
             05 ACTI-CURRENCY                    PIC X(3).
          03  ACCOUNT-OUT.
            05 OUT-RECORD.
              07 ACTO-ACCOUNT-ID                PIC X(11).
              07 ACTO-CUSTOMER-ID               PIC X(16).
              07 ACTO-CUSTOMER-NAME             PIC X(16).
              07 ACTO-IBAN                      PIC X(32).
              07 ACTO-CNTRY-CD                  PIC X(2).
              07 ACTO-BNK-ID                    PIC X(4).
              07 ACTO-BRNCH-ID                  PIC S9(9) COMP.
              07 ACTO-TYPCD                     PIC X.
              07 ACTO-TYPE-NAME                 PIC X(12).
              07 ACTO-SUB-TYPCD                 PIC X(3).
              07 ACTO-TYPE-DESCRIPTION          PIC X(40).
              07 ACTO-BALANCE                   PIC S9(11)V9(3) COMP-3.
              07 ACTO-CURRENCY                  PIC X(3).
              07 ACTO-CRT-DT                    PIC X(8).
              07 ACTO-UPDT-DT                   PIC X(8).
              07 ACTO-LOCKED                    PIC X.
                88 ACTO-LOCKED-YES              VALUE 'Y'.
                88 ACTO-LOCKED-NO               VALUE 'N'.
            05 RTCD                             PIC S9.
              88 RTCD-OK                        VALUE 0.
              88 RTCD-CSTMR-ID                  VALUE 1.
              88 RTCD-CSTMR-NAME                VALUE 2.
              88 RTCD-ACT-SUB-TYP               VALUE 3.
              88 RTCD-ACT-TYP                   VALUE 4.
              88 RTCD-CNTRY-CD                  VALUE 5.
              88 RTCD-BNK-ID                    VALUE 6.
              88 RTCD-BRNCH-ID                  VALUE 7.
            05 RT-MSG                           PIC X(60).
      **************************************************************
      * PROCEDURE DIVISION.
      **************************************************************
       PROCEDURE DIVISION.
       MAIN-RTN. 
           PERFORM GET-INPUT THRU GET-INPUT-END
           PERFORM HANDLE-INPUT THRU HANDLE-INPUT-END
           PERFORM DO-SQL THRU DO-SQL-END
           GOBACK.
      **************************************************************
       GET-INPUT.  
           MOVE IN-PUT TO IN-PUT-WS.                         
           DISPLAY 'ACCOUNT-ID: ' ACTI-ACCOUNT-ID.
       GET-INPUT-END.            
           EXIT. 
      **************************************************************	
       HANDLE-INPUT.
            MOVE LOW-VALUES TO ACCOUNT-OUT
            SET RTCD-OK TO TRUE.
            MOVE ACTI-ACCOUNT-ID TO ACTO-ACCOUNT-ID.

            IF ACTI-CUSTOMER-ID EQUAL SPACES
                  MOVE 1 TO RTCD
                  MOVE 'Invalid customer ID.' TO RT-MSG
            END-IF.

            IF ACTI-CUSTOMER-NAME EQUAL SPACES
                  MOVE 2 TO RTCD
                  MOVE 'Invalid customer name.' TO RT-MSG
            END-IF.

            EVALUATE ACTI-SUB-TYPCD
              WHEN 'BC'
                 MOVE 'Basic Checking Account' TO ACTO-TYPE-DESCRIPTION
              WHEN 'S'
                 MOVE 'Savings Account' TO ACTO-TYPE-DESCRIPTION
              WHEN 'IBC'
                 MOVE 'Interest Bearing Checking'
                     TO ACTO-TYPE-DESCRIPTION
              WHEN 'MM'
                 MOVE 'Money Market Account'
                     TO ACTO-TYPE-DESCRIPTION
              WHEN 'IRA'
                 MOVE 'Investment Retirement Account'
                     TO ACTO-TYPE-DESCRIPTION
              WHEN 'B'
                 MOVE 'Brokerage Account' TO ACTO-TYPE-DESCRIPTION
              WHEN OTHER
                 MOVE 'ERROR' TO ACTO-TYPE-DESCRIPTION
                 MOVE 3 TO RTCD
                 MOVE 'Account sub type does not exist.' TO RT-MSG
            END-EVALUATE.

            EVALUATE ACTI-TYPCD
              WHEN 'B'
                 MOVE 'Business' TO ACTO-TYPE-NAME
              WHEN 'P'
                 MOVE 'Personal' TO ACTO-TYPE-NAME
              WHEN OTHER
                 MOVE 'ERROR' TO ACTO-TYPE-NAME
                 MOVE 4 TO RTCD
                 MOVE 'Account type does not exist.' TO RT-MSG
            END-EVALUATE.

           MOVE ZERO TO SPACE-COUNT
           INSPECT ACTI-CNTRY-CD (1:2)
                       TALLYING SPACE-COUNT FOR ALL SPACES
           IF SPACE-COUNT > ZERO
                 MOVE 5 TO RTCD
                 MOVE 'Invalid country code.' TO RT-MSG
           END-IF.

           MOVE ZERO TO SPACE-COUNT
           INSPECT ACTI-BNK-ID (1:4)
                       TALLYING SPACE-COUNT FOR ALL SPACES
           IF SPACE-COUNT > ZERO
                 MOVE 6 TO RTCD
                 MOVE 'Invalid bank ID.' TO RT-MSG
           END-IF.

           IF ACTI-BRNCH-ID IS ZERO
                 MOVE 7 TO RTCD
                 MOVE 'Invalid branch ID.' TO RT-MSG
            END-IF.

            MOVE 'SUCCESSFUL OPEN' TO RT-MSG.
            MOVE FUNCTION CURRENT-DATE to WS-CURRENT-DATE-DATA.
            MOVE WS-CURRENT-DATE TO ACTO-CRT-DT.
            MOVE WS-CURRENT-DATE TO ACTO-UPDT-DT.
            MOVE ACTI-CUSTOMER-ID TO ACTO-CUSTOMER-ID.
            MOVE ACTI-CUSTOMER-NAME TO ACTO-CUSTOMER-NAME.
            MOVE ACTI-TYPCD TO ACTO-TYPCD.
            MOVE ACTI-SUB-TYPCD TO ACTO-SUB-TYPCD.
            MOVE ACTI-INITIAL-DEPOSIT TO ACTO-BALANCE.
            MOVE ACTI-CURRENCY TO ACTO-CURRENCY.
            MOVE ACTI-CNTRY-CD TO ACTO-CNTRY-CD.
            MOVE ACTI-BNK-ID TO ACTO-BNK-ID.
            MOVE ACTI-BRNCH-ID TO ACTO-BRNCH-ID.
            MOVE 'N' TO ACTO-LOCKED.

            MOVE ACTI-CNTRY-CD TO IBAN-CNTRY-CD
            MOVE 29 TO IBAN-CHECK-DIGITS
            MOVE ACTI-BNK-ID TO IBAN-BNK-ID
            MOVE ACTI-BRNCH-ID TO IBAN-BRNCH-ID

            MOVE IBAN-STRC TO ACTO-IBAN. 
       HANDLE-INPUT-END.            
           EXIT. 
      **************************************************************
       DO-SQL.
            EXEC SQL
                  INSERT INTO OLS0002.ACCOUNT2 (
                     ACCT_ACCOUNT_ID,
                     ACCT_CUSTOMER_ID, 
                     ACCT_CUSTOMER_NAME, 
                     ACCT_IBAN, 
                     ACCT_BNK_ID,
                     ACCT_BRNCH_ID,
                     ACCT_CNTRY_CD, 					 
                     ACCT_TYPCD,
                     ACCT_SUB_TYPCD, 
                     ACCT_TYPE_NAME,
                     ACCT_TYPE_DESCRIPTION,
                     ACCT_BALANCE, 
                     ACCT_CURRENCY,
                     ACCT_CRT_DT, 
                     ACCT_UPDT_DT, 
                     ACCT_LOCKED)
                  VALUES ( 
                     :ACTO-ACCOUNT-ID,
                     :ACTO-CUSTOMER-ID, 
                     :ACTO-CUSTOMER-NAME, 
                     :ACTO-IBAN,
                     :ACTO-BNK-ID, 
                     :ACTO-BRNCH-ID, 
                     :ACTO-CNTRY-CD, 
                     :ACTO-TYPCD,
                     :ACTO-SUB-TYPCD, 
                     :ACTO-TYPE-NAME,
                     :ACTO-TYPE-DESCRIPTION,
                     :ACTO-BALANCE, 
                     :ACTO-CURRENCY,
                     :ACTO-CRT-DT, 
                     :ACTO-UPDT-DT, 
                     :ACTO-LOCKED)
            END-EXEC.
            PERFORM DO-POSTSQL THRU DO-POSTSQL-END.
       DO-SQL-END.
           EXIT. 
      **************************************************************	
       DO-POSTSQL.
            MOVE SQLCODE TO TXT-SQLCODE
            MOVE SQLSTATE TO TXT-SQLSTATE
            MOVE SQLERRMC TO TXT-SQLERRMC

            IF SQLCODE = 0 
               MOVE 'SUCCESSFUL INSERT' TO RT-MSG
               DISPLAY 'ACCOUNT = ' ACTW-ACCOUNT-ID
               IF ACTO-BALANCE = 0
                  MOVE 1.111 TO ACTO-BALANCE
               END-IF
            ELSE
               MOVE 'INSERT NOT SUCCESSFUL' TO RT-MSG
               DISPLAY 'SQLCODE:  ' TXT-SQLCODE
               DISPLAY 'SQLSTATE: ' TXT-SQLSTATE
               DISPLAY 'SQLERRMC: ' TXT-SQLERRMC
            END-IF.
       DO-POSTSQL-END.
           EXIT.
      **************************************************************	

