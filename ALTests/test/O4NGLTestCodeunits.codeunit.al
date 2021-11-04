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
        AssistedSetup: Codeunit "Guided Experience";
        AssistedSetupPage: TestPage "Assisted Setup";
        GuidedExperienceType: Enum "Guided Experience Type";
    begin
        // [SCENARIO] Discovery for assisted setup should find the G/L Source Names Setup Wizard
        // [GIVEN] An temporary instance of assisted setup   
        // [WHEN] Discovery event is triggered
        AssistedSetupPage.OpenView();
        AssistedSetupPage.Close();
        // [THEN] Assisted setup for G/L Source Names should be found
        Assert.IsTrue(AssistedSetup.Exists(GuidedExperienceType::"Assisted Setup", ObjectType::Page, page::"O4N GL SN Setup Wizard"), 'Failed to verify the Assisted Setup Page registered');
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
        TestItemSourceType(SourceType, SourceNo);
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
        GLSourceName.SetRange("Source Type", SourceType);
        GLSourceName.SetRange("Source No.", SourceNo);
        GLSourceName.FindFirst();
        Assert.AreEqual(SourceName, GLSourceName."Source Name", StrSubstNo(SourceNameUpdateFailesErr, GLSourceName."Source Type", GLSourceName."Source No."));
    end;

    local procedure TestItemSourceType(SourceType: Enum "Gen. Journal Source Type"; SourceNo: code[20])
    var
        GLSourceName: record "O4N GL SN";
    begin
        GLSourceName.SetRange("Source Type", SourceType);
        GLSourceName.SetRange("Source No.", SourceNo);
        GLSourceName.FindFirst();
        case SourceType of
            GLSourceName."Source Type"::Customer:
                Assert.AreEqual(GLSourceName."Item Ledger Source Type"::Customer, GLSourceName."Item Ledger Source Type", StrSubstNo(SourceNameUpdateFailesErr, GLSourceName."Source Type", GLSourceName."Source No."));
            GLSourceName."Source Type"::Vendor:
                Assert.AreEqual(GLSourceName."Item Ledger Source Type"::Vendor, GLSourceName."Item Ledger Source Type", StrSubstNo(SourceNameUpdateFailesErr, GLSourceName."Source Type", GLSourceName."Source No."));
            else
                Assert.AreEqual(GLSourceName."Item Ledger Source Type"::" ", GLSourceName."Item Ledger Source Type", StrSubstNo(SourceNameUpdateFailesErr, GLSourceName."Source Type", GLSourceName."Source No."));
        end;
    end;

}