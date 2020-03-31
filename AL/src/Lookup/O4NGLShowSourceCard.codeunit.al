codeunit 70009206 "O4N GL Show Source Card"
{

    TableNo = "G/L Entry";

    trigger OnRun();
    begin
        ShowGLEntrySourceCard(Rec);
    end;

    var
        NoSourceDefinedErr: Label 'Source is not defined';
        SourceNotFoundErr: Label '%1 %2 %3 not found', Comment = '%1 = Tablecaption, %2 = Fieldcaption, %3 = No. value';

    procedure ShowSourceNameCard(GLSourceName: Record "O4N GL SN");
    begin
        with GLSourceName do
            case "Source Type" of
                "Source Type"::Customer:
                    ShowCustCard("Source No.");
                "Source Type"::Vendor:
                    ShowVendCard("Source No.");
                "Source Type"::"Bank Account":
                    ShowBankAccCard("Source No.");
                "Source Type"::"Fixed Asset":
                    ShowFixedAssetCard("Source No.");
                "Source Type"::Employee:
                    ShowEmployeeCard("Source No.");
                else
                    ERROR(NoSourceDefinedErr);
            end;
    end;

    local procedure ShowGLEntrySourceCard(GLEntry: Record "G/L Entry");
    begin
        with GLEntry do
            case "Source Type" of
                "Source Type"::Customer:
                    ShowCustCard("Source No.");
                "Source Type"::Vendor:
                    ShowVendCard("Source No.");
                "Source Type"::"Bank Account":
                    ShowBankAccCard("Source No.");
                "Source Type"::"Fixed Asset":
                    ShowFixedAssetCard("Source No.");
                "Source Type"::Employee:
                    ShowEmployeeCard("Source No.");
                else
                    ERROR(NoSourceDefinedErr);
            end;
    end;

    local procedure ShowCustCard(No: Code[20]);
    var
        Cust: Record Customer;
    begin
        with Cust do
            if GET(No) then
                PAGE.RUN(PAGE::"Customer Card", Cust)
            else
                ERROR(SourceNotFoundErr, TABLECAPTION, FIELDCAPTION("No."), No);
    end;

    local procedure ShowVendCard(No: Code[20]);
    var
        Vend: Record Vendor;
    begin
        with Vend do
            if GET(No) then
                PAGE.RUN(PAGE::"Vendor Card", Vend)
            else
                ERROR(SourceNotFoundErr, TABLECAPTION, FIELDCAPTION("No."), No);
    end;

    local procedure ShowBankAccCard(No: Code[20]);
    var
        BankAcc: Record "Bank Account";
    begin
        with BankAcc do
            if GET(No) then
                PAGE.RUN(PAGE::"Bank Account Card", BankAcc)
            else
                ERROR(SourceNotFoundErr, TABLECAPTION, FIELDCAPTION("No."), No);
    end;

    local procedure ShowFixedAssetCard(No: Code[20]);
    var
        FixedAsset: Record "Fixed Asset";
    begin
        with FixedAsset do
            if GET(No) then
                PAGE.RUN(PAGE::"Fixed Asset Card", FixedAsset)
            else
                ERROR(SourceNotFoundErr, TABLECAPTION, FIELDCAPTION("No."), No);
    end;

    local procedure ShowEmployeeCard(No: Code[20]);
    var
        Employee: Record Employee;
    begin
        with Employee do
            if GET(No) then
                PAGE.RUN(PAGE::"Employee Card", Employee)
            else
                ERROR(SourceNotFoundErr, TABLECAPTION, FIELDCAPTION("No."), No);
    end;
}


