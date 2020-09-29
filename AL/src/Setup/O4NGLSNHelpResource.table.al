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

    /// <summary> 
    /// Description for InitializeResources.
    /// </summary>
    procedure InitializeResources();
    begin
        InitAssistedSetupHelpPageUrl();
        InitAssistedSetupEmbedVideoUrl();
        InitUsageHelpEmbedVideoUrl();
        InitUsageHelpPageUrl();
        InitIcon70x70();
        InitIcon150x150();
        InitIcon240x240();
        InitIcon250x250();
        InitIcon417x417();
    end;

    /// <summary> 
    /// Description for GetUrl.
    /// </summary>
    /// <param name="SetupCode">Parameter of type Code[50].</param>
    /// <returns>Return variable "Text".</returns>
    procedure GetUrl(SetupCode: Code[50]): Text;
    begin
        if GET(SetupCode) then
            exit(Url);
    end;

    /// <summary> 
    /// Description for StartVideo.
    /// </summary>
    /// <param name="SetupCode">Parameter of type Code[50].</param>
    procedure StartVideo(SetupCode: Code[50]);
    var
        Video: Codeunit Video;
    begin
        Video.Play(GetUrl(SetupCode));
    end;

    /// <summary> 
    /// Description for GetSetupHelpCode.
    /// </summary>
    /// <returns>Return variable "Code[50]".</returns>
    procedure GetSetupHelpCode(): Code[50];
    var
        SetupHelpCodeTxt: Label 'SETUPHELP', Locked = true;
    begin
        exit(SetupHelpCodeTxt);
    end;

    /// <summary> 
    /// Description for GetSetupVideoCode.
    /// </summary>
    /// <returns>Return variable "Code[50]".</returns>
    procedure GetSetupVideoCode(): Code[50];
    var
        SetupVideoCodeTxt: Label 'SETUPVIDEO', Locked = true;
    begin
        exit(SetupVideoCodeTxt);
    end;

    /// <summary> 
    /// Description for GetUsageHelpCode.
    /// </summary>
    /// <returns>Return variable "Code[50]".</returns>
    procedure GetUsageHelpCode(): Code[50];
    var
        UsageHelpCodeTxt: Label 'USAGEHELP', Locked = true;
    begin
        exit(UsageHelpCodeTxt);
    end;

    /// <summary> 
    /// Description for GetUsageVideoCode.
    /// </summary>
    /// <returns>Return variable "Code[50]".</returns>
    procedure GetUsageVideoCode(): Code[50];
    var
        UsageVideoCodeTxt: Label 'USAGEVIDEO', Locked = true;
    begin
        exit(UsageVideoCodeTxt);
    end;

    /// <summary> 
    /// Description for Get70PXIconCode.
    /// </summary>
    /// <returns>Return variable "Code[50]".</returns>
    procedure Get70PXIconCode(): Code[50];
    var
        IconCodeTxt: Label 'GLSOURCENAMES_70PXICON', Locked = true;
    begin
        exit(IconCodeTxt)
    end;

    /// <summary> 
    /// Description for Get150PXIconCode.
    /// </summary>
    /// <returns>Return variable "Code[50]".</returns>
    procedure Get150PXIconCode(): Code[50];
    var
        IconCodeTxt: Label 'GLSOURCENAMES_150PXICON', Locked = true;
    begin
        exit(IconCodeTxt)
    end;

    /// <summary> 
    /// Description for Get240PXIconCode.
    /// </summary>
    /// <returns>Return variable "Code[50]".</returns>
    procedure Get240PXIconCode(): Code[50];
    var
        IconCodeTxt: Label 'GLSOURCENAMES_240PXICON', Locked = true;
    begin
        exit(IconCodeTxt)
    end;

    /// <summary> 
    /// Description for Get250PXIconCode.
    /// </summary>
    /// <returns>Return variable "Code[50]".</returns>
    procedure Get250PXIconCode(): Code[50];
    var
        IconCodeTxt: Label 'GLSOURCENAMES_250PXICON', Locked = true;
    begin
        exit(IconCodeTxt)
    end;

    /// <summary> 
    /// Description for Get417PXIconCode.
    /// </summary>
    /// <returns>Return variable "Code[50]".</returns>
    procedure Get417PXIconCode(): Code[50];
    var
        IconCodeTxt: Label 'GLSOURCENAMES_417PXICON', Locked = true;
    begin
        exit(IconCodeTxt)
    end;

    /// <summary> 
    /// Description for InitAssistedSetupHelpPageUrl.
    /// </summary>
    local procedure InitAssistedSetupHelpPageUrl();
    var
        SetupHelpUrlTxt: Label 'http://Objects4NAV.com/GLSourceNames', Locked = true;
    begin
        InitUrl(GetSetupHelpCode(), SetupHelpUrlTxt);
    end;

    /// <summary> 
    /// Description for InitAssistedSetupEmbedVideoUrl.
    /// </summary>
    local procedure InitAssistedSetupEmbedVideoUrl();
    var
        SetupVideoUrlTxt: Label 'https://www.youtube.com/embed/Ih7fuqwIR-Q', Locked = true;
    begin
        InitUrl(GetSetupVideoCode(), SetupVideoUrlTxt);
    end;

    /// <summary> 
    /// Description for InitUsageHelpPageUrl.
    /// </summary>
    local procedure InitUsageHelpPageUrl();
    var
        UsageHelpUrlTxt: Label 'http://Objects4NAV.com/GLSourceNames', Locked = true;
    begin
        InitUrl(GetUsageHelpCode(), UsageHelpUrlTxt);
    end;

    /// <summary> 
    /// Description for InitUsageHelpEmbedVideoUrl.
    /// </summary>
    local procedure InitUsageHelpEmbedVideoUrl();
    var
        UsageVideoUrlTxt: Label 'https://www.youtube.com/embed/7nlKDDpZIE8', Locked = true;
    begin
        InitUrl(GetUsageVideoCode(), UsageVideoUrlTxt);
    end;

    /// <summary> 
    /// Description for InitIcon70x70.
    /// </summary>
    local procedure InitIcon70x70();
    var
        GLSourceNameIcon: Codeunit "O4N GL SN Icon 70x70";
        IconDescriptionTxt: Label 'G/L Source Name Icon 70x70', Locked = true;
    begin
        InitIcon(Get70PXIconCode(), IconDescriptionTxt, GLSourceNameIcon.GetIcon());
    end;

    /// <summary> 
    /// Description for InitIcon150x150.
    /// </summary>
    local procedure InitIcon150x150();
    var
        GLSourceNameIcon: Codeunit "O4N GL SN Icon 150x150";
        IconDescriptionTxt: Label 'G/L Source Name Icon 150x150', Locked = true;
    begin
        InitIcon(Get150PXIconCode(), IconDescriptionTxt, GLSourceNameIcon.GetIcon());
    end;

    /// <summary> 
    /// Description for InitIcon240x240.
    /// </summary>
    local procedure InitIcon240x240();
    var
        GLSourceNameIcon: Codeunit "O4N GL SN Icon 240x240";
        IconDescriptionTxt: Label 'G/L Source Name Icon 240x240', Locked = true;

    begin
        InitIcon(Get70PXIconCode(), IconDescriptionTxt, GLSourceNameIcon.GetIcon());
    end;

    /// <summary> 
    /// Description for InitIcon250x250.
    /// </summary>
    local procedure InitIcon250x250();
    var
        GLSourceNameIcon: Codeunit "O4N GL SN Icon 250x250";
        IconDescriptionTxt: Label 'G/L Source Name Icon 250x250', Locked = true;

    begin
        InitIcon(Get250PXIconCode(), IconDescriptionTxt, GLSourceNameIcon.GetIcon());
    end;

    /// <summary> 
    /// Description for InitIcon417x417.
    /// </summary>
    local procedure InitIcon417x417();
    var
        GLSourceNameIcon: Codeunit "O4N GL SN Icon 417x417";
        IconDescriptionTxt: Label 'G/L Source Name Icon 417x417', Locked = true;
    begin
        InitIcon(Get417PXIconCode(), IconDescriptionTxt, GLSourceNameIcon.GetIcon());
    end;

    /// <summary> 
    /// Description for InitUrl.
    /// </summary>
    /// <param name="UrlCode">Parameter of type Code[50].</param>
    /// <param name="UrlLink">Parameter of type Text.</param>
    local procedure InitUrl(UrlCode: Code[50]; UrlLink: Text);
    var
        GLSourceNameHelpResource: Record "O4N GL SN Help Resource";
    begin
        if not GLSourceNameHelpResource.GET(UrlCode) then begin
            GLSourceNameHelpResource.Code := UrlCode;
            GLSourceNameHelpResource.Url := CopyStr(UrlLink, 1, MaxStrLen(Url));
            GLSourceNameHelpResource.INSERT();
        end;
    end;

    /// <summary> 
    /// Description for InitIcon.
    /// </summary>
    /// <param name="IconCode">Parameter of type Code[50].</param>
    /// <param name="IconDescription">Parameter of type Text.</param>
    /// <param name="IconDataAsBase64">Parameter of type Text.</param>
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
        if not GLSourceNameHelpResource.GET(IconCode) then begin
            GLSourceNameHelpResource.Code := IconCode;
            GLSourceNameHelpResource.Icon.IMPORTSTREAM(InStr, IconDescription, 'image/png');
            GLSourceNameHelpResource.INSERT();
        end;
    end;
}


