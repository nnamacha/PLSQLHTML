CREATE OR REPLACE PACKAGE PKG_CREATE_HTML IS
  -- Author  : Nicholas Namacha
  -- Created : 8/19/2015 1:23:23 PM
  -- Purpose :
  -- Public type declarations
  FHANDLE UTL_FILE.FILE_TYPE;
  FREAD   UTL_FILE.FILE_TYPE;
  -- Public constant declarations
  CSS_FILE CONSTANT VARCHAR2(100) := 'header.html';
  -- Public variable declarations
  FILE_NAME   VARCHAR2(40);
  CTRLM_DIR   VARCHAR2(40);
  V_NEWLINE   VARCHAR2(1000);
  F1          VARCHAR2(40);
  F2          VARCHAR2(40);
  F3          VARCHAR2(40);
  F4          VARCHAR2(40);
  F5          VARCHAR2(40);
  F6          VARCHAR2(40);
  F7          VARCHAR2(40);
  F8          VARCHAR2(40);
  F9          VARCHAR2(40);
  TEXT        VARCHAR2(40);
  OUT_PUT_DIR VARCHAR2(4000);
  -- Public function and procedure declarations
  -- procedure SET_FILE_NAME(TEXT varchar2);
  PROCEDURE BUILD_HEADER(FILE_ID IN VARCHAR2, TEXT IN VARCHAR2);
  PROCEDURE OPENTABLE(FILE_ID IN VARCHAR2);
  PROCEDURE CLOSETABLE(FILE_ID IN VARCHAR2);
  PROCEDURE TABLEDATA(FILE_ID IN VARCHAR2,
                      F1      IN VARCHAR2,
                      FLAG    IN NUMBER,
                      TEXT    IN OUT VARCHAR2,
                      P_KEY   IN GSS_DASHBOARD_DETAIL.F_KEY%TYPE);
  PROCEDURE TABLEDATA(FILE_ID IN VARCHAR2,
                      F1      IN VARCHAR2,
                      F2      IN VARCHAR2,
                      FLAG    IN NUMBER,
                      TEXT    IN OUT VARCHAR2,
                      P_KEY   IN GSS_DASHBOARD_DETAIL.F_KEY%TYPE);
  PROCEDURE TABLEDATA(FILE_ID IN VARCHAR2,
                      F1      IN VARCHAR2,
                      F2      IN VARCHAR2,
                      F3      IN VARCHAR2,
                      FLAG    IN NUMBER,
                      TEXT    IN OUT VARCHAR2,
                      P_KEY   IN GSS_DASHBOARD_DETAIL.F_KEY%TYPE);
  PROCEDURE TABLEDATA(FILE_ID IN VARCHAR2,
                      F1      IN VARCHAR2,
                      F2      IN VARCHAR2,
                      F3      IN VARCHAR2,
                      F4      IN VARCHAR2,
                      FLAG    IN NUMBER,
                      TEXT    IN OUT VARCHAR2,
                      P_KEY   IN GSS_DASHBOARD_DETAIL.F_KEY%TYPE);
  PROCEDURE TABLEDATA(FILE_ID IN VARCHAR2,
                      F1      IN VARCHAR2,
                      F2      IN VARCHAR2,
                      F3      IN VARCHAR2,
                      F4      IN VARCHAR2,
                      F5      IN VARCHAR2,
                      FLAG    IN NUMBER,
                      TEXT    IN OUT VARCHAR2,
                      P_KEY   IN GSS_DASHBOARD_DETAIL.F_KEY%TYPE);
  PROCEDURE TABLEDATA(FILE_ID IN VARCHAR2,
                      F1      IN VARCHAR2,
                      F2      IN VARCHAR2,
                      F3      IN VARCHAR2,
                      F4      IN VARCHAR2,
                      F5      IN VARCHAR2,
                      F6      IN VARCHAR2,
                      FLAG    IN NUMBER,
                      TEXT    IN OUT VARCHAR2,
                      P_KEY   IN GSS_DASHBOARD_DETAIL.F_KEY%TYPE);
  PROCEDURE TABLEDATA(FILE_ID IN VARCHAR2,
                      F1      IN VARCHAR2,
                      F2      IN VARCHAR2,
                      F3      IN VARCHAR2,
                      F4      IN VARCHAR2,
                      F5      IN VARCHAR2,
                      F6      IN VARCHAR2,
                      F7      IN VARCHAR2,
                      FLAG    IN NUMBER,
                      TEXT    IN OUT VARCHAR2,
                      P_KEY   IN GSS_DASHBOARD_DETAIL.F_KEY%TYPE);
  PROCEDURE TABLEDATA(FILE_ID IN VARCHAR2,
                      F1      IN VARCHAR2,
                      F2      IN VARCHAR2,
                      F3      IN VARCHAR2,
                      F4      IN VARCHAR2,
                      F5      IN VARCHAR2,
                      F6      IN VARCHAR2,
                      F7      IN VARCHAR2,
                      F8      IN VARCHAR2,
                      FLAG    IN NUMBER,
                      TEXT    IN OUT VARCHAR2,
                      P_KEY   IN GSS_DASHBOARD_DETAIL.F_KEY%TYPE);
  PROCEDURE TABLEDATA(FILE_ID IN VARCHAR2,
                      F1      IN VARCHAR2,
                      F2      IN VARCHAR2,
                      F3      IN VARCHAR2,
                      F4      IN VARCHAR2,
                      F5      IN VARCHAR2,
                      F6      IN VARCHAR2,
                      F7      IN VARCHAR2,
                      F8      IN VARCHAR2,
                      F9      IN VARCHAR2,
                      FLAG    IN NUMBER,
                      TEXT    IN OUT VARCHAR2,
                      P_KEY   IN GSS_DASHBOARD_DETAIL.F_KEY%TYPE);
  PROCEDURE HEADER_TEXT(FILE_ID     IN VARCHAR2,
                        TEXT        IN OUT VARCHAR2,
                        HEADER_TYPE IN VARCHAR2);
  PROCEDURE ADD_JAVA_SCRIPT(FILE_ID IN VARCHAR2, TEXT IN OUT VARCHAR2);
  PROCEDURE ADD_JAVA_SCRIPT(FILE_ID IN VARCHAR2,
                            TEXT    IN OUT VARCHAR2,
                            F_KEY   IN GSS_DASHBOARD_DETAIL.F_KEY%TYPE);
  PROCEDURE ADD_SUB_JAVA_SCRIPT(FILE_ID IN VARCHAR2, TEXT IN OUT VARCHAR2);
  PROCEDURE ADD_SUB_JAVA_SCRIPT(FILE_ID IN VARCHAR2,
                                TEXT    IN OUT VARCHAR2,
                                F_KEY   IN GSS_DASHBOARD_DETAIL.F_KEY%TYPE);
  PROCEDURE HTML_TRAILER(FILE_ID IN VARCHAR2);
