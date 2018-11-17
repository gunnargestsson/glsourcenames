codeunit 50140 "TestMyALSolution"
{
    Subtype = Test;

    [Test]
    [HandlerFunctions('HelloWorldMessageHandler')]
    procedure TestHelloWorldMessage()
    var
        CustList: TestPage "Customer List";
    begin
        CustList.OpenView();
        CustList.Close();
        Assert.IsTrue(MessageDisplayed, 'Message was not displayed!');
    end;

    [MessageHandler]
    procedure HelloWorldMessageHandler(Message: Text[1024])
    begin
        MessageDisplayed := Message = 'App published: Hello world';
    end;

    var
        Assert: Codeunit Assert;
        MessageDisplayed: Boolean;
}