codeunit 70009205 "O4N GL SN FxdAsset Upd."
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
    /// <param name="Rec">Parameter of type Record "Fixed Asset".</param>
    /// <param name="RunTrigger">Parameter of type Boolean.</param>
    [EventSubscriber(ObjectType::Table, database::"Fixed Asset", 'OnAfterInsertEvent', '', true, false)]
    local procedure UpdateSourceNameOnFixedAssetInsert(var Rec: Record "Fixed Asset"; RunTrigger: Boolean);
    begin
        if Rec.IsTemporary() then exit;
        GLSourceNamesMgt.AddSource(SourceType::"Fixed Asset", Rec."No.", Rec.Description);
    end;

    /// <summary> 
    /// Description for UpdateSourceNameOnFixedAssetDelete.
    /// </summary>
    /// <param name="Rec">Parameter of type Record "Fixed Asset".</param>
    /// <param name="RunTrigger">Parameter of type Boolean.</param>
    [EventSubscriber(ObjectType::Table, database::"Fixed Asset", 'OnAfterDeleteEvent', '', true, false)]
    local procedure UpdateSourceNameOnFixedAssetDelete(var Rec: Record "Fixed Asset"; RunTrigger: Boolean);
    begin
        if Rec.IsTemporary() then exit;
        GLSourceNamesMgt.RemoveSource(SourceType::"Fixed Asset", Rec."No.");
    end;

    /// <summary> 
    /// Description for UpdateSourceNameOnFixedAssetModify.
    /// </summary>
    /// <param name="Rec">Parameter of type Record "Fixed Asset".</param>
    /// <param name="xRec">Parameter of type Record "Fixed Asset".</param>
    /// <param name="RunTrigger">Parameter of type Boolean.</param>
    [EventSubscriber(ObjectType::Table, database::"Fixed Asset", 'OnAfterModifyEvent', '', true, false)]
    local procedure UpdateSourceNameOnFixedAssetModify(var Rec: Record "Fixed Asset"; var xRec: Record "Fixed Asset"; RunTrigger: Boolean);
    begin
        if Rec.IsTemporary() then exit;
        GLSourceNamesMgt.UpdateSource(SourceType::"Fixed Asset", Rec."No.", Rec.Description);
    end;
}


