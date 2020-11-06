codeunit 70009208 "O4N GL SN Upgrade"
{
    Subtype = Upgrade;
    trigger OnRun()
    begin

    end;

    trigger OnCheckPreconditionsPerCompany()
    begin

    end;

    trigger OnCheckPreconditionsPerDatabase()
    begin

    end;

    trigger OnUpgradePerCompany()
    begin
        UpgradeLookupTable();
    end;

    trigger OnUpgradePerDatabase()
    begin

    end;

    trigger OnValidateUpgradePerCompany()
    begin

    end;

    trigger OnValidateUpgradePerDatabase()
    begin

    end;

    local procedure UpgradeLookupTable()
    var
        GLSourceName: Record "O4N GL SN";
    begin
        if GLSourceName.FindSet() then
            repeat
                case GLSourceName."Source Type" of
                    GLSourceName."Source Type"::Customer:
                        GLSourceName."Item Ledger Source Type" := GLSourceName."Item Ledger Source Type"::Customer;
                    GLSourceName."Source Type"::Vendor:
                        GLSourceName."Item Ledger Source Type" := GLSourceName."Item Ledger Source Type"::Vendor;
                end;
                GLSourceName.Modify();
            until GLSourceName.Next() = 0;
    end;
}

