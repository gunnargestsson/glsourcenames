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

    /// <summary> 
    /// Description for AddSource.
    /// </summary>
    /// <param name="SourceType">Parameter of type Enum "Gen. Journal Source Type".</param>
    /// <param name="SourceNo">Parameter of type Code[20].</param>
    /// <param name="SourceName">Parameter of type Text[100].</param>
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
            case SourceType of
                GLSourceName."Source Type"::Customer:
                    GLSourceName."Item Ledger Source Type" := GLSourceName."Item Ledger Source Type"::Customer;
                GLSourceName."Source Type"::Vendor:
                    GLSourceName."Item Ledger Source Type" := GLSourceName."Item Ledger Source Type"::Vendor;
            end;
            GLSourceName.INSERT();
        end;
    end;

    /// <summary> 
    /// Description for RemoveSource.
    /// </summary>
    /// <param name="SourceType">Parameter of type Enum "Gen. Journal Source Type".</param>
    /// <param name="SourceNo">Parameter of type Code[20].</param>
    procedure RemoveSource(SourceType: Enum "Gen. Journal Source Type"; SourceNo: Code[20]);
    var
        GLSourceName: Record "O4N GL SN";
    begin
        if not GLSourceName.WRITEPERMISSION then exit;
        if GLSourceName.GET(SourceType, SourceNo) then
            GLSourceName.DELETE();
    end;

    /// <summary> 
    /// Description for UpdateSource.
    /// </summary>
    /// <param name="SourceType">Parameter of type Enum "Gen. Journal Source Type".</param>
    /// <param name="SourceNo">Parameter of type Code[20].</param>
    /// <param name="SourceName">Parameter of type Text[100].</param>
    procedure UpdateSource(SourceType: Enum "Gen. Journal Source Type"; SourceNo: Code[20]; SourceName: Text[100]);
    var
        GLSourceName: Record "O4N GL SN";
    begin
        if not GLSourceName.WRITEPERMISSION then exit;
        if GLSourceName.GET(SourceType, SourceNo) then begin
            GLSourceName."Source Type" := SourceType;
            GLSourceName."Source No." := SourceNo;
            GLSourceName."Source Name" := SourceName;
            case SourceType of
                GLSourceName."Source Type"::Customer:
                    GLSourceName."Item Ledger Source Type" := GLSourceName."Item Ledger Source Type"::Customer;
                GLSourceName."Source Type"::Vendor:
                    GLSourceName."Item Ledger Source Type" := GLSourceName."Item Ledger Source Type"::Vendor;
            end;
            GLSourceName.MODIFY();
        end else
            AddSource(SourceType, SourceNo, SourceName);
    end;

    /// <summary> 
    /// Description for Refresh.
    /// </summary>
    /// <param name="HideMessage">Parameter of type Boolean.</param>
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

    /// <summary> 
    /// Description for PopulateSourceTable.
    /// </summary>
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

    /// <summary> 
    /// Description for AddSourceTable.
    /// </summary>
    /// <param name="SourceType">Parameter of type Enum "Gen. Journal Source Type".</param>
    /// <param name="RecVariant">Parameter of type Variant.</param>
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

    /// <summary> 
    /// Description for AddEmployeeTable.
    /// </summary>
    /// <param name="SourceType">Parameter of type Enum "Gen. Journal Source Type".</param>
    /// <param name="Employee">Parameter of type Record Employee.</param>
    procedure AddEmployeeTable(SourceType: Enum "Gen. Journal Source Type"; Employee: Record Employee);
    begin
        if Employee.FINDSET() then
            repeat
                AddSource(SourceType, Employee."No.", CopyStr(Employee.FullName(), 1, 100));
            until Employee.NEXT() = 0;
    end;

}


