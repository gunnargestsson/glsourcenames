codeunit 70009215 "O4N GL SN Assisted Setup"
{

    trigger OnRun();
    begin
    end;

    var
        Setup: Record "O4N GL SN Setup";
        GLSourceNamesTxt: Label 'Set up G/L Source Names';
        HelpResource: Record "O4N GL SN Help Resource";
        RequiredPermissionMissingErr: Label 'You have not been granted required access rights to start the Assisted Setup.\\The Assisted Setup for G/L Source Names is about assigning the required permissions to users.  To be able to assign permissions you need to be granted either the SUPER og SECURITY permission set.';

    procedure VerifyUserAccess();
    var
        AccessControl: Record "Access Control";
    begin
        with AccessControl do begin
            SETRANGE("User Security ID", USERSECURITYID);
            SETFILTER("Role ID", '%1|%2', 'SUPER', 'SECURITY');
            if ISEMPTY then
                ERROR(RequiredPermissionMissingErr);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Assisted Setup", 'OnRegister', '', true, false)]
    local procedure OnRegisterAssistedSetup();
    begin
        if not Setup.WRITEPERMISSION then exit;
        if not HelpResource.WRITEPERMISSION then exit;
        InitializeSetup;
        AddToAssistedSetup();
    end;

    local procedure InitializeSetup();
    begin
        with Setup do
            if ISEMPTY then begin
                INIT;
                INSERT;
            end else
                GET;

        with HelpResource do
            InitializeResources;
    end;

    local procedure AddToAssistedSetup();
    var
        AssistedSetup: Codeunit "Assisted Setup";
        AppMgt: Codeunit "O4N GL SN App Mgt.";
        AssistedSetupGroup: Enum "Assisted Setup Group";
    begin
        Setup.GET;
        AssistedSetup.Add(AppMgt.GetAppId(), PAGE::"O4N GL SN Setup Wizard", GLSourceNamesTxt, AssistedSetupGroup::Extensions);
        if Setup.Status = Setup.Status::Completed then
            AssistedSetup.Complete(AppMgt.GetAppId(), PAGE::"O4N GL SN Setup Wizard");
    end;
}


