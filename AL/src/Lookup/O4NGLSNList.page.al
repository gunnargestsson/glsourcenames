page 70009200 "O4N GL SN List"
{

    Caption = 'G/L Source Name List';
    Editable = false;
    PageType = List;
    SourceTable = "O4N GL SN";
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the source type that specifies where the entry was created.';
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the source no. that specifies where the entry was created.';
                }
                field("Source Name"; Rec."Source Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the source name that specifies where the entry was created.';
                }
            }
        }
    }

    actions
    {
    }
}


