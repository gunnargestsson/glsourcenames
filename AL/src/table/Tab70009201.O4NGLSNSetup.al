table 70009201 "O4N GL SN Setup"
{

  fields
  {
    field(1;"Primary Key";Code[10])
    {
      Caption='Primary Key';
      DataClassification=SystemMetadata;
    }
    field(2;"Registration E-Mail Address";Text[50])
    {
      Caption='Registration E-Mail Address';
      DataClassification=EndUserIdentifiableInformation;
    }
    field(3;"Installation Id";Guid)
    {
      Caption='Installation Id';
      DataClassification=SystemMetadata;
    }
    field(4;"Registration Id";Guid)
    {
      Caption='Registration Id';
      DataClassification=SystemMetadata;
    }
    field(5;"Next Registration Verification";DateTime)
    {
      Caption='Next Registration Verification';
      DataClassification=SystemMetadata;
    }
    field(12;Status;Option)
    {
      Caption='Status';
      OptionCaption='Not Completed,Completed,Not Started,Seen,Watched,Read, ';
      OptionMembers="Not Completed",Completed,"Not Started",Seen,Watched,Read," ";
      DataClassification=SystemMetadata;
    }
    field(13;"Tour Id";Integer)
    {
      Caption='Tour Id';
      DataClassification=SystemMetadata;
    }
    field(14;"Video Status";Boolean)
    {
      Caption='Video Status';
      DataClassification=SystemMetadata;
    }
    field(15;"Help Status";Boolean)
    {
      Caption='Help Status';
      DataClassification=SystemMetadata;
    }
    field(16;"Tour Status";Boolean)
    {
      Caption='Tour Status';
      DataClassification=SystemMetadata;
    }
  }

  keys
  {
    key(Key1;"Primary Key")
    {
      Clustered=true;
    }
  }

  fieldgroups
  {
  }
}


