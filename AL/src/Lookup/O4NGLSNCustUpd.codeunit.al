codeunit 70009202 "O4N GL SN Cust Upd."
{

    trigger OnRun();
    begin
    end;

    var
        GLSourceNamesMgt: Codeunit "O4N GL SN Mgt";
        SourceType: Enum "Gen. Journal Source Type";

    [EventSubscriber(ObjectType::Table, database::Customer, 'OnAfterInsertEvent', '', true, false)]
    local procedure UpdateSourceNameOnCustomerInsert(var Rec: Record Customer; RunTrigger: Boolean);
    begin
        if Rec.ISTEMPORARY then exit;
        GLSourceNamesMgt.AddSource(SourceType::Customer, Rec."No.", Rec.Name);
    end;

    [EventSubscriber(ObjectType::Table, database::Customer, 'OnAfterDeleteEvent', '', true, false)]
    local procedure UpdateSourceNameOnCustomerDelete(var Rec: Record Customer; RunTrigger: Boolean);
    begin
        if Rec.ISTEMPORARY then exit;
        GLSourceNamesMgt.RemoveSource(SourceType::Customer, Rec."No.");
    end;

    [EventSubscriber(ObjectType::Table, database::Customer, 'OnAfterModifyEvent', '', true, false)]
    local procedure UpdateSourceNameOnCustomerModify(var Rec: Record Customer; var xRec: Record Customer; RunTrigger: Boolean);
    begin
        if Rec.ISTEMPORARY then exit;
        GLSourceNamesMgt.UpdateSource(SourceType::Customer, Rec."No.", Rec.Name);
    end;
}


