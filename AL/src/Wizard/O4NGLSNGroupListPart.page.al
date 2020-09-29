page 70009204 "O4N GL SN Group ListPart"
{

    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "O4N GL SN Group Access";
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
                    ToolTip = 'Indicates whether members of this user group have full access or just read access to G/L Source Names Lookup table';
                    Visible = false;
                }
                field("User Group Code"; Rec."User Group Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the code representing the user group.';
                }
                field("User Group Name"; Rec."User Group Name")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the user group name.';
                }
                field("Has Permission"; Rec."Has Permission")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Indicates whether the user that are member of this user group already have required permissions';
                }
                field("Assign Permission"; Rec."Assign Permission")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = NOT HasPermission;
                    ToolTip = 'This will assign the required permission to the members of this user group when the wizard completes.';

                    trigger OnValidate();
                    begin
                        GlobalTempUserAccess.SETRANGE("Permission Level", Rec."Permission Level");
                        GlobalTempUserAccess.SETRANGE("Access Via User Group Code", Rec."User Group Code");
                        GlobalTempUserAccess.SETRANGE("Updated Via User Group", true);
                        GlobalTempUserAccess.MODIFYALL("Assign Permission", Rec."Assign Permission");
                    end;
                }
                field("Remove Permission"; Rec."Remove Permission")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = HasPermission;
                    ToolTip = 'This will remove current permission from the members of this user group when the wizard completes.';

                    trigger OnValidate();
                    begin
                        GlobalTempUserAccess.SETRANGE("Permission Level", Rec."Permission Level");
                        GlobalTempUserAccess.SETRANGE("Access Via User Group Code", Rec."User Group Code");
                        GlobalTempUserAccess.SETRANGE("Updated Via User Group", true);
                        GlobalTempUserAccess.MODIFYALL("Remove Permission", Rec."Remove Permission");
                    end;
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
        GlobalTempUserAccess: Record "O4N GL SN User Access" temporary;
        HasPermission: Boolean;

    /// <summary> 
    /// Description for Set.
    /// </summary>
    /// <param name="TempGroupAccess">Parameter of type Record "O4N GL SN Group Access" temporary.</param>
    /// <param name="TempUserAccess">Parameter of type Record "O4N GL SN User Access" temporary.</param>
    procedure Set(var TempGroupAccess: Record "O4N GL SN Group Access" temporary; var TempUserAccess: Record "O4N GL SN User Access" temporary);
    begin
        Rec.COPY(TempGroupAccess, true);
        GlobalTempUserAccess.COPY(TempUserAccess, true);
    end;
}


