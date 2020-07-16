codeunit 70009210 "O4N GL SN Notifications"
{

    trigger OnRun();
    begin
    end;

    var
        GLSourceName: Record "O4N GL SN";
        GLSourceNameUserSetup: Record "O4N GL SN User Setup";
        NewFeatuerNotificationIdTxt: Label '1dd20373-27f8-4c68-a7b4-aab7ca199b98', Locked = true;
        NewFeatureMessageTxt: Label 'We have added a new feature to the General Ledger Entries.  Now you can see the Source Name column!';
        NewFeatureLinkTxt: Label 'Show me the details';
        MissingPermissionNotificationIdTxt: Label '4fa8230a-53e5-4182-8423-373dc6f23f9d', Locked = true;
        MissingPermissionMessageTxt: Label 'You don''t have permissions to use our new feature that will show Source Names.  Please contact your administrator.';
        MissingPermissionLinkTxt: Label 'What should I show?';


    [EventSubscriber(ObjectType::Page, Page::"General Ledger Entries", 'OnOpenPageEvent', '', true, true)]
    local procedure CatchGLEntriesOpenPage();
    var
        Setup: Record "O4N GL SN Setup";
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

    procedure GetMissingPermissionNotificationId(): Guid;
    var
        MissingPermissionNotificationId: Guid;
    begin
        EVALUATE(MissingPermissionNotificationId, MissingPermissionNotificationIdTxt);
        exit(MissingPermissionNotificationId);
    end;

    procedure GetNewFeatuerNotificationId(): Guid;
    var
        NewFeatuerNotificationId: Guid;
    begin
        EVALUATE(NewFeatuerNotificationId, NewFeatuerNotificationIdTxt);
        exit(NewFeatuerNotificationId);
    end;

    local procedure GetNotificationHasBeenShown(NotificationId: Guid): Boolean;
    begin
        exit(GLSourceNameUserSetup.GET(USERSECURITYID(), NotificationId));
    end;

    local procedure SetNotificationHasBeenShown(NotificationId: Guid);
    begin
        GLSourceNameUserSetup."User Security ID" := USERSECURITYID();
        GLSourceNameUserSetup."Notification Id" := NotificationId;
        GLSourceNameUserSetup.INSERT();
    end;
}


