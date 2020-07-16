pageextension 70009201 "O4N Ext GL Entries" extends "General Ledger Entries"
{
    // version NAVW111.0,GLSN10.0

    layout
    {
        addafter("Bal. Account No.")
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
        addafter("Value Entries")
        {
            action("O4N SourceCard")
            {
                AccessByPermission = TableData "O4N GL SN" = R;
                ApplicationArea = Basic, Suite;
                Caption = 'Source Card';
                Image = Card;
                RunObject = Codeunit "O4N GL Show Source Card";
                ToolTip = 'Show the card for the master record defined as the source for this entry';
            }
        }
    }
}


