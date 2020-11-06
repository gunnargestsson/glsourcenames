codeunit 70009214 "O4N Value Show Source Card"
{

    TableNo = "Value Entry";

    trigger OnRun();
    begin
        ShowValueEntrySourceCard(Rec);
    end;

    var
        NoSourceDefinedErr: Label 'Source is not defined';
        SourceNotFoundErr: Label '%1 %2 %3 not found', Comment = '%1 = TableCaption(), %2 = Fieldcaption, %3 = No. value';


    /// <summary> 
    /// Description for ShowGLEntrySourceCard.
    /// </summary>
    /// <param name="ValueEntry">Parameter of type Record "G/L Entry".</param>
    local procedure ShowValueEntrySourceCard(ValueEntry: Record "Value Entry");
    begin
        case ValueEntry."Source Type" of
            ValueEntry."Source Type"::Customer:
                ShowCustCard(ValueEntry."Source No.");
            ValueEntry."Source Type"::Vendor:
                ShowVendCard(ValueEntry."Source No.");
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


