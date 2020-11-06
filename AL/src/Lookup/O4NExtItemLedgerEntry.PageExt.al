pageextension 70009200 "O4N Ext Item Ledger Entry" extends "Item Ledger Entries"
{

    layout
    {
        addbefore("Entry No.")
        {
            field("O4N Source Type"; Rec."Source Type")
            {
                AccessByPermission = TableData "O4N GL SN" = R;
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the type of the master record associated with this entry';
                Editable = false;
            }
            field("O4N Source No."; Rec."Source No.")
            {
                AccessByPermission = TableData "O4N GL SN" = R;
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the number of the master record associated with this entry';
                Visible = false;
                Editable = false;
            }
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
                RunObject = Codeunit "O4N Item Show Source Card";
                ToolTip = 'Show the card for the master record defined as the source for this entry';
            }
        }
    }
}


