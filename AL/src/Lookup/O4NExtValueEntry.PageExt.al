pageextension 70009202 "O4N Ext Value Entry" extends "Value Entries"
{

    layout
    {
        addafter("Source No.")
        {
            field("O4N Source Name"; Rec."O4N Source Name")
            {
                AccessByPermission = TableData "O4N GL SN" = R;
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the name of the master record associated with this entry';
            }
        }
    }
    actions
    {
        addafter("&Navigate")
        {
            action("O4N SourceCard")
            {
                AccessByPermission = TableData "O4N GL SN" = R;
                ApplicationArea = Basic, Suite;
                Caption = 'Source Card';
                Image = Card;
                RunObject = Codeunit "O4N Value Show Source Card";
                ToolTip = 'Show the card for the master record defined as the source for this entry';
            }
        }
    }
}


