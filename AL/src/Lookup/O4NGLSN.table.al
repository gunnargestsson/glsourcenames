table 70009200 "O4N GL SN"
{

    DrillDownPageID = "O4N GL SNs DrillDown";

    fields
    {
        field(1; "Source Type"; Enum "Gen. Journal Source Type")
        {
            Caption = 'Source Type';
            DataClassification = CustomerContent;
        }
        field(2; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("Source Type" = CONST(Customer)) Customer
            ELSE
            IF ("Source Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Source Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Source Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Source Type" = CONST(Employee)) Employee;
        }
        field(3; "Source Name"; Text[100])
        {
            Caption = 'Source Name';
            DataClassification = CustomerContent;
        }
        field(41; "Item Ledger Source Type"; Enum "Analysis Source Type")
        {
            Caption = 'Item Ledger Source Type';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(Key1; "Source Type", "Source No.")
        {
            Clustered = true;
        }
        key(ItemKey; "Item Ledger Source Type", "Source No.")
        {

        }
    }

    fieldgroups
    {
    }
}


