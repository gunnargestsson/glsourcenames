codeunit 70009203 "O4N GL SN Vend Upd."
{

    trigger OnRun();
    begin
    end;

    var
        GLSourceNamesMgt: Codeunit "O4N GL SN Mgt";
        SourceType: Enum "Gen. Journal Source Type";

    /// <summary> 
    /// Description for UpdateSourceNameOnVendorInsert.
    /// </summary>
    /// <param name="Rec">Parameter of type Record Vendor.</param>
    /// <param name="RunTrigger">Parameter of type Boolean.</param>
    [EventSubscriber(ObjectType::Table, database::Vendor, 'OnAfterInsertEvent', '', true, false)]
    local procedure UpdateSourceNameOnVendorInsert(var Rec: Record Vendor; RunTrigger: Boolean);
    begin
        if Rec.IsTemporary() then exit;
        GLSourceNamesMgt.AddSource(SourceType::Vendor, Rec."No.", Rec.Name);
    end;

    /// <summary> 
    /// Description for UpdateSourceNameOnVendorDelete.
    /// </summary>
    /// <param name="Rec">Parameter of type Record Vendor.</param>
    /// <param name="RunTrigger">Parameter of type Boolean.</param>
    [EventSubscriber(ObjectType::Table, database::Vendor, 'OnAfterDeleteEvent', '', true, false)]
    local procedure UpdateSourceNameOnVendorDelete(var Rec: Record Vendor; RunTrigger: Boolean);
    begin
        if Rec.IsTemporary() then exit;
        GLSourceNamesMgt.RemoveSource(SourceType::Vendor, Rec."No.");
    end;

    /// <summary> 
    /// Description for UpdateSourceNameOnVendorModify.
    /// </summary>
    /// <param name="Rec">Parameter of type Record Vendor.</param>
    /// <param name="xRec">Parameter of type Record Vendor.</param>
    /// <param name="RunTrigger">Parameter of type Boolean.</param>
    [EventSubscriber(ObjectType::Table, database::Vendor, 'OnAfterModifyEvent', '', true, false)]
    local procedure UpdateSourceNameOnVendorModify(var Rec: Record Vendor; var xRec: Record Vendor; RunTrigger: Boolean);
    begin
        if Rec.IsTemporary() then exit;
        GLSourceNamesMgt.UpdateSource(SourceType::Vendor, Rec."No.", Rec.Name);
    end;
}


