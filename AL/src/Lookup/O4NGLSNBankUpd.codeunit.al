codeunit 70009204 "O4N GL SN Bank Upd."
{

    trigger OnRun();
    begin
    end;

    var
        GLSourceNamesMgt: Codeunit "O4N GL SN Mgt";
        SourceType: Enum "Gen. Journal Source Type";

    /// <summary> 
    /// Description for UpdateSourceNameOnBankAccInsert.
    /// </summary>
    /// <param name="Rec">Parameter of type Record "Bank Account".</param>
    /// <param name="RunTrigger">Parameter of type Boolean.</param>
    [EventSubscriber(ObjectType::Table, database::"Bank Account", 'OnAfterInsertEvent', '', true, false)]
    local procedure UpdateSourceNameOnBankAccInsert(var Rec: Record "Bank Account"; RunTrigger: Boolean);
    begin
        if Rec.IsTemporary() then exit;
        GLSourceNamesMgt.AddSource(SourceType::"Bank Account", Rec."No.", Rec.Name);
    end;

    /// <summary> 
    /// Description for UpdateSourceNameOnBankAccDelete.
    /// </summary>
    /// <param name="Rec">Parameter of type Record "Bank Account".</param>
    /// <param name="RunTrigger">Parameter of type Boolean.</param>
    [EventSubscriber(ObjectType::Table, database::"Bank Account", 'OnAfterDeleteEvent', '', true, false)]
    local procedure UpdateSourceNameOnBankAccDelete(var Rec: Record "Bank Account"; RunTrigger: Boolean);
    begin
        if Rec.IsTemporary() then exit;
        GLSourceNamesMgt.RemoveSource(SourceType::"Bank Account", Rec."No.");
    end;

    /// <summary> 
    /// Description for UpdateSourceNameOnBankAccModify.
    /// </summary>
    /// <param name="Rec">Parameter of type Record "Bank Account".</param>
    /// <param name="xRec">Parameter of type Record "Bank Account".</param>
    /// <param name="RunTrigger">Parameter of type Boolean.</param>
    [EventSubscriber(ObjectType::Table, database::"Bank Account", 'OnAfterModifyEvent', '', true, false)]
    local procedure UpdateSourceNameOnBankAccModify(var Rec: Record "Bank Account"; var xRec: Record "Bank Account"; RunTrigger: Boolean);
    begin
        if Rec.IsTemporary() then exit;
        GLSourceNamesMgt.UpdateSource(SourceType::"Bank Account", Rec."No.", Rec.Name);
    end;
}