END PKG_CREATE_HTML;
/
CREATE OR REPLACE PACKAGE BODY PKG_CREATE_HTML IS
  -- Private type declarations
  -- Private constant declarations
  -- Private variable declarations
  DIR_NAME VARCHAR2(40);
  -- Function and procedure implementations
  PROCEDURE BUILD_HEADER(FILE_ID IN VARCHAR2, TEXT IN VARCHAR2) IS
    CNT  NUMBER := 0;
    FLAG VARCHAR2(1) := 'A';
  BEGIN
  
    SELECT DIRECTORY_PATH
      INTO DIR_NAME
      FROM DBA_DIRECTORIES
     WHERE DIRECTORY_NAME = 'CTRLM_OUTPUT';
  
    CTRLM_DIR := SUBSTR(DIR_NAME, 0, INSTR(DIR_NAME, 'OUTPUT') - 1)
                
                 FILE_NAME := TEXT;
    FHANDLE   := UTL_FILE.FOPEN(DIR_NAME, FILE_ID, 'w');
    FREAD     := UTL_FILE.FOPEN(CTRLM_DIR, 'header.html', 'r');
    IF UTL_FILE.IS_OPEN(FREAD) THEN
      LOOP
        BEGIN
          CNT := CNT + 1;
          IF CNT = 1 THEN
            FLAG := 'W';
          ELSE
            FLAG := 'A';
          END IF;
          UTL_FILE.GET_LINE(FREAD, V_NEWLINE);
          PN_GSS_DASHBOARD_WRITE_DET(FILE_ID, V_NEWLINE, FLAG);
        END;
      END LOOP;
    END IF;
  EXCEPTION
    WHEN UTL_FILE.INVALID_OPERATION THEN
      UTL_FILE.FCLOSE(FHANDLE);
      UTL_FILE.FCLOSE(FREAD);
      RAISE_APPLICATION_ERROR(-20051, 'utl_file: invalid operation');
    WHEN UTL_FILE.INVALID_FILEHANDLE THEN
      UTL_FILE.FCLOSE(FHANDLE);
      UTL_FILE.FCLOSE(FREAD);
      RAISE_APPLICATION_ERROR(-20052, 'utl_file: invalid file handle');
    WHEN UTL_FILE.READ_ERROR THEN
      UTL_FILE.FCLOSE(FHANDLE);
      UTL_FILE.FCLOSE(FREAD);
      RAISE_APPLICATION_ERROR(-20053, 'utl_file: read error');
    WHEN UTL_FILE.INVALID_PATH THEN
      UTL_FILE.FCLOSE(FHANDLE);
      UTL_FILE.FCLOSE(FREAD);
      RAISE_APPLICATION_ERROR(-20054, 'utl_file: invalid path');
    WHEN UTL_FILE.INVALID_MODE THEN
      UTL_FILE.FCLOSE(FHANDLE);
      UTL_FILE.FCLOSE(FREAD);
      RAISE_APPLICATION_ERROR(-20055, 'utl_file: invalid mode');
    WHEN UTL_FILE.INTERNAL_ERROR THEN
      UTL_FILE.FCLOSE(FHANDLE);
      UTL_FILE.FCLOSE(FREAD);
      RAISE_APPLICATION_ERROR(-20056, 'utl_file: internal error');
    WHEN VALUE_ERROR THEN
      UTL_FILE.FCLOSE(FHANDLE);
      UTL_FILE.FCLOSE(FREAD);
      RAISE_APPLICATION_ERROR(-20057, 'utl_file: value error');
    
    WHEN NO_DATA_FOUND THEN
      NULL;
    WHEN OTHERS THEN
      UTL_FILE.FCLOSE(FHANDLE);
      UTL_FILE.FCLOSE(FREAD);
      RAISE;
  END;
  PROCEDURE OPENTABLE(FILE_ID IN VARCHAR2) IS
  BEGIN
    TEXT := '<div class="eft-extract">';
    PN_GSS_DASHBOARD_WRITE_DET(FILE_ID, TEXT, 'A');
    TEXT := '<div class="pt-table">';
    PN_GSS_DASHBOARD_WRITE_DET(FILE_ID, TEXT, 'A');
    TEXT := '<div class="pt-body">';
    PN_GSS_DASHBOARD_WRITE_DET(FILE_ID, TEXT, 'A');
    TEXT := '<div class="tree">';
    PN_GSS_DASHBOARD_WRITE_DET(FILE_ID, TEXT, 'A');
    TEXT := '<ul class="pt-rows">';
    PN_GSS_DASHBOARD_WRITE_DET(FILE_ID, TEXT, 'A');
    TEXT := '<li class="title"><span></span></li>';
    PN_GSS_DASHBOARD_WRITE_DET(FILE_ID, TEXT, 'A');
    TEXT := '<li class="Record_Type">';
    PN_GSS_DASHBOARD_WRITE_DET(FILE_ID, TEXT, 'A');
    TEXT := '';
  END;
  PROCEDURE CLOSETABLE(FILE_ID IN VARCHAR2) IS
  BEGIN
    TEXT := '</div>';
    PN_GSS_DASHBOARD_WRITE_DET(FILE_ID, TEXT, 'A');
    TEXT := '</div>';
    PN_GSS_DASHBOARD_WRITE_DET(FILE_ID, TEXT, 'A');
    TEXT := '</div>';
    PN_GSS_DASHBOARD_WRITE_DET(FILE_ID, TEXT, 'A');
    TEXT := '</div>';
    PN_GSS_DASHBOARD_WRITE_DET(FILE_ID, TEXT, 'A');
    TEXT := '</div>';
    PN_GSS_DASHBOARD_WRITE_DET(FILE_ID, TEXT, 'A');
    TEXT := '</li>';
    PN_GSS_DASHBOARD_WRITE_DET(FILE_ID, TEXT, 'A');
    TEXT := '</li>';
    PN_GSS_DASHBOARD_WRITE_DET(FILE_ID, TEXT, 'A');
    TEXT := '</ul>';
    PN_GSS_DASHBOARD_WRITE_DET(FILE_ID, TEXT, 'A');
    TEXT := '';
  END;
  PROCEDURE TABLEDATA(FILE_ID IN VARCHAR2,
                      F1      IN VARCHAR2,
                      FLAG    IN NUMBER,
                      TEXT    IN OUT VARCHAR2,
                      P_KEY   IN GSS_DASHBOARD_DETAIL.F_KEY%TYPE) IS
    V_NEWLINE VARCHAR2(3600);
  BEGIN
    IF FLAG = 1 THEN
      V_NEWLINE := '<li> <span>' || F1 || '</span ></li >';
      IF P_KEY = 0 THEN
        ADD_JAVA_SCRIPT(FILE_ID, V_NEWLINE);
      ELSE
        ADD_JAVA_SCRIPT(FILE_ID, V_NEWLINE, P_KEY);
      END IF;
      TEXT := '';
    ELSE
      TEXT := TEXT || '<li><span>' || F1 || '</span ></li >' || CHR(10);
    END IF;
    --Pn_Gss_Dashboard_Write_Det(file_id,V_Newline,'A');
  
  END;
  PROCEDURE TABLEDATA(FILE_ID IN VARCHAR2,
                      F1      IN VARCHAR2,
                      F2      IN VARCHAR2,
                      FLAG    IN NUMBER,
                      TEXT    IN OUT VARCHAR2,
                      P_KEY   IN GSS_DASHBOARD_DETAIL.F_KEY%TYPE) IS
    V_NEWLINE VARCHAR2(3600);
  BEGIN
    IF FLAG = 1 THEN
      V_NEWLINE := '<li><span>' || F1 || '</span><span>' || F2 ||
                   '</span></li>';
      IF P_KEY = 0 THEN
        ADD_JAVA_SCRIPT(FILE_ID, V_NEWLINE);
      ELSE
        ADD_JAVA_SCRIPT(FILE_ID, V_NEWLINE, P_KEY);
      END IF;
      TEXT := '';
    ELSE
      TEXT := TEXT || '<li><span>' || F1 || '</span><span>' || F2 ||
              '</span></li>' || CHR(10);
    END IF;
    --Pn_Gss_Dashboard_Write_Det(file_id,V_Newline,'A');
  
  END;
  PROCEDURE TABLEDATA(FILE_ID IN VARCHAR2,
                      F1      IN VARCHAR2,
                      F2      IN VARCHAR2,
                      F3      IN VARCHAR2,
                      FLAG    IN NUMBER,
                      TEXT    IN OUT VARCHAR2,
                      P_KEY   IN GSS_DASHBOARD_DETAIL.F_KEY%TYPE) IS
    V_NEWLINE VARCHAR2(3600);
  BEGIN
    IF FLAG = 1 THEN
      V_NEWLINE := '<li><span>' || F1 || '</span><span>' || F2 ||
                   '</span><span>' || F3 || '</span></li>';
      IF P_KEY = 0 THEN
        ADD_JAVA_SCRIPT(FILE_ID, V_NEWLINE);
      ELSE
        ADD_JAVA_SCRIPT(FILE_ID, V_NEWLINE, P_KEY);
      END IF;
      TEXT := '';
    ELSE
      TEXT := TEXT || '<li><span>' || F1 || '</span><span>' || F2 ||
              '</span><span>' || F3 || '</span></li>' || CHR(10);
    END IF;
    --Pn_Gss_Dashboard_Write_Det(file_id,V_Newline,'A');
  
  END;
  PROCEDURE TABLEDATA(FILE_ID IN VARCHAR2,
                      F1      IN VARCHAR2,
                      F2      IN VARCHAR2,
                      F3      IN VARCHAR2,
                      F4      IN VARCHAR2,
                      FLAG    IN NUMBER,
                      TEXT    IN OUT VARCHAR2,
                      P_KEY   IN GSS_DASHBOARD_DETAIL.F_KEY%TYPE) IS
    V_NEWLINE VARCHAR2(3600);
  BEGIN
    IF FLAG = 1 THEN
      V_NEWLINE := '<li><span>' || F1 || '</span><span>' || F2 ||
                   '</span><span>' || F3 || '</span><span>' || F4 ||
                   '</span></li>';
      IF P_KEY = 0 THEN
        ADD_JAVA_SCRIPT(FILE_ID, V_NEWLINE);
      ELSE
        ADD_JAVA_SCRIPT(FILE_ID, V_NEWLINE, P_KEY);
      END IF;
      TEXT := '';
    ELSE
      TEXT := TEXT || '<li><span>' || F1 || '</span><span>' || F2 ||
              '</span><span>' || F3 || '</span><span>' || F4 ||
              '</span></li>' || CHR(10);
    END IF;
    --Pn_Gss_Dashboard_Write_Det(file_id,V_Newline,'A');
  
  END;
  PROCEDURE TABLEDATA(FILE_ID IN VARCHAR2,
                      F1      IN VARCHAR2,
                      F2      IN VARCHAR2,
                      F3      IN VARCHAR2,
                      F4      IN VARCHAR2,
                      F5      IN VARCHAR2,
                      FLAG    IN NUMBER,
                      TEXT    IN OUT VARCHAR2,
                      P_KEY   IN GSS_DASHBOARD_DETAIL.F_KEY%TYPE) IS
    V_NEWLINE VARCHAR2(3600);
  BEGIN
    IF FLAG = 1 THEN
      V_NEWLINE := '<li><span>' || F1 || '</span><span>' || F2 ||
                   '</span><span>' || F3 || '</span><span>' || F4 ||
                   '</span><span>' || F5 || '</span></li>';
      IF P_KEY = 0 THEN
        ADD_JAVA_SCRIPT(FILE_ID, V_NEWLINE);
      ELSE
        ADD_JAVA_SCRIPT(FILE_ID, V_NEWLINE, P_KEY);
      END IF;
      TEXT := '';
    ELSE
      TEXT := TEXT || '<li><span>' || F1 || '</span><span>' || F2 ||
              '</span><span>' || F3 || '</span><span>' || F4 ||
              '</span><span>' || F5 || '</span></li>' || CHR(10);
    END IF;
    --Pn_Gss_Dashboard_Write_Det(file_id,V_Newline,'A');
  
  END;
  PROCEDURE TABLEDATA(FILE_ID IN VARCHAR2,
                      F1      IN VARCHAR2,
                      F2      IN VARCHAR2,
                      F3      IN VARCHAR2,
                      F4      IN VARCHAR2,
                      F5      IN VARCHAR2,
                      F6      IN VARCHAR2,
                      FLAG    IN NUMBER,
                      TEXT    IN OUT VARCHAR2,
                      P_KEY   IN GSS_DASHBOARD_DETAIL.F_KEY%TYPE) IS
    V_NEWLINE VARCHAR2(3600);
  BEGIN
    IF FLAG = '1' THEN
      V_NEWLINE := '<li><span>' || F1 || '</span><span>' || F2 ||
                   '</span><span>' || F3 || '</span><span>' || F4 ||
                   '</span><span>' || F5 || '</span><span>' || F6 ||
                   '</span></li>';
      IF P_KEY = 0 THEN
        ADD_JAVA_SCRIPT(FILE_ID, V_NEWLINE);
      ELSE
        ADD_JAVA_SCRIPT(FILE_ID, V_NEWLINE, P_KEY);
      END IF;
      TEXT := '';
    ELSE
      TEXT := TEXT || '<li><span>' || F1 || '</span><span>' || F2 ||
              '</span><span>' || F3 || '</span><span>' || F4 ||
              '</span><span>' || F5 || '</span><span>' || F6 ||
              '</span></li>' || CHR(10);
    END IF;
    --Pn_Gss_Dashboard_Write_Det(file_id,text,'A');
  
  END;
  PROCEDURE TABLEDATA(FILE_ID IN VARCHAR2,
                      F1      IN VARCHAR2,
                      F2      IN VARCHAR2,
                      F3      IN VARCHAR2,
                      F4      IN VARCHAR2,
                      F5      IN VARCHAR2,
                      F6      IN VARCHAR2,
                      F7      IN VARCHAR2,
                      FLAG    IN NUMBER,
                      TEXT    IN OUT VARCHAR2,
                      P_KEY   IN GSS_DASHBOARD_DETAIL.F_KEY%TYPE) IS
    V_NEWLINE VARCHAR2(3600);
  BEGIN
    IF FLAG = '1' THEN
      V_NEWLINE := '<li><span>' || F1 || '</span><span>' || F2 ||
                   '</span><span>' || F3 || '</span><span>' || F4 ||
                   '</span><span>' || F5 || '</span><span>' || F6 ||
                   '</span><span>' || F7 || '</span></li>';
    
      IF P_KEY = 0 THEN
        ADD_JAVA_SCRIPT(FILE_ID, V_NEWLINE);
      ELSE
        ADD_JAVA_SCRIPT(FILE_ID, V_NEWLINE, P_KEY);
      END IF;
      TEXT := '';
    ELSE
      TEXT := TEXT || '<li><span>' || F1 || '</span><span>' || F2 ||
              '</span><span>' || F3 || '</span><span>' || F4 ||
              '</span><span>' || F5 || '</span><span>' || F6 ||
              '</span><span>' || F7 || '</span></li>' || CHR(10);
    END IF;
    --Pn_Gss_Dashboard_Write_Det(file_id,text,'A');
  
  END;
  PROCEDURE TABLEDATA(FILE_ID IN VARCHAR2,
                      F1      IN VARCHAR2,
                      F2      IN VARCHAR2,
                      F3      IN VARCHAR2,
                      F4      IN VARCHAR2,
                      F5      IN VARCHAR2,
                      F6      IN VARCHAR2,
                      F7      IN VARCHAR2,
                      F8      IN VARCHAR2,
                      FLAG    IN NUMBER,
                      TEXT    IN OUT VARCHAR2,
                      P_KEY   IN GSS_DASHBOARD_DETAIL.F_KEY%TYPE) IS
    V_NEWLINE VARCHAR2(3600);
  BEGIN
    IF FLAG = 1 THEN
      V_NEWLINE := '<li><span>' || F1 || '</span><span>' || F2 ||
                   '</span><span>' || F3 || '</span><span>' || F4 ||
                   '</span><span>' || F5 || '</span><span>' || F6 ||
                   '</span><span>' || F7 || '</span><span>' || F8 ||
                   '</span></li>';
      IF P_KEY = 0 THEN
        ADD_JAVA_SCRIPT(FILE_ID, V_NEWLINE);
      ELSE
        ADD_JAVA_SCRIPT(FILE_ID, V_NEWLINE, P_KEY);
      END IF;
      TEXT := '';
    ELSE
      TEXT := TEXT || '<li><span>' || F1 || '</span><span>' || F2 ||
              '</span><span>' || F3 || '</span><span>' || F4 ||
              '</span><span>' || F5 || '</span><span>' || F6 ||
              '</span><span>' || F7 || '</span><span>' || F8 ||
              '</span></li>' || CHR(10);
    END IF;
    --Pn_Gss_Dashboard_Write_Det(file_id,V_Newline,'A');
  
  END;
  PROCEDURE TABLEDATA(FILE_ID IN VARCHAR2,
                      F1      IN VARCHAR2,
                      F2      IN VARCHAR2,
                      F3      IN VARCHAR2,
                      F4      IN VARCHAR2,
                      F5      IN VARCHAR2,
                      F6      IN VARCHAR2,
                      F7      IN VARCHAR2,
                      F8      IN VARCHAR2,
                      F9      IN VARCHAR2,
                      FLAG    IN NUMBER,
                      TEXT    IN OUT VARCHAR2,
                      P_KEY   IN GSS_DASHBOARD_DETAIL.F_KEY%TYPE) IS
    V_NEWLINE VARCHAR2(3600);
  BEGIN
    IF FLAG = 1 THEN
      V_NEWLINE := '<li><span>' || F1 || '</span><span>' || F2 ||
                   '</span><span>' || F3 || '</span><span>' || F4 ||
                   '</span><span>' || F5 || '</span><span>' || F6 ||
                   '</span><span>' || F7 || '</span><span>' || F8 ||
                   '</span><span>' || F9 || '</span></li>';
      IF P_KEY = 0 THEN
        ADD_JAVA_SCRIPT(FILE_ID, V_NEWLINE);
      ELSE
        ADD_JAVA_SCRIPT(FILE_ID, V_NEWLINE, P_KEY);
      END IF;
      TEXT := '';
    ELSE
      TEXT := TEXT || '<li><span>' || F1 || '</span><span>' || F2 ||
              '</span><span>' || F3 || '</span><span>' || F4 ||
              '</span><span>' || F5 || '</span><span>' || F6 ||
              '</span><span>' || F7 || '</span><span>' || F8 ||
              '</span><span>' || F9 || '</span></li>' || CHR(10);
    END IF;
  
  END;
  PROCEDURE HEADER_TEXT(FILE_ID     IN VARCHAR2,
                        TEXT        IN OUT VARCHAR2,
                        HEADER_TYPE IN VARCHAR2) IS
    V_NEWLINE VARCHAR2(3600);
  BEGIN
    V_NEWLINE := '<br><' || HEADER_TYPE || '>' || TEXT || '</' ||
                 HEADER_TYPE || '>';
    PN_GSS_DASHBOARD_WRITE_DET(FILE_ID, V_NEWLINE, 'A');
    TEXT := '';
  END;
  PROCEDURE ADD_JAVA_SCRIPT(FILE_ID IN VARCHAR2, TEXT IN OUT VARCHAR2) IS
  
  BEGIN
    V_NEWLINE := q'{"<div class="tree"><a id="displayText" href="javascript:toggle('toggleText');">}' || TEXT ||
                 q'{</a><div onclick="javascript:toggle('toggleText');">"}';
    PN_GSS_DASHBOARD_WRITE_DET(FILE_ID, V_NEWLINE, 'A');
  END;
  PROCEDURE ADD_JAVA_SCRIPT(FILE_ID IN VARCHAR2,
                            TEXT    IN OUT VARCHAR2,
                            F_KEY   IN GSS_DASHBOARD_DETAIL.F_KEY%TYPE) IS
  
  BEGIN
  
    IF F_KEY = 0 THEN
      V_NEWLINE := q'{"<div class="tree"><a id="displayText" href="javascript:toggle('toggleText');">}' || TEXT ||
                   q'{</a> <== click Here<div onclick="javascript:toggle('toggleText');">"}';
    ELSE
      V_NEWLINE := q'{"<div class="tree"><a id="displayText" href="javascript:toggle('toggleText}' ||
 F_KEY || q'{');">}' || TEXT ||
                   q'{</a><div onclick="javascript:toggle('toggleText}' ||
 F_KEY || q'{');">"}';
    END IF;
    PN_GSS_DASHBOARD_WRITE_DET(FILE_ID, V_NEWLINE, 'A');
  END;
  PROCEDURE ADD_SUB_JAVA_SCRIPT(FILE_ID IN VARCHAR2, TEXT IN OUT VARCHAR2) IS
    V_NEWLINE VARCHAR2(3600);
  BEGIN
    V_NEWLINE := q'{<div id="toggleText" style="display:none; border-width:2px; border-style:solid">}' || TEXT ||
                 '</div>';
    PN_GSS_DASHBOARD_WRITE_DET(FILE_ID, V_NEWLINE, 'A');
  END;
  PROCEDURE ADD_SUB_JAVA_SCRIPT(FILE_ID IN VARCHAR2,
                                TEXT    IN OUT VARCHAR2,
                                F_KEY   IN GSS_DASHBOARD_DETAIL.F_KEY%TYPE) IS
    V_NEWLINE VARCHAR2(3600);
  BEGIN
  
    IF F_KEY = 0 THEN
      V_NEWLINE := q'{<div id="toggleText" style="display:none; border-width:2px; border-style:solid">}' || TEXT ||
                   '</div>';
    ELSE
      V_NEWLINE := q'{<div id="toggleText}' || F_KEY ||
                   q'{" style="display:none; border-width:2px; border-style:solid">}' || TEXT ||
                   '</div>';
    END IF;
    PN_GSS_DASHBOARD_WRITE_DET(FILE_ID, V_NEWLINE, 'A');
  END;
  PROCEDURE HTML_TRAILER(FILE_ID IN VARCHAR2) IS
  BEGIN
    TEXT := '</body>';
    PN_GSS_DASHBOARD_WRITE_DET(FILE_ID, TEXT, 'A');
    TEXT := '</html>';
    PN_GSS_DASHBOARD_WRITE_DET(FILE_ID, TEXT, 'A');
    TEXT := '';
  END;
END PKG_CREATE_HTML;
/
