page 70009203 "O4N GL SN Users ListPart"
{

    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "O4N GL SN User Access";
    SourceTableTemporary = true;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Permission Level"; Rec."Permission Level")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Indicates whether the user has full access or just read access to G/L Source Names Lookup table';
                    Visible = false;
                }
                field("User Name"; Rec."User Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the user''s name. If the user is required to present credentials when starting the client, this is the name that the user must present.';
                    Editable = false;
                    Visible = false;
                }
                field("User Full Name"; Rec."User Full Name")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the full name of the user.';
                }
                field("User Group Member"; Rec."Access Via User Group Code" <> '')
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'User Group Member';
                    Editable = false;
                    ToolTip = 'Indicates if this user is a member of a user group in one of the previous steps.';
                }
                field("Has Permission"; Rec."Has Permission")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Indicates whether the user already has required permissions';
                }
                field("Assign Permission"; Rec."Assign Permission")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = NOT HasPermission;
                    ToolTip = 'This will assign the required permission to this user when the wizard completes.';
                }
                field("Remove Permission"; Rec."Remove Permission")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = HasPermission;
                    ToolTip = 'This will remove current permission from this user when the wizard completes.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord();
    begin
        HasPermission := Rec."Has Permission";
    end;

    var
        HasPermission: Boolean;

    /// <summary> 
    /// Description for Set.
    /// </summary>
    /// <param name="TempUserAccess">Parameter of type Record "O4N GL SN User Access" temporary.</param>
    procedure Set(var TempUserAccess: Record "O4N GL SN User Access" temporary);
    begin
        Rec.COPY(TempUserAccess, true);
    end;
}


