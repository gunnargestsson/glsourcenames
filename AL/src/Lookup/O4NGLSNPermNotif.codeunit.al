codeunit 70009212 "O4N GL SN Perm. Notif."
{

    trigger OnRun();
    begin
    end;

    procedure ShowAssistedSetupToUser(MissingPermissionNotification: Notification);
    begin
        StartVideo('https://www.youtube.com/embed/h9qmD6AfqpQ');
    end;

    local procedure StartVideo(Url: Text);
    var
        Video: Codeunit Video;
    begin
        Video.Play(Url);
    end;
}


