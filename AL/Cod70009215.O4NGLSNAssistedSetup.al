codeunit 70009215 "O4N GL SN Assisted Setup"
{

  trigger OnRun();
  begin
  end;

  var
    Setup : Record "O4N GL SN Setup";
    GLSourceNamesTxt : Label 'Set up G/L Source Names';
    HelpResource : Record "O4N GL SN Help Resource";
    RequiredPermissionMissingErr : Label 'You have not been granted required access rights to start the Assisted Setup.\\The Assisted Setup for G/L Source Names is about assigning the required permissions to users.  To be able to assign permissions you need to be granted either the SUPER og SECURITY permission set.';

  procedure VerifyUserAccess();
  var
    AccessControl : Record "Access Control";
  begin
    with AccessControl do begin
      SETRANGE("User Security ID",USERSECURITYID);
      SETFILTER("Role ID",'%1|%2','SUPER','SECURITY');
      if ISEMPTY then
        ERROR(RequiredPermissionMissingErr);
    end;
  end;

  [EventSubscriber(ObjectType::Table, 1808, 'OnRegisterAssistedSetup', '', true, false)]
  local procedure OnRegisterAssistedSetup(var TempAggregatedAssistedSetup : Record "Aggregated Assisted Setup" temporary);
  begin
    if not Setup.WRITEPERMISSION then exit;
    if not HelpResource.WRITEPERMISSION then exit;
    InitializeSetup;
    AddToAssistedSetup(TempAggregatedAssistedSetup);
  end;

  [EventSubscriber(ObjectType::Table, 1808, 'OnUpdateAssistedSetupStatus', '', true, false)]
  local procedure OnUpdateAssistedSetupStatus(var TempAggregatedAssistedSetup : Record "Aggregated Assisted Setup" temporary);
  begin
    Setup.GET;
    with TempAggregatedAssistedSetup do
      SetStatus(TempAggregatedAssistedSetup,PAGE::"O4N GL SN Setup Wizard",Setup.Status);
  end;

  local procedure InitializeSetup();
  begin
    with Setup do
      if ISEMPTY then begin
        INIT;
        INSERT;
      end else
        GET;

    with HelpResource do
      InitializeResources;
  end;

  local procedure AddToAssistedSetup(var TempAggregatedAssistedSetup : Record "Aggregated Assisted Setup" temporary);
  var
    TempBlob : Record TempBlob;
    GLSourceNameIcon : Codeunit "O4N GL SN Icon 240x240";
    InStr : InStream;
  begin
    with TempAggregatedAssistedSetup do begin
      GLSourceNameIcon.GetIcon(TempBlob);
      TempBlob.Blob.CREATEINSTREAM(InStr);
      InsertAssistedSetupIcon(HelpResource.Get240PXIconCode,InStr);

      AddExtensionAssistedSetup(
        PAGE::"O4N GL SN Setup Wizard",
        GLSourceNamesTxt,
        true,
        Setup.RECORDID,
        Setup.Status,
        HelpResource.Get240PXIconCode);
    end;
  end;
}


