codeunit 70009209 "O4N GL SN Empl Upd."
{

  trigger OnRun();
  begin
  end;

  var
    GLSourceNamesMgt : Codeunit "O4N GL SN Mgt";
    SourceType : Option " ",Customer,Vendor,"Bank Account","Fixed Asset",Employee;

  [EventSubscriber(ObjectType::Table, 5200, 'OnAfterInsertEvent', '', true, false)]
  local procedure UpdateSourceNameOnFixedAssetInsert(var Rec : Record Employee;RunTrigger : Boolean);
  begin
    if Rec.ISTEMPORARY then exit;
    GLSourceNamesMgt.AddSource(SourceType::Employee,Rec."No.",CopyStr(Rec.FullName(),1,50));
  end;

  [EventSubscriber(ObjectType::Table, 5200, 'OnAfterDeleteEvent', '', true, false)]
  local procedure UpdateSourceNameOnFixedAssetDelete(var Rec : Record Employee;RunTrigger : Boolean);
  begin
    if Rec.ISTEMPORARY then exit;
    GLSourceNamesMgt.RemoveSource(SourceType::Employee,Rec."No.");
  end;

  [EventSubscriber(ObjectType::Table, 5200, 'OnAfterModifyEvent', '', true, false)]
  local procedure UpdateSourceNameOnFixedAssetModify(var Rec : Record Employee;var xRec : Record Employee;RunTrigger : Boolean);
  begin
    if Rec.ISTEMPORARY then exit;
    GLSourceNamesMgt.UpdateSource(SourceType::Employee,Rec."No.",CopyStr(Rec.FullName(),1,50));
  end;
}


