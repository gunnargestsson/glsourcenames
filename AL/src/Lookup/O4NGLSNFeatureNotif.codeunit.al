codeunit 70009211 "O4N GL SN Feature Notif."
{

    trigger OnRun();
    begin
    end;

    /// <summary> 
    /// Description for ShowDetailsToUser.
    /// </summary>
    /// <param name="NewFeatureNotification">Parameter of type Notification.</param>
    procedure ShowDetailsToUser(NewFeatureNotification: Notification);
    begin
        StartVideo('https://www.youtube.com/embed/rTLPfA_GX0o');
    end;

    /// <summary> 
    /// Description for StartVideo.
    /// </summary>
    /// <param name="Url">Parameter of type Text.</param>
    local procedure StartVideo(Url: Text);
    var
        Video: Codeunit Video;
    begin
        Video.Play(Url);
    end;
}


