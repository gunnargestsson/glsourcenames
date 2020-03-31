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
                field("Code"; Code)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the code for the help resource';
                }
                field(Url; Url)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the url for the help resource';
                }
                field(Icon; Icon)
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
        InitializeResources();
    end;
}


