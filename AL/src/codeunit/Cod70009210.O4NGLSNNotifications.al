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
        MissingPermissionNotificationIdTxt: Label '4fa8230a-53e5-4182-8423-373dc6f23f9d', Locked = true;
        MissingPermissionMessageText: Label 'You don''t have permissions to use our new feature that will show Source Names.  Please contact your administrator.';
        MissingPermissionLinkTxt: Label 'What should I show?';
        GLSourceNameUserSetup: Record "O4N GL SN User Setup";

    [EventSubscriber(ObjectType::Page, Page::"General Ledger Entries", 'OnOpenPageEvent', '', true, true)]
    local procedure CatchGLEntriesOpenPage(var Rec: Record "G/L Entry");
    var
        Setup: Record "O4N GL SN Setup";
    begin
        if not Setup.ReadPermission() then exit;
        if not Setup.Get() then exit;
        if Setup.Status <> Setup.Status::Completed then exit;
        if not GLSourceNameUserSetup.WRITEPERMISSION() then exit;
        if not GLSourceName.READPERMISSION() then
            NotifyOnMissingPermission(Rec)
        else
            NotifyOnNewFeature(Rec);
    end;

    local procedure NotifyOnMissingPermission(var Rec: Record "G/L Entry");
    var
        MissingPermissionNotification: Notification;
    begin
        if GetNotificationHasBeenShown(GetMissingPermissionNotificationId) then exit;
        with MissingPermissionNotification do begin
            ID := GetMissingPermissionNotificationId;
            MESSAGE := MissingPermissionMessageText;
            SCOPE := NOTIFICATIONSCOPE::LocalScope;
            ADDACTION(MissingPermissionLinkTxt, CODEUNIT::"O4N GL SN Perm. Notif.", 'ShowAssistedSetupToUser');
            SEND;
        end;
        SetNotificationHasBeenShown(GetMissingPermissionNotificationId);
    end;

    local procedure NotifyOnNewFeature(var Rec: Record "G/L Entry");
    var
        NewFeatureNotification: Notification;
    begin
        if GetNotificationHasBeenShown(GetNewFeatuerNotificationId) then exit;
        with NewFeatureNotification do begin
            ID := GetNewFeatuerNotificationId;
            MESSAGE := NewFeatureMessageTxt;
            SCOPE := NOTIFICATIONSCOPE::LocalScope;
            ADDACTION(NewFeatureLinkTxt, CODEUNIT::"O4N GL SN Feature Notif.", 'ShowDetailsToUser');
            SEND;
        end;
        SetNotificationHasBeenShown(GetNewFeatuerNotificationId);
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
        with GLSourceNameUserSetup do
            exit(GET(USERSECURITYID, NotificationId));
    end;

    local procedure SetNotificationHasBeenShown(NotificationId: Guid);
    begin
        with GLSourceNameUserSetup do begin
            "User Security ID" := USERSECURITYID;
            "Notification Id" := NotificationId;
            INSERT;
        end;
    end;
}


