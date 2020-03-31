codeunit 70009201 "O4N GL SN Mgt"
{

  Permissions=TableData "O4N GL SN"=rimd;

  trigger OnRun();
  begin
  end;

  var
    Window : Dialog;
    SourceType : Option " ",Customer,Vendor,"Bank Account","Fixed Asset",Employee;
    ProcessInfo : Label 'Populating G/L Source Names...';
    RequiredPermissionMissingErr : Label 'Required permissions for table "%1" is missing.  Can''t refresh lookup data.';
    ProcessCompleted : Label 'G/L Source Names lookup table update finished';

  procedure AddSource(SourceType : Option;SourceNo : Code[20];SourceName : Text[100]);
  var
    GLSourceName : Record "O4N GL SN";
  begin
    with GLSourceName do begin
      if not WRITEPERMISSION then exit;
      if GET(SourceType,SourceNo) then
        UpdateSource(SourceType,SourceNo,SourceName)
      else begin
        INIT;
        "Source Type" := SourceType;
        "Source No." := SourceNo;
        "Source Name" := SourceName;
        INSERT;
      end;
    end;
  end;

  procedure RemoveSource(SourceType : Option;SourceNo : Code[20]);
  var
    GLSourceName : Record "O4N GL SN";
  begin
    with GLSourceName do begin
      if not WRITEPERMISSION then exit;
      if GET(SourceType,SourceNo) then
        DELETE;
    end;
  end;

  procedure UpdateSource(SourceType : Option;SourceNo : Code[20];SourceName : Text[100]);
  var
    GLSourceName : Record "O4N GL SN";
  begin
    with GLSourceName do begin
      if not WRITEPERMISSION then exit;
      if GET(SourceType,SourceNo) then begin
        "Source Type" := SourceType;
        "Source No." := SourceNo;
        "Source Name" := SourceName;
        MODIFY;
      end else
        AddSource(SourceType,SourceNo,SourceName);
    end;
  end;

  procedure Refresh(HideMessage : Boolean);
  var
    GLSourceName : Record "O4N GL SN";
    Customer : Record Customer;
    Vendor : Record Vendor;
    BankAccount : Record "Bank Account";
    FixedAsset : Record "Fixed Asset";
    Employee: Record Employee;
  begin
    with GLSourceName do
      if not WRITEPERMISSION then
        ERROR(RequiredPermissionMissingErr);
    with Customer do
      if not READPERMISSION then
        ERROR(RequiredPermissionMissingErr);
    with Vendor do
      if not READPERMISSION then
        ERROR(RequiredPermissionMissingErr);
    with BankAccount do
      if not READPERMISSION then
        ERROR(RequiredPermissionMissingErr);
    with FixedAsset do
      if not READPERMISSION then
        ERROR(RequiredPermissionMissingErr);
    with Employee do
      if not READPERMISSION then
        ERROR(RequiredPermissionMissingErr);
    GLSourceName.DELETEALL;
    PopulateSourceTable;
    if not HideMessage then
      MESSAGE(ProcessCompleted);
  end;

  procedure PopulateSourceTable();
  var
    GLSourceName : Record "O4N GL SN";
    Customer : Record Customer;
    Vendor : Record Vendor;
    BankAccount : Record "Bank Account";
    FixedAsset : Record "Fixed Asset";
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
      Window.OPEN(ProcessInfo);
      AddSourceTable(SourceType::Customer,Customer);
      AddSourceTable(SourceType::Vendor,Vendor);
      AddSourceTable(SourceType::"Bank Account",BankAccount);
      AddSourceTable(SourceType::"Fixed Asset",FixedAsset);
      AddSourceTable(SourceType::Employee,Employee);
      Window.CLOSE;
    end;
  end;

  procedure AddSourceTable(SourceType : Option;RecVariant : Variant);
  var
    RecRef : RecordRef;
    NoField : FieldRef;
    NameField : FieldRef;
  begin
    with RecRef do begin
      GETTABLE(RecVariant);
      if FINDSET then repeat
        NoField := FIELD(1);
        NameField := FIELD(2);
        AddSource(SourceType,FORMAT(NoField.VALUE),FORMAT(NameField.VALUE));
      until NEXT = 0;
    end;
  end;

  procedure AddEmployeeTable(SourceType : Option;Employee : Record Employee);
  begin
    with Employee do begin
      if FINDSET then repeat
        AddSource(SourceType,Employee."No.",CopyStr(Employee.FullName(),1,50));
      until NEXT = 0;
    end;
  end;
  
}


