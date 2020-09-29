codeunit 70009202 "O4N GL SN Cust Upd."
{

    trigger OnRun();
    begin
    end;

    var
        GLSourceNamesMgt: Codeunit "O4N GL SN Mgt";
        SourceType: Enum "Gen. Journal Source Type";

    /// <summary> 
    /// Description for UpdateSourceNameOnCustomerInsert.
    /// </summary>
    /// <param name="Rec">Parameter of type Record Customer.</param>
    /// <param name="RunTrigger">Parameter of type Boolean.</param>
    [EventSubscriber(ObjectType::Table, database::Customer, 'OnAfterInsertEvent', '', true, false)]
    local procedure UpdateSourceNameOnCustomerInsert(var Rec: Record Customer; RunTrigger: Boolean);
    begin
        if Rec.IsTemporary() then exit;
        GLSourceNamesMgt.AddSource(SourceType::Customer, Rec."No.", Rec.Name);
    end;

    /// <summary> 
    /// Description for UpdateSourceNameOnCustomerDelete.
    /// </summary>
    /// <param name="Rec">Parameter of type Record Customer.</param>
    /// <param name="RunTrigger">Parameter of type Boolean.</param>
    [EventSubscriber(ObjectType::Table, database::Customer, 'OnAfterDeleteEvent', '', true, false)]
    local procedure UpdateSourceNameOnCustomerDelete(var Rec: Record Customer; RunTrigger: Boolean);
    begin
        if Rec.IsTemporary() then exit;
        GLSourceNamesMgt.RemoveSource(SourceType::Customer, Rec."No.");
    end;

    /// <summary> 
    /// Description for UpdateSourceNameOnCustomerModify.
    /// </summary>
    /// <param name="Rec">Parameter of type Record Customer.</param>
    /// <param name="xRec">Parameter of type Record Customer.</param>
    /// <param name="RunTrigger">Parameter of type Boolean.</param>
    [EventSubscriber(ObjectType::Table, database::Customer, 'OnAfterModifyEvent', '', true, false)]
    local procedure UpdateSourceNameOnCustomerModify(var Rec: Record Customer; var xRec: Record Customer; RunTrigger: Boolean);
    begin
        if Rec.IsTemporary() then exit;
        GLSourceNamesMgt.UpdateSource(SourceType::Customer, Rec."No.", Rec.Name);
    end;
}


