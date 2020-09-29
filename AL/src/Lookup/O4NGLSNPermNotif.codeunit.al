codeunit 70009212 "O4N GL SN Perm. Notif."
{

    trigger OnRun();
    begin
    end;

    /// <summary> 
    /// Description for ShowAssistedSetupToUser.
    /// </summary>
    /// <param name="MissingPermissionNotification">Parameter of type Notification.</param>
    procedure ShowAssistedSetupToUser(MissingPermissionNotification: Notification);
    begin
        StartVideo('https://www.youtube.com/embed/h9qmD6AfqpQ');
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


