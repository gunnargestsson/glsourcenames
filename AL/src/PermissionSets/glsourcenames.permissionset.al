permissionset 70009200 "O4NG/L-SOURCE NAMES"
{
    Access = Public;
    Assignable = true;
    Caption = 'Read G/L Source Names';
    Permissions = codeunit "O4N GL Show Source Card" = X,
                  codeunit "O4N GL SN Feature Notif." = X,
                  codeunit "O4N GL SN Notifications" = X,
                  codeunit "O4N GL SN Perm. Notif." = X,
                  page "O4N GL SNs DrillDown" = X,
                  tabledata "O4N GL SN" = R,
                  tabledata "O4N GL SN Setup" = R,
                  tabledata "O4N GL SN User Setup" = RIMD;
}
