﻿codeunit 70009216 "O4N GL SN Permission Mgt"
{

    trigger OnRun();
    begin
    end;

    var
        ReadRoleIdTxt: Label 'G/L-SOURCE NAMES', Locked = true;
        UpdateRoleIdTxt: Label 'G/L-SOURCE NAMES, E', Locked = true;

    procedure GetAccessControl(var TempUserAccess: Record "O4N GL SN User Access" temporary; var TempGroupAccess: Record "O4N GL SN Group Access" temporary);
    begin
        GetReadOnlyMembers(TempUserAccess, TempGroupAccess);
        GetUpdateMembers(TempUserAccess, TempGroupAccess);
    end;

    procedure SetAccessControl(var TempUserAccess: Record "O4N GL SN User Access" temporary; var TempGroupAccess: Record "O4N GL SN Group Access" temporary);
    begin
        UpdateUserAccessControl(TempUserAccess);
        UpdateGroupAccessControl(TempGroupAccess);
    end;

    procedure SuggestAccessControl(var TempUserAccess: Record "O4N GL SN User Access" temporary; var TempGroupAccess: Record "O4N GL SN Group Access" temporary);
    var
        LocalTempUserAccess: Record "O4N GL SN User Access" temporary;
        LocalTempGroupAccess: Record "O4N GL SN Group Access" temporary;
    begin
        LocalTempGroupAccess.COPY(TempGroupAccess, true);
        LocalTempGroupAccess.SETRANGE("Has Permission", false);
        LocalTempGroupAccess.MODIFYALL("Assign Permission", true);
        LocalTempUserAccess.COPY(TempUserAccess, true);
        LocalTempUserAccess.SETRANGE("Has Permission", false);
        LocalTempUserAccess.MODIFYALL("Assign Permission", true);
    end;

    local procedure UpdateUserAccessControl(var TempUserAccess: Record "O4N GL SN User Access" temporary);
    var
        LocalTempUserAccess: Record "O4N GL SN User Access" temporary;
    begin
        LocalTempUserAccess.COPY(TempUserAccess, true);
        LocalTempUserAccess.SETRANGE("Assign Permission", true);
        LocalTempUserAccess.SETRANGE("Updated Via User Group", false);
        if LocalTempUserAccess.FIND('-') then
            repeat
                AddUserAccess(LocalTempUserAccess."User Security ID", LocalTempUserAccess."Permission Level");
            until LocalTempUserAccess.NEXT() = 0;
        LocalTempUserAccess.SETRANGE("Assign Permission");
        LocalTempUserAccess.SETRANGE("Remove Permission", true);
        if LocalTempUserAccess.FIND('-') then
            repeat
                RemoveUserAccess(LocalTempUserAccess."User Security ID", LocalTempUserAccess."Permission Level");
            until LocalTempUserAccess.NEXT() = 0;
        LocalTempUserAccess.RESET();
    end;

    local procedure UpdateGroupAccessControl(var TempGroupAccess: Record "O4N GL SN Group Access" temporary);
    var
        LocalTempGroupAccess: Record "O4N GL SN Group Access" temporary;
    begin
        LocalTempGroupAccess.COPY(TempGroupAccess, true);
        LocalTempGroupAccess.SETRANGE("Assign Permission", true);
        if LocalTempGroupAccess.FIND('-') then
            repeat
                AddGroupAccess(LocalTempGroupAccess."User Group Code", LocalTempGroupAccess."Permission Level");
            until LocalTempGroupAccess.NEXT() = 0;
        LocalTempGroupAccess.SETRANGE("Assign Permission");
        LocalTempGroupAccess.SETRANGE("Remove Permission", true);
        if LocalTempGroupAccess.FIND('-') then
            repeat
                RemoveGroupAccess(LocalTempGroupAccess."User Group Code", LocalTempGroupAccess."Permission Level");
            until LocalTempGroupAccess.NEXT() = 0;
        LocalTempGroupAccess.RESET();
    end;

    local procedure GetReadOnlyMembers(var TempUserAccess: Record "O4N GL SN User Access" temporary; var TempGroupAccess: Record "O4N GL SN Group Access" temporary);
    var
        TempUser: Record User temporary;
        TempUserGroup: Record "User Group" temporary;
    begin
        WhoThatCanView(DATABASE::"G/L Entry", TempUser, TempUserGroup);

        CopyUserGroups(TempUserGroup, TempGroupAccess, TempGroupAccess."Permission Level"::Read);
        CopyUsers(TempUser, TempUserAccess, TempGroupAccess, TempGroupAccess."Permission Level"::Read);
    end;

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


