codeunit 70009248 "O4N G/L Test Installation"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        ALTestSuite: Record "AL Test Suite";
        ALObjects: Record AllObjWithCaption;
        TestSuiteName: Code[20];
    begin
        CreateTestSuite(TestSuiteName, ALTestSuite);
        GetUnitTests(ALObjects);
        AddTestsToSuite(ALTestSuite, ALObjects);
    end;

    local procedure CreateTestSuite(TestSuiteName: Code[20]; var ALTestSuite: Record "AL Test Suite")
    var
        TestSuite: Codeunit "Test Suite Mgt.";
    begin
        if ALTestSuite.Get(TestSuiteName) then exit;
        TestSuite.CreateTestSuite(TestSuiteName);
        ALTestSuite.Get(TestSuiteName);
    end;

    local procedure GetUnitTests(var ALObjects: Record AllObjWithCaption)
    begin
        ALObjects.SetRange("Object Type", ALObjects."Object Type"::Codeunit);
        ALObjects.SetRange("Object ID", Codeunit::"O4N GL Test Codeunits");
        ALObjects.FindFirst();
    end;

    local procedure AddTestsToSuite(var ALTestSuite: Record "AL Test Suite"; var ALObjects: Record AllObjWithCaption)
    var
        TestSuite: Codeunit "Test Suite Mgt.";
    begin
        TestSuite.DeleteAllMethods(ALTestSuite);
        TestSuite.GetTestMethods(ALTestSuite, ALObjects);
    end;



}