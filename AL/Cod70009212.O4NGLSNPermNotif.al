codeunit 70009212 "O4N GL SN Perm. Notif."
{

  trigger OnRun();
  begin
  end;

  var
    ShowAgainQst : Label 'Do you want to hide this notification in the future?';

  procedure ShowAssistedSetupToUser(MissingPermissionNotification : Notification);
  begin
    StartVideo('https://www.youtube.com/embed/h9qmD6AfqpQ');
  end;

  local procedure StartVideo(Url : Text);
  var
    VideoLink : Page "Video link";
    ClientTypeMgt : Codeunit ClientTypeManagement;
  begin
    if ClientTypeMgt.IsCommonWebClientType then begin
      VideoLink.SetURL(Url);
      VideoLink.RUNMODAL;
    end else
      HYPERLINK(Url);
  end;
}


