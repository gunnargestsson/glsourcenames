table 70009204 "O4N GL SN Group Access"
{

  fields
  {
    field(1;"Permission Level";Option)
    {
      Caption='Permission Level';
      OptionCaption='Read,Update';
      OptionMembers=Read,Update;
      DataClassification=SystemMetadata;
    }
    field(2;"User Group Code";Code[20])
    {
      Caption='User Group Code';
      NotBlank=true;
      TableRelation="User Group";
      DataClassification=SystemMetadata;
    }
    field(4;"User Group Name";Text[50])
    {
      CalcFormula=Lookup("User Group".Name WHERE (Code=FIELD("User Group Code")));
      Caption='User Group Name';
      Editable=false;
      FieldClass=FlowField;      
    }
    field(6;"Has Permission";Boolean)
    {
      Caption='Has Permission';
      DataClassification=SystemMetadata;
    }
    field(7;"Assign Permission";Boolean)
    {
      Caption='Assign Permission';
      DataClassification=SystemMetadata;
    }
    field(8;"Remove Permission";Boolean)
    {
      Caption='Remove Permission';
      DataClassification=SystemMetadata;
    }
  }

  keys
  {
    key(Key1;"Permission Level","User Group Code")
    {
      Clustered=true;
    }
  }

  fieldgroups
  {
  }
}


