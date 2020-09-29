codeunit 70009216 "O4N GL SN Permission Mgt"
{

    trigger OnRun();
    begin
    end;

    var
        ReadRoleIdTxt: Label 'G/L-SOURCE NAMES', Locked = true;
        UpdateRoleIdTxt: Label 'G/L-SOURCE NAMES, E', Locked = true;

    /// <summary> 
    /// Description for GetAccessControl.
    /// </summary>
    /// <param name="TempUserAccess">Parameter of type Record "O4N GL SN User Access" temporary.</param>
    /// <param name="TempGroupAccess">Parameter of type Record "O4N GL SN Group Access" temporary.</param>
    procedure GetAccessControl(var TempUserAccess: Record "O4N GL SN User Access" temporary; var TempGroupAccess: Record "O4N GL SN Group Access" temporary);
    begin
        GetReadOnlyMembers(TempUserAccess, TempGroupAccess);
        GetUpdateMembers(TempUserAccess, TempGroupAccess);
    end;

    /// <summary> 
    /// Description for SetAccessControl.
    /// </summary>
    /// <param name="TempUserAccess">Parameter of type Record "O4N GL SN User Access" temporary.</param>
    /// <param name="TempGroupAccess">Parameter of type Record "O4N GL SN Group Access" temporary.</param>
    procedure SetAccessControl(var TempUserAccess: Record "O4N GL SN User Access" temporary; var TempGroupAccess: Record "O4N GL SN Group Access" temporary);
    begin
        UpdateUserAccessControl(TempUserAccess);
        UpdateGroupAccessControl(TempGroupAccess);
    end;

    /// <summary> 
    /// Description for SuggestAccessControl.
    /// </summary>
    /// <param name="TempUserAccess">Parameter of type Record "O4N GL SN User Access" temporary.</param>
    /// <param name="TempGroupAccess">Parameter of type Record "O4N GL SN Group Access" temporary.</param>
    procedure SuggestAccessControl(var TempUserAccess: Record "O4N GL SN User Access" temporary; var TempGroupAccess: Record "O4N GL SN Group Access" temporary);
    var
        TempUserAccessLocal: Record "O4N GL SN User Access" temporary;
        TempGroupAccessLocal: Record "O4N GL SN Group Access" temporary;
    begin
        TempGroupAccessLocal.COPY(TempGroupAccess, true);
        TempGroupAccessLocal.SETRANGE("Has Permission", false);
        TempGroupAccessLocal.MODIFYALL("Assign Permission", true);
        TempUserAccessLocal.COPY(TempUserAccess, true);
        TempUserAccessLocal.SETRANGE("Has Permission", false);
        TempUserAccessLocal.MODIFYALL("Assign Permission", true);
    end;

    /// <summary> 
    /// Description for UpdateUserAccessControl.
    /// </summary>
    /// <param name="TempUserAccess">Parameter of type Record "O4N GL SN User Access" temporary.</param>
    local procedure UpdateUserAccessControl(var TempUserAccess: Record "O4N GL SN User Access" temporary);
    var
        TempUserAccessLocal: Record "O4N GL SN User Access" temporary;
    begin
        TempUserAccessLocal.COPY(TempUserAccess, true);
        TempUserAccessLocal.SETRANGE("Assign Permission", true);
        TempUserAccessLocal.SETRANGE("Updated Via User Group", false);
        if TempUserAccessLocal.FIND('-') then
            repeat
                AddUserAccess(TempUserAccessLocal."User Security ID", TempUserAccessLocal."Permission Level");
            until TempUserAccessLocal.NEXT() = 0;
        TempUserAccessLocal.SETRANGE("Assign Permission");
        TempUserAccessLocal.SETRANGE("Remove Permission", true);
        if TempUserAccessLocal.FIND('-') then
            repeat
                RemoveUserAccess(TempUserAccessLocal."User Security ID", TempUserAccessLocal."Permission Level");
            until TempUserAccessLocal.NEXT() = 0;
        TempUserAccessLocal.RESET();
    end;

    /// <summary> 
    /// Description for UpdateGroupAccessControl.
    /// </summary>
    /// <param name="TempGroupAccess">Parameter of type Record "O4N GL SN Group Access" temporary.</param>
    local procedure UpdateGroupAccessControl(var TempGroupAccess: Record "O4N GL SN Group Access" temporary);
    var
        TempGroupAccessLocal: Record "O4N GL SN Group Access" temporary;
    begin
        TempGroupAccessLocal.COPY(TempGroupAccess, true);
        TempGroupAccessLocal.SETRANGE("Assign Permission", true);
        if TempGroupAccessLocal.FIND('-') then
            repeat
                AddGroupAccess(TempGroupAccessLocal."User Group Code", TempGroupAccessLocal."Permission Level");
            until TempGroupAccessLocal.NEXT() = 0;
        TempGroupAccessLocal.SETRANGE("Assign Permission");
        TempGroupAccessLocal.SETRANGE("Remove Permission", true);
        if TempGroupAccessLocal.FIND('-') then
            repeat
                RemoveGroupAccess(TempGroupAccessLocal."User Group Code", TempGroupAccessLocal."Permission Level");
            until TempGroupAccessLocal.NEXT() = 0;
        TempGroupAccessLocal.RESET();
    end;

    /// <summary> 
    /// Description for GetReadOnlyMembers.
    /// </summary>
    /// <param name="TempUserAccess">Parameter of type Record "O4N GL SN User Access" temporary.</param>
    /// <param name="TempGroupAccess">Parameter of type Record "O4N GL SN Group Access" temporary.</param>
    local procedure GetReadOnlyMembers(var TempUserAccess: Record "O4N GL SN User Access" temporary; var TempGroupAccess: Record "O4N GL SN Group Access" temporary);
    var
        TempUser: Record User temporary;
        TempUserGroup: Record "User Group" temporary;
    begin
        WhoThatCanView(DATABASE::"G/L Entry", TempUser, TempUserGroup);

        CopyUserGroups(TempUserGroup, TempGroupAccess, TempGroupAccess."Permission Level"::Read);
        CopyUsers(TempUser, TempUserAccess, TempGroupAccess, TempGroupAccess."Permission Level"::Read);
    end;

    /// <summary> 
    /// Description for GetUpdateMembers.
    /// </summary>
    /// <param name="TempUserAccess">Parameter of type Record "O4N GL SN User Access" temporary.</param>
    /// <param name="TempGroupAccess">Parameter of type Record "O4N GL SN Group Access" temporary.</param>
    local procedure GetUpdateMembers(var TempUserAccess: Record "O4N GL SN User Access" temporary; var TempGroupAccess: Record "O4N GL SN Group Access" temporary);
    var
        TempUser: Record User temporary;
        TempUserGroup: Record "User Group" temporary;
    begin
        WhoThatCanUpdate(DATABASE::Customer, TempUser, TempUserGroup);
        WhoThatCanUpdate(DATABASE::Vendor, TempUser, TempUserGroup);
        WhoThatCanUpdate(DATABASE::"Bank Account", TempUser, TempUserGroup);
        WhoThatCanUpdate(DATABASE::"Fixed Asset", TempUser, TempUserGroup);
        WhoThatCanUpdate(DATABASE::Employee, TempUser, TempUserGroup);

        CopyUserGroups(TempUserGroup, TempGroupAccess, TempGroupAccess."Permission Level"::Update);
        CopyUsers(TempUser, TempUserAccess, TempGroupAccess, TempGroupAccess."Permission Level"::Update);
    end;

    /// <summary> 
    /// Description for CopyUserGroups.
    /// </summary>
    /// <param name="TempUserGroup">Parameter of type Record "User Group" temporary.</param>
    /// <param name="TempGroupAccess">Parameter of type Record "O4N GL SN Group Access" temporary.</param>
    /// <param name="PermissionLevel">Parameter of type Option.</param>
    local procedure CopyUserGroups(var TempUserGroup: Record "User Group" temporary; var TempGroupAccess: Record "O4N GL SN Group Access" temporary; PermissionLevel: Option);
    begin
        if TempUserGroup.FIND('-') then
            repeat
                TempGroupAccess.INIT();
                TempGroupAccess."Permission Level" := PermissionLevel;
                TempGroupAccess."User Group Code" := TempUserGroup.Code;
                TempGroupAccess."Has Permission" := GroupHasAccess(TempUserGroup.Code, PermissionLevel);
                TempGroupAccess.INSERT();
            until TempUserGroup.NEXT() = 0;
    end;

    /// <summary> 
    /// Description for CopyUsers.
    /// </summary>
    /// <param name="TempUser">Parameter of type Record User temporary.</param>
    /// <param name="TempUserAccess">Parameter of type Record "O4N GL SN User Access" temporary.</param>
    /// <param name="TempGroupAccess">Parameter of type Record "O4N GL SN Group Access" temporary.</param>
    /// <param name="PermissionLevel">Parameter of type Option.</param>
    local procedure CopyUsers(var TempUser: Record User temporary; var TempUserAccess: Record "O4N GL SN User Access" temporary; var TempGroupAccess: Record "O4N GL SN Group Access" temporary; PermissionLevel: Option);
    begin
        if TempUser.FIND('-') then
            repeat
                TempUserAccess.INIT();
                TempUserAccess."Permission Level" := PermissionLevel;
                TempUserAccess."User Security ID" := TempUser."User Security ID";
                TempUserAccess."Access Via User Group Code" := HasAccessViaGroup(TempUserAccess, TempGroupAccess);
                TempUserAccess."Updated Via User Group" := TempUserAccess."Access Via User Group Code" <> '';
                TempUserAccess."Has Permission" := UserHasAccess(TempUser."User Security ID", PermissionLevel);
                TempUserAccess.INSERT();
            until TempUser.NEXT() = 0;
    end;

    /// <summary> 
    /// Description for WhoThatCanView.
    /// </summary>
    /// <param name="TableId">Parameter of type Integer.</param>
    /// <param name="TempUser">Parameter of type Record User temporary.</param>
    /// <param name="TempUserGroup">Parameter of type Record "User Group" temporary.</param>
    local procedure WhoThatCanView(TableId: Integer; var TempUser: Record User temporary; var TempUserGroup: Record "User Group" temporary);
    var
        Permission: Record Permission;
    begin
        Permission.SETRANGE("Object Type", Permission."Object Type"::"Table Data");
        Permission.SETRANGE("Object ID", TableId);
        Permission.SETRANGE("Read Permission", Permission."Read Permission"::Yes);
        if Permission.FINDSET() then
            repeat
                AddUsersFromAccessControl(Permission."Role ID", TempUser);
                AddGroupFromAccessControl(Permission."Role ID", TempUserGroup);
            until Permission.NEXT() = 0;
    end;

    /// <summary> 
    /// Description for WhoThatCanUpdate.
    /// </summary>
    /// <param name="TableId">Parameter of type Integer.</param>
    /// <param name="TempUser">Parameter of type Record User temporary.</param>
    /// <param name="TempUserGroup">Parameter of type Record "User Group" temporary.</param>
    local procedure WhoThatCanUpdate(TableId: Integer; var TempUser: Record User temporary; var TempUserGroup: Record "User Group" temporary);
    var
        Permission: Record Permission;
    begin
        Permission.SETRANGE("Object Type", Permission."Object Type"::"Table Data");
        Permission.SETRANGE("Object ID", TableId);
        Permission.SETRANGE("Modify Permission", Permission."Modify Permission"::Yes);
        if Permission.FINDSET() then
            repeat
                AddUsersFromAccessControl(Permission."Role ID", TempUser);
                AddGroupFromAccessControl(Permission."Role ID", TempUserGroup);
            until Permission.NEXT() = 0;
    end;

    /// <summary> 
    /// Description for AddUsersFromAccessControl.
    /// </summary>
    /// <param name="PermissionSetId">Parameter of type Code[20].</param>
    /// <param name="TempUser">Parameter of type Record User temporary.</param>
    local procedure AddUsersFromAccessControl(PermissionSetId: Code[20]; var TempUser: Record User temporary);
    var
        AccessControl: Record "Access Control";
        User: Record User;
    begin
        AccessControl.SETRANGE("Role ID", PermissionSetId);
        AccessControl.SETFILTER("Company Name", '%1|%2', COMPANYNAME, '');
        if AccessControl.FINDSET() then
            repeat
                if not TempUser.GET(AccessControl."User Security ID") then
                    if User.GET(AccessControl."User Security ID") then begin
                        TempUser := User;
                        TempUser.INSERT();
                    end;
            until AccessControl.NEXT() = 0;
    end;

    /// <summary> 
    /// Description for AddGroupFromAccessControl.
    /// </summary>
    /// <param name="PermissionSetId">Parameter of type Code[20].</param>
    /// <param name="TempUserGroup">Parameter of type Record "User Group" temporary.</param>
    local procedure AddGroupFromAccessControl(PermissionSetId: Code[20]; var TempUserGroup: Record "User Group" temporary);
    var
        UserGroup: Record "User Group";
        AccessControl: Record "User Group Access Control";
    begin
        AccessControl.SETRANGE("Role ID", PermissionSetId);
        AccessControl.SETFILTER("Company Name", '%1|%2', COMPANYNAME, '');
        if AccessControl.FINDSET() then
            repeat
                if not TempUserGroup.GET(AccessControl."User Group Code") then
                    if UserGroup.GET(AccessControl."User Group Code") then begin
                        TempUserGroup := UserGroup;
                        TempUserGroup.INSERT();
                    end;
            until AccessControl.NEXT() = 0;
    end;

    /// <summary> 
    /// Description for HasAccessViaGroup.
    /// </summary>
    /// <param name="TempUserAccess">Parameter of type Record "O4N GL SN User Access" temporary.</param>
    /// <param name="TempGroupAccess">Parameter of type Record "O4N GL SN Group Access" temporary.</param>
    /// <returns>Return variable "Code[20]".</returns>
    local procedure HasAccessViaGroup(TempUserAccess: Record "O4N GL SN User Access" temporary; var TempGroupAccess: Record "O4N GL SN Group Access" temporary): Code[20];
    var
        UserGroupMember: Record "User Group Member";
        TempUserGroupAccess: Record "O4N GL SN Group Access" temporary;
    begin
        UserGroupMember.SETRANGE("User Security ID", TempUserAccess."User Security ID");
        TempUserGroupAccess.COPY(TempGroupAccess, true);
        TempUserGroupAccess.SETRANGE("Permission Level", TempUserGroupAccess."Permission Level");
        if TempUserGroupAccess.FIND('-') then
            repeat
                UserGroupMember.SETRANGE("User Group Code", TempUserGroupAccess."User Group Code");
                if UserGroupMember.FINDFIRST() then
                    exit(UserGroupMember."User Group Code");
            until TempUserGroupAccess.NEXT() = 0;
    end;

    /// <summary> 
    /// Description for UserHasAccess.
    /// </summary>
    /// <param name="UserSid">Parameter of type Guid.</param>
    /// <param name="PermissionLevel">Parameter of type Option Read,Update.</param>
    /// <returns>Return variable "Boolean".</returns>
    local procedure UserHasAccess(UserSid: Guid; PermissionLevel: Option Read,Update): Boolean;
    var
        AccessControl: Record "Access Control";
        AppMgt: Codeunit "O4N GL SN App Mgt.";
        AppGuid: Guid;
    begin
        EVALUATE(AppGuid, AppMgt.GetAppId());
        AccessControl.SETRANGE("User Security ID", UserSid);
        AccessControl.SETFILTER("Company Name", '%1|%2', COMPANYNAME, '');
        AccessControl.SETRANGE("App ID", AppGuid);
        AccessControl.SETRANGE(Scope, AccessControl.Scope::Tenant);
        case PermissionLevel of
            PermissionLevel::Read:
                AccessControl.SETRANGE("Role ID", ReadRoleIdTxt);
            PermissionLevel::Update:
                AccessControl.SETRANGE("Role ID", UpdateRoleIdTxt);
        end;
        exit(not AccessControl.ISEMPTY());
    end;

    /// <summary> 
    /// Description for GroupHasAccess.
    /// </summary>
    /// <param name="GroupCode">Parameter of type Code[20].</param>
    /// <param name="PermissionLevel">Parameter of type Option Read,Update.</param>
    /// <returns>Return variable "Boolean".</returns>
    local procedure GroupHasAccess(GroupCode: Code[20]; PermissionLevel: Option Read,Update): Boolean;
    var
        UserGroupPermissionSet: Record "User Group Permission Set";
        AppMgt: Codeunit "O4N GL SN App Mgt.";
        AppGuid: Guid;
    begin
        EVALUATE(AppGuid, AppMgt.GetAppId());
        UserGroupPermissionSet.SETRANGE("User Group Code", GroupCode);
        UserGroupPermissionSet.SETRANGE("App ID", AppGuid);
        UserGroupPermissionSet.SETRANGE(Scope, UserGroupPermissionSet.Scope::Tenant);
        case PermissionLevel of
            PermissionLevel::Read:
                UserGroupPermissionSet.SETRANGE("Role ID", ReadRoleIdTxt);
            PermissionLevel::Update:
                UserGroupPermissionSet.SETRANGE("Role ID", UpdateRoleIdTxt);
        end;
        exit(not UserGroupPermissionSet.ISEMPTY());
    end;

    /// <summary> 
    /// Description for AddUserAccess.
    /// </summary>
    /// <param name="UserSid">Parameter of type Guid.</param>
    /// <param name="PermissionLevel">Parameter of type Option Read,Update.</param>
    /// <returns>Return variable "Boolean".</returns>
    local procedure AddUserAccess(UserSid: Guid; PermissionLevel: Option Read,Update): Boolean;
    var
        AccessControl: Record "Access Control";
        AppMgt: Codeunit "O4N GL SN App Mgt.";
        AppGuid: Guid;
    begin
        EVALUATE(AppGuid, AppMgt.GetAppId());
        AccessControl.INIT();
        AccessControl."User Security ID" := UserSid;
        AccessControl."App ID" := AppGuid;
        AccessControl."Company Name" := CopyStr(COMPANYNAME(), 1, MaxStrLen(AccessControl."Company Name"));
        AccessControl.Scope := AccessControl.Scope::Tenant;
        case PermissionLevel of
            PermissionLevel::Read:
                AccessControl."Role ID" := ReadRoleIdTxt;
            PermissionLevel::Update:
                AccessControl."Role ID" := UpdateRoleIdTxt;
        end;
        AccessControl.INSERT(true);
    end;

    /// <summary> 
    /// Description for AddGroupAccess.
    /// </summary>
    /// <param name="GroupCode">Parameter of type Code[20].</param>
    /// <param name="PermissionLevel">Parameter of type Option Read,Update.</param>
    /// <returns>Return variable "Boolean".</returns>
    local procedure AddGroupAccess(GroupCode: Code[20]; PermissionLevel: Option Read,Update): Boolean;
    var
        UserGroupPermissionSet: Record "User Group Permission Set";
        AppMgt: Codeunit "O4N GL SN App Mgt.";
        AppGuid: Guid;
    begin
        EVALUATE(AppGuid, AppMgt.GetAppId());
        UserGroupPermissionSet.INIT();
        UserGroupPermissionSet."User Group Code" := GroupCode;
        UserGroupPermissionSet."App ID" := AppGuid;
        UserGroupPermissionSet.Scope := UserGroupPermissionSet.Scope::Tenant;
        case PermissionLevel of
            PermissionLevel::Read:
                UserGroupPermissionSet."Role ID" := ReadRoleIdTxt;
            PermissionLevel::Update:
                UserGroupPermissionSet."Role ID" := UpdateRoleIdTxt;
        end;
        UserGroupPermissionSet.INSERT(true);
    end;

    /// <summary> 
    /// Description for RemoveUserAccess.
    /// </summary>
    /// <param name="UserSid">Parameter of type Guid.</param>
    /// <param name="PermissionLevel">Parameter of type Option Read,Update.</param>
    /// <returns>Return variable "Boolean".</returns>
    local procedure RemoveUserAccess(UserSid: Guid; PermissionLevel: Option Read,Update): Boolean;
    var
        AccessControl: Record "Access Control";
        AppMgt: Codeunit "O4N GL SN App Mgt.";
        AppGuid: Guid;
    begin
        EVALUATE(AppGuid, AppMgt.GetAppId());
        AccessControl.SETRANGE("User Security ID", UserSid);
        AccessControl.SETFILTER("Company Name", '%1|%2', COMPANYNAME, '');
        AccessControl.SETRANGE("App ID", AppGuid);
        AccessControl.SETRANGE(Scope, AccessControl.Scope::Tenant);
        case PermissionLevel of
            PermissionLevel::Read:
                AccessControl.SETRANGE("Role ID", ReadRoleIdTxt);
            PermissionLevel::Update:
                AccessControl.SETRANGE("Role ID", UpdateRoleIdTxt);
        end;
        AccessControl.DELETEALL(true);
    end;

    /// <summary> 
    /// Description for RemoveGroupAccess.
    /// </summary>
    /// <param name="GroupCode">Parameter of type Code[20].</param>
    /// <param name="PermissionLevel">Parameter of type Option Read,Update.</param>
    /// <returns>Return variable "Boolean".</returns>
    local procedure RemoveGroupAccess(GroupCode: Code[20]; PermissionLevel: Option Read,Update): Boolean;
    var
        UserGroupPermissionSet: Record "User Group Permission Set";
        AppMgt: Codeunit "O4N GL SN App Mgt.";
        AppGuid: Guid;
    begin
        EVALUATE(AppGuid, AppMgt.GetAppId());
        UserGroupPermissionSet.SETRANGE("User Group Code", GroupCode);
        UserGroupPermissionSet.SETRANGE("App ID", AppGuid);
        UserGroupPermissionSet.SETRANGE(Scope, UserGroupPermissionSet.Scope::Tenant);
        case PermissionLevel of
            PermissionLevel::Read:
                UserGroupPermissionSet.SETRANGE("Role ID", ReadRoleIdTxt);
            PermissionLevel::Update:
                UserGroupPermissionSet.SETRANGE("Role ID", UpdateRoleIdTxt);
        end;
        UserGroupPermissionSet.DELETEALL(true);
    end;
}


