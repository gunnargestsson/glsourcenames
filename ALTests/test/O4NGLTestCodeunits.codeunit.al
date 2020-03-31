codeunit 70009249 "O4N GL Test Codeunits"
{

    // {
    //   "name": "G/L Source Names",
    //   "publisher": "Objects4NAV",
    //   "version": "4.0.0.0",
    //   "appId": "479e77f3-031a-49fe-bb6a-314464c6a9a8"
    // }

    // [FEATURE] [G/L Source Names Lookup]
    Subtype = Test;
    Permissions = TableData "G/L Entry" = RMID;

    var
        Assert: Codeunit "Library Assert";
        GLLib: Codeunit "Library - ERM";
        CustLib: Codeunit "Library - Sales";
        VendLib: Codeunit "Library - Purchase";
        FALib: Codeunit "Library - Fixed Asset";
        EmplLib: Codeunit "Library - Human Resource";
        SourceName: Text[100];
        PageErr: Label 'Source Card: %1 error', Locked = true;
        SourceNameUpdateFailesErr: Label 'Source Name Update failed for %1 %2', Locked = true;

    [Test]
    procedure TestRegisterAssistedSetup()
    var
        AssistedSetup: Codeunit "Assisted Setup";
        AssistedSetupPage: TestPage "Assisted Setup";
    begin
        // [SCENARIO] Discovery for assisted setup should find the G/L Source Names Setup Wizard
        // [GIVEN] An temporary instance of assisted setup   
        // [WHEN] Discovery event is triggered
        AssistedSetupPage.OpenView();
        AssistedSetupPage.Close();
        // [THEN] Assisted setup for G/L Source Names should be found
        Assert.IsTrue(AssistedSetup.Exists(page::"O4N GL SN Setup Wizard"), 'Failed to verify the Assisted Setup Page registered');
    end;

    [Test]
    [HandlerFunctions('AssistedSetupMessageHandler,ConfirmAssistedSetupUpdateInvoke')]
    procedure TestAssistedSetup()
    var
        Cust: Record Customer;
        Vend: Record Vendor;
        BankAcc: Record "Bank Account";
        FA: Record "Fixed Asset";
        Employee: Record Employee;
        AssistedSetup: TestPage "O4N GL SN Setup Wizard";
    begin
        // [SCENARIO] User presses Update G/L Source Names in assisted setup
        // [GIVEN] An empty lookup table
        Initialize();
        // [WHEN] User presses the action to update the lookup table
        AssistedSetup.OpenEdit();
        AssistedSetup.ActionDefault.Invoke();
        AssistedSetup."Registration E-Mail Address".SetValue('gunnar@navision.guru');
        AssistedSetup.ActionNext.Invoke();
        AssistedSetup.ActionUpdateSourceLookup.Invoke();
        AssistedSetup.Close();
        // [THEN] G/L Source Name Lookup should have 4 records
        TestLookupNoOfRecords(Cust.Count() + Vend.Count() + BankAcc.Count() + FA.count() + Employee.Count());
    end;

    [MessageHandler]
    procedure AssistedSetupMessageHandler(Message: Text[1024])
    begin
        // Don't care about the message        
    end;

    [ConfirmHandler]
    procedure ConfirmAssistedSetupUpdateInvoke(Question: Text[1024]; var Reply: Boolean)
    begin
        Reply := true;
    end;

    [Test]
    procedure TestCustomerCreationUpdateDeleteEvents()
    var
        Cust: record Customer;
        SourceType: Enum "Gen. Journal Source Type";
    begin
        // [SCENARIO] Create, update and delete of a master table should be reflected the source names lookup table
        // [GIVEN] Default setup
        Initialize();
        // [WHEN] Creating a record
        CustLib.CreateCustomer(Cust);
        // [THEN] source names lookup should be found
        TestSourceExistsInLookupTable(SourceType::Customer, cust."No.");

        // [WHEN] Updating a record
        Cust.Name := 'New Name';
        Cust.Modify();
        // [THEN] source names should match the new name
        TestSourceNameInLookupTable(SourceType::Customer, Cust."No.", Cust.Name);

        // [WHEN] Deleting a record
        Cust.Delete();
        // [THEN] source names lookup should not be found
        TestSourceNotExistsInLookupTable(SourceType::Customer, Cust."No.");

    end;

    [Test]
    procedure TestVendorCreationUpdateDeleteEvents()
    var
        Vend: record Vendor;
        SourceType: Enum "Gen. Journal Source Type";
    begin
        // [SCENARIO] Create, update and delete of a master table should be reflected the source names lookup table
        // [GIVEN] Default setup
        Initialize();
        // [WHEN] Creating a record
        VendLib.CreateVendor(Vend);
        // [THEN] source names lookup should be found
        TestSourceExistsInLookupTable(SourceType::Vendor, Vend."No.");

        // [WHEN] Updating a record
        Vend.Name := 'New Name';
        Vend.Modify();
        // [THEN] source names should match the new name
        TestSourceNameInLookupTable(SourceType::Vendor, Vend."No.", Vend.Name);

        // [WHEN] Deleting a record
        Vend.Delete();
        // [THEN] source names lookup should not be found
        TestSourceNotExistsInLookupTable(SourceType::Vendor, Vend."No.");

    end;

    [Test]
    procedure TestBankAccountCreationUpdateDeleteEvents()
    var
        BankAcc: record "Bank Account";
        SourceType: Enum "Gen. Journal Source Type";
    begin
        // [SCENARIO] Create, update and delete of a master table should be reflected the source names lookup table
        // [GIVEN] Default setup
        Initialize();
        // [WHEN] Creating a record        
        GLLib.CreateBankAccount(BankAcc);
        // [THEN] source names lookup should be found
        TestSourceExistsInLookupTable(SourceType::"Bank Account", BankAcc."No.");

        // [WHEN] Updating a record
        BankAcc.Name := 'New Name';
        BankAcc.Modify();
        // [THEN] source names should match the new name
        TestSourceNameInLookupTable(SourceType::"Bank Account", BankAcc."No.", BankAcc.Name);

        // [WHEN] Deleting a record
        BankAcc.Delete();
        // [THEN] source names lookup should not be found
        TestSourceNotExistsInLookupTable(SourceType::"Bank Account", BankAcc."No.");

    end;

    [Test]
    procedure TestFixedAssetCreationUpdateDeleteEvents()
    var
        FA: Record "Fixed Asset";
        SourceType: Enum "Gen. Journal Source Type";
    begin
        // [SCENARIO] Create, update and delete of a master table should be reflected the source names lookup table
        // [GIVEN] Default setup
        Initialize();
        // [WHEN] Creating a record
        FALib.CreateFixedAsset(FA);
        // [THEN] source names lookup should be found
        TestSourceExistsInLookupTable(SourceType::"Fixed Asset", FA."No.");

        // [WHEN] Updating a record
        FA.Description := 'New Name';
        FA.Modify();
        // [THEN] source names should match the new name
        TestSourceNameInLookupTable(SourceType::"Fixed Asset", FA."No.", FA.Description);

        // [WHEN] Deleting a record
        FA.Delete();
        // [THEN] source names lookup should not be found
        TestSourceNotExistsInLookupTable(SourceType::"Fixed Asset", FA."No.");

    end;

    [Test]
    procedure TestEmployeeCreationUpdateDeleteEvents()
    var
        Employee: Record Employee;
        SourceType: Enum "Gen. Journal Source Type";
    begin
        // [SCENARIO] Create, update and delete of a master table should be reflected the source names lookup table
        // [GIVEN] Default setup
        Initialize();
        // [WHEN] Creating a record
        EmplLib.CreateEmployee(Employee);
        // [THEN] source names lookup should be found
        TestSourceExistsInLookupTable(SourceType::Employee, Employee."No.");

        // [WHEN] Updating a record
        Employee."First Name" := 'New Name';
        Employee.Modify();
        // [THEN] source names should match the new name
        TestSourceNameInLookupTable(SourceType::Employee, Employee."No.", CopyStr(Employee.FullName(), 1, MaxStrLen(Employee."First Name")));

        // [WHEN] Deleting a record
        Employee.Delete();
        // [THEN] source names lookup should not be found
        TestSourceNotExistsInLookupTable(SourceType::Employee, Employee."No.");

    end;

    [Test]
    [HandlerFunctions('CustomerCardRunHandler,GLSourceNamesDrillDownPageHandler')]
    procedure TestShowCustCard()
    var
        GLEntry: Record "G/L Entry";
        Cust: record Customer;
        GLEntries: TestPage "General Ledger Entries";
        SourceType: Enum "Gen. Journal Source Type";
    begin
        // [SCENARIO] Test G/L Entry Source Card Lookup Action
        // [GIVEN] Default setup, new master record and G/L Entry
        Initialize();
        CustLib.CreateCustomer(Cust);
        CreateCLEntry(SourceType::Customer, Cust."No.", GLEntry);
        SourceName := Cust.Name;
        // [WHEN] Pressing Show Source Card
        GLEntries.OpenView();
        GLEntries.GoToRecord(GLEntry);
        GLEntries."O4N SourceCard".Invoke();
        // [THEN] source card should open with correct source name
        // Verified in handler

        // [WHEN] Pressing Source Name Drilldown
        GLEntries."O4N Source Name".Drilldown();
        // [THEN] source card should open with correct source name
        // Verified in handler

    end;

    [PageHandler]
    procedure CustomerCardRunHandler(var CustCard: TestPage "Customer Card")
    begin
        Assert.AreEqual(CustCard.Name.Value(), SourceName, StrSubstNo(PageErr, CustCard.Caption()));
    end;

    [Test]
    [HandlerFunctions('VendorCardRunHandler,GLSourceNamesDrillDownPageHandler')]
    procedure TestShowVendCard()
    var
        GLEntry: Record "G/L Entry";
        Vend: record Vendor;
        GLEntries: TestPage "General Ledger Entries";
        SourceType: Enum "Gen. Journal Source Type";
    begin
        // [SCENARIO] Test G/L Entry Source Card Lookup Action
        // [GIVEN] Default setup, new master record and G/L Entry
        Initialize();
        VendLib.CreateVendor(Vend);
        CreateCLEntry(SourceType::Vendor, Vend."No.", GLEntry);
        SourceName := Vend.Name;
        // [WHEN] Pressing Show Source Card
        GLEntries.OpenView();
        GLEntries.GoToRecord(GLEntry);
        GLEntries."O4N SourceCard".Invoke();
        // [THEN] source card should open with correct source name
        // Verified in handler

        // [WHEN] Pressing Source Name Drilldown
        GLEntries."O4N Source Name".Drilldown();
        // [THEN] source card should open with correct source name
        // Verified in handler

    end;

    [PageHandler]
    procedure VendorCardRunHandler(var VendCard: TestPage "Vendor Card")
    begin
        Assert.AreEqual(VendCard.Name.Value(), SourceName, StrSubstNo(PageErr, VendCard.Caption()));
    end;

    [Test]
    [HandlerFunctions('BankAccountCardRunHandler,GLSourceNamesDrillDownPageHandler')]
    procedure TestShowBankAccCard()
    var
        GLEntry: Record "G/L Entry";
        BankAcc: record "Bank Account";
        GLEntries: TestPage "General Ledger Entries";
        SourceType: Enum "Gen. Journal Source Type";
    begin
        // [SCENARIO] Test G/L Entry Source Card Lookup Action
        // [GIVEN] Default setup, new master record and G/L Entry
        Initialize();
        GLLib.CreateBankAccount(BankAcc);
        CreateCLEntry(SourceType::"Bank Account", BankAcc."No.", GLEntry);
        SourceName := BankAcc.Name;
        // [WHEN] Pressing Show Source Card
        GLEntries.OpenView();
        GLEntries.GoToRecord(GLEntry);
        GLEntries."O4N SourceCard".Invoke();
        // [THEN] source card should open with correct source name
        // Verified in handler

        // [WHEN] Pressing Source Name Drilldown
        GLEntries."O4N Source Name".Drilldown();
        // [THEN] source card should open with correct source name
        // Verified in handler

    end;

    [PageHandler]
    procedure BankAccountCardRunHandler(var BankAccCard: TestPage "Bank Account Card")
    begin
        Assert.AreEqual(BankAccCard.Name.Value(), SourceName, StrSubstNo(PageErr, BankAccCard.Caption()));
    end;

    [Test]
    [HandlerFunctions('FACardRunHandler,GLSourceNamesDrillDownPageHandler')]
    procedure TestShowFACard()
    var
        GLEntry: Record "G/L Entry";
        FA: record "Fixed Asset";
        GLEntries: TestPage "General Ledger Entries";
        SourceType: Enum "Gen. Journal Source Type";
    begin
        // [SCENARIO] Test G/L Entry Source Card Lookup Action
        // [GIVEN] Default setup, new master record and G/L Entry
        Initialize();
        FALib.CreateFixedAsset(FA);
        CreateCLEntry(SourceType::"Fixed Asset", FA."No.", GLEntry);
        SourceName := FA.Description;
        // [WHEN] Pressing Show Source Card
        GLEntries.OpenView();
        GLEntries.GoToRecord(GLEntry);
        GLEntries."O4N SourceCard".Invoke();
        // [THEN] source card should open with correct source name
        // Verified in handler

        // [WHEN] Pressing Source Name Drilldown
        GLEntries."O4N Source Name".Drilldown();
        // [THEN] source card should open with correct source name
        // Verified in handler

    end;

    [PageHandler]
    procedure FACardRunHandler(var FACard: TestPage "Fixed Asset Card")
    begin
        Assert.AreEqual(FACard.Description.Value(), SourceName, StrSubstNo(PageErr, FACard.Caption()));
    end;

    [Test]
    [HandlerFunctions('EmployeeCardRunHandler,GLSourceNamesDrillDownPageHandler')]
    procedure TestShowEmployeeCard()
    var
        GLEntry: Record "G/L Entry";
        Employee: record Employee;
        GLEntries: TestPage "General Ledger Entries";
        SourceType: Enum "Gen. Journal Source Type";
    begin
        // [SCENARIO] Test G/L Entry Source Card Lookup Action
        // [GIVEN] DeEmployeeult setup, new master record and G/L Entry
        Initialize();
        EmplLib.CreateEmployee(Employee);
        CreateCLEntry(SourceType::Employee, Employee."No.", GLEntry);
        SourceName := Employee."First Name";
        // [WHEN] Pressing Show Source Card
        GLEntries.OpenView();
        GLEntries.GoToRecord(GLEntry);
        GLEntries."O4N SourceCard".Invoke();
        // [THEN] source card should open with correct source name
        // Verified in handler

        // [WHEN] Pressing Source Name Drilldown
        GLEntries."O4N Source Name".Drilldown();
        // [THEN] source card should open with correct source name
        // Verified in handler

    end;

    [PageHandler]
    procedure EmployeeCardRunHandler(var EmployeeCard: TestPage "Employee Card")
    begin
        Assert.AreEqual(EmployeeCard."First Name".Value(), SourceName, StrSubstNo(PageErr, EmployeeCard.Caption()));
    end;

    [PageHandler]
    procedure GLSourceNamesDrillDownPageHandler(var DrilldownPage: TestPage "O4N GL SNs DrillDown")
    begin
        // Do nothing        
    end;

    local procedure Initialize()
    var
        GLSourceName: Record "O4N GL SN";
        GLSourceNameSetup: Record "O4N GL SN Setup";
        CompanyInfo: Record "Company Information";
    begin
        GLSourceNameSetup.DeleteAll();
        GLSourceName.DeleteAll();
        if not CompanyInfo.Get() then
            CompanyInfo.Insert();
        CompanyInfo."Registration No." := '';
        CompanyInfo.Modify();
        EmplLib.SetupEmployeeNumberSeries();
    end;

    local procedure CreateCLEntry(SourceType: Enum "Gen. Journal Source Type"; SourceNo: Code[20]; var GLEntry: Record "G/L Entry")
    begin
        if not GLEntry.FindLast() then;
        GLEntry."Entry No." += 1;
        GLEntry.Init();
        GLEntry."Source Type" := SourceType;
        GLEntry."Source No." := SourceNo;
        GLEntry.Insert();
        Commit();
    end;

    local procedure TestLookupIsEmpty()
    var
        GLSourceName: record "O4N GL SN";
    begin
        Assert.RecordIsNotEmpty(GLSourceName);
    end;

    local procedure TestLookupIsNotEmpty()
    var
        GLSourceName: record "O4N GL SN";
    begin
        Assert.RecordIsEmpty(GLSourceName);
    end;

    local procedure TestLookupNoOfRecords(ExpectedNoOfRecords: Integer)
    var
        GLSourceName: record "O4N GL SN";
    begin
        Assert.RecordCount(GLSourceName, ExpectedNoOfRecords);
    end;

    local procedure TestSourceExistsInLookupTable(SourceType: Enum "Gen. Journal Source Type"; SourceNo: code[20])
    var
        GLSourceName: record "O4N GL SN";
    begin
        GLSourceName.SetRange("Source Type", SourceType);
        GLSourceName.SetRange("Source No.", SourceNo);
        Assert.RecordIsNotEmpty(GLSourceName);
    end;

    local procedure TestSourceNotExistsInLookupTable(SourceType: Enum "Gen. Journal Source Type"; SourceNo: code[20])
    var
        GLSourceName: record "O4N GL SN";
    begin
        GLSourceName.SetRange("Source Type", SourceType);
        GLSourceName.SetRange("Source No.", SourceNo);
        Assert.RecordIsEmpty(GLSourceName);
    end;

    local procedure TestSourceNameInLookupTable(SourceType: Enum "Gen. Journal Source Type"; SourceNo: code[20]; SourceName: Text[100])
    var
        GLSourceName: record "O4N GL SN";
    begin
        with GLSourceName do begin
            SetRange("Source Type", SourceType);
            SetRange("Source No.", SourceNo);
            FindFirst();
            Assert.AreEqual(SourceName, "Source Name", StrSubstNo(SourceNameUpdateFailesErr, "Source Type", "Source No."));
        end;
    end;


}