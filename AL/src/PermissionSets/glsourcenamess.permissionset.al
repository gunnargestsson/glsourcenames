permissionset 70009202 "G/L-SOURCE NAMES, S"
{
    Access = Public;
    Assignable = true;
    Caption = 'Setup G/L Source Names';
    Permissions = codeunit "O4N GL SN App Mgt." = X,
                  codeunit "O4N GL SN Assisted Setup" = X,
                  codeunit "O4N GL SN Icon 150x150" = X,
                  codeunit "O4N GL SN Icon 240x240" = X,
                  codeunit "O4N GL SN Icon 250x250" = X,
                  codeunit "O4N GL SN Icon 417x417" = X,
                  codeunit "O4N GL SN Icon 70x70" = X,
                  codeunit "O4N GL SN Permission Mgt" = X,
                  page "O4N GL SN Setup" = X,
                  page "O4N GL SN Setup Wizard" = X,
                  tabledata "O4N GL SN" = RIMD,
                  tabledata "O4N GL SN Help Resource" = RIMD,
                  tabledata "O4N GL SN Setup" = RIMD;
}
