tableextension 70009200 "O4N Ext Item Ledger Entry" extends "Item Ledger Entry"
{
    // version NAVW111.0,GLSN10.0

    fields
    {
        field(70009200; "O4N Source Name"; Text[100])
        {
            CalcFormula = Lookup("O4N GL SN"."Source Name" WHERE("Item Ledger Source Type" = FIELD("Source Type"),
                                                                "Source No." = FIELD("Source No.")));
            Caption = 'Source Name';
            Editable = false;
            FieldClass = FlowField;
        }
    }
    keys
    {
    }
}


