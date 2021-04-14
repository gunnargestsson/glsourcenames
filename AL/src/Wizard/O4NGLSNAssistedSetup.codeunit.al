codeunit 70009215 "O4N GL SN Assisted Setup"
{

    trigger OnRun();
    begin
    end;

    var
        Setup: Record "O4N GL SN Setup";
        HelpResource: Record "O4N GL SN Help Resource";
        GLSourceNamesTxt: Label 'Set up G/L Source Names';
        GLSourceNamesShortTitleTxt: Label 'G/L Entry Details';
        GLSourceNamesDescTxt: Label 'Provice permission details and initalize the G/L Source Names lookup table.';
        RequiredPermissionMissingErr: Label 'You have not been granted required access rights to start the Assisted Setup.\\The Assisted Setup for G/L Source Names is about assigning the required permissions to users.  To be able to assign permissions you need to be granted either the SUPER og SECURITY permission set.';

    /// <summary> 
    /// Description for VerifyUserAccess.
    /// </summary>
    procedure VerifyUserAccess();
    var
        AccessControl: Record "Access Control";
    begin
        AccessControl.SETRANGE("User Security ID", USERSECURITYID());
        AccessControl.SETFILTER("Role ID", '%1|%2', 'SUPER', 'SECURITY');
        if AccessControl.ISEMPTY() then
            ERROR(RequiredPermissionMissingErr);
    end;

    /// <summary> 
    /// Description for OnRegisterAssistedSetup.
    /// </summary>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnRegisterAssistedSetup', '', true, false)]
    local procedure OnRegisterAssistedSetup();
    begin
        if not Setup.WRITEPERMISSION then exit;
        if not HelpResource.WRITEPERMISSION then exit;
        InitializeSetup();
        AddToAssistedSetup();
    end;

    /// <summary> 
    /// Description for InitializeSetup.
    /// </summary>
    local procedure InitializeSetup();
    begin
        if not Setup.Get() then begin
            Setup.INIT();
            Setup.INSERT();
        end;

        HelpResource.InitializeResources();
    end;

    /// <summary> 
    /// Description for AddToAssistedSetup.
    /// </summary>
    local procedure AddToAssistedSetup();
    var
        HelpResources: Record "O4N GL SN Help Resource";
        GuidedExperience: Codeunit "Guided Experience";
        AssistedSetupGroup: Enum "Assisted Setup Group";
        VideoCategory: Enum "Video Category";
        AboutTxt: Label 'Add the Source Name field to G/L Entries and a direct link to the source entity card.';
    begin
        Setup.GET();
        if not HelpResources.Get(HelpResources.GetSetupVideoCode()) then
            HelpResources.InitializeResources();
        HelpResources.Get(HelpResources.GetSetupVideoCode());
        GuidedExperience.InsertAssistedSetup(GLSourceNamesTxt, CopyStr(GLSourceNamesShortTitleTxt, 1, 50), GLSourceNamesDescTxt, 3,
            ObjectType::Page, PAGE::"O4N GL SN Setup Wizard", AssistedSetupGroup::Extensions, HelpResources.Url, VideoCategory::FinancialReporting, AboutTxt);
        if Setup.Status = Setup.Status::Completed then
            GuidedExperience.CompleteAssistedSetup(ObjectType::Page, PAGE::"O4N GL SN Setup Wizard");
    end;
}


