codeunit 70009204 "O4N GL SN Bank Upd."
{

  trigger OnRun();
  begin
  end;

  var
    GLSourceNamesMgt : Codeunit "O4N GL SN Mgt";
    SourceType : Option " ",Customer,Vendor,"Bank Account","Fixed Asset",Employee;

  [EventSubscriber(ObjectType::Table, 270, 'OnAfterInsertEvent', '', true, false)]
  local procedure UpdateSourceNameOnBankAccInsert(var Rec : Record "Bank Account";RunTrigger : Boolean);
  begin
    if Rec.ISTEMPORARY then exit;
    GLSourceNamesMgt.AddSource(SourceType::"Bank Account",Rec."No.",Rec.Name);
  end;

  [EventSubscriber(ObjectType::Table, 270, 'OnAfterDeleteEvent', '', true, false)]
  local procedure UpdateSourceNameOnBankAccDelete(var Rec : Record "Bank Account";RunTrigger : Boolean);
  begin
    if Rec.ISTEMPORARY then exit;
    GLSourceNamesMgt.RemoveSource(SourceType::"Bank Account",Rec."No.");
  end;

  [EventSubscriber(ObjectType::Table, 270, 'OnAfterModifyEvent', '', true, false)]
  local procedure UpdateSourceNameOnBankAccModify(var Rec : Record "Bank Account";var xRec : Record "Bank Account";RunTrigger : Boolean);
  begin
    if Rec.ISTEMPORARY then exit;
    GLSourceNamesMgt.UpdateSource(SourceType::"Bank Account",Rec."No.",Rec.Name);
  end;
}


