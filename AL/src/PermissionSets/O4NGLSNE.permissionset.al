#pragma warning disable AS0011
permissionset 70009201 "O4N G/L-SN, E"
#pragma warning restore AS0011
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
