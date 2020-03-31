codeunit 70009205 "O4N GL SN FxdAsset Upd."
{

    trigger OnRun();
    begin
    end;

    var
        GLSourceNamesMgt: Codeunit "O4N GL SN Mgt";
        SourceType: Enum "Gen. Journal Source Type";

    [EventSubscriber(ObjectType::Table, database::"Fixed Asset", 'OnAfterInsertEvent', '', true, false)]
    local procedure UpdateSourceNameOnFixedAssetInsert(var Rec: Record "Fixed Asset"; RunTrigger: Boolean);
    begin
        if Rec.ISTEMPORARY then exit;
        GLSourceNamesMgt.AddSource(SourceType::"Fixed Asset", Rec."No.", Rec.Description);
    end;

    [EventSubscriber(ObjectType::Table, database::"Fixed Asset", 'OnAfterDeleteEvent', '', true, false)]
    local procedure UpdateSourceNameOnFixedAssetDelete(var Rec: Record "Fixed Asset"; RunTrigger: Boolean);
    begin
        if Rec.ISTEMPORARY then exit;
        GLSourceNamesMgt.RemoveSource(SourceType::"Fixed Asset", Rec."No.");
    end;

    [EventSubscriber(ObjectType::Table, database::"Fixed Asset", 'OnAfterModifyEvent', '', true, false)]
    local procedure UpdateSourceNameOnFixedAssetModify(var Rec: Record "Fixed Asset"; var xRec: Record "Fixed Asset"; RunTrigger: Boolean);
    begin
        if Rec.ISTEMPORARY then exit;
        GLSourceNamesMgt.UpdateSource(SourceType::"Fixed Asset", Rec."No.", Rec.Description);
    end;
}


