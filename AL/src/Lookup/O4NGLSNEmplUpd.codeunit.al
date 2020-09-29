codeunit 70009209 "O4N GL SN Empl Upd."
{

    trigger OnRun();
    begin
    end;

    var
        GLSourceNamesMgt: Codeunit "O4N GL SN Mgt";
        SourceType: Enum "Gen. Journal Source Type";

    /// <summary> 
    /// Description for UpdateSourceNameOnFixedAssetInsert.
    /// </summary>
    /// <param name="Rec">Parameter of type Record Employee.</param>
    /// <param name="RunTrigger">Parameter of type Boolean.</param>
    [EventSubscriber(ObjectType::Table, database::Employee, 'OnAfterInsertEvent', '', true, false)]
    local procedure UpdateSourceNameOnFixedAssetInsert(var Rec: Record Employee; RunTrigger: Boolean);
    begin
        if Rec.IsTemporary() then exit;
        GLSourceNamesMgt.AddSource(SourceType::Employee, Rec."No.", CopyStr(Rec.FullName(), 1, 100));
    end;

    /// <summary> 
    /// Description for UpdateSourceNameOnFixedAssetDelete.
    /// </summary>
    /// <param name="Rec">Parameter of type Record Employee.</param>
    /// <param name="RunTrigger">Parameter of type Boolean.</param>
    [EventSubscriber(ObjectType::Table, database::Employee, 'OnAfterDeleteEvent', '', true, false)]
    local procedure UpdateSourceNameOnFixedAssetDelete(var Rec: Record Employee; RunTrigger: Boolean);
    begin
        if Rec.IsTemporary() then exit;
        GLSourceNamesMgt.RemoveSource(SourceType::Employee, Rec."No.");
    end;

    /// <summary> 
    /// Description for UpdateSourceNameOnFixedAssetModify.
    /// </summary>
    /// <param name="Rec">Parameter of type Record Employee.</param>
    /// <param name="xRec">Parameter of type Record Employee.</param>
    /// <param name="RunTrigger">Parameter of type Boolean.</param>
    [EventSubscriber(ObjectType::Table, database::Employee, 'OnAfterModifyEvent', '', true, false)]
    local procedure UpdateSourceNameOnFixedAssetModify(var Rec: Record Employee; var xRec: Record Employee; RunTrigger: Boolean);
    begin
        if Rec.IsTemporary() then exit;
        GLSourceNamesMgt.UpdateSource(SourceType::Employee, Rec."No.", CopyStr(Rec.FullName(), 1, 100));
    end;
}


