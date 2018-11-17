codeunit 70009211 "O4N GL SN Feature Notif."
{

  trigger OnRun();
  begin
  end;

  var
    ShowAgainQst : Label 'Do you want to hide this notification in the future?';

  procedure ShowDetailsToUser(NewFeatureNotification : Notification);
  begin
    StartVideo('https://www.youtube.com/embed/rTLPfA_GX0o');
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


