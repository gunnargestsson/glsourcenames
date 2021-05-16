permissionset 70009201 "G/L-SOURCE NAMES, E"
{
    Access = Public;
    Assignable = true;
    Caption = 'Update G/L Source Names';
    Permissions = codeunit "O4N GL SN Bank Upd." = X,
                  codeunit "O4N GL SN Cust Upd." = X,
                  codeunit "O4N GL SN FxdAsset Upd." = X,
                  codeunit "O4N GL SN Mgt" = X,
                  codeunit "O4N GL SN Vend Upd." = X,
                  page "O4N GL SN List" = X,
                  page "O4N GL SN Setup" = X,
                  tabledata "O4N GL SN" = imd,
                  tabledata "O4N GL SN Setup" = R;
}
