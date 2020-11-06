codeunit 70009213 "O4N Item Show Source Card"
{

    TableNo = "Item Ledger Entry";

    trigger OnRun();
    begin
        ShowItemLedgerEntrySourceCard(Rec);
    end;

    var
        NoSourceDefinedErr: Label 'Source is not defined';
        SourceNotFoundErr: Label '%1 %2 %3 not found', Comment = '%1 = TableCaption(), %2 = Fieldcaption, %3 = No. value';


    /// <summary> 
    /// Description for ShowGLEntrySourceCard.
    /// </summary>
    /// <param name="ItemLedgerEntry">Parameter of type Record "G/L Entry".</param>
    local procedure ShowItemLedgerEntrySourceCard(ItemLedgerEntry: Record "Item Ledger Entry");
    begin
        case ItemLedgerEntry."Source Type" of
            ItemLedgerEntry."Source Type"::Customer:
                ShowCustCard(ItemLedgerEntry."Source No.");
            ItemLedgerEntry."Source Type"::Vendor:
                ShowVendCard(ItemLedgerEntry."Source No.");
            else
                ERROR(NoSourceDefinedErr);
        end;
    end;

    /// <summary> 
    /// Description for ShowCustCard.
    /// </summary>
    /// <param name="No">Parameter of type Code[20].</param>
    local procedure ShowCustCard(No: Code[20]);
    var
        Cust: Record Customer;
    begin
        if Cust.GET(No) then
            PAGE.RUN(PAGE::"Customer Card", Cust)
        else
            ERROR(SourceNotFoundErr, Cust.TableCaption(), Cust.FIELDCAPTION("No."), No);
    end;

    /// <summary> 
    /// Description for ShowVendCard.
    /// </summary>
    /// <param name="No">Parameter of type Code[20].</param>
    local procedure ShowVendCard(No: Code[20]);
    var
        Vend: Record Vendor;
    begin
        if Vend.GET(No) then
            PAGE.RUN(PAGE::"Vendor Card", Vend)
        else
            ERROR(SourceNotFoundErr, Vend.TableCaption(), Vend.FIELDCAPTION("No."), No);
    end;

}


