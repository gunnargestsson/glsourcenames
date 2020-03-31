codeunit 70009207 "O4N GL Source Name Install"
{
    Subtype = Install;
    trigger OnRun();
    begin
    end;

    var
        PermissionSetToSetupGLSourceNamesTxt: Label 'G/L-SOURCE NAMES, S', Locked = true;
        PermissionSetToUpdateGLSourceNamesTxt: Label 'G/L-SOURCE NAMES, E', Locked = true;
        PermissionSetToUserGLSourceNamesTxt: Label 'G/L-SOURCE NAMES', Locked = true;


    trigger OnInstallAppPerCompany();
    var
        GLSourceNameMgt: Codeunit "O4N GL SN Mgt";
    begin
        GLSourceNameMgt.PopulateSourceTable();
        RecreateHelpResources();
    end;

    trigger OnInstallAppPerDatabase();
    var
        AccessControl: Record "Access Control";
    begin
        with AccessControl do begin
            SETFILTER("Role ID", '%1|%2', 'SUPER', 'SECURITY');
            if FINDSET() then
                repeat
                    AddUserAccess("User Security ID", PermissionSetToUserGLSourceNamesTxt);
                    AddUserAccess("User Security ID", PermissionSetToUpdateGLSourceNamesTxt);
                    AddUserAccess("User Security ID", PermissionSetToSetupGLSourceNamesTxt);
                until NEXT() = 0;
        end;
    end;

    local procedure AddUserAccess(AssignToUser: Guid; PermissionSet: Code[20]);
    var
        AccessControl: Record "Access Control";
        AppMgt: Codeunit "O4N GL SN App Mgt.";
        AppGuid: Guid;
    begin
        EVALUATE(AppGuid, AppMgt.GetAppId());
        with AccessControl do begin
            INIT();
            "User Security ID" := AssignToUser;
            "App ID" := AppGuid;
            Scope := Scope::Tenant;
            "Role ID" := PermissionSet;
            if not FIND() then
                INSERT(true);
        end;
    end;

    local procedure RecreateHelpResources()
    var
        HelpResources: Record "O4N GL SN Help Resource";
    begin
        HelpResources.DeleteAll();
        HelpResources.InitializeResources();
    end;
}

