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
    var
        GLSourceNameMgt: Codeunit "O4N GL SN Mgt";
        archivedVersion: Text;
    begin
        archivedVersion := NAVAPP.GetArchiveVersion();
        case archivedVersion of
            '1.0.0.1':
                begin
                    NAVAPP.RESTOREARCHIVEDATA(DATABASE::"O4N GL SN Setup");
                    NAVAPP.RESTOREARCHIVEDATA(DATABASE::"O4N GL SN User Setup");
                    NAVAPP.DELETEARCHIVEDATA(DATABASE::"O4N GL SN");

                    NAVAPP.DELETEARCHIVEDATA(DATABASE::"O4N GL SN Help Resource");
                    NAVAPP.DELETEARCHIVEDATA(DATABASE::"O4N GL SN User Access");
                    NAVAPP.DELETEARCHIVEDATA(DATABASE::"O4N GL SN Group Access");

                    GLSourceNameMgt.PopulateSourceTable();
                end;
            '15.0.0.0':
                RecreateHelpResources();
        end;
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

    local procedure RecreateHelpResources()
    var
        HelpResources: Record "O4N GL SN Help Resource";
    begin
        HelpResources.DeleteAll();
        HelpResources.InitializeResources();
    end;
}

