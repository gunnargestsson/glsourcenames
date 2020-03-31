codeunit 70009211 "O4N GL SN Feature Notif."
{

    trigger OnRun();
    begin
    end;

    var
        ShowAgainQst: Label 'Do you want to hide this notification in the future?';

    procedure ShowDetailsToUser(NewFeatureNotification: Notification);
    begin
        StartVideo('https://www.youtube.com/embed/rTLPfA_GX0o');
    end;

    local procedure StartVideo(Url: Text);
    var
        Video: Codeunit Video;
    begin
        Video.Play(Url);
    end;
}


