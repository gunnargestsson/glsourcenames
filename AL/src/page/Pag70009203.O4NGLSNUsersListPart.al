page 70009203 "O4N GL SN Users ListPart"
{

  DeleteAllowed=false;
  InsertAllowed=false;
  LinksAllowed=false;
  PageType=ListPart;
  SourceTable="O4N GL SN User Access";
  SourceTableTemporary=true;

  layout
  {
    area(content)
    {
      repeater(Group)
      {
        field("Permission Level";"Permission Level")
        {
          ApplicationArea=Basic,Suite;
          Editable=false;
          ToolTip='Indicates whether the user has full access or just read access to G/L Source Names Lookup table';
          Visible=false;
        }
        field("User Name";"User Name")
        {
          ApplicationArea=Basic,Suite;
          Editable=false;
          Visible=false;
        }
        field("User Full Name";"User Full Name")
        {
          ApplicationArea=Basic,Suite;
          Editable=false;
        }
        field("User Group Member";"Access Via User Group Code" <> '')
        {
          ApplicationArea=Basic,Suite;
          Caption='User Group Member';
          Editable=false;
          ToolTip='Indicates if this user is a member of a user group in one of the previous steps.';
        }
        field("Has Permission";"Has Permission")
        {
          ApplicationArea=Basic,Suite;
          Editable=false;
          ToolTip='Indicates whether the user already has required permissions';
        }
        field("Assign Permission";"Assign Permission")
        {
          ApplicationArea=Basic,Suite;
          Editable=NOT HasPermission;
          ToolTip='This will assign the required permission to this user when the wizard completes.';
        }
        field("Remove Permission";"Remove Permission")
        {
          ApplicationArea=Basic,Suite;
          Editable=HasPermission;
          ToolTip='This will remove current permission from this user when the wizard completes.';
        }
      }
    }
  }

  actions
  {
  }

  trigger OnAfterGetCurrRecord();
  begin
    HasPermission := "Has Permission";
  end;

  var
    HasPermission : Boolean;

  procedure Set(var TempUserAccess : Record "O4N GL SN User Access" temporary);
  begin
    COPY(TempUserAccess,true);
  end;
}


