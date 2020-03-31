table 70009203 "O4N GL SN User Access"
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
    field(2;"User Security ID";Guid)
    {
      Caption='User Security ID';
      NotBlank=true;
      TableRelation=User;
      DataClassification=SystemMetadata;
    }
    field(3;"Access Via User Group Code";Code[20])
    {
      Caption='Access Via User Group Code';
      NotBlank=true;
      TableRelation="User Group";
      DataClassification=SystemMetadata;
    }
    field(4;"User Name";Code[50])
    {
      CalcFormula=Lookup(User."User Name" WHERE ("User Security ID"=FIELD("User Security ID")));
      Caption='User Name';
      Editable=false;
      FieldClass=FlowField;
    }
    field(5;"User Full Name";Text[80])
    {
      CalcFormula=Lookup(User."Full Name" WHERE ("User Security ID"=FIELD("User Security ID")));
      Caption='User Full Name';
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

      trigger OnValidate();
      begin
        "Updated Via User Group" := false;
      end;
    }
    field(8;"Remove Permission";Boolean)
    {
      Caption='Remove Permission';
      DataClassification=SystemMetadata;

      trigger OnValidate();
      begin
        "Updated Via User Group" := false;
      end;
    }
    field(9;"Updated Via User Group";Boolean)
    {
      Caption='Updated Via User Group';
      DataClassification=SystemMetadata;
    }
  }

  keys
  {
    key(Key1;"Permission Level","User Security ID")
    {
      Clustered=true;
    }
  }

  fieldgroups
  {
  }
}


