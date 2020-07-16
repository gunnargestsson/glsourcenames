codeunit 70009201 "O4N GL SN Mgt"
{

    Permissions = TableData "O4N GL SN" = rimd;

    trigger OnRun();
    begin
    end;

    var
        Window: Dialog;
        SourceType: Enum "Gen. Journal Source Type";
        ProcessInfoMsg: Label 'Populating G/L Source Names...';
        RequiredPermissionMissingErr: Label 'Required permissions for table "%1" is missing.  Can''t refresh lookup data.', Comment = '%1 for the current table name';
        ProcessCompletedMsg: Label 'G/L Source Names lookup table update finished';

    procedure AddSource(SourceType: Enum "Gen. Journal Source Type"; SourceNo: Code[20]; SourceName: Text[100]);
    var
        GLSourceName: Record "O4N GL SN";
    begin
        if not GLSourceName.WRITEPERMISSION then exit;
        if GLSourceName.GET(SourceType, SourceNo) then
            UpdateSource(SourceType, SourceNo, SourceName)
        else begin
            GLSourceName.INIT();
            GLSourceName."Source Type" := SourceType;
            GLSourceName."Source No." := SourceNo;
            GLSourceName."Source Name" := SourceName;
            GLSourceName.INSERT();
        end;
    end;

    procedure RemoveSource(SourceType: Enum "Gen. Journal Source Type"; SourceNo: Code[20]);
    var
        GLSourceName: Record "O4N GL SN";
    begin
        if not GLSourceName.WRITEPERMISSION then exit;
        if GLSourceName.GET(SourceType, SourceNo) then
            GLSourceName.DELETE();
    end;

    procedure UpdateSource(SourceType: Enum "Gen. Journal Source Type"; SourceNo: Code[20]; SourceName: Text[100]);
    var
        GLSourceName: Record "O4N GL SN";
    begin
        if not GLSourceName.WRITEPERMISSION then exit;
        if GLSourceName.GET(SourceType, SourceNo) then begin
            GLSourceName."Source Type" := SourceType;
            GLSourceName."Source No." := SourceNo;
            GLSourceName."Source Name" := SourceName;
            GLSourceName.MODIFY();
        end else
            AddSource(SourceType, SourceNo, SourceName);
    end;

    procedure Refresh(HideMessage: Boolean);
    var
        GLSourceName: Record "O4N GL SN";
        Customer: Record Customer;
        Vendor: Record Vendor;
        BankAccount: Record "Bank Account";
        FixedAsset: Record "Fixed Asset";
        Employee: Record Employee;
    begin
        if not GLSourceName.WRITEPERMISSION then
            ERROR(RequiredPermissionMissingErr);
        if not Customer.READPERMISSION then
            ERROR(RequiredPermissionMissingErr);
        if not vendor.READPERMISSION then
            ERROR(RequiredPermissionMissingErr);
        if not BankAccount.READPERMISSION then
            ERROR(RequiredPermissionMissingErr);
        if not FixedAsset.READPERMISSION then
            ERROR(RequiredPermissionMissingErr);
        if not Employee.READPERMISSION then
            ERROR(RequiredPermissionMissingErr);
        GLSourceName.DELETEALL();
        PopulateSourceTable();
        if not HideMessage then
            MESSAGE(ProcessCompletedMsg);
    end;

    procedure PopulateSourceTable();
    var
        GLSourceName: Record "O4N GL SN";
        Customer: Record Customer;
        Vendor: Record Vendor;
        BankAccount: Record "Bank Account";
        FixedAsset: Record "Fixed Asset";
        Employee: Record Employee;
    begin
        if GLSourceName.WRITEPERMISSION and
          Customer.READPERMISSION and
          Vendor.READPERMISSION and
          BankAccount.READPERMISSION and
          FixedAsset.READPERMISSION and
          Employee.READPERMISSION
        then begin
            if not GLSourceName.IsEmpty() then exit;
            if Customer.IsEmpty() and Vendor.IsEmpty() and BankAccount.IsEmpty() and FixedAsset.IsEmpty() and Employee.IsEmpty() then exit;
            Window.OPEN(ProcessInfoMsg);
            AddSourceTable(SourceType::Customer, Customer);
            AddSourceTable(SourceType::Vendor, Vendor);
            AddSourceTable(SourceType::"Bank Account", BankAccount);
            AddSourceTable(SourceType::"Fixed Asset", FixedAsset);
            AddSourceTable(SourceType::Employee, Employee);
            Window.CLOSE();
        end;
    end;

    procedure AddSourceTable(SourceType: Enum "Gen. Journal Source Type"; RecVariant: Variant);
    var
        RecRef: RecordRef;
        NoField: FieldRef;
        NameField: FieldRef;
    begin
        RecRef.GETTABLE(RecVariant);
        if RecRef.FINDSET() then
            repeat
                NoField := RecRef.FIELD(1);
                NameField := RecRef.FIELD(2);
                AddSource(SourceType, FORMAT(NoField.VALUE), FORMAT(NameField.VALUE));
            until RecRef.NEXT() = 0;
    end;

    procedure AddEmployeeTable(SourceType: Enum "Gen. Journal Source Type"; Employee: Record Employee);
    begin
        if Employee.FINDSET() then
            repeat
                AddSource(SourceType, Employee."No.", CopyStr(Employee.FullName(), 1, 100));
            until Employee.NEXT() = 0;
    end;

}


