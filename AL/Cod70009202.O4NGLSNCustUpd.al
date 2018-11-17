codeunit 70009202 "O4N GL SN Cust Upd."
{

  trigger OnRun();
  begin
  end;

  var
    GLSourceNamesMgt : Codeunit "O4N GL SN Mgt";
    SourceType : Option " ",Customer,Vendor,"Bank Account","Fixed Asset",Employee;

  [EventSubscriber(ObjectType::Table, 18, 'OnAfterInsertEvent', '', true, false)]
  local procedure UpdateSourceNameOnCustomerInsert(var Rec : Record Customer;RunTrigger : Boolean);
  begin
    if Rec.ISTEMPORARY then exit;
    GLSourceNamesMgt.AddSource(SourceType::Customer,Rec."No.",Rec.Name);
  end;

  [EventSubscriber(ObjectType::Table, 18, 'OnAfterDeleteEvent', '', true, false)]
  local procedure UpdateSourceNameOnCustomerDelete(var Rec : Record Customer;RunTrigger : Boolean);
  begin
    if Rec.ISTEMPORARY then exit;
    GLSourceNamesMgt.RemoveSource(SourceType::Customer,Rec."No.");
  end;

  [EventSubscriber(ObjectType::Table, 18, 'OnAfterModifyEvent', '', true, false)]
  local procedure UpdateSourceNameOnCustomerModify(var Rec : Record Customer;var xRec : Record Customer;RunTrigger : Boolean);
  begin
    if Rec.ISTEMPORARY then exit;
    GLSourceNamesMgt.UpdateSource(SourceType::Customer,Rec."No.",Rec.Name);
  end;
}


