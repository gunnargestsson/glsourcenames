page 70009201 "O4N GL SN Setup"
{

  Caption='G/L Source Name Setup';
  DeleteAllowed=false;
  InsertAllowed=false;
  PageType=Card;
  SourceTable="O4N GL SN Setup";
  UsageCategory=Administration;
  ApplicationArea=Basic,Suite;

  layout
  {
    area(content)
    {
      group(General)
      {
        field("Registration E-Mail Address";"Registration E-Mail Address")
        {
          ApplicationArea=Basic,Suite;
          ShowMandatory=true;
          ToolTip='The G/L Source Name Extension will be registered on this E-Mail Address.  When registering the registration key will be sent to this E-Mail Address.';
        }
        field("Next Registration Verification";"Next Registration Verification")
        {
          ApplicationArea=Basic,Suite;
          Visible=false;
          Editable=false;
        }
      }
    }
  }

  actions
  {
  }

  trigger OnOpenPage();
  begin
    if ISEMPTY then begin
      INIT;
      INSERT;
    end;
  end;
}


