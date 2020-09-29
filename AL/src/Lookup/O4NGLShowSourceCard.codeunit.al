codeunit 70009206 "O4N GL Show Source Card"
{

    TableNo = "G/L Entry";

    trigger OnRun();
    begin
        ShowGLEntrySourceCard(Rec);
    end;

    var
        NoSourceDefinedErr: Label 'Source is not defined';
        SourceNotFoundErr: Label '%1 %2 %3 not found', Comment = '%1 = TableCaption(), %2 = Fieldcaption, %3 = No. value';

    /// <summary> 
    /// Description for ShowSourceNameCard.
    /// </summary>
    /// <param name="GLSourceName">Parameter of type Record "O4N GL SN".</param>
    procedure ShowSourceNameCard(GLSourceName: Record "O4N GL SN");
    begin
        case GLSourceName."Source Type" of
            GLSourceName."Source Type"::Customer:
                ShowCustCard(GLSourceName."Source No.");
            GLSourceName."Source Type"::Vendor:
                ShowVendCard(GLSourceName."Source No.");
            GLSourceName."Source Type"::"Bank Account":
                ShowBankAccCard(GLSourceName."Source No.");
            GLSourceName."Source Type"::"Fixed Asset":
                ShowFixedAssetCard(GLSourceName."Source No.");
            GLSourceName."Source Type"::Employee:
                ShowEmployeeCard(GLSourceName."Source No.");
            else
                ERROR(NoSourceDefinedErr);
        end;
    end;

    /// <summary> 
    /// Description for ShowGLEntrySourceCard.
    /// </summary>
    /// <param name="GLEntry">Parameter of type Record "G/L Entry".</param>
    local procedure ShowGLEntrySourceCard(GLEntry: Record "G/L Entry");
    begin
        case GLEntry."Source Type" of
            GLEntry."Source Type"::Customer:
                ShowCustCard(GLEntry."Source No.");
            GLEntry."Source Type"::Vendor:
                ShowVendCard(GLEntry."Source No.");
            GLEntry."Source Type"::"Bank Account":
                ShowBankAccCard(GLEntry."Source No.");
            GLEntry."Source Type"::"Fixed Asset":
                ShowFixedAssetCard(GLEntry."Source No.");
            GLEntry."Source Type"::Employee:
                ShowEmployeeCard(GLEntry."Source No.");
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

    /// <summary> 
    /// Description for ShowBankAccCard.
    /// </summary>
    /// <param name="No">Parameter of type Code[20].</param>
    local procedure ShowBankAccCard(No: Code[20]);
    var
        BankAcc: Record "Bank Account";
    begin
        if BankAcc.Get(No) then
            PAGE.RUN(PAGE::"Bank Account Card", BankAcc)
        else
            ERROR(SourceNotFoundErr, BankAcc.TABLECAPTION(), BankAcc.FIELDCAPTION("No."), No);
    end;

    /// <summary> 
    /// Description for ShowFixedAssetCard.
    /// </summary>
    /// <param name="No">Parameter of type Code[20].</param>
    local procedure ShowFixedAssetCard(No: Code[20]);
    var
        FixedAsset: Record "Fixed Asset";
    begin
        if FixedAsset.GET(No) then
            PAGE.RUN(PAGE::"Fixed Asset Card", FixedAsset)
        else
            ERROR(SourceNotFoundErr, FixedAsset.TableCaption(), FixedAsset.FIELDCAPTION("No."), No);
    end;

    /// <summary> 
    /// Description for ShowEmployeeCard.
    /// </summary>
    /// <param name="No">Parameter of type Code[20].</param>
    local procedure ShowEmployeeCard(No: Code[20]);
    var
        Employee: Record Employee;
    begin
        if Employee.GET(No) then
            PAGE.RUN(PAGE::"Employee Card", Employee)
        else
            ERROR(SourceNotFoundErr, Employee.TableCaption(), Employee.FIELDCAPTION("No."), No);
    end;
}


