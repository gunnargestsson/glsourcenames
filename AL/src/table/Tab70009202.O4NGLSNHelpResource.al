table 70009202 "O4N GL SN Help Resource"
{

    Permissions = TableData "O4N GL SN Help Resource" = im;

    fields
    {
        field(1; "Code"; Code[50])
        {
            Caption = 'Code';
            DataClassification = SystemMetadata;
        }
        field(2; Url; Text[250])
        {
            Caption = 'Url';
            ExtendedDatatype = URL;
            DataClassification = SystemMetadata;
        }
        field(3; Icon; Media)
        {
            Caption = 'Icon';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    procedure InitializeResources();
    begin
        InitAssistedSetupHelpPageUrl;
        InitAssistedSetupEmbedVideoUrl;
        InitUsageHelpEmbedVideoUrl;
        InitUsageHelpPageUrl;
        InitIcon70x70;
        InitIcon150x150;
        InitIcon240x240;
        InitIcon250x250;
        InitIcon417x417;
    end;

    procedure GetUrl(SetupCode: Code[50]): Text;
    begin
        if GET(SetupCode) then
            exit(Url);
    end;

    procedure StartVideo(SetupCode: Code[50]);
    var
        Video: Codeunit Video;
    begin
        Video.Play(GetUrl(SetupCode));
    end;

    procedure GetSetupHelpCode(): Code[50];
    var
        SetupHelpCode: Label 'SETUPHELP', Locked = true;
    begin
        exit(SetupHelpCode);
    end;

    procedure GetSetupVideoCode(): Code[50];
    var
        SetupVideoCode: Label 'SETUPVIDEO', Locked = true;
    begin
        exit(SetupVideoCode);
    end;

    procedure GetUsageHelpCode(): Code[50];
    var
        UsageHelpCode: Label 'USAGEHELP', Locked = true;
    begin
        exit(UsageHelpCode);
    end;

    procedure GetUsageVideoCode(): Code[50];
    var
        UsageVideoCode: Label 'USAGEVIDEO', Locked = true;
    begin
        exit(UsageVideoCode);
    end;

    procedure Get70PXIconCode(): Code[50];
    var
        IconCode: Label 'GLSOURCENAMES_70PXICON', Locked = true;
    begin
        exit(IconCode)
    end;

    procedure Get150PXIconCode(): Code[50];
    var
        IconCode: Label 'GLSOURCENAMES_150PXICON', Locked = true;
    begin
        exit(IconCode)
    end;

    procedure Get240PXIconCode(): Code[50];
    var
        IconCode: Label 'GLSOURCENAMES_240PXICON', Locked = true;
    begin
        exit(IconCode)
    end;

    procedure Get250PXIconCode(): Code[50];
    var
        IconCode: Label 'GLSOURCENAMES_250PXICON', Locked = true;
    begin
        exit(IconCode)
    end;

    procedure Get417PXIconCode(): Code[50];
    var
        IconCode: Label 'GLSOURCENAMES_417PXICON', Locked = true;
    begin
        exit(IconCode)
    end;

    local procedure InitAssistedSetupHelpPageUrl();
    var
        SetupHelpUrl: Label 'http://Objects4NAV.com/GLSourceNames', Locked = true;
    begin
        InitUrl(GetSetupHelpCode, SetupHelpUrl);
    end;

    local procedure InitAssistedSetupEmbedVideoUrl();
    var
        SetupVideoUrl: Label 'https://www.youtube.com/embed/TYo1ZJ5jizs', Locked = true;
    begin
        InitUrl(GetSetupVideoCode, SetupVideoUrl);
    end;

    local procedure InitUsageHelpPageUrl();
    var
        UsageHelpUrl: Label 'http://Objects4NAV.com/GLSourceNames', Locked = true;
    begin
        InitUrl(GetUsageHelpCode, UsageHelpUrl);
    end;

    local procedure InitUsageHelpEmbedVideoUrl();
    var
        UsageVideoUrl: Label 'https://www.youtube.com/embed/Xj5TATt7Pns', Locked = true;
    begin
        InitUrl(GetUsageVideoCode, UsageVideoUrl);
    end;

    local procedure InitIcon70x70();
    var
        IconDescription: Label 'G/L Source Name Icon 70x70', Locked = true;
        GLSourceNameIcon: Codeunit "O4N GL SN Icon 70x70";
    begin
        InitIcon(Get70PXIconCode, IconDescription, GLSourceNameIcon.GetIcon());
    end;

    local procedure InitIcon150x150();
    var
        IconDescription: Label 'G/L Source Name Icon 150x150', Locked = true;
        GLSourceNameIcon: Codeunit "O4N GL SN Icon 150x150";
    begin
        InitIcon(Get150PXIconCode, IconDescription, GLSourceNameIcon.GetIcon());
    end;

    local procedure InitIcon240x240();
    var
        IconDescription: Label 'G/L Source Name Icon 240x240', Locked = true;
        GLSourceNameIcon: Codeunit "O4N GL SN Icon 240x240";
    begin
        InitIcon(Get70PXIconCode, IconDescription, GLSourceNameIcon.GetIcon());
    end;

    local procedure InitIcon250x250();
    var
        IconDescription: Label 'G/L Source Name Icon 250x250', Locked = true;
        GLSourceNameIcon: Codeunit "O4N GL SN Icon 250x250";
    begin
        InitIcon(Get250PXIconCode, IconDescription, GLSourceNameIcon.GetIcon());
    end;

    local procedure InitIcon417x417();
    var
        IconDescription: Label 'G/L Source Name Icon 417x417', Locked = true;
        GLSourceNameIcon: Codeunit "O4N GL SN Icon 417x417";
    begin
        InitIcon(Get417PXIconCode, IconDescription, GLSourceNameIcon.GetIcon());
    end;

    local procedure InitUrl(UrlCode: Code[50]; UrlLink: Text);
    var
        GLSourceNameHelpResource: Record "O4N GL SN Help Resource";
    begin
        with GLSourceNameHelpResource do
            if not GET(UrlCode) then begin
                Code := UrlCode;
                Url := UrlLink;
                INSERT;
            end;
    end;

    local procedure InitIcon(IconCode: Code[50]; IconDescription: Text; IconDataAsBase64: Text);
    var
        GLSourceNameHelpResource: Record "O4N GL SN Help Resource";
        Base64: Codeunit "Base64 Convert";
        BlobMgt: Codeunit "Temp Blob";
        OutStr: OutStream;
        InStr: InStream;
    begin
        BlobMgt.CreateOutStream(OutStr);
        Base64.FromBase64(IconDataAsBase64, OutStr);
        BlobMgt.CreateInStream(InStr);
        with GLSourceNameHelpResource do
            if not GET(IconCode) then begin
                Code := IconCode;
                Icon.IMPORTSTREAM(InStr, IconDescription, 'image/png');
                INSERT;
            end;
    end;
}


