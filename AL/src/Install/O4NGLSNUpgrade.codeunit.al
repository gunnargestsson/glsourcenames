﻿codeunit 70009208 "O4N GL SN Upgrade"
{
    Subtype = Upgrade;
    trigger OnRun()
    begin

    end;

    trigger OnCheckPreconditionsPerCompany()
    begin

    end;

    trigger OnCheckPreconditionsPerDatabase()
    begin

    end;

    trigger OnUpgradePerCompany()
    begin
        UpgradeLookupTable();
        UpgradeAccessControl('G/L-SOURCE NAMES, E', 'O4N G/L-SN, EDIT');
        UpgradeAccessControl('G/L-SOURCE NAMES, S', 'O4N G/L-SN, SETUP');
        UpgradeAccessControl('G/L-SOURCE NAMES', 'O4N G/L-SOURCE NAMES');
        UpgradeGroupAccessControl('G/L-SOURCE NAMES, E', 'O4N G/L-SN, EDIT');
        UpgradeGroupAccessControl('G/L-SOURCE NAMES, S', 'O4N G/L-SN, SETUP');
        UpgradeGroupAccessControl('G/L-SOURCE NAMES', 'O4N G/L-SOURCE NAMES');

        // Fix Incorrect Scope
        UpgradeAccessControl('O4N G/L-SN, EDIT', 'O4N G/L-SN, EDIT');
        UpgradeAccessControl('O4N G/L-SN, SETUP', 'O4N G/L-SN, SETUP');
        UpgradeAccessControl('O4N G/L-SOURCE NAMES', 'O4N G/L-SOURCE NAMES');
        UpgradeGroupAccessControl('O4N G/L-SN, EDIT', 'O4N G/L-SN, EDIT');
        UpgradeGroupAccessControl('O4N G/L-SN, SETUP', 'O4N G/L-SN, SETUP');
        UpgradeGroupAccessControl('O4N G/L-SOURCE NAMES', 'O4N G/L-SOURCE NAMES');

    end;

    trigger OnUpgradePerDatabase()
    begin

    end;

    trigger OnValidateUpgradePerCompany()
    begin

    end;

    trigger OnValidateUpgradePerDatabase()
    begin

    end;

    local procedure UpgradeLookupTable()
    var
        GLSourceName: Record "O4N GL SN";
    begin
        if GLSourceName.FindSet() then
            repeat
                case GLSourceName."Source Type" of
                    GLSourceName."Source Type"::Customer:
                        GLSourceName."Item Ledger Source Type" := GLSourceName."Item Ledger Source Type"::Customer;
                    GLSourceName."Source Type"::Vendor:
                        GLSourceName."Item Ledger Source Type" := GLSourceName."Item Ledger Source Type"::Vendor;
                end;
                GLSourceName.Modify();
            until GLSourceName.Next() = 0;
    end;

    local procedure UpgradeAccessControl(OldRoleId: Code[20]; NewRoleId: Code[20])
    var
        OldAccessControl: Record "Access Control";
        NewAccessControl: Record "Access Control";
    begin
        OldAccessControl.SetRange("Role ID", OldRoleId);
        OldAccessControl.SetRange(Scope, OldAccessControl.Scope::Tenant);
        if OldAccessControl.FindSet(true) then
            repeat
                NewAccessControl := OldAccessControl;
                NewAccessControl.Scope := NewAccessControl.Scope::System;
                NewAccessControl.Validate("Role ID", NewRoleId);
                if NewAccessControl.Insert(true) then;
            until OldAccessControl.Next() = 0;
        OldAccessControl.DeleteAll(true);
    end;

    local procedure UpgradeGroupAccessControl(OldRoleId: Code[20]; NewRoleId: Code[20])
    var
        OldGroupAccessControl: Record "User Group Access Control";
        NewGroupAccessControl: Record "User Group Access Control";
    begin
        OldGroupAccessControl.SetRange("Role ID", OldRoleId);
        OldGroupAccessControl.SetRange(Scope, OldGroupAccessControl.Scope::Tenant);
        if OldGroupAccessControl.FindSet(true) then
            repeat
                NewGroupAccessControl := OldGroupAccessControl;
                NewGroupAccessControl.Scope := NewGroupAccessControl.Scope::System;
                NewGroupAccessControl.Validate("Role ID", NewRoleId);
                if NewGroupAccessControl.Insert(true) then;
            until OldGroupAccessControl.Next() = 0;
        OldGroupAccessControl.DeleteAll(true);
    end;

}

