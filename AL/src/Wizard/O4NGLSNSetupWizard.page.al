﻿page 70009210 "O4N GL SN Setup Wizard"
{

    Caption = 'G/L Source Name Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = NavigatePage;
    SourceTable = "O4N GL SN Setup";
    SourceTableTemporary = true;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            group(Group96)
            {
                Editable = false;
                Visible = TopBannerVisible AND NOT FinalStepVisible;
                field(MediaRepositoryStandard; MediaRepositoryStandard.Image)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ShowCaption = false;
                    ToolTip = 'Specifies the wizard logo.';
                }
            }
            group(Group98)
            {
                Editable = false;
                Visible = TopBannerVisible AND FinalStepVisible;
                field(MediaRepositoryDone; MediaRepositoryDone.Image)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ShowCaption = false;
                    ToolTip = 'Specifies the wizard logo.';
                }
            }
            group(Group20)
            {
                Visible = FirstStepVisible;
                group("Welcome to G/L Source Name Setup")
                {
                    Caption = 'Welcome to G/L Source Name Setup';
                    group(Group18)
                    {
                        ShowCaption = false;
                        InstructionalText = 'To be able to use Source Names on G/L Entries, users must have required permissions.';
                    }
                    group(Group19)
                    {
                        ShowCaption = false;
                        InstructionalText = 'Users that can update master tables, like; Customer, Vendor, Bank Account, Fixed Asset and Employee, must be able to update the G/L Source Name lookup table.';
                    }
                }
                group("Let's go!")
                {
                    Caption = 'Let''s go!';
                    group(Group70009201)
                    {
                        ShowCaption = false;
                        InstructionalText = 'Choose Set Defaults and all required permissions will be automatically assigned to user group members and users based on current permissions to the G/L Entries and the above master tables.';
                    }
                    group(Group22)
                    {
                        ShowCaption = false;
                        InstructionalText = 'Choose Next so you can manually set up permissions for users and groups.';
                    }
                }
            }
            group(Group2)
            {
                InstructionalText = 'Check the Assign or Remove Permisson Box to change read permission for the user group members';
                Visible = UserGroupReadVisible;
                part(GroupsWithReadAccess; "O4N GL SN Group ListPart")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'User Groups requiring read access';
                    SubPageView = WHERE("Permission Level" = CONST(Read));
                }
            }
            group(Group1000000002)
            {
                InstructionalText = 'Check the Assign or Remove Permisson Box to change both read and update permission for the user group members';
                Visible = UserGroupUpdateVisible;
                part(GroupsWithUpdateAccess; "O4N GL SN Group ListPart")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'User Groups requiring update access';
                    SubPageView = WHERE("Permission Level" = CONST(Update));
                }
            }
            group(Group1000000007)
            {
                InstructionalText = 'Check the Assign or Remove Permisson Box to change read permission for the user.  User Group members should be managed through the user group only.';
                Visible = UserReadVisible;
                part(UsersWithReadAccess; "O4N GL SN Users ListPart")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Users requiring read access';
                    SubPageView = WHERE("Permission Level" = CONST(Read));
                }
            }
            group(Group1000000005)
            {
                InstructionalText = 'Check the Assign or Remove Permisson Box to change both read and update permission for the user.  User Group members should be managed through the user group only';
                Visible = UserUpdateVisible;
                part(UsersWithUpdateAccess; "O4N GL SN Users ListPart")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Users requiring update access';
                    SubPageView = WHERE("Permission Level" = CONST(Update));
                }
            }
            group(Group12)
            {
                Visible = RegistrationVisible;
                group(Group27)
                {
                    ShowCaption = false;
                    InstructionalText = 'Enter the Registration details.';
                    field("Registration E-Mail Address"; Rec."Registration E-Mail Address")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Your registration will only be stored in Dynamics365.  Your E-Mail Address is not shared with anyone.';
                    }
                }
            }
            group(Group17)
            {
                Visible = FinalStepVisible;
                group(Group70009203)
                {
                    ShowCaption = false;
                    InstructionalText = 'We suggest that you refresh the data in G/L Source Names lookup table before finishing this wizard.  You can come back here any time to refresh the lookup table again';
                }
                group("That's it!")
                {
                    Caption = 'That''s it!';
                    group(Group23)
                    {
                        ShowCaption = false;
                        InstructionalText = 'To refresh the data in the G/L Source Name lookup table, choose Update G/L Source Names.';
                    }
                    group(Group25)
                    {
                        ShowCaption = false;
                        InstructionalText = 'To enable Source Names in G/L Entries, choose Finish.';
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ActionBack)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Back';
                Enabled = BackActionEnabled;
                Image = PreviousRecord;
                InFooterBar = true;
                ToolTip = 'Return to the previous page.';

                trigger OnAction();
                begin
                    NextStep(true);
                end;
            }
            action(ActionNext)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Next';
                Enabled = NextActionEnabled;
                Image = NextRecord;
                InFooterBar = true;
                ToolTip = 'Move to next page.';

                trigger OnAction();
                begin
                    case Step of
                        Step::Registration:
                            if Rec."Registration E-Mail Address" = '' then
                                ERROR(RegistrationEMailAddressMissingErr);
                    end;

                    NextStep(false);
                end;
            }
            action(ActionDefault)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Set Defaults';
                Enabled = FirstStepVisible;
                Image = Default;
                InFooterBar = true;
                ToolTip = 'Updates Permissions to all users and user groups as suggested';

                trigger OnAction();
                var
                    CompanyInformation: Record "Company Information";
                    PermissionMgt: Codeunit "O4N GL SN Permission Mgt";
                begin
                    LogMessage('GL0001', 'Installation Wizard Default Setup', Verbosity::Normal, DATACLASSIFICATION::OrganizationIdentifiableInformation, TelemetryScope::ExtensionPublisher, 'result', 'success');
                    PermissionMgt.SuggestAccessControl(TempUserAccess, TempGroupAccess);
                    if Rec."Registration E-Mail Address" = '' then
                        if CompanyInformation.GET() then
                            Rec."Registration E-Mail Address" := CopyStr(CompanyInformation."E-Mail", 1, MaxStrLen(Rec."Registration E-Mail Address"));

                    if Rec."Registration E-Mail Address" = '' then
                        Step := Step::Registration
                    else
                        Step := Step::Finish;
                    EnableControls();
                end;
            }
            action(ActionUpdateSourceLookup)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Update G/L Source Names';
                Enabled = FinishActionEnabled;
                Image = Card;
                InFooterBar = true;
                ToolTip = 'This action will update the G/L Source Names lookup table';

                trigger OnAction();
                var
                    GLSourceNameMgt: Codeunit "O4N GL SN Mgt";
                begin
                    LogMessage('GL0001', 'Installation Wizard Lookup Update', Verbosity::Normal, DATACLASSIFICATION::OrganizationIdentifiableInformation, TelemetryScope::ExtensionPublisher, 'result', 'success');
                    GLSourceNameMgt.Refresh(false);
                end;
            }
            action(ActionFinish)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Finish';
                Enabled = FinishActionEnabled;
                Image = Approve;
                InFooterBar = true;
                ToolTip = 'Apply configuration and exit the wizard.';

                trigger OnAction();
                begin
                    FinishAction();
                end;
            }
        }
    }

    trigger OnInit();
    begin
        LoadTopBanners();
    end;

    trigger OnOpenPage();
    var
        Setup: Record "O4N GL SN Setup";
        PermissionMgt: Codeunit "O4N GL SN Permission Mgt";
        AssistedSetupMgt: Codeunit "O4N GL SN Assisted Setup";
    begin
        LogMessage('GL0001', 'Installation Wizard Started', Verbosity::Normal, DATACLASSIFICATION::OrganizationIdentifiableInformation, TelemetryScope::ExtensionPublisher, 'result', 'success');
        AssistedSetupMgt.VerifyUserAccess();
        Rec.INIT();
        if not Setup.GET() then begin
            Setup.INIT();
            Setup.INSERT();
        end;
        Rec.TRANSFERFIELDS(Setup);
        Rec.INSERT();

        PermissionMgt.GetAccessControl(TempUserAccess, TempGroupAccess);
        CurrPage.GroupsWithReadAccess.PAGE.Set(TempGroupAccess, TempUserAccess);
        CurrPage.GroupsWithUpdateAccess.PAGE.Set(TempGroupAccess, TempUserAccess);
        CurrPage.UsersWithReadAccess.PAGE.Set(TempUserAccess);
        CurrPage.UsersWithUpdateAccess.PAGE.Set(TempUserAccess);

        Step := Step::Start;
        EnableControls();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean;
    begin
        if CloseAction = ACTION::OK then
            if Rec.Status = Rec.Status::"Not Completed" then begin
                if not CONFIRM(NAVNotSetUpQst, false) then
                    ERROR('')
                else
                    LogMessage('GL0001', 'Installation Wizard Canceled', Verbosity::Normal, DATACLASSIFICATION::OrganizationIdentifiableInformation, TelemetryScope::ExtensionPublisher, 'result', 'success');
            end else
                LogMessage('GL0001', 'Installation Wizard Finished', Verbosity::Normal, DATACLASSIFICATION::OrganizationIdentifiableInformation, TelemetryScope::ExtensionPublisher, 'result', 'success');
    end;

    var
        MediaRepositoryStandard: Record "Media Repository";
        MediaRepositoryDone: Record "Media Repository";
        TempUserAccess: Record "O4N GL SN User Access" temporary;
        TempGroupAccess: Record "O4N GL SN Group Access" temporary;
        Step: Option Start,UserGroupRead,UserGroupUpdate,UserRead,UserUpdate,Registration,Finish;
        TopBannerVisible: Boolean;
        FirstStepVisible: Boolean;
        UserGroupReadVisible: Boolean;
        UserGroupUpdateVisible: Boolean;
        UserReadVisible: Boolean;
        UserUpdateVisible: Boolean;
        RegistrationVisible: Boolean;
        FinalStepVisible: Boolean;
        UserGroupReadEnabled: Boolean;
        UserGroupUpdateEnabled: Boolean;
        UserReadEnabled: Boolean;
        UserUpdateEnabled: Boolean;
        FinishActionEnabled: Boolean;
        BackActionEnabled: Boolean;
        NextActionEnabled: Boolean;
        NAVNotSetUpQst: Label 'G/L Source Names have not been set up.\\Are you sure you want to exit?';
        RegistrationEMailAddressMissingErr: Label 'Registration E-Mail Address is missing';

    /// <summary> 
    /// Description for EnableControls.
    /// </summary>
    local procedure EnableControls();
    begin
        ResetControls();

        case Step of
            Step::Start:
                ShowStartStep();
            Step::UserGroupRead:
                ShowUserGroupReadStep();
            Step::UserGroupUpdate:
                ShowUserGroupUpdateStup();
            Step::UserRead:
                ShowUserReadStep();
            Step::UserUpdate:
                ShowUserUpdateSetup();
            Step::Registration:
                ShowRegistrationStep();
            Step::Finish:
                ShowFinishStep();
        end;
    end;

    /// <summary> 
    /// Description for FinishAction.
    /// </summary>
    local procedure FinishAction();
    begin
        StoreSetup();
        StoreAccessControl();
        CurrPage.CLOSE();
    end;

    /// <summary> 
    /// Description for NextStep.
    /// </summary>
    /// <param name="Backwards">Parameter of type Boolean.</param>
    local procedure NextStep(Backwards: Boolean);
    begin
        if Backwards then begin
            Step := Step - 1;
            if not StepEnabled() then
                NextStep(Backwards);
        end else begin
            Step := Step + 1;
            if not StepEnabled() then
                NextStep(Backwards);
        end;

        EnableControls();
    end;

    /// <summary> 
    /// Description for StepEnabled.
    /// </summary>
    /// <returns>Return variable "Boolean".</returns>
    local procedure StepEnabled(): Boolean;
    begin
        case Step of
            Step::Start:
                exit(true);
            Step::UserGroupRead:
                exit(UserGroupReadEnabled);
            Step::UserGroupUpdate:
                exit(UserGroupUpdateEnabled);
            Step::UserRead:
                exit(UserReadEnabled);
            Step::UserUpdate:
                exit(UserUpdateEnabled);
            Step::Registration:
                exit(true);
            Step::Finish:
                exit(true);
        end;
    end;

    /// <summary> 
    /// Description for ShowStartStep.
    /// </summary>
    local procedure ShowStartStep();
    begin
        FirstStepVisible := true;
        FinishActionEnabled := false;
        BackActionEnabled := false;
    end;

    /// <summary> 
    /// Description for ShowUserGroupReadStep.
    /// </summary>
    local procedure ShowUserGroupReadStep();
    begin
        UserGroupReadVisible := true;
        BackActionEnabled := true;
    end;

    /// <summary> 
    /// Description for ShowUserGroupUpdateStup.
    /// </summary>
    local procedure ShowUserGroupUpdateStup();
    begin
        UserGroupUpdateVisible := true;
        BackActionEnabled := true;
    end;

    /// <summary> 
    /// Description for ShowUserReadStep.
    /// </summary>
    local procedure ShowUserReadStep();
    begin
        UserReadVisible := true;
        BackActionEnabled := true;
    end;

    /// <summary> 
    /// Description for ShowUserUpdateSetup.
    /// </summary>
    local procedure ShowUserUpdateSetup();
    begin
        UserUpdateVisible := true;
        BackActionEnabled := true;
    end;

    /// <summary> 
    /// Description for ShowRegistrationStep.
    /// </summary>
    local procedure ShowRegistrationStep();
    begin
        RegistrationVisible := true;
        BackActionEnabled := true;
    end;

    /// <summary> 
    /// Description for ShowFinishStep.
    /// </summary>
    local procedure ShowFinishStep();
    begin
        FinalStepVisible := true;
        NextActionEnabled := false;
    end;

    /// <summary> 
    /// Description for ResetControls.
    /// </summary>
    local procedure ResetControls();
    begin
        FinishActionEnabled := Rec."Registration E-Mail Address" <> '';
        BackActionEnabled := true;
        NextActionEnabled := true;

        FirstStepVisible := false;
        UserGroupReadVisible := false;
        UserGroupUpdateVisible := false;
        UserReadVisible := false;
        UserUpdateVisible := false;
        RegistrationVisible := false;
        FinalStepVisible := false;

        TempUserAccess.SETRANGE("Permission Level", TempUserAccess."Permission Level"::Read);
        UserReadEnabled := not Rec.IsEmpty();
        TempUserAccess.SETRANGE("Permission Level", TempUserAccess."Permission Level"::Update);
        UserUpdateEnabled := not Rec.IsEmpty();
        TempUserAccess.SETRANGE("Permission Level");

        TempGroupAccess.SETRANGE("Permission Level", TempGroupAccess."Permission Level"::Read);
        UserGroupReadEnabled := not Rec.IsEmpty();
        TempGroupAccess.SETRANGE("Permission Level", TempGroupAccess."Permission Level"::Update);
        UserGroupUpdateEnabled := not Rec.IsEmpty();
        TempGroupAccess.SETRANGE("Permission Level");
    end;

    /// <summary> 
    /// Description for StoreSetup.
    /// </summary>
    local procedure StoreSetup();
    var
        Setup: Record "O4N GL SN Setup";
        GuidedExperiance: Codeunit "Guided Experience";
    begin
        Rec.Status := Rec.Status::Completed;
        Setup.GET();
        Setup.TRANSFERFIELDS(Rec);
# pragma warning disable        
        Setup.MODIFY();
# pragma warning restore        
        GuidedExperiance.CompleteAssistedSetup(ObjectType::Page,page::"O4N GL SN Setup Wizard");
    end;

    /// <summary> 
    /// Description for StoreAccessControl.
    /// </summary>
    local procedure StoreAccessControl();
    var
        PermissionMgt: Codeunit "O4N GL SN Permission Mgt";
    begin
        PermissionMgt.SetAccessControl(TempUserAccess, TempGroupAccess);
    end;

    /// <summary> 
    /// Description for LoadTopBanners.
    /// </summary>
    local procedure LoadTopBanners();
    begin
        if MediaRepositoryStandard.GET('AssistedSetup-NoText-400px.png', FORMAT(CURRENTCLIENTTYPE)) and
           MediaRepositoryDone.GET('AssistedSetupDone-NoText-400px.png', FORMAT(CURRENTCLIENTTYPE))
        then
            TopBannerVisible := MediaRepositoryDone.Image.HASVALUE;
    end;
}


