codeunit 70009207 "O4N GL Source Name Install"
{
    Subtype = Install;
    trigger OnRun();
    begin
    end;


    trigger OnInstallAppPerCompany();
    var
        GLSourceNameMgt: Codeunit "O4N GL SN Mgt";
    begin
        GLSourceNameMgt.PopulateSourceTable();
        RecreateHelpResources();
    end;

    trigger OnInstallAppPerDatabase();
    begin

    end;


    /// <summary> 
    /// Description for RecreateHelpResources.
    /// </summary>
    local procedure RecreateHelpResources()
    var
        HelpResources: Record "O4N GL SN Help Resource";
    begin
        HelpResources.DeleteAll();
        HelpResources.InitializeResources();
    end;
}

