page 70009202 "O4N GL SN Help Resources"
{

    Editable = false;
    PageType = List;
    SourceTable = "O4N GL SN Help Resource";
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the code for the help resource';
                }
                field(Url; Rec.Url)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the url for the help resource';
                }
                field(Icon; Rec.Icon)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the icon for the help resource';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin
        Rec.InitializeResources();
    end;
}


