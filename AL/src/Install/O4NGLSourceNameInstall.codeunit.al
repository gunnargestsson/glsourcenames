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
        AccessControl.SETFILTER("Role ID", '%1|%2', 'SUPER', 'SECURITY');
        if AccessControl.FINDSET() then
            repeat
                AddUserAccess(AccessControl."User Security ID", PermissionSetToUserGLSourceNamesTxt);
                AddUserAccess(AccessControl."User Security ID", PermissionSetToUpdateGLSourceNamesTxt);
                AddUserAccess(AccessControl."User Security ID", PermissionSetToSetupGLSourceNamesTxt);
            until AccessControl.NEXT() = 0;
    end;

    /// <summary> 
    /// Description for AddUserAccess.
    /// </summary>
    /// <param name="AssignToUser">Parameter of type Guid.</param>
    /// <param name="PermissionSet">Parameter of type Code[20].</param>
    local procedure AddUserAccess(AssignToUser: Guid; PermissionSet: Code[20]);
    var
        AccessControl: Record "Access Control";
        AppMgt: Codeunit "O4N GL SN App Mgt.";
        AppGuid: Guid;
    begin
        EVALUATE(AppGuid, AppMgt.GetAppId());
        AccessControl.INIT();
        AccessControl."User Security ID" := AssignToUser;
        AccessControl."App ID" := AppGuid;
        AccessControl.Scope := AccessControl.Scope::Tenant;
        AccessControl."Role ID" := PermissionSet;
        if not AccessControl.FIND() then
            AccessControl.INSERT(true);
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

