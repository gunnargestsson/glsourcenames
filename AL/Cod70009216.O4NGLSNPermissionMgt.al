codeunit 70009216 "O4N GL SN Permission Mgt"
{

  trigger OnRun();
  begin
  end;

  var
    ReadRoleId : Label 'G/L-SOURCE NAMES',Locked=true;
    UpdateRoleId : Label 'G/L-SOURCE NAMES, E',Locked=true;

  procedure GetAccessControl(var TempUserAccess : Record "O4N GL SN User Access" temporary;var TempGroupAccess : Record "O4N GL SN Group Access" temporary);
  begin
    GetReadOnlyMembers(TempUserAccess,TempGroupAccess);
    GetUpdateMembers(TempUserAccess,TempGroupAccess);
  end;

  procedure SetAccessControl(var TempUserAccess : Record "O4N GL SN User Access" temporary;var TempGroupAccess : Record "O4N GL SN Group Access" temporary);
  begin
    UpdateUserAccessControl(TempUserAccess);
    UpdateGroupAccessControl(TempGroupAccess);
  end;

  procedure SuggestAccessControl(var TempUserAccess : Record "O4N GL SN User Access" temporary;var TempGroupAccess : Record "O4N GL SN Group Access" temporary);
  var
    LocalTempUserAccess : Record "O4N GL SN User Access" temporary;
    LocalTempGroupAccess : Record "O4N GL SN Group Access" temporary;
  begin
    with LocalTempGroupAccess do begin
      COPY(TempGroupAccess,true);
      SETRANGE("Has Permission",false);
      MODIFYALL("Assign Permission",true);
    end;
    with LocalTempUserAccess do begin
      COPY(TempUserAccess,true);
      SETRANGE("Has Permission",false);
      MODIFYALL("Assign Permission",true);
    end;
  end;

  local procedure UpdateUserAccessControl(var TempUserAccess : Record "O4N GL SN User Access" temporary);
  var
    LocalTempUserAccess : Record "O4N GL SN User Access" temporary;
  begin
    with LocalTempUserAccess do begin
      COPY(TempUserAccess,true);
      SETRANGE("Assign Permission",true);
      SETRANGE("Updated Via User Group",false);
      if FIND('-') then repeat
        AddUserAccess("User Security ID","Permission Level");
      until NEXT = 0;
      SETRANGE("Assign Permission");
      SETRANGE("Remove Permission",true);
      if FIND('-') then repeat
        RemoveUserAccess("User Security ID","Permission Level");
      until NEXT = 0;
      RESET;
    end;
  end;

  local procedure UpdateGroupAccessControl(var TempGroupAccess : Record "O4N GL SN Group Access" temporary);
  var
    LocalTempGroupAccess : Record "O4N GL SN Group Access" temporary;
  begin
    with LocalTempGroupAccess do begin
      COPY(TempGroupAccess,true);
      SETRANGE("Assign Permission",true);
      if FIND('-') then repeat
        AddGroupAccess("User Group Code","Permission Level");
      until NEXT = 0;
      SETRANGE("Assign Permission");
      SETRANGE("Remove Permission",true);
      if FIND('-') then repeat
        RemoveGroupAccess("User Group Code","Permission Level");
      until NEXT = 0;
      RESET;
    end;
  end;

  local procedure GetReadOnlyMembers(var TempUserAccess : Record "O4N GL SN User Access" temporary;var TempGroupAccess : Record "O4N GL SN Group Access" temporary);
  var
    TempUser : Record User temporary;
    TempUserGroup : Record "User Group" temporary;
  begin
    WhoThatCanView(DATABASE::"G/L Entry",TempUser,TempUserGroup);

    CopyUserGroups(TempUserGroup,TempGroupAccess,TempGroupAccess."Permission Level"::Read);
    CopyUsers(TempUser,TempUserAccess,TempGroupAccess,TempGroupAccess."Permission Level"::Read);
  end;

  local procedure GetUpdateMembers(var TempUserAccess : Record "O4N GL SN User Access" temporary;var TempGroupAccess : Record "O4N GL SN Group Access" temporary);
  var
    TempUser : Record User temporary;
    TempUserGroup : Record "User Group" temporary;
  begin
    WhoThatCanUpdate(DATABASE::Customer,TempUser,TempUserGroup);
    WhoThatCanUpdate(DATABASE::Vendor,TempUser,TempUserGroup);
    WhoThatCanUpdate(DATABASE::"Bank Account",TempUser,TempUserGroup);
    WhoThatCanUpdate(DATABASE::"Fixed Asset",TempUser,TempUserGroup);
    WhoThatCanUpdate(DATABASE::Employee,TempUser,TempUserGroup);

    CopyUserGroups(TempUserGroup,TempGroupAccess,TempGroupAccess."Permission Level"::Update);
    CopyUsers(TempUser,TempUserAccess,TempGroupAccess,TempGroupAccess."Permission Level"::Update);
  end;

  local procedure CopyUserGroups(var TempUserGroup : Record "User Group" temporary;var TempGroupAccess : Record "O4N GL SN Group Access" temporary;PermissionLevel : Option);
  begin
    with TempUserGroup do
      if FIND('-') then repeat
        TempGroupAccess.INIT;
        TempGroupAccess."Permission Level" := PermissionLevel;
        TempGroupAccess."User Group Code" := Code;
        TempGroupAccess."Has Permission" := GroupHasAccess(Code,PermissionLevel);
        TempGroupAccess.INSERT;
      until NEXT = 0;
  end;

  local procedure CopyUsers(var TempUser : Record User temporary;var TempUserAccess : Record "O4N GL SN User Access" temporary;var TempGroupAccess : Record "O4N GL SN Group Access" temporary;PermissionLevel : Option);
  begin
    with TempUser do
      if FIND('-') then repeat
        TempUserAccess.INIT;
        TempUserAccess."Permission Level" := PermissionLevel;
        TempUserAccess."User Security ID" := "User Security ID";
        TempUserAccess."Access Via User Group Code" := HasAccessViaGroup(TempUserAccess,TempGroupAccess);
        TempUserAccess."Updated Via User Group" := TempUserAccess."Access Via User Group Code" <> '';
        TempUserAccess."Has Permission" := UserHasAccess("User Security ID",PermissionLevel);
        TempUserAccess.INSERT;
      until NEXT = 0;
  end;

  local procedure WhoThatCanView(TableId : Integer;var TempUser : Record User temporary;var TempUserGroup : Record "User Group" temporary);
  var
    Permission : Record Permission;
  begin
    with Permission do begin
      SETRANGE("Object Type","Object Type"::"Table Data");
      SETRANGE("Object ID",TableId);
      SETRANGE("Read Permission","Read Permission"::Yes);
      if FINDSET then repeat
        AddUsersFromAccessControl("Role ID",TempUser);
        AddGroupFromAccessControl("Role ID",TempUserGroup);
      until NEXT = 0;
    end;
  end;

  local procedure WhoThatCanUpdate(TableId : Integer;var TempUser : Record User temporary;var TempUserGroup : Record "User Group" temporary);
  var
    Permission : Record Permission;
  begin
    with Permission do begin
      SETRANGE("Object Type","Object Type"::"Table Data");
      SETRANGE("Object ID",TableId);
      SETRANGE("Modify Permission","Modify Permission"::Yes);
      if FINDSET then repeat
        AddUsersFromAccessControl("Role ID",TempUser);
        AddGroupFromAccessControl("Role ID",TempUserGroup);
      until NEXT = 0;
    end;
  end;

  local procedure AddUsersFromAccessControl(PermissionSetId : Code[20];var TempUser : Record User temporary);
  var
    AccessControl : Record "Access Control";
    User : Record User;
  begin
    with AccessControl do begin
      SETRANGE("Role ID",PermissionSetId);
      SETFILTER("Company Name",'%1|%2',COMPANYNAME,'');
      if FINDSET then repeat
        if not TempUser.GET("User Security ID") then
          if User.GET("User Security ID") then begin
            TempUser := User;
            TempUser.INSERT;
          end;
      until NEXT = 0;
    end;
  end;

  local procedure AddGroupFromAccessControl(PermissionSetId : Code[20];var TempUserGroup : Record "User Group" temporary);
  var
    UserGroup : Record "User Group";
    AccessControl : Record "User Group Access Control";
  begin
    with AccessControl do begin
      SETRANGE("Role ID",PermissionSetId);
      SETFILTER("Company Name",'%1|%2',COMPANYNAME,'');
      if FINDSET then repeat
        if not TempUserGroup.GET("User Group Code") then
          if UserGroup.GET("User Group Code") then begin
            TempUserGroup := UserGroup;
            TempUserGroup.INSERT;
          end;
      until NEXT = 0;
    end;
  end;

  local procedure HasAccessViaGroup(TempUserAccess : Record "O4N GL SN User Access" temporary;var TempGroupAccess : Record "O4N GL SN Group Access" temporary) : Code[20];
  var
    UserGroupMember : Record "User Group Member";
    TempUserGroupAccess : Record "O4N GL SN Group Access" temporary;
  begin
    UserGroupMember.SETRANGE("User Security ID",TempUserAccess."User Security ID");
    with TempUserGroupAccess do begin
      COPY(TempGroupAccess,true);
      SETRANGE("Permission Level","Permission Level");
      if FIND('-') then repeat
        UserGroupMember.SETRANGE("User Group Code","User Group Code");
        if UserGroupMember.FINDFIRST then
          exit(UserGroupMember."User Group Code");
      until NEXT = 0;
    end;
  end;

  local procedure UserHasAccess(UserSid : Guid;PermissionLevel : Option Read,Update) : Boolean;
  var
    AccessControl : Record "Access Control";
    AppMgt : Codeunit "O4N GL SN App Mgt.";
    AppGuid : Guid;
  begin
    EVALUATE(AppGuid,AppMgt.GetAppId);
    with AccessControl do begin
      SETRANGE("User Security ID",UserSid);
      SETFILTER("Company Name",'%1|%2',COMPANYNAME,'');
      SETRANGE("App ID",AppGuid);
      SETRANGE(Scope,Scope::Tenant);
      case PermissionLevel of
        PermissionLevel::Read:
          SETRANGE("Role ID",ReadRoleId);
        PermissionLevel::Update:
          SETRANGE("Role ID",UpdateRoleId);
      end;
      exit(not ISEMPTY);
    end;
  end;

  local procedure GroupHasAccess(GroupCode : Code[20];PermissionLevel : Option Read,Update) : Boolean;
  var
    UserGroupPermissionSet : Record "User Group Permission Set";
    AppMgt : Codeunit "O4N GL SN App Mgt.";
    AppGuid : Guid;
  begin
    EVALUATE(AppGuid,AppMgt.GetAppId);
    with UserGroupPermissionSet do begin
      SETRANGE("User Group Code",GroupCode);
      SETRANGE("App ID",AppGuid);
      SETRANGE(Scope,Scope::Tenant);
      case PermissionLevel of
        PermissionLevel::Read:
          SETRANGE("Role ID",ReadRoleId);
        PermissionLevel::Update:
          SETRANGE("Role ID",UpdateRoleId);
      end;
      exit(not ISEMPTY);
    end;
  end;

  local procedure AddUserAccess(UserSid : Guid;PermissionLevel : Option Read,Update) : Boolean;
  var
    AccessControl : Record "Access Control";
    AppMgt : Codeunit "O4N GL SN App Mgt.";
    AppGuid : Guid;
  begin
    EVALUATE(AppGuid,AppMgt.GetAppId);
    with AccessControl do begin
      INIT;
      "User Security ID" := UserSid;
      "App ID" := AppGuid;
      "Company Name" := COMPANYNAME;
      Scope := Scope::Tenant;
      case PermissionLevel of
        PermissionLevel::Read:
          "Role ID" := ReadRoleId;
        PermissionLevel::Update:
          "Role ID" := UpdateRoleId;
      end;
      INSERT(true);
    end;
  end;

  local procedure AddGroupAccess(GroupCode : Code[20];PermissionLevel : Option Read,Update) : Boolean;
  var
    UserGroupPermissionSet : Record "User Group Permission Set";
    AppMgt : Codeunit "O4N GL SN App Mgt.";
    AppGuid : Guid;
  begin
    EVALUATE(AppGuid,AppMgt.GetAppId);
    with UserGroupPermissionSet do begin
      INIT;
      "User Group Code" := GroupCode;
      "App ID" := AppGuid;
      Scope := Scope::Tenant;
      case PermissionLevel of
        PermissionLevel::Read:
          "Role ID" := ReadRoleId;
        PermissionLevel::Update:
          "Role ID" := UpdateRoleId;
      end;
      INSERT(true);
    end;
  end;

  local procedure RemoveUserAccess(UserSid : Guid;PermissionLevel : Option Read,Update) : Boolean;
  var
    AccessControl : Record "Access Control";
    AppMgt : Codeunit "O4N GL SN App Mgt.";
    AppGuid : Guid;
  begin
    EVALUATE(AppGuid,AppMgt.GetAppId);
    with AccessControl do begin
      SETRANGE("User Security ID",UserSid);
      SETFILTER("Company Name",'%1|%2',COMPANYNAME,'');
      SETRANGE("App ID",AppGuid);
      SETRANGE(Scope,Scope::Tenant);
      case PermissionLevel of
        PermissionLevel::Read:
          SETRANGE("Role ID",ReadRoleId);
        PermissionLevel::Update:
          SETRANGE("Role ID",UpdateRoleId);
      end;
      DELETEALL(true);
    end;
  end;

  local procedure RemoveGroupAccess(GroupCode : Code[20];PermissionLevel : Option Read,Update) : Boolean;
  var
    UserGroupPermissionSet : Record "User Group Permission Set";
    AppMgt : Codeunit "O4N GL SN App Mgt.";
    AppGuid : Guid;
  begin
    EVALUATE(AppGuid,AppMgt.GetAppId);
    with UserGroupPermissionSet do begin
      SETRANGE("User Group Code",GroupCode);
      SETRANGE("App ID",AppGuid);
      SETRANGE(Scope,Scope::Tenant);
      case PermissionLevel of
        PermissionLevel::Read:
          SETRANGE("Role ID",ReadRoleId);
        PermissionLevel::Update:
          SETRANGE("Role ID",UpdateRoleId);
      end;
      DELETEALL(true);
    end;
  end;
}


