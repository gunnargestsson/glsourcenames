codeunit 70009210 "O4N GL SN Notifications"
{

    trigger OnRun();
    begin
    end;

    var
        GLSourceName: Record "O4N GL SN";
        NewFeatuerNotificationIdTxt: Label '1dd20373-27f8-4c68-a7b4-aab7ca199b98', Locked = true;
        NewFeatureMessageTxt: Label 'We have added a new feature to the General Ledger Entries.  Now you can see the Source Name column!';
        NewFeatureLinkTxt: Label 'Show me the details';
        MissingPermissionMessageTxt: Label 'You don''t have permissions to use our new feature that will show Source Names.  Please contact your administrator.';
        MissingPermissionLinkTxt: Label 'What should I show?';


    /// <summary> 
    /// Description for CatchGLEntriesOpenPage.
    /// </summary>
    [EventSubscriber(ObjectType::Page, Page::"General Ledger Entries", 'OnOpenPageEvent', '', true, true)]
    local procedure CatchGLEntriesOpenPage();
    var
        Setup: Record "O4N GL SN Setup";
        GLSourceNameUserSetup: Record "O4N GL SN User Setup";
    begin
        if not Setup.ReadPermission() then exit;
        if not Setup.Get() then exit;
        if Setup.Status <> Setup.Status::Completed then exit;
        if not GLSourceNameUserSetup.WRITEPERMISSION() then exit;
        if not GLSourceName.READPERMISSION() then
            NotifyOnMissingPermission()
        else
            NotifyOnNewFeature();
    end;

    /// <summary> 
    /// Description for NotifyOnMissingPermission.
    /// </summary>
    local procedure NotifyOnMissingPermission();
    var
        MissingPermissionNotification: Notification;
    begin
        if GetNotificationHasBeenShown(GetMissingPermissionNotificationId()) then exit;
        MissingPermissionNotification.ID := GetMissingPermissionNotificationId();
        MissingPermissionNotification.MESSAGE := MissingPermissionMessageTxt;
        MissingPermissionNotification.SCOPE := NOTIFICATIONSCOPE::LocalScope;
        MissingPermissionNotification.ADDACTION(MissingPermissionLinkTxt, CODEUNIT::"O4N GL SN Perm. Notif.", 'ShowAssistedSetupToUser');
        MissingPermissionNotification.SEND();
        SetNotificationHasBeenShown(GetMissingPermissionNotificationId());
    end;

    /// <summary> 
    /// Description for NotifyOnNewFeature.
    /// </summary>
    local procedure NotifyOnNewFeature();
    var
        NewFeatureNotification: Notification;
    begin
        if GetNotificationHasBeenShown(GetNewFeatuerNotificationId()) then exit;
        NewFeatureNotification.ID := GetNewFeatuerNotificationId();
        NewFeatureNotification.MESSAGE := NewFeatureMessageTxt;
        NewFeatureNotification.SCOPE := NOTIFICATIONSCOPE::LocalScope;
        NewFeatureNotification.ADDACTION(NewFeatureLinkTxt, CODEUNIT::"O4N GL SN Feature Notif.", 'ShowDetailsToUser');
        NewFeatureNotification.SEND();
        SetNotificationHasBeenShown(GetNewFeatuerNotificationId());
    end;

    /// <summary> 
    /// Description for GetMissingPermissionNotificationId.
    /// </summary>
    /// <returns>Return variable "Guid".</returns>
    procedure GetMissingPermissionNotificationId(): Guid;
    var
        MissingPermissionNotificationId: Guid;
    begin
        MissingPermissionNotificationId := '4fa8230a-53e5-4182-8423-373dc6f23f9d';
        exit(MissingPermissionNotificationId);
    end;

    /// <summary> 
    /// Description for GetNewFeatuerNotificationId.
    /// </summary>
    /// <returns>Return variable "Guid".</returns>
    procedure GetNewFeatuerNotificationId(): Guid;
    var
        NewFeatuerNotificationId: Guid;
    begin
        EVALUATE(NewFeatuerNotificationId, NewFeatuerNotificationIdTxt);
        exit(NewFeatuerNotificationId);
    end;

    /// <summary> 
    /// Description for GetNotificationHasBeenShown.
    /// </summary>
    /// <param name="NotificationId">Parameter of type Guid.</param>
    /// <returns>Return variable "Boolean".</returns>
    local procedure GetNotificationHasBeenShown(NotificationId: Guid): Boolean;
    var
        GLSourceNameUserSetup: Record "O4N GL SN User Setup";
    begin
        exit(GLSourceNameUserSetup.GET(USERSECURITYID(), NotificationId));
    end;

    /// <summary> 
    /// Description for SetNotificationHasBeenShown.
    /// </summary>
    /// <param name="NotificationId">Parameter of type Guid.</param>
    local procedure SetNotificationHasBeenShown(NotificationId: Guid);
    var
        GLSourceNameUserSetup: Record "O4N GL SN User Setup";
    begin
        GLSourceNameUserSetup."User Security ID" := USERSECURITYID();
        GLSourceNameUserSetup."Notification Id" := NotificationId;
        GLSourceNameUserSetup.INSERT();
    end;
}


