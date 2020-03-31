page 70009200 "O4N GL SN List"
{

  Caption='G/L Source Name List';
  Editable=false;
  PageType=List;
  SourceTable="O4N GL SN";

  layout
  {
    area(content)
    {
      repeater(Group)
      {
        field("Source Type";"Source Type")
        {
          ApplicationArea=Basic,Suite;
        }
        field("Source No.";"Source No.")
        {
          ApplicationArea=Basic,Suite;
        }
        field("Source Name";"Source Name")
        {
          ApplicationArea=Basic,Suite;
        }
      }
    }
  }

  actions
  {
  }
}


