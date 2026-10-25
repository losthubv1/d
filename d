
if not game:IsLoaded() then game.Loaded:Wait() end
if not game:GetService("ReplicatedStorage"):WaitForChild("endpoints", 30) then return end
repeat task.wait() until game:GetService("Players").LocalPlayer
local Library = (function()
local NativeLibrary = (function()

local cloneref = (cloneref or clonereference or function(instance: any)
    return instance
end)
local CoreGui: CoreGui = cloneref(game:GetService("CoreGui"))
local Players: Players = cloneref(game:GetService("Players"))
local RunService: RunService = cloneref(game:GetService("RunService"))
local SoundService: SoundService = cloneref(game:GetService("SoundService"))
local UserInputService: UserInputService = cloneref(game:GetService("UserInputService"))
local TextService: TextService = cloneref(game:GetService("TextService"))
local Teams: Teams = cloneref(game:GetService("Teams"))
local TweenService: TweenService = cloneref(game:GetService("TweenService"))

local getgenv = getgenv or function()
    return shared
end
local setclipboard = setclipboard or toclipboard or nil
local protectgui = protectgui or (syn and syn.protect_gui) or function() end
local gethui = gethui or function()
    return CoreGui
end

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local Mouse = cloneref(LocalPlayer:GetMouse())

local Labels = {}
local Buttons = {}
local Toggles = {}
local Options = {}
local Tooltips = {}

local BaseURL = "https://raw.githubusercontent.com/losthubv1/ffedfdfdf/refs/heads/main/"
local CustomImageManager = {}
local CustomImageManagerAssets = {
    TransparencyTexture = {
        RobloxId = 139785960036434,
        Path = "Obsidian/assets/TransparencyTexture.png",
        URL = BaseURL .. "assets/TransparencyTexture.png",

        Id = nil,
    },

    SaturationMap = {
        RobloxId = 4155801252,
        Path = "Obsidian/assets/SaturationMap.png",
        URL = BaseURL .. "assets/SaturationMap.png",

        Id = nil,
    },

    LoadingIcon = {
        RobloxId = 97544096941083,
        Path = "Obsidian/assets/LoadingIcon.png",
        URL = BaseURL .. "assets/LoadingIcon.png",

        Id = nil,
    },

    CheckIcon = {
        RobloxId = 97682394690683,
        Path = "Obsidian/assets/CheckIcon.png",
        URL = BaseURL .. "assets/CheckIcon.png",

        Id = nil,
    },

    Glow = {
        RobloxId = 88645182616510,
        Path = "Obsidian/assets/Glow.png",
        URL = BaseURL .. "assets/Glow.png",

        Id = nil,
    },
}

do
    local function RecursiveCreatePath(Path: string, IsFile: boolean?)
        if not isfolder or not makefolder then
            return
        end

        local Segments = Path:split("/")
        local TraversedPath = ""

        if IsFile then
            table.remove(Segments, #Segments)
        end

        for _, Segment in ipairs(Segments) do
            if not isfolder(TraversedPath .. Segment) then
                makefolder(TraversedPath .. Segment)
            end

            TraversedPath = TraversedPath .. Segment .. "/"
        end

        return TraversedPath
    end

    function CustomImageManager.AddAsset(
        AssetName: string,
        RobloxAssetId: number,
        URL: string,
        ForceRedownload: boolean?
    )
        if CustomImageManagerAssets[AssetName] ~= nil then
            error(string.format("Asset %q already exists", AssetName))
        end

        assert(typeof(RobloxAssetId) == "number", "RobloxAssetId must be a number")

        CustomImageManagerAssets[AssetName] = {
            RobloxId = RobloxAssetId,
            Path = string.format("Obsidian/custom_assets/%s", AssetName),
            URL = URL,

            Id = nil,
        }

        CustomImageManager.DownloadAsset(AssetName, ForceRedownload)
    end

    function CustomImageManager.GetAsset(AssetName: string)
        if not CustomImageManagerAssets[AssetName] then
            return nil
        end

        local AssetData = CustomImageManagerAssets[AssetName]
        if AssetData.Id then
            return AssetData.Id
        end

        local AssetID = string.format("rbxassetid://%s", AssetData.RobloxId)

        if getcustomasset then
            local Success, NewID = pcall(getcustomasset, AssetData.Path)

            if Success and NewID then
                AssetID = NewID
            end
        end

        AssetData.Id = AssetID
        return AssetID
    end

    function CustomImageManager.DownloadAsset(AssetName: string, ForceRedownload: boolean?)
        if not getcustomasset or not writefile or not isfile then
            return false, "missing functions"
        end

        local AssetData = CustomImageManagerAssets[AssetName]

        RecursiveCreatePath(AssetData.Path, true)

        if ForceRedownload ~= true and isfile(AssetData.Path) then
            return true, nil
        end

        local success, errorMessage = pcall(function()
            writefile(AssetData.Path, game:HttpGet(AssetData.URL))
        end)

        return success, errorMessage
    end

    -- Use the upstream Roblox asset IDs; no startup image downloads.
end

local Library = {
    LocalPlayer = LocalPlayer,
    IsRobloxFocused = true,

    --// Device \\--
    DevicePlatform = nil,
    IsMobile = false,

    --// Obsidian Windows \\--
    ScreenGui = nil,
    Window = nil,
    WindowContainer = nil,

    --// Search \\--
    SearchText = "",
    Searching = false,
    GlobalSearch = false,
    LastSearchTab = nil,

    --// Tabs \\--
    ActiveTab = nil,
    Tabs = {},
    TabButtons = {},

    --// Dependency Boxes \\--
    DependencyBoxes = {},

    --// Keybinds Frame \\--
    KeybindFrame = nil,
    KeybindContainer = nil,
    KeybindToggles = {},

    --// Notifications \\--
    Notifications = {},
    NotifySide = "Right",
    NotifyTweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),

    --// Dialogues \\--
    Dialogues = {},
    ActiveDialog = nil,

    --// Loading Window \\--
    ActiveLoading = nil,

    --// Corners \\--
    Corners = {},
    CornerModes = {},
    SpecificCorners = {},

    --// Animations \\--
    TweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),

    TabTransitionInfo = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    TabSwipeOffset = 26,
    TabSwipeFrom = "bottom",

    WindowAnimationInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    DropdownTransitionInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    KeyPickerTransitionInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),

    GroupboxTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    RotatingChevronTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),

    Animations = {
        ToggleWindow = false,
        TabSwitch = false,
        Groupbox = false,
        Dropdown = false,
        KeyPicker = false
    },

    --// States \\--
    Toggled = false,
    Unloaded = false,

    Labels = Labels,
    Buttons = Buttons,
    Toggles = Toggles,
    Options = Options,

    --// Options \\--
    ToggleKeybind = Enum.KeyCode.RightControl,
    ShowToggleFrameInKeybinds = true,

    NotifyOnError = false,
    ShowCustomCursor = true,
    ForceCheckbox = false,

    CantDragForced = false,
    DraggableElements = {},

    --// Signals \\--
    Signals = {},
    UnloadSignals = {},

    OriginalMinSize = Vector2.new(480, 360),
    MinSize = Vector2.new(480, 360),
    DPIScale = 1,
    CornerRadius = 12,

    --// Scheme \\--
    IsLightTheme = false,
    Scheme = {
        BackgroundColor = Color3.fromRGB(15, 15, 15),
        MainColor = Color3.fromRGB(25, 25, 25),
        AccentColor = Color3.fromRGB(255, 255, 255),
        OutlineColor = Color3.fromRGB(40, 40, 40),
        FontColor = Color3.fromRGB(235, 235, 235),
        Font = Font.fromEnum(Enum.Font.BuilderSans),

        RedColor = Color3.fromRGB(255, 50, 50),
        DestructiveColor = Color3.fromRGB(220, 38, 38),
        DarkColor = Color3.new(0, 0, 0),
        WhiteColor = Color3.new(1, 1, 1),

        BackgroundImageEnabled = false,
        BackgroundImage = "",
        WindowGlow = true,
    },

    --// Registry \\--
    Registry = {},
	Scales = {},
	ScalesOffset = {},

    --// Misc \\--
    ImageManager = CustomImageManager,
    ShowCursorBinding = string.sub(tostring({}), 10),

    Notify = nil, Toggle = nil -- we love luau lsp
}

if RunService:IsStudio() then
    if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
        Library.IsMobile = true
        Library.OriginalMinSize = Vector2.new(480, 240)
    else
        Library.IsMobile = false
        Library.OriginalMinSize = Vector2.new(480, 360)
    end
else
    pcall(function()
        Library.DevicePlatform = UserInputService:GetPlatform()
    end)

    Library.IsMobile = (Library.DevicePlatform == Enum.Platform.Android or Library.DevicePlatform == Enum.Platform.IOS)
    Library.OriginalMinSize = Library.IsMobile and Vector2.new(480, 240) or Vector2.new(480, 360)
end

local Templates = {
    --// UI \\--
    Frame = {
        BorderSizePixel = 0,
    },
    ImageLabel = {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    },
    ImageButton = {
        AutoButtonColor = false,
        BorderSizePixel = 0,
    },
    ScrollingFrame = {
        BorderSizePixel = 0,
    },
    TextLabel = {
        BorderSizePixel = 0,
        FontFace = "Font",
        RichText = true,
        TextColor3 = "FontColor",
    },
    TextButton = {
        AutoButtonColor = false,
        BorderSizePixel = 0,
        FontFace = "Font",
        RichText = true,
        TextColor3 = "FontColor",
    },
    TextBox = {
        BorderSizePixel = 0,
        FontFace = "Font",
        PlaceholderColor3 = function()
            local H, S, V = Library.Scheme.FontColor:ToHSV()
            return Color3.fromHSV(H, S, V / 2)
        end,
        Text = "",
        TextColor3 = "FontColor",
    },
    UIListLayout = {
        SortOrder = Enum.SortOrder.LayoutOrder,
    },
    UIStroke = {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    },

    --// Library \\--
    Window = {
        Title = "No Title",
        Footer = "No Footer",

        Position = UDim2.fromOffset(6, 6),
        Size = UDim2.fromOffset(760, 500),
        IconSize = UDim2.fromOffset(30, 30),

        AutoShow = true,
        Center = true,
        Resizable = true,
        Glow = true,
        SearchbarSize = UDim2.fromScale(1, 1),
        GlobalSearch = false,

        CornerRadius = 12,
        NotifySide = "Right",
        ShowCustomCursor = true,

        Font = Enum.Font.BuilderSans,
        ToggleKeybind = Enum.KeyCode.RightControl,

        WindowTransparency = 0.06,
        PanelTransparency = 0.03,

        Animations = {
            ToggleWindow = false,
            TabSwitch = true,
            Groupbox = true,
            Dropdown = true,
            KeyPicker = true,
        },
        TabTransitionTime = 0.18,
        TabSwipeOffset = 16,
        TabSwipeFrom = "bottom",

        ShowMobileButtons = true,
        MobileButtonsSide = "Left",

        UnlockMouseWhileOpen = true,

        EnableSidebarResize = false,
        EnableCompacting = true,
        DisableCompactingSnap = false,
        SidebarCompacted = true,
        MinContainerWidth = 256,

        --// Snapping \\--
        MinSidebarWidth = 128,
        SidebarCompactWidth = 48,
        SidebarCollapseThreshold = 0.5,

        --// Dragging \\--
        CompactWidthActivation = 128,

        --// Background \\--
        BackgroundImageEnabled = false,
        BackgroundImage = ""
    },
    Dialog = {
        Title = "Dialog",
        Description = "No description provided.",
        AutoDismiss = true,
        OutsideClickDismiss = true,
        FooterButtons = {}
    },
    Loading = {
        Title = "Obsidian",
        Icon = 103958626888975,
        IconSize = UDim2.fromOffset(30, 30),

        LoadingIcon = CustomImageManager.GetAsset("LoadingIcon"),
        LoadingIconColor = nil,
        LoadingIconTweenTime = 1,

        CurrentStep = 0,
        TotalSteps = 10,

        ShowSidebar = false,
        AutoResizeHeight = false,

        WindowWidth = 450,
        WindowHeight = 275,

        ContentWidth = 450,
        SidebarWidth = 250,
    },
    Toggle = {
        Text = "Toggle",
        Default = false,

        Callback = function() end,
        Changed = function() end,

        Risky = false,
        Disabled = false,
        Visible = true,
    },
    Input = {
        Text = "Input",
        Default = "",
        Finished = false,
        Numeric = false,
        ClearTextOnFocus = true,
        ClearTextOnBlur = false,
        Placeholder = "",
        AllowEmpty = true,
        EmptyReset = "---",

        Callback = function() end,
        Changed = function() end,
        VerifyValue = nil,

        Disabled = false,
        Visible = true,
    },
    Slider = {
        Text = "Slider",
        Default = 0,
        Min = 0,
        Max = 100,
        Rounding = 0,

        Prefix = "",
        Suffix = "",

        Callback = function() end,
        Changed = function() end,

        Disabled = false,
        Visible = true,

        AllowRightClickInput = true
    },
    Dropdown = {
        Values = {},
        DisabledValues = {},
        ValueImages = {},

        Multi = false,
        DragSelect = false,
        MaxVisibleDropdownItems = 8,

        Callback = function() end,
        Changed = function() end,

        Disabled = false,
        Visible = true,
    },
    Viewport = {
        Object = nil,
        Camera = nil,
        Clone = true,
        AutoFocus = true,
        Interactive = false,
        Height = 200,
        Visible = true,
    },
    Image = {
        Image = "",
        Transparency = 0,
        BackgroundTransparency = 0,
        Color = Color3.new(1, 1, 1),
        RectOffset = Vector2.zero,
        RectSize = Vector2.zero,
        ScaleType = Enum.ScaleType.Fit,
        Height = 200,
        Visible = true,
    },
    Video = {
        Video = "",
        Looped = false,
        Playing = false,
        Volume = 1,
        Height = 200,
        Visible = true,
    },
    UIPassthrough = {
        Instance = nil,
        Height = 24,
        Visible = true,
    },

    --// Addons \\-
    KeyPicker = {
        Text = "KeyPicker",

        Default = "None",
        DefaultModifiers = {},

        Blacklisted = {},
        BlacklistedModifiers = {},
        Whitelisted = {},
        WhitelistedModifiers = {},

        Mode = "Toggle",
        Modes = { "Always", "Toggle", "Hold" },
        SyncToggleState = false,

        Callback = function() end,
        ChangedCallback = function() end,
        Changed = function() end,
        Clicked = function() end,
    },
    ColorPicker = {
        Default = Color3.new(1, 1, 1),

        Callback = function() end,
        Changed = function() end,
    },
}

local Places = {
    Bottom = { 0, 1 },
    Right = { 1, 0 },
}
local Sizes = {
    Left = { 0.5, 1 },
    Right = { 0.5, 1 },
}

--// Scheme Functions \\--
local SchemeReplaceAlias = {
    RedColor = "Red",
    WhiteColor = "White",
    DarkColor = "Dark"
}

local SchemeAlias = {
    Red = "RedColor",
    White = "WhiteColor",
    Dark = "DarkColor"
}

local function GetSchemeValue(Index)
    if not Index then
        return nil
    end

    local ReplaceAliasIndex = SchemeReplaceAlias[Index]
    if ReplaceAliasIndex and Library.Scheme[ReplaceAliasIndex] ~= nil then
        Library.Scheme[Index] = Library.Scheme[ReplaceAliasIndex]
        Library.Scheme[ReplaceAliasIndex] = nil

        return Library.Scheme[Index]
    end

    local AliasIndex = SchemeAlias[Index]
    if AliasIndex and Library.Scheme[AliasIndex] ~= nil then
        warn(string.format("Scheme Value %q is deprecated, please use %q instead.", Index, AliasIndex))
        return Library.Scheme[AliasIndex]
    end

    return Library.Scheme[Index]
end

--// Basic Functions \\--
local function WaitForEvent(Event, Timeout, Condition)
    local Bindable = Instance.new("BindableEvent")
    local Connection = Event:Once(function(...)
        if not Condition or typeof(Condition) == "function" and Condition(...) then
            Bindable:Fire(true)
        else
            Bindable:Fire(false)
        end
    end)
    task.delay(Timeout, function()
        Connection:Disconnect()
        Bindable:Fire(false)
    end)

    local Result = Bindable.Event:Wait()
    Bindable:Destroy()

    return Result
end

local function IsMouseInput(Input: InputObject, IncludeM2: boolean?)
    return Input.UserInputType == Enum.UserInputType.MouseButton1
        or (IncludeM2 == true and Input.UserInputType == Enum.UserInputType.MouseButton2)
        or Input.UserInputType == Enum.UserInputType.Touch
end
local function IsClickInput(Input: InputObject, IncludeM2: boolean?)
    return IsMouseInput(Input, IncludeM2)
        and Input.UserInputState == Enum.UserInputState.Begin
        and Library.IsRobloxFocused
end
local function IsHoverInput(Input: InputObject)
    return (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch)
        and Input.UserInputState == Enum.UserInputState.Change
end
local function IsDragInput(Input: InputObject, IncludeM2: boolean?)
    return IsMouseInput(Input, IncludeM2)
        and (Input.UserInputState == Enum.UserInputState.Begin or Input.UserInputState == Enum.UserInputState.Change)
        and Library.IsRobloxFocused
end
local function IsMouseClickInput(Input: InputObject)
    return Input.UserInputType == Enum.UserInputType.MouseButton1 or 
        Input.UserInputType == Enum.UserInputType.MouseButton2 or 
        Input.UserInputType == Enum.UserInputType.MouseButton3
end
local function IsMovementInput(Input: InputObject)
    return (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch)
        and Library.IsRobloxFocused
end

local function GetTableSize(Table: { [any]: any })
    local Size = 0

    for _, _ in Table do
        Size += 1
    end

    return Size
end
local function StopTween(Tween: TweenBase, Destroy: boolean?)
    if not Tween then
        return
    end

    if Tween.PlaybackState == Enum.PlaybackState.Playing then
        Tween:Cancel()
    end

    if Destroy == true then
        pcall(Tween.Destroy, Tween)
    end
end
local function Trim(Text: string)
    return Text:match("^%s*(.-)%s*$")
end
local function ContainsPlainText(Text: any, Search: string): boolean
    return typeof(Text) == "string" and string.find(string.lower(Text), Search, 1, true) ~= nil
end
local function Round(Value, Rounding)
    assert(Rounding >= 0 and Rounding % 1 == 0, "Rounding must be a non-negative integer.")

    if Rounding == 0 then
        return math.floor(Value)
    end

    return tonumber(string.format("%." .. Rounding .. "f", Value))
end

local function DeepClone(Value)
    if typeof(Value) ~= "table" then
        return Value
    end

    local Clone = {}
    for Key, NestedValue in Value do
        Clone[Key] = DeepClone(NestedValue)
    end

    return Clone
end

local function DestroyObjects(Objects)
    local Snapshot = {}
    for _, Object in Objects do
        table.insert(Snapshot, Object)
    end

    for Index = #Snapshot, 1, -1 do
        local Object = Snapshot[Index]
        if Object and Object.Destroy and not Object.Destroyed then
            Library:SafeCallback(Object.Destroy, Object)
        end
    end

    table.clear(Objects)
end

local function GetUniqueStorageKey(Collection, PreferredKey)
    if PreferredKey ~= nil and Collection[PreferredKey] == nil then
        return PreferredKey
    end

    local BaseKey = tostring(PreferredKey or "Item")
    if PreferredKey == nil and Collection[BaseKey] == nil then
        return BaseKey
    end

    local Suffix = 2
    local Key = BaseKey .. " #" .. Suffix
    while Collection[Key] ~= nil do
        Suffix += 1
        Key = BaseKey .. " #" .. Suffix
    end

    return Key
end

local function RemoveStoredObject(Collection, Object)
    for Key, StoredObject in Collection do
        if StoredObject == Object then
            Collection[Key] = nil
            return Key
        end
    end

    return nil
end

local function RegisterControl(Collection, Key, Control, ControlType)
    assert(Key ~= nil, string.format("%s requires a non-nil index.", ControlType))

    local StorageKey = GetUniqueStorageKey(Collection, Key)
    if StorageKey ~= Key then
        warn(string.format(
            'Duplicate %s index "%s"; stored the newer control as "%s".',
            ControlType,
            tostring(Key),
            tostring(StorageKey)
        ))
    end

    Control.StorageKey = StorageKey
    Collection[StorageKey] = Control
    return StorageKey
end

local function GetPlayers(ExcludeLocalPlayer: boolean?)
    local PlayerList = Players:GetPlayers()

    if ExcludeLocalPlayer then
        local Idx = table.find(PlayerList, LocalPlayer)
        if Idx then
            table.remove(PlayerList, Idx)
        end
    end

    table.sort(PlayerList, function(Player1, Player2)
        return Player1.Name:lower() < Player2.Name:lower()
    end)

    return PlayerList
end
local function GetTeams()
    local TeamList = Teams:GetTeams()

    table.sort(TeamList, function(Team1, Team2)
        return Team1.Name:lower() < Team2.Name:lower()
    end)

    return TeamList
end

function Library:UpdateDependencyBoxes()
    for _, Depbox in Library.DependencyBoxes do
        Depbox:Update(true)
    end

    if Library.Searching then
        Library:UpdateSearch(Library.SearchText)
    end
end

local function CheckDepbox(Box, Search)
    if Box.Visible == false then
        Box.Holder.Visible = false
        return 0
    end

    local VisibleElements = 0

    for _, ElementInfo in Box.Elements do
        if ElementInfo.Type == "Divider" then
            ElementInfo.Holder.Visible = false
            continue
        elseif ElementInfo.SubButton then
            --// Check if any of the Buttons Name matches with Search
            local Visible = false

            --// Check if Search matches Element's Name and if Element is Visible
            if ContainsPlainText(ElementInfo.Text, Search) and ElementInfo.Visible ~= false then
                ElementInfo.Base.Visible = true
                Visible = true
            else
                ElementInfo.Base.Visible = false
            end
            if ContainsPlainText(ElementInfo.SubButton.Text, Search) and ElementInfo.SubButton.Visible ~= false then
                ElementInfo.SubButton.Base.Visible = true
                Visible = true
            else
                ElementInfo.SubButton.Base.Visible = false
            end
            ElementInfo.Holder.Visible = Visible
            if Visible then
                VisibleElements += 1
            end

            continue
        end

        --// Check if Search matches Element's Name and if Element is Visible
        if ContainsPlainText(ElementInfo.Text, Search) and ElementInfo.Visible ~= false then
            ElementInfo.Holder.Visible = true
            VisibleElements += 1
        else
            ElementInfo.Holder.Visible = false
        end
    end

    for _, Depbox in Box.DependencyBoxes do
        VisibleElements += CheckDepbox(Depbox, Search)
    end

    Box.Holder.Visible = VisibleElements > 0
    Box:Resize()
    return VisibleElements
end
local function RestoreDepbox(Box)
    for _, ElementInfo in Box.Elements do
        if ElementInfo.SubButton then
            local MainVisible = ElementInfo.Visible ~= false
            local SubVisible = ElementInfo.SubButton.Visible ~= false
            ElementInfo.Base.Visible = MainVisible
            ElementInfo.SubButton.Base.Visible = SubVisible
            ElementInfo.Holder.Visible = MainVisible or SubVisible
        else
            ElementInfo.Holder.Visible = ElementInfo.Visible ~= false
        end
    end

    for _, Depbox in Box.DependencyBoxes do
        RestoreDepbox(Depbox)
    end

    Box:Resize()
    Box.Holder.Visible = Box.Visible ~= false
end

local function FilterElements(Box, Search)
    local VisibleElements = 0

    for _, ElementInfo in Box.Elements do
        if ElementInfo.Type == "Divider" then
            ElementInfo.Holder.Visible = false
            continue
        elseif ElementInfo.SubButton then
            local MainVisible = ContainsPlainText(ElementInfo.Text, Search) and ElementInfo.Visible ~= false
            local SubVisible = ContainsPlainText(ElementInfo.SubButton.Text, Search)
                and ElementInfo.SubButton.Visible ~= false

            ElementInfo.Base.Visible = MainVisible
            ElementInfo.SubButton.Base.Visible = SubVisible
            ElementInfo.Holder.Visible = MainVisible or SubVisible

            if MainVisible or SubVisible then
                VisibleElements += 1
            end
            continue
        end

        local Visible = ContainsPlainText(ElementInfo.Text, Search) and ElementInfo.Visible ~= false
        ElementInfo.Holder.Visible = Visible
        if Visible then
            VisibleElements += 1
        end
    end

    for _, Depbox in Box.DependencyBoxes do
        VisibleElements += CheckDepbox(Depbox, Search)
    end

    Box:Resize()
    return VisibleElements
end

local function FilterTabbox(Tabbox, Search)
    local VisibleTabs = 0
    local TotalMatches = 0
    local VisibleElements = {}
    local FirstVisibleTab

    for _, SubTab in ipairs(Tabbox.OrderedTabs or Tabbox.Tabs) do
        if SubTab.Destroyed then
            continue
        end

        local Count = FilterElements(SubTab, Search)
        VisibleElements[SubTab] = Count
        SubTab.ButtonHolder.Visible = Count > 0

        if Count > 0 then
            VisibleTabs += 1
            TotalMatches += Count
            FirstVisibleTab = FirstVisibleTab or SubTab
        end
    end

    if FirstVisibleTab then
        if not Tabbox.ActiveTab or VisibleElements[Tabbox.ActiveTab] == 0 then
            FirstVisibleTab:Show()
        else
            Tabbox.ActiveTab:Resize()
        end
    end

    Tabbox.BoxHolder.Visible = VisibleTabs > 0
    return TotalMatches
end

local function ApplySearchToScope(Scope, Search)
    if not Scope then
        return
    end

    local HasVisible = false
    local TabboxMatches = {}

    for _, Tabbox in Scope.Tabboxes do
        if
            Tabbox.Parent
            and Tabbox.Parent.Type == "Groupbox"
            and Tabbox.Parent.Visible == false
        then
            Tabbox.BoxHolder.Visible = false
            TabboxMatches[Tabbox] = 0
        else
            TabboxMatches[Tabbox] = FilterTabbox(Tabbox, Search)
        end
    end

    --// Loop through Groupboxes to get Elements Info
    for _, Groupbox in Scope.Groupboxes do
        if Groupbox.Visible == false then
            Groupbox.BoxHolder.Visible = false
            continue
        end

        local MainMatches = FilterElements(Groupbox, Search)
        for Tabbox, Matches in TabboxMatches do
            if Tabbox.Parent == Groupbox then
                MainMatches += Matches
            end
        end

        Groupbox.Holder.Visible = MainMatches > 0

        local VisibleElements = MainMatches
        for _, DepGroupbox in Scope.DependencyGroupboxes do
            if DepGroupbox.ParentGroupbox == Groupbox or DepGroupbox.BoxHolder == Groupbox.BoxHolder then
                VisibleElements += CheckDepbox(DepGroupbox, Search)
            end
        end

        --// Update Groupbox Size and Visibility if found any element
        if VisibleElements > 0 then
            Groupbox:Resize()
            HasVisible = true
        end
        Groupbox.BoxHolder.Visible = VisibleElements > 0
    end

    for _, Tabbox in Scope.Tabboxes do
        if Tabbox.Parent ~= nil and Tabbox.Parent.Type == "Groupbox" then
            continue
        end

        if TabboxMatches[Tabbox] > 0 then
            HasVisible = true
        end
    end

    return HasVisible
end

local function ApplySearchToTab(Tab, Search)
    if not Tab then
        return false
    end

    if not Tab.OrderedPages or #Tab.OrderedPages == 0 then
        return ApplySearchToScope(Tab, Search)
    end

    local FirstVisiblePage
    local ActiveHasVisible = false

    for _, Page in ipairs(Tab.OrderedPages) do
        if Page.Destroyed then
            continue
        end

        local HasVisible = Page.Visible ~= false and ApplySearchToScope(Page, Search)
        Page.Button.Visible = HasVisible
        if HasVisible then
            FirstVisiblePage = FirstVisiblePage or Page
            ActiveHasVisible = ActiveHasVisible or Tab.ActivePage == Page
        elseif Tab.ActivePage == Page then
            Page:Hide(true)
        end
    end

    if not ActiveHasVisible and FirstVisiblePage then
        FirstVisiblePage:Show(true)
    end

    if Tab.PageNavigation then
        Tab.PageNavigation.Visible = FirstVisiblePage ~= nil
    end
    Tab:RefreshSides()
    return FirstVisiblePage ~= nil
end

local function ResetScope(Scope)
    if not Scope then
        return
    end

    for _, Groupbox in Scope.Groupboxes do
        for _, ElementInfo in Groupbox.Elements do
            if ElementInfo.SubButton then
                local MainVisible = ElementInfo.Visible ~= false
                local SubVisible = ElementInfo.SubButton.Visible ~= false
                ElementInfo.Base.Visible = MainVisible
                ElementInfo.SubButton.Base.Visible = SubVisible
                ElementInfo.Holder.Visible = MainVisible or SubVisible
            else
                ElementInfo.Holder.Visible = ElementInfo.Visible ~= false
            end
        end

        for _, Depbox in Groupbox.DependencyBoxes do
            RestoreDepbox(Depbox)
        end

        Groupbox:Resize()
        Groupbox.Holder.Visible = Groupbox.Visible ~= false
        Groupbox.BoxHolder.Visible = Groupbox.Visible ~= false
    end

    for _, DepGroupbox in Scope.DependencyGroupboxes do
        RestoreDepbox(DepGroupbox)
    end

    for _, Tabbox in Scope.Tabboxes do
        for _, SubTab in ipairs(Tabbox.OrderedTabs or Tabbox.Tabs) do
            for _, ElementInfo in SubTab.Elements do
                if ElementInfo.SubButton then
                    local MainVisible = ElementInfo.Visible ~= false
                    local SubVisible = ElementInfo.SubButton.Visible ~= false
                    ElementInfo.Base.Visible = MainVisible
                    ElementInfo.SubButton.Base.Visible = SubVisible
                    ElementInfo.Holder.Visible = MainVisible or SubVisible
                else
                    ElementInfo.Holder.Visible = ElementInfo.Visible ~= false
                end
            end

            for _, Depbox in SubTab.DependencyBoxes do
                RestoreDepbox(Depbox)
            end

            SubTab.ButtonHolder.Visible = true
        end

        if Tabbox.ActiveTab then
            Tabbox.ActiveTab:Resize()
        end
        Tabbox.BoxHolder.Visible = true
    end
end

local function ResetTab(Tab)
    if not Tab then
        return
    end

    if not Tab.OrderedPages or #Tab.OrderedPages == 0 then
        ResetScope(Tab)
        return
    end

    local FirstVisiblePage
    local ActiveIsVisible = false
    for _, Page in ipairs(Tab.OrderedPages) do
        if Page.Destroyed then
            continue
        end

        ResetScope(Page)
        Page.Button.Visible = Page.Visible ~= false
        if Page.Visible ~= false then
            FirstVisiblePage = FirstVisiblePage or Page
            ActiveIsVisible = ActiveIsVisible or Tab.ActivePage == Page
        end
    end

    if not ActiveIsVisible and FirstVisiblePage then
        FirstVisiblePage:Show(true)
    end

    if Tab.PageNavigation then
        Tab.PageNavigation.Visible = FirstVisiblePage ~= nil
    end
    Tab:RefreshSides()
end

local SearchRefreshQueued = false
local function RefreshSearchIfActive()
    if Library.UpdatingSearch or Trim(Library.SearchText or "") == "" or SearchRefreshQueued then
        return
    end

    SearchRefreshQueued = true
    task.defer(function()
        SearchRefreshQueued = false
        if not Library.Unloaded and not Library.UpdatingSearch and Trim(Library.SearchText or "") ~= "" then
            Library:UpdateSearch(Library.SearchText)
        end
    end)
end

function Library:UpdateSearch(SearchText)
    Library.UpdatingSearch = true
    SearchText = tostring(SearchText or "")
    Library.SearchText = SearchText

    local TabsToReset = {}

    if Library.GlobalSearch then
        for _, Entry in ipairs(Library.TabButtons) do
            local Tab = Entry.Tab
            if
                typeof(Tab) == "table"
                and not Tab.IsKeyTab
                and not Tab.Destroyed
            then
                table.insert(TabsToReset, Tab)
            end
        end
    elseif Library.LastSearchTab and typeof(Library.LastSearchTab) == "table" then
        table.insert(TabsToReset, Library.LastSearchTab)
    end

    for _, Tab in ipairs(TabsToReset) do
        ResetTab(Tab)
    end

    local Search = SearchText:lower()
    if Trim(Search) == "" then
        Library.Searching = false
        Library.LastSearchTab = nil
        Library.UpdatingSearch = false
        return
    end
    if not Library.GlobalSearch and Library.ActiveTab and Library.ActiveTab.IsKeyTab then
        Library.Searching = true
        Library.LastSearchTab = nil
        Library.UpdatingSearch = false
        return
    end

    Library.Searching = true

    local TabsToSearch = {}

    if Library.GlobalSearch then
        for _, Entry in ipairs(Library.TabButtons) do
            local Tab = Entry.Tab
            if
                typeof(Tab) == "table"
                and not Tab.IsKeyTab
                and not Tab.Destroyed
                and Tab.Button
                and Tab.Button.Visible
            then
                table.insert(TabsToSearch, Tab)
            end
        end
    elseif Library.ActiveTab then
        table.insert(TabsToSearch, Library.ActiveTab)
    end

    local FirstVisibleTab = nil
    local ActiveHasVisible = false

    for _, Tab in ipairs(TabsToSearch) do
        local HasVisible = ApplySearchToTab(Tab, Search)
        if HasVisible then
            if not FirstVisibleTab then
                FirstVisibleTab = Tab
            end
            if Tab == Library.ActiveTab then
                ActiveHasVisible = true
            end
        end
    end

    if Library.GlobalSearch then
        if ActiveHasVisible and Library.ActiveTab then
            Library.ActiveTab:RefreshSides()
        elseif FirstVisibleTab then
            local SearchMarker = SearchText
            task.defer(function()
                if
                    Library.SearchText ~= SearchMarker
                    or not Library.GlobalSearch
                    or FirstVisibleTab.Destroyed
                    or not FirstVisibleTab.Button
                    or not FirstVisibleTab.Button.Visible
                then
                    return
                end

                if Library.ActiveTab ~= FirstVisibleTab then
                    FirstVisibleTab:Show()
                end
            end)
        end
        Library.LastSearchTab = nil
    else
        Library.LastSearchTab = Library.ActiveTab
    end
    Library.UpdatingSearch = false
end

function Library:AddToRegistry(Instance, Properties)
    Library.Registry[Instance] = Properties
end

function Library:RemoveFromRegistry(Instance)
    Library.Registry[Instance] = nil
end

function Library:UpdateColorsUsingRegistry()
    for Instance, Properties in Library.Registry do
        for Property, Index in Properties do
            local SchemeValue = GetSchemeValue(Index)

            if SchemeValue or typeof(Index) == "function" then
                Instance[Property] = SchemeValue or Index()
            end
        end
    end
end

function Library:SetDPIScale(DPIScale: number)
    assert(typeof(DPIScale) == "number" and DPIScale > 0, "DPI scale must be a positive number.")
    Library.DPIScale = DPIScale / 100
    Library.MinSize = Library.OriginalMinSize * Library.DPIScale

    for Index = #Library.Scales, 1, -1 do
        local UIScale = Library.Scales[Index]
        if not UIScale.Parent then
            Library.ScalesOffset[UIScale] = nil
            table.remove(Library.Scales, Index)
        else
            UIScale.Scale = Library.DPIScale - (tonumber(Library.ScalesOffset[UIScale]) or 0)
        end
    end

    for _, Option in Options do
        if Option.Type == "Dropdown" then
            Option:RecalculateListSize()
        end
    end

    for _, Notification in Library.Notifications do
        Notification:Resize()
    end

    Library:UpdateNotificationPositions(true)
end

function Library:GiveSignal(Connection: RBXScriptConnection | RBXScriptSignal)
    local ConnectionType = typeof(Connection)
    if Connection and (ConnectionType == "RBXScriptConnection" or ConnectionType == "RBXScriptSignal") then
        table.insert(Library.Signals, Connection)
    end

    return Connection
end

function Library:ForgetSignal(Connection: RBXScriptConnection?)
    if not Connection then
        return
    end

    if Connection.Connected then
        Connection:Disconnect()
    end

    local Index = table.find(Library.Signals, Connection)
    if Index then
        table.remove(Library.Signals, Index)
    end
end

function IsValidCustomIcon(Icon: string)
    return typeof(Icon) == "string" and (Icon:match("^rbxasset://textures/") or Icon:match("roblox%.com/asset/%?id=") or Icon:match("rbxthumb://type="))
end

local function IsCustomAssetIcon(Icon: string, IncludeAssetId: boolean)
    return typeof(Icon) == "string" and (Icon:match("^content://") or Icon:match("^rbxasset://%x+/") or (IncludeAssetId == true and Icon:match("^rbxassetid://")))
end

type Icon = {
    Url: string,
    Id: number,
    IconName: string,
    ImageRectOffset: Vector2,
    ImageRectSize: Vector2,
}

type IconModule = {
    Icons: { string },
    GetAsset: (Name: string) -> Icon?,
}

local FetchIcons, Icons = true, (function()
local assets = (function()
-- This file was @generated by Tarmac. It is not intended for manual editing.
return {
	["a-arrow-down"] = 85758889687786,
	["a-arrow-up"] = 102165397775777,
	["a-large-small"] = 120435565718499,
	accessibility = 134709504811618,
	activity = 116785635688905,
	["air-vent"] = 128830959442416,
	airplay = 120532433393858,
	["alarm-clock"] = 135676792539632,
	["alarm-clock-check"] = 127147726542044,
	["alarm-clock-minus"] = 95643155997004,
	["alarm-clock-off"] = 137565311508297,
	["alarm-clock-plus"] = 120411905187238,
	["alarm-smoke"] = 132790621765466,
	album = 127392884430355,
	["align-center"] = 96679836838314,
	["align-center-horizontal"] = 81234251374424,
	["align-center-vertical"] = 123778475388904,
	["align-end-horizontal"] = 81993664554439,
	["align-end-vertical"] = 99312370694107,
	["align-horizontal-distribute-center"] = 118173212655147,
	["align-horizontal-distribute-end"] = 119611041085513,
	["align-horizontal-distribute-start"] = 121542670969125,
	["align-horizontal-justify-center"] = 129528110611234,
	["align-horizontal-justify-end"] = 84954252650701,
	["align-horizontal-justify-start"] = 94264399395941,
	["align-horizontal-space-around"] = 103744081790884,
	["align-horizontal-space-between"] = 101251856513947,
	["align-justify"] = 132508901949872,
	["align-left"] = 73665096529381,
	["align-right"] = 119992416120405,
	["align-start-horizontal"] = 92574847248087,
	["align-start-vertical"] = 96167730292932,
	["align-vertical-distribute-center"] = 100557171686579,
	["align-vertical-distribute-end"] = 140244274635306,
	["align-vertical-distribute-start"] = 104366918572697,
	["align-vertical-justify-center"] = 125823633272170,
	["align-vertical-justify-end"] = 101012057660025,
	["align-vertical-justify-start"] = 127756811142477,
	["align-vertical-space-around"] = 80630398253986,
	["align-vertical-space-between"] = 99587234432478,
	ambulance = 87996833293600,
	ampersand = 76003774257181,
	ampersands = 122865331745636,
	amphora = 85710574172044,
	anchor = 117368273793473,
	angry = 131535996678230,
	annoyed = 89651894120317,
	antenna = 105556767656262,
	anvil = 100535116378267,
	aperture = 88920539534875,
	["app-window"] = 128524598896661,
	["app-window-mac"] = 84920671926321,
	apple = 82452145861900,
	archive = 96979844504359,
	["archive-restore"] = 130207139403143,
	["archive-x"] = 125724859663305,
	armchair = 92951944347771,
	["arrow-big-down"] = 87872502681784,
	["arrow-big-down-dash"] = 80956925610434,
	["arrow-big-left"] = 76008736050357,
	["arrow-big-left-dash"] = 80166004308034,
	["arrow-big-right"] = 81390374011332,
	["arrow-big-right-dash"] = 125910019327152,
	["arrow-big-up"] = 118315457005585,
	["arrow-big-up-dash"] = 139174253931992,
	["arrow-down"] = 111101849488750,
	["arrow-down-0-1"] = 134662804888116,
	["arrow-down-1-0"] = 90807982982621,
	["arrow-down-a-z"] = 74563886614714,
	["arrow-down-from-line"] = 123039586915624,
	["arrow-down-left"] = 105470816142918,
	["arrow-down-narrow-wide"] = 104635517851768,
	["arrow-down-right"] = 104630792951402,
	["arrow-down-to-dot"] = 95176928712454,
	["arrow-down-to-line"] = 109729358294452,
	["arrow-down-up"] = 139238003599315,
	["arrow-down-wide-narrow"] = 88577562336410,
	["arrow-down-z-a"] = 90653871517145,
	["arrow-left"] = 86088091986547,
	["arrow-left-from-line"] = 88700685151310,
	["arrow-left-right"] = 94596049358882,
	["arrow-left-to-line"] = 116829154369215,
	["arrow-right"] = 81302631706885,
	["arrow-right-from-line"] = 132141803726901,
	["arrow-right-left"] = 108283385684703,
	["arrow-right-to-line"] = 114892398312410,
	["arrow-up"] = 79062740627249,
	["arrow-up-0-1"] = 114095112758791,
	["arrow-up-1-0"] = 115833544112532,
	["arrow-up-a-z"] = 130831349804002,
	["arrow-up-down"] = 102155677695268,
	["arrow-up-from-dot"] = 134959689985016,
	["arrow-up-from-line"] = 134860743051776,
	["arrow-up-left"] = 107477197303574,
	["arrow-up-narrow-wide"] = 101421168592063,
	["arrow-up-right"] = 103889806698388,
	["arrow-up-to-line"] = 131974361540264,
	["arrow-up-wide-narrow"] = 106886180124309,
	["arrow-up-z-a"] = 76578983028237,
	["arrows-up-from-line"] = 105423404426073,
	asterisk = 123815391218414,
	["at-sign"] = 104314582758551,
	atom = 120167347744561,
	["audio-lines"] = 138755914830486,
	["audio-waveform"] = 119789394178873,
	award = 89623672395278,
	axe = 95479937653376,
	["axis-3d"] = 92397422208087,
	baby = 134780923890658,
	backpack = 78993249203823,
	badge = 93861197775357,
	["badge-alert"] = 73521163893374,
	["badge-cent"] = 122278154144822,
	["badge-check"] = 102864233048311,
	["badge-dollar-sign"] = 99073011426006,
	["badge-euro"] = 129639299324055,
	["badge-indian-rupee"] = 87973104646655,
	["badge-info"] = 98821060789724,
	["badge-japanese-yen"] = 134928701899269,
	["badge-minus"] = 129618320064265,
	["badge-percent"] = 105307797413967,
	["badge-plus"] = 120096069624662,
	["badge-pound-sterling"] = 98623823861803,
	["badge-question-mark"] = 114663892643950,
	["badge-russian-ruble"] = 99522239121803,
	["badge-swiss-franc"] = 115747080056818,
	["badge-turkish-lira"] = 137289094254207,
	["badge-x"] = 127345048117218,
	["baggage-claim"] = 108988660196157,
	ban = 131594718784390,
	banana = 126474514866989,
	bandage = 102355944011166,
	banknote = 83624352345036,
	["banknote-arrow-down"] = 128101736029907,
	["banknote-arrow-up"] = 103476760707791,
	["banknote-x"] = 110844057471453,
	barcode = 129209916672607,
	barrel = 127931314050877,
	baseline = 137447148848893,
	bath = 111108655648642,
	battery = 81540661066811,
	["battery-charging"] = 126836500232390,
	["battery-full"] = 127212547690381,
	["battery-low"] = 87721404307217,
	["battery-medium"] = 114615415737248,
	["battery-plus"] = 76354196605526,
	["battery-warning"] = 136795384828263,
	beaker = 140429312347329,
	bean = 140548534094518,
	["bean-off"] = 87490357773352,
	bed = 103703460158347,
	["bed-double"] = 118545136165123,
	["bed-single"] = 117894740011786,
	beef = 95141393904694,
	bell = 111725241873349,
	["bell-dot"] = 102000063515653,
	["bell-electric"] = 130154093563594,
	["bell-minus"] = 134871560843826,
	["bell-off"] = 109403921599739,
	["bell-plus"] = 87193682465452,
	["bell-ring"] = 81911080119140,
	["between-horizontal-end"] = 105855324839543,
	["between-horizontal-start"] = 116266907424675,
	["between-vertical-end"] = 109243784030881,
	["between-vertical-start"] = 112708575033628,
	["biceps-flexed"] = 113573819070463,
	bike = 120355969619987,
	binary = 82905169249889,
	binoculars = 114841582615801,
	biohazard = 90593430701402,
	bird = 127082032570770,
	bitcoin = 120165823908407,
	blend = 106898143444225,
	blinds = 131748682748698,
	blocks = 99930206828481,
	bluetooth = 87938138872705,
	["bluetooth-connected"] = 93809243280097,
	["bluetooth-off"] = 92065127311527,
	["bluetooth-searching"] = 138407763527325,
	bold = 71230510917945,
	bolt = 72499878743015,
	bomb = 119539352578001,
	bone = 93032826374472,
	book = 136417435522797,
	["book-a"] = 138905558517206,
	["book-alert"] = 83126881397457,
	["book-audio"] = 130817325428812,
	["book-check"] = 101435243286406,
	["book-copy"] = 92171152631020,
	["book-dashed"] = 81283267299629,
	["book-down"] = 133514420249956,
	["book-headphones"] = 139523016403916,
	["book-heart"] = 122531870789237,
	["book-image"] = 137276864404721,
	["book-key"] = 139461027818572,
	["book-lock"] = 98420126712941,
	["book-marked"] = 108700129544150,
	["book-minus"] = 134429286820139,
	["book-open"] = 73094472868219,
	["book-open-check"] = 139564107496900,
	["book-open-text"] = 112163368354922,
	["book-plus"] = 86198588567912,
	["book-text"] = 92477178021408,
	["book-type"] = 140569336920621,
	["book-up"] = 129825144914500,
	["book-up-2"] = 138870529166566,
	["book-user"] = 78445558294223,
	["book-x"] = 117684589004730,
	bookmark = 96422374119496,
	["bookmark-check"] = 140385274312943,
	["bookmark-minus"] = 90761509653848,
	["bookmark-plus"] = 102716399992603,
	["bookmark-x"] = 83946741234593,
	["boom-box"] = 117773767367782,
	bot = 112973706230253,
	["bot-message-square"] = 127454915177046,
	["bot-off"] = 123215836836938,
	["bow-arrow"] = 82126194792160,
	box = 101391159909398,
	boxes = 129614835711516,
	braces = 74399703620454,
	brackets = 126480941270849,
	brain = 80449922621372,
	["brain-circuit"] = 122829293465734,
	["brain-cog"] = 133841445789468,
	["brick-wall"] = 88059137745523,
	["brick-wall-fire"] = 101508535298010,
	["brick-wall-shield"] = 122970924994177,
	briefcase = 79573382931819,
	["briefcase-business"] = 89024144265875,
	["briefcase-conveyor-belt"] = 80699894594034,
	["briefcase-medical"] = 88977669291957,
	["bring-to-front"] = 121372673068497,
	brush = 140399962450518,
	["brush-cleaning"] = 77081887717462,
	bubbles = 100951413779327,
	bug = 108064626456459,
	["bug-off"] = 115130754051050,
	["bug-play"] = 93005823489214,
	building = 115759871615135,
	["building-2"] = 113633264034729,
	bus = 70492885634507,
	["bus-front"] = 101442123728652,
	cable = 73929033306217,
	["cable-car"] = 103343370160284,
	cake = 94945328569141,
	["cake-slice"] = 134869363778873,
	calculator = 126294519603935,
	calendar = 95545489603627,
	["calendar-1"] = 111669544177893,
	["calendar-arrow-down"] = 98826297336095,
	["calendar-arrow-up"] = 101259481484784,
	["calendar-check"] = 128735293881337,
	["calendar-check-2"] = 134741295436727,
	["calendar-clock"] = 137989998809749,
	["calendar-cog"] = 81132100829120,
	["calendar-days"] = 74473866264642,
	["calendar-fold"] = 72800363993863,
	["calendar-heart"] = 140469143489469,
	["calendar-minus"] = 126947076491962,
	["calendar-minus-2"] = 114758284207771,
	["calendar-off"] = 83172321745470,
	["calendar-plus"] = 95864120179039,
	["calendar-plus-2"] = 110548362075353,
	["calendar-range"] = 137666557292561,
	["calendar-search"] = 77709463965815,
	["calendar-sync"] = 97624728588729,
	["calendar-x"] = 138974312970463,
	["calendar-x-2"] = 107515535887947,
	camera = 102911860111235,
	["camera-off"] = 99242316763000,
	candy = 121602796953412,
	["candy-cane"] = 112464754953529,
	["candy-off"] = 98908167238404,
	captions = 92247523675264,
	["captions-off"] = 117421756298550,
	car = 104209031513829,
	["car-front"] = 108397050137008,
	["car-taxi-front"] = 73584751879123,
	caravan = 127063101240586,
	["card-sim"] = 87568181073492,
	carrot = 121695263564136,
	["case-lower"] = 104147111219050,
	["case-sensitive"] = 80443686256687,
	["case-upper"] = 106568493343250,
	["cassette-tape"] = 85528666149718,
	cast = 106045389407030,
	castle = 137349466287423,
	cat = 132587012252853,
	cctv = 96089950910363,
	["chart-area"] = 83865456239149,
	["chart-bar"] = 78022204342641,
	["chart-bar-big"] = 77915167652266,
	["chart-bar-decreasing"] = 128999724972766,
	["chart-bar-increasing"] = 94790043521729,
	["chart-bar-stacked"] = 118586341637168,
	["chart-candlestick"] = 97939388409760,
	["chart-column"] = 90604892299985,
	["chart-column-big"] = 117124840997620,
	["chart-column-decreasing"] = 128154461153272,
	["chart-column-increasing"] = 110238053193715,
	["chart-column-stacked"] = 138210545678793,
	["chart-gantt"] = 105284278917364,
	["chart-line"] = 132073950959918,
	["chart-no-axes-column"] = 134593063392849,
	["chart-no-axes-column-decreasing"] = 117582413267339,
	["chart-no-axes-column-increasing"] = 107383929417521,
	["chart-no-axes-combined"] = 125766210212199,
	["chart-no-axes-gantt"] = 136683497999733,
	["chart-pie"] = 129237625973646,
	["chart-scatter"] = 109368208547302,
	["chart-spline"] = 128939166873577,
	check = 83827110621355,
	["check-check"] = 85764415779159,
	["check-line"] = 85776673122871,
	["chef-hat"] = 104351698660651,
	cherry = 130832753420629,
	["chevron-down"] = 95086910949405,
	["chevron-first"] = 130485497879762,
	["chevron-last"] = 127072220474704,
	["chevron-left"] = 83856486110301,
	["chevron-right"] = 126507964682213,
	["chevron-up"] = 124630674114245,
	["chevrons-down"] = 118746624854239,
	["chevrons-down-up"] = 122938925052724,
	["chevrons-left"] = 72622305378588,
	["chevrons-left-right"] = 100027150072609,
	["chevrons-left-right-ellipsis"] = 70758373090992,
	["chevrons-right"] = 115563110262022,
	["chevrons-right-left"] = 79674513843833,
	["chevrons-up"] = 115981451099607,
	["chevrons-up-down"] = 113432796824448,
	chrome = 73342145832786,
	church = 136057686683219,
	circle = 97474013459876,
	["circle-alert"] = 86075768491850,
	["circle-arrow-down"] = 98516510858394,
	["circle-arrow-left"] = 139149045348698,
	["circle-arrow-out-down-left"] = 140114130402613,
	["circle-arrow-out-down-right"] = 97306619688140,
	["circle-arrow-out-up-left"] = 133904465013804,
	["circle-arrow-out-up-right"] = 133791579853102,
	["circle-arrow-right"] = 132106229530514,
	["circle-arrow-up"] = 125630987618979,
	["circle-check"] = 122835208471730,
	["circle-check-big"] = 101462339244321,
	["circle-chevron-down"] = 125398962450772,
	["circle-chevron-left"] = 133979492199232,
	["circle-chevron-right"] = 130029053510525,
	["circle-chevron-up"] = 137057131849576,
	["circle-dashed"] = 97773019242734,
	["circle-divide"] = 75278590313141,
	["circle-dollar-sign"] = 103021845191343,
	["circle-dot"] = 73332621255981,
	["circle-dot-dashed"] = 121201310391755,
	["circle-ellipsis"] = 128894546879090,
	["circle-equal"] = 91854769894722,
	["circle-fading-arrow-up"] = 121178878326961,
	["circle-fading-plus"] = 95512963110153,
	["circle-gauge"] = 84688454826847,
	["circle-minus"] = 74458161947564,
	["circle-off"] = 80618483788295,
	["circle-parking"] = 121342131175144,
	["circle-parking-off"] = 115951067573453,
	["circle-pause"] = 75601858754638,
	["circle-percent"] = 89021739919224,
	["circle-play"] = 119442756895009,
	["circle-plus"] = 132023187288319,
	["circle-pound-sterling"] = 121749745341582,
	["circle-power"] = 131944289575262,
	["circle-question-mark"] = 98575632186975,
	["circle-slash"] = 86554477881978,
	["circle-slash-2"] = 93846864384983,
	["circle-small"] = 106775888594817,
	["circle-star"] = 108994144808450,
	["circle-stop"] = 122478988921288,
	["circle-user"] = 73363870264217,
	["circle-user-round"] = 103422319407938,
	["circle-x"] = 136096054247483,
	["circuit-board"] = 102649990533936,
	citrus = 104012894480157,
	clapperboard = 117040519290119,
	clipboard = 91839478896367,
	["clipboard-check"] = 119930716282333,
	["clipboard-clock"] = 81178312131599,
	["clipboard-copy"] = 116099874965891,
	["clipboard-list"] = 110095483413821,
	["clipboard-minus"] = 107683237596936,
	["clipboard-paste"] = 137750657442733,
	["clipboard-pen"] = 112275963070957,
	["clipboard-pen-line"] = 111346066067551,
	["clipboard-plus"] = 132362866476079,
	["clipboard-type"] = 106736512129205,
	["clipboard-x"] = 128986978015444,
	clock = 96835529467684,
	["clock-1"] = 98563563321460,
	["clock-10"] = 80443443598462,
	["clock-11"] = 82371834247998,
	["clock-12"] = 133877976025070,
	["clock-2"] = 72258367874092,
	["clock-3"] = 86319537133958,
	["clock-4"] = 111040057497751,
	["clock-5"] = 82455058311564,
	["clock-6"] = 110541146574832,
	["clock-7"] = 138423994726927,
	["clock-8"] = 98901513399369,
	["clock-9"] = 140464097226658,
	["clock-alert"] = 115862173875314,
	["clock-arrow-down"] = 95351498388159,
	["clock-arrow-up"] = 131512554213603,
	["clock-fading"] = 138812484601909,
	["clock-plus"] = 108994381956359,
	["closed-caption"] = 109168929168877,
	cloud = 76797375125469,
	["cloud-alert"] = 106567345820073,
	["cloud-check"] = 83689617445982,
	["cloud-cog"] = 99037393440946,
	["cloud-download"] = 134259137069761,
	["cloud-drizzle"] = 108966030756512,
	["cloud-fog"] = 116434374562091,
	["cloud-hail"] = 93896344446382,
	["cloud-lightning"] = 88393801019014,
	["cloud-moon"] = 92598532990542,
	["cloud-moon-rain"] = 102795706163713,
	["cloud-off"] = 132746052928464,
	["cloud-rain"] = 126682720368880,
	["cloud-rain-wind"] = 138531953575675,
	["cloud-snow"] = 83889452050491,
	["cloud-sun"] = 99857531021323,
	["cloud-sun-rain"] = 102969016910466,
	["cloud-upload"] = 85588611412306,
	cloudy = 72892691173430,
	clover = 73146836842348,
	club = 119692145642080,
	code = 102858857098762,
	["code-xml"] = 130876992978049,
	codepen = 121196034119960,
	codesandbox = 81104810964988,
	coffee = 75171771078867,
	cog = 134998527925514,
	coins = 128784569032326,
	["columns-2"] = 89175983308456,
	["columns-3"] = 109318054321048,
	["columns-3-cog"] = 138473447831624,
	["columns-4"] = 92778631374832,
	combine = 98228911815481,
	command = 129307680894782,
	compass = 117355392623233,
	component = 81317444646043,
	computer = 129323176739507,
	["concierge-bell"] = 126886445681359,
	cone = 74845976589938,
	construction = 115083821531795,
	contact = 83336471862351,
	["contact-round"] = 92207205844906,
	container = 116643588421234,
	contrast = 76959893700184,
	cookie = 139241068220893,
	["cooking-pot"] = 73135275032763,
	copy = 87942399647942,
	["copy-check"] = 99030373914807,
	["copy-minus"] = 73147465136627,
	["copy-plus"] = 124547842490145,
	["copy-slash"] = 73629354412770,
	["copy-x"] = 76935228109965,
	copyleft = 117008643514602,
	copyright = 116764791222062,
	["corner-down-left"] = 121810619354729,
	["corner-down-right"] = 94219370057308,
	["corner-left-down"] = 88518708580891,
	["corner-left-up"] = 80457911677892,
	["corner-right-down"] = 71667850048566,
	["corner-right-up"] = 116802297506682,
	["corner-up-left"] = 77719684055742,
	["corner-up-right"] = 101875782041114,
	cpu = 115781787166822,
	["creative-commons"] = 106945564709172,
	["credit-card"] = 135019527878105,
	croissant = 124064182582120,
	crop = 137832753521417,
	cross = 106039923010417,
	crosshair = 114929017287945,
	crown = 90472614287057,
	cuboid = 85125857520529,
	["cup-soda"] = 116064630908908,
	currency = 98741673384975,
	cylinder = 106008846957333,
	dam = 123638563636102,
	database = 122884003685338,
	["database-backup"] = 134263890065988,
	["database-zap"] = 94292145388316,
	["decimals-arrow-left"] = 83364854887027,
	["decimals-arrow-right"] = 89255202941321,
	delete = 120475342373468,
	dessert = 79122775950408,
	diameter = 103202047751161,
	diamond = 116224572544413,
	["diamond-minus"] = 98219591040851,
	["diamond-percent"] = 90953177250482,
	["diamond-plus"] = 81855866369969,
	["dice-1"] = 129785132691343,
	["dice-2"] = 101184428062194,
	["dice-3"] = 126124539917527,
	["dice-4"] = 136593201423203,
	["dice-5"] = 72548398039172,
	["dice-6"] = 107423423270100,
	dices = 117821030233748,
	diff = 89271474511472,
	disc = 139513828111819,
	["disc-2"] = 77624862049574,
	["disc-3"] = 101670496442540,
	["disc-album"] = 119925914044267,
	divide = 122092927804054,
	dna = 89745363802733,
	["dna-off"] = 138639847028076,
	dock = 132625251672190,
	dog = 111571812945872,
	["dollar-sign"] = 118972397587528,
	donut = 80434741396669,
	["door-closed"] = 89760328598955,
	["door-closed-locked"] = 72612456720492,
	["door-open"] = 133814065231262,
	dot = 97016002851923,
	download = 93868047445509,
	["drafting-compass"] = 132019045125555,
	drama = 140495061255070,
	dribbble = 85814569433570,
	drill = 102448607336819,
	drone = 87852662372231,
	droplet = 117947500824611,
	["droplet-off"] = 89562126293632,
	droplets = 91168064495352,
	drum = 85667754872431,
	drumstick = 75387497663037,
	dumbbell = 135834722331614,
	ear = 125040388889621,
	["ear-off"] = 77431400735000,
	earth = 80407859572555,
	["earth-lock"] = 82771383007037,
	eclipse = 124423514511474,
	egg = 73908680452587,
	["egg-fried"] = 88691210642745,
	["egg-off"] = 75945935080886,
	ellipsis = 95956203670622,
	["ellipsis-vertical"] = 93274856771582,
	equal = 81138954359025,
	["equal-approximately"] = 126766764416385,
	["equal-not"] = 110767672641130,
	eraser = 101514212866613,
	["ethernet-port"] = 107171703835846,
	euro = 105515269837621,
	expand = 135216706603096,
	["external-link"] = 88749979118129,
	eye = 139722329189430,
	["eye-closed"] = 85964738779718,
	["eye-off"] = 112375739491233,
	facebook = 126875779412726,
	factory = 124610887424481,
	fan = 99112617546784,
	["fast-forward"] = 86261062156594,
	feather = 72722125673150,
	fence = 136027177552403,
	["ferris-wheel"] = 94212033084546,
	figma = 78102137532795,
	file = 105710786731627,
	["file-archive"] = 121027564735426,
	["file-audio"] = 109136641816876,
	["file-audio-2"] = 71519060566551,
	["file-axis-3d"] = 120595284164307,
	["file-badge"] = 130908597463749,
	["file-badge-2"] = 117822997727543,
	["file-box"] = 78582029223846,
	["file-chart-column"] = 79314568863524,
	["file-chart-column-increasing"] = 113934830439854,
	["file-chart-line"] = 127333232922341,
	["file-chart-pie"] = 87366366651618,
	["file-check"] = 82422075525002,
	["file-check-2"] = 87216739205557,
	["file-clock"] = 73969155690610,
	["file-code"] = 92873308907212,
	["file-code-2"] = 115805780254840,
	["file-cog"] = 89816062085634,
	["file-diff"] = 123117415259557,
	["file-digit"] = 104037036187285,
	["file-down"] = 70441423818099,
	["file-heart"] = 90332007470916,
	["file-image"] = 80147266004613,
	["file-input"] = 126683034896557,
	["file-json"] = 76272094739618,
	["file-json-2"] = 117283373455325,
	["file-key"] = 85781683326011,
	["file-key-2"] = 104279126245073,
	["file-lock"] = 74414492225090,
	["file-lock-2"] = 129467818396353,
	["file-minus"] = 100049317730317,
	["file-minus-2"] = 99533501912168,
	["file-music"] = 87486385971490,
	["file-output"] = 117761656606452,
	["file-pen"] = 120012000577923,
	["file-pen-line"] = 77107867479655,
	["file-play"] = 122519637890628,
	["file-plus"] = 134349751246644,
	["file-plus-2"] = 98358464374463,
	["file-question-mark"] = 107111567783242,
	["file-scan"] = 116607859572941,
	["file-search"] = 87648314058326,
	["file-search-2"] = 97504576826222,
	["file-sliders"] = 87362735438576,
	["file-spreadsheet"] = 108378493201587,
	["file-stack"] = 119139237519469,
	["file-symlink"] = 125888988169632,
	["file-terminal"] = 114817439039127,
	["file-text"] = 77346633411296,
	["file-type"] = 91319647276184,
	["file-type-2"] = 102862931204754,
	["file-up"] = 77215633607245,
	["file-user"] = 125031706574705,
	["file-video-camera"] = 98825192269661,
	["file-volume"] = 84825655898765,
	["file-volume-2"] = 132074661677474,
	["file-warning"] = 131113901247439,
	["file-x"] = 134673190690961,
	["file-x-2"] = 75426786305569,
	files = 119868587246453,
	film = 115982940808785,
	fingerprint = 135337299493865,
	["fire-extinguisher"] = 106667025708329,
	fish = 107002260548857,
	["fish-off"] = 83515767284587,
	["fish-symbol"] = 112313456680575,
	flag = 80165228709790,
	["flag-off"] = 131374214560413,
	["flag-triangle-left"] = 100274047554673,
	["flag-triangle-right"] = 95559011206904,
	flame = 78769660969441,
	["flame-kindling"] = 125287652452426,
	flashlight = 114148297083785,
	["flashlight-off"] = 78806207489112,
	["flask-conical"] = 77588155748536,
	["flask-conical-off"] = 140153784540477,
	["flask-round"] = 125921380095942,
	["flip-horizontal"] = 104841355411279,
	["flip-horizontal-2"] = 75840761823703,
	["flip-vertical"] = 88010991372085,
	["flip-vertical-2"] = 115335841457244,
	flower = 125602823130456,
	["flower-2"] = 93937864318346,
	focus = 74209922635562,
	["fold-horizontal"] = 119215308506101,
	["fold-vertical"] = 89627287319601,
	folder = 94236858672537,
	["folder-archive"] = 85978040479686,
	["folder-check"] = 89058605827073,
	["folder-clock"] = 132379000568110,
	["folder-closed"] = 78087942744334,
	["folder-code"] = 79208102753918,
	["folder-cog"] = 125325854177187,
	["folder-dot"] = 135307937184362,
	["folder-down"] = 133724276147220,
	["folder-git"] = 129905012475725,
	["folder-git-2"] = 132556334850282,
	["folder-heart"] = 74682854132263,
	["folder-input"] = 89543549078565,
	["folder-kanban"] = 115692234423291,
	["folder-key"] = 134841972348783,
	["folder-lock"] = 129345483035475,
	["folder-minus"] = 96592440405999,
	["folder-open"] = 100030967746766,
	["folder-open-dot"] = 93584740507880,
	["folder-output"] = 79131635705997,
	["folder-pen"] = 95853187570930,
	["folder-plus"] = 133649526561782,
	["folder-root"] = 85546937479322,
	["folder-search"] = 85575256433549,
	["folder-search-2"] = 132801780326542,
	["folder-symlink"] = 82192734774481,
	["folder-sync"] = 80229070969489,
	["folder-tree"] = 137484935980485,
	["folder-up"] = 135876471645692,
	["folder-x"] = 98414588777713,
	folders = 129365910191151,
	footprints = 128293375583452,
	forklift = 121191524995774,
	forward = 85252404877367,
	frame = 91667256603587,
	framer = 105756021674631,
	frown = 136210266332024,
	fuel = 124477459297771,
	fullscreen = 75191423285573,
	funnel = 139525415522108,
	["funnel-plus"] = 85388798952525,
	["funnel-x"] = 118617352389010,
	["gallery-horizontal"] = 119833288662729,
	["gallery-horizontal-end"] = 110525792845537,
	["gallery-thumbnails"] = 104642411702006,
	["gallery-vertical"] = 73022710081053,
	["gallery-vertical-end"] = 81965622854313,
	gamepad = 98531369429309,
	["gamepad-2"] = 123513783706820,
	gauge = 112385371277348,
	gavel = 135735395765414,
	gem = 111750318675671,
	["georgian-lari"] = 83044477439865,
	ghost = 121912141443713,
	gift = 104098622197576,
	["git-branch"] = 137795533783771,
	["git-branch-plus"] = 140661560177072,
	["git-commit-horizontal"] = 70945132741002,
	["git-commit-vertical"] = 91329034046756,
	["git-compare"] = 115173556067875,
	["git-compare-arrows"] = 88221652268203,
	["git-fork"] = 99605451182076,
	["git-graph"] = 112496986736544,
	["git-merge"] = 136694613142223,
	["git-pull-request"] = 103161641898441,
	["git-pull-request-arrow"] = 135103379062990,
	["git-pull-request-closed"] = 132153092177959,
	["git-pull-request-create"] = 72404602418293,
	["git-pull-request-create-arrow"] = 78997835114389,
	["git-pull-request-draft"] = 109941927307148,
	github = 99911323926868,
	gitlab = 84697247849648,
	["glass-water"] = 88501428715818,
	glasses = 71294658108313,
	globe = 111578783307093,
	["globe-lock"] = 90505069766503,
	goal = 113884228231281,
	gpu = 94475400466478,
	["graduation-cap"] = 137048485405567,
	grape = 81297793587857,
	["grid-2x2"] = 74713443066181,
	["grid-2x2-check"] = 138646582122430,
	["grid-2x2-plus"] = 73772834594194,
	["grid-2x2-x"] = 70574771191740,
	["grid-3x2"] = 98309561243489,
	["grid-3x3"] = 71217273531422,
	grip = 85101746401400,
	["grip-horizontal"] = 87629819003793,
	["grip-vertical"] = 137774674680603,
	group = 137317722960946,
	guitar = 73621537334007,
	ham = 88694785814390,
	hamburger = 94625438561758,
	hammer = 118024154647073,
	hand = 135226632951455,
	["hand-coins"] = 83908670424159,
	["hand-fist"] = 107874697791879,
	["hand-grab"] = 123243858007453,
	["hand-heart"] = 112348965568014,
	["hand-helping"] = 125055501525649,
	["hand-metal"] = 79886749805841,
	["hand-platter"] = 107005076555892,
	handbag = 91595142847556,
	handshake = 119934900822508,
	["hard-drive"] = 78399523068992,
	["hard-drive-download"] = 126141378180246,
	["hard-drive-upload"] = 83678732882261,
	["hard-hat"] = 108269886668169,
	hash = 79281219073716,
	["hat-glasses"] = 88187986739237,
	haze = 71695050029489,
	["hdmi-port"] = 81667603031684,
	heading = 78795987652364,
	["heading-1"] = 139010744018776,
	["heading-2"] = 124511186941584,
	["heading-3"] = 93398585070111,
	["heading-4"] = 129752194457637,
	["heading-5"] = 91071250337131,
	["heading-6"] = 120942934503080,
	["headphone-off"] = 129718080175290,
	headphones = 77933962515384,
	headset = 78282688338634,
	heart = 111284155515598,
	["heart-crack"] = 127768416202523,
	["heart-handshake"] = 116921190920035,
	["heart-minus"] = 73753737435862,
	["heart-off"] = 77001527259120,
	["heart-plus"] = 136895624976238,
	["heart-pulse"] = 77506710442387,
	heater = 92597012287078,
	hexagon = 107545705237342,
	highlighter = 76647612275284,
	history = 87356875172942,
	hop = 107327941544346,
	["hop-off"] = 82070652552741,
	hospital = 136121422327167,
	hotel = 116521770015178,
	hourglass = 97354459771104,
	house = 127889862453151,
	["house-plug"] = 78286530988441,
	["house-plus"] = 86361930968044,
	["house-wifi"] = 81833657881659,
	["ice-cream-bowl"] = 132923169807183,
	["ice-cream-cone"] = 113398279002531,
	["id-card"] = 132284632593096,
	["id-card-lanyard"] = 109892675249866,
	image = 97933683823480,
	["image-down"] = 128149725849146,
	["image-minus"] = 133568289476916,
	["image-off"] = 99722939227313,
	["image-play"] = 73625941877084,
	["image-plus"] = 110592938693426,
	["image-up"] = 132790868440788,
	["image-upscale"] = 93091453446368,
	images = 100017582062659,
	import = 139415113590086,
	inbox = 117961494051741,
	["indent-decrease"] = 90925139615278,
	["indent-increase"] = 110694604864721,
	infinity = 71094877806551,
	info = 117194610053749,
	["inspection-panel"] = 140555328817154,
	instagram = 137841936676016,
	italic = 138130625449010,
	["iteration-ccw"] = 106807980654516,
	["iteration-cw"] = 117352992192290,
	["japanese-yen"] = 135085526808806,
	joystick = 126601646824958,
	kanban = 94237167428633,
	kayak = 114220085067472,
	key = 128426502701541,
	["key-round"] = 80439075172197,
	["key-square"] = 108847209577743,
	keyboard = 78021479821645,
	["keyboard-music"] = 96603074688320,
	["keyboard-off"] = 74463086557782,
	lamp = 106149598999550,
	["lamp-ceiling"] = 107373474068506,
	["lamp-desk"] = 119091300882668,
	["lamp-floor"] = 118721404002286,
	["lamp-wall-down"] = 131117332018010,
	["lamp-wall-up"] = 111944147622055,
	["land-plot"] = 117262165674351,
	landmark = 79297358121552,
	languages = 99917326264912,
	laptop = 88630921256285,
	["laptop-minimal"] = 91902636411470,
	["laptop-minimal-check"] = 98083699649871,
	lasso = 136407965747211,
	["lasso-select"] = 140206314736013,
	laugh = 88041268215527,
	layers = 92401939426051,
	["layers-2"] = 71032875043708,
	["layout-dashboard"] = 109242208940047,
	["layout-grid"] = 80776002921415,
	["layout-list"] = 114901096944423,
	["layout-panel-left"] = 114060619125104,
	["layout-panel-top"] = 140600115620376,
	["layout-template"] = 129513311046670,
	leaf = 114141473154636,
	["leafy-green"] = 75869853521394,
	lectern = 132546168528484,
	["letter-text"] = 127411184020577,
	library = 83641291044674,
	["library-big"] = 70943181021648,
	["life-buoy"] = 88251596523708,
	ligature = 108611580430117,
	lightbulb = 84480692719292,
	["lightbulb-off"] = 107872451939373,
	["line-squiggle"] = 109026309416970,
	link = 73034596791310,
	["link-2"] = 133396582932673,
	["link-2-off"] = 121617377271978,
	linkedin = 140464241694936,
	list = 114094290740453,
	["list-check"] = 127870753168379,
	["list-checks"] = 86457557777962,
	["list-collapse"] = 82013284474006,
	["list-end"] = 137196003577993,
	["list-filter"] = 93463268962238,
	["list-filter-plus"] = 82054172755080,
	["list-minus"] = 109578084629712,
	["list-music"] = 129462394886041,
	["list-ordered"] = 90091028350622,
	["list-plus"] = 132897130887667,
	["list-restart"] = 131578648989528,
	["list-start"] = 139157484305448,
	["list-todo"] = 80421543478674,
	["list-tree"] = 117981368838761,
	["list-video"] = 109079200359344,
	["list-x"] = 79967305528275,
	loader = 93092440305180,
	["loader-circle"] = 83085220798016,
	["loader-pinwheel"] = 80619164634690,
	locate = 76100135911825,
	["locate-fixed"] = 90537535083303,
	["locate-off"] = 130114126626523,
	lock = 71897067930472,
	["lock-keyhole"] = 82932539629673,
	["lock-keyhole-open"] = 126670774179963,
	["lock-open"] = 87192818819520,
	["log-in"] = 104921246880407,
	["log-out"] = 121452889215065,
	logs = 116413304493431,
	lollipop = 92370242563303,
	luggage = 109817666982832,
	magnet = 106378767543648,
	mail = 107247149114562,
	["mail-check"] = 102299214572170,
	["mail-minus"] = 137507529682313,
	["mail-open"] = 79957216174404,
	["mail-plus"] = 97392054041921,
	["mail-question-mark"] = 132294296415348,
	["mail-search"] = 132121654925757,
	["mail-warning"] = 85952461449135,
	["mail-x"] = 132599640757010,
	mailbox = 121433709442295,
	mails = 109802610456892,
	map = 108279805507438,
	["map-minus"] = 133117854348106,
	["map-pin"] = 125589857044225,
	["map-pin-check"] = 73433657551837,
	["map-pin-check-inside"] = 102543459974284,
	["map-pin-house"] = 128212288031307,
	["map-pin-minus"] = 120843698769560,
	["map-pin-minus-inside"] = 118797191517231,
	["map-pin-off"] = 83652562771070,
	["map-pin-pen"] = 102101538402375,
	["map-pin-plus"] = 90799053974278,
	["map-pin-plus-inside"] = 131853510003248,
	["map-pin-x"] = 129671310772849,
	["map-pin-x-inside"] = 90842207454692,
	["map-pinned"] = 113144984652101,
	["map-plus"] = 115814246160273,
	mars = 120237837691441,
	["mars-stroke"] = 78837613304628,
	martini = 131037926665327,
	maximize = 98630565368634,
	["maximize-2"] = 108777312690515,
	medal = 112779948066117,
	megaphone = 104747300280187,
	["megaphone-off"] = 77333538129191,
	meh = 95295284819943,
	["memory-stick"] = 136984029152121,
	menu = 88105946054940,
	merge = 101733452883797,
	["message-circle"] = 103253555420242,
	["message-circle-code"] = 96382573068905,
	["message-circle-dashed"] = 88932788490732,
	["message-circle-heart"] = 126027602940494,
	["message-circle-more"] = 101045229209246,
	["message-circle-off"] = 98784452586047,
	["message-circle-plus"] = 88173371208090,
	["message-circle-question-mark"] = 72740176528871,
	["message-circle-reply"] = 85158719896232,
	["message-circle-warning"] = 92512156177738,
	["message-circle-x"] = 138168651420422,
	["message-square"] = 101115671378532,
	["message-square-code"] = 87110566156463,
	["message-square-dashed"] = 114772668488726,
	["message-square-diff"] = 132647384859535,
	["message-square-dot"] = 95702767009418,
	["message-square-heart"] = 71034790619774,
	["message-square-lock"] = 138911497616369,
	["message-square-more"] = 76114133337761,
	["message-square-off"] = 72445971887595,
	["message-square-plus"] = 84876490293543,
	["message-square-quote"] = 101124360921783,
	["message-square-reply"] = 99682905593886,
	["message-square-share"] = 111163696139836,
	["message-square-text"] = 91402725252953,
	["message-square-warning"] = 133546627536577,
	["message-square-x"] = 91869532020383,
	["messages-square"] = 109110355978624,
	mic = 103948785438713,
	["mic-off"] = 79381540622986,
	["mic-vocal"] = 92319189653574,
	microchip = 114426363692876,
	microscope = 103981634776023,
	microwave = 75423014603555,
	milestone = 84696060292016,
	milk = 107378004547607,
	["milk-off"] = 81017198212200,
	minimize = 132292418800172,
	["minimize-2"] = 115725194133672,
	minus = 120931250449806,
	monitor = 73331152826648,
	["monitor-check"] = 108437497698621,
	["monitor-cog"] = 125290620584522,
	["monitor-dot"] = 86826823806038,
	["monitor-down"] = 80104156010991,
	["monitor-off"] = 107107538808355,
	["monitor-pause"] = 115791072190872,
	["monitor-play"] = 128624177550179,
	["monitor-smartphone"] = 124682793139873,
	["monitor-speaker"] = 105110083118826,
	["monitor-stop"] = 101211853475552,
	["monitor-up"] = 116088712099154,
	["monitor-x"] = 133534745521587,
	moon = 77588825794567,
	["moon-star"] = 98988085004726,
	mountain = 80263482644790,
	["mountain-snow"] = 104191181305826,
	mouse = 107043064551659,
	["mouse-off"] = 116655697625016,
	["mouse-pointer"] = 115752319794521,
	["mouse-pointer-2"] = 109904293129960,
	["mouse-pointer-ban"] = 137539892774993,
	["mouse-pointer-click"] = 107709798577185,
	move = 133600479817246,
	["move-3d"] = 81125830831808,
	["move-diagonal"] = 125202386581344,
	["move-diagonal-2"] = 81239271655220,
	["move-down"] = 125006021670342,
	["move-down-left"] = 76073036666591,
	["move-down-right"] = 129792477029045,
	["move-horizontal"] = 93208311061400,
	["move-left"] = 112800860992157,
	["move-right"] = 82428819089555,
	["move-up"] = 71652407503735,
	["move-up-left"] = 119494062849748,
	["move-up-right"] = 90419076834904,
	["move-vertical"] = 70761579193717,
	music = 93139938100228,
	["music-2"] = 113187037257153,
	["music-3"] = 81349478842651,
	["music-4"] = 96972456280656,
	navigation = 90646250576973,
	["navigation-2"] = 134503816311328,
	["navigation-2-off"] = 131174321328073,
	["navigation-off"] = 108454330041507,
	network = 126418990233987,
	newspaper = 135902869972441,
	nfc = 131962316674237,
	["non-binary"] = 105709493665133,
	notebook = 129243301519710,
	["notebook-pen"] = 91292009218546,
	["notebook-tabs"] = 123657464898215,
	["notebook-text"] = 133642544036180,
	["notepad-text"] = 92434105164050,
	["notepad-text-dashed"] = 136002331761132,
	nut = 81712991871726,
	["nut-off"] = 96078624970734,
	octagon = 134475998551461,
	["octagon-alert"] = 95722117767051,
	["octagon-minus"] = 115829204734243,
	["octagon-pause"] = 91912739903056,
	["octagon-x"] = 117018306251145,
	omega = 91642142247281,
	option = 109155681659629,
	orbit = 74587349912272,
	origami = 77425924575822,
	package = 132935702099654,
	["package-2"] = 91942377485714,
	["package-check"] = 101219557585600,
	["package-minus"] = 100080161784047,
	["package-open"] = 86330655620431,
	["package-plus"] = 83558395457935,
	["package-search"] = 94733344459732,
	["package-x"] = 131230547740708,
	["paint-bucket"] = 136313372531199,
	["paint-roller"] = 134288427758523,
	paintbrush = 131259265232881,
	["paintbrush-vertical"] = 102069363134766,
	palette = 72590019059979,
	panda = 94307958462865,
	["panel-bottom"] = 137958171526644,
	["panel-bottom-close"] = 129839176758045,
	["panel-bottom-dashed"] = 70933718377231,
	["panel-bottom-open"] = 121992330356041,
	["panel-left"] = 113565000264024,
	["panel-left-close"] = 74390600046658,
	["panel-left-dashed"] = 72672900085409,
	["panel-left-open"] = 83412022647633,
	["panel-right"] = 84244938232059,
	["panel-right-close"] = 110482031701194,
	["panel-right-dashed"] = 90286202042323,
	["panel-right-open"] = 97178553892975,
	["panel-top"] = 73398031615308,
	["panel-top-close"] = 96198752262708,
	["panel-top-dashed"] = 110503999562022,
	["panel-top-open"] = 97204124781562,
	["panels-left-bottom"] = 103748432439667,
	["panels-right-bottom"] = 126632243488487,
	["panels-top-left"] = 110293983641300,
	paperclip = 85348713089672,
	parentheses = 132664978899134,
	["parking-meter"] = 137810887120829,
	["party-popper"] = 109041559217985,
	pause = 103515787468348,
	["paw-print"] = 92297066485556,
	["pc-case"] = 128937361383812,
	pen = 116061195824555,
	["pen-line"] = 74845359608302,
	["pen-off"] = 87844360625113,
	["pen-tool"] = 133366920150012,
	pencil = 138696307419367,
	["pencil-line"] = 110410329363278,
	["pencil-off"] = 137726198263006,
	["pencil-ruler"] = 84544564987704,
	pentagon = 83842838413405,
	percent = 122952027760305,
	["person-standing"] = 88108597062307,
	["philippine-peso"] = 137021984302903,
	phone = 98258227445115,
	["phone-call"] = 110549742231723,
	["phone-forwarded"] = 101851668578549,
	["phone-incoming"] = 110075904144850,
	["phone-missed"] = 76822282444954,
	["phone-off"] = 96027672862323,
	["phone-outgoing"] = 136094637639849,
	pi = 76240757098861,
	piano = 99707908396210,
	pickaxe = 75482513098960,
	["picture-in-picture"] = 89952035422534,
	["picture-in-picture-2"] = 111681849788255,
	["piggy-bank"] = 90884658423229,
	pilcrow = 70649688801421,
	["pilcrow-left"] = 78150190347601,
	["pilcrow-right"] = 77497763828757,
	pill = 116144362117466,
	["pill-bottle"] = 135805261557990,
	pin = 91435057862637,
	["pin-off"] = 86227962812956,
	pipette = 71094894064846,
	pizza = 95650659741106,
	plane = 137398243053043,
	["plane-landing"] = 104010936460941,
	["plane-takeoff"] = 95605407118637,
	play = 80104466227462,
	plug = 127012265988191,
	["plug-2"] = 75875872308134,
	["plug-zap"] = 101683967511440,
	plus = 118563428285930,
	pocket = 113239264323778,
	["pocket-knife"] = 103757792000836,
	podcast = 96567592813667,
	pointer = 103954952458474,
	["pointer-off"] = 77566412863428,
	popcorn = 124139605746210,
	popsicle = 102234286085590,
	["pound-sterling"] = 126999093165604,
	power = 139821907770093,
	["power-off"] = 91025506233520,
	presentation = 126156401836303,
	printer = 138626675452013,
	["printer-check"] = 75685462628514,
	projector = 82137422954163,
	proportions = 95735787905869,
	puzzle = 94036333231756,
	pyramid = 134832369326112,
	["qr-code"] = 115947204757344,
	quote = 102055887623346,
	rabbit = 131189288131840,
	radar = 77840020129555,
	radiation = 100120053411692,
	radical = 83794585544135,
	radio = 96448232078753,
	["radio-receiver"] = 115849531523249,
	["radio-tower"] = 123806688762520,
	radius = 121971099119676,
	["rail-symbol"] = 114970540339018,
	rainbow = 93078612490453,
	rat = 79141000137786,
	ratio = 74750864366592,
	receipt = 76330670769012,
	["receipt-cent"] = 131615440184048,
	["receipt-euro"] = 70850947232799,
	["receipt-indian-rupee"] = 84786980270142,
	["receipt-japanese-yen"] = 82207509366200,
	["receipt-pound-sterling"] = 71719348386314,
	["receipt-russian-ruble"] = 81492439455331,
	["receipt-swiss-franc"] = 79810601551246,
	["receipt-text"] = 88438942017408,
	["receipt-turkish-lira"] = 86570860820726,
	["rectangle-circle"] = 85507321361461,
	["rectangle-ellipsis"] = 127439030387481,
	["rectangle-goggles"] = 118679920384510,
	["rectangle-horizontal"] = 71430723037696,
	["rectangle-vertical"] = 72311863384941,
	recycle = 113191864541329,
	redo = 121875341327093,
	["redo-2"] = 138576248818175,
	["redo-dot"] = 117514482954867,
	["refresh-ccw"] = 86267075959666,
	["refresh-ccw-dot"] = 119023527726959,
	["refresh-cw"] = 76845925482586,
	["refresh-cw-off"] = 129981583943775,
	refrigerator = 86690334895832,
	regex = 79467153526782,
	["remove-formatting"] = 100639728039833,
	["repeat"] = 140407645345286,
	["repeat-1"] = 138579844223208,
	["repeat-2"] = 81045504832502,
	replace = 90341483418707,
	["replace-all"] = 76323102138169,
	reply = 138678897436694,
	["reply-all"] = 118380589053924,
	rewind = 124642191767611,
	ribbon = 79206292377631,
	rocket = 79846157539863,
	["rocking-chair"] = 135381220274271,
	["roller-coaster"] = 135317411701728,
	["rotate-3d"] = 136846515530149,
	["rotate-ccw"] = 103593823592882,
	["rotate-ccw-key"] = 72108307437441,
	["rotate-ccw-square"] = 102805428127392,
	["rotate-cw"] = 92926614772014,
	["rotate-cw-square"] = 94393061569190,
	route = 90844221445155,
	["route-off"] = 85315637775689,
	router = 130572058656931,
	["rows-2"] = 140376315766404,
	["rows-3"] = 70922215029935,
	["rows-4"] = 82310713996487,
	rss = 74657652878902,
	ruler = 81932543667472,
	["ruler-dimension-line"] = 116926583536145,
	["russian-ruble"] = 108882947390227,
	sailboat = 138278085859398,
	salad = 97083943538056,
	sandwich = 84512118570250,
	satellite = 90379425147438,
	["satellite-dish"] = 139162594956306,
	["saudi-riyal"] = 111230712493826,
	save = 126786081818943,
	["save-all"] = 132114356737462,
	["save-off"] = 103052152978546,
	scale = 119160471592362,
	["scale-3d"] = 93309101177595,
	scaling = 72422884764012,
	scan = 85082632913446,
	["scan-barcode"] = 71220109533744,
	["scan-eye"] = 97734789454128,
	["scan-face"] = 112627054869699,
	["scan-heart"] = 126892182652292,
	["scan-line"] = 125356770699594,
	["scan-qr-code"] = 129609805395670,
	["scan-search"] = 123647342231468,
	["scan-text"] = 82686374141174,
	school = 82511976287252,
	scissors = 73848300538397,
	["scissors-line-dashed"] = 102508082248814,
	["screen-share"] = 106412780353220,
	["screen-share-off"] = 101801998485496,
	scroll = 125776467998184,
	["scroll-text"] = 86918746287564,
	search = 125618569555993,
	["search-check"] = 102448639481709,
	["search-code"] = 107490113587580,
	["search-slash"] = 140195845290995,
	["search-x"] = 76625315572908,
	section = 132412965594548,
	send = 120131238507529,
	["send-horizontal"] = 127567207232610,
	["send-to-back"] = 105100147812939,
	["separator-horizontal"] = 136326354982755,
	["separator-vertical"] = 81032704114272,
	server = 72203285684743,
	["server-cog"] = 80743099902491,
	["server-crash"] = 104218894040999,
	["server-off"] = 95557390125060,
	settings = 101463883805422,
	["settings-2"] = 75339943202126,
	shapes = 94522066975471,
	share = 117401968838172,
	["share-2"] = 128552309636290,
	sheet = 124970301577850,
	shell = 126582315829979,
	shield = 84528813312016,
	["shield-alert"] = 92505396627173,
	["shield-ban"] = 102215491431686,
	["shield-check"] = 83449656859552,
	["shield-ellipsis"] = 93186850567552,
	["shield-half"] = 127055700945681,
	["shield-minus"] = 130374791120900,
	["shield-off"] = 132566117165802,
	["shield-plus"] = 83455402777739,
	["shield-question-mark"] = 128418825650056,
	["shield-user"] = 99618574383264,
	["shield-x"] = 89958978888777,
	ship = 119708468740563,
	["ship-wheel"] = 100264434901423,
	shirt = 100263550622526,
	["shopping-bag"] = 128835919419658,
	["shopping-basket"] = 139164114183615,
	["shopping-cart"] = 74658309187754,
	shovel = 93002580942748,
	["shower-head"] = 73619400343212,
	shredder = 138895317439043,
	shrimp = 116646646308539,
	shrink = 88836419137438,
	shrub = 76988369043032,
	shuffle = 119271040819486,
	sigma = 95577381168467,
	signal = 86317434523846,
	["signal-high"] = 71259263664875,
	["signal-low"] = 131288244120038,
	["signal-medium"] = 100328562267364,
	["signal-zero"] = 129038651813632,
	signature = 109457267964186,
	signpost = 72013144690387,
	["signpost-big"] = 101768854635202,
	siren = 135315463281920,
	["skip-back"] = 100366953633482,
	["skip-forward"] = 96350165788710,
	skull = 89401908547230,
	slack = 103734185902703,
	slash = 80289381134111,
	slice = 110909868827850,
	["sliders-horizontal"] = 104021219611587,
	["sliders-vertical"] = 105544572196049,
	smartphone = 109476896891915,
	["smartphone-charging"] = 94398441643045,
	["smartphone-nfc"] = 108057157032168,
	smile = 72681486741811,
	["smile-plus"] = 74596726382029,
	snail = 112699295253268,
	snowflake = 82505048791925,
	["soap-dispenser-droplet"] = 117335418112713,
	sofa = 80126963498533,
	soup = 104459318914683,
	space = 124217116768896,
	spade = 76967916150583,
	sparkle = 126477294768200,
	sparkles = 130602425201313,
	speaker = 138304808385322,
	speech = 137983960166079,
	["spell-check"] = 78243940332032,
	["spell-check-2"] = 95385653254823,
	spline = 128106773633629,
	["spline-pointer"] = 123280676328314,
	split = 112314002585584,
	spool = 109278157412120,
	spotlight = 87670272614404,
	["spray-can"] = 121630219787799,
	sprout = 116761478445060,
	square = 96489726265199,
	["square-activity"] = 140333051781567,
	["square-arrow-down"] = 107014673922005,
	["square-arrow-down-left"] = 124277460165719,
	["square-arrow-down-right"] = 73561771563744,
	["square-arrow-left"] = 140645828577303,
	["square-arrow-out-down-left"] = 89110471358870,
	["square-arrow-out-down-right"] = 79224964686159,
	["square-arrow-out-up-left"] = 139915836525364,
	["square-arrow-out-up-right"] = 75394510228384,
	["square-arrow-right"] = 137883327825941,
	["square-arrow-up"] = 86704051916529,
	["square-arrow-up-left"] = 72035481166850,
	["square-arrow-up-right"] = 103199082180609,
	["square-asterisk"] = 91331591548413,
	["square-bottom-dashed-scissors"] = 72833822818441,
	["square-chart-gantt"] = 118014434980199,
	["square-check"] = 131281718379727,
	["square-check-big"] = 93336092924352,
	["square-chevron-down"] = 131902770547285,
	["square-chevron-left"] = 127087352857648,
	["square-chevron-right"] = 83652669185775,
	["square-chevron-up"] = 72583133755831,
	["square-code"] = 124986136764997,
	["square-dashed"] = 79183888005672,
	["square-dashed-bottom"] = 89157701577789,
	["square-dashed-bottom-code"] = 116292194698799,
	["square-dashed-kanban"] = 121007350604616,
	["square-dashed-mouse-pointer"] = 130924289391684,
	["square-dashed-top-solid"] = 124416825207572,
	["square-divide"] = 137218625315282,
	["square-dot"] = 117976103587060,
	["square-equal"] = 121507447179718,
	["square-function"] = 86203774968018,
	["square-kanban"] = 93286950307565,
	["square-library"] = 117062543132766,
	["square-m"] = 115722178058159,
	["square-menu"] = 81614384000771,
	["square-minus"] = 71839009603427,
	["square-mouse-pointer"] = 93614884809738,
	["square-parking"] = 129799277887252,
	["square-parking-off"] = 73561529934834,
	["square-pause"] = 126984552711307,
	["square-pen"] = 94523918453624,
	["square-percent"] = 127625721826020,
	["square-pi"] = 110661345713027,
	["square-pilcrow"] = 79387020279550,
	["square-play"] = 109792454183012,
	["square-plus"] = 73228825720276,
	["square-power"] = 110236577492349,
	["square-radical"] = 138382976817926,
	["square-round-corner"] = 117707560364355,
	["square-scissors"] = 75179246281400,
	["square-sigma"] = 131506090287142,
	["square-slash"] = 112196704068674,
	["square-split-horizontal"] = 97627785389902,
	["square-split-vertical"] = 106959144758418,
	["square-square"] = 80835095859324,
	["square-stack"] = 124304690179249,
	["square-star"] = 115056433115255,
	["square-stop"] = 111768891575856,
	["square-terminal"] = 93337999108432,
	["square-user"] = 72248743154708,
	["square-user-round"] = 135580858593151,
	["square-x"] = 107073482662073,
	["squares-exclude"] = 73691835285197,
	["squares-intersect"] = 96924928301087,
	["squares-subtract"] = 87554296790348,
	["squares-unite"] = 122198623051662,
	squircle = 82987060321691,
	["squircle-dashed"] = 118443285499033,
	squirrel = 73560557505029,
	stamp = 121319474186232,
	star = 127746172798481,
	["star-half"] = 131968454447228,
	["star-off"] = 72177495447859,
	["step-back"] = 85492554496339,
	["step-forward"] = 113928948415823,
	stethoscope = 105982582717298,
	sticker = 127276314334483,
	["sticky-note"] = 112097020099499,
	store = 133824185120097,
	["stretch-horizontal"] = 132144609663362,
	["stretch-vertical"] = 75386274307446,
	strikethrough = 83947301832572,
	subscript = 113391516050262,
	sun = 79901529465096,
	["sun-dim"] = 104619182730276,
	["sun-medium"] = 91618371923097,
	["sun-moon"] = 79929011380037,
	["sun-snow"] = 137414435824708,
	sunrise = 135585238325032,
	sunset = 73712698016360,
	superscript = 72669097231454,
	["swatch-book"] = 128454451162104,
	["swiss-franc"] = 136694453759982,
	["switch-camera"] = 140606464585502,
	sword = 75020726675544,
	swords = 89815227241465,
	syringe = 78733573607159,
	table = 86743029152675,
	["table-2"] = 124462232337013,
	["table-cells-merge"] = 103787916007071,
	["table-cells-split"] = 137584996978518,
	["table-columns-split"] = 112532547114237,
	["table-of-contents"] = 123289010637455,
	["table-properties"] = 106533508299112,
	["table-rows-split"] = 80913015124376,
	tablet = 98236546892857,
	["tablet-smartphone"] = 82512006965851,
	tablets = 118977326005264,
	tag = 103234399652910,
	tags = 102666304482309,
	["tally-1"] = 110936672654832,
	["tally-2"] = 94187147342756,
	["tally-3"] = 124913781937253,
	["tally-4"] = 92590022818947,
	["tally-5"] = 138114201809681,
	tangent = 115243287449073,
	target = 81035867308138,
	telescope = 111810481539512,
	tent = 135834669198083,
	["tent-tree"] = 78356729712249,
	terminal = 73413798937791,
	["test-tube"] = 108565640789121,
	["test-tube-diagonal"] = 111814426284329,
	["test-tubes"] = 84207634752507,
	text = 92542971051973,
	["text-cursor"] = 71303185547080,
	["text-cursor-input"] = 81578218115202,
	["text-quote"] = 103419429142075,
	["text-search"] = 119231709110976,
	["text-select"] = 107531686199786,
	theater = 83268813741529,
	thermometer = 105535887519165,
	["thermometer-snowflake"] = 129660993200918,
	["thermometer-sun"] = 72570194548829,
	["thumbs-down"] = 105602592815443,
	["thumbs-up"] = 72411375022432,
	ticket = 104336783939037,
	["ticket-check"] = 125662376066034,
	["ticket-minus"] = 125106761208017,
	["ticket-percent"] = 73387393631130,
	["ticket-plus"] = 91987299109025,
	["ticket-slash"] = 88947231854573,
	["ticket-x"] = 120285559163949,
	tickets = 128293616470608,
	["tickets-plane"] = 110636990485048,
	timer = 96119720980390,
	["timer-off"] = 73592886882763,
	["timer-reset"] = 115263131999748,
	["toggle-left"] = 126278872210073,
	["toggle-right"] = 135316241551499,
	toilet = 82858381666593,
	["tool-case"] = 133216548079593,
	tornado = 119132390241284,
	torus = 135140424211153,
	touchpad = 111708702894486,
	["touchpad-off"] = 111996914034893,
	["tower-control"] = 132285132951711,
	["toy-brick"] = 91649902772315,
	tractor = 97620732372191,
	["traffic-cone"] = 139621281679882,
	["train-front"] = 98677382842804,
	["train-front-tunnel"] = 114866528676443,
	["train-track"] = 120194201330757,
	["tram-front"] = 91307750164226,
	transgender = 111481765827654,
	trash = 116863849368916,
	["trash-2"] = 79564839810840,
	["tree-deciduous"] = 131205325166458,
	["tree-palm"] = 128164120447244,
	["tree-pine"] = 90774792597002,
	trees = 98571299046731,
	trello = 107898356259657,
	["trending-down"] = 117917602459815,
	["trending-up"] = 116886197130999,
	["trending-up-down"] = 103717610858616,
	triangle = 107100599170044,
	["triangle-alert"] = 76712741040235,
	["triangle-dashed"] = 84136951328014,
	["triangle-right"] = 97661263578338,
	trophy = 99468111768746,
	truck = 102380610139245,
	["truck-electric"] = 107501288276081,
	["turkish-lira"] = 98366519784263,
	turntable = 129425246442560,
	turtle = 124788802294981,
	tv = 91976706623107,
	["tv-minimal"] = 102675516773869,
	["tv-minimal-play"] = 133814752541561,
	twitch = 78418686039425,
	type = 123010942632689,
	["type-outline"] = 75596975306451,
	umbrella = 130176200284323,
	["umbrella-off"] = 123696654720209,
	underline = 86005310176484,
	undo = 98677000788509,
	["undo-2"] = 123288184651876,
	["undo-dot"] = 97048183118444,
	["unfold-horizontal"] = 102321820508665,
	["unfold-vertical"] = 110395906345252,
	ungroup = 116761886838866,
	university = 105398737245802,
	unlink = 114774779025598,
	["unlink-2"] = 84980216310960,
	unplug = 71213047838603,
	upload = 84448595764921,
	usb = 122244624865802,
	user = 81899856845503,
	["user-check"] = 124183127537182,
	["user-cog"] = 132530394308182,
	["user-lock"] = 102304427888373,
	["user-minus"] = 139212780407738,
	["user-pen"] = 109063575712204,
	["user-plus"] = 73169931625061,
	["user-round"] = 122472562648438,
	["user-round-check"] = 116820685971606,
	["user-round-cog"] = 81932262543896,
	["user-round-minus"] = 131104410574220,
	["user-round-pen"] = 88582957358214,
	["user-round-plus"] = 72756692986447,
	["user-round-search"] = 121920726195803,
	["user-round-x"] = 133496165281802,
	["user-search"] = 91526614931270,
	["user-star"] = 104674549336879,
	["user-x"] = 83017534068566,
	users = 109023655602096,
	["users-round"] = 73720692207232,
	utensils = 92328553872866,
	["utensils-crossed"] = 115379488607669,
	["utility-pole"] = 78544397723455,
	variable = 108495567404232,
	vault = 125730392773824,
	["vector-square"] = 120085753224630,
	vegan = 133693714976186,
	["venetian-mask"] = 73997918289433,
	venus = 77091339518872,
	["venus-and-mars"] = 85333806376716,
	vibrate = 94421703759873,
	["vibrate-off"] = 104055297186916,
	video = 120899025417114,
	["video-off"] = 98571437579498,
	videotape = 110595652490996,
	view = 96170375252355,
	voicemail = 129863571214632,
	volleyball = 79983513397509,
	volume = 136944486138432,
	["volume-1"] = 76450166585050,
	["volume-2"] = 127590428470553,
	["volume-off"] = 76437794585400,
	["volume-x"] = 102557100794756,
	vote = 111127508049086,
	wallet = 82693664006746,
	["wallet-cards"] = 131093307699863,
	["wallet-minimal"] = 104760648200766,
	wallpaper = 127531571966115,
	wand = 100247093544676,
	["wand-sparkles"] = 109636225248973,
	warehouse = 117043792208242,
	["washing-machine"] = 124299191442908,
	watch = 96632122742030,
	waves = 132537108109414,
	["waves-ladder"] = 130770635115623,
	waypoints = 89579429286632,
	webcam = 99543028331067,
	webhook = 127494549649286,
	["webhook-off"] = 94143246779298,
	weight = 70452176653194,
	wheat = 72827060603331,
	["wheat-off"] = 133950070398243,
	["whole-word"] = 83053413552620,
	wifi = 101360393607039,
	["wifi-cog"] = 86268760919032,
	["wifi-high"] = 139565602232260,
	["wifi-low"] = 129432377919005,
	["wifi-off"] = 128431848377922,
	["wifi-pen"] = 109435800293522,
	["wifi-sync"] = 134593311559828,
	["wifi-zero"] = 132143289837251,
	wind = 73952787381292,
	["wind-arrow-down"] = 107113727390188,
	workflow = 125401528378697,
	worm = 110566866003503,
	["wrap-text"] = 118921109568806,
	wrench = 108764185264619,
	x = 73070135088117,
	youtube = 100529433894693,
	zap = 99546940565021,
	["zap-off"] = 112636243101847,
	["zoom-in"] = 132256802524814,
	["zoom-out"] = 109610457179810,
	["beer-off"] = 138037951949066,
	["beer"] = 120586510698080,
	["bottle-wine"] = 93707442058849,
	["cannabis"] = 130136923421319,
	["chart-network"] = 116749958806877,
	["cigarrete-off"] = 85361164732665,
	["cigarette"] = 78543658965377,
	["indian-rupee"] = 139912038918762,
	["twitter"] = 83698772731875,
	["wine-off"] = 128440413658301,
	["wine"] = 73532622126175,
}
end)()
return { Icons = assets, GetAsset = function(name)
    local id = assets[name]
    if not id then return nil end
    return { Url = "rbxassetid://" .. id, Id = id, IconName = name, ImageRectOffset = Vector2.zero, ImageRectSize = Vector2.zero }
end }
end)()

function Library:GetIcon(IconName: string)
    if not FetchIcons then
        return
    end

    local Success, Icon = pcall(Icons.GetAsset, IconName)
    if not Success then
        return
    end

    return Icon
end

function Library:GetCustomIcon(IconName: string): any
    if not IconName then
        return nil
    end

    if tonumber(IconName) then
        IconName = string.format("rbxassetid://%s", tostring(IconName))
    end

    if IsCustomAssetIcon(IconName, true) then
        return {
            Url = IconName,
            ImageRectOffset = Vector2.zero,
            ImageRectSize = Vector2.zero,
        }
    elseif IsValidCustomIcon(IconName) then
        return {
            Url = IconName,
            ImageRectOffset = Vector2.zero,
            ImageRectSize = Vector2.zero,
            Custom = true,
        }
    end

    local LucideIcon = Library:GetIcon(IconName)
    if LucideIcon then
        return LucideIcon
    end

    return nil
end

function Library:Validate(Table: { [string]: any }, Template: { [string]: any }): { [string]: any }
    local Validated = {}
    if typeof(Table) == "table" then
        for Key, Value in Table do
            Validated[Key] = Value
        end
    end

    for k, v in Template do
        if typeof(k) == "number" then
            continue
        end

        if typeof(v) == "table" then
            if typeof(Validated[k]) == "table" then
                Validated[k] = Library:Validate(Validated[k], v)
            elseif Validated[k] == nil then
                Validated[k] = DeepClone(v)
            end
        elseif Validated[k] == nil then
            Validated[k] = v
        end
    end

    return Validated
end

--// Creator Functions \\--
local function FillInstance(Table: { [string]: any }, Instance: GuiObject)
    local ThemeProperties = Library.Registry[Instance] or {}

    for key, value in Table do
        if key ~= "Text" then
            local SchemeValue = GetSchemeValue(value)

            if SchemeValue or typeof(value) == "function" then
                ThemeProperties[key] = value
                value = SchemeValue or value()
            else
                ThemeProperties[key] = nil
            end
        end

        Instance[key] = value
    end

    if GetTableSize(ThemeProperties) > 0 then
        Library.Registry[Instance] = ThemeProperties
    end
end

local function New(ClassName: string, Properties: { [string]: any }): any
    local Instance = Instance.new(ClassName)

    if Templates[ClassName] then
        FillInstance(Templates[ClassName], Instance)
    end
    FillInstance(Properties, Instance)

    if Properties["Parent"] and not Properties["ZIndex"] then
        pcall(function()
            Instance.ZIndex = Properties.Parent.ZIndex
        end)
    end

    return Instance
end

local function TrackCornerMode(UICorner, Mode)
    Library.CornerModes[UICorner] = Mode
    return UICorner
end

--// Main Instances \\-
local function SafeParentUI(Instance: Instance, Parent: Instance | () -> Instance)
    local success, _error = pcall(function()
        if not Parent then
            Parent = CoreGui
        end

        local DestinationParent
        if typeof(Parent) == "function" then
            DestinationParent = Parent()
        else
            DestinationParent = Parent
        end

        Instance.Parent = DestinationParent
    end)

    if not (success and Instance.Parent) then
        Instance.Parent = Library.LocalPlayer:WaitForChild("PlayerGui", math.huge)
    end
end

local function ParentUI(UI: Instance, SkipHiddenUI: boolean?)
    if SkipHiddenUI then
        SafeParentUI(UI, CoreGui)
        return
    end

    pcall(protectgui, UI)
    SafeParentUI(UI, gethui)
end

local ScreenGui = New("ScreenGui", {
    Name = "Obsidian",
    DisplayOrder = 999,
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Global,
})
ParentUI(ScreenGui)
Library.ScreenGui = ScreenGui

ScreenGui.DescendantRemoving:Connect(function(Instance)
    Library:RemoveFromRegistry(Instance)
end)

local ModalElement = New("TextButton", {
    BackgroundTransparency = 1,
    Modal = false,
    Size = UDim2.fromScale(0, 0),
    AnchorPoint = Vector2.zero,
    Text = "",
    ZIndex = -999,
    Parent = ScreenGui,
})

--// Cursor
local Cursor, CursorCustomImage
do
    Cursor = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = "WhiteColor",
        Size = UDim2.fromOffset(9, 1),
        Visible = false,
        ZIndex = 11000,
        Parent = ScreenGui,
    })
    New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = "DarkColor",
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, 2, 1, 2),
        ZIndex = 10999,
        Parent = Cursor,
    })

    local CursorV = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = "WhiteColor",
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(1, 9),
        ZIndex = 11000,
        Parent = Cursor,
    })
    New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = "DarkColor",
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, 2, 1, 2),
        ZIndex = 10999,
        Parent = CursorV,
    })

    CursorCustomImage = New("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(20, 20),
        ZIndex = 11000,
        Visible = false,
        Parent = Cursor
    })
end

--// Notification \\--
local NotificationArea
local NotifyOrder = {}
do
    NotificationArea = New("Frame", {
        AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -6, 0, 6),
        Size = UDim2.new(0, 300, 1, -6),
        Parent = ScreenGui,
    })
    table.insert(
        Library.Scales,
        New("UIScale", {
            Parent = NotificationArea,
        })
    )
end

--// Lib Functions \\--
function Library:ResetCursorIcon()
    CursorCustomImage.Visible = false
    CursorCustomImage.Size = UDim2.fromOffset(20, 20)
end

function Library:ChangeCursorIcon(ImageId: string)
    if not ImageId or ImageId == "" then
        Library:ResetCursorIcon()
        return
    end

    local Icon = Library:GetCustomIcon(ImageId)
    assert(Icon, "Image must be a valid Roblox asset or a valid URL or a valid lucide icon.")

    CursorCustomImage.Visible = true
    CursorCustomImage.Image = Icon.Url
    CursorCustomImage.ImageRectOffset = Icon.ImageRectOffset
    CursorCustomImage.ImageRectSize = Icon.ImageRectSize
end

function Library:ChangeCursorIconSize(Size: UDim2)
    assert(typeof(Size) == "UDim2", "UDim2 expected.")
    CursorCustomImage.Size = Size
end

function Library:GetBetterColor(Color: Color3, Add: number): Color3
    Add = Add * (Library.IsLightTheme and -4 or 2)
    return Color3.fromRGB(
        math.clamp(Color.R * 255 + Add, 0, 255),
        math.clamp(Color.G * 255 + Add, 0, 255),
        math.clamp(Color.B * 255 + Add, 0, 255)
    )
end

function Library:GetLighterColor(Color: Color3): Color3
    local H, S, V = Color:ToHSV()
    return Color3.fromHSV(H, math.max(0, S - 0.1), math.min(1, V + 0.1))
end

function Library:GetDarkerColor(Color: Color3): Color3
    local H, S, V = Color:ToHSV()
    return Color3.fromHSV(H, S, V / 2)
end

function Library:GetKeyString(KeyCode: Enum.KeyCode)
    if KeyCode.EnumType == Enum.KeyCode and KeyCode.Value > 33 and KeyCode.Value < 127 then
        return string.char(KeyCode.Value)
    end

    return KeyCode.Name
end

function Library:GetTextBounds(Text: string, Font: Font, Size: number, Width: number?): (number, number)
    local Params = Instance.new("GetTextBoundsParams")
    Params.Text = Text
    Params.RichText = true
    Params.Font = Font
    Params.Size = Size
    Params.Width = Width or workspace.CurrentCamera.ViewportSize.X - 32

    local Bounds = TextService:GetTextBoundsAsync(Params)
    return Bounds.X, Bounds.Y
end

function Library:MouseIsOverFrame(Frame: GuiObject, Mouse: Vector2): boolean
    local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize
    return Mouse.X >= AbsPos.X
        and Mouse.X <= AbsPos.X + AbsSize.X
        and Mouse.Y >= AbsPos.Y
        and Mouse.Y <= AbsPos.Y + AbsSize.Y
end

function Library:IsInsideFrame(ParentFrame: GuiObject, Frame: GuiObject)
    local GuiPos = Frame.AbsolutePosition
	local GuiSize = Frame.AbsoluteSize

	local FramePos = ParentFrame.AbsolutePosition
	local FrameSize = ParentFrame.AbsoluteSize

	return GuiPos.X >= FramePos.X
		and GuiPos.X + GuiSize.X <= FramePos.X + FrameSize.X
		and GuiPos.Y >= FramePos.Y
		and GuiPos.Y + GuiSize.Y <= FramePos.Y + FrameSize.Y
end

function Library:SafeCallback(Func: (...any) -> ...any, ...: any)
    if not (Func and typeof(Func) == "function") then
        return
    end

    local Result = table.pack(xpcall(Func, function(Error)
        task.defer(error, debug.traceback(Error, 2))
        if Library.NotifyOnError and Library.Notify then
            Library:Notify({
                Title = "Error",
                Description = Error,
                Time = 10,
                Icon = "circle-x",
            })
        end

        return Error
    end, ...))

    if not Result[1] then
        return nil
    end

    return table.unpack(Result, 2, Result.n)
end

function GetOverlappingDraggable(UI: GuiObject, TargetPos: Vector2?)
    local Pos1 = TargetPos or UI.AbsolutePosition
    local Size1 = UI.AbsoluteSize
    
    for _, Other in ipairs(Library.DraggableElements) do
        if Other == UI or not Other.Visible or not Other.Parent then
            continue
        end

        local Pos2 = Other.AbsolutePosition
        local Size2 = Other.AbsoluteSize
        
        if Pos1.X < Pos2.X + Size2.X and
            Pos1.X + Size1.X > Pos2.X and
            Pos1.Y < Pos2.Y + Size2.Y and
            Pos1.Y + Size1.Y > Pos2.Y then
            return Other
        end
    end
    
    return nil
end

function GetNonOverlappingPosition(UI: GuiObject, StartPos: UDim2?)
    local ScreenSize = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)) - Vector2.new(100, 100)
    local Start = StartPos and Vector2.new(StartPos.X.Offset, StartPos.Y.Offset) or Vector2.new(6, 6)
    local Padding = 6
    
    local CurrentX = Start.X
    local CurrentY = Start.Y
    
    local Size = UI.AbsoluteSize
    if Size.X == 0 and Size.Y == 0 then
        RunService.RenderStepped:Wait()
        Size = UI.AbsoluteSize
    end
    
    if Size.X == 0 then Size = Vector2.new(150, 40) end

    local MaxXInColumn = Size.X

    while true do
        local Obstacle = GetOverlappingDraggable(UI, Vector2.new(CurrentX, CurrentY))
        if not Obstacle then
            break
        end
        
        if Obstacle.AbsoluteSize.X > MaxXInColumn then
            MaxXInColumn = Obstacle.AbsoluteSize.X
        end
        
        local NextY = Obstacle.AbsolutePosition.Y + Obstacle.AbsoluteSize.Y + Padding
        if NextY + Size.Y > ScreenSize.Y - Padding then
            local NextX = CurrentX + MaxXInColumn + Padding
            
            if NextX + Size.X > ScreenSize.X - Padding then
                break
            end
            
            CurrentY = Start.Y
            CurrentX = NextX
            MaxXInColumn = Size.X
        else
            CurrentY = NextY
        end
    end
    
    return UDim2.fromOffset(CurrentX, CurrentY)
end

function PositionDraggable(UI: GuiObject, StartPos: UDim2?)
    UI.Position = GetNonOverlappingPosition(UI, StartPos)
end

function Library:MakeDraggable(UI: GuiObject, DragFrame: GuiObject, IgnoreToggled: boolean?, IsMainWindow: boolean?)
    local StartPos
    local FramePos
    local Dragging = false
    local Changed
    local InputBegan
    local InputChanged

    InputBegan = DragFrame.InputBegan:Connect(function(Input: InputObject)
        if not IsClickInput(Input) or IsMainWindow and Library.CantDragForced then
            return
        end

        StartPos = Input.Position
        FramePos = UI.Position
        Dragging = true

        Changed = Input.Changed:Connect(function()
            if Input.UserInputState ~= Enum.UserInputState.End then
                return
            end

            Dragging = false
            if Changed and Changed.Connected then
                Changed:Disconnect()
                Changed = nil
            end
        end)
    end)

    InputChanged = UserInputService.InputChanged:Connect(function(Input: InputObject)
        if
            (not IgnoreToggled and not Library.Toggled)
            or (IsMainWindow and Library.CantDragForced)
            or not (ScreenGui and ScreenGui.Parent)
        then
            Dragging = false
            if Changed and Changed.Connected then
                Changed:Disconnect()
                Changed = nil
            end

            return
        end

        if Dragging and IsHoverInput(Input) then
            local Delta = Input.Position - StartPos
            UI.Position =
                UDim2.new(FramePos.X.Scale, FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)
        end
    end)

    Library:GiveSignal(InputChanged)
    Library:GiveSignal(InputBegan)
    
    UI.Destroying:Once(function()
        if InputChanged and InputChanged.Connected then
            InputChanged:Disconnect()
        end

        if InputBegan and InputBegan.Connected then
            InputBegan:Disconnect()
        end

        if Changed and Changed.Connected then
            Changed:Disconnect()
        end

        local IdxChanged = table.find(Library.Signals, InputChanged)
        if IdxChanged then
            table.remove(Library.Signals, IdxChanged)
        end

        local IdxBegan = table.find(Library.Signals, InputBegan)
        if IdxBegan then
            table.remove(Library.Signals, IdxBegan)
        end
    end)
end

function Library:MakeResizable(UI: GuiObject, DragFrame: GuiObject, Callback: () -> ()?)
    local StartPos
    local FrameSize
    local Dragging = false
    local Changed
    local InputBegan
    local InputChanged

    InputBegan = DragFrame.InputBegan:Connect(function(Input: InputObject)
        if not IsClickInput(Input) then
            return
        end

        StartPos = Input.Position
        FrameSize = UI.Size
        Dragging = true

        Changed = Input.Changed:Connect(function()
            if Input.UserInputState ~= Enum.UserInputState.End then
                return
            end

            Dragging = false
            if Changed and Changed.Connected then
                Changed:Disconnect()
                Changed = nil
            end
        end)
    end)

    InputChanged = UserInputService.InputChanged:Connect(function(Input: InputObject)
        if not UI.Visible or not (ScreenGui and ScreenGui.Parent) then
            Dragging = false
            if Changed and Changed.Connected then
                Changed:Disconnect()
                Changed = nil
            end

            return
        end

        if Dragging and IsHoverInput(Input) then
            local Delta = Input.Position - StartPos
            UI.Size = UDim2.new(
                FrameSize.X.Scale,
                math.clamp(FrameSize.X.Offset + Delta.X, Library.MinSize.X, math.huge),
                FrameSize.Y.Scale,
                math.clamp(FrameSize.Y.Offset + Delta.Y, Library.MinSize.Y, math.huge)
            )
            if Callback then
                Library:SafeCallback(Callback)
            end
        end
    end)

    Library:GiveSignal(InputChanged)
    Library:GiveSignal(InputBegan)

    UI.Destroying:Once(function()
        if InputChanged and InputChanged.Connected then
            InputChanged:Disconnect()
        end

        if InputBegan and InputBegan.Connected then
            InputBegan:Disconnect()
        end

        if Changed and Changed.Connected then
            Changed:Disconnect()
        end

        local IdxChanged = table.find(Library.Signals, InputChanged)
        if IdxChanged then
            table.remove(Library.Signals, IdxChanged)
        end

        local IdxBegan = table.find(Library.Signals, InputBegan)
        if IdxBegan then
            table.remove(Library.Signals, IdxBegan)
        end
    end)
end

function Library:MakeCover(Holder: GuiObject, Place: string)
    local Pos = Places[Place] or { 0, 0 }
    local Size = Sizes[Place] or { 1, 0.5 }

    local Cover = New("Frame", {
        AnchorPoint = Vector2.new(Pos[1], Pos[2]),
        BackgroundColor3 = Holder.BackgroundColor3,
        Position = UDim2.fromScale(Pos[1], Pos[2]),
        Size = UDim2.fromScale(Size[1], Size[2]),
        Parent = Holder,
    })

    return Cover
end

function Library:MakeLine(Frame: GuiObject, Info)
    local Line = New("Frame", {
        AnchorPoint = Info.AnchorPoint or Vector2.zero,
        BackgroundColor3 = "OutlineColor",
        Position = Info.Position,
        Size = Info.Size,
        ZIndex = Info.ZIndex or Frame.ZIndex,
        Parent = Frame,
    })

    return Line
end

function Library:AddOutline(Frame: GuiObject)
    local OutlineStroke = New("UIStroke", {
        Color = "OutlineColor",
        Thickness = 1,
        Transparency = 0.12,
        ZIndex = 2,
        Parent = Frame,
    })
    local ShadowStroke = New("UIStroke", {
        Color = "DarkColor",
        Thickness = 1,
        Transparency = 0.62,
        ZIndex = 1,
        Parent = Frame,
    })
    return OutlineStroke, ShadowStroke
end

function Library:AddBlank(Frame: GuiObject, Size: UDim2)
    return New("Frame", {
        BackgroundTransparency = 1,
        Size = Size or UDim2.fromScale(0, 0),
        Parent = Frame,
    })
end

--// Animations \\--
local TransparencyCache = {}
local ActiveTabTweens = setmetatable({}, { __mode = "k" })

function Library:PlayTabAnimation(TabCanvas: CanvasGroup, Showing: boolean, OnComplete: (() -> ())?)
    if not TabCanvas then
        if OnComplete then
            OnComplete()
        end

        return
    end

    local Existing = ActiveTabTweens[TabCanvas]
    if Existing then
        StopTween(Existing, true)
        ActiveTabTweens[TabCanvas] = nil
    end

    local BaseZIndex = TabCanvas.ZIndex
    if not (Library.Animations and Library.Animations.TabSwitch) then
        TabCanvas.Visible = Showing
        TabCanvas.GroupTransparency = Showing and 0 or 1
        TabCanvas.Position = UDim2.fromScale(0, 0)
        TabCanvas.ZIndex = BaseZIndex

        if OnComplete then
            OnComplete()
        end

        return
    end

    if Showing then
        local TweenInfo = Library.TabTransitionInfo or TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local Offset = Library.TabSwipeOffset or 26
        local SwipeFrom = string.lower(Library.TabSwipeFrom or "bottom")
        local StartPosition

        if SwipeFrom == "left" then
            StartPosition = UDim2.fromOffset(-Offset, 0)
        elseif SwipeFrom == "top" then
            StartPosition = UDim2.fromOffset(0, -Offset)
        elseif SwipeFrom == "right" then
            StartPosition = UDim2.fromOffset(Offset, 0)
        else -- bottom (Default)
            StartPosition = UDim2.fromOffset(0, Offset)
        end

        TabCanvas.ZIndex = BaseZIndex + 1
        TabCanvas.GroupTransparency = 1
        TabCanvas.Position = StartPosition
        TabCanvas.Visible = true

        local Tween = TweenService:Create(TabCanvas, TweenInfo, {
            GroupTransparency = 0,
            Position = UDim2.fromScale(0, 0)
        })

        ActiveTabTweens[TabCanvas] = Tween
        Tween:Play()

        local Connection; Connection = Tween.Completed:Connect(function(PlaybackState)
            if Connection then
                Connection:Disconnect()
            end

            if ActiveTabTweens[TabCanvas] == Tween then
                ActiveTabTweens[TabCanvas] = nil
            end

            if PlaybackState == Enum.PlaybackState.Cancelled then
                return
            end

            TabCanvas.ZIndex = BaseZIndex
            if OnComplete then
                OnComplete()
            end
        end)
    else
        TabCanvas.GroupTransparency = 1
        TabCanvas.Visible = false
        TabCanvas.Position = UDim2.fromScale(0, 0)
        TabCanvas.ZIndex = BaseZIndex

        if OnComplete then
            OnComplete()
        end
    end
end

--// Deprecated \\--
function Library:MakeOutline(Frame: GuiObject, Corner: number?, ZIndex: number?)
    warn("Obsidian:MakeOutline is deprecated, please use Obsidian:AddOutline instead.")
    local Holder = New("Frame", {
        BackgroundColor3 = "DarkColor",
        Position = UDim2.fromOffset(-2, -2),
        Size = UDim2.new(1, 4, 1, 4),
        ZIndex = ZIndex,
        Parent = Frame,
    })

    local Outline = New("Frame", {
        BackgroundColor3 = "OutlineColor",
        Position = UDim2.fromOffset(1, 1),
        Size = UDim2.new(1, -2, 1, -2),
        ZIndex = ZIndex,
        Parent = Holder,
    })

    if Corner and Corner > 0 then
        New("UICorner", {
            CornerRadius = UDim.new(0, Corner + 1),
            Parent = Holder,
        })
        New("UICorner", {
            CornerRadius = UDim.new(0, Corner),
            Parent = Outline,
        })
    end

    return Holder, Outline
end

function Library:AddDraggableLabel(...)
    local Params = select(1, ...)
    local Text
    local Icon
    local IconPosition = "left"

    if typeof(Params) == "table" then
        Text = Params.Text
        Icon = Params.Icon
        IconPosition = Params.IconPosition or "left"
    elseif typeof(Params) == "string" then
        Text = Params
        Icon = select(2, ...)
        IconPosition = select(3, ...) or "left"
    end

    if typeof(IconPosition) ~= "string" then
        IconPosition = "left"
    end

    IconPosition = string.lower(IconPosition)
    assert(IconPosition == "left" or IconPosition == "right", "Icon Position needs to be either 'left' or 'right'.")

    local DraggableLabel = {
        Connections = {},
        Destroyed = false
    }

    local IconImage
    local Label = New("TextLabel", {
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundColor3 = "BackgroundColor",
        Size = UDim2.fromOffset(0, 0),
        Position = UDim2.fromOffset(6, 6),
        Text = Text,
        TextSize = 15,
        ZIndex = 10,
        Parent = ScreenGui,
    })

    table.insert(
        Library.Corners, 
        New("UICorner", {
            CornerRadius = UDim.new(0, Library.CornerRadius),
            Parent = Label,
        })
    )

    local Padding = New("UIPadding", {
        PaddingBottom = UDim.new(0, 6),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        PaddingTop = UDim.new(0, 6),
        Parent = Label,
    })
    table.insert(
        Library.Scales,
        New("UIScale", {
            Parent = Label,
        })
    )

    Library:AddOutline(Label)
    Library:MakeDraggable(Label, Label, true)

    function DraggableLabel:SetText(Text: string)
        Label.Text = Text
    end

    function DraggableLabel:SetIcon(NewIcon: string)
        Icon = NewIcon

        local IsNotEmpty = Icon and Trim(tostring(Icon)) ~= ""
        if IsNotEmpty then
            local CustomIcon = Library:GetCustomIcon(Icon)
            assert(CustomIcon, "Icon must be a valid Roblox asset or a valid URL or a valid lucide icon.")

            IconImage = IconImage or New("ImageLabel", {
                BackgroundTransparency = 1,
                ImageColor3 = "FontColor",
                Size = UDim2.fromOffset(16, 16),
                ZIndex = 11,
                Parent = Label,
            })

            IconImage.Image = CustomIcon.Url
            IconImage.ImageRectOffset = CustomIcon.ImageRectOffset
            IconImage.ImageRectSize = CustomIcon.ImageRectSize
        end

        if IconImage then IconImage.Visible = IsNotEmpty end
        DraggableLabel:SetIconPosition(IconPosition)
    end

    function DraggableLabel:SetIconPosition(NewPosition: string)
        IconPosition = string.lower(NewPosition)
        assert(IconPosition == "left" or IconPosition == "right", "Icon Position needs to be either 'left' or 'right'.")

        local IsNotEmpty = Icon and Trim(tostring(Icon)) ~= ""
        Padding.PaddingLeft = UDim.new(0, (IsNotEmpty and IconPosition == "left") and 34 or 12)
        Padding.PaddingRight = UDim.new(0, (IsNotEmpty and IconPosition == "right") and 34 or 12)

        if IconImage then
            if IconPosition == "left" then
                IconImage.AnchorPoint = Vector2.new(0, 0.5)
                IconImage.Position = UDim2.new(0, -22, 0.5, 0)
            else
                IconImage.AnchorPoint = Vector2.new(1, 0.5)
                IconImage.Position = UDim2.new(1, 22, 0.5, 0)
            end
        end
    end

    function DraggableLabel:SetVisible(Visible: boolean)
        Label.Visible = Visible
    end
    
    DraggableLabel:SetIcon(Icon)
    DraggableLabel.Label = Label

    if not table.find(Library.DraggableElements, Label) then
        table.insert(Library.DraggableElements, Label)
    end

    PositionDraggable(Label, Label.Position)

    function DraggableLabel:Destroy()
        if DraggableLabel.Destroyed then
            return
        end
        DraggableLabel.Destroyed = true

        if DraggableLabel.Connections then
            for _, connection in DraggableLabel.Connections do
                connection:Disconnect()
            end
        end

        local ElemIdx = table.find(Library.DraggableElements, Label)
        if ElemIdx then
            table.remove(Library.DraggableElements, ElemIdx)
        end

        if Label then
            Label:Destroy()
        end
    end

    return DraggableLabel
end

function Library:AddDraggableButton(...)
    local Params = select(1, ...)

    local Text
    local Func
    local ExcludeScaling
    local ExcludeDragging

    if typeof(Params) == "table" then
        Text = Params.Text
        Func = Params.Callback or Params.Func
        ExcludeScaling = Params.ExcludeScaling
        ExcludeDragging = Params.ExcludeDragging
    elseif typeof(Params) == "string" then
        Text = Params
        Func = select(2, ...)
        ExcludeScaling = select(3, ...)
        ExcludeDragging = select(4, ...)
    end

    local DraggableButton = {
        Connections = {},
        Destroyed = false
    }

    local Button = New("TextButton", {
        BackgroundColor3 = "BackgroundColor",
        Position = UDim2.fromOffset(6, 6),
        TextSize = 16,
        ZIndex = 10,
        Parent = ScreenGui,
    })
    table.insert(
        Library.Corners, 
        New("UICorner", {
            CornerRadius = UDim.new(0, Library.CornerRadius),
            Parent = Button,
        })
    )
    if not ExcludeScaling then
        table.insert(
            Library.Scales,
            New("UIScale", {
                Parent = Button,
            })
        )
    end
    Library:AddOutline(Button)

    local DragThreshold = if ExcludeDragging then 0.25 else math.huge
    local Changed
    table.insert(DraggableButton.Connections, Button.InputBegan:Connect(function(Input: InputObject)
        if not IsClickInput(Input) then
            return
        end

        if Changed and Changed.Connected then
            Changed:Disconnect()
        end
        local Start = tick()

        Changed = Input.Changed:Connect(function()
            if Input.UserInputState ~= Enum.UserInputState.End then
                return
            end

            local IsLikelyDragging = tick() - Start > DragThreshold
            if Changed and Changed.Connected then
                Changed:Disconnect()
                Changed = nil
            end
            if IsLikelyDragging then
                return
            end

            Library:SafeCallback(Func, DraggableButton)
        end)
    end))

    function DraggableButton:SetText(Text: string)
        local X, Y = Library:GetTextBounds(Text, Library.Scheme.Font, 16)

        Button.Text = Text
        Button.Size = UDim2.fromOffset(X * 2, Y * 2)
    end

    Library:MakeDraggable(Button, Button, true)
    DraggableButton:SetText(Text)
    DraggableButton.Button = Button

    if not table.find(Library.DraggableElements, Button) then
        table.insert(Library.DraggableElements, Button)
    end

    PositionDraggable(Button, Button.Position)

    function DraggableButton:Destroy()
        if DraggableButton.Destroyed then
            return
        end
        DraggableButton.Destroyed = true

        if Changed and Changed.Connected then
            Changed:Disconnect()
            Changed = nil
        end
        if DraggableButton.Connections then
            for _, connection in DraggableButton.Connections do
                connection:Disconnect()
            end
        end

        local ElemIdx = table.find(Library.DraggableElements, Button)
        if ElemIdx then
            table.remove(Library.DraggableElements, ElemIdx)
        end

        if Button then
            Button:Destroy()
        end
    end

    return DraggableButton
end

function Library:AddDraggableMenu(Name: string)
    local Holder = New("Frame", {
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundColor3 = "BackgroundColor",
        Position = UDim2.fromOffset(6, 6),
        Size = UDim2.fromOffset(0, 0),
        ZIndex = 10,
        Parent = ScreenGui,
    })
    table.insert(
        Library.Corners,
        New("UICorner", {
            CornerRadius = UDim.new(0, Library.CornerRadius),
            Parent = Holder,
        })
    )
    table.insert(
        Library.Scales,
        New("UIScale", {
            Parent = Holder,
        })
    )
    Library:AddOutline(Holder)

    Library:MakeLine(Holder, {
        Position = UDim2.fromOffset(0, 34),
        Size = UDim2.new(1, 0, 0, 1),
    })

    local Label = New("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 34),
        Text = Name,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Holder,
    })
    New("UIPadding", {
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        Parent = Label,
    })

    local Container = New("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 35),
        Size = UDim2.new(1, 0, 1, -35),
        Parent = Holder,
    })
    New("UIListLayout", {
        Padding = UDim.new(0, 7),
        Parent = Container,
    })
    New("UIPadding", {
        PaddingBottom = UDim.new(0, 7),
        PaddingLeft = UDim.new(0, 7),
        PaddingRight = UDim.new(0, 7),
        PaddingTop = UDim.new(0, 7),
        Parent = Container,
    })

    Library:MakeDraggable(Holder, Label, true)

    if not table.find(Library.DraggableElements, Holder) then
        table.insert(Library.DraggableElements, Holder)
    end

    PositionDraggable(Holder, Holder.Position)

    return Holder, Container
end

function Library:AddDraggableImageButton(...)
    local Params = select(1, ...)

    local Icon
    local IconSize
    local Func
    local ExcludeScaling
    local ExcludeDragging

    if typeof(Params) == "table" then
        Icon = Params.Icon
        IconSize = Params.IconSize or 24
        Func = Params.Callback or Params.Func
        ExcludeScaling = Params.ExcludeScaling
        ExcludeDragging = Params.ExcludeDragging
    elseif typeof(Params) == "string" or typeof(Params) == "number" then
        Icon = Params
        IconSize = select(2, ...)
        Func = select(3, ...)
        ExcludeScaling = select(4, ...)
        ExcludeDragging = select(5, ...)
    end

    local DraggableImageButton = {
        Connections = {},
        Destroyed = false,
    }

    local Button = New("TextButton", {
        BackgroundColor3 = "BackgroundColor",
        Position = UDim2.fromOffset(6, 6),
        Size = UDim2.fromOffset(IconSize + 12, IconSize + 12),
        Text = "",
        ZIndex = 10,
        Parent = ScreenGui,
    })
    
    local IconImage = New("ImageLabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(IconSize, IconSize),
        ImageColor3 = "FontColor",
        ZIndex = 11,
        Parent = Button,
    })

    table.insert(
        Library.Corners, 
        New("UICorner", {
            CornerRadius = UDim.new(0, Library.CornerRadius),
            Parent = Button,
        })
    )
    if not ExcludeScaling then
        table.insert(
            Library.Scales,
            New("UIScale", {
                Parent = Button,
            })
        )
    end
    Library:AddOutline(Button)

    local DragThreshold = if ExcludeDragging then 0.25 else math.huge
    local Changed
    table.insert(DraggableImageButton.Connections, Button.InputBegan:Connect(function(Input: InputObject)
        if not IsClickInput(Input) then
            return
        end

        if Changed and Changed.Connected then
            Changed:Disconnect()
        end
        local Start = tick()

        Changed = Input.Changed:Connect(function()
            if Input.UserInputState ~= Enum.UserInputState.End then
                return
            end

            local IsLikelyDragging = tick() - Start > DragThreshold
            if Changed and Changed.Connected then
                Changed:Disconnect()
                Changed = nil
            end
            if IsLikelyDragging then
                return
            end

            Library:SafeCallback(Func, DraggableImageButton)
        end)
    end))

    function DraggableImageButton:SetIcon(NewIcon: string)
        Icon = NewIcon or Icon
        
        local CustomIcon = Library:GetCustomIcon(Icon)
        assert(CustomIcon, "Icon must be a valid Roblox asset or a valid URL or a valid lucide icon.")

        IconImage.Image = CustomIcon.Url
        IconImage.ImageRectOffset = CustomIcon.ImageRectOffset
        IconImage.ImageRectSize = CustomIcon.ImageRectSize
    end

    function DraggableImageButton:SetIconSize(NewSize: number)
        IconSize = NewSize
        IconImage.Size = UDim2.fromOffset(IconSize, IconSize)
        Button.Size = UDim2.fromOffset(IconSize + 12, IconSize + 12)
    end

    Library:MakeDraggable(Button, Button, true)
    DraggableImageButton:SetIcon(Icon)
    DraggableImageButton.Button = Button

    if not table.find(Library.DraggableElements, Button) then
        table.insert(Library.DraggableElements, Button)
    end

    PositionDraggable(Button, Button.Position)

    function DraggableImageButton:Destroy()
        if DraggableImageButton.Destroyed then
            return
        end
        DraggableImageButton.Destroyed = true

        if Changed and Changed.Connected then
            Changed:Disconnect()
            Changed = nil
        end
        for _, Connection in DraggableImageButton.Connections do
            Connection:Disconnect()
        end

        local ElementIndex = table.find(Library.DraggableElements, Button)
        if ElementIndex then
            table.remove(Library.DraggableElements, ElementIndex)
        end

        if Button then
            Button:Destroy()
        end
    end

    return DraggableImageButton
end

--// Watermark - Deprecated \\--
do
    local WatermarkLabel = Library:AddDraggableLabel("")
    WatermarkLabel:SetVisible(false)

    function Library:SetWatermark(Text: string)
        warn("Watermark is deprecated, please use Library:AddDraggableLabel instead.")
        WatermarkLabel:SetText(Text)
    end

    function Library:SetWatermarkVisibility(Visible: boolean)
        warn("Watermark is deprecated, please use Library:AddDraggableLabel instead.")
        WatermarkLabel:SetVisible(Visible)
    end
end

--// Context Menu \\--
local CurrentMenu
function Library:AddContextMenu(
    Holder: GuiObject,
    Size: UDim2 | () -> (),
    Offset: { [number]: number } | () -> {},
    List: number?,
    ActiveCallback: (Active: boolean) -> ()?,
    AnimationType: ("Dropdown" | "KeyPicker" | "none")?
)
    local Menu
    local ParentGui = Holder:FindFirstAncestorOfClass("ScreenGui")
    local MenuZIndex = math.max(10, Holder.ZIndex + 1)
    if ParentGui ~= ScreenGui and (Library.ActiveLoading and ParentGui ~= Library.ActiveLoading.ScreenGui) then
        ParentGui = ScreenGui
    end

    if List then
        Menu = New("ScrollingFrame", {
            AutomaticCanvasSize = List == 2 and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
            AutomaticSize = List == 1 and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
            BackgroundColor3 = "BackgroundColor",
            BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
            CanvasSize = UDim2.fromOffset(0, 0),
            ScrollBarImageColor3 = "OutlineColor",
            ScrollBarThickness = List == 2 and 2 or 0,
            Size = typeof(Size) == "function" and Size() or Size,
            TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
            Visible = false,
            ZIndex = MenuZIndex,
            Parent = ParentGui,
        })
    else
        Menu = New("Frame", {
            BackgroundColor3 = "BackgroundColor",
            Size = typeof(Size) == "function" and Size() or Size,
            Visible = false,
            ZIndex = MenuZIndex,
            Parent = ParentGui,
        })
    end
    local MenuScale = New("UIScale", {
        Parent = Menu,
    })
    table.insert(Library.Scales, MenuScale)

    New("UIStroke", {
        Color = "OutlineColor",
        Parent = Menu,
    })

    local Table = {
        Connections = {},
        Destroyed = false,

        Active = false,
        Holder = Holder,
        Menu = Menu,
        List = nil,
        Signal = nil,

        Size = Size,

        AutoSizeY = List == 1,
        OpenCloseTween = nil,
        Animated = function()
            if not AnimationType or AnimationType == "none" then
                return false
            end

            if not (Library.Animations and Library.Animations[AnimationType] == true) then
                return false
            end
            
            return true, Library[string.format("%sTransitionInfo", AnimationType)] or TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        end
    }

    if List then
        Table.List = New("UIListLayout", {
            Parent = Menu,
        })
    end

    function Table:Open()
        if CurrentMenu == Table then
            return
        elseif CurrentMenu then
            CurrentMenu:Close()
        end

        CurrentMenu = Table
        Table.Active = true

        if typeof(Offset) == "function" then
            Menu.Position = UDim2.fromOffset(
                math.floor(Holder.AbsolutePosition.X + Offset()[1]),
                math.floor(Holder.AbsolutePosition.Y + Offset()[2])
            )
        else
            Menu.Position = UDim2.fromOffset(
                math.floor(Holder.AbsolutePosition.X + Offset[1]),
                math.floor(Holder.AbsolutePosition.Y + Offset[2])
            )
        end

        local TargetSize = typeof(Table.Size) == "function" and Table.Size() or Table.Size

        if typeof(ActiveCallback) == "function" then
            Library:SafeCallback(ActiveCallback, true)
        end

        if Table.OpenCloseTween then
            StopTween(Table.OpenCloseTween, true)
            Table.OpenCloseTween = nil
        end

        local IsAnimated, TweenInfo = Table.Animated()
        if IsAnimated == true then
            local OpenSize = TargetSize
            if Table.AutoSizeY then
                local FullHeight = Menu.AbsoluteSize.Y

                Menu.AutomaticSize = Enum.AutomaticSize.None
                OpenSize = UDim2.new(TargetSize.X.Scale, TargetSize.X.Offset, 0, FullHeight)
            end

            Menu.Size = UDim2.new(OpenSize.X.Scale, OpenSize.X.Offset, 0, 0)
            Menu.Visible = true

            local Tween = TweenService:Create(Menu, TweenInfo, { Size = OpenSize })
            Table.OpenCloseTween = Tween

            local Connection; Connection = Library:GiveSignal(Tween.Completed:Once(function()
                Library:ForgetSignal(Connection)

                if Table.OpenCloseTween == Tween then
                    StopTween(Table.OpenCloseTween, true)
                    Table.OpenCloseTween = nil

                    if Table.AutoSizeY then
                        Menu.AutomaticSize = Enum.AutomaticSize.Y
                    end
                end
            end))

            Tween:Play()
        else
            Menu.Size = TargetSize
            Menu.Visible = true
        end

        Table.Signal = Holder:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
            if typeof(Offset) == "function" then
                Menu.Position = UDim2.fromOffset(
                    math.floor(Holder.AbsolutePosition.X + Offset()[1]),
                    math.floor(Holder.AbsolutePosition.Y + Offset()[2])
                )
            else
                Menu.Position = UDim2.fromOffset(
                    math.floor(Holder.AbsolutePosition.X + Offset[1]),
                    math.floor(Holder.AbsolutePosition.Y + Offset[2])
                )
            end

            local BoundaryFrame = Library.WindowContainer
            if
                Library.ActiveLoading
                and ParentGui == Library.ActiveLoading.ScreenGui
                and Library.ActiveLoading.Sidebar
            then
                BoundaryFrame = Library.ActiveLoading.Sidebar.Container
            end

            if
                BoundaryFrame
                and BoundaryFrame.Parent
                and not Library:IsInsideFrame(BoundaryFrame, Holder)
                and Table.Active
            then
                Table:Close()
            end
        end)
    end

    function Table:Close()
        if CurrentMenu ~= Table then
            return
        end

        if Table.Signal then
            Table.Signal:Disconnect()
            Table.Signal = nil
        end

        Table.Active = false
        CurrentMenu = nil

        if typeof(ActiveCallback) == "function" then
            Library:SafeCallback(ActiveCallback, false)
        end

        if Table.OpenCloseTween then
            StopTween(Table.OpenCloseTween, true)
            Table.OpenCloseTween = nil
        end

        local IsAnimated, TweenInfo = Table.Animated()
        if IsAnimated == true then
            if Table.AutoSizeY then
                Menu.AutomaticSize = Enum.AutomaticSize.None
            end

            local CurrentSize = Menu.Size
            local CollapsedSize = UDim2.new(CurrentSize.X.Scale, CurrentSize.X.Offset, 0, 0)

            local Tween = TweenService:Create(Menu, TweenInfo, { Size = CollapsedSize })
            Table.OpenCloseTween = Tween

            local Connection; Connection = Library:GiveSignal(Tween.Completed:Once(function(PlaybackState)
                Library:ForgetSignal(Connection)

                if Table.OpenCloseTween == Tween then
                    StopTween(Table.OpenCloseTween, true)
                    Table.OpenCloseTween = nil

                    Menu.Visible = false
                    if Table.AutoSizeY then
                        Menu.AutomaticSize = Enum.AutomaticSize.Y
                    end
                end
            end))

            Tween:Play()
        else
            Menu.Visible = false
        end
    end

    function Table:Toggle()
        if Table.Active then
            Table:Close()
        else
            Table:Open()
        end
    end

    function Table:SetSize(Size)
        Table.Size = Size
        Menu.Size = typeof(Size) == "function" and Size() or Size
    end

    function Table:Destroy()
        if Table.Destroyed then
            return
        end
        Table.Destroyed = true

        if Table.Connections then
            for _, Connection in Table.Connections do
                Connection:Disconnect()
            end
        end

        if CurrentMenu == Table then
            Table:Close()
        end

        if Table.OpenCloseTween then
            StopTween(Table.OpenCloseTween, true)
            Table.OpenCloseTween = nil
        end

        local ScaleIndex = table.find(Library.Scales, MenuScale)
        if ScaleIndex then
            table.remove(Library.Scales, ScaleIndex)
        end
        Library.ScalesOffset[MenuScale] = nil

        if Menu then
            Menu:Destroy()
        end
    end

    return Table
end

Library:GiveSignal(UserInputService.InputBegan:Connect(function(Input: InputObject)
    if Library.Unloaded then
        return
    end

    if IsClickInput(Input, true) then
        local Location = Input.Position

        if
            CurrentMenu
            and not (
                Library:MouseIsOverFrame(CurrentMenu.Menu, Location)
                or Library:MouseIsOverFrame(CurrentMenu.Holder, Location)
            )
        then
            CurrentMenu:Close()
        end
    end
end))

--// Tooltip \\--
local TooltipLabel = New("TextLabel", {
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundColor3 = "BackgroundColor",
    TextSize = 14,
    TextWrapped = true,
    Visible = false,
    ZIndex = 20,
    Parent = ScreenGui,
})
New("UIPadding", {
    PaddingBottom = UDim.new(0, 2),
    PaddingLeft = UDim.new(0, 4),
    PaddingRight = UDim.new(0, 4),
    PaddingTop = UDim.new(0, 2),
    Parent = TooltipLabel,
})
table.insert(
    Library.Scales,
    New("UIScale", {
        Parent = TooltipLabel,
    })
)
local TooltipStroke = New("UIStroke", {
    Color = "OutlineColor",
    Parent = TooltipLabel,
})
local function RestoreTooltipRegistry()
    Library:AddToRegistry(TooltipLabel, {
        BackgroundColor3 = "BackgroundColor",
        FontFace = "Font",
        TextColor3 = "FontColor",
    })
    Library:AddToRegistry(TooltipStroke, {
        Color = "OutlineColor",
    })
end
TooltipLabel:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
    if Library.Unloaded then
        return
    end

    local X, _ = Library:GetTextBounds(
        TooltipLabel.Text,
        TooltipLabel.FontFace,
        TooltipLabel.TextSize,
        (workspace.CurrentCamera.ViewportSize.X - TooltipLabel.AbsolutePosition.X - 8) / Library.DPIScale
    )

    TooltipLabel.Size = UDim2.fromOffset(X + 8, 0)
end)

local CurrentHoverInstance
function Library:AddTooltip(InfoStr: string, DisabledInfoStr: string, HoverInstance: GuiObject)
    local TooltipTable = {
        Disabled = false,
        Enabled = true,
        Hovering = false,
        Signals = {},
    }

    local function DoHover()
        if
            TooltipTable.Destroyed
            or TooltipTable.Enabled == false
            or CurrentHoverInstance == HoverInstance
            or Library.ActiveDialog
            or (CurrentMenu and Library:MouseIsOverFrame(CurrentMenu.Menu, Mouse))
            or (TooltipTable.Disabled and typeof(DisabledInfoStr) ~= "string")
            or (not TooltipTable.Disabled and typeof(InfoStr) ~= "string")
        then
            return
        end
        CurrentHoverInstance = HoverInstance

        local ParentGui = HoverInstance:FindFirstAncestorOfClass("ScreenGui")
        if ParentGui ~= ScreenGui and (Library.ActiveLoading and ParentGui ~= Library.ActiveLoading.ScreenGui) then
            ParentGui = ScreenGui
        end
        TooltipLabel.Parent = ParentGui
        RestoreTooltipRegistry()

        TooltipLabel.Text = TooltipTable.Disabled and DisabledInfoStr or InfoStr
        TooltipLabel.Visible = true

        while
            not TooltipTable.Destroyed
            and not Library.Unloaded
            and HoverInstance.Parent ~= nil
            and (Library.Toggled or Library.ActiveLoading)
            and not Library.ActiveDialog
            and Library:MouseIsOverFrame(HoverInstance, Mouse)
            and not (CurrentMenu and Library:MouseIsOverFrame(CurrentMenu.Menu, Mouse))
        do
            TooltipLabel.Position = UDim2.fromOffset(
                Mouse.X + (Library.ShowCustomCursor and 8 or 14),
                Mouse.Y + (Library.ShowCustomCursor and 8 or 12)
            )

            RunService.RenderStepped:Wait()
        end

        TooltipLabel.Visible = false
        CurrentHoverInstance = nil
    end

    local function GiveSignal(Connection: RBXScriptConnection | RBXScriptSignal)
        local ConnectionType = typeof(Connection)
        if Connection and (ConnectionType == "RBXScriptConnection" or ConnectionType == "RBXScriptSignal") then
            table.insert(TooltipTable.Signals, Connection)
        end

        return Connection
    end

    GiveSignal(HoverInstance.MouseEnter:Connect(DoHover))
    GiveSignal(HoverInstance.MouseMoved:Connect(DoHover))
    GiveSignal(HoverInstance.MouseLeave:Connect(function()
        if CurrentHoverInstance ~= HoverInstance then
            return
        end

        TooltipLabel.Visible = false
        CurrentHoverInstance = nil
    end))

    function TooltipTable:Destroy()
        if TooltipTable.Destroyed then
            return
        end
        TooltipTable.Destroyed = true

        for Index = #TooltipTable.Signals, 1, -1 do
            local Connection = table.remove(TooltipTable.Signals, Index)
            if Connection and Connection.Connected then
                Connection:Disconnect()
            end
        end

        if CurrentHoverInstance == HoverInstance then
            if TooltipLabel then
                TooltipLabel.Visible = false
            end

            CurrentHoverInstance = nil
        end

        local TooltipIndex = table.find(Tooltips, TooltipTable)
        if TooltipIndex then
            table.remove(Tooltips, TooltipIndex)
        end
    end

    table.insert(Tooltips, TooltipTable)
    return TooltipTable
end

function Library:OnUnload(Callback)
    table.insert(Library.UnloadSignals, Callback)
end

local CheckIcon = Library:GetIcon("check")
local ArrowIcon = Library:GetIcon("chevron-up")
local ResizeIcon = Library:GetIcon("move-diagonal-2")
local KeyIcon = Library:GetIcon("key")
local MoveIcon = Library:GetIcon("move")
local FileQuestionMarkIcon = Library:GetIcon("file-question-mark")

function Library:SetIconModule(module: IconModule)
    FetchIcons = true
    Icons = module

    -- Top ten fixes 🚀
    CheckIcon = Library:GetIcon("check")
    ArrowIcon = Library:GetIcon("chevron-up")
    ResizeIcon = Library:GetIcon("move-diagonal-2")
    KeyIcon = Library:GetIcon("key")
    MoveIcon = Library:GetIcon("move")
    FileQuestionMarkIcon = Library:GetIcon("file-question-mark")
end

local BaseAddons = {}
do
    local Funcs = {}

    function Funcs:AddKeyPicker(Idx, Info)
        if self.Destroyed then return nil end
        assert(Idx ~= nil, "AddKeyPicker requires a non-nil index.")

        Info = Library:Validate(Info, Templates.KeyPicker)

        local ParentObj = self
        local IsForButton = ParentObj.Type == "Button" or ParentObj.Type == "SubButton"
        local ToggleLabel = ParentObj.TextLabel

        if IsForButton then
            assert(Info.Mode == "Press", "KeyPicker on Buttons can only be applied with the 'Press' mode.")

            for _, Addon in table.clone(ParentObj.Addons or {}) do
                if Addon.Type == "KeyPicker" and Addon.Destroy then
                    Addon:Destroy()
                end
            end
            ToggleLabel = ParentObj.Base
        end

        local KeyPicker = {
            Connections = {},
            Destroyed = false,

            Text = Info.Text,
            Value = Info.Default, -- Key
            Modifiers = Info.DefaultModifiers, -- Modifiers
            DisplayValue = Info.Default, -- Picker Text

            Blacklisted = Info.Blacklisted,
            BlacklistedModifiers = Info.BlacklistedModifiers,
            Whitelisted = Info.Whitelisted,
            WhitelistedModifiers = Info.WhitelistedModifiers,

            Toggled = false,
            Mode = Info.Mode,
            SyncToggleState = Info.SyncToggleState,

            Callback = Info.Callback,
            ChangedCallback = Info.ChangedCallback,
            Changed = Info.Changed,
            Clicked = Info.Clicked,

            Type = "KeyPicker",
        }

        if KeyPicker.Mode == "Press" then
            assert(ParentObj.Type == "Label" or ParentObj.Type == "Button" or ParentObj.Type == "SubButton", "KeyPicker with the mode 'Press' can be only applied on Labels and Buttons.")

            KeyPicker.SyncToggleState = false
            Info.Modes = { "Press" }
            Info.Mode = "Press"
        end

        if KeyPicker.SyncToggleState then
            Info.Modes = { "Toggle", "Hold" }

            if not table.find(Info.Modes, Info.Mode) then
                Info.Mode = "Toggle"
            end
        end

        local Picking = false

        -- Special Keys
        local SpecialKeys = {
            ["MB1"] = Enum.UserInputType.MouseButton1,
            ["MB2"] = Enum.UserInputType.MouseButton2,
            ["MB3"] = Enum.UserInputType.MouseButton3,
        }

        local SpecialKeysInput = {
            [Enum.UserInputType.MouseButton1] = "MB1",
            [Enum.UserInputType.MouseButton2] = "MB2",
            [Enum.UserInputType.MouseButton3] = "MB3",
        }

        -- Modifiers
        local Modifiers = {
            ["LAlt"] = Enum.KeyCode.LeftAlt,
            ["RAlt"] = Enum.KeyCode.RightAlt,

            ["LCtrl"] = Enum.KeyCode.LeftControl,
            ["RCtrl"] = Enum.KeyCode.RightControl,

            ["LShift"] = Enum.KeyCode.LeftShift,
            ["RShift"] = Enum.KeyCode.RightShift,

            ["Tab"] = Enum.KeyCode.Tab,
            ["CapsLock"] = Enum.KeyCode.CapsLock,
        }

        local ModifiersInput = {
            [Enum.KeyCode.LeftAlt] = "LAlt",
            [Enum.KeyCode.RightAlt] = "RAlt",

            [Enum.KeyCode.LeftControl] = "LCtrl",
            [Enum.KeyCode.RightControl] = "RCtrl",

            [Enum.KeyCode.LeftShift] = "LShift",
            [Enum.KeyCode.RightShift] = "RShift",

            [Enum.KeyCode.Tab] = "Tab",
            [Enum.KeyCode.CapsLock] = "CapsLock",
        }

        local IsModifierInput = function(Input)
            return Input.UserInputType == Enum.UserInputType.Keyboard and ModifiersInput[Input.KeyCode] ~= nil
        end

        local GetActiveModifiers = function()
            local ActiveModifiers = {}

            for Name, Input in Modifiers do
                if table.find(ActiveModifiers, Name) then
                    continue
                end
                if not UserInputService:IsKeyDown(Input) then
                    continue
                end

                table.insert(ActiveModifiers, Name)
            end

            return ActiveModifiers
        end

        local AreModifiersHeld = function(Required)
            if not (typeof(Required) == "table" and GetTableSize(Required) > 0) then
                return true
            end

            local ActiveModifiers = GetActiveModifiers()
            local Holding = true

            for _, Name in Required do
                if table.find(ActiveModifiers, Name) then
                    continue
                end

                Holding = false
                break
            end

            return Holding
        end

        local IsInputDown = function(Input)
            if not Input then
                return false
            end

            if SpecialKeysInput[Input.UserInputType] ~= nil then
                return UserInputService:IsMouseButtonPressed(Input.UserInputType)
                    and not UserInputService:GetFocusedTextBox()
            elseif Input.UserInputType == Enum.UserInputType.Keyboard then
                return UserInputService:IsKeyDown(Input.KeyCode) and not UserInputService:GetFocusedTextBox()
            else
                return false
            end
        end

        local ConvertToInputModifiers = function(CurrentModifiers)
            local InputModifiers = {}

            for _, name in CurrentModifiers do
                table.insert(InputModifiers, Modifiers[name])
            end

            return InputModifiers
        end

        local VerifyModifiers = function(CurrentModifiers)
            if typeof(CurrentModifiers) ~= "table" then
                return {}
            end

            local ValidModifiers = {}

            for _, name in CurrentModifiers do
                if not Modifiers[name] then
                    continue
                end

                table.insert(ValidModifiers, name)
            end

            return ValidModifiers
        end

        KeyPicker.Modifiers = VerifyModifiers(KeyPicker.Modifiers)

        local SlideOverflow = true
        local MaxPickerWidth = 75
        local SlidingLabel

        local LastPickerWidth = 0
        local SlideForwardTween
        local SlideBackTween
        local ButtonAddonHolder
        local OriginalToggleLabelParent
        local HandleForwardTween = function(State)
            if State ~= Enum.PlaybackState.Completed then
                return
            end

            task.wait(1.5)
            if SlideBackTween then
                SlideBackTween:Play()
            end
        end

        local HandleBackTween = function(State)
            if State ~= Enum.PlaybackState.Completed then
                return
            end

            task.wait(1.5)
            if SlideForwardTween then
                SlideForwardTween:Play()
            end
        end

        local CancelSlidingTweens = function()
            if SlideForwardTween then
                StopTween(SlideForwardTween, true)
                SlideForwardTween = nil
            end

            if SlideBackTween then
                StopTween(SlideBackTween, true)
                SlideBackTween = nil
            end
        end

        local Picker = New("TextButton", {
            BackgroundColor3 = "MainColor",
            Size = UDim2.fromOffset(18, 18),
            Text = (IsForButton and SlideOverflow) and "" or KeyPicker.Value,
            TextSize = 14,
            Parent = ToggleLabel,
        })

        if IsForButton and SlideOverflow then
            Picker.ClipsDescendants = true

            SlidingLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Position = UDim2.new(0, 0, 0, 0),
                Text = KeyPicker.Value,
                TextSize = 14,
                FontFace = Picker.FontFace,
                TextXAlignment = Enum.TextXAlignment.Center,
                Parent = Picker,
            })

            Library:AddToRegistry(SlidingLabel, {
                TextColor3 = "FontColor",
            })
        end

        New("UIStroke", {
            Color = "OutlineColor",
            Parent = Picker,
        })

        if IsForButton then
            OriginalToggleLabelParent = ToggleLabel.Parent
            local Holder = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 21),
                Parent = OriginalToggleLabelParent,
            })
            ButtonAddonHolder = Holder

            New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                Padding = UDim.new(0, 9),
                Parent = Holder,
            })

            ToggleLabel.Parent = Holder
            Picker.Parent = Holder

            Picker.Size = UDim2.new(0, 18, 1, 0)
        end

        local KeybindsToggle = { Normal = KeyPicker.Mode ~= "Toggle" }
        do
            local Holder = New("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 16),
                Text = "",
                Visible = not Info.NoUI,
                Parent = Library.KeybindContainer,
            })

            local Label = New("TextLabel", {
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(0, 1),
                Text = "",
                TextSize = 14,
                TextTransparency = 0.5,
                Parent = Holder,
            })

            local Checkbox = New("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = "MainColor",
                Position = UDim2.fromScale(0, 0.5),
                Size = UDim2.fromOffset(14, 14),
                SizeConstraint = Enum.SizeConstraint.RelativeYY,
                Parent = Holder,
            })
            New("UIStroke", {
                Color = "OutlineColor",
                Parent = Checkbox,
            })

            local CheckImage = New("ImageLabel", {
                Image = CheckIcon and CheckIcon.Url or "",
                ImageColor3 = "FontColor",
                ImageRectOffset = CheckIcon and CheckIcon.ImageRectOffset or Vector2.zero,
                ImageRectSize = CheckIcon and CheckIcon.ImageRectSize or Vector2.zero,
                ImageTransparency = 1,
                Position = UDim2.fromOffset(2, 2),
                Size = UDim2.new(1, -4, 1, -4),
                Parent = Checkbox,
            })

            function KeybindsToggle:Display(State)
                Label.TextTransparency = State and 0 or 0.5
                CheckImage.ImageTransparency = State and 0 or 1
            end

            function KeybindsToggle:SetText(Text)
                Label.Text = Text
            end

            function KeybindsToggle:SetVisibility(Visibility)
                Holder.Visible = Visibility
            end

            function KeybindsToggle:SetNormal(Normal)
                KeybindsToggle.Normal = Normal

                Holder.Active = not Normal
                Label.Position = Normal and UDim2.fromOffset(0, 0) or UDim2.fromOffset(22, 0)
                Checkbox.Visible = not Normal
            end

            KeyPicker.DoClick = function(...) end --// make luau lsp shut up
            Holder.MouseButton1Click:Connect(function()
                if KeybindsToggle.Normal then
                    return
                end

                KeyPicker.Toggled = not KeyPicker.Toggled
                KeyPicker:DoClick()
            end)

            KeybindsToggle.Holder = Holder
            KeybindsToggle.Label = Label
            KeybindsToggle.Checkbox = Checkbox
            KeybindsToggle.Loaded = true
            table.insert(Library.KeybindToggles, KeybindsToggle)
        end

        local ModeButtons = {}
        local TotalModeButtons = GetTableSize(Info.Modes)
        local MenuTable = Library:AddContextMenu(Picker, UDim2.fromOffset(62, 0), function()
            return { Picker.AbsoluteSize.X + 1.5, 0.5 }
        end, 1, nil, "KeyPicker")
        KeyPicker.Menu = MenuTable

        for _, Mode in Info.Modes do
            local ModeButton = {}

            local Button = New("TextButton", {
                BackgroundColor3 = "MainColor",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, IsForButton and 21 or (TotalModeButtons == 1 and 18 or 19)),
                Text = Mode,
                TextSize = 14,
                TextTransparency = 0.5,
                Parent = MenuTable.Menu,
            })

            function ModeButton:Select()
                for _, Button in ModeButtons do
                    Button:Deselect()
                end

                KeyPicker.Mode = Mode

                Button.BackgroundTransparency = 0
                Button.TextTransparency = 0

                MenuTable:Close()
                if KeyPicker.Update then
                    KeyPicker:Update()
                end
            end

            function ModeButton:Deselect()
                KeyPicker.Mode = nil

                Button.BackgroundTransparency = 1
                Button.TextTransparency = 0.5
            end

            Button.MouseButton1Click:Connect(function()
                ModeButton:Select()
            end)

            if KeyPicker.Mode == Mode then
                ModeButton:Select()
            end

            ModeButtons[Mode] = ModeButton
        end

        function KeyPicker:Display(PickerText)
            if Library.Unloaded then
                return
            end

            local DisplayText = PickerText or KeyPicker.DisplayValue
            if IsForButton and SlideOverflow then
                if LastPickerWidth == Picker.AbsoluteSize.X then
                    return
                end

                local X, _Y = Library:GetTextBounds(
                    DisplayText,
                    Picker.FontFace,
                    Picker.TextSize,
                    10000
                )

                SlidingLabel.Text = DisplayText

                local OffsetScale = X + 9
                local PickerWidth = math.min(OffsetScale, MaxPickerWidth)
                Picker.Size = UDim2.new(0, PickerWidth, 1, 0)

                if OffsetScale > PickerWidth then
                    SlidingLabel.TextXAlignment = Enum.TextXAlignment.Left
                    SlidingLabel.Size = UDim2.new(0, OffsetScale, 1, 0)
                    SlidingLabel.Position = UDim2.fromOffset(4.5, 0)

                    RunService.RenderStepped:Wait()

                    local RealPickerWidth = Picker.AbsoluteSize.X
                    if RealPickerWidth <= 0 then RealPickerWidth = PickerWidth end

                    LastPickerWidth = RealPickerWidth

                    local OverflowDistance = OffsetScale - RealPickerWidth - 4.5
                    if OverflowDistance > 0 then
                        CancelSlidingTweens()

                        local Duration = OverflowDistance / 25
                        local TweenInfo = TweenInfo.new(
                            Duration,
                            Enum.EasingStyle.Linear, Enum.EasingDirection.InOut
                        )

                        SlideForwardTween = TweenService:Create(SlidingLabel, TweenInfo, {
                            Position = UDim2.fromOffset(-OverflowDistance, 0)
                        })

                        SlideBackTween = TweenService:Create(SlidingLabel, TweenInfo, {
                            Position = UDim2.fromOffset(4.5, 0)
                        })

                        SlideForwardTween:Play()

                        SlideForwardTween.Completed:Connect(HandleForwardTween)
                        SlideBackTween.Completed:Connect(HandleBackTween)
                    else
                        CancelSlidingTweens()

                        SlidingLabel.TextXAlignment = Enum.TextXAlignment.Center
                        SlidingLabel.Size = UDim2.new(1, 0, 1, 0)
                        SlidingLabel.Position = UDim2.new(0, 0, 0, 0)
                    end
                else
                    CancelSlidingTweens()

                    SlidingLabel.TextXAlignment = Enum.TextXAlignment.Center
                    SlidingLabel.Size = UDim2.new(1, 0, 1, 0)
                    SlidingLabel.Position = UDim2.new(0, 0, 0, 0)
                end
            else
                local X, Y = Library:GetTextBounds(
                    DisplayText,
                    Picker.FontFace,
                    Picker.TextSize,
                    ToggleLabel.AbsoluteSize.X
                )
                Picker.Text = DisplayText
                Picker.Size = IsForButton and UDim2.new(0, X + 9, 1, 0) or UDim2.fromOffset((X + 9), (Y + 4))
            end
        end

        function KeyPicker:Update()
            KeyPicker:Display()

            if Info.NoUI then
                return
            end

            if KeyPicker.Mode == "Toggle" and ParentObj.Type == "Toggle" and ParentObj.Disabled then
                KeybindsToggle:SetVisibility(false)
                return
            end

            local State = KeyPicker:GetState()
            local ShowToggle = Library.ShowToggleFrameInKeybinds and KeyPicker.Mode == "Toggle"

            if KeyPicker.SyncToggleState and ParentObj.Value ~= State then
                ParentObj:SetValue(State)
            end

            if KeybindsToggle.Loaded then
                if ShowToggle then
                    KeybindsToggle:SetNormal(false)
                else
                    KeybindsToggle:SetNormal(true)
                end

                KeybindsToggle:SetText(("[%s] %s (%s)"):format(KeyPicker.DisplayValue, KeyPicker.Text, KeyPicker.Mode))
                KeybindsToggle:SetVisibility(true)
                KeybindsToggle:Display(State)
            end
        end

        function KeyPicker:GetState()
            if KeyPicker.Mode == "Always" then
                return true
            elseif KeyPicker.Mode == "Hold" then
                local Key = KeyPicker.Value
                if Key == "None" then
                    return false
                end

                if not AreModifiersHeld(KeyPicker.Modifiers) then
                    return false
                end

                if Picking then
                    return false
                end

                if SpecialKeys[Key] ~= nil then
                    if Library.Toggled then
                        return false
                    end

                    return UserInputService:IsMouseButtonPressed(SpecialKeys[Key])
                        and not UserInputService:GetFocusedTextBox()
                else
                    local KeyCode = Enum.KeyCode[Key]
                    return KeyCode ~= nil
                        and UserInputService:IsKeyDown(KeyCode :: any)
                        and not UserInputService:GetFocusedTextBox()
                end
            else
                return KeyPicker.Toggled
            end
        end

        function KeyPicker:OnChanged(Func)
            KeyPicker.Changed = Func
        end

        function KeyPicker:OnClick(Func)
            KeyPicker.Clicked = Func
        end

        function KeyPicker:DoClick()
            if Picking then
                return
            end

            if KeyPicker.Mode == "Press" then
                if KeyPicker.Toggled and Info.WaitForCallback == true then
                    return
                end

				KeyPicker.Toggled = true
            end

            Library:SafeCallback(KeyPicker.Callback, KeyPicker.Toggled)
            Library:SafeCallback(KeyPicker.Clicked, KeyPicker.Toggled)

            if IsForButton then
                Library:SafeCallback(ParentObj.Func, KeyPicker.Toggled)
			end
			
			if Library.ToggleKeybind == KeyPicker and Library.Toggle then
                Library:Toggle()
            end

			if KeyPicker.Mode == "Press" then
                KeyPicker.Toggled = false
            end
        end

        function KeyPicker:RunChanged(IsKeyValid, KeyCode)
            if IsKeyValid == nil or KeyCode == nil then
                IsKeyValid, KeyCode = pcall(function()
                    if KeyPicker.Value == "None" then
                        return nil
                    end

                    if SpecialKeys[KeyPicker.Value] == nil then
                        return Enum.KeyCode[KeyPicker.Value]
                    end

                    return SpecialKeys[KeyPicker.Value]
                end)
            end

            local NewModifiers = ConvertToInputModifiers(KeyPicker.Modifiers)
            Library:SafeCallback(KeyPicker.ChangedCallback, KeyCode, NewModifiers)
            Library:SafeCallback(KeyPicker.Changed, KeyCode, NewModifiers)
        end

        function KeyPicker:SetValue(Data)
            assert(typeof(Data) == "table", "KeyPicker value must be a table.")
            local Key, Mode, Modifiers = Data[1], Data[2], Data[3]
            if typeof(Key) ~= "string" then
                Key = "None"
            end

            local IsKeyValid, KeyCode = pcall(function()
                if Key == "None" then
                    Key = nil
                    return nil
                end

                if SpecialKeys[Key] == nil then
                    return Enum.KeyCode[Key]
                end

                return SpecialKeys[Key]
            end)

            IsKeyValid = IsKeyValid and (Key == nil or KeyCode ~= nil)

            if Key == nil then
                KeyPicker.Value = "None"
            elseif IsKeyValid then
                KeyPicker.Value = Key
            else
                KeyPicker.Value = "Unknown"
            end

            KeyPicker.Modifiers =
                VerifyModifiers(if typeof(Modifiers) == "table" then Modifiers else KeyPicker.Modifiers)
            KeyPicker.DisplayValue = if GetTableSize(KeyPicker.Modifiers) > 0
                then (table.concat(KeyPicker.Modifiers, " + ") .. " + " .. KeyPicker.Value)
                else KeyPicker.Value

            if ModeButtons[Mode] then
                ModeButtons[Mode]:Select()
            end

            KeyPicker:Update()
            KeyPicker:RunChanged(IsKeyValid, KeyCode)
        end

        function KeyPicker:SetText(Text)
            KeyPicker.Text = tostring(Text)
            KeyPicker:Update()
        end

        local SetPickingState = function(State)
            Picking = State
            Library.IsPicking = State

            if ParentObj then
                ParentObj.AnyKeyPickerPicking = Picking
            end

            if IsForButton then
                ToggleLabel.Visible = not Picking
                RunService.RenderStepped:Wait()
            end

            KeyPicker:Update()
        end

        table.insert(KeyPicker.Connections, Picker.MouseButton1Click:Connect(function()
            if Picking or Library.IsPicking then
                return
            end

            SetPickingState(true)

            if IsForButton and SlideOverflow then
                KeyPicker:Display("...")
            else
                Picker.Text = "..."
                Picker.Size = IsForButton and UDim2.new(0, 29, 1, 0) or UDim2.fromOffset(29, 18)
            end

            -- Wait for any input --
            local ActiveModifiers = {}
            local CurrentInput = nil

            local IsValidInput = function(InputObj)
                if InputObj.KeyCode == Enum.KeyCode.Escape then
                    return true
                end

                local IsMod = IsModifierInput(InputObj)
                local KeyName
                if SpecialKeysInput[InputObj.UserInputType] ~= nil then
                    KeyName = SpecialKeysInput[InputObj.UserInputType]
                elseif InputObj.UserInputType == Enum.UserInputType.Keyboard then
                    if IsMod then
                        KeyName = ModifiersInput[InputObj.KeyCode]
                    else
                        KeyName = InputObj.KeyCode.Name
                    end
                end

                if KeyName then
                    if IsMod then
                        if KeyPicker.WhitelistedModifiers and #KeyPicker.WhitelistedModifiers > 0 and not table.find(KeyPicker.WhitelistedModifiers, KeyName) then
                            return false
                        end

                        if KeyPicker.BlacklistedModifiers and table.find(KeyPicker.BlacklistedModifiers, KeyName) then
                            return false
                        end
                    else
                        if KeyPicker.Whitelisted and #KeyPicker.Whitelisted > 0 and not table.find(KeyPicker.Whitelisted, KeyName) then
                            return false
                        end

                        if KeyPicker.Blacklisted and table.find(KeyPicker.Blacklisted, KeyName) then
                            return false
                        end
                    end
                end

                return true
            end

            -- Wait for the first valid InputBegan, while remaining cancellable on destroy/unload.
            local FirstInputConnection
            FirstInputConnection = UserInputService.InputBegan:Connect(function(InputObj)
                if UserInputService:GetFocusedTextBox() == nil and IsValidInput(InputObj) then
                    CurrentInput = InputObj
                end
            end)
            repeat
                task.wait()
            until
                CurrentInput ~= nil
                or KeyPicker.Destroyed
                or Library.Unloaded
                or UserInputService:GetFocusedTextBox() ~= nil

            FirstInputConnection:Disconnect()
            if KeyPicker.Destroyed or Library.Unloaded or UserInputService:GetFocusedTextBox() ~= nil then
                if not KeyPicker.Destroyed then
                    SetPickingState(false)
                end
                return
            end

            -- If it's a modifier key, we wait for either its release or another input --
            while IsModifierInput(CurrentInput) do
                if CurrentInput.KeyCode == Enum.KeyCode.Escape then
                    break
                end

                -- Display the current state including the current modifier key --
                local ModName = ModifiersInput[CurrentInput.KeyCode]
                if ModName then
                    local text = if #ActiveModifiers > 0 then table.concat(ActiveModifiers, " + ") .. " + " .. ModName .. " + ..." else ModName .. " + ..."
                    KeyPicker:Display(text)
                end

                local NextInput = nil
                local Released = false

                local BeganConn
                local EndedConn

                BeganConn = UserInputService.InputBegan:Connect(function(InputObj)
                    if UserInputService:GetFocusedTextBox() ~= nil then
                        return
                    end
                    if IsValidInput(InputObj) then
                        NextInput = InputObj
                    end
                end)

                EndedConn = UserInputService.InputEnded:Connect(function(InputObj)
                    if InputObj.KeyCode == CurrentInput.KeyCode then
                        Released = true
                    end
                end)

                repeat
                    task.wait()
                until
                    Released
                    or NextInput
                    or UserInputService:GetFocusedTextBox() ~= nil
                    or Library.Unloaded
                    or KeyPicker.Destroyed

                if BeganConn then BeganConn:Disconnect() end
                if EndedConn then EndedConn:Disconnect() end

                if UserInputService:GetFocusedTextBox() ~= nil or Library.Unloaded or KeyPicker.Destroyed then
                    if not KeyPicker.Destroyed then
                        SetPickingState(false)
                    end
                    return
                end

                if Released then
                    break -- Use modifier key as bind
                elseif NextInput then
                    -- Add another modifier or continue to normal key
                    local OldModName = ModifiersInput[CurrentInput.KeyCode]
                    if OldModName and not table.find(ActiveModifiers, OldModName) then
                        ActiveModifiers[#ActiveModifiers + 1] = OldModName
                    end

                    CurrentInput = NextInput
                    if CurrentInput.KeyCode == Enum.KeyCode.Escape then
                        break
                    end
                end
            end

            local Key = "Unknown"
            if SpecialKeysInput[CurrentInput.UserInputType] ~= nil then
                Key = SpecialKeysInput[CurrentInput.UserInputType]
            elseif CurrentInput.UserInputType == Enum.UserInputType.Keyboard then
                Key = CurrentInput.KeyCode == Enum.KeyCode.Escape and "None" or CurrentInput.KeyCode.Name
            end

            ActiveModifiers = if CurrentInput.KeyCode == Enum.KeyCode.Escape or Key == "Unknown" then {} else ActiveModifiers

            KeyPicker.Toggled = if ParentObj.Type == "Toggle" then ParentObj.Value else false
            KeyPicker:SetValue({ Key, KeyPicker.Mode, ActiveModifiers })

            repeat
                task.wait()
            until
                not IsInputDown(CurrentInput)
                or UserInputService:GetFocusedTextBox()
                or KeyPicker.Destroyed
                or Library.Unloaded

            if not KeyPicker.Destroyed then
                SetPickingState(false)
            end
        end))
        table.insert(KeyPicker.Connections, Picker.MouseButton2Click:Connect(MenuTable.Toggle))

        table.insert(KeyPicker.Connections, UserInputService.InputBegan:Connect(function(Input: InputObject)
            if Library.Unloaded then
                return
            end

            local IsMouse = IsMouseClickInput(Input)
            if
                KeyPicker.Mode == "Always"
                or KeyPicker.Value == "Unknown"
                or KeyPicker.Value == "None"
                or Picking
                or Library.IsPicking
                or UserInputService:GetFocusedTextBox()
                or (IsMouse and Library.Toggled)
            then
                return
            end

            local Key = KeyPicker.Value
            local HoldingModifiers = AreModifiersHeld(KeyPicker.Modifiers)
            local HoldingKey = false

            if
                Key
                and HoldingModifiers == true
                and (
                    SpecialKeysInput[Input.UserInputType] == Key
                    or (Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode.Name == Key)
                )
            then
                HoldingKey = true
            end

            if KeyPicker.Mode == "Toggle" then
                if HoldingKey then
                    KeyPicker.Toggled = not KeyPicker.Toggled
                    KeyPicker:DoClick()
                end
            elseif KeyPicker.Mode == "Press" then
                if HoldingKey then
                    KeyPicker:DoClick()
                end
            end

            KeyPicker:Update()
        end))

        table.insert(KeyPicker.Connections, UserInputService.InputEnded:Connect(function(Input: InputObject)
            if Library.Unloaded then
                return
            end

            local IsMouse = IsMouseClickInput(Input)
            if
                KeyPicker.Value == "Unknown"
                or KeyPicker.Value == "None"
                or Picking
                or Library.IsPicking
                or UserInputService:GetFocusedTextBox()
                or (IsMouse and Library.Toggled)
            then
                return
            end

            KeyPicker:Update()
        end))

        KeyPicker:Update()

        if ParentObj.Addons then
            table.insert(ParentObj.Addons, KeyPicker)
        end

        KeyPicker.Default = KeyPicker.Value
        KeyPicker.DefaultModifiers = table.clone(KeyPicker.Modifiers or {})

        function KeyPicker:Destroy()
            if KeyPicker.Destroyed then
                return
            end
            KeyPicker.Destroyed = true
            if Picking then
                Picking = false
                Library.IsPicking = false
                if ParentObj then
                    ParentObj.AnyKeyPickerPicking = false
                end
            end

            if KeyPicker.Connections then
                for _, Connection in KeyPicker.Connections do
                    Connection:Disconnect()
                end
            end

            if KeybindsToggle and KeybindsToggle.Loaded then
                if KeybindsToggle.Holder then 
                    KeybindsToggle.Holder:Destroy()
                end
                local KTIdx = table.find(Library.KeybindToggles, KeybindsToggle)
                if KTIdx then
                    table.remove(Library.KeybindToggles, KTIdx)
                end
            end

            if MenuTable then 
                MenuTable:Destroy() 
            end

            if IsForButton and SlideOverflow then
                if SlideForwardTween then 
                    SlideForwardTween:Destroy() 
                end

                if SlideBackTween then 
                    SlideBackTween:Destroy() 
                end
            end

            if ButtonAddonHolder then
                if
                    ToggleLabel
                    and ToggleLabel.Parent == ButtonAddonHolder
                    and OriginalToggleLabelParent
                    and OriginalToggleLabelParent.Parent
                then
                    ToggleLabel.Parent = OriginalToggleLabelParent
                end
                ButtonAddonHolder:Destroy()
                ButtonAddonHolder = nil
                Picker = nil
            elseif Picker then
                Picker:Destroy()
            end

            if ParentObj and ParentObj.Addons then
                local AddonIdx = table.find(ParentObj.Addons, KeyPicker)
                
                if AddonIdx then 
                    table.remove(ParentObj.Addons, AddonIdx) 
                end
            end

            RemoveStoredObject(Options, KeyPicker)
        end

        RegisterControl(Options, Idx, KeyPicker, "KeyPicker")

        return self
    end

    local HueSequenceTable = {}
    for Hue = 0, 1, 0.1 do
        table.insert(HueSequenceTable, ColorSequenceKeypoint.new(Hue, Color3.fromHSV(Hue, 1, 1)))
    end
    function Funcs:AddColorPicker(Idx, Info)
        if self.Destroyed then return nil end
        assert(Idx ~= nil, "AddColorPicker requires a non-nil index.")

        Info = Library:Validate(Info, Templates.ColorPicker)

        local ParentObj = self
        local ToggleLabel = ParentObj.TextLabel

        local ColorPicker = {
            Connections = {},
            Destroyed = false,

            Value = Info.Default,

            Transparency = Info.Transparency or 0,
            Title = Info.Title,

            Callback = Info.Callback,
            Changed = Info.Changed,

            Type = "ColorPicker",
        }
        ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = ColorPicker.Value:ToHSV()

        local Holder = New("TextButton", {
            BackgroundColor3 = ColorPicker.Value,
            Size = UDim2.fromOffset(18, 18),
            Text = "",
            Parent = ToggleLabel,
        })

        local HolderStroke = New("UIStroke", {
            Color = Library:GetDarkerColor(ColorPicker.Value),
            Parent = Holder,
        })

        local HolderTransparency = New("ImageLabel", {
            Image = CustomImageManager.GetAsset("TransparencyTexture"),
            ImageTransparency = (1 - ColorPicker.Transparency),
            ScaleType = Enum.ScaleType.Tile,
            Position = UDim2.new(0, -1, 0, -1),
            Size = UDim2.new(1, 2, 1, 2),
            TileSize = UDim2.fromOffset(9, 9),
            Parent = Holder,
        })

        --// Color Menu \\--
        local ColorMenu = Library:AddContextMenu(
            Holder,
            UDim2.fromOffset(Info.Transparency and 256 or 234, 0),
            function()
                return { 0.5, Holder.AbsoluteSize.Y + 1.5 }
            end,
            1)
        ColorMenu.List.Padding = UDim.new(0, 8)
        ColorPicker.ColorMenu = ColorMenu

        New("UIPadding", {
            PaddingBottom = UDim.new(0, 6),
            PaddingLeft = UDim.new(0, 6),
            PaddingRight = UDim.new(0, 6),
            PaddingTop = UDim.new(0, 6),
            Parent = ColorMenu.Menu,
        })

        if typeof(ColorPicker.Title) == "string" then
            New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 8),
                Text = ColorPicker.Title,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = ColorMenu.Menu,
            })
        end

        local ColorHolder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 200),
            Parent = ColorMenu.Menu,
        })
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, 6),
            Parent = ColorHolder,
        })

        --// Sat Map
        local SatVipMap = New("ImageButton", {
            BackgroundColor3 = ColorPicker.Value,
            Image = CustomImageManager.GetAsset("SaturationMap"),
            Size = UDim2.fromOffset(200, 200),
            Parent = ColorHolder,
        })

        local SatVibCursor = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = "WhiteColor",
            Size = UDim2.fromOffset(6, 6),
            Parent = SatVipMap,
        })
        New("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = SatVibCursor,
        })
        New("UIStroke", {
            Color = "DarkColor",
            Parent = SatVibCursor,
        })

        --// Hue
        local HueSelector = New("TextButton", {
            Size = UDim2.fromOffset(16, 200),
            Text = "",
            Parent = ColorHolder,
        })
        New("UIGradient", {
            Color = ColorSequence.new(HueSequenceTable),
            Rotation = 90,
            Parent = HueSelector,
        })

        local HueCursor = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = "WhiteColor",
            BorderColor3 = "DarkColor",
            BorderSizePixel = 1,
            Position = UDim2.fromScale(0.5, ColorPicker.Hue),
            Size = UDim2.new(1, 2, 0, 1),
            Parent = HueSelector,
        })

        --// Alpha
        local TransparencySelector, TransparencyColor, TransparencyCursor
        if Info.Transparency then
            TransparencySelector = New("ImageButton", {
                Image = CustomImageManager.GetAsset("TransparencyTexture"),
                ScaleType = Enum.ScaleType.Tile,
                Size = UDim2.fromOffset(16, 200),
                TileSize = UDim2.fromOffset(8, 8),
                Parent = ColorHolder,
            })

            TransparencyColor = New("Frame", {
                BackgroundColor3 = ColorPicker.Value,
                Size = UDim2.fromScale(1, 1),
                Parent = TransparencySelector,
            })
            New("UIGradient", {
                Rotation = 90,
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1),
                }),
                Parent = TransparencyColor,
            })

            TransparencyCursor = New("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = "WhiteColor",
                BorderColor3 = "DarkColor",
                BorderSizePixel = 1,
                Position = UDim2.fromScale(0.5, ColorPicker.Transparency),
                Size = UDim2.new(1, 2, 0, 1),
                Parent = TransparencySelector,
            })
        end

        local InfoHolder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 20),
            Parent = ColorMenu.Menu,
        })
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
            Padding = UDim.new(0, 8),
            Parent = InfoHolder,
        })

        local HueBox = New("TextBox", {
            BackgroundColor3 = "MainColor",
            ClearTextOnFocus = false,
            Size = UDim2.fromScale(1, 1),
            Text = "#??????",
            TextSize = 14,
            Parent = InfoHolder,
        })

        New("UIStroke", {
            Color = "OutlineColor",
            Parent = HueBox,
        })

        local RgbBox = New("TextBox", {
            BackgroundColor3 = "MainColor",
            ClearTextOnFocus = false,
            Size = UDim2.fromScale(1, 1),
            Text = "?, ?, ?",
            TextSize = 14,
            Parent = InfoHolder,
        })

        New("UIStroke", {
            Color = "OutlineColor",
            Parent = RgbBox,
        })

        --// Context Menu \\--
        local ContextMenu = Library:AddContextMenu(Holder, UDim2.fromOffset(93, 0), function()
            return { Holder.AbsoluteSize.X + 1.5, 0.5 }
        end, 1)
        ColorPicker.ContextMenu = ContextMenu
        ContextMenu.List.Padding = UDim.new(0, 6)
        do
            local function CreateButton(Text, Func)
                local Button = New("TextButton", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 21),
                    Text = Text,
                    TextSize = 14,
                    Parent = ContextMenu.Menu,
                })

                Button.MouseButton1Click:Connect(function()
                    Library:SafeCallback(Func)
                    ContextMenu:Close()
                end)
            end

            CreateButton("Copy color", function()
                Library.CopiedColor = { ColorPicker.Value, ColorPicker.Transparency }
            end)

            ColorPicker.SetValueRGB = function(...) end --// make luau lsp shut up
            CreateButton("Paste color", function()
                if typeof(Library.CopiedColor) ~= "table" or typeof(Library.CopiedColor[1]) ~= "Color3" then
                    return
                end

                ColorPicker:SetValueRGB(Library.CopiedColor[1], Library.CopiedColor[2])
            end)

            if setclipboard then
                CreateButton("Copy Hex", function()
                    setclipboard(tostring(ColorPicker.Value:ToHex()))
                end)

                CreateButton("Copy RGB", function()
                    setclipboard(table.concat({
                        math.floor(ColorPicker.Value.R * 255),
                        math.floor(ColorPicker.Value.G * 255),
                        math.floor(ColorPicker.Value.B * 255),
                    }, ", "))
                end)
            end
        end

        --// End \\--
        function ColorPicker:SetHSVFromRGB(Color)
            ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = Color:ToHSV()
        end

        function ColorPicker:Display()
            if Library.Unloaded then
                return
            end

            ColorPicker.Value = Color3.fromHSV(ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib)

            Holder.BackgroundColor3 = ColorPicker.Value
            HolderStroke.Color = Library:GetDarkerColor(ColorPicker.Value)
            HolderTransparency.ImageTransparency = (1 - ColorPicker.Transparency)

            SatVipMap.BackgroundColor3 = Color3.fromHSV(ColorPicker.Hue, 1, 1)
            if TransparencyColor then
                TransparencyColor.BackgroundColor3 = ColorPicker.Value
            end

            SatVibCursor.Position = UDim2.fromScale(ColorPicker.Sat, 1 - ColorPicker.Vib)
            HueCursor.Position = UDim2.fromScale(0.5, ColorPicker.Hue)
            if TransparencyCursor then
                TransparencyCursor.Position = UDim2.fromScale(0.5, ColorPicker.Transparency)
            end

            HueBox.Text = "#" .. ColorPicker.Value:ToHex()
            RgbBox.Text = table.concat({
                math.floor(ColorPicker.Value.R * 255),
                math.floor(ColorPicker.Value.G * 255),
                math.floor(ColorPicker.Value.B * 255),
            }, ", ")
        end

        function ColorPicker:RunChanged()
            Library:SafeCallback(ColorPicker.Callback, ColorPicker.Value)
            Library:SafeCallback(ColorPicker.Changed, ColorPicker.Value)
        end

        function ColorPicker:Update()
            ColorPicker:Display()
            ColorPicker:RunChanged()
        end

        function ColorPicker:OnChanged(Func)
            ColorPicker.Changed = Func
        end

        function ColorPicker:SetValue(HSV, Transparency)
            if typeof(HSV) == "Color3" then
                ColorPicker:SetValueRGB(HSV, Transparency)
                return
            end

            local Color = Color3.fromHSV(HSV[1], HSV[2], HSV[3])
            ColorPicker.Transparency = Info.Transparency and Transparency or 0
            ColorPicker:SetHSVFromRGB(Color)
            ColorPicker:Update()
        end

        function ColorPicker:SetValueRGB(Color, Transparency)
            ColorPicker.Transparency = Info.Transparency and Transparency or 0
            ColorPicker:SetHSVFromRGB(Color)
            ColorPicker:Update()
        end

        table.insert(ColorPicker.Connections, Holder.MouseButton1Click:Connect(ColorMenu.Toggle))
        table.insert(ColorPicker.Connections, Holder.MouseButton2Click:Connect(ContextMenu.Toggle))

        table.insert(ColorPicker.Connections, SatVipMap.InputBegan:Connect(function(Input: InputObject)
            while IsDragInput(Input) and not ColorPicker.Destroyed do
                local MinX = SatVipMap.AbsolutePosition.X
                local MaxX = MinX + SatVipMap.AbsoluteSize.X
                local LocationX = math.clamp(Mouse.X, MinX, MaxX)

                local MinY = SatVipMap.AbsolutePosition.Y
                local MaxY = MinY + SatVipMap.AbsoluteSize.Y
                local LocationY = math.clamp(Mouse.Y, MinY, MaxY)

                local OldSat = ColorPicker.Sat
                local OldVib = ColorPicker.Vib
                ColorPicker.Sat = (LocationX - MinX) / (MaxX - MinX)
                ColorPicker.Vib = 1 - ((LocationY - MinY) / (MaxY - MinY))

                if ColorPicker.Sat ~= OldSat or ColorPicker.Vib ~= OldVib then
                    ColorPicker:Update()
                end

                RunService.RenderStepped:Wait()
            end
        end))

        table.insert(ColorPicker.Connections, HueSelector.InputBegan:Connect(function(Input: InputObject)
            while IsDragInput(Input) and not ColorPicker.Destroyed do
                local Min = HueSelector.AbsolutePosition.Y
                local Max = Min + HueSelector.AbsoluteSize.Y
                local Location = math.clamp(Mouse.Y, Min, Max)

                local OldHue = ColorPicker.Hue
                ColorPicker.Hue = (Location - Min) / (Max - Min)

                if ColorPicker.Hue ~= OldHue then
                    ColorPicker:Update()
                end

                RunService.RenderStepped:Wait()
            end
        end))
        
        if TransparencySelector then
            table.insert(ColorPicker.Connections, TransparencySelector.InputBegan:Connect(function(Input: InputObject)
                while IsDragInput(Input) and not ColorPicker.Destroyed do
                    local Min = TransparencySelector.AbsolutePosition.Y
                    local Max = TransparencySelector.AbsolutePosition.Y + TransparencySelector.AbsoluteSize.Y
                    local Location = math.clamp(Mouse.Y, Min, Max)

                    local OldTransparency = ColorPicker.Transparency
                    ColorPicker.Transparency = (Location - Min) / (Max - Min)

                    if ColorPicker.Transparency ~= OldTransparency then
                        ColorPicker:Update()
                    end

                    RunService.RenderStepped:Wait()
                end
            end))
        end

        table.insert(ColorPicker.Connections, HueBox.FocusLost:Connect(function(Enter)
            if not Enter then
                return
            end

            local Success, Color = pcall(Color3.fromHex, HueBox.Text)
            if Success and typeof(Color) == "Color3" then
                ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = Color:ToHSV()
            end

            ColorPicker:Update()
        end))

        table.insert(ColorPicker.Connections, RgbBox.FocusLost:Connect(function(Enter)
            if not Enter then
                return
            end

            local R, G, B = RgbBox.Text:match("(%d+),%s*(%d+),%s*(%d+)")
            if R and G and B then
                ColorPicker:SetHSVFromRGB(Color3.fromRGB(R, G, B))
            end

            ColorPicker:Update()
        end))

        ColorPicker:Display()

        if ParentObj.Addons then
            table.insert(ParentObj.Addons, ColorPicker)
        end

        ColorPicker.Default = ColorPicker.Value

        function ColorPicker:Destroy()
            if ColorPicker.Destroyed then
                return
            end
            ColorPicker.Destroyed = true

            if ColorPicker.Connections then
                for _, Connection in ColorPicker.Connections do
                    Connection:Disconnect()
                end
            end

            if ColorMenu then 
                ColorMenu:Destroy() 
            end

            if ContextMenu then 
                ContextMenu:Destroy() 
            end

            if Holder then 
                Holder:Destroy() 
            end

            if ParentObj and ParentObj.Addons then
                local AddonIdx = table.find(ParentObj.Addons, ColorPicker)
                
                if AddonIdx then 
                    table.remove(ParentObj.Addons, AddonIdx) 
                end
            end

            RemoveStoredObject(Options, ColorPicker)
        end

        RegisterControl(Options, Idx, ColorPicker, "ColorPicker")

        return self
    end

    BaseAddons.__index = Funcs
    BaseAddons.__namecall = function(_, Key, ...)
        return Funcs[Key](...)
    end
end

local BaseGroupbox = {}
do
    local Funcs = {}

    function Funcs:AddDivider(...)
        if self.Destroyed then return nil end

        local Params = select(1, ...)
        local Text
        local MarginTop = 0
        local MarginBottom = 0

        if typeof(Params) == "table" then
            Text = Params.Text
            MarginTop = Params.MarginTop or Params.Margin or 0
            MarginBottom = Params.MarginBottom or Params.Margin or 0
        elseif typeof(Params) == "string" then
            Text = Params
        end

        local Groupbox = self
        local Container = Groupbox.Container

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 6 + MarginTop + MarginBottom),
            Parent = Container,
        })

        local InnerHolder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Parent = Holder,
        })

        New("UIPadding", {
            PaddingTop = UDim.new(0, MarginTop),
            PaddingBottom = UDim.new(0, MarginBottom),
            Parent = Holder,
        })

        if Text then
            local TextLabel = New("TextLabel", {
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 0),
                Text = Text,
                TextSize = 14,
                TextTransparency = 0.5,
                TextXAlignment = Enum.TextXAlignment.Center,
                Parent = InnerHolder,
            })

            local X, _ = Library:GetTextBounds(Text, TextLabel.FontFace, TextLabel.TextSize, TextLabel.AbsoluteSize.X)
            local SizeX = X // 2 + 10

            New("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = "MainColor",
                BorderColor3 = "OutlineColor",
                BorderSizePixel = 1,
                Position = UDim2.fromScale(0, 0.5),
                Size = UDim2.new(0.5, -SizeX, 0, 2),
                Parent = InnerHolder,
            })
            New("Frame", {
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = "MainColor",
                BorderColor3 = "OutlineColor",
                BorderSizePixel = 1,
                Position = UDim2.fromScale(1, 0.5),
                Size = UDim2.new(0.5, -SizeX, 0, 2),
                Parent = InnerHolder,
            })
        else
            New("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = "MainColor",
                BorderColor3 = "OutlineColor",
                BorderSizePixel = 1,
                Position = UDim2.fromScale(0, 0.5),
                Size = UDim2.new(1, 0, 0, 2),
                Parent = InnerHolder,
            })
        end

        Groupbox:Resize()

        local Divider = {
            Connections = {},
            Destroyed = false,

            Holder = Holder,
            Text = Text,
            MarginTop = MarginTop,
            MarginBottom = MarginBottom,
            Visible = true,
            Type = "Divider",
        }

        function Divider:SetVisible(Value)
            Divider.Visible = Value == true
            Holder.Visible = Divider.Visible
            Groupbox:Resize()
        end

        function Divider:Destroy()
            if Divider.Destroyed then
                return
            end
            Divider.Destroyed = true

            if Divider.Connections then
                for _, Connection in Divider.Connections do
                    Connection:Disconnect()
                end
            end

            if Holder then 
                Holder:Destroy() 
            end

            local ElemIdx = table.find(Groupbox.Elements, Divider)
            if ElemIdx then 
                table.remove(Groupbox.Elements, ElemIdx) 
            end

            Groupbox:Resize()
        end

        table.insert(Groupbox.Elements, Divider)
        return Divider
    end

    function Funcs:AddLabel(...)
        if self.Destroyed then return nil end

        local Data = {}
        local Addons = {}

        local First = select(1, ...)
        local Second = select(2, ...)

        if typeof(First) == "table" or typeof(Second) == "table" then
            local Params = typeof(First) == "table" and First or Second

            Data.Text = Params.Text or ""
            Data.DoesWrap = Params.DoesWrap or false
            Data.Size = Params.Size or 14
            Data.Visible = Params.Visible ~= false
            Data.Idx = typeof(Second) == "table" and First or nil
        else
            Data.Text = First or ""
            Data.DoesWrap = Second or false
            Data.Size = 14
            Data.Visible = true
            Data.Idx = select(3, ...) or nil
        end

        local Groupbox = self
        local Container = Groupbox.Container

        local Label = {
            Connections = {},
            Destroyed = false,

            Text = Data.Text,
            DoesWrap = Data.DoesWrap,

            Addons = Addons,

            Visible = Data.Visible,
            Type = "Label",
        }

        local TextLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 18),
            Text = Label.Text,
            TextSize = Data.Size,
            TextWrapped = Label.DoesWrap,
            TextXAlignment = Groupbox.IsKeyTab and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left,
            Visible = Label.Visible,
            Parent = Container,
        })

        function Label:Display()
            if not Label.DoesWrap then
                return
            end

            local Width = TextLabel.AbsoluteSize.X
            if Width <= 0 then return end

            local _, Y = Library:GetTextBounds(Label.Text, TextLabel.FontFace, TextLabel.TextSize, Width)
            TextLabel.Size = UDim2.new(1, 0, 0, Y + 4)
        end

        function Label:SetVisible(Visible: boolean)
            Label.Visible = Visible

            TextLabel.Visible = Label.Visible
            Groupbox:Resize()
        end

        function Label:SetText(Text: string)
            Label.Text = Text
            TextLabel.Text = Text

            Label:Display()
            Groupbox:Resize()
        end

        if Label.DoesWrap then
            Label:Display()

            local Last = TextLabel.AbsoluteSize
            TextLabel:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                if TextLabel.AbsoluteSize == Last then
                    return
                end

                Label:Display()
                Last = TextLabel.AbsoluteSize

                Groupbox:Resize()
            end)
        else
            New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                Padding = UDim.new(0, 6),
                Parent = TextLabel,
            })
        end

        Groupbox:Resize()

        Label.TextLabel = TextLabel
        Label.Container = Container
        if not Data.DoesWrap then
            setmetatable(Label, BaseAddons)
        end

        Label.Holder = TextLabel
        table.insert(Groupbox.Elements, Label)

        if Data.Idx then
            RegisterControl(Labels, Data.Idx, Label, "Label")
        else
            table.insert(Labels, Label)
        end

        function Label:Destroy()
            if Label.Destroyed then
                return
            end
            Label.Destroyed = true

            if Label.Connections then
                for _, Connection in Label.Connections do
                    Connection:Disconnect()
                end
            end

            if Label.Addons then
                for Index = #Label.Addons, 1, -1 do
                    local Addon = table.remove(Label.Addons, Index)
                    if Addon and Addon.Destroy then
                        Addon:Destroy()
                    end
                end
            end

            if TextLabel then 
                TextLabel:Destroy() 
            end

            local ElemIdx = table.find(Groupbox.Elements, Label)
            if ElemIdx then 
                table.remove(Groupbox.Elements, ElemIdx) 
            end

            Groupbox:Resize()

            if Data.Idx then
                RemoveStoredObject(Labels, Label)
            else
                local LblIdx = table.find(Labels, Label)
                
                if LblIdx then 
                    table.remove(Labels, LblIdx) 
                end
            end
        end

        return Label
    end

    function Funcs:AddButton(...)
        if self.Destroyed then return nil end

        local function GetInfo(...)
            local Info = {}

            local First = select(1, ...)
            local Second = select(2, ...)

            if typeof(First) == "table" or typeof(Second) == "table" then
                local Params = typeof(First) == "table" and First or Second

                Info.Text = Params.Text or ""
                Info.Func = Params.Func or Params.Callback or function() end
                Info.DoubleClick = Params.DoubleClick

                Info.Tooltip = Params.Tooltip
                Info.DisabledTooltip = Params.DisabledTooltip

                Info.Risky = Params.Risky or false
                Info.Disabled = Params.Disabled or false
                Info.Visible = Params.Visible ~= false
                Info.Idx = typeof(Second) == "table" and First or nil
            else
                Info.Text = First or ""
                Info.Func = Second or function() end
                Info.DoubleClick = false

                Info.Tooltip = nil
                Info.DisabledTooltip = nil

                Info.Risky = false
                Info.Disabled = false
                Info.Visible = true
                Info.Idx = select(3, ...) or nil
            end

            return Info
        end
        local Info = GetInfo(...)

        local Groupbox = self
        local Container = Groupbox.Container

        local Button = {
            Connections = {},
            Addons = {},
            Destroyed = false,

            Text = Info.Text,
            Func = Info.Func,
            DoubleClick = Info.DoubleClick,

            Tooltip = Info.Tooltip,
            DisabledTooltip = Info.DisabledTooltip,
            TooltipTable = nil,

            Risky = Info.Risky,
            Disabled = Info.Disabled,
            Visible = Info.Visible,

            Tween = nil,
            Type = "Button",
        }

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 21),
            Visible = Button.Visible,
            Parent = Container,
        })

        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
            Padding = UDim.new(0, 8),
            Parent = Holder,
        })

        local function CreateButton(Button)
            local Base = New("TextButton", {
                Active = not Button.Disabled,
                BackgroundColor3 = Button.Disabled and "BackgroundColor" or "MainColor",
                Size = UDim2.fromScale(1, 1),
                Text = Button.Text,
                TextSize = 14,
                TextTransparency = 0.4,
                Visible = Button.Visible,
                Parent = Holder,
            })

            local Stroke = New("UIStroke", {
                Color = "OutlineColor",
                Transparency = Button.Disabled and 0.5 or 0,
                Parent = Base,
            })
            table.insert(
                Library.Corners,
                TrackCornerMode(New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                    Parent = Base,
                }), "Half")
            )

            return Base, Stroke
        end

        local function UpdateHolderVisibility()
            Holder.Visible = Button.Visible or (Button.SubButton and Button.SubButton.Visible) or false
        end

        local function InitEvents(Button)
            Button.Base.MouseEnter:Connect(function()
                if Button.Disabled then
                    return
                end

                Button.Tween = TweenService:Create(Button.Base, Library.TweenInfo, {
                    TextTransparency = 0,
                })
                Button.Tween:Play()
            end)
            Button.Base.MouseLeave:Connect(function()
                if Button.Disabled then
                    return
                end

                Button.Tween = TweenService:Create(Button.Base, Library.TweenInfo, {
                    TextTransparency = 0.4,
                })
                Button.Tween:Play()
            end)

            Button.Base.MouseButton1Click:Connect(function()
                if Button.Disabled or Button.Locked then
                    return
                end

                if Button.DoubleClick then
                    Button.Locked = true

                    Button.Base.Text = "Are you sure?"
                    Button.Base.TextColor3 = Library.Scheme.AccentColor
                    Library.Registry[Button.Base].TextColor3 = "AccentColor"

                    local Clicked = WaitForEvent(Button.Base.MouseButton1Click, 0.5)

                    Button.Base.Text = Button.Text
                    Button.Base.TextColor3 = Button.Risky and Library.Scheme.RedColor or Library.Scheme.FontColor
                    Library.Registry[Button.Base].TextColor3 = Button.Risky and "RedColor" or "FontColor"

                    if Clicked then
                        Library:SafeCallback(Button.Func)
                    end

                    RunService.RenderStepped:Wait() --// Mouse Button fires without waiting (i hate roblox)
                    Button.Locked = false
                    return
                end

                Library:SafeCallback(Button.Func)
            end)
        end

        Button.Base, Button.Stroke = CreateButton(Button)
        InitEvents(Button)

        function Button:AddButton(...)
            if Button.Destroyed then
                return nil
            end
            if Button.SubButton and not Button.SubButton.Destroyed then
                Button.SubButton:Destroy()
            end

            local Info = GetInfo(...)

            local SubButton = {
                Connections = {},
                Addons = {},
                Destroyed = false,

                Text = Info.Text,
                Func = Info.Func,
                DoubleClick = Info.DoubleClick,

                Tooltip = Info.Tooltip,
                DisabledTooltip = Info.DisabledTooltip,
                TooltipTable = nil,

                Risky = Info.Risky,
                Disabled = Info.Disabled,
                Visible = Info.Visible,

                Tween = nil,
                Type = "SubButton",
            }

            Button.SubButton = SubButton
            SubButton.Base, SubButton.Stroke = CreateButton(SubButton)
            InitEvents(SubButton)
            UpdateHolderVisibility()
            RefreshSearchIfActive()

            function SubButton:UpdateColors()
                if Library.Unloaded then
                    return
                end

                StopTween(SubButton.Tween)

                SubButton.Base.BackgroundColor3 = SubButton.Disabled and Library.Scheme.BackgroundColor
                    or Library.Scheme.MainColor
                SubButton.Base.TextTransparency = SubButton.Disabled and 0.8 or 0.4
                SubButton.Stroke.Transparency = SubButton.Disabled and 0.5 or 0

                Library.Registry[SubButton.Base].BackgroundColor3 = SubButton.Disabled and "BackgroundColor"
                    or "MainColor"
            end

            function SubButton:SetDisabled(Disabled: boolean)
                SubButton.Disabled = Disabled

                if SubButton.TooltipTable then
                    SubButton.TooltipTable.Disabled = SubButton.Disabled
                end

                SubButton.Base.Active = not SubButton.Disabled
                SubButton:UpdateColors()
            end

            function SubButton:SetVisible(Visible: boolean)
                SubButton.Visible = Visible

                SubButton.Base.Visible = SubButton.Visible
                UpdateHolderVisibility()
                Groupbox:Resize()
            end

            function SubButton:SetText(Text: string)
                SubButton.Text = Text
                SubButton.Base.Text = Text
                RefreshSearchIfActive()
            end

            if typeof(SubButton.Tooltip) == "string" or typeof(SubButton.DisabledTooltip) == "string" then
                SubButton.TooltipTable =
                    Library:AddTooltip(SubButton.Tooltip, SubButton.DisabledTooltip, SubButton.Base)
                SubButton.TooltipTable.Disabled = SubButton.Disabled
            end

            if SubButton.Risky then
                SubButton.Base.TextColor3 = Library.Scheme.RedColor
                Library.Registry[SubButton.Base].TextColor3 = "RedColor"
            end

            SubButton:UpdateColors()

            if Info.Idx then
                RegisterControl(Buttons, Info.Idx, SubButton, "Button")
            else
                table.insert(Buttons, SubButton)
            end

            SubButton.AddKeyPicker = BaseAddons.__index.AddKeyPicker

            function SubButton:Destroy()
                if SubButton.Destroyed then
                    return
                end
                SubButton.Destroyed = true

                DestroyObjects(SubButton.Addons)

                if SubButton.TooltipTable then 
                    SubButton.TooltipTable:Destroy() 
                end

                if SubButton.Tween then 
                    SubButton.Tween:Destroy() 
                end

                if SubButton.Base then 
                    SubButton.Base:Destroy() 
                end

                if Button.SubButton == SubButton then
                    Button.SubButton = nil
                    UpdateHolderVisibility()
                end
                RefreshSearchIfActive()

                if Info.Idx then
                    RemoveStoredObject(Buttons, SubButton)
                else
                    local BIdx = table.find(Buttons, SubButton)
                    
                    if BIdx then 
                        table.remove(Buttons, BIdx) 
                    end
                end
            end

            return SubButton
        end

        function Button:UpdateColors()
            if Library.Unloaded then
                return
            end

            StopTween(Button.Tween)

            Button.Base.BackgroundColor3 = Button.Disabled and Library.Scheme.BackgroundColor
                or Library.Scheme.MainColor
            Button.Base.TextTransparency = Button.Disabled and 0.8 or 0.4
            Button.Stroke.Transparency = Button.Disabled and 0.5 or 0

            Library.Registry[Button.Base].BackgroundColor3 = Button.Disabled and "BackgroundColor" or "MainColor"
        end

        function Button:SetDisabled(Disabled: boolean)
            Button.Disabled = Disabled

            if Button.TooltipTable then
                Button.TooltipTable.Disabled = Button.Disabled
            end

            Button.Base.Active = not Button.Disabled
            Button:UpdateColors()
        end

        function Button:SetVisible(Visible: boolean)
            Button.Visible = Visible

            Button.Base.Visible = Button.Visible
            UpdateHolderVisibility()
            Groupbox:Resize()
        end

        function Button:SetText(Text: string)
            Button.Text = Text
            Button.Base.Text = Text
            RefreshSearchIfActive()
        end

        if typeof(Button.Tooltip) == "string" or typeof(Button.DisabledTooltip) == "string" then
            Button.TooltipTable = Library:AddTooltip(Button.Tooltip, Button.DisabledTooltip, Button.Base)
            Button.TooltipTable.Disabled = Button.Disabled
        end

        if Button.Risky then
            Button.Base.TextColor3 = Library.Scheme.RedColor
            Library.Registry[Button.Base].TextColor3 = "RedColor"
        end

        Button:UpdateColors()
        Groupbox:Resize()

        Button.Holder = Holder
        table.insert(Groupbox.Elements, Button)

        if Info.Idx then
            RegisterControl(Buttons, Info.Idx, Button, "Button")
        else
            table.insert(Buttons, Button)
        end

        Button.AddKeyPicker = BaseAddons.__index.AddKeyPicker

        function Button:Destroy()
            if Button.Destroyed then
                return
            end
            Button.Destroyed = true

            DestroyObjects(Button.Addons)

            if Button.TooltipTable then 
                Button.TooltipTable:Destroy() 
            end

            if Button.Tween then 
                Button.Tween:Destroy() 
            end

            if Button.SubButton then 
                Button.SubButton:Destroy() 
            end

            if Holder then 
                Holder:Destroy() 
            end

            local ElemIdx = table.find(Groupbox.Elements, Button)
            if ElemIdx then 
                table.remove(Groupbox.Elements, ElemIdx) 
            end

            Groupbox:Resize()

            if Info.Idx then
                RemoveStoredObject(Buttons, Button)
            else
                local BIdx = table.find(Buttons, Button)
                
                if BIdx then 
                    table.remove(Buttons, BIdx) 
                end
            end
        end

        return Button
    end

    function Funcs:AddCheckbox(Idx, Info)
        if self.Destroyed then return nil end
        assert(Idx ~= nil, "AddCheckbox requires a non-nil index.")

        Info = Library:Validate(Info, Templates.Toggle)

        local Groupbox = self
        local Container = Groupbox.Container

        local Toggle = {
            Connections = {},
            Destroyed = false,

            Text = Info.Text,
            Value = Info.Default,

            Tooltip = Info.Tooltip,
            DisabledTooltip = Info.DisabledTooltip,
            TooltipTable = nil,

            Callback = Info.Callback,
            Changed = Info.Changed,

            Risky = Info.Risky,
            Disabled = Info.Disabled,
            Visible = Info.Visible,

            Addons = {},
            AnyKeyPickerPicking = false,

            Variant = "Checkbox",
            Type = "Toggle",
        }

        local Button = New("TextButton", {
            Active = not Toggle.Disabled,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 20),
            Text = "",
            Visible = Toggle.Visible,
            Parent = Container,
        })

        local Label = New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(26, 0),
            Size = UDim2.new(1, -26, 1, 0),
            Text = Toggle.Text,
            TextSize = 14,
            TextTransparency = 0.4,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Button,
        })

        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = UDim.new(0, 6),
            Parent = Label,
        })

        local Checkbox = New("Frame", {
            BackgroundColor3 = "MainColor",
            Size = UDim2.fromScale(1, 1),
            SizeConstraint = Enum.SizeConstraint.RelativeYY,
            Parent = Button,
        })
        New("UICorner", {
            CornerRadius = UDim.new(0, 2),
            Parent = Checkbox,
        })

        local CheckboxStroke = New("UIStroke", {
            Color = "OutlineColor",
            Parent = Checkbox,
        })

        local CheckImage = New("ImageLabel", {
            Image = CheckIcon and CheckIcon.Url or "",
            ImageColor3 = "FontColor",
            ImageRectOffset = CheckIcon and CheckIcon.ImageRectOffset or Vector2.zero,
            ImageRectSize = CheckIcon and CheckIcon.ImageRectSize or Vector2.zero,
            ImageTransparency = 1,
            Position = UDim2.fromOffset(2, 2),
            Size = UDim2.new(1, -4, 1, -4),
            Parent = Checkbox,
        })

        function Toggle:UpdateColors()
            Toggle:Display()
        end

        function Toggle:Display()
            if Library.Unloaded then
                return
            end

            CheckboxStroke.Transparency = Toggle.Disabled and 0.5 or 0

            if Toggle.Disabled then
                Label.TextTransparency = 0.8
                CheckImage.ImageTransparency = Toggle.Value and 0.8 or 1

                Checkbox.BackgroundColor3 = Library.Scheme.BackgroundColor
                Library.Registry[Checkbox].BackgroundColor3 = "BackgroundColor"

                return
            end

            TweenService:Create(Label, Library.TweenInfo, {
                TextTransparency = Toggle.Value and 0 or 0.4,
            }):Play()
            TweenService:Create(CheckImage, Library.TweenInfo, {
                ImageTransparency = Toggle.Value and 0 or 1,
            }):Play()

            Checkbox.BackgroundColor3 = Library.Scheme.MainColor
            Library.Registry[Checkbox].BackgroundColor3 = "MainColor"
        end

        function Toggle:OnChanged(Func)
            Toggle.Changed = Func
        end

        function Toggle:RunChanged()
            Library:SafeCallback(Toggle.Callback, Toggle.Value)
            Library:SafeCallback(Toggle.Changed, Toggle.Value)
        end

        function Toggle:SetValue(Value)
            Toggle.Value = Value
            Toggle:Display()

            for _, Addon in Toggle.Addons do
                if Addon.Type == "KeyPicker" and Addon.SyncToggleState then
                    Addon.Toggled = Toggle.Value
                    Addon:Update()
                end
            end

            Library:UpdateDependencyBoxes()

            if not Toggle.AnyKeyPickerPicking then
                Toggle:RunChanged()
            end
        end

        function Toggle:SetDisabled(Disabled: boolean)
            Toggle.Disabled = Disabled

            if Toggle.TooltipTable then
                Toggle.TooltipTable.Disabled = Toggle.Disabled
            end

            for _, Addon in Toggle.Addons do
                if Addon.Type == "KeyPicker" and Addon.SyncToggleState then
                    Addon:Update()
                end
            end

            Button.Active = not Toggle.Disabled
            Toggle:Display()
        end

        function Toggle:SetVisible(Visible: boolean)
            Toggle.Visible = Visible

            Button.Visible = Toggle.Visible
            Groupbox:Resize()
        end

        function Toggle:SetText(Text: string)
            Toggle.Text = Text
            Label.Text = Text
            RefreshSearchIfActive()
        end

        table.insert(Toggle.Connections, Button.MouseButton1Click:Connect(function()
            if Toggle.Disabled then
                return
            end

            Toggle:SetValue(not Toggle.Value)
        end))

        if typeof(Toggle.Tooltip) == "string" or typeof(Toggle.DisabledTooltip) == "string" then
            Toggle.TooltipTable = Library:AddTooltip(Toggle.Tooltip, Toggle.DisabledTooltip, Button)
            Toggle.TooltipTable.Disabled = Toggle.Disabled
        end

        if Toggle.Risky then
            Label.TextColor3 = Library.Scheme.RedColor
            Library.Registry[Label].TextColor3 = "RedColor"
        end

        Toggle:Display()
        Groupbox:Resize()

        Toggle.TextLabel = Label
        Toggle.Container = Container
        setmetatable(Toggle, BaseAddons)

        Toggle.Holder = Button
        table.insert(Groupbox.Elements, Toggle)

        Toggle.Default = Toggle.Value

        RegisterControl(Toggles, Idx, Toggle, "Toggle")

        function Toggle:Destroy()
            if Toggle.Destroyed then
                return
            end
            Toggle.Destroyed = true

            if Toggle.Connections then
                for _, Connection in Toggle.Connections do
                    Connection:Disconnect()
                end
            end

            if Toggle.TooltipTable then 
                Toggle.TooltipTable:Destroy() 
            end

            if Button then 
                Button:Destroy() 
            end

            if Toggle.Addons then
                for Index = #Toggle.Addons, 1, -1 do
                    local Addon = table.remove(Toggle.Addons, Index)
                    if Addon and Addon.Destroy then
                        Addon:Destroy()
                    end
                end
            end

            local ElemIdx = table.find(Groupbox.Elements, Toggle)
            if ElemIdx then 
                table.remove(Groupbox.Elements, ElemIdx) 
            end

            Groupbox:Resize()
            RemoveStoredObject(Toggles, Toggle)
        end

        return Toggle
    end

    function Funcs:AddToggle(Idx, Info)
        if self.Destroyed then return nil end
        assert(Idx ~= nil, "AddToggle requires a non-nil index.")

        if Library.ForceCheckbox then
            return Funcs.AddCheckbox(self, Idx, Info)
        end

        Info = Library:Validate(Info, Templates.Toggle)

        local Groupbox = self
        local Container = Groupbox.Container

        local Toggle = {
            Connections = {},
            Destroyed = false,

            Text = Info.Text,
            Value = Info.Default,

            Tooltip = Info.Tooltip,
            DisabledTooltip = Info.DisabledTooltip,
            TooltipTable = nil,

            Callback = Info.Callback,
            Changed = Info.Changed,

            Risky = Info.Risky,
            Disabled = Info.Disabled,
            Visible = Info.Visible,

            Addons = {},
            AnyKeyPickerPicking = false,

            Variant = "Switch",
            Type = "Toggle",
        }

        local Button = New("TextButton", {
            Active = not Toggle.Disabled,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 18),
            Text = "",
            Visible = Toggle.Visible,
            Parent = Container,
        })

        local Label = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -44, 1, 0),
            Text = Toggle.Text,
            TextSize = 14,
            TextTransparency = 0.4,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Button,
        })

        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = UDim.new(0, 6),
            Parent = Label,
        })

        local Switch = New("Frame", {
            AnchorPoint = Vector2.new(1, 0),
            BackgroundColor3 = "MainColor",
            Position = UDim2.fromScale(1, 0),
            Size = UDim2.fromOffset(36, 20),
            Parent = Button,
        })
        New("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = Switch,
        })
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 2),
            PaddingLeft = UDim.new(0, 2),
            PaddingRight = UDim.new(0, 2),
            PaddingTop = UDim.new(0, 2),
            Parent = Switch,
        })
        local SwitchStroke = New("UIStroke", {
            Color = "OutlineColor",
            Parent = Switch,
        })

        local Ball = New("Frame", {
            BackgroundColor3 = "FontColor",
            Size = UDim2.fromScale(1, 1),
            SizeConstraint = Enum.SizeConstraint.RelativeYY,
            Parent = Switch,
        })
        New("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = Ball,
        })

        function Toggle:UpdateColors()
            Toggle:Display()
        end

        function Toggle:Display()
            if Library.Unloaded then
                return
            end

            local Offset = Toggle.Value and 1 or 0

            Switch.BackgroundTransparency = Toggle.Disabled and 0.75 or 0
            SwitchStroke.Transparency = Toggle.Disabled and 0.75 or 0

            Switch.BackgroundColor3 = Toggle.Value and Library.Scheme.AccentColor or Library.Scheme.MainColor
            SwitchStroke.Color = Toggle.Value and Library.Scheme.AccentColor or Library.Scheme.OutlineColor

            Library.Registry[Switch].BackgroundColor3 = Toggle.Value and "AccentColor" or "MainColor"
            Library.Registry[SwitchStroke].Color = Toggle.Value and "AccentColor" or "OutlineColor"

            if Toggle.Disabled then
                Label.TextTransparency = 0.8
                Ball.AnchorPoint = Vector2.new(Offset, 0)
                Ball.Position = UDim2.fromScale(Offset, 0)

                Ball.BackgroundColor3 = Library:GetDarkerColor(Library.Scheme.FontColor)
                Library.Registry[Ball].BackgroundColor3 = function()
                    return Library:GetDarkerColor(Library.Scheme.FontColor)
                end

                return
            end

            TweenService:Create(Label, Library.TweenInfo, {
                TextTransparency = Toggle.Value and 0 or 0.4,
            }):Play()
            TweenService:Create(Ball, Library.TweenInfo, {
                AnchorPoint = Vector2.new(Offset, 0),
                Position = UDim2.fromScale(Offset, 0),
            }):Play()

            Ball.BackgroundColor3 = Toggle.Value and Library.Scheme.BackgroundColor or Library.Scheme.FontColor
            Library.Registry[Ball].BackgroundColor3 = Toggle.Value and "BackgroundColor" or "FontColor"
        end

        function Toggle:OnChanged(Func)
            Toggle.Changed = Func
        end

        function Toggle:RunChanged()
            Library:SafeCallback(Toggle.Callback, Toggle.Value)
            Library:SafeCallback(Toggle.Changed, Toggle.Value)
        end

        function Toggle:SetValue(Value)
            Toggle.Value = Value
            Toggle:Display()

            for _, Addon in Toggle.Addons do
                if Addon.Type == "KeyPicker" and Addon.SyncToggleState then
                    Addon.Toggled = Toggle.Value
                    Addon:Update()
                end
            end

            Library:UpdateDependencyBoxes()

            if not Toggle.AnyKeyPickerPicking then
                Toggle:RunChanged()
            end
        end

        function Toggle:SetDisabled(Disabled: boolean)
            Toggle.Disabled = Disabled

            if Toggle.TooltipTable then
                Toggle.TooltipTable.Disabled = Toggle.Disabled
            end

            for _, Addon in Toggle.Addons do
                if Addon.Type == "KeyPicker" and Addon.SyncToggleState then
                    Addon:Update()
                end
            end

            Button.Active = not Toggle.Disabled
            Toggle:Display()
        end

        function Toggle:SetVisible(Visible: boolean)
            Toggle.Visible = Visible

            Button.Visible = Toggle.Visible
            Groupbox:Resize()
        end

        function Toggle:SetText(Text: string)
            Toggle.Text = Text
            Label.Text = Text
            RefreshSearchIfActive()
        end

        table.insert(Toggle.Connections, Button.MouseButton1Click:Connect(function()
            if Toggle.Disabled then
                return
            end

            Toggle:SetValue(not Toggle.Value)
        end))

        if typeof(Toggle.Tooltip) == "string" or typeof(Toggle.DisabledTooltip) == "string" then
            Toggle.TooltipTable = Library:AddTooltip(Toggle.Tooltip, Toggle.DisabledTooltip, Button)
            Toggle.TooltipTable.Disabled = Toggle.Disabled
        end

        if Toggle.Risky then
            Label.TextColor3 = Library.Scheme.RedColor
            Library.Registry[Label].TextColor3 = "RedColor"
        end

        Toggle:Display()
        Groupbox:Resize()

        Toggle.TextLabel = Label
        Toggle.Container = Container
        setmetatable(Toggle, BaseAddons)

        Toggle.Holder = Button
        table.insert(Groupbox.Elements, Toggle)

        Toggle.Default = Toggle.Value

        RegisterControl(Toggles, Idx, Toggle, "Checkbox")

        function Toggle:Destroy()
            if Toggle.Destroyed then
                return
            end
            Toggle.Destroyed = true

            if Toggle.Connections then
                for _, Connection in Toggle.Connections do
                    Connection:Disconnect()
                end
            end

            if Toggle.TooltipTable then 
                Toggle.TooltipTable:Destroy() 
            end

            if Button then 
                Button:Destroy() 
            end

            if Toggle.Addons then
                for Index = #Toggle.Addons, 1, -1 do
                    local Addon = table.remove(Toggle.Addons, Index)
                    if Addon and Addon.Destroy then
                        Addon:Destroy()
                    end
                end
            end

            local ElemIdx = table.find(Groupbox.Elements, Toggle)
            if ElemIdx then 
                table.remove(Groupbox.Elements, ElemIdx) 
            end

            Groupbox:Resize()
            RemoveStoredObject(Toggles, Toggle)
        end

        return Toggle
    end

    function Funcs:AddInput(Idx, Info)
        if self.Destroyed then return nil end
        assert(Idx ~= nil, "AddInput requires a non-nil index.")

        Info = Library:Validate(Info, Templates.Input)
        if typeof(Info.VerifyValue) == "function" and Info.Finished ~= true then
            Info.Finished = true
        end

        local Groupbox = self
        local Container = Groupbox.Container

        local Input = {
            Connections = {},
            Destroyed = false,

            Text = Info.Text,
            Value = Info.Default,

            Finished = Info.Finished,
            Numeric = Info.Numeric,
            ClearTextOnFocus = Info.ClearTextOnFocus,
            ClearTextOnBlur = Info.ClearTextOnBlur,
            Placeholder = Info.Placeholder,
            AllowEmpty = Info.AllowEmpty,
            EmptyReset = Info.EmptyReset,

            Tooltip = Info.Tooltip,
            DisabledTooltip = Info.DisabledTooltip,
            TooltipTable = nil,

            Callback = Info.Callback,
            Changed = Info.Changed,
            VerifyValue = Info.VerifyValue,

            Disabled = Info.Disabled,
            Visible = Info.Visible,

            Type = "Input",
        }

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 39),
            Visible = Input.Visible,
            Parent = Container,
        })

        local Label = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 14),
            Text = Input.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Holder,
        })

        local Box = New("TextBox", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = "MainColor",
            ClearTextOnFocus = not Input.Disabled and Input.ClearTextOnFocus,
            PlaceholderText = Input.Placeholder,
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.new(1, 0, 0, 21),
            Text = Input.Value,
            TextEditable = not Input.Disabled,
            TextScaled = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Holder,
        })

        New("UIPadding", {
            PaddingBottom = UDim.new(0, 3),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 4),
            Parent = Box,
        })

        New("UIStroke", {
            Color = "OutlineColor",
            Parent = Box,
        })
        table.insert(
            Library.Corners,
            TrackCornerMode(New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = Box,
            }), "Half")
        )

        function Input:UpdateColors()
            if Library.Unloaded then
                return
            end

            Label.TextTransparency = Input.Disabled and 0.8 or 0
            Box.TextTransparency = Input.Disabled and 0.8 or 0
        end

        function Input:OnChanged(Func)
            Input.Changed = Func
        end

        function Input:RunChanged()
            Library:SafeCallback(Input.Callback, Input.Value)
            Library:SafeCallback(Input.Changed, Input.Value)
        end

        function Input:SetValue(Text)
            Text = tostring(Text or "")

            if not Input.AllowEmpty and Trim(Text) == "" then
                Text = Input.EmptyReset
            end

            if Info.MaxLength and #Text > Info.MaxLength then
                Text = Text:sub(1, Info.MaxLength)
            end

            if Input.Numeric then
                if #tostring(Text) > 0 and not tonumber(Text) then
                    Text = Input.Value
                end
            end

            if typeof(Info.VerifyValue) == "function" and (Text ~= Input.EmptyReset and Info.VerifyValue(Text) ~= true) then
                Text = Input.EmptyReset
            end

            Input.Value = Text
            Box.Text = Text

            if not Input.Disabled then
                Input:RunChanged()
            end
        end

        function Input:SetDisabled(Disabled: boolean)
            Input.Disabled = Disabled

            if Input.TooltipTable then
                Input.TooltipTable.Disabled = Input.Disabled
            end

            Box.ClearTextOnFocus = not Input.Disabled and Input.ClearTextOnFocus
            Box.TextEditable = not Input.Disabled
            Input:UpdateColors()
        end

        function Input:SetVisible(Visible: boolean)
            Input.Visible = Visible

            Holder.Visible = Input.Visible
            Groupbox:Resize()
        end

        function Input:SetText(Text: string)
            Input.Text = Text
            Label.Text = Text
            RefreshSearchIfActive()
        end

        if Input.Finished then
            table.insert(Input.Connections, Box.FocusLost:Connect(function(Enter)
                if not Enter then
                    if Input.ClearTextOnBlur then
                        Box.Text = Input.Value
                    end

                    return
                end

                Input:SetValue(Box.Text)
            end))
        else
            table.insert(Input.Connections, Box:GetPropertyChangedSignal("Text"):Connect(function()
                if Box.Text == Input.Value then return end

                if Input.Numeric and (Box.Text == "-" or Box.Text == "." or Box.Text == "-.") then
                    return
                end
                Input:SetValue(Box.Text)
            end))

            if Input.Numeric then
                table.insert(Input.Connections, Box.FocusLost:Connect(function()
                    if Box.Text == "-" or Box.Text == "." or Box.Text == "-." then
                        Box.Text = Input.Value
                    end
                end))
            end
        end

        if typeof(Input.Tooltip) == "string" or typeof(Input.DisabledTooltip) == "string" then
            Input.TooltipTable = Library:AddTooltip(Input.Tooltip, Input.DisabledTooltip, Box)
            Input.TooltipTable.Disabled = Input.Disabled
        end

        Groupbox:Resize()

        Input.Holder = Holder
        table.insert(Groupbox.Elements, Input)

        Input.Default = Input.Value
        if typeof(Info.VerifyValue) == "function" and (Input.Default ~= Input.EmptyReset and Info.VerifyValue(Input.Default) ~= true) then
            Input:SetValue(Input.EmptyReset)
            Input.Default = Input.EmptyReset
        end
        
        RegisterControl(Options, Idx, Input, "Input")

        function Input:Destroy()
            if Input.Destroyed then
                return
            end
            Input.Destroyed = true

            if Input.Connections then
                for _, Connection in Input.Connections do
                    Connection:Disconnect()
                end
            end

            if Input.TooltipTable then 
                Input.TooltipTable:Destroy() 
            end

            if Holder then 
                Holder:Destroy() 
            end

            local ElemIdx = table.find(Groupbox.Elements, Input)
            if ElemIdx then 
                table.remove(Groupbox.Elements, ElemIdx) 
            end

            Groupbox:Resize()
            RemoveStoredObject(Options, Input)
        end

        return Input
    end

    function Funcs:AddSlider(Idx, Info)
        if self.Destroyed then return nil end
        assert(Idx ~= nil, "AddSlider requires a non-nil index.")

        Info = Library:Validate(Info, Templates.Slider)
        assert(typeof(Info.Min) == "number" and typeof(Info.Max) == "number", "Slider Min and Max must be numbers.")
        assert(Info.Max > Info.Min, "Slider Max must be greater than Min.")
        assert(
            typeof(Info.Rounding) == "number" and Info.Rounding >= 0 and Info.Rounding % 1 == 0,
            "Slider Rounding must be a non-negative integer."
        )

        Info.Default = math.clamp(
            Round(math.clamp(tonumber(Info.Default) or Info.Min, Info.Min, Info.Max), Info.Rounding),
            Info.Min,
            Info.Max
        )

        local Groupbox = self
        local Container = Groupbox.Container

        local Slider = {
            Connections = {},
            Destroyed = false,

            Text = Info.Text,
            Value = Info.Default,

            Min = Info.Min,
            Max = Info.Max,

            Prefix = Info.Prefix,
            Suffix = Info.Suffix,
            Compact = Info.Compact,
            Rounding = Info.Rounding,
            HideMax = Info.HideMax,

            Tooltip = Info.Tooltip,
            DisabledTooltip = Info.DisabledTooltip,
            TooltipTable = nil,

            Callback = Info.Callback,
            Changed = Info.Changed,

            Disabled = Info.Disabled,
            Visible = Info.Visible,

            AllowRightClickInput = Info.AllowRightClickInput,

            Type = "Slider",
        }

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, Info.Compact and 15 or 33),
            Visible = Slider.Visible,
            Parent = Container,
        })

        local SliderLabel
        if not Info.Compact then
            SliderLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 14),
                Text = Slider.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Holder,
            })
        end

        local Bar = New("TextButton", {
            Active = not Slider.Disabled,
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = "MainColor",
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.new(1, 0, 0, 15),
            Text = "",
            Parent = Holder,
        })

        New("UIStroke", {
            Color = "OutlineColor",
            Parent = Bar,
        })
        table.insert(
            Library.Corners,
            TrackCornerMode(New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = Bar,
            }), "Half")
        )

        local DisplayLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Text = "",
            TextSize = 14,
            ZIndex = Bar.ZIndex + 2,
            Parent = Bar,
        })
        New("UIStroke", {
            ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
            Color = "DarkColor",
            LineJoinMode = Enum.LineJoinMode.Miter,
            Parent = DisplayLabel,
        })

        local InputTextBox
        if Info.AllowRightClickInput then
            InputTextBox = New("TextBox", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Text = "",
                TextSize = 14,
                ZIndex = Bar.ZIndex + 3,
                Visible = false,
                ClearTextOnFocus = false,
                Parent = Bar,
            })
            New("UIStroke", {
                ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
                Color = "DarkColor",
                LineJoinMode = Enum.LineJoinMode.Miter,
                Parent = InputTextBox,
            })
        end

        local Fill = New("Frame", {
            BackgroundColor3 = "AccentColor",
            Size = UDim2.fromScale(0.5, 1),
            ZIndex = Bar.ZIndex + 1,
            Parent = Bar,
        })
        table.insert(
            Library.Corners,
            TrackCornerMode(New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = Fill,
            }), "Half")
        )

        function Slider:UpdateColors()
            if Library.Unloaded then
                return
            end

            if SliderLabel then
                SliderLabel.TextTransparency = Slider.Disabled and 0.8 or 0
            end
            DisplayLabel.TextTransparency = Slider.Disabled and 0.8 or 0
            
            if Info.AllowRightClickInput then
                InputTextBox.TextTransparency = Slider.Disabled and 0.8 or 0
            end

            Fill.BackgroundColor3 = Slider.Disabled and Library.Scheme.OutlineColor or Library.Scheme.AccentColor
            Library.Registry[Fill].BackgroundColor3 = Slider.Disabled and "OutlineColor" or "AccentColor"
        end

        function Slider:Display()
            if Library.Unloaded then
                return
            end

            local CustomDisplayText = nil
            if Info.FormatDisplayValue then
                CustomDisplayText = Info.FormatDisplayValue(Slider, Slider.Value)
            end

            if CustomDisplayText then
                DisplayLabel.Text = tostring(CustomDisplayText)
            else
                if Info.Compact then
                    DisplayLabel.Text =
                        string.format("%s: %s%s%s", Slider.Text, Slider.Prefix, Slider.Value, Slider.Suffix)
                elseif Info.HideMax then
                    DisplayLabel.Text = string.format("%s%s%s", Slider.Prefix, Slider.Value, Slider.Suffix)
                else
                    DisplayLabel.Text = string.format(
                        "%s%s%s/%s%s%s",
                        Slider.Prefix,
                        Slider.Value,
                        Slider.Suffix,
                        Slider.Prefix,
                        Slider.Max,
                        Slider.Suffix
                    )
                end
            end

            local X = (Slider.Value - Slider.Min) / (Slider.Max - Slider.Min)
            Fill.Size = UDim2.fromScale(X, 1)
        end

        function Slider:OnChanged(Func)
            Slider.Changed = Func
        end

        function Slider:SetMax(Value)
            assert(Value > Slider.Min, "Max value cannot be less than the current min value.")

            Slider:SetValue(math.clamp(Slider.Value, Slider.Min, Value))
            Slider.Max = Value
            Slider:Display()
        end

        function Slider:SetMin(Value)
            assert(Value < Slider.Max, "Min value cannot be greater than the current max value.")

            Slider:SetValue(math.clamp(Slider.Value, Value, Slider.Max))
            Slider.Min = Value
            Slider:Display()
        end

        function Slider:RunChanged()
            Library:SafeCallback(Slider.Callback, Slider.Value)
            Library:SafeCallback(Slider.Changed, Slider.Value)
        end

        function Slider:SetValue(Str)
            local Num = tonumber(Str)
            if not Num or Num == Slider.Value then
                return
            end

            Num = math.clamp(Round(math.clamp(Num, Slider.Min, Slider.Max), Slider.Rounding), Slider.Min, Slider.Max)

            Slider.Value = Num
            Slider:Display()

            Slider:RunChanged()
        end

        function Slider:SetDisabled(Disabled: boolean)
            Slider.Disabled = Disabled

            if Slider.TooltipTable then
                Slider.TooltipTable.Disabled = Slider.Disabled
            end

            Bar.Active = not Slider.Disabled
            Slider:UpdateColors()
        end

        function Slider:SetVisible(Visible: boolean)
            Slider.Visible = Visible

            Holder.Visible = Slider.Visible
            Groupbox:Resize()
        end

        function Slider:SetText(Text: string)
            Slider.Text = Text
            if SliderLabel then
                SliderLabel.Text = Text
                RefreshSearchIfActive()
                return
            end
            Slider:Display()
            RefreshSearchIfActive()
        end

        function Slider:SetPrefix(Prefix: string)
            Slider.Prefix = Prefix
            Slider:Display()
        end

        function Slider:SetSuffix(Suffix: string)
            Slider.Suffix = Suffix
            Slider:Display()
        end

        if Info.AllowRightClickInput then
            local LastValidText = ""
            table.insert(Slider.Connections, InputTextBox:GetPropertyChangedSignal("Text"):Connect(function()
                local Text = InputTextBox.Text
                local AsNum = tonumber(Text)

                if #tostring(Text) > 0 and not AsNum and Text ~= "-" then
                    InputTextBox.Text = LastValidText
                else
                    if Slider.Rounding == 0 and Text:find("%.") then
                        InputTextBox.Text = LastValidText
                        return
                    end

                    local DecimalPos = Text:find("%.")
                    if DecimalPos and Slider.Rounding > 0 then
                        local Decimals = #Text - DecimalPos
                        if Decimals > Slider.Rounding then
                            InputTextBox.Text = LastValidText
                            return
                        end
                    end

                    LastValidText = Text

                    if AsNum then
                        if AsNum > Slider.Max then
                            InputTextBox.Text = tostring(Slider.Max)
                        elseif AsNum < Slider.Min then
                            InputTextBox.Text = tostring(Slider.Min)
                        end
                    end
                end
            end))

            table.insert(Slider.Connections, InputTextBox.FocusLost:Connect(function()
                InputTextBox.Visible = false
                DisplayLabel.Visible = true

                local Num = tonumber(InputTextBox.Text)
                if not Num then
                    return
                end

                Num = Round(Num, Slider.Rounding)
                Slider:SetValue(Num)
            end))
        end

        local LastTap = 0
        table.insert(Slider.Connections, Bar.InputBegan:Connect(function(Input: InputObject)
            local ValidInput = IsClickInput(Input) or Input.UserInputType == Enum.UserInputType.MouseButton2
            if not ValidInput or Slider.Disabled then
                return
            end

            if Info.AllowRightClickInput then
                local IsRightClick = Input.UserInputType == Enum.UserInputType.MouseButton2
                local IsDoubleTap = false

                if Library.IsMobile and Input.UserInputType == Enum.UserInputType.Touch then
                    if tick() - LastTap < 0.3 then
                        IsDoubleTap = true
                    end
                    
                    LastTap = tick()
                end

                if IsRightClick or IsDoubleTap then
                    InputTextBox.Text = tostring(Slider.Value)
                    InputTextBox.Visible = true
                    DisplayLabel.Visible = false

                    task.spawn(InputTextBox.CaptureFocus, InputTextBox)
                    return
                end
            end

            if not IsClickInput(Input) then
                return
            end

            local ScrollingStates = {}
            local function DisableScrolling(Frame)
                if Frame and ScrollingStates[Frame] == nil then
                    ScrollingStates[Frame] = Frame.ScrollingEnabled
                    Frame.ScrollingEnabled = false
                end
            end

            local ActiveScope = Groupbox.Tab or Library.ActiveTab
            if ActiveScope and ActiveScope.Sides then
                for _, Side in ActiveScope.Sides do
                    DisableScrolling(Side)
                end
            end

            if Library.ActiveLoading and Library.ActiveLoading.Sidebar then
                DisableScrolling(Library.ActiveLoading.Sidebar.Container)
            end

            while IsDragInput(Input) and not Slider.Destroyed do
                local Location = Mouse.X
                local Scale = math.clamp((Location - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)

                local OldValue = Slider.Value
                Slider.Value = math.clamp(
                    Round(Slider.Min + ((Slider.Max - Slider.Min) * Scale), Slider.Rounding),
                    Slider.Min,
                    Slider.Max
                )

                Slider:Display()
                if Slider.Value ~= OldValue then
                    Slider:RunChanged()
                end

                RunService.RenderStepped:Wait()
            end

            for Frame, WasEnabled in ScrollingStates do
                if Frame.Parent then
                    Frame.ScrollingEnabled = WasEnabled
                end
            end
        end))

        if typeof(Slider.Tooltip) == "string" or typeof(Slider.DisabledTooltip) == "string" then
            Slider.TooltipTable = Library:AddTooltip(Slider.Tooltip, Slider.DisabledTooltip, Bar)
            Slider.TooltipTable.Disabled = Slider.Disabled
        end

        Slider:UpdateColors()
        Slider:Display()
        Groupbox:Resize()

        Slider.Holder = Holder
        table.insert(Groupbox.Elements, Slider)

        Slider.Default = Slider.Value

        RegisterControl(Options, Idx, Slider, "Slider")

        function Slider:Destroy()
            if Slider.Destroyed then
                return
            end
            Slider.Destroyed = true

            if Slider.Connections then
                for _, Connection in Slider.Connections do
                    Connection:Disconnect()
                end
            end

            if Slider.TooltipTable then 
                Slider.TooltipTable:Destroy() 
            end

            if Holder then 
                Holder:Destroy() 
            end

            local ElemIdx = table.find(Groupbox.Elements, Slider)
            if ElemIdx then 
                table.remove(Groupbox.Elements, ElemIdx) 
            end

            Groupbox:Resize()
            RemoveStoredObject(Options, Slider)
        end

        return Slider
    end

    function Funcs:AddDropdown(Idx, Info)
        if self.Destroyed then return nil end
        assert(Idx ~= nil, "AddDropdown requires a non-nil index.")

        Info = Library:Validate(Info, Templates.Dropdown)
        assert(typeof(Info.Values) == "table", "Dropdown Values must be a table.")
        assert(typeof(Info.DisabledValues) == "table", "Dropdown DisabledValues must be a table.")
        assert(Info.MaxVisibleDropdownItems > 0, "MaxVisibleDropdownItems must be greater than zero.")

        local Groupbox = self
        local Container = Groupbox.Container

        if Info.SpecialType == "Player" then
            Info.Values = GetPlayers(Info.ExcludeLocalPlayer)
            Info.AllowNull = true
        elseif Info.SpecialType == "Team" then
            Info.Values = GetTeams()
            Info.AllowNull = true
        end

        local Dropdown = {
            Connections = {},
            Destroyed = false,

            Text = typeof(Info.Text) == "string" and Info.Text or nil,

            Value = Info.Multi and {} or nil,
            Values = Info.Values,
            DisabledValues = Info.DisabledValues,
            ValueImages = Info.ValueImages,

            Multi = Info.Multi,
            DragSelect = Info.Multi and not Library.IsMobile and Info.DragSelect == true,

            SpecialType = Info.SpecialType,
            ExcludeLocalPlayer = Info.ExcludeLocalPlayer,
            EnablePlayerImages = Info.EnablePlayerImages,

            Tooltip = Info.Tooltip,
            DisabledTooltip = Info.DisabledTooltip,
            TooltipTable = nil,

            Callback = Info.Callback,
            Changed = Info.Changed,

            Disabled = Info.Disabled,
            Visible = Info.Visible,

            Type = "Dropdown",
        }

        local function GetFirstSelectableValue()
            for _, Value in Dropdown.Values do
                if not table.find(Dropdown.DisabledValues, Value) then
                    return Value
                end
            end

            return nil
        end

        local function SanitizeSelection()
            if Dropdown.Multi then
                for Value in Dropdown.Value do
                    if
                        not table.find(Dropdown.Values, Value)
                        or table.find(Dropdown.DisabledValues, Value)
                    then
                        Dropdown.Value[Value] = nil
                    end
                end

                if not Info.AllowNull and next(Dropdown.Value) == nil then
                    local FirstValue = GetFirstSelectableValue()
                    if FirstValue ~= nil then
                        Dropdown.Value[FirstValue] = true
                    end
                end
            elseif Dropdown.Value ~= nil and (
                not table.find(Dropdown.Values, Dropdown.Value)
                or table.find(Dropdown.DisabledValues, Dropdown.Value)
            ) then
                Dropdown.Value = Info.AllowNull and nil or GetFirstSelectableValue()
            elseif Dropdown.Value == nil and not Info.AllowNull then
                Dropdown.Value = GetFirstSelectableValue()
            end
        end

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, Dropdown.Text and 39 or 21),
            Visible = Dropdown.Visible,
            Parent = Container,
        })

        local Label = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 14),
            Text = Dropdown.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Visible = not not Info.Text,
            ZIndex = 3,
            Parent = Holder,
        })

        local DisplayContainer = New("TextButton", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = "MainColor",
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.new(1, 0, 0, 21),
            Text = "",
            TextTransparency = 1,
            ZIndex = 2,
            Parent = Holder,
        })

        New("UIPadding", {
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 4),
            Parent = DisplayContainer,
        })

        New("UIStroke", {
            Color = "OutlineColor",
            Parent = DisplayContainer,
        })
        table.insert(
            Library.Corners,
            TrackCornerMode(New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = DisplayContainer,
            }), "Half")
        )

        local DisplayImage = New("ImageLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(-4, 3),
            Size = UDim2.fromOffset(16, 16),
            Image = "",
            ImageTransparency = 1,
            ZIndex = 2,
            Parent = DisplayContainer,
        })

        local DisplayButton = New("TextButton", {
            Active = not Dropdown.Disabled,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 21),
            Text = "---",
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 2,
            Parent = DisplayContainer,
        })

        local ArrowImage = New("ImageLabel", {
            AnchorPoint = Vector2.new(1, 0.5),
            Image = ArrowIcon and ArrowIcon.Url or "",
            ImageColor3 = "FontColor",
            ImageRectOffset = ArrowIcon and ArrowIcon.ImageRectOffset or Vector2.zero,
            ImageRectSize = ArrowIcon and ArrowIcon.ImageRectSize or Vector2.zero,
            ImageTransparency = 0.5,
            Position = UDim2.fromScale(1, 0.5),
            Size = UDim2.fromOffset(16, 16),
            Parent = DisplayContainer,
        })

        local SearchBox
        if Info.Searchable then
            SearchBox = New("TextBox", {
                BackgroundTransparency = 1,
                PlaceholderText = "Search...",
                Position = UDim2.fromOffset(-8, 0),
                Size = UDim2.new(1, -12, 1, 0),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Visible = false,
                Parent = DisplayButton,
            })
            New("UIPadding", {
                PaddingLeft = UDim.new(0, 8),
                Parent = SearchBox,
            })
        end

        local GetValueImage = function(Value)
            if not Value then
                return nil
            end

            local ValueImage = nil
            if Dropdown.SpecialType == "Player" and Dropdown.EnablePlayerImages == true then
                if typeof(Value) == "Instance" and Value:IsA("Player") then
                    ValueImage = { Url = string.format("rbxthumb://type=AvatarHeadShot&id=%s&w=48&h=48", tostring(Value.UserId)) }
                end
            else
                if Dropdown.ValueImages and Dropdown.ValueImages[Value] then
                    ValueImage = Library:GetCustomIcon(Dropdown.ValueImages[Value])
                end
            end

            return ValueImage
        end

        local MenuTable = Library:AddContextMenu(
            DisplayContainer,
            function()
                return UDim2.fromOffset((DisplayContainer.AbsoluteSize.X / Library.DPIScale), 0)
            end,
            function()
                return { 0.5, DisplayContainer.AbsoluteSize.Y + 1.5 }
            end,
            2,
            function(Active: boolean)
                DisplayButton.TextTransparency = (Active and SearchBox) and 1 or 0

                ArrowImage.ImageTransparency = Active and 0 or 0.5
                ArrowImage.Rotation = Active and 180 or 0

                if SearchBox then
                    SearchBox.Text = ""
                    SearchBox.Visible = Active
                end
            end,
            "Dropdown"
        )
        Dropdown.Menu = MenuTable

        local ButtonContainer = New("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = -1,
			Size = UDim2.new(1, -2, 0, 0),
            Visible = false,
			Parent = MenuTable.Menu,
		})

		New("UIListLayout", {
			Padding = UDim.new(0, 6),
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = ButtonContainer,
		})

		New("UIPadding", {
			PaddingBottom = UDim.new(0, 4),
			PaddingLeft = UDim.new(0, 4),
			PaddingRight = UDim.new(0, 4),
			PaddingTop = UDim.new(0, 4),
			Parent = ButtonContainer,
		})

		local ButtonHolder = New("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = 0,
			Size = UDim2.fromScale(1, 0),
			Parent = MenuTable.Menu,
		})

		New("UIListLayout", {
			Parent = ButtonHolder,
		})

        function Dropdown:RecalculateListSize(Count)
            local ListHeight =
                math.clamp((Count or GetTableSize(Dropdown.Values)) * 21, 0, Info.MaxVisibleDropdownItems * 21)
            local ActionHeight = ButtonContainer.Visible
                and math.max(ButtonContainer.AbsoluteSize.Y / Library.DPIScale, 29)
                or 0

            MenuTable:SetSize(function()
                return UDim2.fromOffset(
                    (DisplayContainer.AbsoluteSize.X / Library.DPIScale),
                    ListHeight + ActionHeight
                )
            end)
        end

        function Dropdown:UpdateColors()
            if Library.Unloaded then
                return
            end

            Label.TextTransparency = Dropdown.Disabled and 0.8 or 0
            DisplayButton.TextTransparency = Dropdown.Disabled and 0.8 or 0
            DisplayImage.ImageTransparency = Dropdown.Disabled and 0.8 or 0
            ArrowImage.ImageTransparency = Dropdown.Disabled and 0.8 or MenuTable.Active and 0 or 0.5
        end

        function Dropdown:Display()
            if Library.Unloaded then
                return
            end

            local Str = ""
            local ValueImage = nil

            if Info.Multi then
                for _, Value in Dropdown.Values do
                    if Dropdown.Value[Value] then
                        if not ValueImage then
                            ValueImage = GetValueImage(Value)
                        end

                        Str = Str
                            .. (Info.FormatDisplayValue and tostring(Info.FormatDisplayValue(Value)) or tostring(Value))
                            .. ", "
                    end
                end

                Str = Str:sub(1, #Str - 2)
            else
                ValueImage = GetValueImage(Dropdown.Value)
                Str = Dropdown.Value and tostring(Dropdown.Value) or ""

                if Str ~= "" and Info.FormatDisplayValue then
                    Str = tostring(Info.FormatDisplayValue(Str))
                end
            end

            if #Str > 25 then
                Str = Str:sub(1, 22) .. "..."
            end

            DisplayButton.Text = (Str == "" and "---" or Str)
            
            if ValueImage then
                DisplayImage.Image = ValueImage.Url
                DisplayImage.ImageRectOffset = ValueImage.ImageRectOffset or Vector2.zero
                DisplayImage.ImageRectSize = ValueImage.ImageRectSize or Vector2.zero
                DisplayImage.ImageTransparency = 0
            else
                DisplayImage.Image = ""
                DisplayImage.ImageTransparency = 1
            end

            DisplayButton.Size = ValueImage and UDim2.new(1, -8, 0, 21) or UDim2.new(1, 0, 0, 21)
            DisplayButton.Position = ValueImage and UDim2.fromOffset(14, 0) or UDim2.fromOffset(0, 0)
        end

        function Dropdown:OnChanged(Func)
            Dropdown.Changed = Func
        end

        function Dropdown:GetActiveValues(ReturnCount)
            local Table = {}

            if Info.Multi then
                for Value, _ in Dropdown.Value do
                    table.insert(Table, Value)
                end
            else
                if Dropdown.Value then
                    table.insert(Table, Dropdown.Value)
                end
            end

            return ReturnCount == true and GetTableSize(Table) or Table
        end

        local Buttons = {}
        local ExtraButtons = {}
        local BulkActionButton
        local DragSelecting = false
        local DragStartIndex = nil
        local DragInitialValues = {}
        local DragInputEndedConn = nil
        local DragInputChangedConn = nil

        local function DisconnectDragConnection(Connection)
            if not Connection then
                return
            end

            if Connection.Connected then
                Connection:Disconnect()
            end

            local DropdownIndex = table.find(Dropdown.Connections, Connection)
            if DropdownIndex then
                table.remove(Dropdown.Connections, DropdownIndex)
            end

            local LibraryIndex = table.find(Library.Signals, Connection)
            if LibraryIndex then
                table.remove(Library.Signals, LibraryIndex)
            end
        end

        local function UpdateExtraButtonContainerVisibility()
            local HasVisibleButton = false
            for _, ExtraButton in ExtraButtons do
                if ExtraButton.Holder and ExtraButton.Holder.Visible then
                    HasVisibleButton = true
                    break
                end
            end

            ButtonContainer.Visible = HasVisibleButton
            Dropdown:RecalculateListSize()
        end

        local function StopDragSelect()
            DragSelecting = false
            DragStartIndex = nil
            table.clear(DragInitialValues)

            DisconnectDragConnection(DragInputEndedConn)
            DisconnectDragConnection(DragInputChangedConn)
            DragInputEndedConn = nil
            DragInputChangedConn = nil
        end

        local function UpdateDrag(CurrentIndex)
            local Min = math.min(DragStartIndex, CurrentIndex)
            local Max = math.max(DragStartIndex, CurrentIndex)

            for OtherButton, OtherTable in Buttons do
                local InRange = OtherTable.Index >= Min and OtherTable.Index <= Max
                local Try = DragInitialValues[OtherTable.Value]
                if InRange then
                    Try = not Try
                end

                if not (Dropdown:GetActiveValues(true) == 1 and not Try and not Info.AllowNull) then
                    Dropdown.Value[OtherTable.Value] = Try and true or nil
                end

                OtherTable:UpdateButton()
            end

            Dropdown:Display()
        end

        function Dropdown:BuildDropdownList()
            local Values = Dropdown.Values
            local DisabledValues = Dropdown.DisabledValues

            StopDragSelect()

            for Button, _ in Buttons do
                if not (Button and Button.Parent) then
                    continue
                end

                Button.Parent:Destroy()
            end
            table.clear(Buttons)

            local Count = 0

            for _, Value in Values do
                local FormattedValue = tostring(Info.FormatListValue and Info.FormatListValue(Value) or Value)
                if SearchBox and not ContainsPlainText(FormattedValue, SearchBox.Text:lower()) then
                    continue
                end

                Count += 1

                local IsDisabled = table.find(DisabledValues, Value)
                local Table = {}
                local ValueImage = GetValueImage(Value)

                local Container = New("Frame", {
                    BackgroundColor3 = "MainColor",
                    BackgroundTransparency = 1,
                    LayoutOrder = IsDisabled and 1 or 0,
                    Size = UDim2.new(1, 0, 0, 21),
                    Parent = ButtonHolder,
                })

                local Image = ValueImage and New("ImageLabel", {
                    BackgroundTransparency = 1,
                    Image = ValueImage.Url,
                    ImageRectOffset = ValueImage.ImageRectOffset,
                    ImageRectSize = ValueImage.ImageRectSize,
                    ImageTransparency = 0.5,
                    Size = UDim2.fromOffset(16, 16),
                    Position = UDim2.fromOffset(4, 3),
                    Parent = Container,
                })

                local Button = New("TextButton", {
                    BackgroundTransparency = 1,
                    Size = ValueImage and UDim2.new(1, -18, 0, 21) or UDim2.new(1, 0, 0, 21),
                    Position = ValueImage and UDim2.fromOffset(18, 0) or UDim2.fromOffset(0, 0),
                    Text = FormattedValue,
                    TextSize = 14,
                    TextTransparency = 0.5,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Container,
                })
                New("UIPadding", {
                    PaddingLeft = UDim.new(0, 7),
                    PaddingRight = UDim.new(0, 7),
                    Parent = Button,
                })

                local Selected
                if Info.Multi then
                    Selected = Dropdown.Value[Value]
                else
                    Selected = Dropdown.Value == Value
                end

                function Table:UpdateButton()
                    if Info.Multi then
                        Selected = Dropdown.Value[Value]
                    else
                        Selected = Dropdown.Value == Value
                    end

                    Container.BackgroundTransparency = Selected and 0 or 1
                    Button.TextTransparency = IsDisabled and 0.8 or Selected and 0 or 0.5

                    if Image then
                        Image.ImageTransparency = IsDisabled and 0.8 or Selected and 0 or 0.5
                    end
                end

                Table.Index = Count
                Table.Value = Value

                if not IsDisabled then
                    Button.MouseButton1Click:Connect(function()
                        if DragSelecting then return end

                        local Try = not Selected
                        if not (Dropdown:GetActiveValues(true) == 1 and not Try and not Info.AllowNull) then
                            Selected = Try
                            if Info.Multi then
                                Dropdown.Value[Value] = Selected and true or nil
                            else
                                Dropdown.Value = Selected and Value or nil
                            end

                            for _, OtherButton in Buttons do
                                OtherButton:UpdateButton()
                            end
                        end

                        Table:UpdateButton()
                        Dropdown:Display()

                        Library:UpdateDependencyBoxes()
                        Dropdown:RunChanged()
                    end)

                    if Info.Multi and Dropdown.DragSelect and not Library.IsMobile then
                        Button.InputBegan:Connect(function(StartInput)
                            if not IsMouseInput(StartInput) then return end

                            DragSelecting = true
                            DragStartIndex = Table.Index
                            table.clear(DragInitialValues)

                            for OtherButton, OtherTable in Buttons do
                                DragInitialValues[OtherTable.Value] = Dropdown.Value[OtherTable.Value]
                            end

                            UpdateDrag(Table.Index)

                            DisconnectDragConnection(DragInputEndedConn)
                            DisconnectDragConnection(DragInputChangedConn)

                            DragInputChangedConn = Library:GiveSignal(UserInputService.InputChanged:Connect(function(ChangeInput)
                                if not IsMovementInput(ChangeInput) and ChangeInput ~= StartInput then
                                    return
                                end

                                local Pos = ChangeInput.Position
                                for OtherButton, OtherTable in Buttons do
                                    if Library:MouseIsOverFrame(OtherButton, Pos) then
                                        UpdateDrag(OtherTable.Index)
                                        break
                                    end
                                end
                            end))

                            DragInputEndedConn = Library:GiveSignal(UserInputService.InputEnded:Connect(function(EndInput)
                                if EndInput ~= StartInput and not (IsMouseInput(EndInput) and EndInput.UserInputType == StartInput.UserInputType) then
                                    return
                                end

                                Library:UpdateDependencyBoxes()
                                Dropdown:RunChanged()

                                StopDragSelect()
                            end))

                            table.insert(Dropdown.Connections, DragInputEndedConn)
                            table.insert(Dropdown.Connections, DragInputChangedConn)
                        end)
                    end
                end

                Table:UpdateButton()
                Dropdown:Display()

                Buttons[Button] = Table
            end

            if Info.Multi and not BulkActionButton then
                BulkActionButton = Dropdown:AddButton("Select All", function()
                    local Selected = {}
                    for _, Value in Dropdown.Values do
                        if not table.find(Dropdown.DisabledValues, Value) then
                            Selected[Value] = true
                        end
                    end

                    Dropdown.Value = Selected
                    for _, ValueButton in Buttons do
                        ValueButton:UpdateButton()
                    end
                end)
                BulkActionButton:AddButton("Deselect All", function()
                    Dropdown.Value = {}
                    SanitizeSelection()
                    for _, ValueButton in Buttons do
                        ValueButton:UpdateButton()
                    end
                end)
            end

            Dropdown:RecalculateListSize(Count)
        end

        function Dropdown:RunChanged()
            Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
            Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
        end

        function Dropdown:AddButton(...)
            if self.Destroyed then
                return nil
            end

            local function GetInfo(...)
                local Info = {}

                local First = select(1, ...)
                local Second = select(2, ...)

                if typeof(First) == "table" or typeof(Second) == "table" then
                    local Params = typeof(First) == "table" and First or Second

                    Info.Text = Params.Text or ""
                    Info.Func = Params.Func or Params.Callback or function() end
                    Info.DoubleClick = Params.DoubleClick

                    Info.Tooltip = Params.Tooltip
                    Info.DisabledTooltip = Params.DisabledTooltip

                    Info.Risky = Params.Risky or false
                    Info.Disabled = Params.Disabled or false
                    Info.Visible = Params.Visible ~= false
                    Info.Idx = typeof(Second) == "table" and First or nil
                else
                    Info.Text = First or ""
                    Info.Func = Second or function() end
                    Info.DoubleClick = false

                    Info.Tooltip = nil
                    Info.DisabledTooltip = nil

                    Info.Risky = false
                    Info.Disabled = false
                    Info.Visible = true
                    Info.Idx = select(3, ...) or nil
                end

                return Info
            end
            local Info = GetInfo(...)

            local Container = ButtonContainer

            local Button = {
                Connections = {},
                Destroyed = false,

                Text = Info.Text,
                Func = function()
                    Library:SafeCallback(Info.Func)
                    Dropdown:Display()

                    Library:UpdateDependencyBoxes()
                    Dropdown:RunChanged()
                end,
                DoubleClick = Info.DoubleClick,

                Tooltip = Info.Tooltip,
                DisabledTooltip = Info.DisabledTooltip,
                TooltipTable = nil,

                Risky = Info.Risky,
                Disabled = Info.Disabled,
                Visible = Info.Visible,

                Tween = nil,
                Type = "Button",
            }

            local Holder = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 21),
                Visible = Button.Visible,
                Parent = Container,
            })
            New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                Padding = UDim.new(0, 6),
                Parent = Holder,
            })

            local function CreateButton(Button)
                local Base = New("TextButton", {
                    Active = not Button.Disabled,
                    BackgroundColor3 = Button.Disabled and "BackgroundColor" or "MainColor",
                    Size = UDim2.fromScale(1, 1),
                    Text = Button.Text,
                    TextSize = 14,
                    TextTransparency = 0.4,
                    Visible = Button.Visible,
                    Parent = Holder,
                })

                local Stroke = New("UIStroke", {
                    Color = "OutlineColor",
                    Transparency = Button.Disabled and 0.5 or 0,
                    Parent = Base,
                })
                table.insert(
                    Library.Corners,
                    TrackCornerMode(New("UICorner", {
                        CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                        Parent = Base,
                    }), "Half")
                )

                return Base, Stroke
            end

            local function UpdateHolderVisibility()
                Holder.Visible = Button.Visible or (Button.SubButton and Button.SubButton.Visible) or false
                UpdateExtraButtonContainerVisibility()
            end

            local function InitEvents(Button)
                Button.Base.MouseEnter:Connect(function()
                    if Button.Disabled then
                        return
                    end

                    Button.Tween = TweenService:Create(Button.Base, Library.TweenInfo, {
                        TextTransparency = 0,
                    })
                    Button.Tween:Play()
                end)
                Button.Base.MouseLeave:Connect(function()
                    if Button.Disabled then
                        return
                    end

                    Button.Tween = TweenService:Create(Button.Base, Library.TweenInfo, {
                        TextTransparency = 0.4,
                    })
                    Button.Tween:Play()
                end)

                Button.Base.MouseButton1Click:Connect(function()
                    if Button.Disabled or Button.Locked then
                        return
                    end

                    if Button.DoubleClick then
                        Button.Locked = true

                        Button.Base.Text = "Are you sure?"
                        Button.Base.TextColor3 = Library.Scheme.AccentColor
                        Library.Registry[Button.Base].TextColor3 = "AccentColor"

                        local Clicked = WaitForEvent(Button.Base.MouseButton1Click, 0.5)

                        Button.Base.Text = Button.Text
                        Button.Base.TextColor3 = Button.Risky and Library.Scheme.RedColor or Library.Scheme.FontColor
                        Library.Registry[Button.Base].TextColor3 = Button.Risky and "RedColor" or "FontColor"

                        if Clicked then
                            Library:SafeCallback(Button.Func)
                        end

                        RunService.RenderStepped:Wait()
                        Button.Locked = false
                        return
                    end

                    Library:SafeCallback(Button.Func)
                end)
            end

            Button.Base, Button.Stroke = CreateButton(Button)
            InitEvents(Button)

            function Button:AddButton(...)
                if Button.Destroyed then
                    return nil
                end
                if Button.SubButton and not Button.SubButton.Destroyed then
                    Button.SubButton:Destroy()
                end

                local Info = GetInfo(...)

                local SubButton = {
                    Connections = {},
                    Destroyed = false,

                    Text = Info.Text,
                    Func = Info.Func,
                    DoubleClick = Info.DoubleClick,

                    Tooltip = Info.Tooltip,
                    DisabledTooltip = Info.DisabledTooltip,
                    TooltipTable = nil,

                    Risky = Info.Risky,
                    Disabled = Info.Disabled,
                    Visible = Info.Visible,

                    Tween = nil,
                    Type = "SubButton",
                }

                Button.SubButton = SubButton
                SubButton.Base, SubButton.Stroke = CreateButton(SubButton)
                InitEvents(SubButton)
                UpdateHolderVisibility()

                function SubButton:UpdateColors()
                    if Library.Unloaded then
                        return
                    end

                    StopTween(SubButton.Tween)

                    SubButton.Base.BackgroundColor3 = SubButton.Disabled and Library.Scheme.BackgroundColor
                        or Library.Scheme.MainColor
                    SubButton.Base.TextTransparency = SubButton.Disabled and 0.8 or 0.4
                    SubButton.Stroke.Transparency = SubButton.Disabled and 0.5 or 0

                    Library.Registry[SubButton.Base].BackgroundColor3 = SubButton.Disabled and "BackgroundColor" or "MainColor"
                end

                function SubButton:SetDisabled(Disabled: boolean)
                    SubButton.Disabled = Disabled

                    if SubButton.TooltipTable then
                        SubButton.TooltipTable.Disabled = SubButton.Disabled
                    end

                    SubButton.Base.Active = not SubButton.Disabled
                    SubButton:UpdateColors()
                end

                function SubButton:SetVisible(Visible: boolean)
                    SubButton.Visible = Visible

                    SubButton.Base.Visible = SubButton.Visible
                    UpdateHolderVisibility()
                end

                function SubButton:SetText(Text: string)
                    SubButton.Text = Text
                    SubButton.Base.Text = Text
                end

                if typeof(SubButton.Tooltip) == "string" or typeof(SubButton.DisabledTooltip) == "string" then
                    SubButton.TooltipTable = Library:AddTooltip(SubButton.Tooltip, SubButton.DisabledTooltip, SubButton.Base)
                    SubButton.TooltipTable.Disabled = SubButton.Disabled
                end

                if SubButton.Risky then
                    SubButton.Base.TextColor3 = Library.Scheme.RedColor
                    Library.Registry[SubButton.Base].TextColor3 = "RedColor"
                end

                SubButton:UpdateColors()

                if Info.Idx then
                    RegisterControl(ExtraButtons, Info.Idx, SubButton, "Dropdown button")
                else
                    table.insert(ExtraButtons, SubButton)
                end
                UpdateExtraButtonContainerVisibility()

                function SubButton:Destroy()
                    if SubButton.Destroyed then
                        return
                    end
                    SubButton.Destroyed = true

                    if SubButton.TooltipTable then
                        SubButton.TooltipTable:Destroy()
                    end

                    if SubButton.Tween then
                        SubButton.Tween:Destroy()
                    end

                    if SubButton.Base then
                        SubButton.Base:Destroy()
                    end

                    if Button.SubButton == SubButton then
                        Button.SubButton = nil
                    end

                    if Info.Idx then
                        RemoveStoredObject(ExtraButtons, SubButton)
                    else
                        local BIdx = table.find(ExtraButtons, SubButton)

                        if BIdx then
                            table.remove(ExtraButtons, BIdx)
                        end
                    end

                    UpdateHolderVisibility()
                end

                return SubButton
            end

            function Button:UpdateColors()
                if Library.Unloaded then
                    return
                end

                StopTween(Button.Tween)

                Button.Base.BackgroundColor3 = Button.Disabled and Library.Scheme.BackgroundColor or Library.Scheme.MainColor
                Button.Base.TextTransparency = Button.Disabled and 0.8 or 0.4
                Button.Stroke.Transparency = Button.Disabled and 0.5 or 0

                Library.Registry[Button.Base].BackgroundColor3 = Button.Disabled and "BackgroundColor" or "MainColor"
            end

            function Button:SetDisabled(Disabled: boolean)
                Button.Disabled = Disabled

                if Button.TooltipTable then
                    Button.TooltipTable.Disabled = Button.Disabled
                end

                Button.Base.Active = not Button.Disabled
                Button:UpdateColors()
            end

            function Button:SetVisible(Visible: boolean)
                Button.Visible = Visible

                Button.Base.Visible = Button.Visible
                UpdateHolderVisibility()
            end

            function Button:SetText(Text: string)
                Button.Text = Text
                Button.Base.Text = Text
            end

            if typeof(Button.Tooltip) == "string" or typeof(Button.DisabledTooltip) == "string" then
                Button.TooltipTable = Library:AddTooltip(Button.Tooltip, Button.DisabledTooltip, Button.Base)
                Button.TooltipTable.Disabled = Button.Disabled
            end

            if Button.Risky then
                Button.Base.TextColor3 = Library.Scheme.RedColor
                Library.Registry[Button.Base].TextColor3 = "RedColor"
            end

            Button:UpdateColors()

            Button.Holder = Holder

            if Info.Idx then
                RegisterControl(ExtraButtons, Info.Idx, Button, "Dropdown button")
            else
                table.insert(ExtraButtons, Button)
            end
            UpdateExtraButtonContainerVisibility()

            function Button:Destroy()
                if Button.Destroyed then
                    return
                end
                Button.Destroyed = true

                if Button.TooltipTable then
                    Button.TooltipTable:Destroy()
                end

                if Button.Tween then
                    Button.Tween:Destroy()
                end

                if Button.SubButton then
                    Button.SubButton:Destroy()
                end

                if Holder then
                    Holder:Destroy()
                end

                local ElemIdx = table.find(Groupbox.Elements, Button)
                if ElemIdx then
                    table.remove(Groupbox.Elements, ElemIdx)
                end

                Groupbox:Resize()

                if Info.Idx then
                    RemoveStoredObject(ExtraButtons, Button)
                else
                    local BIdx = table.find(ExtraButtons, Button)

                    if BIdx then
                        table.remove(ExtraButtons, BIdx)
                    end
                end

                UpdateExtraButtonContainerVisibility()
            end

            return Button
        end

        function Dropdown:SetValue(Value)
            if Info.Multi then
                local Table = {}

                for Val, Active in (typeof(Value) == "table" and Value or {}) do
                    if typeof(Active) ~= "boolean" then
                        if table.find(Dropdown.Values, Active) then
                            Table[Active] = true
                        end
                    elseif Active and table.find(Dropdown.Values, Val) then
                        Table[Val] = true
                    end
                end

                Dropdown.Value = Table
            else
                if table.find(Dropdown.Values, Value) then
                    Dropdown.Value = Value
                elseif not Value and Info.AllowNull then
                    Dropdown.Value = nil
                end
            end
            SanitizeSelection()

            Dropdown:Display()
            for _, Button in Buttons do
                Button:UpdateButton()
            end

            if not Dropdown.Disabled then
                Library:UpdateDependencyBoxes()
                Dropdown:RunChanged()
            end
        end

        function Dropdown:SetValues(Values)
            assert(typeof(Values) == "table", "Dropdown Values must be a table.")
            Dropdown.Values = DeepClone(Values)
            SanitizeSelection()
            Dropdown:BuildDropdownList()
            Dropdown:Display()

            if not Dropdown.Disabled then
                Library:UpdateDependencyBoxes()
                Dropdown:RunChanged()
            end
        end

        function Dropdown:AddValues(Values)
            if typeof(Values) == "table" then
                for _, val in Values do
                    table.insert(Dropdown.Values, val)
                end
            elseif typeof(Values) == "string" then
                table.insert(Dropdown.Values, Values)
            else
                return
            end

            SanitizeSelection()
            Dropdown:BuildDropdownList()
            Dropdown:Display()

            if not Dropdown.Disabled then
                Library:UpdateDependencyBoxes()
                Dropdown:RunChanged()
            end
        end

        function Dropdown:SetDisabledValues(DisabledValues)
            assert(typeof(DisabledValues) == "table", "Dropdown DisabledValues must be a table.")
            Dropdown.DisabledValues = DeepClone(DisabledValues)
            SanitizeSelection()
            Dropdown:BuildDropdownList()
            Dropdown:Display()

            if not Dropdown.Disabled then
                Library:UpdateDependencyBoxes()
                Dropdown:RunChanged()
            end
        end

        function Dropdown:AddDisabledValues(DisabledValues)
            if typeof(DisabledValues) == "table" then
                for _, val in DisabledValues do
                    table.insert(Dropdown.DisabledValues, val)
                end
            elseif typeof(DisabledValues) == "string" then
                table.insert(Dropdown.DisabledValues, DisabledValues)
            else
                return
            end

            SanitizeSelection()
            Dropdown:BuildDropdownList()
            Dropdown:Display()

            if not Dropdown.Disabled then
                Library:UpdateDependencyBoxes()
                Dropdown:RunChanged()
            end
        end

        function Dropdown:SetValueImages(ValueImages)
            if typeof(ValueImages) ~= "table" then
                return
            end
            
            Dropdown.ValueImages = ValueImages
            Dropdown:BuildDropdownList()
        end

        function Dropdown:AddValueImages(ValueImages)
            if typeof(ValueImages) ~= "table" then
                return
            end
            
            for key, val in ValueImages do
                Dropdown.ValueImages[key] = val
            end
            
            Dropdown:BuildDropdownList()
        end

        function Dropdown:SetDisabled(Disabled: boolean)
            Dropdown.Disabled = Disabled

            if Dropdown.TooltipTable then
                Dropdown.TooltipTable.Disabled = Dropdown.Disabled
            end

            MenuTable:Close()
            DisplayButton.Active = not Dropdown.Disabled
            Dropdown:UpdateColors()
        end

        function Dropdown:SetVisible(Visible: boolean)
            Dropdown.Visible = Visible

            Holder.Visible = Dropdown.Visible
            Groupbox:Resize()
        end

        function Dropdown:SetText(Text: string)
            Dropdown.Text = Text
            Holder.Size = UDim2.new(1, 0, 0, Text and 39 or 21)

            Label.Text = Text and Text or ""
            Label.Visible = not not Text
            RefreshSearchIfActive()
        end

        function Dropdown:SetDragSelect(Value: boolean)
            if not Info.Multi or Library.IsMobile then 
                Value = false
            end

            Dropdown.DragSelect = Value == true
            Dropdown:BuildDropdownList()
        end

        local ToggleDropdown = function()
            if Dropdown.Disabled then
                return
            end

            MenuTable:Toggle()
        end

        table.insert(Dropdown.Connections, DisplayContainer.MouseButton1Click:Connect(ToggleDropdown))
        table.insert(Dropdown.Connections, DisplayButton.MouseButton1Click:Connect(ToggleDropdown))

        if SearchBox then
            table.insert(Dropdown.Connections, SearchBox:GetPropertyChangedSignal("Text"):Connect(Dropdown.BuildDropdownList))
        end

        local Defaults = {}
        if typeof(Info.Default) == "string" then
            local Index = table.find(Dropdown.Values, Info.Default)
            if Index then
                table.insert(Defaults, Index)
            end
        elseif typeof(Info.Default) == "table" then
            for _, Value in next, Info.Default do
                local Index = table.find(Dropdown.Values, Value)
                if Index then
                    table.insert(Defaults, Index)
                end
            end
        elseif Dropdown.Values[Info.Default] ~= nil then
            table.insert(Defaults, Info.Default)
        end

        if next(Defaults) then
            for i = 1, #Defaults do
                local Index = Defaults[i]
                if Info.Multi then
                    Dropdown.Value[Dropdown.Values[Index]] = true
                else
                    Dropdown.Value = Dropdown.Values[Index]
                end

                if not Info.Multi then
                    break
                end
            end
        end
        SanitizeSelection()

        if typeof(Dropdown.Tooltip) == "string" or typeof(Dropdown.DisabledTooltip) == "string" then
            Dropdown.TooltipTable = Library:AddTooltip(Dropdown.Tooltip, Dropdown.DisabledTooltip, DisplayContainer)
            Dropdown.TooltipTable.Disabled = Dropdown.Disabled
        end

        Dropdown:UpdateColors()
        Dropdown:Display()
        Dropdown:BuildDropdownList()
        Groupbox:Resize()

        Dropdown.Holder = Holder
        table.insert(Groupbox.Elements, Dropdown)

        Dropdown.Default = Defaults
        Dropdown.DefaultValues = DeepClone(Dropdown.Values)

        RegisterControl(Options, Idx, Dropdown, "Dropdown")

        function Dropdown:Destroy()
            if Dropdown.Destroyed then
                return
            end
            Dropdown.Destroyed = true

            StopDragSelect()

            if Dropdown.Connections then
                for _, Connection in Dropdown.Connections do
                    Connection:Disconnect()
                end
            end

            if Dropdown.TooltipTable then 
                Dropdown.TooltipTable:Destroy() 
            end

            DestroyObjects(ExtraButtons)

            if MenuTable then 
                MenuTable:Destroy() 
            end

            if Holder then 
                Holder:Destroy() 
            end

            local ElemIdx = table.find(Groupbox.Elements, Dropdown)
            if ElemIdx then 
                table.remove(Groupbox.Elements, ElemIdx) 
            end

            Groupbox:Resize()
            RemoveStoredObject(Options, Dropdown)
        end

        return Dropdown
    end

    function Funcs:AddViewport(Idx, Info)
        if self.Destroyed then return nil end
        assert(Idx ~= nil, "AddViewport requires a non-nil index.")

        Info = Library:Validate(Info, Templates.Viewport)

        local Groupbox = self
        local Container = Groupbox.Container

        local Dragging, Pinching = false, false
        local LastMousePos, LastPinchDist = nil, 0
        local ParentScrollingStates = nil

        local function SetParentScrollingEnabled(Enabled)
            if not Enabled then
                if ParentScrollingStates then
                    return
                end

                ParentScrollingStates = {}
                local function Disable(Frame)
                    if Frame and ParentScrollingStates[Frame] == nil then
                        ParentScrollingStates[Frame] = Frame.ScrollingEnabled
                        Frame.ScrollingEnabled = false
                    end
                end

                if Groupbox.Tab and Groupbox.Tab.Sides then
                    for _, Side in Groupbox.Tab.Sides do
                        Disable(Side)
                    end
                end

                if
                    typeof(Groupbox.Container) == "Instance"
                    and Groupbox.Container:IsA("ScrollingFrame")
                then
                    Disable(Groupbox.Container)
                end
                return
            end

            if ParentScrollingStates then
                for Frame, WasEnabled in ParentScrollingStates do
                    if Frame.Parent then
                        Frame.ScrollingEnabled = WasEnabled
                    end
                end
                ParentScrollingStates = nil
            end
        end

        local ViewportObject = Info.Object
        if Info.Clone and typeof(Info.Object) == "Instance" then
            if Info.Object.Archivable then
                ViewportObject = ViewportObject:Clone()
            else
                Info.Object.Archivable = true
                ViewportObject = ViewportObject:Clone()
                Info.Object.Archivable = false
            end
        end

        local Viewport = {
            Connections = {},
            Destroyed = false,

            Object = ViewportObject :: PVInstance,
            Camera = if not Info.Camera then Instance.new("Camera") else Info.Camera,
            Interactive = Info.Interactive,
            AutoFocus = Info.AutoFocus,
            Visible = Info.Visible,
            Type = "Viewport",
        }

        assert(
            typeof(Viewport.Object) == "Instance" and (Viewport.Object:IsA("BasePart") or Viewport.Object:IsA("Model")),
            "Instance must be a BasePart or Model."
        )

        assert(
            typeof(Viewport.Camera) == "Instance" and Viewport.Camera:IsA("Camera"),
            "Camera must be a valid Camera instance."
        )

        local function GetModelSize(model)
            if model:IsA("BasePart") then
                return model.Size
            end

            return select(2, model:GetBoundingBox())
        end

        local function FocusCamera()
            local ModelSize = GetModelSize(Viewport.Object)
            local MaxExtent = math.max(ModelSize.X, ModelSize.Y, ModelSize.Z)
            local CameraDistance = MaxExtent * 2
            local ModelPosition = (Viewport.Object :: PVInstance):GetPivot().Position

            Viewport.Camera.CFrame = CFrame.new(ModelPosition + Vector3.new(0, MaxExtent / 2, CameraDistance), ModelPosition)
        end

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, Info.Height),
            Visible = Viewport.Visible,
            Parent = Container,
        })

        local Box = New("Frame", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = "MainColor",
            BorderColor3 = "OutlineColor",
            BorderSizePixel = 1,
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.fromScale(1, 1),
            Parent = Holder,
        })

        New("UIPadding", {
            PaddingBottom = UDim.new(0, 3),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 4),
            Parent = Box,
        })

        local ViewportFrame = New("ViewportFrame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Parent = Box,
            CurrentCamera = Viewport.Camera,
            Active = Viewport.Interactive,
        })

        table.insert(Viewport.Connections, ViewportFrame.MouseEnter:Connect(function()
            if not Viewport.Interactive then
                return
            end

            SetParentScrollingEnabled(false)
        end))

        table.insert(Viewport.Connections, ViewportFrame.MouseLeave:Connect(function()
            if not Viewport.Interactive then
                return
            end

            SetParentScrollingEnabled(true)
        end))

        table.insert(Viewport.Connections, ViewportFrame.InputBegan:Connect(function(input)
            if not Viewport.Interactive then
                return
            end

            if input.UserInputType == Enum.UserInputType.MouseButton2 then
                Dragging = true
                LastMousePos = input.Position
            elseif input.UserInputType == Enum.UserInputType.Touch and not Pinching then
                Dragging = true
                LastMousePos = input.Position
            end
        end))

        table.insert(Viewport.Connections, UserInputService.InputEnded:Connect(function(input)
            if Library.Unloaded then
                return
            end

            if not Viewport.Interactive then
                return
            end

            if input.UserInputType == Enum.UserInputType.MouseButton2 then
                Dragging = false
            elseif input.UserInputType == Enum.UserInputType.Touch then
                Dragging = false
            end
        end))

        table.insert(Viewport.Connections, UserInputService.InputChanged:Connect(function(input)
            if Library.Unloaded then
                return
            end

            if not Viewport.Interactive or not Dragging or Pinching then
                return
            end

            if
                input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch
            then
                local MouseDelta = input.Position - LastMousePos
                LastMousePos = input.Position

                local Position = (Viewport.Object :: PVInstance):GetPivot().Position
                local Camera = Viewport.Camera

                local RotationY = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), -MouseDelta.X * 0.01)
                Camera.CFrame = CFrame.new(Position) * RotationY * CFrame.new(-Position) * Camera.CFrame

                local RotationX = CFrame.fromAxisAngle(Camera.CFrame.RightVector, -MouseDelta.Y * 0.01)
                local PitchedCFrame = CFrame.new(Position) * RotationX * CFrame.new(-Position) * Camera.CFrame

                if PitchedCFrame.UpVector.Y > 0.1 then
                    Camera.CFrame = PitchedCFrame
                end
            end
        end))

        table.insert(Viewport.Connections, ViewportFrame.InputChanged:Connect(function(input)
            if not Viewport.Interactive then
                return
            end

            if input.UserInputType == Enum.UserInputType.MouseWheel then
                local ZoomAmount = input.Position.Z * 2
                Viewport.Camera.CFrame += Viewport.Camera.CFrame.LookVector * ZoomAmount
            end
        end))

        table.insert(Viewport.Connections, UserInputService.TouchPinch:Connect(function(touchPositions, scale, velocity, state)
            if Library.Unloaded then
                return
            end

            if not Viewport.Interactive or not Library:MouseIsOverFrame(ViewportFrame, touchPositions[1]) then
                return
            end

            if state == Enum.UserInputState.Begin then
                Pinching = true
                Dragging = false
                LastPinchDist = (touchPositions[1] - touchPositions[2]).Magnitude
            elseif state == Enum.UserInputState.Change then
                local currentDist = (touchPositions[1] - touchPositions[2]).Magnitude
                local delta = (currentDist - LastPinchDist) * 0.1
                LastPinchDist = currentDist
                Viewport.Camera.CFrame += Viewport.Camera.CFrame.LookVector * delta
            elseif state == Enum.UserInputState.End or state == Enum.UserInputState.Cancel then
                Pinching = false
            end
        end))

        ;(Viewport.Object :: PVInstance).Parent = ViewportFrame
        if Viewport.AutoFocus then
            FocusCamera()
        end

        function Viewport:SetObject(Object: Instance, Clone: boolean?)
            assert(
                typeof(Object) == "Instance" and (Object:IsA("BasePart") or Object:IsA("Model")),
                "Object must be a BasePart or Model."
            )

            if Clone then
                local SourceObject = Object
                local WasArchivable = SourceObject.Archivable
                SourceObject.Archivable = true
                Object = SourceObject:Clone()
                SourceObject.Archivable = WasArchivable
            end

            if Viewport.Object then
                Viewport.Object:Destroy()
            end

            Viewport.Object = Object
            ;(Viewport.Object :: PVInstance).Parent = ViewportFrame
            if Viewport.AutoFocus then
                FocusCamera()
            end

            Groupbox:Resize()
        end

        function Viewport:SetHeight(Height: number)
            assert(Height > 0, "Height must be greater than 0.")

            Holder.Size = UDim2.new(1, 0, 0, Height)
            Groupbox:Resize()
        end

        function Viewport:Focus()
            if not Viewport.Object then
                return
            end

            FocusCamera()
        end

        function Viewport:SetCamera(Camera: Instance)
            assert(
                Camera and typeof(Camera) == "Instance" and Camera:IsA("Camera"),
                "Camera must be a valid Camera instance."
            )

            Viewport.Camera = Camera
            ViewportFrame.CurrentCamera = Camera
        end

        function Viewport:SetInteractive(Interactive: boolean)
            Viewport.Interactive = Interactive
            ViewportFrame.Active = Interactive

            if not Interactive then
                Dragging = false
                Pinching = false
                SetParentScrollingEnabled(true)
            end
        end

        function Viewport:SetVisible(Visible: boolean)
            Viewport.Visible = Visible

            Holder.Visible = Viewport.Visible
            Groupbox:Resize()
        end

        Groupbox:Resize()

        Viewport.Holder = Holder
        table.insert(Groupbox.Elements, Viewport)

        RegisterControl(Options, Idx, Viewport, "Viewport")

        function Viewport:Destroy()
            if Viewport.Destroyed then
                return
            end
            Viewport.Destroyed = true
            Viewport:SetInteractive(false)

            if Viewport.Connections then
                for _, Connection in Viewport.Connections do
                    Connection:Disconnect()
                end
            end

            if Holder then 
                Holder:Destroy() 
            end

            local ElemIdx = table.find(Groupbox.Elements, Viewport)
            if ElemIdx then 
                table.remove(Groupbox.Elements, ElemIdx) 
            end

            Groupbox:Resize()
            RemoveStoredObject(Options, Viewport)
        end

        return Viewport
    end

    function Funcs:AddImage(Idx, Info)
        if self.Destroyed then return nil end
        assert(Idx ~= nil, "AddImage requires a non-nil index.")

        Info = Library:Validate(Info, Templates.Image)
        local InitialIcon = Library:GetCustomIcon(Info.Image)
        assert(InitialIcon, "Image must be a valid Roblox asset or a valid URL or a valid lucide icon.")

        local Groupbox = self
        local Container = Groupbox.Container

        local Image = {
            Connections = {},
            Destroyed = false,

            Image = InitialIcon.Url,
            Color = Info.Color,
            RectOffset = InitialIcon.ImageRectOffset,
            RectSize = InitialIcon.ImageRectSize,
            Height = Info.Height,
            ScaleType = Info.ScaleType,
            Transparency = Info.Transparency,
            BackgroundTransparency = Info.BackgroundTransparency,

            Visible = Info.Visible,
            Type = "Image",
        }

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, Info.Height),
            Visible = Image.Visible,
            Parent = Container,
        })

        local Box = New("Frame", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = "MainColor",
            BorderColor3 = "OutlineColor",
            BorderSizePixel = 1,
            BackgroundTransparency = Image.BackgroundTransparency,
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.fromScale(1, 1),
            Parent = Holder,
        })

        New("UIPadding", {
            PaddingBottom = UDim.new(0, 3),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 4),
            Parent = Box,
        })

        local ImageProperties = {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Image = Image.Image,
            ImageTransparency = Image.Transparency,
            ImageColor3 = Image.Color,
            ImageRectOffset = Image.RectOffset,
            ImageRectSize = Image.RectSize,
            ScaleType = Image.ScaleType,
            Parent = Box,
        }

        local ImageLabel = New("ImageLabel", ImageProperties)

        function Image:SetHeight(Height: number)
            assert(Height > 0, "Height must be greater than 0.")

            Image.Height = Height
            Holder.Size = UDim2.new(1, 0, 0, Height)
            Groupbox:Resize()
        end

        function Image:SetImage(NewImage: string)
            assert(typeof(NewImage) == "string", "Image must be a string.")

            local Icon = Library:GetCustomIcon(NewImage)
            assert(Icon, "Image must be a valid Roblox asset or a valid URL or a valid lucide icon.")

            NewImage = Icon.Url
            Image.RectOffset = Icon.ImageRectOffset
            Image.RectSize = Icon.ImageRectSize

            ImageLabel.Image = NewImage
            ImageLabel.ImageRectOffset = Image.RectOffset
            ImageLabel.ImageRectSize = Image.RectSize
            Image.Image = NewImage
        end

        function Image:SetColor(Color: Color3)
            assert(typeof(Color) == "Color3", "Color must be a Color3 value.")

            ImageLabel.ImageColor3 = Color
            Image.Color = Color
        end

        function Image:SetRectOffset(RectOffset: Vector2)
            assert(typeof(RectOffset) == "Vector2", "RectOffset must be a Vector2 value.")

            ImageLabel.ImageRectOffset = RectOffset
            Image.RectOffset = RectOffset
        end

        function Image:SetRectSize(RectSize: Vector2)
            assert(typeof(RectSize) == "Vector2", "RectSize must be a Vector2 value.")

            ImageLabel.ImageRectSize = RectSize
            Image.RectSize = RectSize
        end

        function Image:SetScaleType(ScaleType: Enum.ScaleType)
            assert(
                typeof(ScaleType) == "EnumItem" and ScaleType.EnumType == Enum.ScaleType,
                "ScaleType must be a valid Enum.ScaleType."
            )

            ImageLabel.ScaleType = ScaleType
            Image.ScaleType = ScaleType
        end

        function Image:SetTransparency(Transparency: number)
            assert(typeof(Transparency) == "number", "Transparency must be a number between 0 and 1.")
            assert(Transparency >= 0 and Transparency <= 1, "Transparency must be between 0 and 1.")

            ImageLabel.ImageTransparency = Transparency
            Image.Transparency = Transparency
        end

        function Image:SetVisible(Visible: boolean)
            Image.Visible = Visible

            Holder.Visible = Image.Visible
            Groupbox:Resize()
        end

        Groupbox:Resize()

        Image.Holder = Holder
        table.insert(Groupbox.Elements, Image)

        RegisterControl(Options, Idx, Image, "Image")

        function Image:Destroy()
            if Image.Destroyed then
                return
            end
            Image.Destroyed = true

            if Holder then 
                Holder:Destroy() 
            end

            local ElemIdx = table.find(Groupbox.Elements, Image)
            if ElemIdx then 
                table.remove(Groupbox.Elements, ElemIdx) 
            end

            Groupbox:Resize()
            RemoveStoredObject(Options, Image)
        end

        return Image
    end

    function Funcs:AddVideo(Idx, Info)
        if self.Destroyed then return nil end
        assert(Idx ~= nil, "AddVideo requires a non-nil index.")

        Info = Library:Validate(Info, Templates.Video)

        local Groupbox = self
        local Container = Groupbox.Container

        local Video = {
            Connections = {},
            Destroyed = false,

            Video = Info.Video,
            Looped = Info.Looped,
            Playing = Info.Playing,
            Volume = Info.Volume,
            Height = Info.Height,
            Visible = Info.Visible,

            Type = "Video",
        }

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, Info.Height),
            Visible = Video.Visible,
            Parent = Container,
        })

        local Box = New("Frame", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = "MainColor",
            BorderColor3 = "OutlineColor",
            BorderSizePixel = 1,
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.fromScale(1, 1),
            Parent = Holder,
        })

        New("UIPadding", {
            PaddingBottom = UDim.new(0, 3),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 4),
            Parent = Box,
        })

        local VideoFrameInstance = New("VideoFrame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Video = Video.Video,
            Looped = Video.Looped,
            Volume = Video.Volume,
            Parent = Box,
        })

        VideoFrameInstance.Playing = Video.Playing

        function Video:SetHeight(Height: number)
            assert(Height > 0, "Height must be greater than 0.")

            Video.Height = Height
            Holder.Size = UDim2.new(1, 0, 0, Height)
            Groupbox:Resize()
        end

        function Video:SetVideo(NewVideo: string)
            assert(typeof(NewVideo) == "string", "Video must be a string.")

            VideoFrameInstance.Video = NewVideo
            Video.Video = NewVideo
        end

        function Video:SetLooped(Looped: boolean)
            assert(typeof(Looped) == "boolean", "Looped must be a boolean.")

            VideoFrameInstance.Looped = Looped
            Video.Looped = Looped
        end

        function Video:SetVolume(Volume: number)
            assert(typeof(Volume) == "number", "Volume must be a number between 0 and 10.")

            VideoFrameInstance.Volume = Volume
            Video.Volume = Volume
        end

        function Video:SetPlaying(Playing: boolean)
            assert(typeof(Playing) == "boolean", "Playing must be a boolean.")

            VideoFrameInstance.Playing = Playing
            Video.Playing = Playing
        end

        function Video:Play()
            VideoFrameInstance.Playing = true
            Video.Playing = true
        end

        function Video:Pause()
            VideoFrameInstance.Playing = false
            Video.Playing = false
        end

        function Video:SetVisible(Visible: boolean)
            Video.Visible = Visible

            Holder.Visible = Video.Visible
            Groupbox:Resize()
        end

        Groupbox:Resize()

        Video.Holder = Holder
        Video.VideoFrame = VideoFrameInstance
        table.insert(Groupbox.Elements, Video)

        RegisterControl(Options, Idx, Video, "Video")

        function Video:Destroy()
            if Video.Destroyed then
                return
            end
            Video.Destroyed = true

            if Video.Connections then
                for _, Connection in Video.Connections do
                    Connection:Disconnect()
                end
            end

            if Holder then 
                Holder:Destroy() 
            end

            local ElemIdx = table.find(Groupbox.Elements, Video)
            if ElemIdx then 
                table.remove(Groupbox.Elements, ElemIdx) 
            end

            Groupbox:Resize()
            RemoveStoredObject(Options, Video)
        end

        return Video
    end

    function Funcs:AddUIPassthrough(Idx, Info)
        if self.Destroyed then return nil end
        assert(Idx ~= nil, "AddUIPassthrough requires a non-nil index.")

        Info = Library:Validate(Info, Templates.UIPassthrough)

        local Groupbox = self
        local Container = Groupbox.Container

        assert(Info.Instance, "Instance must be provided.")
        assert(
            typeof(Info.Instance) == "Instance" and Info.Instance:IsA("GuiBase2d"),
            "Instance must inherit from GuiBase2d."
        )
        assert(typeof(Info.Height) == "number" and Info.Height > 0, "Height must be a number greater than 0.")

        local Passthrough = {
            Connections = {},
            Destroyed = false,

            Instance = Info.Instance,
            Height = Info.Height,
            Visible = Info.Visible,

            Type = "UIPassthrough",
        }

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, Info.Height),
            Visible = Passthrough.Visible,
            Parent = Container,
        })

        Passthrough.Instance.Parent = Holder

        Groupbox:Resize()

        function Passthrough:SetHeight(Height: number)
            assert(typeof(Height) == "number" and Height > 0, "Height must be a number greater than 0.")

            Passthrough.Height = Height
            Holder.Size = UDim2.new(1, 0, 0, Height)
            Groupbox:Resize()
        end

        function Passthrough:SetInstance(Instance: Instance)
            assert(Instance, "Instance must be provided.")
            assert(
                typeof(Instance) == "Instance" and Instance:IsA("GuiBase2d"),
                "Instance must inherit from GuiBase2d."
            )

            if Passthrough.Instance then
                Passthrough.Instance.Parent = nil
            end

            Passthrough.Instance = Instance
            Passthrough.Instance.Parent = Holder
        end

        function Passthrough:SetVisible(Visible: boolean)
            Passthrough.Visible = Visible

            Holder.Visible = Passthrough.Visible
            Groupbox:Resize()
        end

        Passthrough.Holder = Holder
        table.insert(Groupbox.Elements, Passthrough)

        RegisterControl(Options, Idx, Passthrough, "Passthrough")

        function Passthrough:Destroy()
            if Passthrough.Destroyed then
                return
            end
            Passthrough.Destroyed = true

            if Passthrough.Connections then
                for _, Connection in Passthrough.Connections do
                    Connection:Disconnect()
                end
            end

            if Holder then 
                Holder:Destroy() 
            end

            local ElemIdx = table.find(Groupbox.Elements, Passthrough)
            if ElemIdx then 
                table.remove(Groupbox.Elements, ElemIdx) 
            end

            Groupbox:Resize()
            RemoveStoredObject(Options, Passthrough)
        end

        return Passthrough
    end

    function Funcs:AddDependencyBox()
        if self.Destroyed then return nil end

        local Groupbox = self
        local Container = Groupbox.Container

        local DepboxContainer
        local DepboxList

        do
            DepboxContainer = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Visible = false,
                Parent = Container,
            })

            DepboxList = New("UIListLayout", {
                Padding = UDim.new(0, 8),
                Parent = DepboxContainer,
            })
        end

        local Depbox = {
            Type = "DependencyBox",
            Connections = {},
            Destroyed = false,

            Visible = false,
            Dependencies = {},

            Holder = DepboxContainer,
            Container = DepboxContainer,
            Tab = Groupbox.Tab,
            RootTab = Groupbox.RootTab,

            Elements = {},
            DependencyBoxes = {}
        }

        function Depbox:Resize()
            DepboxContainer.Size = UDim2.new(1, 0, 0, DepboxList.AbsoluteContentSize.Y / Library.DPIScale)
            Groupbox:Resize()
        end

        function Depbox:Update(CancelSearch)
            for _, Dependency in Depbox.Dependencies do
                local Element = Dependency[1]
                local Value = Dependency[2]

                if Element.Type == "Toggle" and Element.Value ~= Value then
                    DepboxContainer.Visible = false
                    Depbox.Visible = false
                    return
                elseif Element.Type == "Dropdown" then
                    if typeof(Element.Value) == "table" then
                        if not Element.Value[Value] then
                            DepboxContainer.Visible = false
                            Depbox.Visible = false
                            return
                        end
                    else
                        if Element.Value ~= Value then
                            DepboxContainer.Visible = false
                            Depbox.Visible = false
                            return
                        end
                    end
                end
            end

            Depbox.Visible = true
            DepboxContainer.Visible = true
            if not Library.Searching then
                task.defer(function()
                    Depbox:Resize()
                end)
            elseif not CancelSearch then
                Library:UpdateSearch(Library.SearchText)
            end
        end

        table.insert(Depbox.Connections, DepboxList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            if not Depbox.Visible then
                return
            end

            Depbox:Resize()
        end))

        function Depbox:SetupDependencies(Dependencies)
            for _, Dependency in Dependencies do
                assert(typeof(Dependency) == "table", "Dependency should be a table.")
                assert(Dependency[1] ~= nil, "Dependency is missing element.")
                assert(Dependency[2] ~= nil, "Dependency is missing expected value.")
            end

            Depbox.Dependencies = Dependencies
            Depbox:Update()
        end

        table.insert(Depbox.Connections, DepboxContainer:GetPropertyChangedSignal("Visible"):Connect(function()
            Depbox:Resize()
        end))

        setmetatable(Depbox, BaseGroupbox)

        table.insert(Groupbox.DependencyBoxes, Depbox)
        table.insert(Library.DependencyBoxes, Depbox)

        function Depbox:Destroy()
            if Depbox.Destroyed then
                return
            end
            Depbox.Destroyed = true

            if Depbox.Connections then
                for _, Connection in Depbox.Connections do
                    Connection:Disconnect()
                end
            end

            DestroyObjects(Depbox.Elements)
            DestroyObjects(Depbox.DependencyBoxes)

            if DepboxContainer then 
                DepboxContainer:Destroy() 
            end

            local ElemIdx = table.find(Groupbox.DependencyBoxes, Depbox)
            if ElemIdx then 
                table.remove(Groupbox.DependencyBoxes, ElemIdx)
            end

            local LibIdx = table.find(Library.DependencyBoxes, Depbox)
            if LibIdx then 
                table.remove(Library.DependencyBoxes, LibIdx) 
            end
            RefreshSearchIfActive()
        end

        return Depbox
    end

    function Funcs:AddDependencyGroupbox()
        if self.Destroyed then return nil end

        local Groupbox = self
        assert(Groupbox.Type == "Groupbox", "Dependency groupboxes cannot be nested.")
        local Tab = Groupbox.Tab
        local BoxHolder = Groupbox.BoxHolder
        assert(Tab and BoxHolder, "Dependency groupboxes can only be added to a tab groupbox.")

        local DepGroupboxContainer
        local DepGroupboxList

        do
            DepGroupboxContainer = New("Frame", {
                BackgroundColor3 = "BackgroundColor",
                Size = UDim2.fromScale(1, 0),
                Visible = false,
                Parent = BoxHolder,
            })
            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius),
                    Parent = DepGroupboxContainer,
                })
            )
            Library:AddOutline(DepGroupboxContainer)

            DepGroupboxList = New("UIListLayout", {
                Padding = UDim.new(0, 8),
                Parent = DepGroupboxContainer,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 7),
                PaddingLeft = UDim.new(0, 7),
                PaddingRight = UDim.new(0, 7),
                PaddingTop = UDim.new(0, 7),
                Parent = DepGroupboxContainer,
            })
        end

        local DepGroupbox = {
            Type = "DependencyGroupbox",
            Connections = {},
            Destroyed = false,

            Visible = false,
            Dependencies = {},

            BoxHolder = BoxHolder,
            Holder = DepGroupboxContainer,
            Container = DepGroupboxContainer,

            Tab = Tab,
            ParentGroupbox = Groupbox,
            Elements = {},
            DependencyBoxes = {},
        }

        function DepGroupbox:Resize()
            DepGroupboxContainer.Size = UDim2.new(
                1,
                0,
                0,
                (DepGroupboxList.AbsoluteContentSize.Y / Library.DPIScale) + 14
            )
        end

        function DepGroupbox:Update(CancelSearch)
            for _, Dependency in DepGroupbox.Dependencies do
                local Element = Dependency[1]
                local Value = Dependency[2]

                if Element.Type == "Toggle" and Element.Value ~= Value then
                    DepGroupboxContainer.Visible = false
                    DepGroupbox.Visible = false
                    return
                elseif Element.Type == "Dropdown" then
                    if typeof(Element.Value) == "table" then
                        if not Element.Value[Value] then
                            DepGroupboxContainer.Visible = false
                            DepGroupbox.Visible = false
                            return
                        end
                    else
                        if Element.Value ~= Value then
                            DepGroupboxContainer.Visible = false
                            DepGroupbox.Visible = false
                            return
                        end
                    end
                end
            end

            DepGroupbox.Visible = true
            DepGroupboxContainer.Visible = true
            DepGroupbox:Resize()
            if Library.Searching and not CancelSearch then
                Library:UpdateSearch(Library.SearchText)
            end
        end

        function DepGroupbox:SetupDependencies(Dependencies)
            for _, Dependency in Dependencies do
                assert(typeof(Dependency) == "table", "Dependency should be a table.")
                assert(Dependency[1] ~= nil, "Dependency is missing element.")
                assert(Dependency[2] ~= nil, "Dependency is missing expected value.")
            end

            DepGroupbox.Dependencies = Dependencies
            DepGroupbox:Update()
        end

        setmetatable(DepGroupbox, BaseGroupbox)

        table.insert(
            DepGroupbox.Connections,
            DepGroupboxList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if DepGroupbox.Visible then
                    DepGroupbox:Resize()
                end
            end)
        )

        table.insert(Tab.DependencyGroupboxes, DepGroupbox)
        table.insert(Library.DependencyBoxes, DepGroupbox :: any)

        function DepGroupbox:Destroy()
            if DepGroupbox.Destroyed then
                return
            end
            DepGroupbox.Destroyed = true

            if DepGroupbox.Connections then
                for _, Connection in DepGroupbox.Connections do
                    Connection:Disconnect()
                end
            end

            DestroyObjects(DepGroupbox.Elements)
            DestroyObjects(DepGroupbox.DependencyBoxes)

            if DepGroupboxContainer then 
                DepGroupboxContainer:Destroy() 
            end

            local ElemIdx = table.find(Tab.DependencyGroupboxes, DepGroupbox)
            if ElemIdx then 
                table.remove(Tab.DependencyGroupboxes, ElemIdx) 
            end

            local LibIdx = table.find(Library.DependencyBoxes, DepGroupbox)
            if LibIdx then 
                table.remove(Library.DependencyBoxes, LibIdx) 
            end
            RefreshSearchIfActive()
        end

        return DepGroupbox
    end

    BaseGroupbox.__index = Funcs
    BaseGroupbox.__namecall = function(_, Key, ...)
        return Funcs[Key](...)
    end
end

local function UpdateLightThemeState()
    local Background = Library.Scheme.BackgroundColor
    if typeof(Background) ~= "Color3" then
        Library.IsLightTheme = false
        return
    end

    Library.IsLightTheme = (Background.R * 0.2126 + Background.G * 0.7152 + Background.B * 0.0722) > 0.55
end

function Library:ApplyScheme(Scheme)
    assert(typeof(Scheme) == "table", "Expected a scheme table, got: " .. typeof(Scheme))

    local Pending = {}
    for RawKey, Value in Scheme do
        local Key = RawKey == "FontFace" and "Font" or RawKey
        local Current = Library.Scheme[Key]

        if Key == "Font" then
            if typeof(Value) == "EnumItem" then
                Value = Font.fromEnum(Value :: any)
            end
            assert(typeof(Value) == "Font", "Scheme.Font must be a Font or Enum.Font value.")
        elseif Key == "BackgroundImage" then
            assert(typeof(Value) == "string" or typeof(Value) == "number", "Scheme.BackgroundImage must be a string or number.")
            Value = tostring(Value)
        elseif Current ~= nil then
            assert(
                typeof(Value) == typeof(Current),
                string.format("Scheme.%s must be %s, got %s.", tostring(Key), typeof(Current), typeof(Value))
            )
        else
            warn(string.format("Ignoring unknown scheme field %q.", tostring(RawKey)))
            continue
        end

        Pending[Key] = Value
    end

    for Key, Value in Pending do
        Library.Scheme[Key] = Value
    end

    UpdateLightThemeState()
    Library:UpdateColorsUsingRegistry()
    return Library.Scheme
end

function Library:SetScheme(Scheme)
    return Library:ApplyScheme(Scheme)
end

function Library:SetFont(FontFace)
    if typeof(FontFace) == "EnumItem" then
        FontFace = Font.fromEnum(FontFace :: any)
    end

    Library.Scheme.Font = FontFace
    Library:UpdateColorsUsingRegistry()
end

function Library:EnableBackgroundImage(Enable: boolean)
    assert(typeof(Enable) == "boolean", "Expected boolean for Enable, got: " .. typeof(Enable))

    Library.Scheme.BackgroundImageEnabled = Enable
    if Library.Window then
        Library.Window:EnableBackgroundImage(Enable)
    end

    Library:UpdateColorsUsingRegistry()
end

function Library:SetBackgroundImageEnabled(Enable: boolean)
    return Library:EnableBackgroundImage(Enable)
end

function Library:SetBackgroundImage(Image: string | number)
    assert(typeof(Image) == "string" or typeof(Image) == "number", "Expected string/number got " .. typeof(Image))

    Image = tostring(Image)
    Library.Scheme.BackgroundImage = Image
    if Library.Window then
        Library.Window:SetBackgroundImage(Image)
    end

    Library:UpdateColorsUsingRegistry()
end

function Library:SetGlow(Glow: boolean)
    assert(typeof(Glow) == "boolean", "Expected boolean for Glow, got: " .. typeof(Glow))

    Library.Scheme.WindowGlow = Glow
    if Library.Window then
        Library.Window:SetGlow(Glow)
    end

    Library:UpdateColorsUsingRegistry()
end

function Library:UpdateNotificationPositions(Snap: boolean?)
    local IsLeft = Library.NotifySide:lower() == "left"
    local XScale = IsLeft and 0 or 1
    local RunningY = 0

    for _, FakeBackground in NotifyOrder do
        local Data = Library.Notifications[FakeBackground]
        if not (Data and FakeBackground.Parent) then continue end

        local Target = UDim2.new(XScale, 0, 0, RunningY)
        if Snap or not Data.PositionInitialized then
            FakeBackground.Position = Target
            Data.PositionInitialized = true

        elseif FakeBackground.Position ~= Target then
            TweenService:Create(FakeBackground, Library.NotifyTweenInfo, {
                Position = Target,
            }):Play()
        end

        RunningY = RunningY + FakeBackground.AbsoluteSize.Y + 8
    end
end

function Library:SetNotifySide(Side: string)
    Library.NotifySide = Side

    local IsLeft = Side:lower() == "left"
    if IsLeft then
        NotificationArea.AnchorPoint = Vector2.new(0, 0)
        NotificationArea.Position = UDim2.fromOffset(6, 6)
    else
        NotificationArea.AnchorPoint = Vector2.new(1, 0)
        NotificationArea.Position = UDim2.new(1, -6, 0, 6)
    end

    for FakeBackground in Library.Notifications do
        if not (FakeBackground and FakeBackground.Parent) then continue end
        FakeBackground.AnchorPoint = if IsLeft then Vector2.new(0, 0) else Vector2.new(1, 0)
    end

    Library:UpdateNotificationPositions(true)
end

function Library:Notify(...)
    local Data = {}
    local Info = select(1, ...)

    if typeof(Info) == "table" then
        Data.Title = tostring(Info.Title)
        Data.TitleColor = Info.TitleColor

        Data.Description = tostring(Info.Description)
        Data.DescriptionColor = Info.DescriptionColor

        Data.Time = Info.Time or 5
        Data.SoundId = Info.SoundId
        Data.Steps = Info.Steps
        Data.Persist = Info.Persist

        Data.Icon = Info.Icon
        Data.BigIcon = Info.BigIcon
        Data.IconColor = Info.IconColor

        Data.Volume = tonumber(Info.Volume) or 3
    else
        Data.Description = tostring(Info)
        Data.Time = select(2, ...) or 5
        Data.SoundId = select(3, ...)
        Data.Volume = select(4, ...) or 3
    end
    if typeof(Data.Steps) == "number" and Data.Steps <= 0 then
        Data.Steps = nil
    end
    Data.Destroyed = false

    local DeletedInstance = false
    local DeleteConnection = nil
    if typeof(Data.Time) == "Instance" then
        DeleteConnection = Data.Time.Destroying:Connect(function()
            DeletedInstance = true

            DeleteConnection:Disconnect()
            DeleteConnection = nil
        end)
    end

    local FakeBackground = New("Frame", {
        AnchorPoint = Library.NotifySide:lower() == "left" and Vector2.new(0, 0) or Vector2.new(1, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 0),
        Visible = false,
        Parent = NotificationArea,
    })

    local Holder = New("Frame", {
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = "MainColor",
        Position = Library.NotifySide:lower() == "left" and UDim2.new(-1, -8, 0, -2) or UDim2.new(1, 8, 0, -2),
        Size = UDim2.fromScale(1, 1),
        ZIndex = 5,
        Parent = FakeBackground,
    })
    table.insert(
        Library.Corners,
        TrackCornerMode(New("UICorner", {
            CornerRadius = UDim.new(0, Library.CornerRadius > 6 and Library.CornerRadius / 2 or Library.CornerRadius),
            Parent = Holder,
        }), "AdaptiveHalf")
    )
    New("UIListLayout", {
        Padding = UDim.new(0, 4),
        Parent = Holder,
    })
    New("UIPadding", {
        PaddingBottom = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingTop = UDim.new(0, 8),
        Parent = Holder,
    })
    Library:AddOutline(Holder)

    local ContentContainer = New("Frame", {
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.XY,
        Size = UDim2.fromScale(1, 0),
        Parent = Holder,
    })
    
    if Data.BigIcon then
        New("UIListLayout", {
            Padding = UDim.new(0, 8),
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Parent = ContentContainer,
        })
    end

    local BigIconLabel
    if Data.BigIcon then
        local ParsedIcon = Library:GetCustomIcon(Data.BigIcon)
        if ParsedIcon then
            BigIconLabel = New("ImageLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.fromOffset(24, 24),
                Image = ParsedIcon.Url,
                ImageColor3 = Data.IconColor or "WhiteColor",
                ImageRectOffset = ParsedIcon.ImageRectOffset,
                ImageRectSize = ParsedIcon.ImageRectSize,
                Parent = ContentContainer,
            })
        end
    end

    local TextContainer = New("Frame", {
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.XY,
        Size = UDim2.fromScale(0, 0),
        Parent = ContentContainer,
    })
    New("UIListLayout", {
        Padding = UDim.new(0, 4),
        Parent = TextContainer,
    })
    
    local TitleContainer
    if Data.Title then
        TitleContainer = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(0, 0),
            Parent = TextContainer,
        })
    end

    local IconLabel
    if Data.Icon and TitleContainer then
        local ParsedIcon = Library:GetCustomIcon(Data.Icon)
        if ParsedIcon then
            IconLabel = New("ImageLabel", {
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(0, 0, 0.5, 1),
                Size = UDim2.fromOffset(15, 15),
                Image = ParsedIcon.Url,
                ImageColor3 = Data.IconColor or "AccentColor",
                ImageRectOffset = ParsedIcon.ImageRectOffset,
                ImageRectSize = ParsedIcon.ImageRectSize,
                Parent = TitleContainer,
            })
        end
    end

    local Title
    local Desc
    local TitleX = 0
    local DescX = 0

    local TimerFill

    if Data.Title then
        Title = New("TextLabel", {
            AutomaticSize = Enum.AutomaticSize.None,
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, (Data.Icon and 21 or 0), 0.5, 0),
            Size = UDim2.fromScale(0, 0),
            Text = Data.Title,
            TextColor3 = Data.TitleColor or "AccentColor",
            TextSize = 15,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
            TextWrapped = true,
            Parent = TitleContainer,
        })
    end

    if Data.Description then
        Desc = New("TextLabel", {
            AutomaticSize = Enum.AutomaticSize.None,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(0, 0),
            Text = Data.Description,
            TextColor3 = Data.DescriptionColor or "FontColor",
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = TextContainer,
        })
    end

    function Data:Resize()
        local ExtraWidth = BigIconLabel and 32 or 0
        local IconWidth = IconLabel and 21 or 0

        if Title then
            local X, Y =
                Library:GetTextBounds(Title.Text, Title.FontFace, Title.TextSize, (NotificationArea.AbsoluteSize.X / Library.DPIScale) - 24 - ExtraWidth - IconWidth)
            Title.Size = UDim2.fromOffset(X, Y)
            TitleX = X + IconWidth
            TitleContainer.Size = UDim2.fromOffset(TitleX, math.max(Y, IconLabel and 16 or 0))
        end

        if Desc then
            local X, Y =
                Library:GetTextBounds(Desc.Text, Desc.FontFace, Desc.TextSize, (NotificationArea.AbsoluteSize.X / Library.DPIScale) - 24 - ExtraWidth)
            Desc.Size = UDim2.fromOffset(X, Y)
            DescX = X
        end

        FakeBackground.Size = UDim2.fromOffset(math.max(TitleX, DescX) + 24 + ExtraWidth, 0)

        if Library.Notifications[FakeBackground] then
            Library:UpdateNotificationPositions()
        end
    end

    function Data:ChangeTitle(Text)
        if Title then
            Data.Title = tostring(Text)
            Title.Text = Data.Title
            Data:Resize()
        end
    end

    function Data:ChangeDescription(Text)
        if Desc then
            Data.Description = tostring(Text)
            Desc.Text = Data.Description
            Data:Resize()
        end
    end

    function Data:ChangeStep(NewStep)
        if TimerFill and Data.Steps then
            NewStep = math.clamp(NewStep or 0, 0, Data.Steps)
            TimerFill.Size = UDim2.fromScale(NewStep / Data.Steps, 1)
        end
    end

    function Data:Destroy()
        if Data.Destroyed then
            return
        end
        Data.Destroyed = true

        if typeof(Data.Time) == "Instance" then
            pcall(Data.Time.Destroy, Data.Time)
        end

        if DeleteConnection then
            DeleteConnection:Disconnect()
        end

        if FakeBackground then
            local Idx = table.find(NotifyOrder, FakeBackground)
            if Idx then
                table.remove(NotifyOrder, Idx)
            end
        end

        Library:UpdateNotificationPositions()

        TweenService
            :Create(Holder, Library.NotifyTweenInfo, {
                Position = Library.NotifySide:lower() == "left" and UDim2.new(-1, -8, 0, -2) or UDim2.new(1, 8, 0, -2),
            })
            :Play()

        task.delay(Library.NotifyTweenInfo.Time, function()
            Library.Notifications[FakeBackground] = nil
            FakeBackground:Destroy()
        end)
    end

    Data:Resize()

    local TimerHolder = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 7),
        Visible = (Data.Persist ~= true and typeof(Data.Time) ~= "Instance") or typeof(Data.Steps) == "number",
        Parent = Holder,
    })
    local TimerBar = New("Frame", {
        BackgroundColor3 = "BackgroundColor",
        BorderColor3 = "OutlineColor",
        BorderSizePixel = 1,
        Position = UDim2.fromOffset(0, 3),
        Size = UDim2.new(1, 0, 0, 2),
        Parent = TimerHolder,
    })
    TimerFill = New("Frame", {
        BackgroundColor3 = "AccentColor",
        Size = UDim2.fromScale(1, 1),
        Parent = TimerBar,
    })

    if typeof(Data.Time) == "Instance" then
        TimerFill.Size = UDim2.fromScale(0, 1)
    end
    if Data.SoundId then
        local SoundId = Data.SoundId
        if typeof(SoundId) == "number" then
            SoundId = string.format("rbxassetid://%d", SoundId)
        end

        New("Sound", {
            SoundId = SoundId,
            Volume = tonumber(Data.Volume) or 3,
            PlayOnRemove = true,
            Parent = SoundService,
        }):Destroy()
    end

    Data.Holder = Holder

    table.insert(NotifyOrder, FakeBackground)
    Library.Notifications[FakeBackground] = Data

    Library:UpdateNotificationPositions()

    FakeBackground.Visible = true
    TweenService:Create(Holder, Library.NotifyTweenInfo, {
        Position = UDim2.fromOffset(0, 0),
    }):Play()

    task.delay(Library.NotifyTweenInfo.Time, function()
        if Data.Persist then
            return
        elseif typeof(Data.Time) == "Instance" then
            repeat
                task.wait()
            until DeletedInstance or Data.Destroyed
        else
            TweenService
                :Create(TimerFill, TweenInfo.new(Data.Time, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                    Size = UDim2.fromScale(0, 1),
                })
                :Play()
            task.wait(Data.Time)
        end

        if not Data.Destroyed then
            Data:Destroy()
        end
    end)

    return Data
end

function Library:CreateWindow(WindowInfo)
    local RawWindowInfo = typeof(WindowInfo) == "table" and WindowInfo or {}
    local HasFont = RawWindowInfo.Font ~= nil
    local HasGlow = RawWindowInfo.Glow ~= nil
    local HasBackgroundImageEnabled = RawWindowInfo.BackgroundImageEnabled ~= nil
    local HasBackgroundImage = RawWindowInfo.BackgroundImage ~= nil
    local RequestedScheme = RawWindowInfo.Scheme or RawWindowInfo.Colors

    WindowInfo = Library:Validate(WindowInfo, Templates.Window)
    if RequestedScheme ~= nil then
        Library:ApplyScheme(RequestedScheme)
    end

    if not HasFont then
        WindowInfo.Font = Library.Scheme.Font
    end
    if not HasGlow then
        WindowInfo.Glow = Library.Scheme.WindowGlow
    end
    if not HasBackgroundImageEnabled then
        WindowInfo.BackgroundImageEnabled = Library.Scheme.BackgroundImageEnabled
    end
    if not HasBackgroundImage then
        WindowInfo.BackgroundImage = Library.Scheme.BackgroundImage
    end

    local ViewportSize: Vector2 = workspace.CurrentCamera.ViewportSize
    if RunService:IsStudio() and ViewportSize.X <= 5 and ViewportSize.Y <= 5 then
        repeat
            ViewportSize = workspace.CurrentCamera.ViewportSize
            task.wait()
        until ViewportSize.X > 5 and ViewportSize.Y > 5
    end

    local MaxX = ViewportSize.X - 64
    local MaxY = ViewportSize.Y - 64

    Library.OriginalMinSize =
        Vector2.new(math.min(Library.OriginalMinSize.X, MaxX), math.min(Library.OriginalMinSize.Y, MaxY))
    Library.MinSize = Library.OriginalMinSize

    WindowInfo.Size = UDim2.fromOffset(
        math.clamp(WindowInfo.Size.X.Offset, Library.MinSize.X, MaxX),
        math.clamp(WindowInfo.Size.Y.Offset, Library.MinSize.Y, MaxY)
    )
    WindowInfo.MinContainerWidth = math.clamp(
        WindowInfo.MinContainerWidth,
        64,
        WindowInfo.Size.X.Offset - 49
    )
    if typeof(WindowInfo.Font) == "EnumItem" then
        WindowInfo.Font = Font.fromEnum(WindowInfo.Font :: any)
    end
    WindowInfo.CornerRadius = math.clamp(WindowInfo.CornerRadius, 0, 20)
    
    --// Old Naming \\--
    if WindowInfo.Compact ~= nil then
        WindowInfo.SidebarCompacted = WindowInfo.Compact
    end
    if WindowInfo.SidebarMinWidth ~= nil then
        WindowInfo.MinSidebarWidth = WindowInfo.SidebarMinWidth
    end
    WindowInfo.MinSidebarWidth = math.max(64, WindowInfo.MinSidebarWidth)
    WindowInfo.SidebarCompactWidth = math.max(48, WindowInfo.SidebarCompactWidth)
    WindowInfo.SidebarCollapseThreshold = math.clamp(WindowInfo.SidebarCollapseThreshold, 0.1, 0.9)
    WindowInfo.CompactWidthActivation = math.max(48, WindowInfo.CompactWidthActivation)

    Library.CornerRadius = WindowInfo.CornerRadius
    Library:SetNotifySide(WindowInfo.NotifySide)
    Library.ShowCustomCursor = WindowInfo.ShowCustomCursor
    Library.Scheme.Font = WindowInfo.Font
    Library.ToggleKeybind = WindowInfo.ToggleKeybind
    Library.GlobalSearch = WindowInfo.GlobalSearch
    
    Library.Animations = WindowInfo.Animations or Library.Animations or DeepClone(Templates.Window.Animations)
    Library.Scheme.BackgroundImageEnabled = WindowInfo.BackgroundImageEnabled
    Library.Scheme.BackgroundImage = WindowInfo.BackgroundImage
    Library.Scheme.WindowGlow = WindowInfo.Glow
    Library.TabTransitionInfo = TweenInfo.new(
        math.max(0, WindowInfo.TabTransitionTime or 0.22),
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    Library.TabSwipeOffset = math.max(1, WindowInfo.TabSwipeOffset or 26)
    Library.TabSwipeFrom = WindowInfo.TabSwipeFrom or "right"

    local IsDefaultSearchbarSize = WindowInfo.SearchbarSize == UDim2.fromScale(1, 1)
    local MainFrame
    local Glow
    local DividerLine
    local TitleHolder
    local WindowTitle
    local WindowIcon
    local RightWrapper
    local SearchBox
    local CurrentTabInfo
    local CurrentTabLabel
    local CurrentTabDescription
    local ResizeButton
    local Tabs
    local Container
    local BackgroundImage
    local BottomBackground
    local FooterLabel
    local TopBar
    local Window = {}

    local InitialLeftWidth = math.clamp(
        math.ceil(WindowInfo.Size.X.Offset * 0.3),
        48,
        WindowInfo.Size.X.Offset - WindowInfo.MinContainerWidth - 1
    )
    local IsCompact = WindowInfo.SidebarCompacted
    local LastExpandedWidth = InitialLeftWidth

    do
        Library.KeybindFrame, Library.KeybindContainer = Library:AddDraggableMenu("Keybinds")
        Library.KeybindFrame.AnchorPoint = Vector2.new(0, 0.5)
        Library.KeybindFrame.Position = UDim2.new(0, 6, 0.5, 0)
        Library.KeybindFrame.Visible = false

        MainFrame = New("TextButton", {
            BackgroundColor3 = function()
                return Library:GetBetterColor(Library.Scheme.BackgroundColor, -1)
            end,
            BackgroundTransparency = WindowInfo.WindowTransparency,
            Name = "Main",
            Text = "",
            Position = WindowInfo.Position,
            Size = WindowInfo.Size,
            Visible = false,
            Parent = ScreenGui,
        })
        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                Parent = MainFrame,
            })
        )
        table.insert(
            Library.Scales,
            New("UIScale", {
                Parent = MainFrame,
            })
        )
        Library:AddOutline(MainFrame)
        Library:MakeLine(MainFrame, {
            Position = UDim2.fromOffset(0, 48),
            Size = UDim2.new(1, 0, 0, 1),
        })

        Glow = New("ImageLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(-20, -20),
            Size = UDim2.new(1, 40, 1, 40),
            ZIndex = -1,
            Image = CustomImageManager.GetAsset("Glow"),
            ImageColor3 = function()
                return Library:GetBetterColor(Library.Scheme.AccentColor, -1)
            end,
            ImageTransparency = 0.78,
            Visible = WindowInfo.Glow,
            Parent = MainFrame,
        })

        DividerLine = New("Frame", {
            BackgroundColor3 = "OutlineColor",
            Position = UDim2.fromOffset(InitialLeftWidth, 0),
            Size = UDim2.new(0, 1, 1, -21),
            Parent = MainFrame,
            ZIndex = 2
        })

        local BackgroundIcon = Library:GetCustomIcon(WindowInfo.BackgroundImage)
        BackgroundImage = New("ImageLabel", {
            Image = BackgroundIcon and BackgroundIcon.Url or "",
            ImageRectOffset = BackgroundIcon and BackgroundIcon.ImageRectOffset or Vector2.zero,
            ImageRectSize = BackgroundIcon and BackgroundIcon.ImageRectSize or Vector2.zero,
            Position = UDim2.fromScale(0, 0),
            Size = UDim2.fromScale(1, 1),
            ScaleType = Enum.ScaleType.Stretch,
            ZIndex = 1,
            BackgroundTransparency = 1,
            ImageTransparency = 0.82,
            Visible = WindowInfo.BackgroundImageEnabled and BackgroundIcon ~= nil,
            Parent = MainFrame,
        })

        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                Parent = BackgroundImage,
            })
        )

        if WindowInfo.Center then
            MainFrame.Position = UDim2.new(0.5, -MainFrame.Size.X.Offset / 2, 0.5, -MainFrame.Size.Y.Offset / 2)
        end

        --// Top Bar \\-
        TopBar = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 48),
            Parent = MainFrame,
        })
        Library:MakeDraggable(MainFrame, TopBar, false, true)

        --// Title \\--
        TitleHolder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, InitialLeftWidth, 1, 0),
            Parent = TopBar,
        })
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 6),
            Parent = TitleHolder,
        })

        if WindowInfo.Icon then
            local Icon = Library:GetCustomIcon(WindowInfo.Icon)
            if Icon then
                WindowIcon = New("ImageLabel", {
                    Image = Icon.Url,
                    ImageRectOffset = Icon.ImageRectOffset,
                    ImageRectSize = Icon.ImageRectSize,
                    Size = WindowInfo.IconSize,
                    Parent = TitleHolder,
                })
            end
        end
        if not WindowIcon then
            WindowInfo.Icon = nil
            WindowIcon = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = WindowInfo.IconSize,
                Text = WindowInfo.Title:sub(1, 1),
                TextScaled = true,
                Visible = IsCompact,
                Parent = TitleHolder,
            })
        end

        local X = Library:GetTextBounds(
            WindowInfo.Title,
            Library.Scheme.Font,
            20,
            TitleHolder.AbsoluteSize.X - (WindowInfo.Icon and WindowInfo.IconSize.X.Offset + 6 or 0) - 12
        )
        WindowTitle = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, X, 1, 0),
            Text = WindowInfo.Title,
            TextSize = 20,
            Parent = TitleHolder,
        })

        --// Top Right Bar \\--
        RightWrapper = New("Frame", {
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -49, 0.5, 0),
            Size = UDim2.new(1, -InitialLeftWidth - 57 - 1, 1, -16),
            Parent = TopBar,
        })

        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Parent = RightWrapper,
        })

        CurrentTabInfo = New("Frame", {
            Size = UDim2.fromScale(WindowInfo.DisableSearch and 1 or 0.65, 1),
            Visible = false,
            BackgroundTransparency = 1,
            Parent = RightWrapper,
        })

        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Parent = CurrentTabInfo,
        })

        New("UIPadding", {
            PaddingBottom = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 6),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 8),
            Parent = CurrentTabInfo,
        })

        CurrentTabLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Text = "",
            TextSize = 18,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = CurrentTabInfo,
        })

        CurrentTabDescription = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Text = "",
            TextWrapped = true,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = CurrentTabInfo,
        })

        SearchBox = New("TextBox", {
            BackgroundColor3 = "MainColor",
            Size = WindowInfo.SearchbarSize,
            PlaceholderText = "Search...",
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Visible = not (WindowInfo.DisableSearch or false),
            Parent = RightWrapper,
        })
        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                Parent = SearchBox,
            })
        )
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 28),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 8),
            Parent = SearchBox,
        })
        New("UIStroke", {
            Color = "OutlineColor",
            Parent = SearchBox,
        })

        local SearchIcon = Library:GetIcon("search")
        if SearchIcon then
            New("ImageLabel", {
                Position = UDim2.fromOffset(-22, 0),
                Image = SearchIcon.Url,
                ImageColor3 = "FontColor",
                ImageRectOffset = SearchIcon.ImageRectOffset,
                ImageRectSize = SearchIcon.ImageRectSize,
                ImageTransparency = 0.5,
                Size = UDim2.fromScale(1, 1),
                SizeConstraint = Enum.SizeConstraint.RelativeYY,
                Parent = SearchBox,
            })
        end

        if MoveIcon then
            New("ImageLabel", {
                AnchorPoint = Vector2.new(1, 0.5),
                Image = MoveIcon.Url,
                ImageColor3 = "OutlineColor",
                ImageRectOffset = MoveIcon.ImageRectOffset,
                ImageRectSize = MoveIcon.ImageRectSize,
                Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.fromOffset(28, 28),
                SizeConstraint = Enum.SizeConstraint.RelativeYY,
                Parent = TopBar,
            })
        end

        --// Bottom Bar \\--
        BottomBackground = New("Frame", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = function()
                return Library:GetBetterColor(Library.Scheme.BackgroundColor, 4)
            end,
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.new(1, 0, 0, 20 + WindowInfo.CornerRadius),
            Parent = MainFrame
        })
        Library:MakeLine(MainFrame, {
            AnchorPoint = Vector2.new(0, 1),
            Position = UDim2.new(0, 0, 1, -20),
            Size = UDim2.new(1, 0, 0, 1),
        })

        local BottomBar = New("Frame", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundTransparency = 1,
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.new(1, 0, 0, 20),
            Parent = MainFrame,
        })
        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                Parent = BottomBackground,
            })
        )

        --// Footer \\-
        FooterLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Text = WindowInfo.Footer,
            TextSize = 14,
            TextTransparency = 0.5,
            Parent = BottomBar,
        })

        --// Resize Button \\--
        if WindowInfo.Resizable then
            ResizeButton = New("TextButton", {
                AnchorPoint = Vector2.new(1, 0),
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -WindowInfo.CornerRadius / 4, 0, 0),
                Size = UDim2.fromScale(1, 1),
                SizeConstraint = Enum.SizeConstraint.RelativeYY,
                Text = "",
                Parent = BottomBar,
            })

            Library:MakeResizable(MainFrame, ResizeButton, function()
                Window:SetSidebarWidth(Window:GetSidebarWidth())
                for _, Tab in Library.Tabs do
                    Tab:Resize(true)
                end
            end)
        end

        if ResizeButton then
            New("ImageLabel", {
                Image = ResizeIcon and ResizeIcon.Url or "",
                ImageColor3 = "FontColor",
                ImageRectOffset = ResizeIcon and ResizeIcon.ImageRectOffset or Vector2.zero,
                ImageRectSize = ResizeIcon and ResizeIcon.ImageRectSize or Vector2.zero,
                ImageTransparency = 0.5,
                Position = UDim2.fromOffset(2, 2),
                Size = UDim2.new(1, -4, 1, -4),
                Parent = ResizeButton,
            })
        end

        --// Tabs \\--
        Tabs = New("ScrollingFrame", {
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = "BackgroundColor",
            BackgroundTransparency = WindowInfo.PanelTransparency,
            CanvasSize = UDim2.fromScale(0, 0),
            Position = UDim2.fromOffset(0, 49),
            ScrollBarThickness = 0,
            Size = UDim2.new(0, InitialLeftWidth, 1, -70),
            Parent = MainFrame,
        })
        New("UIListLayout", {
            Parent = Tabs,
        })
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 4),
            PaddingLeft = UDim.new(0, 4),
            PaddingRight = UDim.new(0, 4),
            PaddingTop = UDim.new(0, 4),
            Parent = Tabs,
        })

        --// Container \\--
        Container = New("Frame", {
            AnchorPoint = Vector2.new(1, 0),
            BackgroundColor3 = function()
                return Library:GetBetterColor(Library.Scheme.BackgroundColor, 1)
            end,
            BackgroundTransparency = WindowInfo.PanelTransparency,
            ClipsDescendants = true,
            Name = "Container",
            Position = UDim2.new(1, 0, 0, 49),
            Size = UDim2.new(1, -InitialLeftWidth - 1, 1, -70),
            Parent = MainFrame,
        })
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 6),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 6),
            Parent = Container,
        })

        Library.WindowContainer = Container
    end

    --// Window Table \\--
    local Fading = false
    local PendingToggleValue = nil

    local function SetUICorner(UICorner, Corner, HalfCurrent, HalfValue, Value)
        local Current = UICorner[Corner]
        if Current.Offset == 0 and Current.Scale == 0 then
            return
        end

        UICorner[Corner] = Current.Offset == HalfCurrent and HalfValue or Value
    end

    function Window:ChangeTitle(Title)
        assert(typeof(Title) == "string", "Expected string for Title got: " .. typeof(Title))

        WindowTitle.Text = Title
        WindowInfo.Title = Title
    end

    function Window:EnableBackgroundImage(State: boolean)
        assert(typeof(State) == "boolean", "Expected boolean for State, got: " .. typeof(State))
        BackgroundImage.Visible = State and BackgroundImage.Image ~= ""
        WindowInfo.BackgroundImageEnabled = State
        Library.Scheme.BackgroundImageEnabled = State
    end

    function Window:SetBackgroundImageEnabled(State: boolean)
        return Window:EnableBackgroundImage(State)
    end

    function Window:SetBackgroundImage(Image: string | number)
        assert(typeof(Image) == "string" or typeof(Image) == "number", "Expected string/number got " .. typeof(Image))
        Image = tostring(Image)
        local ValidIcon = false

        if typeof(Image) == "string" then
            local BackgroundIcon = Library:GetCustomIcon(Image)

            if BackgroundIcon then
                ValidIcon = true

                BackgroundImage.Image = BackgroundIcon.Url
                BackgroundImage.ImageRectOffset = BackgroundIcon.ImageRectOffset
                BackgroundImage.ImageRectSize = BackgroundIcon.ImageRectSize
                BackgroundImage.Visible = WindowInfo.BackgroundImageEnabled
            elseif Image:match("http://") or Image:match("https://") then
                local URLWithoutQuery = Image:match("^[^?#]+") or Image
                local Extension = URLWithoutQuery:match("(%.[%w]+)$") or ".png"
                local Hash = 5381
                for Index = 1, #Image do
                    Hash = (Hash * 33 + string.byte(Image, Index)) % 2147483647
                end

                local BaseAssetName = string.format("background_%08x%s", Hash, Extension)
                local AssetName = BaseAssetName
                local Suffix = 2
                while
                    CustomImageManagerAssets[AssetName]
                    and CustomImageManagerAssets[AssetName].URL ~= Image
                do
                    AssetName = string.format("background_%08x_%d%s", Hash, Suffix, Extension)
                    Suffix += 1
                end

                ValidIcon = true
                if CustomImageManagerAssets[AssetName] == nil then
                    CustomImageManager.AddAsset(AssetName, 0, Image)
                else
                    CustomImageManager.DownloadAsset(AssetName, true)
                end

                BackgroundImage.Image = CustomImageManager.GetAsset(AssetName)
                BackgroundImage.ImageRectOffset = Vector2.zero
                BackgroundImage.ImageRectSize = Vector2.zero
                BackgroundImage.Visible = WindowInfo.BackgroundImageEnabled
            end
        end

        if not ValidIcon then
            BackgroundImage.Image = ""
            BackgroundImage.ImageRectOffset = Vector2.zero
            BackgroundImage.ImageRectSize = Vector2.zero
            BackgroundImage.Visible = false
        end
    
        WindowInfo.BackgroundImage = Image
        Library.Scheme.BackgroundImage = Image
    end

    function Window:SetGlow(State: boolean)
        assert(typeof(State) == "boolean", "Expected boolean for State, got: " .. typeof(State))
        Glow.Visible = State
        WindowInfo.Glow = State
        Library.Scheme.WindowGlow = State
    end

    function Window:SetFooter(Footer: string)
        assert(typeof(Footer) == "string", "Expected string for Footer got: " .. typeof(Footer))

        FooterLabel.Text = Footer
        WindowInfo.Footer = Footer
    end

    function Window:SetCornerRadius(Radius: number)
        assert(typeof(Radius) == "number", "Expected number for Radius got: " .. typeof(Radius))
        Radius = math.clamp(Radius, 0, 20)

        local RadiusHalf = UDim.new(0, Radius / 2)
        local RadiusUDim = UDim.new(0, Radius)
        local HalfCurrent = Library.CornerRadius / 2

        for Index = #Library.Corners, 1, -1 do
            local UICorner = Library.Corners[Index]
            if not UICorner.Parent then
                Library.CornerModes[UICorner] = nil
                table.remove(Library.Corners, Index)
                continue
            end

            local Mode = Library.CornerModes[UICorner] or "Full"
            if Mode == "Half" then
                UICorner.CornerRadius = RadiusHalf
            elseif Mode == "AdaptiveHalf" then
                UICorner.CornerRadius = UDim.new(0, Radius > 6 and Radius / 2 or Radius)
            else
                UICorner.CornerRadius = RadiusUDim
            end
        end

        for Index = #Library.SpecificCorners, 1, -1 do
            local UICorner = Library.SpecificCorners[Index]
            if not UICorner.Parent then
                table.remove(Library.SpecificCorners, Index)
                continue
            end

            SetUICorner(UICorner, "TopRightRadius", HalfCurrent, RadiusHalf, RadiusUDim)
            SetUICorner(UICorner, "TopLeftRadius", HalfCurrent, RadiusHalf, RadiusUDim)
            SetUICorner(UICorner, "BottomRightRadius", HalfCurrent, RadiusHalf, RadiusUDim)
            SetUICorner(UICorner, "BottomLeftRadius", HalfCurrent, RadiusHalf, RadiusUDim)
        end

        Library.CornerRadius = Radius
        WindowInfo.CornerRadius = Radius

        if ResizeButton then
            ResizeButton.Position = UDim2.new(1, -Radius / 4, 0, 0)
        end
        BottomBackground.Size = UDim2.new(1, 0, 0, 20 + Radius)

        for _, Tab in Library.Tabs do
            if Tab.IsKeyTab then
                continue
            end

            for _, Tabbox in Tab.Tabboxes do
                Tabbox:UpdateCorners()
            end
            for _, Page in ipairs(Tab.OrderedPages or {}) do
                for _, Tabbox in Page.Tabboxes do
                    Tabbox:UpdateCorners()
                end
            end
        end
    end

    function Window:SetAnimations(Animations: { [string]: boolean }?, TabTransitionTime: number?, TabSwipeOffset: number?, TabSwipeFrom: ("left" | "right" | "top" | "bottom" | string)?)
        if typeof(Animations) == "table" then
            WindowInfo.Animations = Animations
            Library.Animations = Animations
        end

        if typeof(TabTransitionTime) == "number" then
            local TweenInfo = TweenInfo.new(
                math.max(0, TabTransitionTime or 0.22),
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            )

            WindowInfo.TabTransitionInfo = TweenInfo
            Library.TabTransitionInfo = TweenInfo
        end

        if typeof(TabSwipeOffset) == "number" then
            TabSwipeOffset = math.max(1, TabSwipeOffset)

            WindowInfo.TabSwipeOffset = TabSwipeOffset
            Library.TabSwipeOffset = TabSwipeOffset
        end

        if typeof(TabSwipeFrom) == "string" then
            TabSwipeFrom = string.lower(TabSwipeFrom)

            WindowInfo.TabSwipeFrom = TabSwipeFrom
            Library.TabSwipeFrom = TabSwipeFrom
        end
    end

    local function ApplyCompact()
        IsCompact = Window:GetSidebarWidth() == WindowInfo.SidebarCompactWidth
        if WindowInfo.DisableCompactingSnap then
            IsCompact = Window:GetSidebarWidth() <= WindowInfo.CompactWidthActivation
        end

        WindowTitle.Visible = not IsCompact
        if not WindowInfo.Icon then
            WindowIcon.Visible = IsCompact
        end

        for _, Button in Library.TabButtons do
            Button.Button.BackgroundColor3 = IsCompact and Library.Scheme.AccentColor or Library.Scheme.MainColor
            Button.Label.Visible = not IsCompact
            Button.Padding.PaddingBottom = UDim.new(0, IsCompact and 8 or 11)
            Button.Padding.PaddingLeft = UDim.new(0, IsCompact and 8 or 12)
            Button.Padding.PaddingRight = UDim.new(0, IsCompact and 8 or 12)
            Button.Padding.PaddingTop = UDim.new(0, IsCompact and 8 or 11)
            if Button.Icon then
                Button.Icon.SizeConstraint = IsCompact and Enum.SizeConstraint.RelativeXY
                    or Enum.SizeConstraint.RelativeYY
            end
            if Button.Decoration then
                Button.Decoration.Visible = IsCompact
            end
            if Button.Corner then
                Button.Corner.CornerRadius = UDim.new(0, IsCompact and 4 or 0)
            end
            if Button.Tooltip then
                Button.Tooltip.Enabled = IsCompact
            end
        end
    end

    function Window:IsSidebarCompacted()
        return IsCompact
    end

    function Window:SetCompact(State)
        Window:SetSidebarWidth(State and WindowInfo.SidebarCompactWidth or LastExpandedWidth)
    end

    function Window:GetSidebarWidth()
        return Tabs.Size.X.Offset
    end

    function Window:SetSidebarWidth(Width)
        Width = math.clamp(Width, 48, MainFrame.Size.X.Offset - WindowInfo.MinContainerWidth - 1)

        DividerLine.Position = UDim2.fromOffset(Width, 0)

        TitleHolder.Size = UDim2.new(0, Width, 1, 0)
        RightWrapper.Size = UDim2.new(1, -Width - 57 - 1, 1, -16)
        Tabs.Size = UDim2.new(0, Width, 1, -70)
        Container.Size = UDim2.new(1, -Width - 1, 1, -70)

        if WindowInfo.EnableCompacting then
            ApplyCompact()
        end
        if not IsCompact then
            LastExpandedWidth = Width
        end
    end

    function Window:ShowTabInfo(Name, Description)
        CurrentTabLabel.Text = `<b>{Name or "Name"}</b>`
        CurrentTabDescription.Text = Description or "No information is provided for this tab."

        if IsDefaultSearchbarSize then
            SearchBox.Size = UDim2.fromScale(0.35, 1)
        end
        CurrentTabInfo.Visible = true
    end

    function Window:HideTabInfo()
        CurrentTabInfo.Visible = false
        if IsDefaultSearchbarSize then
            SearchBox.Size = UDim2.fromScale(1, 1)
        end
    end

    local function ShowFirstAvailableTab(ExcludedTab)
        if Library.ActiveTab or Library.Unloaded then
            return
        end

        for _, Entry in ipairs(Library.TabButtons) do
            local Candidate = Entry.Tab
            if
                Candidate ~= ExcludedTab
                and typeof(Candidate) == "table"
                and not Candidate.Destroyed
                and Candidate.Button
                and Candidate.Button.Visible
                and Candidate.Show
            then
                Candidate:Show()
                return
            end
        end

        Window:HideTabInfo()
    end

    function Window:AddTab(...)
        local Name = nil
        local Icon = nil
        local Description = nil
        local FullWidth = false

        if select("#", ...) == 1 and typeof(...) == "table" then
            local Info = select(1, ...)
            Name = Info.Name or "Tab"
            Icon = Info.Icon
            Description = Info.Description or "No information is provided for this tab."
            FullWidth = Info.FullWidth == true or Info.Special == true or Info.Layout == "FullWidth"
        else
            Name = select(1, ...) or "Tab"
            Icon = select(2, ...)
            Description = select(3, ...) or "No information is provided for this tab."
        end

        Icon = Icon or "file-question-mark"

        local TabButton: TextButton
        local TabLabel
        local TabDecoration
        local TabIcon
        local TabButtonEntry
        local TabButtonCorner

        local TabContainer
        local TabCanvas
        local TabRootContent
        local TabLeft
        local TabRight
        local PageNavigation
        local PageButtons
        local PageButtonsList

        Icon = if Icon == "file-question-mark" then FileQuestionMarkIcon else Library:GetCustomIcon(Icon)

        local function CreateLayoutScope(Parent, ScopeFullWidth)
            local Left = New("ScrollingFrame", {
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                CanvasSize = UDim2.fromScale(0, 0),
                ScrollBarImageTransparency = 1,
                ScrollBarThickness = 0,
                Size = UDim2.new(ScopeFullWidth and 1 or 0.5, ScopeFullWidth and 0 or -5, 1, 0),
                Parent = Parent,
            })
            New("UIListLayout", {
                Padding = UDim.new(0, 2),
                Parent = Left,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 2),
                PaddingLeft = UDim.new(0, 2),
                PaddingRight = UDim.new(0, 2),
                PaddingTop = UDim.new(0, 2),
                Parent = Left,
            })
            New("Frame", {
                BackgroundTransparency = 1,
                LayoutOrder = -1,
                Parent = Left,
            })
            New("Frame", {
                BackgroundTransparency = 1,
                LayoutOrder = 1,
                Parent = Left,
            })

            local Right = New("ScrollingFrame", {
                AnchorPoint = Vector2.new(1, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                CanvasSize = UDim2.fromScale(0, 0),
                Position = UDim2.fromScale(1, 0),
                ScrollBarImageTransparency = 1,
                ScrollBarThickness = 0,
                Size = UDim2.new(0.5, -5, 1, 0),
                Visible = not ScopeFullWidth,
                Parent = Parent,
            })
            New("UIListLayout", {
                Padding = UDim.new(0, 2),
                Parent = Right,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 2),
                PaddingLeft = UDim.new(0, 2),
                PaddingRight = UDim.new(0, 2),
                PaddingTop = UDim.new(0, 2),
                Parent = Right,
            })
            New("Frame", {
                BackgroundTransparency = 1,
                LayoutOrder = -1,
                Parent = Right,
            })
            New("Frame", {
                BackgroundTransparency = 1,
                LayoutOrder = 1,
                Parent = Right,
            })

            return Left, Right
        end

        do
            TabButton = New("TextButton", {
                BackgroundColor3 = function()
                    return IsCompact and Library.Scheme.AccentColor or Library.Scheme.MainColor
                end,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 40),
                Text = "",
                Parent = Tabs,
            })
            local ButtonPadding = New("UIPadding", {
                PaddingBottom = UDim.new(0, IsCompact and 8 or 11),
                PaddingLeft = UDim.new(0, IsCompact and 8 or 12),
                PaddingRight = UDim.new(0, IsCompact and 8 or 12),
                PaddingTop = UDim.new(0, IsCompact and 8 or 11),
                Parent = TabButton,
            })
            TabButtonCorner = New("UICorner", {
                CornerRadius = UDim.new(0, IsCompact and 4 or 0),
                Parent = TabButton,
            })

            TabLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(30, 0),
                Size = UDim2.new(1, -30, 1, 0),
                Text = Name,
                TextSize = 16,
                TextTransparency = 0.5,
                TextXAlignment = Enum.TextXAlignment.Left,
                Visible = not IsCompact,
                Parent = TabButton,
            })

            TabDecoration = New("Frame", {
                BackgroundColor3 = "AccentColor",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.fromOffset(-11, 0),
                Size = UDim2.new(0, 2, 1, 0),
                Visible = IsCompact,
                Parent = TabButton,
            })
            New("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = TabDecoration,
            })

            if Icon then
                TabIcon = New("ImageLabel", {
                    Image = Icon.Url,
                    ImageColor3 = Icon.Custom and "WhiteColor" or "AccentColor",
                    ImageRectOffset = Icon.ImageRectOffset,
                    ImageRectSize = Icon.ImageRectSize,
                    ImageTransparency = 0.5,
                    ScaleType = Enum.ScaleType.Fit,
                    Size = UDim2.fromScale(1, 1),
                    SizeConstraint = IsCompact and Enum.SizeConstraint.RelativeXY or Enum.SizeConstraint.RelativeYY,
                    Parent = TabButton,
                })
            end

            TabButtonEntry = {
                Button = TabButton,
                Label = TabLabel,
                Padding = ButtonPadding,
                Icon = TabIcon,
                Decoration = TabDecoration,
                Corner = TabButtonCorner,
            }
            table.insert(Library.TabButtons, TabButtonEntry)

            --// Tab Canvas \\--
            TabCanvas = New("CanvasGroup", {
                BackgroundTransparency = 1,
                ClipsDescendants = true,
                GroupTransparency = 0,
                Size = UDim2.fromScale(1, 1),
                Visible = false,
                Parent = Container,
            })

            --// Tab Container \\--
            TabContainer = New("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0, 0),
                Size = UDim2.fromScale(1, 1),
                Visible = true,
                Parent = TabCanvas,
            })

            TabRootContent = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Parent = TabContainer,
            })

            TabLeft, TabRight = CreateLayoutScope(TabRootContent, FullWidth)
        end

        --// Warning Box \\--
        local WarningBoxHolder = New("Frame", {
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(0, 7),
            Size = UDim2.fromScale(1, 0),
            Visible = false,
            Parent = TabContainer,
        })

        local WarningBox
        local WarningBoxOutline
        local WarningBoxShadowOutline
        local WarningBoxScrollingFrame
        local WarningTitle
        local WarningStroke
        local WarningText
        do
            WarningBox = New("Frame", {
                BackgroundColor3 = "BackgroundColor",
                Position = UDim2.fromOffset(2, 0),
                Size = UDim2.new(1, -5, 0, 0),
                Parent = WarningBoxHolder,
            })
            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                    Parent = WarningBox,
                })
            )
            WarningBoxOutline, WarningBoxShadowOutline = Library:AddOutline(WarningBox)

            WarningBoxScrollingFrame = New("ScrollingFrame", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2.fromScale(1, 1),
                CanvasSize = UDim2.new(0, 0, 0, 0),
                ScrollBarThickness = 3,
                ScrollingDirection = Enum.ScrollingDirection.Y,
                Parent = WarningBox,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 4),
                PaddingLeft = UDim.new(0, 6),
                PaddingRight = UDim.new(0, 6),
                PaddingTop = UDim.new(0, 4),
                Parent = WarningBoxScrollingFrame,
            })

            WarningTitle = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -4, 0, 14),
                Text = "",
                TextColor3 = Color3.fromRGB(255, 50, 50),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = WarningBoxScrollingFrame,
            })

            WarningStroke = New("UIStroke", {
                ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
                Color = Color3.fromRGB(169, 0, 0),
                LineJoinMode = Enum.LineJoinMode.Miter,
                Parent = WarningTitle,
            })

            WarningText = New("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(0, 16),
                Size = UDim2.new(1, -4, 0, 0),
                Text = "",
                TextSize = 14,
                TextWrapped = true,
                Parent = WarningBoxScrollingFrame,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
            })

            New("UIStroke", {
                ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
                Color = "DarkColor",
                LineJoinMode = Enum.LineJoinMode.Miter,
                Parent = WarningText,
            })
        end

        --// Tab Table \\--
        local TabStorageKey = GetUniqueStorageKey(Library.Tabs, Name)
        local Tab = {
            Type = "Tab",
            Name = Name,
            StorageKey = TabStorageKey,
            Description = Description,
            FullWidth = FullWidth,

            Connections = {},
            Destroyed = false,

            Window = Window,
            Button = TabButton,
            Canvas = TabCanvas,
            Container = TabRootContent,
            Sides = FullWidth and { TabLeft } or { TabLeft, TabRight },
            Pages = {},
            OrderedPages = {},
            ActivePage = nil,
            PageNavigation = nil,
            WarningBox = {
                IsNormal = false,
                LockSize = false,
                Visible = false,
                Title = "WARNING",
                Text = "",
            },

            Groupboxes = {},
            Tabboxes = {},
            DependencyGroupboxes = {},
        }
        TabButtonEntry.Tab = Tab

        function Tab:UpdateWarningBox(Info)
            if typeof(Info.IsNormal) == "boolean" then
                Tab.WarningBox.IsNormal = Info.IsNormal
            end
            if typeof(Info.LockSize) == "boolean" then
                Tab.WarningBox.LockSize = Info.LockSize
            end
            if typeof(Info.Visible) == "boolean" then
                Tab.WarningBox.Visible = Info.Visible
            end
            if typeof(Info.Title) == "string" then
                Tab.WarningBox.Title = Info.Title
            end
            if typeof(Info.Text) == "string" then
                Tab.WarningBox.Text = Info.Text
            end

            WarningBoxHolder.Visible = Tab.WarningBox.Visible
            WarningTitle.Text = Tab.WarningBox.Title
            WarningText.Text = Tab.WarningBox.Text
            Tab:Resize(true)

            WarningBox.BackgroundColor3 = Tab.WarningBox.IsNormal == true and Library.Scheme.BackgroundColor
                or Color3.fromRGB(127, 0, 0)

            WarningBoxShadowOutline.Color = Tab.WarningBox.IsNormal == true and Library.Scheme.DarkColor
                or Color3.fromRGB(85, 0, 0)
            WarningBoxOutline.Color = Tab.WarningBox.IsNormal == true and Library.Scheme.OutlineColor
                or Color3.fromRGB(255, 50, 50)

            WarningTitle.TextColor3 = Tab.WarningBox.IsNormal == true and Library.Scheme.FontColor
                or Color3.fromRGB(255, 50, 50)
            WarningStroke.Color = Tab.WarningBox.IsNormal == true and Library.Scheme.OutlineColor
                or Color3.fromRGB(169, 0, 0)

            if not Library.Registry[WarningBox] then
                Library:AddToRegistry(WarningBox, {})
            end
            if not Library.Registry[WarningBoxShadowOutline] then
                Library:AddToRegistry(WarningBoxShadowOutline, {})
            end
            if not Library.Registry[WarningBoxOutline] then
                Library:AddToRegistry(WarningBoxOutline, {})
            end
            if not Library.Registry[WarningTitle] then
                Library:AddToRegistry(WarningTitle, {})
            end
            if not Library.Registry[WarningStroke] then
                Library:AddToRegistry(WarningStroke, {})
            end

            Library.Registry[WarningBox].BackgroundColor3 = function()
                return Tab.WarningBox.IsNormal == true and Library.Scheme.BackgroundColor or Color3.fromRGB(127, 0, 0)
            end

            Library.Registry[WarningBoxShadowOutline].Color = function()
                return Tab.WarningBox.IsNormal == true and Library.Scheme.DarkColor or Color3.fromRGB(85, 0, 0)
            end

            Library.Registry[WarningBoxOutline].Color = function()
                return Tab.WarningBox.IsNormal == true and Library.Scheme.OutlineColor or Color3.fromRGB(255, 50, 50)
            end

            Library.Registry[WarningTitle].TextColor3 = function()
                return Tab.WarningBox.IsNormal == true and Library.Scheme.FontColor or Color3.fromRGB(255, 50, 50)
            end

            Library.Registry[WarningStroke].Color = function()
                return Tab.WarningBox.IsNormal == true and Library.Scheme.OutlineColor or Color3.fromRGB(169, 0, 0)
            end
        end

        function Tab:RefreshSides()
            local WarningOffset = WarningBoxHolder.Visible and WarningBox.Size.Y.Offset + 8 or 0
            local HasPages = #Tab.OrderedPages > 0
            local NavigationOffset = HasPages and PageNavigation and PageNavigation.Visible and 40 or 0
            local ContentOffset = WarningOffset + NavigationOffset

            TabRootContent.Visible = not HasPages
            TabRootContent.Position = UDim2.fromOffset(0, WarningOffset)
            TabRootContent.Size = UDim2.new(1, 0, 1, -WarningOffset)

            if PageNavigation then
                PageNavigation.Position = UDim2.fromOffset(0, WarningOffset)
            end

            for _, Page in ipairs(Tab.OrderedPages) do
                if not Page.Destroyed and Page.Holder then
                    Page.Holder.Position = UDim2.fromOffset(0, ContentOffset)
                    Page.Holder.Size = UDim2.new(1, 0, 1, -ContentOffset)
                end
            end
        end

        function Tab:Resize(ResizeWarningBox: boolean?)
            if ResizeWarningBox then
                local MaximumSize = math.floor(TabContainer.AbsoluteSize.Y / 3.25)
                local _, YText = Library:GetTextBounds(
                    WarningText.Text,
                    Library.Scheme.Font,
                    WarningText.TextSize,
                    WarningText.AbsoluteSize.X
                )

                local YBox = 24 + YText
                if Tab.WarningBox.LockSize == true and YBox >= MaximumSize then
                    WarningBoxScrollingFrame.CanvasSize = UDim2.fromOffset(0, YBox)
                    YBox = MaximumSize
                else
                    WarningBoxScrollingFrame.CanvasSize = UDim2.fromOffset(0, 0)
                end

                WarningText.Size = UDim2.new(1, -4, 0, YText)
                WarningBox.Size = UDim2.new(1, -5, 0, YBox + 4)
            end

            Tab:RefreshSides()
            RefreshSearchIfActive()
        end

        local function AddTabbox(self, ...)
            local ParentObj = self
            local OwnerScope = ParentObj.Type == "Groupbox" and ParentObj.Tab or ParentObj
            if ParentObj.Destroyed or OwnerScope.Destroyed or Tab.Destroyed then
                return nil
            end

            local Info
            if select("#", ...) == 1 and typeof(select(1, ...)) == "table" then
                Info = DeepClone(select(1, ...))
            else
                Info = {
                    Name = select(1, ...),
                    Side = select(2, ...),
                }
            end
            Info.Name = if Info.Name == nil or Trim(tostring(Info.Name)) == "" then nil else tostring(Info.Name)
            Info.Side = Info.Side == 2 and 2 or 1

            local function CornerRadius()
                if ParentObj.Type == "Groupbox" then
                    return WindowInfo.CornerRadius / 2
                else
                    return WindowInfo.CornerRadius
                end
            end

            local BoxHolder = New("Frame", {
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 0),
                Parent = if ParentObj.Type == "Groupbox"
                    then ParentObj.Container
                    else (OwnerScope.FullWidth or Info.Side == 1) and OwnerScope.Sides[1] or OwnerScope.Sides[2],
            })
            New("UIListLayout", {
                Padding = UDim.new(0, 6),
                Parent = BoxHolder,
            })
            if ParentObj.Type ~= "Groupbox" then
                New("UIPadding", {
                    PaddingBottom = UDim.new(0, 4),
                    PaddingTop = UDim.new(0, 4),
                    Parent = BoxHolder,
                })
            end

            local TabboxHolder
            local TabboxButtons

            do
                TabboxHolder = New("Frame", {
                    BackgroundColor3 = "BackgroundColor",
                    Size = UDim2.fromScale(1, 0),
                    Parent = BoxHolder,
                })
                table.insert(
                    Library.Corners,
                    TrackCornerMode(New("UICorner", {
                        CornerRadius = UDim.new(0, CornerRadius()),
                        Parent = TabboxHolder,
                    }), ParentObj.Type == "Groupbox" and "Half" or "Full")
                )
                Library:AddOutline(TabboxHolder)

                TabboxButtons = New("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 34),
                    Parent = TabboxHolder,
                })
                New("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Parent = TabboxButtons,
                })
            end

            local TotalTabs = 0

            local Tabbox = {
                Type = "Tabbox",
                Connections = {},
                Destroyed = false,

                ActiveTab = nil,

                BoxHolder = BoxHolder,
                Holder = TabboxHolder,
                Tabs = {},
                OrderedTabs = {},
                Parent = ParentObj,
                OwnerTab = OwnerScope,
                RootTab = Tab,
            }

            function Tabbox:UpdateCorners()
                for Index, SubTab in ipairs(Tabbox.OrderedTabs) do
                    SubTab:UpdateCorners(Index, #Tabbox.OrderedTabs)
                end
            end

            function Tabbox:AddTab(Name, IconName)
                if Tabbox.Destroyed or OwnerScope.Destroyed or Tab.Destroyed then
                    return nil
                end

                TotalTabs = TotalTabs + 1
                local TabIndex = TotalTabs

                local IsNameEmpty = Name == nil or Trim(tostring(Name)) == ""
                local PreferredKey = IsNameEmpty and tostring(TabIndex) or tostring(Name)
                local TabStoringIndex = GetUniqueStorageKey(Tabbox.Tabs, PreferredKey)

                local Button = New("TextButton", {
                    BackgroundColor3 = "MainColor",
                    BackgroundTransparency = 0,
                    Size = UDim2.fromOffset(0, 34),
                    Text = "",
                    Parent = TabboxButtons,
                })

                local ButtonCorner = New("UICorner", {
                    TopLeftRadius = UDim.new(0, CornerRadius()),
                    TopRightRadius = UDim.new(0, CornerRadius()),
                    BottomRightRadius = UDim.new(0, 0),
                    BottomLeftRadius = UDim.new(0, 0),
                    Parent = Button,
                }); table.insert(Library.SpecificCorners, ButtonCorner)

                local ButtonContent = New("Frame", {
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundTransparency = 1,
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromOffset(0, 16),
                    Parent = Button,
                })
                New("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDim.new(0, 8),
                    Parent = ButtonContent,
                })

                local ButtonIcon                
                local BoxIcon = Library:GetCustomIcon(IconName)
                if BoxIcon then
                    ButtonIcon = New("ImageLabel", {
                        Image = BoxIcon.Url,
                        ImageColor3 = BoxIcon.Custom and "WhiteColor" or "AccentColor",
                        ImageRectOffset = BoxIcon.ImageRectOffset,
                        ImageRectSize = BoxIcon.ImageRectSize,
                        ImageTransparency = 0.5,
                        Size = IsNameEmpty and UDim2.fromOffset(20, 20) or UDim2.fromOffset(18, 18),
                        Parent = ButtonContent,
                    })
                end

                local ButtonLabel
                if not IsNameEmpty then
                    ButtonLabel = New("TextLabel", {
                        AutomaticSize = Enum.AutomaticSize.X,
                        BackgroundTransparency = 1,
                        Size = UDim2.fromOffset(0, 16),
                        Text = Name,
                        TextSize = 15,
                        TextTransparency = 0.5,
                        Parent = ButtonContent,
                    })
                end

                local Line = Library:MakeLine(Button, {
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 1),
                    Size = UDim2.new(1, 0, 0, 1),
                })

                local Container = New("Frame", {
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(0, 35),
                    Size = UDim2.new(1, 0, 1, -35),
                    Visible = false,
                    Parent = TabboxHolder,
                })
                local List = New("UIListLayout", {
                    Padding = UDim.new(0, 8),
                    Parent = Container,
                })
                New("UIPadding", {
                    PaddingBottom = UDim.new(0, 7),
                    PaddingLeft = UDim.new(0, 7),
                    PaddingRight = UDim.new(0, 7),
                    PaddingTop = UDim.new(0, 7),
                    Parent = Container,
                })

                local SubTab = {
                    Type = "TabboxTab",
                    Connections = {},
                    Destroyed = false,

                    Name = IsNameEmpty and nil or tostring(Name),
                    StorageKey = TabStoringIndex,
                    ButtonHolder = Button,
                    Container = Container,
                    ButtonCorner = ButtonCorner,

                    Tab = OwnerScope,
                    Elements = {},
                    DependencyBoxes = {},
                }

                function SubTab:Show()
                    if SubTab.Destroyed or Tabbox.Destroyed or Tabbox.ActiveTab == SubTab then
                        return
                    end

                    if Tabbox.ActiveTab then
                        Tabbox.ActiveTab:Hide()
                    end

                    Button.BackgroundTransparency = 1

                    if ButtonLabel then
                        ButtonLabel.TextTransparency = 0
                    end
                    if ButtonIcon then
                        ButtonIcon.ImageTransparency = 0
                    end

                    Line.Visible = false

                    Container.Visible = true

                    Tabbox.ActiveTab = SubTab
                    SubTab:Resize()
                end

                function SubTab:Hide()
                    Button.BackgroundTransparency = 0

                    if ButtonLabel then
                        ButtonLabel.TextTransparency = 0.5
                    end
                    if ButtonIcon then
                        ButtonIcon.ImageTransparency = 0.5
                    end
                    Line.Visible = true
                    Container.Visible = false

                    if Tabbox.ActiveTab == SubTab then
                        Tabbox.ActiveTab = nil
                    end
                end

                function SubTab:Resize()
                    if SubTab.Destroyed or Tabbox.ActiveTab ~= SubTab then
                        return
                    end

                    TabboxHolder.Size = UDim2.new(1, 0, 0, (List.AbsoluteContentSize.Y / Library.DPIScale) + 49)
                    if ParentObj.Type == "Groupbox" then
                        ParentObj:Resize()
                    end
                    RefreshSearchIfActive()
                end

                function SubTab:UpdateCorners(Index, Count)
                    local Radius = CornerRadius()

                    ButtonCorner.TopLeftRadius = UDim.new(0, Index == 1 and Radius or 0)
                    ButtonCorner.TopRightRadius = UDim.new(0, Index == Count and Radius or 0)
                end

                function SubTab:Destroy()
                    if SubTab.Destroyed then
                        return
                    end
                    SubTab.Destroyed = true
                    local WasActive = Tabbox.ActiveTab == SubTab

                    if SubTab.Connections then
                        for _, Connection in SubTab.Connections do
                            Connection:Disconnect()
                        end
                    end

                    DestroyObjects(SubTab.Elements)
                    DestroyObjects(SubTab.DependencyBoxes)

                    RemoveStoredObject(Tabbox.Tabs, SubTab)
                    local OrderedIndex = table.find(Tabbox.OrderedTabs, SubTab)
                    if OrderedIndex then
                        table.remove(Tabbox.OrderedTabs, OrderedIndex)
                    end
                    if WasActive then
                        Tabbox.ActiveTab = nil
                    end

                    if Container then
                        Container:Destroy()
                    end

                    if Button then
                        Button:Destroy()
                    end

                    Tabbox:UpdateCorners()
                    if WasActive and not Tabbox.Destroyed then
                        local Replacement = Tabbox.OrderedTabs[1]
                        if Replacement then
                            Replacement:Show()
                        else
                            TabboxHolder.Size = UDim2.new(1, 0, 0, 34)
                        end
                    end
                end

                --// Execution \\--
                if not Tabbox.ActiveTab then
                    SubTab:Show()
                end

                table.insert(SubTab.Connections, Button.MouseButton1Click:Connect(SubTab.Show))
                table.insert(
                    SubTab.Connections,
                    List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                        SubTab:Resize()
                    end)
                )

                setmetatable(SubTab, BaseGroupbox)

                Tabbox.Tabs[TabStoringIndex] = SubTab
                table.insert(Tabbox.OrderedTabs, SubTab)
                Tabbox:UpdateCorners()

                return SubTab, TabStoringIndex
            end

            function Tabbox:Destroy()
                if Tabbox.Destroyed then
                    return
                end
                Tabbox.Destroyed = true

                if Tabbox.Connections then
                    for _, Connection in Tabbox.Connections do
                        Connection:Disconnect()
                    end
                end

                DestroyObjects(Tabbox.OrderedTabs)
                table.clear(Tabbox.Tabs)
                Tabbox.ActiveTab = nil

                RemoveStoredObject(OwnerScope.Tabboxes, Tabbox)
                if ParentObj.Type == "Groupbox" and ParentObj.Tabboxes then
                    local ParentIndex = table.find(ParentObj.Tabboxes, Tabbox)
                    if ParentIndex then
                        table.remove(ParentObj.Tabboxes, ParentIndex)
                    end
                end

                if TabboxHolder then
                    TabboxHolder:Destroy()
                end

                if BoxHolder then
                    BoxHolder:Destroy()
                end
                RefreshSearchIfActive()
            end

            local TabboxKey = GetUniqueStorageKey(OwnerScope.Tabboxes, Info.Name)
            Tabbox.Name = Info.Name
            Tabbox.StorageKey = TabboxKey
            OwnerScope.Tabboxes[TabboxKey] = Tabbox
            if ParentObj.Type == "Groupbox" then
                table.insert(ParentObj.Tabboxes, Tabbox)
            end

            return Tabbox, TabboxKey
        end

        function Tab:AddTabbox(...)
            assert(#Tab.OrderedPages == 0, "Add tabboxes to the Page returned by Tab:AddPage while page navigation is active.")
            return AddTabbox(Tab, ...)
        end

        function Tab:AddLeftTabbox(Name)
            return Tab:AddTabbox({ Side = 1, Name = Name })
        end

        function Tab:AddRightTabbox(Name)
            return Tab:AddTabbox({ Side = 2, Name = Name })
        end

        local function AddGroupbox(OwnerScope, ...)
            if OwnerScope.Destroyed or Tab.Destroyed then
                return nil
            end

            local Info
            if select("#", ...) == 1 and typeof(select(1, ...)) == "table" then
                Info = DeepClone(select(1, ...))
            else
                Info = {
                    Name = select(1, ...),
                    IconName = select(2, ...),
                    Side = select(3, ...),
                }
            end

            Info.Name = if Info.Name == nil or Trim(tostring(Info.Name)) == "" then "Groupbox" else tostring(Info.Name)
            Info.IconName = Info.IconName or Info.Icon
            Info.Side = Info.Side == 2 and 2 or 1

            local BoxHolder = New("Frame", {
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 0),
                Parent = (OwnerScope.FullWidth or Info.Side == 1) and OwnerScope.Sides[1] or OwnerScope.Sides[2],
            })
            New("UIListLayout", {
                Padding = UDim.new(0, 6),
                Parent = BoxHolder,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 4),
                PaddingTop = UDim.new(0, 4),
                Parent = BoxHolder,
            })

            local GroupboxHolder
            local GroupboxLabel

            local GroupboxContainer
            local GroupboxList

            local GroupboxLine
            local GroupboxArrow

            do
                GroupboxHolder = New("Frame", {
                    BackgroundColor3 = "BackgroundColor",
                    Size = UDim2.fromScale(1, 0),
                    Parent = BoxHolder,
                })
                table.insert(
                    Library.Corners,
                    New("UICorner", {
                        CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                        Parent = GroupboxHolder,
                    })
                )
                Library:AddOutline(GroupboxHolder)

                GroupboxLine = Library:MakeLine(GroupboxHolder, {
                    Position = UDim2.fromOffset(0, 34),
                    Size = UDim2.new(1, 0, 0, 1),
                })

                local BoxIcon = Library:GetCustomIcon(Info.IconName)
                if BoxIcon then
                    New("ImageLabel", {
                        Image = BoxIcon.Url,
                        ImageColor3 = BoxIcon.Custom and "WhiteColor" or "AccentColor",
                        ImageRectOffset = BoxIcon.ImageRectOffset,
                        ImageRectSize = BoxIcon.ImageRectSize,
                        Position = UDim2.fromOffset(6, 6),
                        Size = UDim2.fromOffset(22, 22),
                        Parent = GroupboxHolder,
                    })
                end

                GroupboxLabel = New("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(BoxIcon and 30 or 0, 0),
                    Size = UDim2.new(
                        1,
                        -((BoxIcon and 30 or 0) + (Info.DisableCollapsing ~= true and 36 or 0)),
                        0,
                        34
                    ),
                    Text = Info.Name,
                    TextSize = 15,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = GroupboxHolder,
                })
                New("UIPadding", {
                    PaddingLeft = UDim.new(0, 12),
                    PaddingRight = UDim.new(0, 12),
                    Parent = GroupboxLabel,
                })

                if Info.DisableCollapsing ~= true then
                    GroupboxArrow = New("ImageButton", {
                        BackgroundTransparency = 1,
                        Image = ArrowIcon and ArrowIcon.Url or "",
                        ImageColor3 = "WhiteColor",
                        ImageRectOffset = ArrowIcon and ArrowIcon.ImageRectOffset or Vector2.zero,
                        ImageRectSize = ArrowIcon and ArrowIcon.ImageRectSize or Vector2.zero,
                        Position = UDim2.new(1, -(20 + 8), 0, 8),
                        Size = UDim2.fromOffset(20, 20),
                        Rotation = 180,
                        ZIndex = 5,
                        Parent = GroupboxHolder,
                    })
                end

                GroupboxContainer = New("Frame", {
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(0, 35),
                    Size = UDim2.new(1, 0, 1, -35),
                    Parent = GroupboxHolder,
                })

                GroupboxList = New("UIListLayout", {
                    Padding = UDim.new(0, 8),
                    Parent = GroupboxContainer,
                })
                New("UIPadding", {
                    PaddingBottom = UDim.new(0, 7),
                    PaddingLeft = UDim.new(0, 7),
                    PaddingRight = UDim.new(0, 7),
                    PaddingTop = UDim.new(0, 7),
                    Parent = GroupboxContainer,
                })
            end

            local Groupbox = {
                Type = "Groupbox",

                Connections = {},
                Destroyed = false,

                Visible = true,
                Collapsed = false,

                BoxHolder = BoxHolder,
                Holder = GroupboxHolder,
                Container = GroupboxContainer,

                Tab = OwnerScope,
                RootTab = Tab,
                DependencyBoxes = {},
                Elements = {},
                Tabboxes = {},
            }

            local ResizeTween
            local CollapseArrowTween

            function Groupbox:Resize()
                if Groupbox.Destroyed then
                    return
                end

                if ResizeTween then
                    StopTween(ResizeTween, true)
                    ResizeTween = nil
                end

                local TargetSize = UDim2.new(1, 0, 0, if Groupbox.Collapsed then 34 else (GroupboxList.AbsoluteContentSize.Y / Library.DPIScale) + 49)

                GroupboxLine.Visible = not Groupbox.Collapsed
                if Library.Animations and Library.Animations.Groupbox then
                    local TweenInfo = Library.GroupboxTweenInfo or TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    local Tween = TweenService:Create(GroupboxHolder, TweenInfo, { Size = TargetSize })
                    ResizeTween = Tween

                    local Connection; Connection = Library:GiveSignal(Tween.Completed:Once(function()
                        Library:ForgetSignal(Connection)

                        if ResizeTween == Tween then
                            StopTween(ResizeTween, true)
                            ResizeTween = nil
                        end
                    end))

                    Tween:Play()
                else
                    GroupboxHolder.Size = TargetSize
                end
                RefreshSearchIfActive()
            end

            function Groupbox:SetCollapsed(Collapsed: boolean)
                if Groupbox.Destroyed then return end
                if Info.DisableCollapsing == true then return end
                Groupbox.Collapsed = Collapsed

                if CollapseArrowTween then
                    StopTween(CollapseArrowTween, true)
                    CollapseArrowTween = nil
                end

                local TargetRotation = if Collapsed then 0 else 180

                GroupboxContainer.Visible = not Collapsed
                if Library.Animations and Library.Animations.Groupbox then
                    local TweenInfo = Library.GroupboxTweenInfo or TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                    local Tween = TweenService:Create(GroupboxArrow, TweenInfo, { Rotation = TargetRotation })
                    CollapseArrowTween = Tween

                    local Connection; Connection = Library:GiveSignal(Tween.Completed:Once(function()
                        Library:ForgetSignal(Connection)

                        if CollapseArrowTween == Tween then
                            StopTween(CollapseArrowTween, true)
                            CollapseArrowTween = nil
                        end
                    end))

                    Tween:Play()
                else
                    GroupboxArrow.Rotation = TargetRotation
                end

                Groupbox:Resize()
            end

            function Groupbox:ToggleCollapsed()
                if Info.DisableCollapsing == true then return end
                Groupbox:SetCollapsed(not Groupbox.Collapsed)
            end

            function Groupbox:Destroy()
                if Groupbox.Destroyed then
                    return
                end
                Groupbox.Destroyed = true

                if ResizeTween then
                    StopTween(ResizeTween, true)
                    ResizeTween = nil
                end

                if CollapseArrowTween then
                    StopTween(CollapseArrowTween, true)
                    CollapseArrowTween = nil
                end

                if Groupbox.Connections then
                    for _, Connection in Groupbox.Connections do
                        Connection:Disconnect()
                    end
                end

                DestroyObjects(Groupbox.Tabboxes)
                DestroyObjects(Groupbox.Elements)
                DestroyObjects(Groupbox.DependencyBoxes)

                local OwnedDependencyGroupboxes = {}
                for _, DepGroupbox in OwnerScope.DependencyGroupboxes do
                    if DepGroupbox.ParentGroupbox == Groupbox then
                        table.insert(OwnedDependencyGroupboxes, DepGroupbox)
                    end
                end
                DestroyObjects(OwnedDependencyGroupboxes)
                RemoveStoredObject(OwnerScope.Groupboxes, Groupbox)

                if GroupboxHolder then 
                    GroupboxHolder:Destroy() 
                end

                if BoxHolder then
                    BoxHolder:Destroy()
                end
                RefreshSearchIfActive()
            end

            function Groupbox:SetVisible(Visible: boolean)
                if Groupbox.Destroyed then
                    return
                end

                Groupbox.Visible = Visible
                BoxHolder.Visible = Visible

                RefreshSearchIfActive()
            end

            function Groupbox:Show()
                Groupbox:SetVisible(true) 
            end

            function Groupbox:Hide()
                Groupbox:SetVisible(false) 
            end

            if Info.DisableCollapsing ~= true then
                table.insert(
                    Groupbox.Connections,
                    GroupboxArrow.MouseButton1Click:Connect(function()
                        Groupbox:ToggleCollapsed()
                    end)
                )
            end

            Groupbox.AddTabbox = AddTabbox
            setmetatable(Groupbox, BaseGroupbox)

            table.insert(
                Groupbox.Connections,
                GroupboxList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    Groupbox:Resize()
                end)
            )

            Groupbox:Resize()
            local GroupboxKey = GetUniqueStorageKey(OwnerScope.Groupboxes, Info.Name)
            Groupbox.Name = Info.Name
            Groupbox.StorageKey = GroupboxKey
            OwnerScope.Groupboxes[GroupboxKey] = Groupbox

            if Info.Visible == false then
                Groupbox:Hide()
            end

            if Info.DisableCollapsing ~= true and Info.Collapsed == true then
                Groupbox:SetCollapsed(true)
            end

            return Groupbox, GroupboxKey
        end

        function Tab:AddGroupbox(...)
            assert(#Tab.OrderedPages == 0, "Add groupboxes to the Page returned by Tab:AddPage while page navigation is active.")
            return AddGroupbox(Tab, ...)
        end

        function Tab:AddLeftGroupbox(Name, IconName, Visible, Collapsed, DisableCollapsing)
            return Tab:AddGroupbox({ Side = 1, Name = Name, IconName = IconName, Visible = Visible, Collapsed = Collapsed, DisableCollapsing = DisableCollapsing or false })
        end

        function Tab:AddRightGroupbox(Name, IconName, Visible, Collapsed, DisableCollapsing)
            return Tab:AddGroupbox({ Side = 2, Name = Name, IconName = IconName, Visible = Visible, Collapsed = Collapsed, DisableCollapsing = DisableCollapsing or false })
        end

        local function UpdatePageButtonsLayout()
            if not (PageButtons and PageButtonsList and PageButtons.Parent) then
                return
            end

            local Scale = math.max(Library.DPIScale, 0.01)
            local ContentWidth = math.ceil(PageButtonsList.AbsoluteContentSize.X / Scale) + 16
            local ViewportWidth = PageButtons.AbsoluteSize.X / Scale
            local Overflowing = ContentWidth > ViewportWidth

            PageButtonsList.HorizontalAlignment = Overflowing
                and Enum.HorizontalAlignment.Left
                or Enum.HorizontalAlignment.Center
            PageButtons.CanvasSize = Overflowing and UDim2.fromOffset(ContentWidth, 0) or UDim2.fromScale(0, 0)
        end

        local function EnsurePageNavigation()
            if PageNavigation then
                return
            end

            PageNavigation = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 40),
                Visible = false,
                Parent = TabContainer,
            })
            Tab.PageNavigation = PageNavigation

            PageButtons = New("ScrollingFrame", {
                AutomaticCanvasSize = Enum.AutomaticSize.None,
                BackgroundTransparency = 1,
                CanvasSize = UDim2.fromScale(0, 0),
                ScrollBarImageTransparency = 1,
                ScrollBarThickness = 0,
                ScrollingDirection = Enum.ScrollingDirection.X,
                Size = UDim2.fromScale(1, 1),
                Parent = PageNavigation,
            })
            PageButtonsList = New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                Padding = UDim.new(0, 18),
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Parent = PageButtons,
            })
            New("UIPadding", {
                PaddingLeft = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 8),
                Parent = PageButtons,
            })

            table.insert(Tab.Connections, PageButtonsList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                UpdatePageButtonsLayout()
            end))
            table.insert(Tab.Connections, PageButtons:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                UpdatePageButtonsLayout()
            end))
        end

        local function ShowFirstAvailablePage(ExcludedPage)
            for _, Candidate in ipairs(Tab.OrderedPages) do
                if
                    Candidate ~= ExcludedPage
                    and not Candidate.Destroyed
                    and Candidate.Visible ~= false
                    and Candidate.Button
                    and Candidate.Button.Visible
                then
                    return Candidate:Show(true)
                end
            end

            Tab.ActivePage = nil
            return false
        end

        local function UpdatePageNavigationVisibility()
            if not PageNavigation then
                return
            end

            local HasVisiblePage = false
            for _, Page in ipairs(Tab.OrderedPages) do
                if not Page.Destroyed and Page.Visible ~= false and Page.Button.Visible then
                    HasVisiblePage = true
                    break
                end
            end

            PageNavigation.Visible = HasVisiblePage
            UpdatePageButtonsLayout()
            Tab:RefreshSides()
        end

        function Tab:AddPage(...)
            assert(not Tab.Destroyed, "Cannot add a page to a destroyed tab.")
            assert(
                next(Tab.Groupboxes) == nil and next(Tab.Tabboxes) == nil and #Tab.DependencyGroupboxes == 0,
                "Tab:AddPage must be used before adding groupboxes or tabboxes directly to the tab."
            )

            local Info
            if select("#", ...) == 1 and typeof(select(1, ...)) == "table" then
                Info = DeepClone(select(1, ...))
            else
                Info = {
                    Name = select(1, ...),
                    Description = select(2, ...),
                }
            end

            local PageNumber = #Tab.OrderedPages + 1
            Info.Name = if Info.Name == nil or Trim(tostring(Info.Name)) == ""
                then "Page " .. tostring(PageNumber)
                else tostring(Info.Name)
            Info.Description = tostring(Info.Description or Info.Tooltip or Info.Name)
            Info.FullWidth = Info.FullWidth == true
                or Info.Special == true
                or Info.Layout == "FullWidth"
                or (Info.FullWidth == nil and FullWidth)

            EnsurePageNavigation()

            local PageStorageKey = GetUniqueStorageKey(Tab.Pages, Info.Name)
            local Page
            local Hovering = false

            local Button = New("TextButton", {
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                Size = UDim2.fromOffset(0, 38),
                Text = Info.Name,
                TextColor3 = function()
                    return Tab.ActivePage == Page and Library.Scheme.AccentColor or Library.Scheme.FontColor
                end,
                TextSize = 15,
                TextTransparency = 0.5,
                Parent = PageButtons,
            })
            New("UIPadding", {
                PaddingLeft = UDim.new(0, 4),
                PaddingRight = UDim.new(0, 4),
                Parent = Button,
            })

            local Indicator = New("Frame", {
                AnchorPoint = Vector2.new(0.5, 1),
                BackgroundColor3 = "AccentColor",
                Position = UDim2.new(0.5, 0, 1, 0),
                Size = UDim2.fromOffset(28, 2),
                Visible = false,
                Parent = Button,
            })
            New("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = Indicator,
            })

            local PageHolder = New("Frame", {
                BackgroundTransparency = 1,
                ClipsDescendants = true,
                Size = UDim2.fromScale(1, 1),
                Visible = false,
                Parent = TabContainer,
            })
            local PageCanvas = New("CanvasGroup", {
                BackgroundTransparency = 1,
                GroupTransparency = 0,
                Size = UDim2.fromScale(1, 1),
                Visible = true,
                Parent = PageHolder,
            })
            local PageLeft, PageRight = CreateLayoutScope(PageCanvas, Info.FullWidth)

            Page = {
                Type = "Page",
                Name = Info.Name,
                StorageKey = PageStorageKey,
                Description = Info.Description,
                FullWidth = Info.FullWidth,
                Visible = Info.Visible ~= false,
                Destroyed = false,

                RootTab = Tab,
                Window = Window,
                Button = Button,
                ButtonHolder = Button,
                Indicator = Indicator,
                Holder = PageHolder,
                Canvas = PageCanvas,
                Container = PageCanvas,
                Sides = Info.FullWidth and { PageLeft } or { PageLeft, PageRight },

                Connections = {},
                Groupboxes = {},
                Tabboxes = {},
                DependencyGroupboxes = {},
            }

            local function RenderButton()
                if Page.Destroyed then
                    return
                end

                local Active = Tab.ActivePage == Page
                Button.TextColor3 = Active and Library.Scheme.AccentColor or Library.Scheme.FontColor
                Button.TextTransparency = Active and 0 or (Hovering and 0.2 or 0.5)
                Indicator.Visible = Active
            end

            function Page:Show(SkipSearchRefresh)
                if
                    Page.Destroyed
                    or Tab.Destroyed
                    or Page.Visible == false
                    or not Button.Visible
                then
                    return false
                end
                if Tab.ActivePage == Page then
                    PageHolder.Visible = true
                    RenderButton()
                    return true
                end

                local Previous = Tab.ActivePage
                if Previous then
                    Previous:Hide(true)
                end

                Tab.ActivePage = Page
                PageHolder.Visible = true
                Library:PlayTabAnimation(PageCanvas, true)
                if Previous and not Previous.Destroyed then
                    Previous:RenderButton()
                end
                RenderButton()
                Tab:RefreshSides()

                if not SkipSearchRefresh and typeof(Info.Callback) == "function" then
                    Library:SafeCallback(Info.Callback, Page)
                end
                if not SkipSearchRefresh then
                    RefreshSearchIfActive()
                end
                return true
            end

            function Page:Hide(SkipSearchRefresh)
                if Page.Destroyed or Tab.Destroyed then
                    return false
                end

                local WasActive = Tab.ActivePage == Page
                Library:PlayTabAnimation(PageCanvas, false)
                PageHolder.Visible = false
                if WasActive then
                    Tab.ActivePage = nil
                end
                RenderButton()

                if not SkipSearchRefresh then
                    RefreshSearchIfActive()
                end
                return WasActive
            end

            function Page:RenderButton()
                RenderButton()
            end

            function Page:SetVisible(Visible)
                if Page.Destroyed then
                    return
                end

                Page.Visible = Visible == true
                Button.Visible = Page.Visible
                if not Page.Visible and Tab.ActivePage == Page then
                    Page:Hide(true)
                    ShowFirstAvailablePage(Page)
                elseif Page.Visible and not Tab.ActivePage then
                    Page:Show(true)
                end

                UpdatePageNavigationVisibility()
                RefreshSearchIfActive()
            end

            function Page:Destroy()
                if Page.Destroyed then
                    return
                end

                local WasActive = Tab.ActivePage == Page
                Page.Destroyed = true
                if WasActive then
                    Tab.ActivePage = nil
                end

                for _, Connection in Page.Connections do
                    Connection:Disconnect()
                end
                DestroyObjects(Page.Groupboxes)
                DestroyObjects(Page.Tabboxes)
                DestroyObjects(Page.DependencyGroupboxes)

                RemoveStoredObject(Tab.Pages, Page)
                local OrderedIndex = table.find(Tab.OrderedPages, Page)
                if OrderedIndex then
                    table.remove(Tab.OrderedPages, OrderedIndex)
                end

                if Page.Tooltip then
                    Page.Tooltip:Destroy()
                end
                Button:Destroy()
                PageHolder:Destroy()

                if WasActive and not Tab.Destroyed then
                    ShowFirstAvailablePage(Page)
                end
                UpdatePageNavigationVisibility()
                RefreshSearchIfActive()
            end

            Page.AddGroupbox = AddGroupbox
            Page.AddTabbox = AddTabbox
            function Page:AddLeftGroupbox(Name, IconName, Visible, Collapsed, DisableCollapsing)
                return AddGroupbox(Page, {
                    Side = 1,
                    Name = Name,
                    IconName = IconName,
                    Visible = Visible,
                    Collapsed = Collapsed,
                    DisableCollapsing = DisableCollapsing or false,
                })
            end
            function Page:AddRightGroupbox(Name, IconName, Visible, Collapsed, DisableCollapsing)
                return AddGroupbox(Page, {
                    Side = 2,
                    Name = Name,
                    IconName = IconName,
                    Visible = Visible,
                    Collapsed = Collapsed,
                    DisableCollapsing = DisableCollapsing or false,
                })
            end
            function Page:AddLeftTabbox(Name)
                return AddTabbox(Page, { Side = 1, Name = Name })
            end
            function Page:AddRightTabbox(Name)
                return AddTabbox(Page, { Side = 2, Name = Name })
            end

            table.insert(Page.Connections, Button.MouseEnter:Connect(function()
                Hovering = true
                RenderButton()
            end))
            table.insert(Page.Connections, Button.MouseLeave:Connect(function()
                Hovering = false
                RenderButton()
            end))
            table.insert(Page.Connections, Button.MouseButton1Click:Connect(function()
                Page:Show()
            end))

            Page.Tooltip = Library:AddTooltip(Info.Name, Info.Description, Button)
            Tab.Pages[PageStorageKey] = Page
            table.insert(Tab.OrderedPages, Page)
            Button.Visible = Page.Visible

            UpdatePageNavigationVisibility()
            if Page.Visible and not Tab.ActivePage then
                Page:Show(true)
            end
            RefreshSearchIfActive()

            return Page, PageStorageKey
        end

        Tab.AddSection = Tab.AddPage
        Tab.AddSubTab = Tab.AddPage

        function Tab:Hover(Hovering)
            if Tab.Destroyed or Library.ActiveTab == Tab then
                return
            end

            TweenService:Create(TabLabel, Library.TweenInfo, {
                TextTransparency = Hovering and 0.25 or 0.5,
            }):Play()
            if TabIcon then
                TweenService:Create(TabIcon, Library.TweenInfo, {
                    ImageTransparency = Hovering and 0.25 or 0.5,
                }):Play()
            end
        end

        function Tab:Show()
            if Tab.Destroyed or not TabButton.Visible or Library.ActiveTab == Tab then
                return
            end

            if Library.ActiveTab then
                Library.ActiveTab:Hide()
            end

            TweenService:Create(TabButton, Library.TweenInfo, {
                BackgroundTransparency = 0.85,
            }):Play()
            TweenService:Create(TabLabel, Library.TweenInfo, {
                TextTransparency = 0,
            }):Play()
            TweenService:Create(TabDecoration, Library.TweenInfo, {
                BackgroundTransparency = 0.4,
            }):Play()
            if TabIcon then
                TweenService:Create(TabIcon, Library.TweenInfo, {
                    ImageTransparency = 0,
                }):Play()
            end

            Window:ShowTabInfo(Name, Description)

            Library:PlayTabAnimation(TabCanvas, true)
            Tab:RefreshSides()

            Library.ActiveTab = Tab

            if Trim(Library.SearchText or "") ~= "" then
                Library:UpdateSearch(Library.SearchText)
            end
        end

        function Tab:Hide()
            local WasActive = Library.ActiveTab == Tab

            TweenService:Create(TabButton, Library.TweenInfo, {
                BackgroundTransparency = 1,
            }):Play()

            TweenService:Create(TabLabel, Library.TweenInfo, {
                TextTransparency = 0.5,
            }):Play()
            TweenService:Create(TabDecoration, Library.TweenInfo, {
                BackgroundTransparency = 1,
            }):Play()
            if TabIcon then
                TweenService:Create(TabIcon, Library.TweenInfo, {
                    ImageTransparency = 0.5,
                }):Play()
            end

            if WasActive then
                Library:PlayTabAnimation(TabCanvas, false)
                Window:HideTabInfo()
                Library.ActiveTab = nil
            else
                TabCanvas.Visible = false
            end
        end

        function Tab:SetVisible(Visible: boolean)
            if Tab.Destroyed then
                return
            end

            TabButton.Visible = Visible

            if not Visible and Library.ActiveTab == Tab then
                Tab:Hide()
                ShowFirstAvailableTab(Tab)
            elseif Visible and not Library.ActiveTab then
                Tab:Show()
            end
            RefreshSearchIfActive()
        end

        function Tab:Destroy()
            if Tab.Destroyed then
                return
            end
            local WasActive = Library.ActiveTab == Tab
            Tab.Destroyed = true

            if WasActive then
                Tab:Hide()
            end

            if Tab.Connections then
                for _, Connection in Tab.Connections do
                    Connection:Disconnect()
                end
            end

            DestroyObjects(Tab.OrderedPages)
            table.clear(Tab.Pages)
            Tab.ActivePage = nil
            DestroyObjects(Tab.Groupboxes)
            DestroyObjects(Tab.Tabboxes)
            DestroyObjects(Tab.DependencyGroupboxes)

            if TabCanvas then
                TabCanvas:Destroy()
            elseif TabContainer then
                TabContainer:Destroy()
            end

            if TabButton then
                for Index, Entry in Library.TabButtons do
                    if typeof(Entry) == "table" and Entry.Button == TabButton then
                        table.remove(Library.TabButtons, Index)
                        break
                    end
                end
                
                TabButton:Destroy()
            end

            if Tab.Tooltip then
                Tab.Tooltip:Destroy()
            end

            RemoveStoredObject(Library.Tabs, Tab)
            if WasActive then
                ShowFirstAvailableTab(Tab)
            end
        end

        --// Execution \\--
        local TabTooltip = Library:AddTooltip(Name, Name, TabButton)
        TabTooltip.Enabled = IsCompact
        Tab.Tooltip = TabTooltip
        TabButtonEntry.Tooltip = TabTooltip

        if not Library.ActiveTab then
            Tab:Show()
        end

        table.insert(Tab.Connections, TabButton.MouseEnter:Connect(function()
            Tab:Hover(true)
        end))
        table.insert(Tab.Connections, TabButton.MouseLeave:Connect(function()
            Tab:Hover(false)
        end))
        table.insert(Tab.Connections, TabButton.MouseButton1Click:Connect(Tab.Show))

        Library.Tabs[TabStorageKey] = Tab

        return Tab, TabStorageKey
    end

    function Window:AddSpecialTab(...)
        local Info
        if select("#", ...) == 1 and typeof(select(1, ...)) == "table" then
            Info = DeepClone(select(1, ...))
        else
            Info = {
                Name = select(1, ...),
                Icon = select(2, ...),
                Description = select(3, ...),
            }
        end

        Info.FullWidth = true
        Info.Special = true
        return Window:AddTab(Info)
    end

    function Window:AddKeyTab(...)
        local Name = nil
        local Icon = nil
        local Description = nil

        if select("#", ...) == 1 and typeof(...) == "table" then
            local Info = select(1, ...)
            Name = Info.Name or "Key Tab"
            Icon = Info.Icon
            Description = Info.Description or "No information is provided for this tab."
        else
            Name = select(1, ...) or "Key Tab"
            Icon = select(2, ...)
            Description = select(3, ...) or "No information is provided for this tab."
        end

        Icon = Icon or "key"

        local TabButton: TextButton
        local TabLabel
        local TabDecoration
        local TabIcon
        local TabButtonEntry
        local TabButtonCorner

        local TabCanvas
        local TabContainer

        Icon = if Icon == "key" then KeyIcon else Library:GetCustomIcon(Icon)
        do
            TabButton = New("TextButton", {
                BackgroundColor3 = function()
                    return IsCompact and Library.Scheme.AccentColor or Library.Scheme.MainColor
                end,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 40),
                Text = "",
                Parent = Tabs,
            })
            local ButtonPadding = New("UIPadding", {
                PaddingBottom = UDim.new(0, IsCompact and 8 or 11),
                PaddingLeft = UDim.new(0, IsCompact and 8 or 12),
                PaddingRight = UDim.new(0, IsCompact and 8 or 12),
                PaddingTop = UDim.new(0, IsCompact and 8 or 11),
                Parent = TabButton,
            })
            TabButtonCorner = New("UICorner", {
                CornerRadius = UDim.new(0, IsCompact and 4 or 0),
                Parent = TabButton,
            })

            TabLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(30, 0),
                Size = UDim2.new(1, -30, 1, 0),
                Text = Name,
                TextSize = 16,
                TextTransparency = 0.5,
                TextXAlignment = Enum.TextXAlignment.Left,
                Visible = not IsCompact,
                Parent = TabButton,
            })

            TabDecoration = New("Frame", {
                BackgroundColor3 = "AccentColor",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.fromOffset(-11, 0),
                Size = UDim2.new(0, 2, 1, 0),
                Visible = IsCompact,
                Parent = TabButton,
            })
            New("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = TabDecoration,
            })

            if Icon then
                TabIcon = New("ImageLabel", {
                    Image = Icon.Url,
                    ImageColor3 = Icon.Custom and "WhiteColor" or "AccentColor",
                    ImageRectOffset = Icon.ImageRectOffset,
                    ImageRectSize = Icon.ImageRectSize,
                    ImageTransparency = 0.5,
                    Size = UDim2.fromScale(1, 1),
                    SizeConstraint = IsCompact and Enum.SizeConstraint.RelativeXY or Enum.SizeConstraint.RelativeYY,
                    Parent = TabButton,
                })
            end

            TabButtonEntry = {
                Button = TabButton,
                Label = TabLabel,
                Padding = ButtonPadding,
                Icon = TabIcon,
                Decoration = TabDecoration,
                Corner = TabButtonCorner,
            }
            table.insert(Library.TabButtons, TabButtonEntry)

            --// Tab Canvas \\--
            TabCanvas = New("CanvasGroup", {
                BackgroundTransparency = 1,
                ClipsDescendants = true,
                GroupTransparency = 0,
                Size = UDim2.fromScale(1, 1),
                Visible = false,
                Parent = Container,
            })

            --// Tab Container \\--
            TabContainer = New("ScrollingFrame", {
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                CanvasSize = UDim2.fromScale(0, 0),
                ScrollBarThickness = 0,
                Position = UDim2.fromScale(0, 0),
                Size = UDim2.fromScale(1, 1),
                Visible = true,
                Parent = TabCanvas,
            })
            New("UIListLayout", {
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                Padding = UDim.new(0, 8),
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Parent = TabContainer,
            })
            New("UIPadding", {
                PaddingLeft = UDim.new(0, 1),
                PaddingRight = UDim.new(0, 1),
                Parent = TabContainer,
            })
        end

        --// Tab Table \\--
        local TabStorageKey = GetUniqueStorageKey(Library.Tabs, Name)
        local Tab = {
            Type = "KeyTab",
            Name = Name,
            StorageKey = TabStorageKey,
            Description = Description,
            IsKeyTab = true,
            Connections = {},
            Destroyed = false,

            Elements = {},
            DependencyBoxes = {},

            Window = Window,
            Button = TabButton,
            Canvas = TabCanvas
        }
        TabButtonEntry.Tab = Tab

        function Tab:AddKeyBox(Callback)
            assert(typeof(Callback) == "function", "Callback must be a function")

            local Holder = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(0.75, 0, 0, 21),
                Parent = TabContainer,
            })

            local Box = New("TextBox", {
                BackgroundColor3 = "MainColor",
                PlaceholderText = "Key",
                Size = UDim2.new(1, -71, 1, 0),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Holder,
            })
            New("UIPadding", {
                PaddingLeft = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 8),
                Parent = Box,
            })
            New("UIStroke", {
                Color = "OutlineColor",
                Parent = Box,
            })

            local Button = New("TextButton", {
                AnchorPoint = Vector2.new(1, 0),
                BackgroundColor3 = "MainColor",
                Position = UDim2.fromScale(1, 0),
                Size = UDim2.new(0, 63, 1, 0),
                Text = "Execute",
                TextSize = 14,
                Parent = Holder,
            })
            New("UIStroke", {
                Color = "OutlineColor",
                Parent = Button,
            })

            Button.InputBegan:Connect(function(Input)
                if not IsClickInput(Input) then
                    return
                end

                if not Library:MouseIsOverFrame(Button, Input.Position) then
                    return
                end

                Callback(Box.Text)
            end)
        end
        
        function Tab:Destroy()
            if Tab.Destroyed then
                return
            end
            local WasActive = Library.ActiveTab == Tab
            Tab.Destroyed = true

            if WasActive then
                Tab:Hide()
            end

            for _, Connection in Tab.Connections do
                Connection:Disconnect()
            end
            DestroyObjects(Tab.Elements)
            DestroyObjects(Tab.DependencyBoxes)

            if TabCanvas then
                TabCanvas:Destroy()
            elseif TabContainer then
                TabContainer:Destroy()
            end

            if TabButton then
                for Index, Entry in Library.TabButtons do
                    if typeof(Entry) == "table" and Entry.Button == TabButton then
                        table.remove(Library.TabButtons, Index)
                        break
                    end
                end
                
                TabButton:Destroy()
            end

            if Tab.Tooltip then
                Tab.Tooltip:Destroy()
            end

            RemoveStoredObject(Library.Tabs, Tab)
            if WasActive then
                ShowFirstAvailableTab(Tab)
            end
        end

        function Tab:RefreshSides() end
        function Tab:Resize() end
        function Tab:UpdateCorners() end

        function Tab:Hover(Hovering)
            if Tab.Destroyed or Library.ActiveTab == Tab then
                return
            end

            TweenService:Create(TabLabel, Library.TweenInfo, {
                TextTransparency = Hovering and 0.25 or 0.5,
            }):Play()
            if TabIcon then
                TweenService:Create(TabIcon, Library.TweenInfo, {
                    ImageTransparency = Hovering and 0.25 or 0.5,
                }):Play()
            end
        end

        function Tab:Show()
            if Tab.Destroyed or not TabButton.Visible or Library.ActiveTab == Tab then
                return
            end

            if Library.ActiveTab then
                Library.ActiveTab:Hide()
            end

            TweenService:Create(TabButton, Library.TweenInfo, {
                BackgroundTransparency = 0.85,
            }):Play()

            TweenService:Create(TabLabel, Library.TweenInfo, {
                TextTransparency = 0,
            }):Play()
            TweenService:Create(TabDecoration, Library.TweenInfo, {
                BackgroundTransparency = 0.4,
            }):Play()

            if TabIcon then
                TweenService:Create(TabIcon, Library.TweenInfo, {
                    ImageTransparency = 0,
                }):Play()
            end

            Library:PlayTabAnimation(TabCanvas, true)

            if Description then
                Window:ShowTabInfo(Name, Description)
            end

            Tab:RefreshSides()

            Library.ActiveTab = Tab

            if Trim(Library.SearchText or "") ~= "" then
                Library:UpdateSearch(Library.SearchText)
            end
        end

        function Tab:Hide()
            local WasActive = Library.ActiveTab == Tab

            TweenService:Create(TabButton, Library.TweenInfo, {
                BackgroundTransparency = 1,
            }):Play()

            TweenService:Create(TabLabel, Library.TweenInfo, {
                TextTransparency = 0.5,
            }):Play()
            TweenService:Create(TabDecoration, Library.TweenInfo, {
                BackgroundTransparency = 1,
            }):Play()

            if TabIcon then
                TweenService:Create(TabIcon, Library.TweenInfo, {
                    ImageTransparency = 0.5,
                }):Play()
            end

            if WasActive then
                Library:PlayTabAnimation(TabCanvas, false)
                Window:HideTabInfo()
                Library.ActiveTab = nil
            else
                TabCanvas.Visible = false
            end
        end

        function Tab:SetVisible(Visible: boolean)
            if Tab.Destroyed then
                return
            end

            TabButton.Visible = Visible

            if not Visible and Library.ActiveTab == Tab then
                Tab:Hide()
                ShowFirstAvailableTab(Tab)
            elseif Visible and not Library.ActiveTab then
                Tab:Show()
            end
            RefreshSearchIfActive()
        end

        --// Execution \\--
        local TabTooltip = Library:AddTooltip(Name, Name, TabButton)
        TabTooltip.Enabled = IsCompact
        Tab.Tooltip = TabTooltip
        TabButtonEntry.Tooltip = TabTooltip

        if not Library.ActiveTab then
            Tab:Show()
        end

        table.insert(Tab.Connections, TabButton.MouseEnter:Connect(function()
            Tab:Hover(true)
        end))
        table.insert(Tab.Connections, TabButton.MouseLeave:Connect(function()
            Tab:Hover(false)
        end))
        table.insert(Tab.Connections, TabButton.MouseButton1Click:Connect(Tab.Show))

        Tab.Container = TabContainer
        setmetatable(Tab, BaseGroupbox)

        Library.Tabs[TabStorageKey] = Tab

        return Tab, TabStorageKey
    end

    function Window:AddDialog(Idx, Info)
        assert(Idx ~= nil, "Dialog requires a non-nil index.")
        local ExistingDialog = Library.Dialogues[Idx]
        if ExistingDialog and not ExistingDialog.Destroyed then
            ExistingDialog:Dismiss()
        end

        Info = Library:Validate(Info, Templates.Dialog)

        local DialogFrame
        local DialogOverlay
        local DialogContainer
        local ButtonsHolder
        local FooterButtonsList = {}

        DialogOverlay = New("TextButton", {
            AutoButtonColor = false,
            BackgroundColor3 = "DarkColor",
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Text = "",
            Active = false,
            ZIndex = 9000,
            Visible = true,
            Parent = MainFrame,
        })
        TweenService:Create(DialogOverlay, Library.TweenInfo, {
            BackgroundTransparency = 0.5,
        }):Play()

        DialogFrame = New("TextButton", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = "BackgroundColor",
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(300, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Text = "",
            AutoButtonColor = false,
            ZIndex = 9001,
            Parent = DialogOverlay,
        })
        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                Parent = DialogFrame,
            })
        )
        Library:AddOutline(DialogFrame)

        local InnerContainer = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            ZIndex = 9002,
            Parent = DialogFrame,
        })
        local DialogScale = New("UIScale", {
            Scale = 0.95,
            Parent = DialogFrame,
        })
        TweenService:Create(DialogScale, Library.TweenInfo, {
            Scale = 1
        }):Play()
        local _InnerPadding = New("UIPadding", {
            PaddingBottom = UDim.new(0, 15),
            PaddingLeft = UDim.new(0, 15),
            PaddingRight = UDim.new(0, 15),
            PaddingTop = UDim.new(0, 15),
            Parent = InnerContainer,
        })
        local _InnerLayout = New("UIListLayout", {
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = InnerContainer,
        })

        local HeaderContainer = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            LayoutOrder = 1,
            ZIndex = 9002,
            Parent = InnerContainer,
        })
        New("UIListLayout", {
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = HeaderContainer,
        })
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 5),
            Parent = HeaderContainer,
        })

        local TitleRow = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 20),
            AutomaticSize = Enum.AutomaticSize.Y,
            LayoutOrder = 1,
            ZIndex = 9002,
            Parent = HeaderContainer,
        })
        New("UIListLayout", {
            Padding = UDim.new(0, 6),
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = TitleRow,
        })

        if Info.Icon then
            local ParsedIcon = Library:GetCustomIcon(Info.Icon)
            if ParsedIcon then
                local IconImg = New("ImageLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.fromOffset(16, 16),
                    Image = ParsedIcon.Url,
                    ImageColor3 = "FontColor",
                    ImageRectOffset = ParsedIcon.ImageRectOffset,
                    ImageRectSize = ParsedIcon.ImageRectSize,
                    LayoutOrder = 1,
                    ZIndex = 9002,
                    Parent = TitleRow,
                })
                if Info.TitleColor then
                    IconImg.ImageColor3 = Info.TitleColor
                end
            end
        end

        local TitleLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 18),
            AutomaticSize = Enum.AutomaticSize.Y,
            Text = Info.Title,
            TextSize = 18,
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = 2,
            ZIndex = 9002,
            Parent = TitleRow,
        })
        if Info.TitleColor then
            TitleLabel.TextColor3 = Info.TitleColor
        end

        local DescriptionLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 14),
            AutomaticSize = Enum.AutomaticSize.Y,
            Text = Info.Description,
            TextSize = 14,
            TextTransparency = Info.DescriptionColor and 0 or 0.2,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            LayoutOrder = 2,
            ZIndex = 9002,
            Parent = HeaderContainer,
        })
        if Info.DescriptionColor then
            DescriptionLabel.TextColor3 = Info.DescriptionColor
        end

        DialogContainer = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            LayoutOrder = 4,
            ZIndex = 9002,
            Parent = InnerContainer,
        })
        local _DialogContainerLayout = New("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = DialogContainer,
        })
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 5),
            Parent = DialogContainer,
        })
        
        local _Sep2 = New("Frame", {
            BackgroundColor3 = "OutlineColor",
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 1),
            LayoutOrder = 5,
            ZIndex = 9002,
            Parent = InnerContainer,
        })

        ButtonsHolder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            LayoutOrder = 6,
            ZIndex = 9002,
            Parent = InnerContainer,
        })
        New("UIListLayout", {
            Padding = UDim.new(0, 8),
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Wraps = true,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = ButtonsHolder,
        })
        New("UIPadding", {
            PaddingTop = UDim.new(0, 5),
            Parent = ButtonsHolder,
        })

        local Dialog = {
            Type = "Dialog",
            Destroyed = false,
            Elements = {},
            DependencyBoxes = {},
            Container = DialogContainer,
        }

        function Dialog:Resize()
            local MaxWidth = MainFrame.AbsoluteSize.X * 0.75
            local MinWidth = 400

            local TotalButtonWidth = 0
            local ButtonCount = 0
            local HasButtons = false

            for _, BtnWrap in FooterButtonsList do
                HasButtons = true
                ButtonCount = ButtonCount + 1
                TotalButtonWidth = TotalButtonWidth + BtnWrap.Container.Size.X.Offset
            end

            local TargetWidth = MinWidth
            if HasButtons then
                local RequiredWidth = TotalButtonWidth + ((ButtonCount - 1) * 8) + 30
                TargetWidth = math.max(MinWidth, math.min(RequiredWidth, MaxWidth))
            end

            DialogFrame.Size = UDim2.fromOffset(TargetWidth, 0)

            local _DescX, DescY = Library:GetTextBounds(DescriptionLabel.Text, Library.Scheme.Font, 14, TargetWidth - 30)
            DescriptionLabel.Size = UDim2.new(1, 0, 0, DescY)

            local HasElements = false
            for _, v in DialogContainer:GetChildren() do
                if not v:IsA("UIListLayout") and not v:IsA("UIPadding") then
                    HasElements = true
                    break
                end
            end
            DialogContainer.Visible = HasElements

            ButtonsHolder.Visible = HasButtons
            _Sep2.Visible = HasButtons
        end

        function Dialog:SetTitle(Title)
            TitleLabel.Text = Title
            Dialog:Resize()
        end

        function Dialog:SetDescription(Description)
            DescriptionLabel.Text = Description
            Dialog:Resize()
        end

        function Dialog:Dismiss()
            if Dialog.Destroyed then
                return
            end

            Dialog.Destroyed = true

            if Library.ActiveDialog == Dialog then
                Library.ActiveDialog = nil
            end

            DestroyObjects(Dialog.DependencyBoxes)
            DestroyObjects(Dialog.Elements)
            DestroyObjects(FooterButtonsList)

            local CloseTween = TweenService:Create(DialogScale, Library.TweenInfo, { Scale = 0.95 })
            TweenService:Create(DialogOverlay, Library.TweenInfo, { BackgroundTransparency = 1 }):Play()
            CloseTween:Play()
            
            task.delay(Library.TweenInfo.Time, function()
                DialogOverlay:Destroy()
            end)
            if Library.Dialogues[Idx] == Dialog then
                Library.Dialogues[Idx] = nil
            end
        end

        Dialog.Destroy = Dialog.Dismiss

        DialogOverlay.MouseButton1Click:Connect(function()
            if Info.OutsideClickDismiss then
                Dialog:Dismiss()
            end
        end)

        function Dialog:RemoveFooterButton(ButtonIdx)
            if FooterButtonsList[ButtonIdx] then
                FooterButtonsList[ButtonIdx]:Destroy()
                Dialog:Resize()
            end
        end

        function Dialog:SetButtonDisabled(ButtonIdx, Disabled)
            if FooterButtonsList[ButtonIdx] and type(FooterButtonsList[ButtonIdx].SetDisabled) == "function" then
                FooterButtonsList[ButtonIdx]:SetDisabled(Disabled)
            end
        end

        function Dialog:SetButtonOrder(ButtonIdx, Order)
            if FooterButtonsList[ButtonIdx] and FooterButtonsList[ButtonIdx].Container then
                FooterButtonsList[ButtonIdx].Container.LayoutOrder = Order
            end
        end

        function Dialog:AddFooterButton(ButtonIdx, ButtonInfo)
            Dialog:RemoveFooterButton(ButtonIdx)

            local WaitTime = ButtonInfo.WaitTime or 0

            local ButtonContainer = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromOffset(0, 26),
                LayoutOrder = ButtonInfo.Order or 0,
                ZIndex = 9002,
                Parent = ButtonsHolder,
            })
            
            local BtnColor = "MainColor"
            local BtnOutline = "OutlineColor"
            local Variant = ButtonInfo.Variant or "Primary"
            
            if Variant == "Primary" then
                BtnColor = "FontColor"
                BtnOutline = "FontColor"
            elseif Variant == "Secondary" then
                BtnColor = "MainColor"
                BtnOutline = "OutlineColor"
            elseif Variant == "Destructive" then
                BtnColor = "DestructiveColor"
                BtnOutline = "DestructiveColor"
            elseif Variant == "Ghost" then
                BtnColor = "BackgroundColor"
                BtnOutline = "BackgroundColor"
            end

            local TextBtn = New("TextButton", {
                BackgroundColor3 = BtnColor,
                BorderColor3 = BtnOutline,
                BackgroundTransparency = WaitTime > 0 and 0.5 or 0,
                Size = UDim2.fromOffset(0, 26),
                Text = "",
                AutoButtonColor = false,
                ZIndex = 9002,
                Parent = ButtonContainer,
            })
            Library:AddOutline(TextBtn)
            local TextBtnCorner = TrackCornerMode(New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius > 6 and Library.CornerRadius / 2 or Library.CornerRadius),
                Parent = TextBtn
            }), "AdaptiveHalf")
            table.insert(Library.Corners, TextBtnCorner)

            local _BtnPadding = New("UIPadding", {
                PaddingLeft = UDim.new(0, 15),
                PaddingRight = UDim.new(0, 15),
                Parent = TextBtn,
            })

            local TextColor = Library.Scheme.FontColor
            if Variant == "Primary" then
                TextColor = Library.Scheme.BackgroundColor
            elseif Variant == "Destructive" then
                TextColor = Color3.new(1, 1, 1)
            end
            
            local BtnLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Text = ButtonInfo.Title or ButtonIdx,
                TextColor3 = TextColor,
                TextTransparency = WaitTime > 0 and 0.5 or 0,
                TextSize = 14,
                ZIndex = 9002,
                Parent = TextBtn,
            })
            
            local LabelX, _ = Library:GetTextBounds(BtnLabel.Text, Library.Scheme.Font, 14, 250)
            ButtonContainer.Size = UDim2.fromOffset(LabelX + 30, 26)
            TextBtn.Size = UDim2.fromOffset(LabelX + 30, 26)

            local ProgressBar
            local ProgressBarCorner
            if WaitTime > 0 then
                ProgressBar = New("Frame", {
                    BackgroundColor3 = "AccentColor",
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 1, -2),
                    Size = UDim2.new(0, 0, 0, 2),
                    ZIndex = 2,
                    Parent = TextBtn,
                })
                ProgressBarCorner = TrackCornerMode(New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius > 6 and Library.CornerRadius / 2 or Library.CornerRadius),
                    Parent = ProgressBar
                }), "AdaptiveHalf")
                table.insert(Library.Corners, ProgressBarCorner)
            end

            local IsActive = WaitTime <= 0

            local ButtonWrap = {
                Destroyed = false,
                Container = ButtonContainer,
                Corners = { TextBtnCorner, ProgressBarCorner },
                SetDisabled = function(self, Disabled)
                    if Dialog.Destroyed or not TextBtn.Parent then
                        return
                    end

                    IsActive = not Disabled
                    if Disabled then
                        TweenService:Create(TextBtn, Library.TweenInfo, { BackgroundTransparency = 0.5 }):Play()
                        TweenService:Create(BtnLabel, Library.TweenInfo, { TextTransparency = 0.5 }):Play()
                    else
                        TweenService:Create(TextBtn, Library.TweenInfo, { BackgroundTransparency = 0 }):Play()
                        TweenService:Create(BtnLabel, Library.TweenInfo, { TextTransparency = 0 }):Play()
                    end
                end
            }
            function ButtonWrap:Destroy()
                if ButtonWrap.Destroyed then
                    return
                end
                ButtonWrap.Destroyed = true

                for _, Corner in ButtonWrap.Corners do
                    if Corner then
                        local CornerIndex = table.find(Library.Corners, Corner)
                        if CornerIndex then
                            table.remove(Library.Corners, CornerIndex)
                        end
                        Library.CornerModes[Corner] = nil
                    end
                end

                if ButtonContainer then
                    ButtonContainer:Destroy()
                end
                if FooterButtonsList[ButtonIdx] == ButtonWrap then
                    FooterButtonsList[ButtonIdx] = nil
                end
            end

            local ActiveColor = typeof(BtnColor) == "Color3" and BtnColor or Library.Scheme[BtnColor]
            local HoverColor = Variant == "Ghost" and Library.Scheme.MainColor or Library:GetBetterColor(ActiveColor, 10)

            TextBtn.MouseEnter:Connect(function()
                if not IsActive then return end
                TweenService:Create(TextBtn, Library.TweenInfo, {
                    BackgroundColor3 = HoverColor
                }):Play()
            end)
            TextBtn.MouseLeave:Connect(function()
                if not IsActive then return end
                TweenService:Create(TextBtn, Library.TweenInfo, {
                    BackgroundColor3 = ActiveColor
                }):Play()
            end)

            TextBtn.MouseButton1Click:Connect(function()
                if not IsActive then return end
                if ButtonInfo.Callback then
                    ButtonInfo.Callback(Dialog)
                end
                if Info.AutoDismiss then
                    Dialog:Dismiss()
                end
            end)

            if WaitTime > 0 then
                TweenService:Create(ProgressBar, TweenInfo.new(WaitTime, Enum.EasingStyle.Linear), {
                    Size = UDim2.new(1, 0, 0, 2)
                }):Play()
                
                task.delay(WaitTime, function()
                    if Dialog.Destroyed or not TextBtn.Parent then
                        return
                    end

                    ButtonWrap:SetDisabled(false)
                    if ProgressBar and ProgressBar.Parent then
                        TweenService:Create(ProgressBar, Library.TweenInfo, {
                            BackgroundTransparency = 1
                        }):Play()
                    end
                end)
            end

            FooterButtonsList[ButtonIdx] = ButtonWrap
        end

        for BIdx, BInfo in Info.FooterButtons do
            if type(BIdx) == "number" and BInfo.Id then BIdx = BInfo.Id end
            Dialog:AddFooterButton(BIdx, BInfo)
        end

        setmetatable(Dialog, BaseGroupbox)
        Library.Dialogues[Idx] = Dialog

        Dialog:Resize()
        
        Library.ActiveDialog = Dialog
        return Dialog
    end

    local GuiProperties = { "BackgroundTransparency" }
    local ImageProperties = { "BackgroundTransparency", "ImageTransparency" }
    local TextProperties = { "BackgroundTransparency", "TextTransparency" }
    local StrokeProperties = { "Transparency" }

    local function FadeInstance(Desc, Properties)
        local Cache = TransparencyCache[Desc]
        if not Cache then
            Cache = {}
            TransparencyCache[Desc] = Cache
        end

        for _, Prop in Properties do
            if not Library.Toggled then
                Cache[Prop] = Desc[Prop]
            end

            if Cache[Prop] ~= nil and Cache[Prop] ~= 1 then
                TweenService:Create(Desc, Library.WindowAnimationInfo, {
                    [Prop] = Library.Toggled and Cache[Prop] or 1,
                }):Play()
            end
        end
    end

    function Window:Toggle(Value: boolean?)
        if Library.ActiveLoading then
            if Value == true then
                return
            end

            if not Library.Toggled then
                return
            end
        end

        if Fading then
            local BaseValue = if typeof(PendingToggleValue) == "boolean" then PendingToggleValue else Library.Toggled
            PendingToggleValue = if typeof(Value) == "boolean" then Value else not BaseValue
            return
        end

        if typeof(Value) == "boolean" then
            Library.Toggled = Value
        else
            Library.Toggled = not Library.Toggled
        end

        if Library.Animations and Library.Animations.ToggleWindow == true then
            local FadeTime = Library.WindowAnimationInfo.Time
            Fading = true

            if Library.Toggled then
                MainFrame.Visible = true
            end

            if Library.Toggled then 
				FadeInstance(MainFrame, { "BackgroundTransparency" })
				task.wait(FadeTime / 2)
			else
				task.delay(FadeTime / 2, FadeInstance, MainFrame, { "BackgroundTransparency" })
			end

            for _, Instance in MainFrame:GetDescendants() do
                if Instance == TopBar then
                    continue
                end

                if Instance:IsA("GuiObject") then
                    local ClassName = Instance.ClassName
                    if ClassName == "ImageLabel" or ClassName == "ImageButton" then
                        FadeInstance(Instance, ImageProperties)
                    elseif ClassName == "TextLabel" or ClassName == "TextBox" or ClassName == "TextButton" then
                        FadeInstance(Instance, TextProperties)
                    else
                        FadeInstance(Instance, GuiProperties)
                    end
                elseif Instance.ClassName == "UIStroke" then
                    FadeInstance(Instance, StrokeProperties)
                end
            end

            task.delay(FadeTime, function()
                MainFrame.Visible = Library.Toggled
                Fading = false

                local PendingValue = PendingToggleValue
                PendingToggleValue = nil
                if
                    not Library.Unloaded
                    and typeof(PendingValue) == "boolean"
                    and PendingValue ~= Library.Toggled
                then
                    Window:Toggle(PendingValue)
                end
            end)
        else
            MainFrame.Visible = Library.Toggled
        end

        if WindowInfo.UnlockMouseWhileOpen then
            ModalElement.Modal = Library.Toggled
        end

        if Library.Toggled and not Library.IsMobile then
            local OldMouseIconEnabled = UserInputService.MouseIconEnabled
            local ShowCursorBinding = Library.ShowCursorBinding
            pcall(function()
                RunService:UnbindFromRenderStep(ShowCursorBinding)
            end)
            RunService:BindToRenderStep(ShowCursorBinding, Enum.RenderPriority.Last.Value, function()
                UserInputService.MouseIconEnabled = not Library.ShowCustomCursor

                Cursor.Position = UDim2.fromOffset(Mouse.X, Mouse.Y)
                Cursor.Visible = Library.ShowCustomCursor

                if not (Library.Toggled and ScreenGui and ScreenGui.Parent) then
                    UserInputService.MouseIconEnabled = OldMouseIconEnabled
                    Cursor.Visible = false
                    RunService:UnbindFromRenderStep(ShowCursorBinding)
                end
            end)
        elseif not Library.Toggled then
            TooltipLabel.Visible = false

            for _, Option in Library.Options do
                if Option.Type == "ColorPicker" then
                    Option.ColorMenu:Close()
                    Option.ContextMenu:Close()
                elseif Option.Type == "Dropdown" or Option.Type == "KeyPicker" then
                    Option.Menu:Close()
                end
            end
        end
    end

    function Library:Toggle(Value: boolean?)
        return Window:Toggle(Value)
    end

    if WindowInfo.EnableSidebarResize then
        local Threshold = (WindowInfo.MinSidebarWidth + WindowInfo.SidebarCompactWidth) * WindowInfo.SidebarCollapseThreshold
        local StartPos, StartWidth
        local CantDragBeforeResize = false
        local Dragging = false
        local Changed

        local SidebarGrabber = New("TextButton", {
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundTransparency = 1,
            Position = UDim2.fromScale(0.5, 0),
            Size = UDim2.new(0, 8, 1, 0),
            Text = "",
            Parent = DividerLine,
        })
        SidebarGrabber.MouseEnter:Connect(function()
            TweenService:Create(DividerLine, Library.TweenInfo, {
                BackgroundColor3 = Library:GetLighterColor(Library.Scheme.OutlineColor),
            }):Play()
        end)
        SidebarGrabber.MouseLeave:Connect(function()
            if Dragging then
                return
            end
            TweenService:Create(DividerLine, Library.TweenInfo, {
                BackgroundColor3 = Library.Scheme.OutlineColor,
            }):Play()
        end)

        SidebarGrabber.InputBegan:Connect(function(Input: InputObject)
            if not IsClickInput(Input) then
                return
            end

            CantDragBeforeResize = Library.CantDragForced
            Library.CantDragForced = true

            StartPos = Input.Position
            StartWidth = Window:GetSidebarWidth()
            Dragging = true

            Changed = Input.Changed:Connect(function()
                if Input.UserInputState ~= Enum.UserInputState.End then
                    return
                end

                Library.CantDragForced = CantDragBeforeResize
                TweenService:Create(DividerLine, Library.TweenInfo, {
                    BackgroundColor3 = Library.Scheme.OutlineColor,
                }):Play()

                Dragging = false
                if Changed and Changed.Connected then
                    Changed:Disconnect()
                    Changed = nil
                end
            end)
        end)

        Library:GiveSignal(UserInputService.InputChanged:Connect(function(Input: InputObject)
            if not Library.Toggled or not (ScreenGui and ScreenGui.Parent) then
                if Dragging or Changed then
                    Library.CantDragForced = CantDragBeforeResize
                end
                Dragging = false
                if Changed and Changed.Connected then
                    Changed:Disconnect()
                    Changed = nil
                end

                return
            end

            if Dragging and IsHoverInput(Input) then
                local Delta = Input.Position - StartPos
                local Width = StartWidth + Delta.X

                if WindowInfo.DisableCompactingSnap then
                    Window:SetSidebarWidth(Width)
                    return
                end

                if Width > Threshold then
                    Window:SetSidebarWidth(math.max(Width, WindowInfo.MinSidebarWidth))
                else
                    Window:SetSidebarWidth(WindowInfo.SidebarCompactWidth)
                end
            end
        end))
    end
    if WindowInfo.EnableCompacting and WindowInfo.SidebarCompacted then
        Window:SetSidebarWidth(WindowInfo.SidebarCompactWidth)
    end
    if WindowInfo.AutoShow and not Library.ActiveLoading then
        task.spawn(Library.Toggle)
    end

    if Library.IsMobile then
        local ToggleButton = Library:AddDraggableButton("Toggle", function()
            Library:Toggle()
        end, true, true)

        local LockButton = Library:AddDraggableButton("Lock", function(self)
            Library.CantDragForced = not Library.CantDragForced
            self:SetText(Library.CantDragForced and "Unlock" or "Lock")
        end, true, true)

        if WindowInfo.MobileButtonsSide == "Right" then
            ToggleButton.Button.AnchorPoint = Vector2.new(1, 0)
            ToggleButton.Button.Position = UDim2.new(1, -6, 0, 6)

            LockButton.Button.AnchorPoint = Vector2.new(1, 0)
            LockButton.Button.Position = UDim2.new(1, -(ToggleButton.Button.Size.X.Offset + 12), 0, 6)
        else
            ToggleButton.Button.AnchorPoint = Vector2.new(0, 0)
            ToggleButton.Button.Position = UDim2.fromOffset(6, 6)

            LockButton.Button.AnchorPoint = Vector2.new(0, 0)
            LockButton.Button.Position = UDim2.fromOffset(ToggleButton.Button.Size.X.Offset + 12, 6)
        end

        if WindowInfo.ShowMobileButtons == false then
            ToggleButton.Button.Visible = false
            LockButton.Button.Visible = false
        end
    end

    --// Execution \\--
    Window:SetBackgroundImage(WindowInfo.BackgroundImage)
    Window:EnableBackgroundImage(WindowInfo.BackgroundImageEnabled)
    Window:SetGlow(WindowInfo.Glow)

    Window.SearchBox, Window.MainFrame = SearchBox, MainFrame
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        Library:UpdateSearch(SearchBox.Text)
    end)

    Library:GiveSignal(UserInputService.InputBegan:Connect(function(Input: InputObject)
        if Library.Unloaded then
            return
        end

        if UserInputService:GetFocusedTextBox() then
            return
        end

        if Input.KeyCode == Library.ToggleKeybind then
            Library:Toggle()
        end
    end))

    Library:GiveSignal(UserInputService.WindowFocused:Connect(function()
        Library.IsRobloxFocused = true
    end))
    Library:GiveSignal(UserInputService.WindowFocusReleased:Connect(function()
        Library.IsRobloxFocused = false
    end))

    Library.Window = Window
    return Window
end

function Library:CreateLoading(LoadingInfo)
    if Library.ActiveLoading then
        warn("Loading GUI already exists, you cannot create multiple Loading GUIs.")
        return Library.ActiveLoading
    end

    LoadingInfo = Library:Validate(LoadingInfo, Templates.Loading)
    assert(
        typeof(LoadingInfo.TotalSteps) == "number" and LoadingInfo.TotalSteps > 0,
        "TotalSteps must be a positive number."
    )
    LoadingInfo.CurrentStep = if typeof(LoadingInfo.CurrentStep) == "number" then LoadingInfo.CurrentStep else 0

    local Loading = {
        CurrentStep = LoadingInfo.CurrentStep,
        TotalSteps = LoadingInfo.TotalSteps,

        ShowSidebar = LoadingInfo.ShowSidebar,
        AutoResizeHeight = LoadingInfo.AutoResizeHeight,
        IsError = false,
        Destroyed = false,

        WindowWidth = LoadingInfo.WindowWidth,
        WindowHeight = LoadingInfo.WindowHeight,
        BaseWindowHeight = LoadingInfo.WindowHeight,
        WindowErrorHeight = LoadingInfo.WindowHeight,

        ContentWidth = LoadingInfo.ContentWidth,
        SidebarWidth = LoadingInfo.SidebarWidth,
    }

    --// ScreenGui \\--
    local ScreenGui = New("ScreenGui", {
        Name = "ObsidianLoading",
        DisplayOrder = 999,
        ResetOnSpawn = false
    })
    ParentUI(ScreenGui)
    Loading.ScreenGui = ScreenGui

    ScreenGui.DescendantRemoving:Connect(function(Instance)
        Library:RemoveFromRegistry(Instance)
    end)

    --// Main Frame \\--
    local MainFrame = New("TextButton", {
        Name = "Main",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = function()
            return Library:GetBetterColor(Library.Scheme.BackgroundColor, -1)
        end,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(Loading.ShowSidebar and (Loading.ContentWidth + Loading.SidebarWidth) or Loading.WindowWidth, Loading.WindowHeight),
        ClipsDescendants = true,
        Text = "",
        AutoButtonColor = false,
        Parent = ScreenGui,
    })
    Library:AddOutline(MainFrame)
    local MainCorner = New("UICorner", { CornerRadius = UDim.new(0, Library.CornerRadius), Parent = MainFrame })
    table.insert(Library.Corners, MainCorner)
    
	local MainScale = New("UIScale", {
		Scale = Library.IsMobile and 0.8 or 1,
		Parent = MainFrame
	})
	table.insert(Library.Scales, MainScale)
	Library.ScalesOffset[MainScale] = Library.IsMobile and 0.2 or 0

    --// Layout Containers \\--
    local Container = New("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.new(0, Loading.ContentWidth, 1, 0),
        Parent = MainFrame,
    })

    local SideBar = New("Frame", {
        Name = "SideBar",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(Loading.ContentWidth, 0),
        Size = UDim2.new(0, Loading.ShowSidebar and Loading.SidebarWidth or 0, 1, 0),
        ClipsDescendants = true,
        Visible = Loading.ShowSidebar,
        Parent = MainFrame,
    })
    local SidebarCorner = New("UICorner", { CornerRadius = UDim.new(0, Library.CornerRadius), Parent = SideBar })
    table.insert(Library.Corners, SidebarCorner)
    
    Library:AddOutline(SideBar)
    
    local SidebarDivider = New("Frame", {
        BackgroundColor3 = "OutlineColor",
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.new(0, 1, 1, 0),
        Visible = Loading.ShowSidebar,
        Parent = SideBar,
    })

    --// Top Bar \\--
    local TopBar = New("Frame", {
        Name = "TopBar",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 48),
        ZIndex = 2,
        Parent = Container,
    })
    Library:MakeDraggable(MainFrame, TopBar, true, true)

    local TitleHolder = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = TopBar,
    })
    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 6),
        Parent = TitleHolder,
    })
    New("UIPadding", {
        PaddingLeft = UDim.new(0, 12),
        Parent = TitleHolder,
    })

    local LoadingWindowIcon
    if LoadingInfo.Icon then
        local Icon = Library:GetCustomIcon(LoadingInfo.Icon)
        if Icon then
            LoadingWindowIcon = New("ImageLabel", {
                Image = Icon.Url,
                ImageRectOffset = Icon.ImageRectOffset,
                ImageRectSize = Icon.ImageRectSize,
                Size = LoadingInfo.IconSize,
                Parent = TitleHolder,
            })
        end
    end
    if not LoadingWindowIcon then
        LoadingInfo.Icon = nil
        LoadingWindowIcon = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = LoadingInfo.IconSize,
            Text = LoadingInfo.Title:sub(1, 1),
            TextScaled = true,
            Parent = TitleHolder,
        })
    end

    local TitleX = Library:GetTextBounds(
        LoadingInfo.Title,
        Library.Scheme.Font,
        20,
        TitleHolder.AbsoluteSize.X - (LoadingInfo.Icon and (LoadingInfo.IconSize.X.Offset + 6) or 0) - 12
    )
    local _WindowTitle = New("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, TitleX, 1, 0),
        Text = LoadingInfo.Title,
        TextSize = 20,
        Parent = TitleHolder,
    })

    Library:MakeLine(Container, {
        Position = UDim2.fromOffset(0, 48),
        Size = UDim2.new(1, 0, 0, 1),
    })

    --// Loading Content Elements \\--
    local InnerContent = New("Frame", {
        Name = "InnerContent",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 49),
        Size = UDim2.new(1, 0, 1, -49),
        Parent = Container,
    })

    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 12),
        Parent = InnerContent,
    })

    local IconHolder = New("Frame", {
        Name = "IconHolder",
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(64, 64),
        Parent = InnerContent,
    })

    local LoaderIcon = Library:GetCustomIcon(LoadingInfo.LoadingIcon)
        or Library:GetCustomIcon(Templates.Loading.LoadingIcon)
    local LoadingIcon = New("ImageLabel", {
        Name = "LoaderIcon",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1),
        Image = LoaderIcon and LoaderIcon.Url or "",
        ImageRectOffset = LoaderIcon and LoaderIcon.ImageRectOffset or Vector2.zero,
        ImageRectSize = LoaderIcon and LoaderIcon.ImageRectSize or Vector2.zero,
        ImageColor3 = LoadingInfo.LoadingIconColor or ((LoadingInfo.LoadingIcon == Templates.Loading.LoadingIcon) and "AccentColor" or "WhiteColor"),
        Parent = IconHolder,
    })

    local RotationTween
    if LoadingInfo.LoadingIconTweenTime > 0 then
        RotationTween = TweenService:Create(
            LoadingIcon,
            TweenInfo.new(LoadingInfo.LoadingIconTweenTime, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1),
            { Rotation = 360 }
        )
        RotationTween:Play()
    end

    local MessageLabel = New("TextLabel", {
        BackgroundTransparency = 1,
        AutomaticSize = Loading.AutoResizeHeight and Enum.AutomaticSize.Y or Enum.AutomaticSize.XY,
        Size = Loading.AutoResizeHeight and UDim2.new(1, -60, 0, 0) or UDim2.fromOffset(0, 0),
        Text = "",
        TextSize = 18,
        TextWrapped = Loading.AutoResizeHeight,
        Parent = InnerContent,
    })

    local DescriptionLabel = New("TextLabel", {
        BackgroundTransparency = 1,
        AutomaticSize = Loading.AutoResizeHeight and Enum.AutomaticSize.Y or Enum.AutomaticSize.XY,
        Size = Loading.AutoResizeHeight and UDim2.new(1, -60, 0, 0) or UDim2.fromOffset(0, 0),
        Text = "",
        TextSize = 14,
        TextTransparency = 0.5,
        TextWrapped = Loading.AutoResizeHeight,
        Parent = InnerContent,
    })

    --// Progress Bar \\--
    local SliderBar = New("Frame", {
        BackgroundColor3 = "MainColor",
        Size = UDim2.new(0.7, 0, 0, 15),
        Parent = InnerContent,
    })
    Library:AddOutline(SliderBar)

    local SliderFill = New("Frame", {
        BackgroundColor3 = "AccentColor",
        BorderSizePixel = 0,
        Size = UDim2.fromScale(0, 1),
        Parent = SliderBar,
    })

    local ProgressLabel = New("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Text = "",
        TextSize = 14,
        ZIndex = 2,
        Parent = SliderBar,
    })
    New("UIStroke", {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
        Color = "DarkColor",
        LineJoinMode = Enum.LineJoinMode.Miter,
        Parent = ProgressLabel,
    })

    --// Sidebar Object \\--
    local SidebarScrolling = New("ScrollingFrame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Size = UDim2.fromScale(1, 1),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = "OutlineColor",
        Parent = SideBar,
    })
    local SidebarList = New("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = SidebarScrolling,
    })
    New("UIPadding", {
        PaddingBottom = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        PaddingTop = UDim.new(0, 12),
        Parent = SidebarScrolling,
    })

    local SidebarObject = {
        Connections = {},
        Destroyed = false,
        Elements = {},
        DependencyBoxes = {},
        Tabboxes = {},
        
        BoxHolder = SidebarScrolling,
        Container = SidebarScrolling,
        
        Resize = function(self)
            SidebarScrolling.CanvasSize = UDim2.fromOffset(0, SidebarList.AbsoluteContentSize.Y + 24)
        end,
        Tab = {
            Elements = {},
            DependencyBoxes = {},
            DependencyGroupboxes = {},
            Tabboxes = {},
        },
    }

    table.insert(
        SidebarObject.Connections,
        SidebarList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            SidebarObject:Resize()
        end)
    )

    setmetatable(SidebarObject, BaseGroupbox)
    Loading.Sidebar = SidebarObject

    --// Error Frame \\--
    local ErrorFrame = New("Frame", {
        Name = "Error",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 49),
        Size = UDim2.new(1, 0, 1, -49),
        ClipsDescendants = true,
        Visible = false,
        Parent = Container,
    })

    local _ErrorTitle = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(15, 15),
        Size = UDim2.new(1, -30, 0, 18),
        Text = "Error",
        TextColor3 = "RedColor",
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = ErrorFrame,
    })

    local ErrorLabel = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(15, 39),
        Size = UDim2.new(1, -30, 1, -90),
        Text = "Error Message",
        TextSize = 14,
        TextTransparency = 0.2,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        Parent = ErrorFrame,
    })

    local ErrorButtonsDivider = New("Frame", {
        BackgroundColor3 = "OutlineColor",
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 1, -48),
        Size = UDim2.new(1, -30, 0, 1),
        Visible = false,
        Parent = ErrorFrame,
    })

    local ErrorButtonsHolder = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, 42),
        Visible = false,
        Parent = ErrorFrame,
    })
    New("UIListLayout", {
        Padding = UDim.new(0, 8),
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = ErrorButtonsHolder,
    })
    New("UIPadding", {
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 15),
        PaddingRight = UDim.new(0, 15),
        Parent = ErrorButtonsHolder,
    })
    local ErrorButtonCorners = {}

    local function ClearErrorButtonCorners()
        for _, Corner in ErrorButtonCorners do
            local CornerIndex = table.find(Library.Corners, Corner)
            if CornerIndex then
                table.remove(Library.Corners, CornerIndex)
            end
            Library.CornerModes[Corner] = nil
        end
        table.clear(ErrorButtonCorners)
    end

    function Loading:UpdateLayout()
        if Loading.IsError then
            Loading:RecalculateErrorHeight()
        end

        local ShowSidebar = Loading.ShowSidebar and not Loading.IsError
        local FinalWidth = ShowSidebar and (Loading.ContentWidth + Loading.SidebarWidth) or Loading.WindowWidth
        local FinalHeight = Loading.IsError and Loading.WindowErrorHeight or Loading.WindowHeight
        
        if ShowSidebar then
            SideBar.Visible = true
            SidebarDivider.Visible = true
        end

        TweenService:Create(MainFrame, Library.TweenInfo, { Size = UDim2.fromOffset(FinalWidth, FinalHeight) }):Play()
        TweenService:Create(SideBar, Library.TweenInfo, { Position = UDim2.fromOffset(Loading.ContentWidth, 0), Size = UDim2.new(0, ShowSidebar and Loading.SidebarWidth or 0, 1, 0) }):Play()
        TweenService:Create(Container, Library.TweenInfo, { Size = UDim2.new(0, ShowSidebar and Loading.ContentWidth or Loading.WindowWidth, 1, 0) }):Play()

        if not ShowSidebar then
            task.delay(Library.TweenInfo.Time, function()
                if not (Loading.ShowSidebar and not Loading.IsError) then
                    SideBar.Visible = false
                    SidebarDivider.Visible = false
                end
            end)
        end
    end

    --// Content Page \\--
    function Loading:RecalculateLoadingHeight()
        if not Loading.AutoResizeHeight then
            return
        end

        local RequiredHeight = 
              49 -- TopBar
            + 48 -- Padding
            + InnerContent.UIListLayout.AbsoluteContentSize.Y

        Loading.WindowHeight = math.max(Loading.BaseWindowHeight, RequiredHeight)
    end

    function Loading:SetMessage(Text)
        MessageLabel.Text = Text

        if Loading.AutoResizeHeight then
            Loading:RecalculateLoadingHeight()
            Loading:UpdateLayout()
        end
    end

    function Loading:SetDescription(Text)
        DescriptionLabel.Text = Text

        if Loading.AutoResizeHeight then
            Loading:RecalculateLoadingHeight()
            Loading:UpdateLayout()
        end
    end

    function Loading:SetLoadingIcon(Icon)
        local IconData = Library:GetCustomIcon(Icon)
        if not IconData then
            return false
        end

        LoadingIcon.Image = IconData.Url
        LoadingIcon.ImageRectOffset = IconData.ImageRectOffset
        LoadingIcon.ImageRectSize = IconData.ImageRectSize
        return true
    end

    function Loading:SetLoadingIconTweenTime(TweenTime)
        if RotationTween then
            StopTween(RotationTween, true)
            RotationTween = nil
        end

        if TweenTime > 0 then
            RotationTween = TweenService:Create(
                LoadingIcon,
                TweenInfo.new(TweenTime, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1),
                { Rotation = 360 }
            )
            RotationTween:Play()
        else
            LoadingIcon.Rotation = 0
        end
    end

    function Loading:SetLoadingIconColor(Color)
        LoadingIcon.ImageColor3 = Color
    end

    function Loading:SetCurrentStep(Step)
        assert(typeof(Step) == "number", "Step must be a number.")
        Loading.CurrentStep = math.clamp(Step, 0, Loading.TotalSteps)

        local Progress = Loading.CurrentStep / Loading.TotalSteps
        TweenService:Create(SliderFill, Library.TweenInfo, { Size = UDim2.fromScale(Progress, 1) }):Play()

        ProgressLabel.Text = string.format("%d/%d", Loading.CurrentStep, Loading.TotalSteps)
    end

    function Loading:SetTotalSteps(Steps)
        assert(typeof(Steps) == "number" and Steps > 0, "Steps must be a positive number.")
        Loading.TotalSteps = Steps
        Loading:SetCurrentStep(Loading.CurrentStep)
    end

    --// Size \\--
    function Loading:SetWindowHeight(Height)
        Loading.WindowHeight = Height
        Loading:UpdateLayout()
    end

    function Loading:SetWindowWidth(Width)
        Loading.WindowWidth = Width
        Loading:UpdateLayout()
    end

    function Loading:SetContentWidth(Width)
        Loading.ContentWidth = Width
        Loading:UpdateLayout()
    end

    function Loading:SetSidebarWidth(Width)
        Loading.SidebarWidth = Width
        Loading:UpdateLayout()
    end

    --// Sidebar \\--
    function Loading:ShowSidebarPage(Bool)
        assert(typeof(Bool) == "boolean", "Expected boolean for Bool, got: " .. typeof(Bool))
        Loading.ShowSidebar = Bool
        Loading:UpdateLayout()
    end

    --// Error Page \\--
    function Loading:ShowErrorPage(Enabled)
        assert(typeof(Enabled) == "boolean", "Expected boolean for Enabled, got: " .. typeof(Enabled))
        Loading.IsError = Enabled
        InnerContent.Visible = not Enabled
        ErrorFrame.Visible = Enabled
        Loading:UpdateLayout()
    end

    function Loading:RecalculateErrorHeight()
        local TargetWidth = (Loading.ShowSidebar and not Loading.IsError and Loading.ContentWidth or Loading.WindowWidth) - 30
        local _, ErrorY = Library:GetTextBounds(ErrorLabel.Text, Library.Scheme.Font, 14, TargetWidth)

        ErrorLabel.Size = UDim2.new(1, -30, 0, ErrorY)

        local HasButtons = ErrorButtonsHolder.Visible
        local RequiredHeight =
              49                        -- TopBar
            + 15                        -- Padding Top
            + 18                        -- Title Height
            + 6                         -- Padding between Title and Label
            + ErrorY                    -- Label Height
            + 15                        -- Padding between Label and Buttons
            + (HasButtons and 48 or 0)  -- Buttons Area

        Loading.WindowErrorHeight = RequiredHeight -- math.max(Loading.WindowHeight, RequiredHeight)
    end

    function Loading:SetErrorMessage(Text)
        ErrorLabel.Text = Text
        Loading:UpdateLayout()
    end

    function Loading:SetErrorButtons(Buttons)
        assert(typeof(Buttons) == "table", "Buttons must be a table")

        ClearErrorButtonCorners()
        for _, button in ErrorButtonsHolder:GetChildren() do
            if button:IsA("Frame") then 
                button:Destroy() 
            end
        end

        local HasButtons = GetTableSize(Buttons) > 0
        ErrorButtonsHolder.Visible = HasButtons
        ErrorButtonsDivider.Visible = HasButtons

        for Idx, ButtonInfo in Buttons do
            local ButtonContainer = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromOffset(0, 26),
                Parent = ErrorButtonsHolder,
            })
            
            local BtnColor = "MainColor"
            local BtnOutline = "OutlineColor"
            local Variant = ButtonInfo.Variant or "Primary"
            
            if Variant == "Primary" then
                BtnColor = "FontColor"
                BtnOutline = "FontColor"
            elseif Variant == "Secondary" then
                BtnColor = "MainColor"
                BtnOutline = "OutlineColor"
            elseif Variant == "Destructive" then
                BtnColor = "DestructiveColor"
                BtnOutline = "DestructiveColor"
            elseif Variant == "Ghost" then
                BtnColor = "BackgroundColor"
                BtnOutline = "BackgroundColor"
            end

            local TextBtn = New("TextButton", {
                BackgroundColor3 = BtnColor,
                BorderColor3 = BtnOutline,
                Size = UDim2.fromOffset(0, 26),
                Text = "",
                AutoButtonColor = false,
                Parent = ButtonContainer,
            })
            Library:AddOutline(TextBtn)
            local ButtonCorner = TrackCornerMode(New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius > 6 and Library.CornerRadius / 2 or Library.CornerRadius),
                Parent = TextBtn
            }), "AdaptiveHalf")
            table.insert(Library.Corners, ButtonCorner)
            table.insert(ErrorButtonCorners, ButtonCorner)

            New("UIPadding", {
                PaddingLeft = UDim.new(0, 15),
                PaddingRight = UDim.new(0, 15),
                Parent = TextBtn,
            })

            local TextColor = Library.Scheme.FontColor
            if Variant == "Primary" then
                TextColor = Library.Scheme.BackgroundColor
            elseif Variant == "Destructive" then
                TextColor = Color3.new(1, 1, 1)
            end

            local BtnLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Text = ButtonInfo.Title or Idx,
                TextColor3 = TextColor,
                TextSize = 14,
                Parent = TextBtn,
            })
            
            local LabelX, _ = Library:GetTextBounds(BtnLabel.Text, Library.Scheme.Font, 14, 250)
            ButtonContainer.Size = UDim2.fromOffset(LabelX + 30, 26)
            TextBtn.Size = UDim2.fromOffset(LabelX + 30, 26)

            local ActiveColor = typeof(BtnColor) == "Color3" and BtnColor or Library.Scheme[BtnColor]
            local HoverColor = Variant == "Ghost" and Library.Scheme.MainColor or Library:GetBetterColor(ActiveColor, 10)

            TextBtn.MouseEnter:Connect(function()
                TweenService:Create(TextBtn, Library.TweenInfo, {
                    BackgroundColor3 = HoverColor
                }):Play()
            end)
            TextBtn.MouseLeave:Connect(function()
                TweenService:Create(TextBtn, Library.TweenInfo, {
                    BackgroundColor3 = ActiveColor
                }):Play()
            end)

            TextBtn.MouseButton1Click:Connect(function()
                if ButtonInfo.Callback then
                    ButtonInfo.Callback(Loading)
                end
            end)
        end

        Loading:UpdateLayout()
    end

    --// Destroy/Continue \\--
    function Loading:Destroy()
        if Loading.Destroyed then
            return
        end
        Loading.Destroyed = true

        if RotationTween then
            StopTween(RotationTween, true)
            RotationTween = nil
        end

        for _, Connection in SidebarObject.Connections do
            Connection:Disconnect()
        end
        DestroyObjects(SidebarObject.Tabboxes)
        DestroyObjects(SidebarObject.Elements)
        DestroyObjects(SidebarObject.DependencyBoxes)
        DestroyObjects(SidebarObject.Tab.DependencyGroupboxes)
        SidebarObject.Destroyed = true

        local ScaleIndex = table.find(Library.Scales, MainScale)
        if ScaleIndex then
            table.remove(Library.Scales, ScaleIndex)
        end
        Library.ScalesOffset[MainScale] = nil

        for _, Corner in { MainCorner, SidebarCorner } do
            local CornerIndex = table.find(Library.Corners, Corner)
            if CornerIndex then
                table.remove(Library.Corners, CornerIndex)
            end
            Library.CornerModes[Corner] = nil
        end
        ClearErrorButtonCorners()

        if TooltipLabel.Parent == ScreenGui then
            TooltipLabel.Visible = false
            CurrentHoverInstance = nil
            if Library.ScreenGui and Library.ScreenGui.Parent then
                TooltipLabel.Parent = Library.ScreenGui
                RestoreTooltipRegistry()
            end
        end

        ScreenGui:Destroy()
        if Library.ActiveLoading == Loading then
            Library.ActiveLoading = nil
        end

        if
            Loading.RestoreWindowOnDestroy
            and Library.Toggle
            and Library.Toggled == false
            and Library.Unloaded ~= true
        then
            Library:Toggle(true)
        end
    end

    Loading.Continue = Loading.Destroy;

    Loading.RestoreWindowOnDestroy = Library.Toggle and Library.Toggled and Library.Unloaded ~= true
    if Loading.RestoreWindowOnDestroy then
        Library:Toggle(false)
    end

    Loading:SetCurrentStep(Loading.CurrentStep)

    Library.ActiveLoading = Loading
    return Loading
end

local function OnPlayerChange()
    if Library.Unloaded then
        return
    end

    local PlayerList, ExcludedPlayerList = GetPlayers(), GetPlayers(true)
    for _, Dropdown in Options do
        if Dropdown.Type == "Dropdown" and Dropdown.SpecialType == "Player" then
            Dropdown:SetValues(Dropdown.ExcludeLocalPlayer and ExcludedPlayerList or PlayerList)
        end
    end
end

local function OnTeamChange()
    if Library.Unloaded then
        return
    end

    local TeamList = GetTeams()
    for _, Dropdown in Options do
        if Dropdown.Type == "Dropdown" and Dropdown.SpecialType == "Team" then
            Dropdown:SetValues(TeamList)
        end
    end
end

Library:GiveSignal(Players.PlayerAdded:Connect(OnPlayerChange))
Library:GiveSignal(Players.PlayerRemoving:Connect(OnPlayerChange))

Library:GiveSignal(Teams.ChildAdded:Connect(OnTeamChange))
Library:GiveSignal(Teams.ChildRemoved:Connect(OnTeamChange))

function Library:Unload()
    Library.Unloaded = true

    --// Disconnect connections
    for Index = #Library.Signals, 1, -1 do
        local Connection = table.remove(Library.Signals, Index)

        if Connection and Connection.Connected then
            Connection:Disconnect()
        end
    end

    --// Run Unload Callbacks
    for _ = 1, #Library.UnloadSignals do
        local Callback = table.remove(Library.UnloadSignals, 1)

        if Callback then
            Library:SafeCallback(Callback)
        end
    end

    --// Destroy elements
    DestroyObjects(Library.Tabs)
    DestroyObjects(Library.Dialogues)
    DestroyObjects(Library.Notifications)

    for Index = #Tooltips, 1, -1 do
        local Tooltip = table.remove(Tooltips, Index)

        if Tooltip and Tooltip.Destroy then
            Library:SafeCallback(Tooltip.Destroy, Tooltip)
        end
    end

    if Library.ActiveLoading then
        Library.ActiveLoading:Destroy()
    end

    if ScreenGui then
        ScreenGui:Destroy()
    end

    --// Clear tables
    table.clear(Library.Registry)

    table.clear(Options)
    table.clear(Toggles)
    table.clear(Buttons)
    table.clear(Labels)
    table.clear(Tooltips)

    table.clear(Library.Tabs)
    table.clear(Library.TabButtons)

    table.clear(Library.Scales)
    table.clear(Library.ScalesOffset)

    table.clear(Library.Corners)
    table.clear(Library.CornerModes)
    table.clear(Library.SpecificCorners)

    table.clear(Library.Notifications)
    table.clear(Library.Dialogues)
    table.clear(Library.DraggableElements)
    table.clear(Library.KeybindToggles)
    table.clear(Library.DependencyBoxes)

    table.clear(TransparencyCache)
    table.clear(ActiveTabTweens)
    
    Library.Toggle = function(...) end
    Library.ScreenGui = nil
    Library.WindowContainer = nil
    Library.KeybindFrame = nil
    Library.KeybindContainer = nil
    Library.ActiveTab = nil
    Library.ActiveDialog = nil

    getgenv().Library = nil
end

getgenv().Library = Library
return Library

end)()
-- Compatibility only: all visual controls and layout come from the vendored Obsidian fork.
local Library={native=NativeLibrary,alive=true}
local serial=0
local function id()
    serial+=1;return "Comet_"..serial
end
local function guard(fn,...)
    if not fn then return end
    local args=table.pack(...)
    task.spawn(function()
        local ok,why=pcall(fn,table.unpack(args,1,args.n))
        if not ok and Library.alive then Library.CreateNoti({Title="Action failed",Desc=tostring(why)})end
    end)
end
function Library.DisconnectConnections()
    if not Library.alive then return end
    Library.alive=false
    if not NativeLibrary.Unloaded then NativeLibrary:Unload()end
end
Library.DestroyUI=Library.DisconnectConnections
function Library.ToggleUI()
    if Library.alive then
        Library.ScreenGui.Enabled=true
        NativeLibrary:Toggle();getgenv().UIToggled=NativeLibrary.Toggled
    end
end
function Library.CreateNoti(options)
    if Library.alive then NativeLibrary:Notify({Title=options.Title or "CometHub",Description=options.Desc or "",Time=options.ShowTime or 4})end
end
function Library.CreateMain(options)
    local native=NativeLibrary:CreateWindow({Title=options.Title or "CometHub",Footer="Anime Adventures",Size=UDim2.fromOffset(760,510),Center=true,AutoShow=true,Resizable=true,GlobalSearch=true,ShowCustomCursor=false,Glow=false})
    Library.ScreenGui=NativeLibrary.ScreenGui
    Library.ScreenGui.Name="CometHubObsidian"
    getgenv().UIToggled=true
    local window={native=native,pages={},Main=native.MainFrame,SearchBox=native.SearchBox}
    local pageIcons={Overview="house",Joiners="list-ordered",["April Fools"]="sparkles",Autoplay="map-pin",Macros="clapperboard",Dungeon="door-open",Game="swords",Webhook="bell",Settings="settings"}
    local sectionIcons={Positions="map-pin",["Stage setup"]="sliders-horizontal",["Economy & upgrades"]="coins",["Unit overrides"]="users",["April Fools"]="sparkles",["Join priority"]="list-ordered",["Discord Webhook"]="bell",Dungeon="door-open",["Assassin Contracts"]="crosshair"}
    window.SelectPage=function(name)
        for _,page in ipairs(window.pages)do if page.name==name or page.title==name then page.native:Show();window.active=page;return true end end
        return false
    end
    window.Filter=function()NativeLibrary:UpdateSearch(window.SearchBox and window.SearchBox.Text or "")end
    NativeLibrary:GiveSignal(game:GetService("UserInputService").InputBegan:Connect(function(input)
        if input.KeyCode==Enum.KeyCode.K and(game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl)or game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.RightControl))then
            Library.ScreenGui.Enabled=true;NativeLibrary:Toggle(true)
            if window.SearchBox then window.SearchBox:CaptureFocus()end
        end
    end))
    NativeLibrary:OnUnload(function()
        Library.alive=false
        local hub=getgenv().CometAA
        if hub and hub.ui==Library and hub.alive and hub.unload then hub.unload()end
    end)
    function window.CreatePage(config)
        local title=config.Page_Title or config.Page_Name
        local tab=native:AddTab(title,pageIcons[config.Page_Name],title)
        local page={native=tab,name=config.Page_Name,title=title,sections={}}
        table.insert(window.pages,page)
        if not window.active then window.active=page end
        function page.CreateSection(name,collapsed)
            local side=#page.sections%2+1
            local group=tab:AddGroupbox({Name=name,Side=side,IconName=sectionIcons[name],Collapsed=collapsed==true})
            local section={native=group,title=name,items={}}
            table.insert(page.sections,section)
            local function controlRecord(raw,key)
                table.insert(section.items,{native=raw,key=key})
                return raw
            end
            function section.CreateLabel(config)
                local raw=controlRecord(group:AddLabel(id(),{Text=config.Title or "",DoesWrap=true,Size=13}),config.Title)
                return {native=raw,SetText=function(text)raw:SetText(tostring(text))end,SetColor=function(color)if raw.TextLabel then raw.TextLabel.TextColor3=color end end}
            end
            function section.CreateButton(config,callback)
                local raw=controlRecord(group:AddButton({Text=config.Title,Func=function()guard(callback)end}),config.Title)
                return {native=raw,Button=raw.Base}
            end
            function section.CreateToggle(config,callback)
                local silent=true
                local raw=controlRecord(group:AddToggle(id(),{Text=config.Title,Default=config.Default==true,Tooltip=config.Desc,Callback=function(v)if not silent then guard(callback,v)end end}),config.Title)
                silent=false
                local function set(v,mute)silent=mute==true;raw:SetValue(v==true);silent=false end
                return {native=raw,SetStage=function(v)set(v)end,SetValue=set,GetValue=function()return raw.Value end}
            end
            function section.CreateBox(config,callback)
                local silent=true
                local raw=controlRecord(group:AddInput(id(),{Text=config.Title,Default=tostring(config.Default or ""),Placeholder=config.Placeholder or "",Finished=true,ClearTextOnFocus=false,Callback=function(v)if not silent then guard(callback,v)end end}),config.Title)
                silent=false
                return {native=raw,SetText=function(v)silent=true;raw:SetValue(tostring(v or ""));silent=false end,GetText=function()return raw.Value end}
            end
            function section.CreateSlider(config,callback)
                local silent=true
                local raw=controlRecord(group:AddSlider(id(),{Text=config.Title,Min=config.Min,Max=config.Max,Default=math.clamp(tonumber(config.Default)or config.Min,config.Min,config.Max),Rounding=0,Callback=function(v)if not silent then guard(callback,v)end end}),config.Title)
                silent=false
                return {native=raw,SetValue=function(v,mute)silent=mute==true;raw:SetValue(v);silent=false end,GetValue=function()return raw.Value end}
            end
            function section.CreateDropdown(config,callback)
                local silent=true
                local values,selected={},{}
                local multi=config.Selected==true
                if multi then
                    for key,v in pairs(config.List or{})do
                        if type(key)=="number"then
                            table.insert(values,v)
                            local defaults=config.Default or {}
                            if defaults[v]==true or table.find(defaults,v)then selected[v]=true end
                        else table.insert(values,key);if v then selected[key]=true end end
                    end;table.sort(values)
                else values=config.List or{};selected=config.Default end
                if not multi and not table.find(values,selected)then selected=nil end
                local previous=multi and table.clone(selected)or nil
                local raw=controlRecord(group:AddDropdown(id(),{Text=config.Title,Values=values,Default=selected,Multi=multi,AllowNull=true,Searchable=config.Search==true or #values>8,Callback=function(v)
                    if multi then
                        local now=type(v)=="table"and v or{}
                        if not silent then for _,key in ipairs(values)do if (previous[key]==true)~=(now[key]==true)then guard(callback,key,now[key]==true)end end end
                        previous=table.clone(now)
                    elseif not silent then guard(callback,v)end
                end}),config.Title)
                silent=false
                local function set(v,mute)silent=mute==true;raw:SetValue(v);silent=false end
                return {native=raw,SetValue=set,GetValue=function()return raw.Value end,
                    GetNewList=function(_,list)
                        silent=true;values=multi and{}or(list or{})
                        if multi then for key,value in pairs(list or{})do table.insert(values,type(key)=="number" and value or key)end;table.sort(values)end
                        raw:SetValues(values);silent=false
                    end,
                    ClearText=function(_,v)set(v,true)end}
            end
            function section.CreateBind(config)
                local raw=group:AddLabel(config.Title)
                local picker=raw:AddKeyPicker(id(),{Default=config.Key.Name,Mode="Toggle",Text=config.Title,NoUI=true})
                NativeLibrary.ToggleKeybind=picker
                return picker
            end
            return section
        end
        return page
    end
    return window
end
return Library

end)()
local STAGE_CATALOG = game:GetService("HttpService"):JSONDecode([==[[{"id":"tokyoghoul_winter_1","name":"Act 1","world":"","kind":"Events","group":"tokyo_ghoul__winter","groupName":"Fiend City (Winter)","worldRank":12,"actNumber":1},{"id":"tokyoghoul_winter_2","name":"Act 2","world":"","kind":"Events","group":"tokyo_ghoul__winter","groupName":"Fiend City (Winter)","worldRank":12,"actNumber":2},{"id":"tokyoghoul_winter_3","name":"Act 3","world":"","kind":"Events","group":"tokyo_ghoul__winter","groupName":"Fiend City (Winter)","worldRank":12,"actNumber":3},{"id":"tokyoghoul_winter_4","name":"Act 4","world":"","kind":"Events","group":"tokyo_ghoul__winter","groupName":"Fiend City (Winter)","worldRank":12,"actNumber":4},{"id":"tokyoghoul_winter_5","name":"Act 5","world":"","kind":"Events","group":"tokyo_ghoul__winter","groupName":"Fiend City (Winter)","worldRank":12,"actNumber":5},{"id":"tokyoghoul_winter_6","name":"Act 6","world":"","kind":"Events","group":"tokyo_ghoul__winter","groupName":"Fiend City (Winter)","worldRank":12,"actNumber":6},{"id":"jjk_winter_1","name":"Act 1","world":"","kind":"Events","group":"jjk__winter","groupName":"Haunted Academy (Frozen)","worldRank":12,"actNumber":1},{"id":"jjk_winter_2","name":"Act 2","world":"","kind":"Events","group":"jjk__winter","groupName":"Haunted Academy (Frozen)","worldRank":12,"actNumber":2},{"id":"jjk_winter_3","name":"Act 3","world":"","kind":"Events","group":"jjk__winter","groupName":"Haunted Academy (Frozen)","worldRank":12,"actNumber":3},{"id":"jjk_winter_4","name":"Act 4","world":"","kind":"Events","group":"jjk__winter","groupName":"Haunted Academy (Frozen)","worldRank":12,"actNumber":4},{"id":"jjk_winter_5","name":"Act 5","world":"","kind":"Events","group":"jjk__winter","groupName":"Haunted Academy (Frozen)","worldRank":12,"actNumber":5},{"id":"jjk_winter_6","name":"Act 6","world":"","kind":"Events","group":"jjk__winter","groupName":"Haunted Academy (Frozen)","worldRank":12,"actNumber":6},{"id":"csm_portal_secret","name":"[Contract] The Sword Hybrid","world":"","kind":"Events","group":"csm_city","groupName":"Hellish City","worldRank":12,"actNumber":1},{"id":"csm_portal_1","name":"[Contract] The Tomato","world":"","kind":"Events","group":"csm_city","groupName":"Hellish City","worldRank":12,"actNumber":1},{"id":"csm_portal_2","name":"[Contract] The Slug","world":"","kind":"Events","group":"csm_city","groupName":"Hellish City","worldRank":12,"actNumber":2},{"id":"csm_portal_3","name":"[Contract] The Marshmallow","world":"","kind":"Events","group":"csm_city","groupName":"Hellish City","worldRank":12,"actNumber":3},{"id":"csm_portal_4","name":"[Contract] The Batty","world":"","kind":"Events","group":"csm_city","groupName":"Hellish City","worldRank":12,"actNumber":4},{"id":"csm_portal_5","name":"[Contract] The Fishy","world":"","kind":"Events","group":"csm_city","groupName":"Hellish City","worldRank":12,"actNumber":5},{"id":"csm_portal_6","name":"[Contract] The Leech","world":"","kind":"Events","group":"csm_city","groupName":"Hellish City","worldRank":12,"actNumber":6},{"id":"magnolia_winter_1","name":"Act 1","world":"","kind":"Events","group":"magnolia__winter","groupName":"Magic Town (Snow)","worldRank":12,"actNumber":1},{"id":"magnolia_winter_2","name":"Act 2","world":"","kind":"Events","group":"magnolia__winter","groupName":"Magic Town (Snow)","worldRank":12,"actNumber":2},{"id":"magnolia_winter_3","name":"Act 3","world":"","kind":"Events","group":"magnolia__winter","groupName":"Magic Town (Snow)","worldRank":12,"actNumber":3},{"id":"magnolia_winter_4","name":"Act 4","world":"","kind":"Events","group":"magnolia__winter","groupName":"Magic Town (Snow)","worldRank":12,"actNumber":4},{"id":"magnolia_winter_5","name":"Act 5","world":"","kind":"Events","group":"magnolia__winter","groupName":"Magic Town (Snow)","worldRank":12,"actNumber":5},{"id":"magnolia_winter_6","name":"Act 6","world":"","kind":"Events","group":"magnolia__winter","groupName":"Magic Town (Snow)","worldRank":12,"actNumber":6},{"id":"namek_winter_1","name":"Act 1","world":"","kind":"Events","group":"namek_cartoon__winter","groupName":"Planet Greenie (Frozen)","worldRank":12,"actNumber":1},{"id":"esdeath_portal","name":"The Ice Queen","world":"","kind":"Events","group":"namek_cartoon__winter","groupName":"Planet Greenie (Frozen)","worldRank":12,"actNumber":1},{"id":"namek_winter_2","name":"Act 2","world":"","kind":"Events","group":"namek_cartoon__winter","groupName":"Planet Greenie (Frozen)","worldRank":12,"actNumber":2},{"id":"namek_winter_3","name":"Act 3","world":"","kind":"Events","group":"namek_cartoon__winter","groupName":"Planet Greenie (Frozen)","worldRank":12,"actNumber":3},{"id":"namek_winter_4","name":"Act 4","world":"","kind":"Events","group":"namek_cartoon__winter","groupName":"Planet Greenie (Frozen)","worldRank":12,"actNumber":4},{"id":"namek_winter_5","name":"Act 5","world":"","kind":"Events","group":"namek_cartoon__winter","groupName":"Planet Greenie (Frozen)","worldRank":12,"actNumber":5},{"id":"namek_winter_6","name":"Act 6","world":"","kind":"Events","group":"namek_cartoon__winter","groupName":"Planet Greenie (Frozen)","worldRank":12,"actNumber":6},{"id":"naruto_winter_1","name":"Act 1","world":"","kind":"Events","group":"naruto__winter","groupName":"Sand Village (Snow)","worldRank":12,"actNumber":1},{"id":"naruto_winter_2","name":"Act 2","world":"","kind":"Events","group":"naruto__winter","groupName":"Sand Village (Snow)","worldRank":12,"actNumber":2},{"id":"naruto_winter_3","name":"Act 3","world":"","kind":"Events","group":"naruto__winter","groupName":"Sand Village (Snow)","worldRank":12,"actNumber":3},{"id":"naruto_winter_4","name":"Act 4","world":"","kind":"Events","group":"naruto__winter","groupName":"Sand Village (Snow)","worldRank":12,"actNumber":4},{"id":"naruto_winter_5","name":"Act 5","world":"","kind":"Events","group":"naruto__winter","groupName":"Sand Village (Snow)","worldRank":12,"actNumber":5},{"id":"naruto_winter_6","name":"Act 6","world":"","kind":"Events","group":"naruto__winter","groupName":"Sand Village (Snow)","worldRank":12,"actNumber":6},{"id":"jojo_portal_pucci","name":"The New Moon","world":"","kind":"Events","group":"space_center_gravity","groupName":"Space Center (New Moon)","worldRank":12,"actNumber":1},{"id":"aot_winter_1","name":"Act 1","world":"","kind":"Events","group":"aot__winter","groupName":"Walled City (Winter)","worldRank":12,"actNumber":1},{"id":"aot_winter_2","name":"Act 2","world":"","kind":"Events","group":"aot__winter","groupName":"Walled City (Winter)","worldRank":12,"actNumber":2},{"id":"aot_winter_3","name":"Act 3","world":"","kind":"Events","group":"aot__winter","groupName":"Walled City (Winter)","worldRank":12,"actNumber":3},{"id":"aot_winter_4","name":"Act 4","world":"","kind":"Events","group":"aot__winter","groupName":"Walled City (Winter)","worldRank":12,"actNumber":4},{"id":"aot_winter_5","name":"Act 5","world":"","kind":"Events","group":"aot__winter","groupName":"Walled City (Winter)","worldRank":12,"actNumber":5},{"id":"aot_winter_6","name":"Act 6","world":"","kind":"Events","group":"aot__winter","groupName":"Walled City (Winter)","worldRank":12,"actNumber":6},{"id":"opm_portal_g","name":"Alien Assault","world":"","kind":"Events","group":"boros_ship_portal","groupName":"Alien Spaceship (Final)","worldRank":13,"actNumber":1},{"id":"opm_portal","name":"Universal King","world":"","kind":"Events","group":"boros_ship_portal","groupName":"Alien Spaceship (Final)","worldRank":13,"actNumber":1},{"id":"7ds_portal","name":"The Demon Leader","world":"","kind":"Events","group":"7ds_map_cube","groupName":"Fabled Kingdom (Cube)","worldRank":14,"actNumber":1},{"id":"sakamoto_portal_nagumo","name":"The Master of Disguise","world":"","kind":"Events","group":"assassin_park","groupName":"Assassin Park","worldRank":16,"actNumber":1},{"id":"dressrosa_portal_final","name":"The Stringer","world":"","kind":"Events","group":"dressrosa_string","groupName":"Puppet Island (Threads)","worldRank":16,"actNumber":1},{"id":"dressrosa_portal","name":"The Threads","world":"","kind":"Events","group":"dressrosa_string","groupName":"Puppet Island (Threads)","worldRank":16,"actNumber":1},{"id":"bsd_portal_final","name":"Detective Mission","world":"","kind":"Events","group":"bsd","groupName":"Sky Aircraft","worldRank":16,"actNumber":1},{"id":"madoka2_portal","name":"Wish City (Night)","world":"","kind":"Events","group":"madoka","groupName":"Wish City","worldRank":16,"actNumber":1},{"id":"eclipse_portal_final","name":"Destiny","world":"","kind":"Events","group":"eclipse","groupName":"Otherwordly Plane","worldRank":18,"actNumber":1},{"id":"eclipse_portal","name":"Otherwordly Plane","world":"","kind":"Events","group":"eclipse","groupName":"Otherwordly Plane","worldRank":18,"actNumber":1},{"id":"april2_event","name":"Fool's Hunt","world":"","kind":"Events","group":"fate","groupName":"Mountain Temple","worldRank":20,"actNumber":1},{"id":"fate_portal","name":"Mountain Temple (War)","world":"","kind":"Events","group":"fate","groupName":"Mountain Temple","worldRank":20,"actNumber":1},{"id":"fate_portal_final","name":"The Ruler","world":"","kind":"Events","group":"fate","groupName":"Mountain Temple","worldRank":20,"actNumber":1},{"id":"halloween2_event","name":"Nightmare Hunt","world":"","kind":"Events","group":"namek_halloween","groupName":"Planet Greenie (Haunted)","worldRank":20,"actNumber":1},{"id":"christmas_event","name":"Holiday Hunt","world":"","kind":"Events","group":"christmas_map","groupName":"Frozen Abyss","worldRank":21,"actNumber":1},{"id":"christmas2_portal_final","name":"The Fallen Star","world":"","kind":"Events","group":"christmas_map","groupName":"Frozen Abyss","worldRank":21,"actNumber":1},{"id":"buddha_portal_level","name":"The Enlightened","world":"","kind":"Events","group":"christmas_map_buddha","groupName":"Frozen Abyss (Six Realms)","worldRank":21,"actNumber":1},{"id":"pain_portal","name":"The Savior","world":"","kind":"Events","group":"amegakure","groupName":"Rain Village","worldRank":21,"actNumber":1},{"id":"shibuya_portal","name":"Shibuya District (Portal)","world":"","kind":"Events","group":"shibuya","groupName":"Shibuya District","worldRank":22,"actNumber":1},{"id":"shibuya_portal_megumi2","name":"The Holy Warlord","world":"","kind":"Events","group":"shibuya","groupName":"Shibuya District","worldRank":22,"actNumber":1},{"id":"shibuya_portal_final","name":"The Mage Slayer","world":"","kind":"Events","group":"shibuya","groupName":"Shibuya District","worldRank":22,"actNumber":1},{"id":"namek_infinite","name":"Infinite Mode","world":"namek","kind":"Infinite","group":"namek","groupName":"Planet Greenie","worldRank":1,"actNumber":1},{"id":"aot_infinite","name":"Infinite Mode","world":"aot","kind":"Infinite","group":"aot","groupName":"Walled City","worldRank":2,"actNumber":1},{"id":"demonslayer_infinite","name":"Infinite Mode","world":"demonslayer","kind":"Infinite","group":"demonslayer","groupName":"Snowy Town","worldRank":3,"actNumber":1},{"id":"naruto_infinite","name":"Infinite Mode","world":"naruto","kind":"Infinite","group":"naruto","groupName":"Sand Village","worldRank":4,"actNumber":1},{"id":"marineford_infinite","name":"Infinite Mode","world":"marineford","kind":"Infinite","group":"marineford","groupName":"Navy Bay","worldRank":5,"actNumber":1},{"id":"tokyoghoul_infinite","name":"Infinite Mode","world":"tokyo_ghoul","kind":"Infinite","group":"tokyo_ghoul","groupName":"Fiend City","worldRank":6,"actNumber":1},{"id":"hueco_infinite","name":"Infinite Mode","world":"hueco","kind":"Infinite","group":"hueco","groupName":"Spirit World","worldRank":7,"actNumber":1},{"id":"hxhant_infinite","name":"Infinite Mode","world":"hxhant","kind":"Infinite","group":"hxhant","groupName":"Ant Kingdom","worldRank":8,"actNumber":1},{"id":"magnolia_infinite","name":"Infinite Mode","world":"magnolia","kind":"Infinite","group":"magnolia","groupName":"Magic Town","worldRank":9,"actNumber":1},{"id":"jjk_infinite","name":"Infinite Mode","world":"jjk","kind":"Infinite","group":"jjk","groupName":"Haunted Academy","worldRank":10,"actNumber":1},{"id":"clover_infinite","name":"Infinite Mode","world":"clover","kind":"Infinite","group":"clover","groupName":"Magic Hills","worldRank":11,"actNumber":1},{"id":"jojo_infinite","name":"Infinite Mode","world":"jojo","kind":"Infinite","group":"jojo","groupName":"Space Center","worldRank":12,"actNumber":1},{"id":"opm_infinite","name":"Infinite Mode","world":"opm","kind":"Infinite","group":"opm","groupName":"Alien Spaceship","worldRank":13,"actNumber":1},{"id":"7ds_infinite","name":"Infinite Mode","world":"7ds","kind":"Infinite","group":"7ds","groupName":"Fabled Kingdom","worldRank":14,"actNumber":1},{"id":"mha_infinite","name":"Infinite Mode","world":"mha","kind":"Infinite","group":"mha","groupName":"Ruined City","worldRank":15,"actNumber":1},{"id":"madoka_infinite","name":"Infinite Mode","world":"dressrosa","kind":"Infinite","group":"dressrosa","groupName":"Puppet Island","worldRank":16,"actNumber":1},{"id":"dressrosa_infinite","name":"Infinite Mode","world":"dressrosa","kind":"Infinite","group":"dressrosa","groupName":"Puppet Island","worldRank":16,"actNumber":1},{"id":"sao_infinite","name":"Infinite Mode","world":"sao","kind":"Infinite","group":"sao","groupName":"Virtual Dungeon","worldRank":17,"actNumber":1},{"id":"berserk_infinite","name":"Infinite Mode","world":"berserk","kind":"Infinite","group":"berserk","groupName":"Snowy Kingdom","worldRank":18,"actNumber":1},{"id":"overlord_infinite","name":"Infinite Mode","world":"overlord","kind":"Infinite","group":"overlord","groupName":"Dungeon Throne","worldRank":19,"actNumber":1},{"id":"fate_infinite","name":"Infinite Mode","world":"fate","kind":"Infinite","group":"fate","groupName":"Mountain Temple","worldRank":20,"actNumber":1},{"id":"amegakure_infinite","name":"Infinite Mode","world":"amegakure","kind":"Infinite","group":"amegakure","groupName":"Rain Village","worldRank":21,"actNumber":1},{"id":"shibuya_infinite","name":"Infinite Mode","world":"shibuya","kind":"Infinite","group":"shibuya","groupName":"Shibuya District","worldRank":22,"actNumber":1},{"id":"clover_legend_1","name":"Legend Stage 1","world":"clover_legend","kind":"LegendaryStages","group":"clover_legend","groupName":"Magic Hills (Elf Invasion)","worldRank":11,"actNumber":1},{"id":"clover_legend_2","name":"Legend Stage 2","world":"clover_legend","kind":"LegendaryStages","group":"clover_legend","groupName":"Magic Hills (Elf Invasion)","worldRank":11,"actNumber":2},{"id":"clover_legend_3","name":"Legend Stage 3","world":"clover_legend","kind":"LegendaryStages","group":"clover_legend","groupName":"Magic Hills (Elf Invasion)","worldRank":11,"actNumber":3},{"id":"bleach_legend_1","name":"Legend Stage 1","world":"bleach_legend","kind":"LegendaryStages","group":"bleach_legend","groupName":"Spirit Invasion","worldRank":11,"actNumber":1},{"id":"bleach_legend_2","name":"Legend Stage 2","world":"bleach_legend","kind":"LegendaryStages","group":"bleach_legend","groupName":"Spirit Invasion","worldRank":11,"actNumber":2},{"id":"bleach_legend_3","name":"Legend Stage 3","world":"bleach_legend","kind":"LegendaryStages","group":"bleach_legend","groupName":"Spirit Invasion","worldRank":11,"actNumber":3},{"id":"bleach_legend_4","name":"Legend Stage 4","world":"bleach_legend","kind":"LegendaryStages","group":"bleach_legend","groupName":"Spirit Invasion","worldRank":11,"actNumber":4},{"id":"bleach_legend_5","name":"Legend Stage 5","world":"bleach_legend","kind":"LegendaryStages","group":"bleach_legend","groupName":"Spirit Invasion","worldRank":11,"actNumber":5},{"id":"bleach_legend_6","name":"Legend Stage 6","world":"bleach_legend","kind":"LegendaryStages","group":"bleach_legend","groupName":"Spirit Invasion","worldRank":11,"actNumber":6},{"id":"jojo_legend_1","name":"Legend Stage 1","world":"jojo_legend","kind":"LegendaryStages","group":"jojo_legend","groupName":"Space Center","worldRank":12,"actNumber":1},{"id":"jojo_legend_2","name":"Legend Stage 2","world":"jojo_legend","kind":"LegendaryStages","group":"jojo_legend","groupName":"Space Center","worldRank":12,"actNumber":2},{"id":"jojo_legend_3","name":"Legend Stage 3","world":"jojo_legend","kind":"LegendaryStages","group":"jojo_legend","groupName":"Space Center","worldRank":12,"actNumber":3},{"id":"7ds_legend_1","name":"Legend Stage 1","world":"7ds_legend","kind":"LegendaryStages","group":"7ds_legend","groupName":"Fabled Kingdom (Generals)","worldRank":14,"actNumber":1},{"id":"7ds_legend_2","name":"Legend Stage 2","world":"7ds_legend","kind":"LegendaryStages","group":"7ds_legend","groupName":"Fabled Kingdom (Generals)","worldRank":14,"actNumber":2},{"id":"7ds_legend_3","name":"Legend Stage 3","world":"7ds_legend","kind":"LegendaryStages","group":"7ds_legend","groupName":"Fabled Kingdom (Generals)","worldRank":14,"actNumber":3},{"id":"mha_legend_1","name":"Legend Stage 1","world":"mha_legend","kind":"LegendaryStages","group":"mha_legend","groupName":"Ruined City (Midnight)","worldRank":15,"actNumber":1},{"id":"mha_legend_2","name":"Legend Stage 2","world":"mha_legend","kind":"LegendaryStages","group":"mha_legend","groupName":"Ruined City (Midnight)","worldRank":15,"actNumber":2},{"id":"mha_legend_3","name":"Legend Stage 3","world":"mha_legend","kind":"LegendaryStages","group":"mha_legend","groupName":"Ruined City (Midnight)","worldRank":15,"actNumber":3},{"id":"mha_legend_4","name":"Legend Stage 4","world":"mha_legend","kind":"LegendaryStages","group":"mha_legend","groupName":"Ruined City (Midnight)","worldRank":15,"actNumber":4},{"id":"mha_legend_5","name":"Legend Stage 5","world":"mha_legend","kind":"LegendaryStages","group":"mha_legend","groupName":"Ruined City (Midnight)","worldRank":15,"actNumber":5},{"id":"mha_legend_6","name":"Legend Stage 6","world":"mha_legend","kind":"LegendaryStages","group":"mha_legend","groupName":"Ruined City (Midnight)","worldRank":15,"actNumber":6},{"id":"sao_legend_1","name":"Legend Stage 1","world":"sao_legend","kind":"LegendaryStages","group":"sao_legend","groupName":"Virtual Dungeon (Bosses)","worldRank":17,"actNumber":1},{"id":"sao_legend_2","name":"Legend Stage 2","world":"sao_legend","kind":"LegendaryStages","group":"sao_legend","groupName":"Virtual Dungeon (Bosses)","worldRank":17,"actNumber":2},{"id":"sao_legend_3","name":"Legend Stage 3","world":"sao_legend","kind":"LegendaryStages","group":"sao_legend","groupName":"Virtual Dungeon (Bosses)","worldRank":17,"actNumber":3},{"id":"overlord_legend_1","name":"Legend Stage 1","world":"overlord_legend","kind":"LegendaryStages","group":"overlord_legend","groupName":"Dungeon Throne","worldRank":19,"actNumber":1},{"id":"overlord_legend_2","name":"Legend Stage 2","world":"overlord_legend","kind":"LegendaryStages","group":"overlord_legend","groupName":"Dungeon Throne","worldRank":19,"actNumber":2},{"id":"overlord_legend_3","name":"Legend Stage 3","world":"overlord_legend","kind":"LegendaryStages","group":"overlord_legend","groupName":"Dungeon Throne","worldRank":19,"actNumber":3},{"id":"amegakure_legend_1","name":"Legend Stage 1","world":"amegakure_legend","kind":"LegendaryStages","group":"amegakure_legend","groupName":"Rain Village","worldRank":21,"actNumber":1},{"id":"amegakure_legend_2","name":"Legend Stage 2","world":"amegakure_legend","kind":"LegendaryStages","group":"amegakure_legend","groupName":"Rain Village","worldRank":21,"actNumber":2},{"id":"amegakure_legend_3","name":"Legend Stage 3","world":"amegakure_legend","kind":"LegendaryStages","group":"amegakure_legend","groupName":"Rain Village","worldRank":21,"actNumber":3},{"id":"tournament_raid_1","name":"Universal Tournament","world":"","kind":"Raids","group":"tournament_of_power","groupName":"Power Contest","worldRank":4,"actNumber":1},{"id":"naruto_raid_1","name":"Raid: Midnight Attack","world":"naruto_raid_1","kind":"Raids","group":"naruto_raid","groupName":"Sand Village","worldRank":5,"actNumber":1},{"id":"aot_raid_1","name":"Raid: Extinction","world":"aot_raid_1","kind":"Raids","group":"aot_raid","groupName":"Walled City","worldRank":5,"actNumber":1},{"id":"demonslayer_raid_1","name":"Raid: Demonic Invasion","world":"demonslayer_raid_1","kind":"Raids","group":"demonslayer_raid","groupName":"Nightmare Train","worldRank":6,"actNumber":1},{"id":"west_city_raid","name":"Raid: Cyborg Attack","world":"west_city","kind":"Raids","group":"west_city","groupName":"Future City","worldRank":9,"actNumber":1},{"id":"fairytail_raid","name":"Heavenly Invasion","world":"","kind":"Raids","group":"magnolia_night","groupName":"Magic Town","worldRank":9,"actNumber":1},{"id":"jjk_finger","name":"Cursed Womb","world":"","kind":"Raids","group":"jjk_finger","groupName":"Haunted Academy","worldRank":10,"actNumber":1},{"id":"jjk_raid","name":"Haunted Procession","world":"","kind":"Raids","group":"jjk_movie","groupName":"Haunted Academy","worldRank":10,"actNumber":1},{"id":"bleach_yamamoto_raid","name":"The Fire","world":"","kind":"Raids","group":"karakura3","groupName":"Spirit Town","worldRank":10,"actNumber":1},{"id":"uchiha_level_1","name":"Raid: Act 1","world":"uchiha","kind":"Raids","group":"uchiha_hideout","groupName":"Storm Hideout","worldRank":13,"actNumber":1},{"id":"uchiha_level_2","name":"Raid: Act 2","world":"uchiha","kind":"Raids","group":"uchiha_hideout","groupName":"Storm Hideout","worldRank":13,"actNumber":2},{"id":"uchiha_level_3","name":"Raid: Act 3","world":"uchiha","kind":"Raids","group":"uchiha_hideout","groupName":"Storm Hideout","worldRank":13,"actNumber":3},{"id":"uchiha_level_4","name":"Raid: Act 4","world":"uchiha","kind":"Raids","group":"uchiha_hideout","groupName":"Storm Hideout","worldRank":13,"actNumber":4},{"id":"uchiha_level_5","name":"Raid: Act 5","world":"uchiha","kind":"Raids","group":"uchiha_hideout_final","groupName":"Storm Hideout","worldRank":13,"actNumber":5},{"id":"west_city_frieza_level_1","name":"Raid: The Elite Bodyguard","world":"west_city_frieza","kind":"Raids","group":"west_city_frieza","groupName":"Future City (Tyrant's Invasion)","worldRank":14,"actNumber":1},{"id":"west_city_frieza_level_2","name":"Raid: The Commander","world":"west_city_frieza","kind":"Raids","group":"west_city_frieza","groupName":"Future City (Tyrant's Invasion)","worldRank":14,"actNumber":2},{"id":"west_city_frieza_level_3","name":"Raid: The Return","world":"west_city_frieza","kind":"Raids","group":"west_city_frieza","groupName":"Future City (Tyrant's Invasion)","worldRank":14,"actNumber":3},{"id":"west_city_frieza_level_4","name":"Raid: The Resurrected Leader","world":"west_city_frieza","kind":"Raids","group":"west_city_frieza","groupName":"Future City (Tyrant's Invasion)","worldRank":14,"actNumber":4},{"id":"west_city_frieza_level_5","name":"Raid: The Ultimate Emperor","world":"west_city_frieza","kind":"Raids","group":"west_city_frieza","groupName":"Future City (Tyrant's Invasion)","worldRank":14,"actNumber":5},{"id":"entertainment_district_level_1","name":"Raid: The Temple Demon","world":"entertainment_district","kind":"Raids","group":"entertainment_district","groupName":"Cursed Festival","worldRank":15,"actNumber":1},{"id":"entertainment_district_level_2","name":"Raid: The Spider Demon Leader","world":"entertainment_district","kind":"Raids","group":"entertainment_district","groupName":"Cursed Festival","worldRank":15,"actNumber":2},{"id":"entertainment_district_level_3","name":"Raid: The Fallen Princess","world":"entertainment_district","kind":"Raids","group":"entertainment_district","groupName":"Cursed Festival","worldRank":15,"actNumber":3},{"id":"entertainment_district_level_4","name":"Raid: The High Rank","world":"entertainment_district","kind":"Raids","group":"entertainment_district","groupName":"Cursed Festival","worldRank":15,"actNumber":4},{"id":"entertainment_district_level_5","name":"Raid: The Demon Pair","world":"entertainment_district","kind":"Raids","group":"entertainment_district","groupName":"Cursed Festival","worldRank":15,"actNumber":5},{"id":"mha_stain","name":"Raid: The Menace","world":"mha_stain","kind":"Raids","group":"mha_city_night","groupName":"Ruined City (The Menace)","worldRank":17,"actNumber":1},{"id":"marineford_sengoku","name":"Raid: The Buddha","world":"marineford_sengoku","kind":"Raids","group":"marineford","groupName":"Navy's Ford (Buddha)","worldRank":18,"actNumber":1},{"id":"morioh_level_1","name":"Raid: Act 1","world":"morioh","kind":"Raids","group":"morioh","groupName":"Strange Town","worldRank":19,"actNumber":1},{"id":"morioh_level_2","name":"Raid: Act 2","world":"morioh","kind":"Raids","group":"morioh","groupName":"Strange Town","worldRank":19,"actNumber":2},{"id":"morioh_level_3","name":"Raid: Act 3","world":"morioh","kind":"Raids","group":"morioh","groupName":"Strange Town","worldRank":19,"actNumber":3},{"id":"morioh_level_4","name":"Raid: Act 4","world":"morioh","kind":"Raids","group":"morioh","groupName":"Strange Town","worldRank":19,"actNumber":4},{"id":"morioh_level_5","name":"Raid: Act 5","world":"morioh","kind":"Raids","group":"morioh","groupName":"Strange Town","worldRank":19,"actNumber":5},{"id":"hxh_feitan","name":"Raid: The Spider","world":"hxh_feitan","kind":"Raids","group":"hxhant_night","groupName":"Ant Kingdom (Midnight)","worldRank":21,"actNumber":1},{"id":"kai_planet_level_1","name":"Raid: The Guardian","world":"kai_planet","kind":"Raids","group":"kai_planet","groupName":"Sacred Planet","worldRank":21,"actNumber":1},{"id":"kai_planet_level_2","name":"Raid: The Evil King","world":"kai_planet","kind":"Raids","group":"kai_planet","groupName":"Sacred Planet","worldRank":21,"actNumber":2},{"id":"kai_planet_level_3","name":"Raid: The Evil Mage","world":"kai_planet","kind":"Raids","group":"kai_planet","groupName":"Sacred Planet","worldRank":21,"actNumber":3},{"id":"kai_planet_level_4","name":"Raid: The Genie","world":"kai_planet","kind":"Raids","group":"kai_planet","groupName":"Sacred Planet","worldRank":21,"actNumber":4},{"id":"kai_planet_level_5","name":"Raid: The Pure Form","world":"kai_planet","kind":"Raids","group":"kai_planet","groupName":"Sacred Planet","worldRank":21,"actNumber":5},{"id":"namek_level_1","name":"Act 1","world":"namek","kind":"Story","group":"namek","groupName":"Planet Greenie","worldRank":1,"actNumber":1},{"id":"namek_level_2","name":"Act 2","world":"namek","kind":"Story","group":"namek","groupName":"Planet Greenie","worldRank":1,"actNumber":2},{"id":"namek_level_3","name":"Act 3","world":"namek","kind":"Story","group":"namek","groupName":"Planet Greenie","worldRank":1,"actNumber":3},{"id":"namek_level_4","name":"Act 4","world":"namek","kind":"Story","group":"namek","groupName":"Planet Greenie","worldRank":1,"actNumber":4},{"id":"namek_level_5","name":"Act 5","world":"namek","kind":"Story","group":"namek","groupName":"Planet Greenie","worldRank":1,"actNumber":5},{"id":"namek_level_6","name":"Act 6","world":"namek","kind":"Story","group":"namek","groupName":"Planet Greenie","worldRank":1,"actNumber":6},{"id":"aot_level_1","name":"Act 1","world":"aot","kind":"Story","group":"aot","groupName":"Walled City","worldRank":2,"actNumber":1},{"id":"aot_level_2","name":"Act 2","world":"aot","kind":"Story","group":"aot","groupName":"Walled City","worldRank":2,"actNumber":2},{"id":"aot_level_3","name":"Act 3","world":"aot","kind":"Story","group":"aot","groupName":"Walled City","worldRank":2,"actNumber":3},{"id":"aot_level_4","name":"Act 4","world":"aot","kind":"Story","group":"aot","groupName":"Walled City","worldRank":2,"actNumber":4},{"id":"aot_level_5","name":"Act 5","world":"aot","kind":"Story","group":"aot","groupName":"Walled City","worldRank":2,"actNumber":5},{"id":"aot_level_6","name":"Act 6","world":"aot","kind":"Story","group":"aot","groupName":"Walled City","worldRank":2,"actNumber":6},{"id":"demonslayer_level_1","name":"Act 1","world":"demonslayer","kind":"Story","group":"demonslayer","groupName":"Snowy Town","worldRank":3,"actNumber":1},{"id":"demonslayer_level_2","name":"Act 2","world":"demonslayer","kind":"Story","group":"demonslayer","groupName":"Snowy Town","worldRank":3,"actNumber":2},{"id":"demonslayer_level_3","name":"Act 3","world":"demonslayer","kind":"Story","group":"demonslayer","groupName":"Snowy Town","worldRank":3,"actNumber":3},{"id":"demonslayer_level_4","name":"Act 4","world":"demonslayer","kind":"Story","group":"demonslayer","groupName":"Snowy Town","worldRank":3,"actNumber":4},{"id":"demonslayer_level_5","name":"Act 5","world":"demonslayer","kind":"Story","group":"demonslayer","groupName":"Snowy Town","worldRank":3,"actNumber":5},{"id":"demonslayer_level_6","name":"Act 6","world":"demonslayer","kind":"Story","group":"demonslayer","groupName":"Snowy Town","worldRank":3,"actNumber":6},{"id":"naruto_level_1","name":"Act 1","world":"naruto","kind":"Story","group":"naruto","groupName":"Sand Village","worldRank":4,"actNumber":1},{"id":"naruto_level_2","name":"Act 2","world":"naruto","kind":"Story","group":"naruto","groupName":"Sand Village","worldRank":4,"actNumber":2},{"id":"naruto_level_3","name":"Act 3","world":"naruto","kind":"Story","group":"naruto","groupName":"Sand Village","worldRank":4,"actNumber":3},{"id":"naruto_level_4","name":"Act 4","world":"naruto","kind":"Story","group":"naruto","groupName":"Sand Village","worldRank":4,"actNumber":4},{"id":"naruto_level_5","name":"Act 5","world":"naruto","kind":"Story","group":"naruto","groupName":"Sand Village","worldRank":4,"actNumber":5},{"id":"naruto_level_6","name":"Act 6","world":"naruto","kind":"Story","group":"naruto","groupName":"Sand Village","worldRank":4,"actNumber":6},{"id":"marineford_level_1","name":"Act 1","world":"marineford","kind":"Story","group":"marineford","groupName":"Navy Bay","worldRank":5,"actNumber":1},{"id":"marineford_level_2","name":"Act 2","world":"marineford","kind":"Story","group":"marineford","groupName":"Navy Bay","worldRank":5,"actNumber":2},{"id":"marineford_level_3","name":"Act 3","world":"marineford","kind":"Story","group":"marineford","groupName":"Navy Bay","worldRank":5,"actNumber":3},{"id":"marineford_level_4","name":"Act 4","world":"marineford","kind":"Story","group":"marineford","groupName":"Navy Bay","worldRank":5,"actNumber":4},{"id":"marineford_level_5","name":"Act 5","world":"marineford","kind":"Story","group":"marineford","groupName":"Navy Bay","worldRank":5,"actNumber":5},{"id":"marineford_level_6","name":"Act 6","world":"marineford","kind":"Story","group":"marineford","groupName":"Navy Bay","worldRank":5,"actNumber":6},{"id":"tokyoghoul_level_1","name":"Act 1","world":"tokyo_ghoul","kind":"Story","group":"tokyo_ghoul","groupName":"Fiend City","worldRank":6,"actNumber":1},{"id":"tokyoghoul_level_2","name":"Act 2","world":"tokyo_ghoul","kind":"Story","group":"tokyo_ghoul","groupName":"Fiend City","worldRank":6,"actNumber":2},{"id":"tokyoghoul_level_3","name":"Act 3","world":"tokyo_ghoul","kind":"Story","group":"tokyo_ghoul","groupName":"Fiend City","worldRank":6,"actNumber":3},{"id":"tokyoghoul_level_4","name":"Act 4","world":"tokyo_ghoul","kind":"Story","group":"tokyo_ghoul","groupName":"Fiend City","worldRank":6,"actNumber":4},{"id":"tokyoghoul_level_5","name":"Act 5","world":"tokyo_ghoul","kind":"Story","group":"tokyo_ghoul","groupName":"Fiend City","worldRank":6,"actNumber":5},{"id":"tokyoghoul_level_6","name":"Act 6","world":"tokyo_ghoul","kind":"Story","group":"tokyo_ghoul","groupName":"Fiend City","worldRank":6,"actNumber":6},{"id":"hueco_level_1","name":"Act 1","world":"hueco","kind":"Story","group":"hueco","groupName":"Spirit World","worldRank":7,"actNumber":1},{"id":"hueco_level_2","name":"Act 2","world":"hueco","kind":"Story","group":"hueco","groupName":"Spirit World","worldRank":7,"actNumber":2},{"id":"hueco_level_3","name":"Act 3","world":"hueco","kind":"Story","group":"hueco","groupName":"Spirit World","worldRank":7,"actNumber":3},{"id":"hueco_level_4","name":"Act 4","world":"hueco","kind":"Story","group":"hueco","groupName":"Spirit World","worldRank":7,"actNumber":4},{"id":"hueco_level_5","name":"Act 5","world":"hueco","kind":"Story","group":"hueco","groupName":"Spirit World","worldRank":7,"actNumber":5},{"id":"hueco_level_6","name":"Act 6","world":"hueco","kind":"Story","group":"hueco","groupName":"Spirit World","worldRank":7,"actNumber":6},{"id":"hxhant_level_1","name":"Act 1","world":"hxhant","kind":"Story","group":"hxhant","groupName":"Ant Kingdom","worldRank":8,"actNumber":1},{"id":"hxhant_level_2","name":"Act 2","world":"hxhant","kind":"Story","group":"hxhant","groupName":"Ant Kingdom","worldRank":8,"actNumber":2},{"id":"hxhant_level_3","name":"Act 3","world":"hxhant","kind":"Story","group":"hxhant","groupName":"Ant Kingdom","worldRank":8,"actNumber":3},{"id":"hxhant_level_4","name":"Act 4","world":"hxhant","kind":"Story","group":"hxhant","groupName":"Ant Kingdom","worldRank":8,"actNumber":4},{"id":"hxhant_level_5","name":"Act 5","world":"hxhant","kind":"Story","group":"hxhant","groupName":"Ant Kingdom","worldRank":8,"actNumber":5},{"id":"hxhant_level_6","name":"Act 6","world":"hxhant","kind":"Story","group":"hxhant","groupName":"Ant Kingdom","worldRank":8,"actNumber":6},{"id":"magnolia_level_1","name":"Act 1","world":"magnolia","kind":"Story","group":"magnolia","groupName":"Magic Town","worldRank":9,"actNumber":1},{"id":"magnolia_level_2","name":"Act 2","world":"magnolia","kind":"Story","group":"magnolia","groupName":"Magic Town","worldRank":9,"actNumber":2},{"id":"magnolia_level_3","name":"Act 3","world":"magnolia","kind":"Story","group":"magnolia","groupName":"Magic Town","worldRank":9,"actNumber":3},{"id":"magnolia_level_4","name":"Act 4","world":"magnolia","kind":"Story","group":"magnolia","groupName":"Magic Town","worldRank":9,"actNumber":4},{"id":"magnolia_level_5","name":"Act 5","world":"magnolia","kind":"Story","group":"magnolia","groupName":"Magic Town","worldRank":9,"actNumber":5},{"id":"magnolia_level_6","name":"Act 6","world":"magnolia","kind":"Story","group":"magnolia","groupName":"Magic Town","worldRank":9,"actNumber":6},{"id":"jjk_level_1","name":"Act 1","world":"jjk","kind":"Story","group":"jjk","groupName":"Haunted Academy","worldRank":10,"actNumber":1},{"id":"jjk_level_2","name":"Act 2","world":"jjk","kind":"Story","group":"jjk","groupName":"Haunted Academy","worldRank":10,"actNumber":2},{"id":"jjk_level_3","name":"Act 3","world":"jjk","kind":"Story","group":"jjk","groupName":"Haunted Academy","worldRank":10,"actNumber":3},{"id":"jjk_level_4","name":"Act 4","world":"jjk","kind":"Story","group":"jjk","groupName":"Haunted Academy","worldRank":10,"actNumber":4},{"id":"jjk_level_5","name":"Act 5","world":"jjk","kind":"Story","group":"jjk","groupName":"Haunted Academy","worldRank":10,"actNumber":5},{"id":"jjk_level_6","name":"Act 6","world":"jjk","kind":"Story","group":"jjk","groupName":"Haunted Academy","worldRank":10,"actNumber":6},{"id":"clover_level_1","name":"Act 1","world":"clover","kind":"Story","group":"clover","groupName":"Magic Hills","worldRank":11,"actNumber":1},{"id":"clover_level_2","name":"Act 2","world":"clover","kind":"Story","group":"clover","groupName":"Magic Hills","worldRank":11,"actNumber":2},{"id":"clover_level_3","name":"Act 3","world":"clover","kind":"Story","group":"clover","groupName":"Magic Hills","worldRank":11,"actNumber":3},{"id":"clover_level_4","name":"Act 4","world":"clover","kind":"Story","group":"clover","groupName":"Magic Hills","worldRank":11,"actNumber":4},{"id":"clover_level_5","name":"Act 5","world":"clover","kind":"Story","group":"clover","groupName":"Magic Hills","worldRank":11,"actNumber":5},{"id":"clover_level_6","name":"Act 6","world":"clover","kind":"Story","group":"clover","groupName":"Magic Hills","worldRank":11,"actNumber":6},{"id":"jojo_level_1","name":"Act 1","world":"jojo","kind":"Story","group":"jojo","groupName":"Space Center","worldRank":12,"actNumber":1},{"id":"jojo_level_2","name":"Act 2","world":"jojo","kind":"Story","group":"jojo","groupName":"Space Center","worldRank":12,"actNumber":2},{"id":"jojo_level_3","name":"Act 3","world":"jojo","kind":"Story","group":"jojo","groupName":"Space Center","worldRank":12,"actNumber":3},{"id":"jojo_level_4","name":"Act 4","world":"jojo","kind":"Story","group":"jojo","groupName":"Space Center","worldRank":12,"actNumber":4},{"id":"jojo_level_5","name":"Act 5","world":"jojo","kind":"Story","group":"jojo","groupName":"Space Center","worldRank":12,"actNumber":5},{"id":"jojo_level_6","name":"Act 6","world":"jojo","kind":"Story","group":"jojo","groupName":"Space Center","worldRank":12,"actNumber":6},{"id":"opm_level_1","name":"Act 1","world":"opm","kind":"Story","group":"opm","groupName":"Alien Spaceship","worldRank":13,"actNumber":1},{"id":"opm_level_2","name":"Act 2","world":"opm","kind":"Story","group":"opm","groupName":"Alien Spaceship","worldRank":13,"actNumber":2},{"id":"opm_level_3","name":"Act 3","world":"opm","kind":"Story","group":"opm","groupName":"Alien Spaceship","worldRank":13,"actNumber":3},{"id":"opm_level_4","name":"Act 4","world":"opm","kind":"Story","group":"opm","groupName":"Alien Spaceship","worldRank":13,"actNumber":4},{"id":"opm_level_5","name":"Act 5","world":"opm","kind":"Story","group":"opm","groupName":"Alien Spaceship","worldRank":13,"actNumber":5},{"id":"opm_level_6","name":"Act 6","world":"opm","kind":"Story","group":"opm","groupName":"Alien Spaceship","worldRank":13,"actNumber":6},{"id":"7ds_level_1","name":"Act 1","world":"7ds","kind":"Story","group":"7ds","groupName":"Fabled Kingdom","worldRank":14,"actNumber":1},{"id":"7ds_level_2","name":"Act 2","world":"7ds","kind":"Story","group":"7ds","groupName":"Fabled Kingdom","worldRank":14,"actNumber":2},{"id":"7ds_level_3","name":"Act 3","world":"7ds","kind":"Story","group":"7ds","groupName":"Fabled Kingdom","worldRank":14,"actNumber":3},{"id":"7ds_level_4","name":"Act 4","world":"7ds","kind":"Story","group":"7ds","groupName":"Fabled Kingdom","worldRank":14,"actNumber":4},{"id":"7ds_level_5","name":"Act 5","world":"7ds","kind":"Story","group":"7ds","groupName":"Fabled Kingdom","worldRank":14,"actNumber":5},{"id":"7ds_level_6","name":"Act 6","world":"7ds","kind":"Story","group":"7ds","groupName":"Fabled Kingdom","worldRank":14,"actNumber":6},{"id":"mha_level_1","name":"Act 1","world":"mha","kind":"Story","group":"mha","groupName":"Ruined City","worldRank":15,"actNumber":1},{"id":"mha_level_2","name":"Act 2","world":"mha","kind":"Story","group":"mha","groupName":"Ruined City","worldRank":15,"actNumber":2},{"id":"mha_level_3","name":"Act 3","world":"mha","kind":"Story","group":"mha","groupName":"Ruined City","worldRank":15,"actNumber":3},{"id":"mha_level_4","name":"Act 4","world":"mha","kind":"Story","group":"mha","groupName":"Ruined City","worldRank":15,"actNumber":4},{"id":"mha_level_5","name":"Act 5","world":"mha","kind":"Story","group":"mha","groupName":"Ruined City","worldRank":15,"actNumber":5},{"id":"mha_level_6","name":"Act 6","world":"mha","kind":"Story","group":"mha","groupName":"Ruined City","worldRank":15,"actNumber":6},{"id":"dressrosa_level_1","name":"Act 1","world":"dressrosa","kind":"Story","group":"dressrosa","groupName":"Puppet Island","worldRank":16,"actNumber":1},{"id":"dressrosa_level_2","name":"Act 2","world":"dressrosa","kind":"Story","group":"dressrosa","groupName":"Puppet Island","worldRank":16,"actNumber":2},{"id":"dressrosa_level_3","name":"Act 3","world":"dressrosa","kind":"Story","group":"dressrosa","groupName":"Puppet Island","worldRank":16,"actNumber":3},{"id":"dressrosa_level_4","name":"Act 4","world":"dressrosa","kind":"Story","group":"dressrosa","groupName":"Puppet Island","worldRank":16,"actNumber":4},{"id":"dressrosa_level_5","name":"Act 5","world":"dressrosa","kind":"Story","group":"dressrosa","groupName":"Puppet Island","worldRank":16,"actNumber":5},{"id":"dressrosa_level_6","name":"Act 6","world":"dressrosa","kind":"Story","group":"dressrosa","groupName":"Puppet Island","worldRank":16,"actNumber":6},{"id":"sao_level_1","name":"Act 1","world":"sao","kind":"Story","group":"sao","groupName":"Virtual Dungeon","worldRank":17,"actNumber":1},{"id":"sao_level_2","name":"Act 2","world":"sao","kind":"Story","group":"sao","groupName":"Virtual Dungeon","worldRank":17,"actNumber":2},{"id":"sao_level_3","name":"Act 3","world":"sao","kind":"Story","group":"sao","groupName":"Virtual Dungeon","worldRank":17,"actNumber":3},{"id":"sao_level_4","name":"Act 4","world":"sao","kind":"Story","group":"sao","groupName":"Virtual Dungeon","worldRank":17,"actNumber":4},{"id":"sao_level_5","name":"Act 5","world":"sao","kind":"Story","group":"sao","groupName":"Virtual Dungeon","worldRank":17,"actNumber":5},{"id":"sao_level_6","name":"Act 6","world":"sao","kind":"Story","group":"sao","groupName":"Virtual Dungeon","worldRank":17,"actNumber":6},{"id":"berserk_level_1","name":"Act 1","world":"berserk","kind":"Story","group":"berserk","groupName":"Snowy Kingdom","worldRank":18,"actNumber":1},{"id":"berserk_level_2","name":"Act 2","world":"berserk","kind":"Story","group":"berserk","groupName":"Snowy Kingdom","worldRank":18,"actNumber":2},{"id":"berserk_level_3","name":"Act 3","world":"berserk","kind":"Story","group":"berserk","groupName":"Snowy Kingdom","worldRank":18,"actNumber":3},{"id":"berserk_level_4","name":"Act 4","world":"berserk","kind":"Story","group":"berserk","groupName":"Snowy Kingdom","worldRank":18,"actNumber":4},{"id":"berserk_level_5","name":"Act 5","world":"berserk","kind":"Story","group":"berserk","groupName":"Snowy Kingdom","worldRank":18,"actNumber":5},{"id":"berserk_level_6","name":"Act 6","world":"berserk","kind":"Story","group":"berserk","groupName":"Snowy Kingdom","worldRank":18,"actNumber":6},{"id":"overlord_level_1","name":"Act 1","world":"overlord","kind":"Story","group":"overlord","groupName":"Dungeon Throne","worldRank":19,"actNumber":1},{"id":"overlord_level_2","name":"Act 2","world":"overlord","kind":"Story","group":"overlord","groupName":"Dungeon Throne","worldRank":19,"actNumber":2},{"id":"overlord_level_3","name":"Act 3","world":"overlord","kind":"Story","group":"overlord","groupName":"Dungeon Throne","worldRank":19,"actNumber":3},{"id":"overlord_level_4","name":"Act 4","world":"overlord","kind":"Story","group":"overlord","groupName":"Dungeon Throne","worldRank":19,"actNumber":4},{"id":"overlord_level_5","name":"Act 5","world":"overlord","kind":"Story","group":"overlord","groupName":"Dungeon Throne","worldRank":19,"actNumber":5},{"id":"overlord_level_6","name":"Act 6","world":"overlord","kind":"Story","group":"overlord","groupName":"Dungeon Throne","worldRank":19,"actNumber":6},{"id":"fate_level_1","name":"Act 1","world":"fate","kind":"Story","group":"fate","groupName":"Mountain Temple","worldRank":20,"actNumber":1},{"id":"fate_level_2","name":"Act 2","world":"fate","kind":"Story","group":"fate","groupName":"Mountain Temple","worldRank":20,"actNumber":2},{"id":"fate_level_3","name":"Act 3","world":"fate","kind":"Story","group":"fate","groupName":"Mountain Temple","worldRank":20,"actNumber":3},{"id":"fate_level_4","name":"Act 4","world":"fate","kind":"Story","group":"fate","groupName":"Mountain Temple","worldRank":20,"actNumber":4},{"id":"fate_level_5","name":"Act 5","world":"fate","kind":"Story","group":"fate","groupName":"Mountain Temple","worldRank":20,"actNumber":5},{"id":"fate_level_6","name":"Act 6","world":"fate","kind":"Story","group":"fate","groupName":"Mountain Temple","worldRank":20,"actNumber":6},{"id":"amegakure_level_1","name":"Act 1","world":"amegakure","kind":"Story","group":"amegakure","groupName":"Rain Village","worldRank":21,"actNumber":1},{"id":"amegakure_level_2","name":"Act 2","world":"amegakure","kind":"Story","group":"amegakure","groupName":"Rain Village","worldRank":21,"actNumber":2},{"id":"amegakure_level_3","name":"Act 3","world":"amegakure","kind":"Story","group":"amegakure","groupName":"Rain Village","worldRank":21,"actNumber":3},{"id":"amegakure_level_4","name":"Act 4","world":"amegakure","kind":"Story","group":"amegakure","groupName":"Rain Village","worldRank":21,"actNumber":4},{"id":"amegakure_level_5","name":"Act 5","world":"amegakure","kind":"Story","group":"amegakure","groupName":"Rain Village","worldRank":21,"actNumber":5},{"id":"amegakure_level_6","name":"Act 6","world":"amegakure","kind":"Story","group":"amegakure","groupName":"Rain Village","worldRank":21,"actNumber":6},{"id":"shibuya_level_1","name":"Act 1","world":"shibuya","kind":"Story","group":"shibuya","groupName":"Shibuya District","worldRank":22,"actNumber":1},{"id":"shibuya_level_2","name":"Act 2","world":"shibuya","kind":"Story","group":"shibuya","groupName":"Shibuya District","worldRank":22,"actNumber":2},{"id":"shibuya_level_3","name":"Act 3","world":"shibuya","kind":"Story","group":"shibuya","groupName":"Shibuya District","worldRank":22,"actNumber":3},{"id":"shibuya_level_4","name":"Act 4","world":"shibuya","kind":"Story","group":"shibuya","groupName":"Shibuya District","worldRank":22,"actNumber":4},{"id":"shibuya_level_5","name":"Act 5","world":"shibuya","kind":"Story","group":"shibuya","groupName":"Shibuya District","worldRank":22,"actNumber":5},{"id":"shibuya_level_6","name":"Act 6","world":"shibuya","kind":"Story","group":"shibuya","groupName":"Shibuya District","worldRank":22,"actNumber":6}]]==])
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local env = getgenv and getgenv() or shared

if env.CometAA and env.CometAA.unload then pcall(env.CometAA.unload) end

local H = { alive = true, connections = {}, threads = {}, log = {}, status = "Starting", action = "Idle", guis = {} }
env.CometAA = H

local FOLDER = "CometHub/AnimeAdventures"
local SETTINGS_FILE = FOLDER .. "/settings_v2.json"
local MACRO_FOLDER = FOLDER .. "/macros"
local LOBBY_PLACE = 8304191830

local S = {
    kaitun = false, kaitunReplay = true,
    aprilMergeMethod = true, aprilZone = "Auto", aprilFarmsFirst = true, aprilSwapAtCap = true,
    aprilSpells = { ["Random Buff"] = true, ["Clone"] = true, ["Merge"] = true, ["Ritual"] = true, ["Astral Gate"] = true, ["Astral Summon"] = true, ["Refund"] = false },
    cardMode = "Buffs, then Candy", autoCards = true,
    autoBanner = false, bannerReserve = 0, bannerAmount = "x1",
    autoJoin = false, joinKind = "Story", joinWorld = "", joinAct = "", difficulty = "Normal", joinDelay = 3,
    priority1 = "Daily Challenge", priority2 = "April Fools", priority3 = "Selected Stage", priority4 = "None",
    towerFloor = 1, towerNext = true, challengeTries = {},
    autoStart = true, autoSkip = true, afterMatch = "Replay", endActionExplicit=false, stopSkipWave=0, sellFarmWave=0, leaveWave = 0, sellWave = 0,
    autoPlay = false, playZone = "Middle", mapZones = {}, autoUpgrade = true, maxUnits = 20, farmsFirst = true, cashReserve = 0,
    autoAbility = false, abilityBossOnly = false, autoRukia = false,
    macro = "", macroPlay = false, macroTiming = "Wave",
    webhookUrl = "", webhookMatch = false, webhookSummon = false, webhookPing = false,
    autoExecute = true, skipSummon = false,
    joinerVersion=0,joiners={}, autoDailyChallenge=false, autoChallenge=false, autoTower=false, autoRelic=false,
    dungeonAutoStart=true,dungeonRoomPriority={},dungeonShopItems={},dungeonShopPriority={},dungeonSelectedShopOnly=false,dungeonAcceptShrine=false,dungeonDeclineCurses={},dungeonChestDepth=20,dungeonOpenNormal=true,
    aprilJoinMode = "Matchmaking", autoDungeon = false, dungeonMaxDepth = 20,
    dungeonPlay = true, autoContracts = false, contractPlay = true, contractTier = 5,
    contractSkipCleared = true, autoDazai = false, positionProfiles = {},
    autoWorthiness = false, worthinessWave = 30, macroTimeout = 35,
    boostFps=false, blackScreen=false, rightClickTeleport=false, rightClickMove=false, walkAround=false, rejoinOnPlayer=false, cameraZoom=128,
    pauseAll = false, dungeonKeepRare = true, dungeonShop = true,
    stagePlans = {}, stagePlanVersion = 0, bindRecordedMacro = true,
}
local DEFAULT_SPELLS = table.clone(S.aprilSpells)

local disk = type(isfile) == "function" and type(readfile) == "function" and type(writefile) == "function"
    and type(isfolder) == "function" and type(makefolder) == "function"
local function ensureFolder(path)
    if not disk then return end
    local built = ""
    for part in path:gmatch("[^/]+") do
        built = built == "" and part or built .. "/" .. part
        if not isfolder(built) then pcall(makefolder, built) end
    end
end
local function readJSON(path)
    if not disk or not isfile(path) then return nil end
    local ok, data = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
    return ok and data or nil
end
local function writeJSON(path, value)
    if not disk then return false end
    return pcall(writefile, path, HttpService:JSONEncode(value))
end

do
    ensureFolder(FOLDER); ensureFolder(MACRO_FOLDER)
    local saved = readJSON(SETTINGS_FILE)
    if type(saved) == "table" then
        for key, value in pairs(saved) do
            if S[key] ~= nil and type(S[key]) == type(value) then S[key] = value end
        end
        for name in pairs(DEFAULT_SPELLS) do if S.aprilSpells[name] == nil then S.aprilSpells[name] = DEFAULT_SPELLS[name] end end
    end
end

if S.joinerVersion==0 then
    local kindNames={Story="World",LegendaryStages="Legend",Raids="Raid",Infinite="Infinite",Events="Event"}
    for _,key in ipairs({"priority1","priority2","priority3","priority4"})do
        if S.autoJoin then
            if S[key]=="Daily Challenge"then S.autoDailyChallenge=true end
            if S[key]=="Challenge"then S.autoChallenge=true end
            if S[key]=="Infinity Castle"then S.autoTower=true end
            if S[key]=="Relic Shards"then S.autoRelic=true end
            if S[key]=="Selected Stage"then
                S.joiners[S.joinKind]={enabled=true,world=S.joinWorld,act=S.joinAct,difficulty=S.difficulty}
            end
        end
        if S[key]=="Selected Stage"then S[key]=kindNames[S.joinKind]or "World"end
    end
    S.joinerVersion=1
end

if S.stagePlanVersion == 0 then
    S.autoPlay, S.dungeonPlay, S.contractPlay, S.macroPlay = false, false, false, false
    S.stagePlanVersion = 1
end
local saveQueued = false
local function save()
    if saveQueued then return end
    saveQueued = true
    task.delay(0.5, function()
        saveQueued = false
        if H.alive then writeJSON(SETTINGS_FILE, S) end
    end)
end
H.saveSettings = save

local function log(message)
    message = tostring(message)
    table.insert(H.log, os.date("%H:%M:%S") .. " " .. message)
    if #H.log > 120 then table.remove(H.log, 1) end
end
local function setAction(text)
    if H.action ~= text then H.action = text; log(text) end
end
local function track(connection) table.insert(H.connections, connection); return connection end
local function spawnLoop(fn)
    local thread = task.spawn(fn)
    table.insert(H.threads, thread)
    return thread
end

local function readValue(parent, name, fallback)
    local child = parent and parent:FindFirstChild(name)
    if child and child:IsA("ValueBase") then return child.Value end
    return fallback
end
local function isLobby()
    return readValue(workspace:FindFirstChild("_MAP_CONFIG"), "IsLobby", game.PlaceId == LOBBY_PLACE) == true
end
local function wave() return tonumber(readValue(workspace, "_wave_num", 0)) or 0 end
local function gameData(name) return readValue(workspace:FindFirstChild("_DATA"), name, nil) end
local function stats() return player:FindFirstChild("_stats") end
local function cash() return tonumber(readValue(stats(), "resource", 0)) or 0 end
local function aprilCoins() return tonumber(readValue(stats(), "_resourceAprilCoins", 0)) or 0 end

local Loader, Services, Data = nil, {}, {}
do
    local src = ReplicatedStorage:FindFirstChild("src")
    local module = src and src:FindFirstChild("Loader")
    if module then
        local ok, result = pcall(require, module)
        if ok and type(result) == "table" then Loader = result end
    end
end
local function refreshServices()
    if not Loader or type(debug.getupvalues) ~= "function" then return end
    for _, api in ipairs({ "load_client_service", "load_core_service", "load_client_class", "load_core_class" }) do
        local ok, values = pcall(debug.getupvalues, Loader[api])
        if ok and type(values) == "table" then
            for _, cache in pairs(values) do
                if type(cache) == "table" then
                    for name, entry in pairs(cache) do
                        if type(name) == "string" and type(entry) == "table" and type(entry.module) == "table" then Services[name] = entry.module end
                    end
                end
            end
        end
    end
    local ok, values = pcall(debug.getupvalues, Loader.load_data)
    if ok and type(values) == "table" then
        for _, cache in pairs(values) do if type(cache) == "table" and type(cache.Units) == "table" then Data = cache end end
    end
end
refreshServices()
do
    local deadline = os.clock() + 120
    while os.clock() < deadline do
        local service = Services.UnitCollectionServiceClient
        if service and service.session and Data.Units and Services.PlacementCore then break end
        task.wait(1)
        refreshServices()
    end
end
H.services, H.data, H.settings = Services, Data, S

local function session()
    local service = Services.UnitCollectionServiceClient
    return service and service.session
end
local function collection() local s = session(); return s and s.collection end
local function unitRecord(id) return Data.Units and Data.Units[id] end
local function unitName(id) local r = unitRecord(id); return r and r.name or tostring(id) end
local function levelId()
    if Loader and type(Loader.LevelData) == "table" then
        local level = Loader.LevelData
        if level.id then return tostring(level.id) end
        if level._dungeon then return "dungeon:" .. tostring(level.map) end
        if level._event_contract then return "contract:" .. tostring(level.map) end
    end
    return tostring(readValue(workspace:FindFirstChild("_MAP_CONFIG"), "Level", "") or "")
end
local StagePlans = (function()
local StagePlans = {}
function StagePlans.context(level, difficulty)
    if type(level) ~= "table" then return nil end
    local suffix = "|" .. tostring(level._difficulty or difficulty or "Normal")
    if level._dungeon then return "dungeon:" .. tostring(level.map) .. suffix end
    if level._event_contract then return "contract:" .. tostring(level.map) .. suffix end
    if level._gamemode == "infinite_tower" then return "tower:" .. tostring(level.map) .. suffix end
    if level.id then return "stage:" .. tostring(level.id) .. suffix end
end
function StagePlans.resolve(plans, level, difficulty)
    local key = StagePlans.context(level, difficulty)
    return key and plans[key] or nil, key
end
function StagePlans.bind(plans, key, engine, macro)
    if not key then return false, "Select a stage first" end
    if not table.find({ "Off", "Auto Play", "Macro" }, engine) then return false, "Unknown playback mode" end
    if engine == "Macro" and (type(macro) ~= "string" or macro == "") then return false, "Select a saved macro" end
    local entry = plans[key] or {}
    entry.engine, entry.macro = engine, engine == "Macro" and macro or nil
    plans[key] = entry
    return true
end
return StagePlans

end)()
local function currentPlanKey()
    return StagePlans.context(Loader and Loader.LevelData, S.difficulty)
end
H.stagePlans = StagePlans
H.currentPlanKey = currentPlanKey
local AutoplayPolicy = (function()
local Policy = {}
local function number(value, fallback, low, high)
    local n=tonumber(value)
    if not n or n~=n or n==math.huge or n==-math.huge then n=fallback end
    return math.clamp(n,low,high)
end
local function points(list)
    local out={}
    for _,p in ipairs(type(list)=="table"and list or{})do
        if type(p)=="table" and tonumber(p[1])and tonumber(p[2])and tonumber(p[3])then
            local values={tonumber(p[1]),tonumber(p[2]),tonumber(p[3])}
            local valid=true;for i=1,3 do if values[i]~=values[i]or math.abs(values[i])>1000000 then valid=false end end
            if valid then table.insert(out,values)end
        end
        if #out>=100 then break end
    end
    return out
end
function Policy.normalize(raw,defaults)
    raw=type(raw)=="table"and raw or{};defaults=defaults or{}
    local config={zone=raw.zone or defaults.zone or "Auto",farmZone=raw.farmZone or "Back",mode=raw.mode or "Auto",radius=number(raw.radius,30,3,120),
        maxUnits=number(raw.maxUnits,defaults.maxUnits or 20,1,30),reserve=number(raw.reserve,defaults.reserve or 0,0,1000000),
        farmsFirst=raw.farmsFirst~=false,upgrade=raw.upgrade or "Efficiency",points=points(raw.points),units={}}
    if raw.farmsFirst==nil and defaults.farmsFirst~=nil then config.farmsFirst=defaults.farmsFirst end
    for slot=1,6 do
        local u=type(raw.units)=="table"and raw.units[tostring(slot)]or{};u=type(u)=="table"and u or{}
        config.units[tostring(slot)]={enabled=u.enabled~=false,limit=number(u.limit,6,0,30),priority=number(u.priority,slot,1,6),
            fromWave=number(u.fromWave,0,0,10000),untilWave=number(u.untilWave,0,0,10000),maxUpgrade=number(u.maxUpgrade,0,0,100),
            upgrade=u.upgrade~=false,zone=u.zone or "Inherit",mode=u.mode or "Inherit",points=points(u.points)}
    end
    return config
end
function Policy.eligible(config,slot,count,wave,spawnCap)
    local u=config.units[tostring(slot)]
    return u and u.enabled and count<math.min(u.limit,spawnCap or 6)and wave>=u.fromWave and(u.untilWave==0 or wave<=u.untilWave)
end
function Policy.canUpgrade(config,slot,level)
    local u=config.units[tostring(slot)]
    return u and u.enabled and u.upgrade and(u.maxUpgrade==0 or level<u.maxUpgrade)
end
function Policy.position(config,slot,isFarm,count,total)
    local u=config.units[tostring(slot)]
    local zone=u.zone~="Inherit"and u.zone or(isFarm and config.farmZone or config.zone)
    local mode=u.mode~="Inherit"and u.mode or config.mode
    local own=#u.points>0
    local list=own and u.points or config.points
    if mode=="Exact"then return mode,zone,list[(own and count or total)+1]end
    return mode,zone,list[1]
end
return Policy

end)()
local function levelName(id)
    local level = Loader and Loader.LevelData or Data.Levels and Data.Levels[id]
    if not level then return id ~= "" and id or "Unknown" end
    local world = level.world and Data.Worlds and Data.Worlds[level.world]
    return (world and world.name and (world.name .. " · ") or "") .. tostring(level.name or id)
end
local function isApril() return levelId():find("april", 1, true) ~= nil end

local c2s = ReplicatedStorage:WaitForChild("endpoints"):WaitForChild("client_to_server")
local s2c = ReplicatedStorage.endpoints:WaitForChild("server_to_client")
local inflight = {}
H.remoteCalls = {}
local function call(name, ...)
    local remote = c2s:FindFirstChild(name)
    if not remote then return false, "missing " .. name end
    if inflight[name] then return false, "busy" end
    inflight[name] = true
    H.remoteCalls[name] = (H.remoteCalls[name] or 0) + 1
    local args = table.pack(...)
    local done, ok, result = false, false, nil
    task.spawn(function()
        ok, result = pcall(function()
            if remote:IsA("RemoteFunction") then return table.pack(remote:InvokeServer(table.unpack(args, 1, args.n))) end
            remote:FireServer(table.unpack(args, 1, args.n))
            return { true, n = 1 }
        end)
        done = true
        inflight[name] = nil
    end)
    local deadline = os.clock() + 12
    while not done and os.clock() < deadline do task.wait(0.05) end
    if not done then return false, "timeout" end
    if not ok then return false, tostring(result) end
    return result[1] ~= false, result[2] or result[1]
end
local function fire(name, ...)
    local remote = c2s:FindFirstChild(name)
    if not remote then return end
    local args = table.pack(...)
    task.spawn(function()
        pcall(function()
            if remote:IsA("RemoteFunction") then remote:InvokeServer(table.unpack(args, 1, args.n)) else remote:FireServer(table.unpack(args, 1, args.n)) end
        end)
    end)
end
local function onServer(name, callback)
    local remote = s2c:FindFirstChild(name)
    if remote then track(remote.OnClientEvent:Connect(function(...)
        local ok, err = pcall(callback, ...)
        if not ok then log(name .. ": " .. tostring(err)) end
    end)) end
end

local function unitStat(unit, name)
    local folder = unit:FindFirstChild("_stats")
    local value = folder and folder:FindFirstChild(name)
    return value and value.Value
end
local function myUnits()
    local list = {}
    local folder = workspace:FindFirstChild("_UNITS")
    for _, unit in ipairs(folder and folder:GetChildren() or {}) do
        if unit:IsA("Model") and unitStat(unit, "player") == player then table.insert(list, unit) end
    end
    return list
end
local function unitId(unit) return tostring(unitStat(unit, "id")) end
local function isFarm(record) return record ~= nil and (tonumber(record.farm_amount) or 0) > 0 end
local function invested(unit)
    local record = unitRecord(unitId(unit))
    if not record then return 0 end
    local total = tonumber(record.cost) or 0
    for i = 1, unitStat(unit, "upgrade") or 0 do
        local step = record.upgrade and record.upgrade[i]
        total += step and tonumber(step.cost) or 0
    end
    return total
end
local function nextUpgrade(unit)
    local gui = Services.GUIService
    if gui and type(gui.get_next_upgrade_info) == "function" then
        local ok, info = pcall(gui.get_next_upgrade_info, gui, unit)
        if ok and type(info) == "table" and info.cost then return info end
    end
    local record = unitRecord(unitId(unit))
    return record and record.upgrade and record.upgrade[(unitStat(unit, "upgrade") or 0) + 1]
end
local function upgradeCost(unit)
    local info = nextUpgrade(unit)
    if not info or not info.cost then return nil end
    return math.ceil((tonumber(info.cost) or math.huge) * (unitStat(unit, "upgrade_cost_multiplier") or 1))
end
local function levelStats(record, level)
    local stats = { damage = tonumber(record.damage), attack_cooldown = tonumber(record.attack_cooldown), range = tonumber(record.range), farm_amount = tonumber(record.farm_amount) }
    for i = 1, level do
        local step = record.upgrade and record.upgrade[i]
        if step then for key in pairs(stats) do if step[key] then stats[key] = tonumber(step[key]) end end end
    end
    return stats
end
local damageHistory = setmetatable({}, { __mode = "k" })
local function statDps(unit)
    local damage = tonumber(unitStat(unit, "damage")) or 0
    local cooldown = tonumber(unitStat(unit, "attack_cooldown")) or 1
    return damage / math.max(cooldown, 0.2)
end
local function liveDps(unit)
    local history = damageHistory[unit]
    if history and #history >= 2 then
        local first, last = history[1], history[#history]
        if last.t - first.t >= 10 then
            local measured = (last.d - first.d) / (last.t - first.t)
            if measured > 0 then return math.max(measured, statDps(unit) * 0.25) end
        end
    end
    return statDps(unit)
end
local function sampleDamage(units)
    local now = os.clock()
    for _, unit in ipairs(units) do
        local total = tonumber(unitStat(unit, "total_damage"))
        if total then
            local history = damageHistory[unit] or {}
            damageHistory[unit] = history
            if #history == 0 or now - history[#history].t >= 2 then table.insert(history, { t = now, d = total }) end
            while #history > 2 and now - history[1].t > 25 do table.remove(history, 1) end
        end
    end
end
local function remainingWaves()
    local level = Loader and Loader.LevelData
    local total = level and (level._override_infinite_bound_waves or (level.waves and 0)) or 0
    if isApril() then total = 30 end
    if total == 0 then total = 25 end
    return math.max(0, total - wave())
end
local function upgradeValue(unit)
    local info = nextUpgrade(unit)
    local record = unitRecord(unitId(unit))
    if not info or not info.cost or not record then return nil end
    local cost = math.ceil((tonumber(info.cost) or math.huge) * (unitStat(unit, "upgrade_cost_multiplier") or 1))
    local current = levelStats(record, unitStat(unit, "upgrade") or 0)
    if isFarm(record) then
        local gain = (tonumber(info.farm_amount) or current.farm_amount or 0) - (current.farm_amount or 0)
        return cost, "farm", gain * remainingWaves() / cost
    end
    local damage, cooldown = current.damage or 0, current.attack_cooldown or 1
    local nextDamage = tonumber(info.damage) or damage
    local nextCooldown = tonumber(info.attack_cooldown) or cooldown
    local live = liveDps(unit)
    if damage <= 0 or statDps(unit) <= 0 then return cost, "support", nil end
    local ratio = (nextDamage / math.max(nextCooldown, 0.2)) / (damage / math.max(cooldown, 0.2))
    local gain = live * math.max(0, ratio - 1)
    if info.range and current.range and current.range > 0 then gain += live * math.max(0, info.range / current.range - 1) * 0.5 end
    return cost, "dps", gain / cost
end
H.upgradeValue = upgradeValue

local function maxLevel(record) return record and record.upgrade and #record.upgrade or 0 end
local function hitsAir(record)
    if not record then return false end
    if record.hill_unit or record.hybrid_placement then return true end
    local attack = record.primary_attack_no_upgrades or record.primary_attack
    local data = attack and Data.Attacks and Data.Attacks[attack]
    return data ~= nil and data.targets_flying == true
end
local function airUnits(units)
    local list = {}
    for _, unit in ipairs(units) do
        local record = unitRecord(unitId(unit))
        if record and not isFarm(record) and (tonumber(record.damage) or 0) > 0 and hitsAir(record) then table.insert(list, unit) end
    end
    return list
end
local function airNeeded(units) return wave() >= 6 and #airUnits(units) < 3 end
local function topDps(record)
    local top = levelStats(record, maxLevel(record))
    return (top.damage or 0) / math.max(top.attack_cooldown or 1, 0.2)
end
local Carry = { id = nil, merges = 0 }
H.carry = Carry
function Carry.copies(units)
    local list = {}
    for _, unit in ipairs(units) do if Carry.id and unitId(unit) == Carry.id then table.insert(list, unit) end end
    table.sort(list, function(a, b)
        local la, lb = unitStat(a, "upgrade") or 0, unitStat(b, "upgrade") or 0
        if la ~= lb then return la > lb end
        return liveDps(a) > liveDps(b)
    end)
    return list
end
function Carry.main(units) return Carry.copies(units)[1] end
function Carry.role(unit, units)
    if not Carry.id or unitId(unit) ~= Carry.id then return nil end
    return Carry.main(units) == unit and "main" or "base"
end
function Carry.choose(units, hand, spells)
    local hasClone = false
    for _, spell in ipairs(spells) do if spell.id == "clone" then hasClone = true end end
    local counts, records, live = {}, {}, {}
    for _, unit in ipairs(units) do
        local id = unitId(unit)
        local record = unitRecord(id)
        if record and not isFarm(record) and maxLevel(record) > 0 and (tonumber(record.cost) or 0) >= 50 then
            counts[id] = (counts[id] or 0) + 1; records[id] = record
            live[id] = math.max(live[id] or 0, liveDps(unit))
        end
    end
    for _, item in ipairs(hand) do
        if not isFarm(item.record) and maxLevel(item.record) > 0 then counts[item.id] = (counts[item.id] or 0) + 1; records[item.id] = item.record end
    end
    local function score(id)
        local record = records[id]
        local level0 = levelStats(record, 0)
        local baseDps = (level0.damage or 0) / math.max(level0.attack_cooldown or 1, 0.2)
        local scale = (live[id] and baseDps > 0) and live[id] / baseDps or 1
        local totalCost = 0
        for i = 1, maxLevel(record) do totalCost += tonumber(record.upgrade[i].cost) or 0 end
        local maxed = topDps(record) * scale
        return maxed / math.max(totalCost, 1000) * (hitsAir(record) and 1.5 or 1) * (((counts[id] or 0) >= 2 or hasClone) and 2 or 0.5)
    end
    local pairAvailable=false
    if S.aprilMergeMethod and Carry.merges == 0 then
        for id,count in pairs(counts) do if live[id] and count >= 2 then pairAvailable=true;break end end
    end
    local best, bestScore
    for id in pairs(counts) do
        if live[id] and (not pairAvailable or counts[id] >= 2) then
            local value = score(id)
            if not best or value > bestScore then best, bestScore = id, value end
        end
    end
    if Carry.id and counts[Carry.id] then
        if Carry.merges > 0 or not best or best == Carry.id or ((not pairAvailable or (counts[Carry.id] or 0) >= 2) and bestScore < score(Carry.id) * 3) then return end
    end
    if best and best ~= Carry.id then Carry.id = best; setAction("Carry chosen: " .. unitName(best)) end
end

local function lanes()
    local list = {}
    local cache = Services.PathService and Services.PathService.PATH_CACHE
    for key, group in pairs(cache or {}) do
        if tostring(key) == "pve" and type(group) == "table" then
            for _, lane in pairs(group) do if type(lane) == "table" and lane.points and lane.total_distance then table.insert(list, lane) end end
        end
    end
    return list
end
local function lanePoint(lane, distance)
    local points = lane.points
    for i = 1, #points - 1 do
        local a, b = points[i], points[i + 1]
        if distance >= a.distance_from_spawn and distance <= b.distance_from_spawn then
            local t = (distance - a.distance_from_spawn) / math.max(1e-3, b.distance_from_spawn - a.distance_from_spawn)
            return a.position:Lerp(b.position, t)
        end
    end
    return points[#points].position
end
local ZONES = { Front = 0.2, Middle = 0.5, Back = 0.8 }
local pathCache = setmetatable({}, { __mode = "k" })
local function pathSamples(lane)
    if pathCache[lane] then return pathCache[lane] end
    local samples = {}
    for distance = 0, lane.total_distance, 2 do
        table.insert(samples, { position = lanePoint(lane, distance), fraction = distance / lane.total_distance })
    end
    pathCache[lane] = samples
    return samples
end
local function zoneWeight(zone, fraction)
    local center = ZONES[zone]
    if not center then return 1 end
    return 0.15 + math.exp(-((fraction - center) / 0.18) ^ 2)
end
local function coverage(position, range, zone)
    local total = 0
    for _, lane in ipairs(lanes()) do
        for _, sample in ipairs(pathSamples(lane)) do
            if (sample.position - position).Magnitude <= range then total += zoneWeight(zone, sample.fraction) end
        end
    end
    return total
end
local Spots = { lane = nil, cells = nil, bad = {} }
function Spots.get()
    local list = lanes()
    local PlacementCore = Services.PlacementCore
    if #list == 0 or not PlacementCore or not PlacementCore._initialized then return nil end
    if Spots.lane == list[1] and Spots.cells then return Spots.cells end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Include
    params.FilterDescendantsInstances = { PlacementCore.GroundRaycastParts, PlacementCore.HillRaycastParts }
    local seen, cells, count = {}, {}, 0
    for _, lane in ipairs(list) do
        for index, sample in ipairs(pathSamples(lane)) do
            if index % 2 == 1 then
                for dx = -27, 27, 3 do
                    for dz = -27, 27, 3 do
                        if dx * dx + dz * dz <= 27 * 27 then
                            local gx = math.floor((sample.position.X + dx) / 3 + 0.5)
                            local gz = math.floor((sample.position.Z + dz) / 3 + 0.5)
                            local id = gx * 100003 + gz
                            if not seen[id] then
                                seen[id] = true
                                local origin = Vector3.new(gx * 3, sample.position.Y + 60, gz * 3)
                                local hit = workspace:Raycast(origin, Vector3.new(0, -150, 0), params)
                                if hit then table.insert(cells, { position = hit.Position, instance = hit.Instance, id = id }) end
                                count += 1
                                if count % 200 == 0 then task.wait() end
                            end
                        end
                    end
                end
            end
        end
    end
    Spots.lane, Spots.cells, Spots.bad = list[1], cells, {}
    return cells
end
local function findSpot(record, zone, anchor, maxDistance)
    local cells = Spots.get()
    if not cells then return nil end
    local PlacementCore = Services.PlacementCore
    local taken = {}
    local folder = workspace:FindFirstChild("_UNITS")
    for _, unit in ipairs(folder and folder:GetChildren() or {}) do
        if unitStat(unit, "player") ~= nil then
            local ok, pivot = pcall(unit.GetPivot, unit)
            if ok then table.insert(taken, pivot.Position) end
        end
    end
    local farm = isFarm(record)
    local range = math.min(tonumber(record.range) or 15, 45)
    local best, bestScore
    for index, cell in ipairs(cells) do
        if not Spots.bad[cell.id] then
            local free = true
            for _, position in ipairs(taken) do
                local delta = position - cell.position
                if delta.X * delta.X + delta.Z * delta.Z < 2.9 * 2.9 then free = false break end
            end
            if free then
                local ok, valid = pcall(PlacementCore.is_valid_raycast_hit, cell.instance, record)
                local near = not anchor or (cell.position - anchor).Magnitude <= maxDistance
                if ok and valid and near then
                    local score = anchor and -(cell.position - anchor).Magnitude
                        or farm and -coverage(cell.position, 20, "Auto") or coverage(cell.position, range, zone)
                    if farm and not anchor and zone ~= "Auto" then
                        local nearest, fraction = math.huge, 0.5
                        for _, lane in ipairs(lanes()) do
                            for _, sample in ipairs(pathSamples(lane)) do
                                local d = (sample.position - cell.position).Magnitude
                                if d < nearest then nearest, fraction = d, sample.fraction end
                            end
                        end
                        score += zoneWeight(zone, fraction) * 50
                    end
                    if record.hybrid_placement and not farm and PlacementCore.HillRaycastParts and cell.instance:IsDescendantOf(PlacementCore.HillRaycastParts) then
                        score += math.abs(score) * 0.5 + 5
                    end
                    score += math.random() * 0.05
                    if not best or score > bestScore then best, bestScore = cell, score end
                end
            end
        end
        if index % 150 == 0 then task.wait() end
    end
    return best
end
local function placeUnit(uuid, record, zone, anchor, maxDistance)
    if isApril() and #myUnits() >= 20 then return false, "placement limit" end
    for _ = 1, 4 do
        local cell = findSpot(record, zone, anchor, maxDistance)
        if not cell then return false, "no spot" end
        local function count()
            local n = 0
            for _, unit in ipairs(myUnits()) do if unitId(unit) == record.id then n += 1 end end
            return n
        end
        local before = count()
        call("spawn_unit", uuid, CFrame.new(cell.position))
        local deadline = os.clock() + 1.5
        repeat task.wait(0.1) until count() > before or os.clock() > deadline
        if count() > before then return true end
        Spots.bad[cell.id] = true
    end
    return false, "declined"
end
local function bestUpgrades(units)
    local options, dpsValues = {}, {}
    for _, unit in ipairs(units) do
        local role = S.aprilMergeMethod and Carry.role(unit, units) or nil
        if unitStat(unit, "state") ~= "dead" and role ~= "base" then
            local cost, kind, value = upgradeValue(unit)
            if cost then
                if role == "main" and (#Carry.copies(units) >= 2 or wave() >= 10) then kind = "carry" end
                table.insert(options, { unit = unit, cost = cost, kind = kind, value = value })
                if kind == "dps" then table.insert(dpsValues, value) end
            end
        end
    end
    table.sort(dpsValues)
    local median = dpsValues[math.ceil(#dpsValues / 2)] or 0
    local airWeak = wave() >= 6 and #airUnits(units) < 4
    for _, option in ipairs(options) do
        if option.kind == "carry" then option.score = 1e12
        elseif option.kind == "support" then option.score = median * 0.7
        elseif option.kind == "dps" and airWeak and hitsAir(unitRecord(unitId(option.unit))) then option.score = (option.value or 0) * 4
        elseif option.kind == "farm" then option.score = option.value >= 2 and 1e13 or option.value >= 1.3 and 1e11 or -1
        else option.score = option.value end
    end
    table.sort(options, function(a, b) return a.score > b.score end)
    return options, median
end
local function upgradeOne(units, reserve, farmsFirst)
    local options = bestUpgrades(units)
    local top = options[1]
    if not top or top.score < 0 then return false end
    if top.kind == "farm" and not farmsFirst then
        for _, option in ipairs(options) do if option.kind ~= "farm" then top = option break end end
    end
    if top.cost > cash() - reserve then
        if top.kind == "farm" or top.kind == "carry" then setAction("Saving for " .. unitName(unitId(top.unit)) .. " upgrade") end
        return false
    end
    local level = unitStat(top.unit, "upgrade")
    call("upgrade_unit_ingame", top.unit)
    task.wait(0.2)
    if unitStat(top.unit, "upgrade") ~= level then
        setAction(string.format("Upgraded %s to %s (%s)", unitName(unitId(top.unit)), tostring(unitStat(top.unit, "upgrade")),
            top.kind == "farm" and "income" or top.kind == "carry" and "carry" or top.kind == "dps" and string.format("+%.2f dps/$", top.value) or "support"))
        return true
    end
    return false
end

local SPELL_NAMES = { random_buff = "Random Buff", clone = "Clone", sacrifice = "Merge", ritual = "Ritual", gate = "Astral Gate", summon = "Astral Summon", sell_refund = "Refund" }
local April = { failures = {}, capped = nil }
function April.hand()
    local s = session()
    local col = collection()
    local list = {}
    for slot, uuid in pairs(s and s.override_equipped_units or {}) do
        local unit = col and (col.temporary_units[uuid] or (col.collection_profile_data and col.collection_profile_data.owned_units[uuid]))
        local record = unit and unitRecord(unit.unit_id)
        if record then table.insert(list, { slot = slot, uuid = uuid, id = unit.unit_id, record = record, temporary = col.temporary_units[uuid] ~= nil }) end
    end
    return list
end
function April.spells()
    local s = session()
    local list = {}
    for slot, id in pairs(s and s.ingame_spells or {}) do
        table.insert(list, { slot = slot, id = id, meta = Data.IngameSpells and Data.IngameSpells[id] or {} })
    end
    return list
end
local function strongest(units, preferGeneral)
    local best
    for _, unit in ipairs(units) do
        if preferGeneral and unitId(unit):find("divine", 1, true) and (unitStat(unit, "buff_damage_multiplier") or 0) < 1 then return unit end
        if not isFarm(unitRecord(unitId(unit))) and (not best or liveDps(unit) > liveDps(best)) then best = unit end
    end
    return best
end
local function weakest(units, excludeFarms)
    local worst
    for _, unit in ipairs(units) do
        local record = unitRecord(unitId(unit))
        local farm = isFarm(record)
        local summon = not record or record.unsellable or (tonumber(record.cost) or 0) < 50 or unitId(unit):find("drone", 1, true) or unitId(unit) == Carry.id
        local support = record and not farm and (tonumber(record.damage) or 0) <= 0
        if not summon and not support and not (excludeFarms and farm) and (not worst or liveDps(unit) < liveDps(worst)) then worst = unit end
    end
    return worst
end
function April.spellStep(units)
    April.mergeReserveWanted=nil
    local hand, spells = April.hand(), April.spells()
    local full = #hand + #spells >= 6
    for _, spell in ipairs(spells) do
        local cost = tonumber(spell.meta.cost) or 0
        local enabled = S.aprilSpells[SPELL_NAMES[spell.id] or ""] == true
        local target, discard
        if spell.id == "sell_refund" then
            local capped = April.capped and #units >= April.capped
            local upgrade
            for _, item in ipairs(hand) do
                if not isFarm(item.record) and (tonumber(item.record.damage) or 0) > 0 then upgrade = item end
            end
            local worst = capped and upgrade and weakest(units, true)
            if worst and (tonumber(upgrade.record.cost) or 0) > invested(worst) then target = worst else discard = true end
        elseif not enabled then
            discard = true
        elseif spell.id == "gate" or spell.id == "summon" then
            if cost <= cash() and #units < 20 then
                call("use_ingame_spell", spell.slot)
                setAction("Used " .. SPELL_NAMES[spell.id])
                return true
            end
        elseif spell.id == "random_buff" then
            target = Carry.main(units) or strongest(units, true)
        elseif spell.id == "clone" then
            local copies = Carry.copies(units)
            local mainLevel = copies[1] and (unitStat(copies[1], "upgrade") or 0) or 0
            if copies[1] and #copies < 2 and (mainLevel == 0 or (not S.aprilMergeMethod and mainLevel >= maxLevel(unitRecord(unitId(copies[1]))))) then
                target = copies[1]
            else
                local bestFarm
                for _, unit in ipairs(units) do
                    local record = unitRecord(unitId(unit))
                    if isFarm(record) and remainingWaves() > 8 and (not bestFarm or (unitStat(unit, "upgrade") or 0) > (unitStat(bestFarm, "upgrade") or 0)) then bestFarm = unit end
                end
                target = bestFarm or (not S.aprilMergeMethod and (Carry.main(units) or strongest(units)))
            end
            if #units >= 20 then target, discard = nil, full end
        elseif spell.id == "sacrifice" then
            local copies = Carry.copies(units)
            local main = copies[1]
            local record = main and unitRecord(unitId(main))
            if S.aprilMergeMethod and main and maxLevel(record) > 0
                and (unitStat(main,"upgrade") or 0) >= maxLevel(record) then
                -- Merge targets the untouched receiver, consuming the maxed donor.
                for i = #copies, 2, -1 do
                    local base = copies[i]
                    local reach = tonumber(unitStat(base,"range")) or 10
                    if (unitStat(base,"upgrade") or 0) == 0
                        and (base:GetPivot().Position-main:GetPivot().Position).Magnitude <= reach then
                        local rebuild = 0
                        for _, step in ipairs(record.upgrade or {}) do rebuild += math.ceil((tonumber(step.cost) or 0) * (tonumber(unitStat(base,"upgrade_cost_multiplier")) or 1)) end
                        if cash() >= cost + rebuild then
                            target = base
                            April.mergeDonor = main
                            break
                        else
                            April.mergeReserveWanted=cost+rebuild
                            setAction("Saving merge rebuild cash: " .. math.floor(cash()) .. "/" .. math.ceil(cost+rebuild))
                        end
                    end
                end
            end
            -- Keep Merge for a legal max + level-0 pair. Never merge onto the donor.
            discard = not S.aprilMergeMethod and full
        elseif spell.id == "ritual" then
            local general = false
            for _, unit in ipairs(units) do if unitId(unit):find("divine", 1, true) then general = true end end
            if not general and #units >= 4 then target = weakest(units, true) else discard = full end
        end
        if target and cost <= cash() then
            if spell.id == "sacrifice" then
                local donor = April.mergeDonor
                local beforeDamage = tonumber(unitStat(target,"damage")) or 0
                call("use_ingame_spell",spell.slot,target)
                local deadline = os.clock()+3
                repeat
                    local donorGone = not donor or not table.find(myUnits(),donor)
                    if donorGone and target.Parent and (tonumber(unitStat(target,"damage")) or 0) > beforeDamage then
                        Carry.merges += 1
                        setAction("Merge confirmed · rebuild " .. unitName(unitId(target)))
                        April.mergeDonor=nil
                        return true
                    end
                    task.wait(.1)
                until os.clock() >= deadline or not H.alive
                April.mergeDonor=nil
                setAction("Merge not confirmed; waiting for a valid pair")
            else
                call("use_ingame_spell", spell.slot, target)
                setAction((SPELL_NAMES[spell.id] or spell.id) .. " on " .. unitName(unitId(target)))
            end
            return true
        elseif discard then
            call("delete_ingame_spell", tostring(spell.slot))
            setAction("Discarded " .. (SPELL_NAMES[spell.id] or spell.id))
            return true
        end
    end
    return false
end
local KEY_UNITS = { "bulma", "hoshino", "nagumo", "sakamoto", "conrad", "aizen", "law_2", "hamura", "goku", "vegeta", "divine" }
local function isKeyUnit(id)
    for _, key in ipairs(KEY_UNITS) do if id:find(key, 1, true) then return true end end
    return false
end
function April.placeStep(units)
    local hand = April.hand()
    local needAir = airNeeded(units)
    table.sort(hand, function(a, b)
        local fa, fb = S.aprilFarmsFirst and isFarm(a.record), S.aprilFarmsFirst and isFarm(b.record)
        if fa ~= fb then return fa end
        if needAir then
            local aa, ab = hitsAir(a.record) and (tonumber(a.record.damage) or 0) > 0, hitsAir(b.record) and (tonumber(b.record.damage) or 0) > 0
            if aa ~= ab then return aa end
        end
        local ka, kb = isKeyUnit(a.id), isKeyUnit(b.id)
        if ka ~= kb then return ka end
        local va = (tonumber(a.record.damage) or 0) / math.max(tonumber(a.record.attack_cooldown) or 1, 0.2) / math.max(tonumber(a.record.cost) or 1, 1)
        local vb = (tonumber(b.record.damage) or 0) / math.max(tonumber(b.record.attack_cooldown) or 1, 0.2) / math.max(tonumber(b.record.cost) or 1, 1)
        return va > vb
    end)
    for _, item in ipairs(hand) do
        local cost = tonumber(item.record.cost) or math.huge
        local farmCap = tonumber(item.record.spawn_cap)
        local sameCount = 0
        for _, unit in ipairs(units) do if unitId(unit) == item.id then sameCount += 1 end end
        local atUnitCap = farmCap and sameCount >= farmCap
        local atCap = #units >= 20
        if (tonumber(item.record.damage) or 0) <= 0 and not isFarm(item.record) and sameCount >= 1 then
            call("delete_ingame_temporary_unit", tostring(item.slot))
            setAction("Skipped extra " .. unitName(item.id))
            return true
        end
        -- Keep a fresh copy in hand for the next cycle; an existing pair is enough.
        if S.aprilMergeMethod and item.id == Carry.id and sameCount >= 2 then continue end
        if item.id == Carry.id and not atUnitCap and cost <= cash() then
            local main = Carry.main(units)
            if main and atCap then
                local worst = weakest(units, true)
                if worst then call("sell_unit_ingame", worst); task.wait(0.3) end
                if #myUnits() >= 20 then return false end
            end
            local reach = (tonumber(item.record.range) or 12) * 0.6
            local ok = placeUnit(item.uuid, item.record, S.aprilZone, main and main:GetPivot().Position, reach)
            if not ok and main then ok = placeUnit(item.uuid, item.record, S.aprilZone, main:GetPivot().Position, reach * 1.6) end
            setAction((ok and "Placed carry copy " or "Could not place carry copy ") .. unitName(item.id))
            return true
        end
        if isFarm(item.record) and not atUnitCap and not atCap then
            local income = tonumber(item.record.farm_amount) or 0
            if income * remainingWaves() < cost * 1.2 then
                call("delete_ingame_temporary_unit", tostring(item.slot))
                setAction("Skipped " .. unitName(item.id) .. " (too late to pay back)")
                return true
            end
        elseif not atUnitCap and not atCap and not isKeyUnit(item.id) and item.id ~= Carry.id and not (hitsAir(item.record) and #airUnits(units) < 6) then
            local damage, cooldown = tonumber(item.record.damage) or 0, tonumber(item.record.attack_cooldown) or 1
            local scale, samples, dpsCount, supports = 0, 0, 0, 0
            for _, unit in ipairs(units) do
                local record = unitRecord(unitId(unit))
                if record and not isFarm(record) then
                    local base = levelStats(record, unitStat(unit, "upgrade") or 0)
                    if (base.damage or 0) > 0 then
                        dpsCount += 1
                        scale += liveDps(unit) / (base.damage / math.max(base.attack_cooldown or 1, 0.2))
                        samples += 1
                    elseif unitId(unit) == item.id then supports += 1 end
                end
            end
            scale = samples > 0 and scale / samples or 1
            local placeValue = damage / math.max(cooldown, 0.2) * scale / cost
            local _, bestUpgradeValue = bestUpgrades(units)
            local weak = damage > 0 and dpsCount >= 8 and wave() >= 10 and placeValue < bestUpgradeValue * 0.6
            local duplicateSupport = damage <= 0 and supports >= 1
            if weak or duplicateSupport then
                call("delete_ingame_temporary_unit", tostring(item.slot))
                setAction(string.format("Skipped %s (%.2f dps/$ vs upgrades %.2f)", unitName(item.id), placeValue, bestUpgradeValue))
                return true
            end
        end
        if atUnitCap or atCap then
            local worst = weakest(units, true)
            local airSwap = needAir and hitsAir(item.record) and (tonumber(item.record.damage) or 0) > 0
            if airSwap then
                local candidates = {}
                for _, unit in ipairs(units) do if not hitsAir(unitRecord(unitId(unit))) then table.insert(candidates, unit) end end
                worst = weakest(candidates, true) or worst
            end
            local scale, samples = 0, 0
            for _, unit in ipairs(units) do
                local record = unitRecord(unitId(unit))
                local base = record and levelStats(record, unitStat(unit, "upgrade") or 0)
                if base and (base.damage or 0) > 0 and not isFarm(record) then
                    scale += liveDps(unit) / (base.damage / math.max(base.attack_cooldown or 1, 0.2)); samples += 1
                end
            end
            scale = samples > 0 and scale / samples or 1
            local newDps = (tonumber(item.record.damage) or 0) / math.max(tonumber(item.record.attack_cooldown) or 1, 0.2) * scale
            local better = worst and newDps > liveDps(worst) * 1.4
            if atCap and not atUnitCap and S.aprilSwapAtCap and worst and not isFarm(item.record) and cost <= cash()
                and (airSwap or better) then
                call("sell_unit_ingame", worst)
                setAction("Swapped " .. unitName(unitId(worst)) .. " for " .. unitName(item.id))
                task.wait(0.3)
                placeUnit(item.uuid, item.record, S.aprilZone)
                return true
            end
            call("delete_ingame_temporary_unit", tostring(item.slot))
            setAction("Discarded " .. unitName(item.id) .. (atUnitCap and " (unit limit)" or " (placement limit)"))
            return true
        elseif cost <= cash() then
            local twin
            if not isFarm(item.record) and (tonumber(item.record.damage) or 0) > 0 then
                for _, unit in ipairs(units) do if unitId(unit) == item.id and (unitStat(unit, "upgrade") or 0) > 0 then twin = unit break end end
            end
            local ok
            if twin then ok = placeUnit(item.uuid, item.record, S.aprilZone, twin:GetPivot().Position, (tonumber(item.record.range) or 12) * 0.6) end
            if not ok then ok = placeUnit(item.uuid, item.record, S.aprilZone) end
            if ok then
                April.failures[item.uuid] = nil
                setAction("Placed " .. unitName(item.id))
            else
                April.failures[item.uuid] = (April.failures[item.uuid] or 0) + 1
                if April.failures[item.uuid] >= 2 and #units >= 15 then April.capped = #units end
                if April.failures[item.uuid] >= 4 then
                    call("delete_ingame_temporary_unit", tostring(item.slot))
                    setAction("Discarded " .. unitName(item.id) .. " (no valid spot)")
                end
            end
            return true
        end
    end
    return false
end
function April.step()
    local units = myUnits()
    sampleDamage(units)
    Carry.choose(units, April.hand(), April.spells())
    local acted = April.spellStep(units)
    if April.mergeReserveWanted and not acted then
        setAction("Saving merge rebuild cash: " .. math.floor(cash()) .. "/" .. math.ceil(April.mergeReserveWanted))
        return
    end
    if not acted then acted=April.placeStep(units) end
    if acted then units = myUnits() end
    local reserve = 0
    if #units < 14 then
        for _, item in ipairs(April.hand()) do
            local cost = tonumber(item.record.cost) or 0
            if (tonumber(item.record.damage) or 0) > 0 or isFarm(item.record) then
                if reserve == 0 or cost < reserve then reserve = cost end
            end
        end
    end
    if not upgradeOne(units, reserve, S.aprilFarmsFirst) and not acted and not H.action:find("Saving", 1, true) then setAction("Waiting for cash or new hand units") end
end

local Play = { failures = {} }
function Play.equipped()
    local col = collection()
    local profile = col and col.collection_profile_data
    local s = session()
    local equipped = s and s.override_equipped_units or profile and profile.equipped_units or {}
    local list = {}
    for slot, uuid in pairs(equipped) do
        local unit = profile and profile.owned_units[uuid] or col and col.temporary_units[uuid]
        local record = unit and unitRecord(unit.unit_id)
        if record then table.insert(list, { slot = tonumber(slot) or 0, uuid = uuid, id = unit.unit_id, record = record }) end
    end
    table.sort(list, function(a, b) return a.slot < b.slot end)
    return list
end
function Play.zone()
    local level = Loader and Loader.LevelData or Data.Levels and Data.Levels[levelId()]
    local map = level and level.map
    local profile = map and S.positionProfiles[map]
    if profile and profile.zone then return profile.zone end
    return map and S.mapZones[map] or S.playZone
end
function Play.config()
    local rule = StagePlans.resolve(S.stagePlans, Loader and Loader.LevelData, S.difficulty)
    return AutoplayPolicy.normalize(rule and rule.autoplay, { zone = Play.zone(), maxUnits = S.maxUnits, reserve = S.cashReserve, farmsFirst = S.farmsFirst })
end
function Play.suggestSpot(record, zone)
    local cell = findSpot(record, zone or "Auto")
    return cell and cell.position
end
function Play.atPoint(item, position)
    local core = Services.PlacementCore
    if not core or not core._initialized then return false end
    local params = RaycastParams.new(); params.FilterType = Enum.RaycastFilterType.Include
    params.FilterDescendantsInstances = { core.GroundRaycastParts, core.HillRaycastParts }
    local hit = workspace:Raycast(position + Vector3.new(0, 15, 0), Vector3.new(0, -60, 0), params)
    if not hit or not core.is_valid_raycast_hit(hit.Instance, item.record) then setAction("Slot " .. item.slot .. ": saved point has the wrong terrain"); return false end
    local before = {}; for _, unit in ipairs(myUnits()) do before[unit] = true end
    call("spawn_unit", item.uuid, CFrame.new(hit.Position))
    local deadline = os.clock() + 1.5
    repeat
        for _, unit in ipairs(myUnits()) do
            if not before[unit] and unitId(unit) == item.id and (unit:GetPivot().Position - hit.Position).Magnitude < 5 then return true end
        end
        task.wait(0.1)
    until os.clock() >= deadline
    setAction("Slot " .. item.slot .. ": saved point not accepted; check position or cooldown")
    return false
end
function Play.upgrade(units, equipped, config)
    if config.upgrade == "Disabled" then return false end
    local byUuid, byId = {}, {}
    for _, item in ipairs(equipped) do byUuid[item.uuid] = item.slot; byId[item.id] = item.slot end
    local candidates = {}
    for _, option in ipairs(bestUpgrades(units)) do
        local slot = byUuid[unitStat(option.unit, "uuid")] or byId[unitId(option.unit)]
        if slot and AutoplayPolicy.canUpgrade(config, slot, unitStat(option.unit, "upgrade") or 0) then
            option.slot = slot
            table.insert(candidates, option)
        end
    end
    table.sort(candidates, function(a,b)
        if config.farmsFirst and (a.kind == "farm") ~= (b.kind == "farm") then return a.kind == "farm" end
        if not config.farmsFirst and (a.kind == "farm") ~= (b.kind == "farm") then return a.kind ~= "farm" end
        if config.upgrade == "Cheapest" then return a.cost < b.cost end
        if config.upgrade == "Unit priority" then
            local x,y = config.units[tostring(a.slot)].priority,config.units[tostring(b.slot)].priority
            if x ~= y then return x < y end
        elseif config.upgrade == "Lowest level" then
            local x,y = unitStat(a.unit,"upgrade") or 0,unitStat(b.unit,"upgrade") or 0
            if x ~= y then return x < y end
        end
        return (a.value or 0) > (b.value or 0)
    end)
    for _, option in ipairs(candidates) do
        if option.cost <= cash() - config.reserve then
            local level = unitStat(option.unit,"upgrade")
            call("upgrade_unit_ingame",option.unit); task.wait(.2)
            if unitStat(option.unit,"upgrade") ~= level then setAction("Upgraded slot " .. option.slot .. " · " .. config.upgrade); return true end
        end
    end
    return false
end
function Play.step()
    local units, equipped, config = myUnits(), Play.equipped(), Play.config()
    sampleDamage(units)
    if #units < config.maxUnits then
        local options = {}
        for _, item in ipairs(equipped) do
            local count = 0
            for _, unit in ipairs(units) do if unitId(unit) == item.id then count += 1 end end
            local cost = tonumber(item.record.cost) or math.huge
            if AutoplayPolicy.eligible(config,item.slot,count,wave(),tonumber(item.record.spawn_cap)) and cost <= cash()-config.reserve then
                table.insert(options,{item=item,count=count,cost=cost})
            end
        end
        table.sort(options,function(a,b)
            local fa,fb = isFarm(a.item.record),isFarm(b.item.record)
            if config.farmsFirst and fa ~= fb then return fa end
            local pa,pb=config.units[tostring(a.item.slot)].priority,config.units[tostring(b.item.slot)].priority
            if pa ~= pb then return pa < pb end
            return a.count < b.count
        end)
        for _, option in ipairs(options) do
            local mode,zone,point=AutoplayPolicy.position(config,option.item.slot,isFarm(option.item.record),option.count,#units)
            local key=currentPlanKey()..":"..option.item.slot
            local failure=Play.failures[key]
            if not failure or os.clock()>=failure then
                local ok=false
                if mode=="Exact" then
                    if point then ok=Play.atPoint(option.item,Vector3.new(table.unpack(point)))
                    else setAction("Slot "..option.item.slot..": add exact points or choose Auto")end
                else
                    local anchor=mode=="Area" and point and Vector3.new(table.unpack(point)) or nil
                    if mode=="Area" and not anchor then setAction("Slot "..option.item.slot..": pick an area center")
                    else ok=placeUnit(option.item.uuid,option.item.record,zone,anchor,config.radius)end
                end
                if ok then Play.failures[key]=nil;setAction("Placed slot "..option.item.slot.." · "..zone);return end
                Play.failures[key]=os.clock()+8
            end
        end
    end
    if Play.upgrade(units,equipped,config)then return end
    if not H.action:find("Slot",1,true)then setAction("Waiting for this stage's placement / upgrade rules")end
end

H.autoplay, H.autoplayPolicy = Play, AutoplayPolicy
local Abilities = { lastCast = setmetatable({}, { __mode = "k" }), rukiaIndex = 1 }
local function bossAlive()
    local folder = workspace:FindFirstChild("_UNITS")
    for _, unit in ipairs(folder and folder:GetChildren() or {}) do
        if unitStat(unit, "player") == nil and (unitStat(unit, "is_boss") == true or unitStat(unit, "boss") == true) then return true end
    end
    return false
end
-- Read observed charge and readiness; never treat a rejected RPC as a cooldown.
-- Read observed charge and readiness; never treat a rejected RPC as a cooldown.
local Smart = { current = nil, nextCast = 0, status = {}, meters = setmetatable({}, { __mode = "k" }), dazaiUntil = 0 }
H.smartAbilities = Smart
function Smart.number(unit, tokens)
    local statsFolder = unit:FindFirstChild("_stats")
    for _, root in ipairs({ unit, statsFolder or unit }) do
        for key, value in pairs(root:GetAttributes()) do
            local normalized = key:lower():gsub("[^%a]", "")
            for _, token in ipairs(tokens) do if normalized:find(token, 1, true) and type(value) == "number" then return value end end
        end
    end
    for _, node in ipairs(statsFolder and statsFolder:GetDescendants() or {}) do
        if node:IsA("NumberValue") or node:IsA("IntValue") then
            local normalized = node.Name:lower():gsub("[^%a]", "")
            for _, token in ipairs(tokens) do if normalized:find(token, 1, true) then return node.Value end end
        end
    end
    return nil
end
function Smart.ready(unit)
    if unitStat(unit, "active_queued_or_using") == true then return false end
    local remaining = tonumber(unitStat(unit, "active_attack_cooldown_remaining"))
    if remaining and remaining > 0 then return false end
    return type(unitStat(unit, "active_attack")) == "string" and unitStat(unit, "active_attack") ~= ""
end
function Smart.rukia(units)
    local choices = {}
    for _, unit in ipairs(units) do
        if unitId(unit):find("rukia_bankai", 1, true) then
            local charge = Smart.number(unit, { "charge", "gauge", "meter", "energy" })
            local meter = Smart.meters[unit]
            if not meter then meter = { observed = os.clock() }; Smart.meters[unit] = meter end
            if charge == nil then
                charge = meter.cast and math.clamp((os.clock() - meter.cast - 20) * 2.5, 0, 100)
                    or math.clamp((os.clock() - meter.observed) * 2.5, 0, 100)
            end
            table.insert(choices, { unit = unit, charge = charge })
        end
    end
    if #choices == 0 then Smart.status.Rukia = "No Snow Reaper placed"; return end
    for _, item in ipairs(choices) do
        local meter = Smart.meters[item.unit]
        if item.unit == Smart.current and meter and meter.cast and os.clock() - meter.cast < 20 then
            Smart.status.Rukia = "Current bar: " .. math.floor(item.charge); return
        end
    end
    table.sort(choices, function(a, b) return (a.charge or -1) > (b.charge or -1) end)
    local best = choices[1]
    if best.charge < 100 then Smart.current = nil; Smart.status.Rukia = "Recharging: " .. math.floor(best.charge); return end
    if not Smart.ready(best.unit) then Smart.status.Rukia = "Waiting for a supported active ability"; return end
    if os.clock() < Smart.nextCast then return end
    Smart.nextCast = os.clock() + 3
    local ok = call("use_active_attack", best.unit)
    if ok then Smart.current = best.unit; Smart.meters[best.unit].cast = os.clock(); Smart.status.Rukia = "Activated; charge or wiki-timed rotation" end
end
function Smart.dazai(units)
    if os.clock() < Smart.dazaiUntil then Smart.status.Dazai = "Global cooldown: " .. math.ceil(Smart.dazaiUntil - os.clock()) .. "s"; return end
    local candidates = {}
    local folder = workspace:FindFirstChild("_UNITS")
    for _, enemy in ipairs(folder and folder:GetChildren() or {}) do
        if unitStat(enemy, "player") == nil and unitStat(enemy, "id") then
            local special = (tonumber(unitStat(enemy, "shield")) or 0) > 0
            for _, flag in ipairs({ "flying", "is_flying", "armored", "is_armored", "fire", "ice", "fire_immune", "ice_immune" }) do
                if unitStat(enemy, flag) == true or enemy:GetAttribute(flag) == true then special = true end
            end
            local traits = enemy:FindFirstChild("_traits") or enemy:FindFirstChild("_traits", true)
            if traits and #traits:GetChildren() > 0 then special = true end
            if special then table.insert(candidates, enemy) end
        end
    end
    if #candidates == 0 then Smart.status.Dazai = "No enemy passive needs nullifying"; return end
    for _, unit in ipairs(units) do
        if unitId(unit):find("dazai", 1, true) and Smart.ready(unit) and os.clock() >= (Abilities.lastCast[unit] or 0) then
            local range = tonumber(unitStat(unit, "range")) or 0
            for _, enemy in ipairs(candidates) do
                if (enemy:GetPivot().Position - unit:GetPivot().Position).Magnitude <= range then
                    Abilities.lastCast[unit] = os.clock() + math.max(3, tonumber(unitStat(unit, "active_attack_cooldown")) or 10)
                    local ok = call("use_active_attack", unit)
                    if ok then Smart.dazaiUntil = os.clock() + 90 end
                    Smart.status.Dazai = "Nullifier cast; 90s global cooldown"; return
                end
            end
        end
    end
    Smart.status.Dazai = "Waiting for Dazai readiness / range"
end

function Abilities.step(units)
    if S.autoRukia then Smart.rukia(units) end
    if S.autoDazai then Smart.dazai(units) end
    if not S.autoAbility or (S.abilityBossOnly and not bossAlive()) then return end
    for _, unit in ipairs(units) do
        local id = unitId(unit)
        if not (S.autoRukia and id:find("rukia_bankai", 1, true)) and not (S.autoDazai and id:find("dazai", 1, true)) then
            if Smart.ready(unit) and os.clock() >= (Abilities.lastCast[unit] or 0) then
                Abilities.lastCast[unit] = os.clock() + math.max(3, tonumber(unitStat(unit, "active_attack_cooldown")) or 10)
                call("use_active_attack", unit)
            end
        end
    end
end

local Cards = {}
function Cards.score(card)
    local score = card.option_type == "Good" and 100 or 0
    local candy = 0
    for _, effect in ipairs(card.effects or {}) do
        if effect.type == "candy_multiplier" then candy += tonumber(effect.amount) or 0 end
        if effect.type == "stat_mul" then
            local weights = { damage = 30, attack_cooldown = 25, range = 15 }
            local amount = tonumber(effect.amount) or 0
            if effect.stat == "attack_cooldown" then amount = 1 / math.max(0.1, 1 + amount) - 1 end
            score += (weights[effect.stat] or 8) * amount * 10
        end
        if effect.type == "unit_cost" then score -= (tonumber(effect.amount) or 0) * 200 end
        if effect.type == "enemy_speedup" then score -= 30 end
        if effect.type == "enemy_stat_mul" then score -= 40 * (tonumber(effect.amount) or 0) end
        if effect.type == "enemy_resistance_specific" then score -= 0.3 * (tonumber(effect.amount) or 0) end
        if tostring(effect.type):find("regen", 1, true) then score -= 18 end
        if tostring(effect.type):find("shield", 1, true) or tostring(effect.type):find("immune", 1, true) then score -= 35 end
    end
    if S.cardMode == "Candy" or (S.cardMode == "Buffs, then Candy" and Carry.merges > 0) then
        score = candy * 300 + (card.option_type == "Good" and 20 or 0)
    end
    return score
end
onServer("show_roguelike_options", function(_, options)
    if S.pauseAll or (not S.autoCards and not (S.kaitun and isApril())) then return end
    local rule = StagePlans.resolve(S.stagePlans, Loader and Loader.LevelData, S.difficulty)
    if type(options) ~= "table" then return end
    local bestKey, bestScore
    for key, card in pairs(options) do
        local score = Cards.score(card)
        if not bestScore or score > bestScore then bestKey, bestScore = key, score end
    end
    if bestKey then
        task.wait(0.6)
        call("select_roguelike_option", tostring(bestKey))
        setAction("Picked card " .. tostring(options[bestKey].title))
    end
end)
local Recorder = { frames = {} }
onServer("game_finished", function(...)
    H.lastResult = select(1, ...)
    local ok, text = pcall(HttpService.JSONEncode, HttpService, table.pack(...))
    log("Game finished: " .. (ok and text:sub(1, 300) or "?"))
    writeJSON(FOLDER .. "/last_finish.json", { payload = ok and text:sub(1, 4000) or "?", frames = Recorder.frames })
end)
spawnLoop(function()
    while H.alive do
        pcall(function()
            if isLobby() or not workspace:FindFirstChild("_BASES") then return end
            local base = workspace._BASES:FindFirstChild("player")
            local fake = base and base:FindFirstChild("fake_unit", true)
            local humanoid = fake and fake:FindFirstChildOfClass("Humanoid")
            if not humanoid then return end
            local basePosition = fake:GetPivot().Position
            local near, total = {}, 0
            local folder = workspace:FindFirstChild("_UNITS")
            for _, unit in ipairs(folder and folder:GetChildren() or {}) do
                if unit:IsA("Model") and unitStat(unit, "player") == nil and unitStat(unit, "id") then
                    total += 1
                    local ok, pivot = pcall(unit.GetPivot, unit)
                    if ok and (pivot.Position - basePosition).Magnitude < 40 then
                        local hum = unit:FindFirstChildOfClass("Humanoid")
                        table.insert(near, tostring(unitStat(unit, "id")) .. ":" .. math.floor(hum and hum.Health or -1))
                    end
                end
            end
            local pve = workspace._BASES:FindFirstChild("pve")
            local pveFake = pve and pve:FindFirstChild("fake_unit", true)
            local pveHumanoid = pveFake and pveFake:FindFirstChildOfClass("Humanoid")
            table.insert(Recorder.frames, string.format("%s w%d hp=%d pve=%d enemies=%d near=[%s]", os.date("%M:%S"), wave(), humanoid.Health,
                pveHumanoid and pveHumanoid.Health or -1, total, table.concat(near, ",")))
            if #Recorder.frames > 90 then table.remove(Recorder.frames, 1) end
        end)
        task.wait(1)
    end
end)
local function enemyCount()
    local count = 0
    local folder = workspace:FindFirstChild("_UNITS")
    for _, unit in ipairs(folder and folder:GetChildren() or {}) do
        if unitStat(unit, "player") == nil and unitStat(unit, "id") then count += 1 end
    end
    return count
end
onServer("start_vote_wave_skip", function()
    if S.pauseAll then return end
    local rule = StagePlans.resolve(S.stagePlans, Loader and Loader.LevelData, S.difficulty)
    if not (S.autoSkip or (S.kaitun and isApril())) then return end
    if S.stopSkipWave>0 and wave()>=S.stopSkipWave then return end
    if S.kaitun and isApril() then
        for _ = 1, 20 do
            if enemyCount() <= 3 then break end
            task.wait(1)
        end
        if enemyCount() > 3 then return end
    end
    fire("vote_wave_skip")
end)

local function httpRequest(options)
    local send = request or http_request or (syn and syn.request) or (http and http.request)
    if type(send) ~= "function" then return false, "HTTP unavailable" end
    local ok, response = pcall(send, options)
    if not ok then return false, tostring(response) end
    local status = tonumber(response.StatusCode or response.Status)
    return status and status >= 200 and status < 300, status
end
local function webhook(title, fields, color)
    local url = S.webhookUrl:match("^%s*(.-)%s*$")
    if not url:match("^https://[%w%.]*discord%.com/api/webhooks/") and not url:match("^https://[%w%.]*discordapp%.com/api/webhooks/") then return false, "Enter a Discord webhook URL" end
    local list = {}
    for _, field in ipairs(fields) do table.insert(list, { name = field[1], value = tostring(field[2]), inline = true }) end
    return httpRequest({ Url = url, Method = "POST", Headers = { ["Content-Type"] = "application/json" },
        Body = HttpService:JSONEncode({ username = "CometHub", content = S.webhookPing and "@everyone" or nil,
            embeds = { { title = title, color = color or 0x7aa2ff, fields = list, footer = { text = "Anime Adventures · " .. player.Name },
                timestamp = DateTime.now():ToIsoDate() } } }) })
end
H.webhook = webhook

local Modes
local Match = { finishedHandled = false, matches = 0 }
local Lobby = { nextJoin = 0 }
H.lobby = Lobby
local function afterMatch()
    if Match.finishedHandled then return end
    Match.finishedHandled = true
    if not Match.resultLogged then
    Match.resultLogged=true
    Match.matches += 1
    local base = workspace:FindFirstChild("_BASES") and workspace._BASES:FindFirstChild("player")
    local humanoid = base and base:FindFirstChild("fake_unit", true) and base:FindFirstChild("fake_unit", true):FindFirstChildOfClass("Humanoid")
    local run = { wave = wave(), hp = humanoid and math.floor(humanoid.Health) or -1, coins = aprilCoins() - (Match.startCoins or aprilCoins()),
        minutes = math.floor((os.clock() - (Match.startClock or os.clock())) / 6) / 10, merges = Carry.merges, at = os.date("%H:%M") }
    local history = readJSON(FOLDER .. "/runs.json") or {}
    table.insert(history, run)
    writeJSON(FOLDER .. "/runs.json", history)
    log(string.format("Run ended: wave %d, base %d, +%d coins, %.1f min, %d merges", run.wave, run.hp, run.coins, run.minutes, run.merges))
    if S.webhookMatch then
        task.spawn(webhook, "Match finished", { { "Stage", levelName(levelId()) }, { "Wave", wave() }, { "April Coins", aprilCoins() },
            { "Gems", readValue(stats(), "gem_amount", 0) }, { "Session matches", Match.matches } })
    end
    end
    if not H.alive or S.pauseAll then Match.finishedHandled = false; return end
    if S.kaitun and isApril() and S.kaitunReplay then
        setAction("Returning to lobby")
        for _ = 1, 3 do
            if not H.alive or S.pauseAll or isLobby() then return end
            local ok = call("teleport_back_to_lobby")
            if not ok then setAction("Retrying lobby teleport") end
            task.wait(5)
        end
        Match.finishedHandled=false
        return
    end
    local level = Loader and Loader.LevelData
    if not S.endActionExplicit and level and level._gamemode == "infinite_tower" and S.towerNext and H.lastResult and H.lastResult.victory == true then
        local actual = tonumber(level._infinite_tower_floor or level.floor) or S.towerFloor
        S.towerFloor = actual + 1; save()
        setAction("Next Infinity Castle floor"); call("request_start_infinite_tower_from_game"); return
    end
    if not S.endActionExplicit and (Modes.isDungeon() or (S.autoContracts and Modes.isContract()) or S.autoWorthiness) then
        setAction("Returning to lobby for the next farming run"); call("teleport_back_to_lobby"); return
    end
    if not S.endActionExplicit and S.autoJoin and S.priority1 ~= "Selected Stage" and S.priority1 ~= "None" then
        setAction("Returning to lobby for the priority list"); call("teleport_back_to_lobby"); return
    end
    local remote, argument
    if S.afterMatch == "Replay" then remote,argument="set_game_finished_vote","replay"
    elseif S.afterMatch == "Next" then remote,argument="set_game_finished_vote","next_story"
    elseif S.afterMatch == "Lobby" then remote="teleport_back_to_lobby" end
    if remote then
        for _=1,3 do
            if not H.alive or S.pauseAll or gameData("GameFinished") ~= true then return end
            setAction(S.afterMatch == "Replay" and "Voting replay" or S.afterMatch == "Next" and "Voting next stage" or "Returning to lobby")
            if argument then call(remote,argument) else call(remote) end
            task.wait(5)
        end
        Match.finishedHandled=false
    end
end

local Macro = { recording = false, actions = {}, units = {}, playing = false, generation = 0, pending = 0 }
local function macroPath(name)
    if type(name) ~= "string" or not name:match("^[%w_%- ]+$") then return nil end
    return MACRO_FOLDER .. "/" .. name .. ".json"
end
function Macro.list()
    local names = {}
    if disk and type(listfiles) == "function" then
        for _, path in ipairs(listfiles(MACRO_FOLDER)) do
            local name = path:match("([^/\\]+)%.json$")
            if name and macroPath(name) then table.insert(names, name) end
        end
    end
    table.sort(names); return names
end
function Macro.indexOf(unit)
    for index, known in pairs(Macro.units) do if known == unit then return index end end
end
function Macro.capture(name, args)
    if not Macro.recording then return end
    local action = { t = os.clock() - Macro.started, wave = wave(), failed = true }
    if name == "spawn_unit" then
        local col = collection()
        local profile = col and col.collection_profile_data
        local record = profile and profile.owned_units[args[1]] or col and col.temporary_units[args[1]]
        if not record or typeof(args[2]) ~= "CFrame" then return end
        Macro.sequence += 1
        action.type, action.unit, action.cf, action.index = "place", record.unit_id, { args[2]:GetComponents() }, Macro.sequence
        local before = {}; for _, unit in ipairs(myUnits()) do before[unit] = true end
        table.insert(Macro.actions, action)
        Macro.pending += 1
        local generation = Macro.generation
        task.spawn(function()
            local deadline = os.clock() + 6
            repeat
                for _, unit in ipairs(myUnits()) do
                    if not before[unit] and unitId(unit) == record.unit_id and not Macro.indexOf(unit)
                        and (unit:GetPivot().Position - args[2].Position).Magnitude < 6 then
                        action.failed = false; Macro.units[action.index] = unit; Macro.pending -= 1; return
                    end
                end
                task.wait(0.05)
            until os.clock() >= deadline or generation ~= Macro.generation or not H.alive
            action.failed = true; Macro.pending -= 1
        end)
    else
        local kinds = { upgrade_unit_ingame = "upgrade", sell_unit_ingame = "sell", use_active_attack = "ability", change_priority = "priority" }
        local unit = typeof(args[1]) == "Instance" and args[1]
        if not kinds[name] or not unit then return end
        local index = Macro.indexOf(unit)
        if not index or unitStat(unit,"player") ~= player then return end
        if name == "use_active_attack" and not Smart.ready(unit) then return end
        local beforeLevel = unitStat(unit,"upgrade") or 0
        local beforePriority = unitStat(unit,"priority")
        local beforeCooldown = tonumber(unitStat(unit,"active_attack_cooldown_remaining")) or 0
        action.type, action.index, action.priority = kinds[name], index, args[2]
        action.expectedLevel = name == "upgrade_unit_ingame" and (beforeLevel + 1) or nil
        table.insert(Macro.actions, action)
        Macro.pending += 1
        local generation = Macro.generation
        task.spawn(function()
            local deadline = os.clock()+5
            repeat
                local accepted = false
                if action.type == "upgrade" then
                    accepted = (unitStat(unit,"upgrade") or 0) > beforeLevel
                elseif action.type == "sell" then
                    accepted = unit.Parent == nil or unit.Parent ~= workspace:FindFirstChild("_UNITS")
                elseif action.type == "priority" then
                    accepted = unitStat(unit,"priority") ~= beforePriority and unitStat(unit,"priority") == action.priority
                elseif action.type == "ability" then
                    accepted = unitStat(unit,"active_queued_or_using") == true
                        or (tonumber(unitStat(unit,"active_attack_cooldown_remaining")) or 0) > beforeCooldown
                end
                if accepted then action.failed=false; break end
                task.wait(.05)
            until os.clock() >= deadline or generation ~= Macro.generation or not H.alive
            Macro.pending -= 1
        end)
    end
end
function Macro.installHook()
    if env.CometAAHook then env.CometAAHook.target = Macro; return true end
    if type(hookmetamethod) ~= "function" or type(getnamecallmethod) ~= "function" then return false end
    local hook = { target = Macro }
    local watched = { spawn_unit = true, upgrade_unit_ingame = true, sell_unit_ingame = true, use_active_attack = true, change_priority = true }
    local original
    original = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if hook.target and hook.target.recording and (method == "InvokeServer" or method == "FireServer")
            and typeof(self) == "Instance" and self.Parent == c2s and watched[self.Name] then
            -- Capture synchronously before invocation; no yielding work lives in capture.
            pcall(hook.target.capture, self.Name, table.pack(...))
            if setnamecallmethod then setnamecallmethod(method) end
        end
        return original(self, ...)
    end)
    env.CometAAHook = hook; return true
end
function Macro.startRecording()
    if isLobby() then return false, "Join a match first" end
    if Macro.playing or Macro.pending > 0 then return false, "Wait for the current macro operation" end
    if not Macro.installHook() then return false, "Remote recording is unsupported by this executor" end
    Macro.generation += 1
    Macro.actions, Macro.units, Macro.started, Macro.recording, Macro.sequence = {}, {}, os.clock(), true, 0
    Macro.level = levelId(); return true
end
function Macro.stopRecording(name)
    Macro.recording = false
    local deadline = os.clock() + 6
    while Macro.pending > 0 and os.clock() < deadline do task.wait(0.05) end
    name = name and name ~= "" and name or (Macro.level .. "_" .. os.date("%m%d_%H%M"))
    name = name:gsub("[^%w_%- ]", "")
    local path = macroPath(name)
    if not path then return "Invalid name", 0 end
    local list, placed = {}, {}
    for _, action in ipairs(Macro.actions) do
        if not action.failed and (action.type == "place" or placed[action.index]) then
            table.insert(list, action)
            if action.type == "place" then placed[action.index]=true end
        end
    end
    if #list == 0 then return "No actions recorded", 0 end
    local firstTime = list[1].t or 0
    for _, action in ipairs(list) do action.t = math.max(0, (action.t or 0) - firstTime) end
    local key = currentPlanKey()
    if not writeJSON(path, { version = 3, level = Macro.level, scopeKey = key, created = os.time(), actions = list }) then return "Save failed", 0 end
    if S.bindRecordedMacro and key then StagePlans.bind(S.stagePlans, key, "Macro", name); save() end
    return name, #list
end
function Macro.stop()
    Macro.playing = false; Macro.generation += 1
end
function Macro.play(name)
    if Macro.recording or Macro.playing then return false, "A macro operation is already running" end
    local path = macroPath(name)
    local macro = path and readJSON(path)
    if type(macro) ~= "table" or type(macro.actions) ~= "table" then return false, "Macro not found" end
    if #macro.actions == 0 then return false, "Macro has no recorded actions" end
    if macro.scopeKey and macro.scopeKey ~= currentPlanKey() then return false, "Macro belongs to another stage, map, or difficulty" end
    if not macro.scopeKey and macro.level ~= levelId() then return false, "Macro belongs to another stage" end
    Macro.generation += 1
    local generation, started = Macro.generation, os.clock()
    Macro.playing, Macro.units = true, {}
    local function cancelled() return not H.alive or not Macro.playing or generation ~= Macro.generation or gameData("GameFinished") == true end
    spawnLoop(function()
        local ok, err = pcall(function()
            for index, action in ipairs(macro.actions) do
                if cancelled() then return end
                local deadline = os.clock() + 180
                while not cancelled() do
                    if S.macroTiming == "Wave" and wave() >= (action.wave or 0) then break end
                    if S.macroTiming == "Time" and os.clock() - started >= (action.t or 0) then break end
                    if os.clock() >= deadline then error("Timing timeout at action " .. index) end
                    task.wait(0.1)
                end
                if cancelled() then return end
                deadline = os.clock() + S.macroTimeout
                local done = false
                while not cancelled() and os.clock() < deadline and not done do
                    setAction("Macro " .. index .. "/" .. #macro.actions .. " · " .. action.type)
                    if action.type == "place" then
                        local item
                        for _, equipped in ipairs(Play.equipped()) do if equipped.id == action.unit then item = equipped; break end end
                        if not item then error("Missing equipped unit: " .. tostring(action.unit)) end
                        local cf = CFrame.new(table.unpack(action.cf))
                        for _, unit in ipairs(myUnits()) do
                            if unitId(unit) == action.unit and not Macro.indexOf(unit) and (unit:GetPivot().Position - cf.Position).Magnitude < 4 then
                                Macro.units[action.index] = unit; done = true; break
                            end
                        end
                        if not done and cash() >= (tonumber(item.record.cost) or math.huge) then call("spawn_unit", item.uuid, cf) end
                    else
                        local unit = Macro.units[action.index]
                        if not unit or not unit.Parent then error("Missing placed unit for action " .. index) end
                        if action.type == "upgrade" then
                            local level = unitStat(unit, "upgrade") or 0
                            if not action.expectedLevel then action.expectedLevel = level + 1 end
                            if level >= action.expectedLevel then done = true else
                                local cost = upgradeCost(unit)
                                if not cost then error("Unit cannot upgrade at action " .. index) end
                                if cash() >= cost then call("upgrade_unit_ingame", unit) end
                            end
                        elseif action.type == "sell" then call("sell_unit_ingame", unit); done = not table.find(myUnits(), unit)
                        elseif action.type == "ability" then done = call("use_active_attack", unit)
                        elseif action.type == "priority" then done = call("change_priority", unit, action.priority)
                        else error("Unknown macro action: " .. tostring(action.type)) end
                    end
                    task.wait(0.35)
                end
                if not done and not cancelled() then error("Action " .. index .. " timed out") end
            end
        end)
        Macro.playing = false
        if not ok then setAction("Macro stopped: " .. tostring(err)) else setAction("Macro finished") end
    end)
    return true
end
H.macro = Macro
H.api = { units = myUnits, placeUnit = placeUnit, call = call, hand = April.hand, upgradeCost = upgradeCost, levelId = levelId }


function Lobby.walkTo(position)
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    root.CFrame = CFrame.new(position + Vector3.new(0, 3, 0))
    return true
end
function Lobby.visible(gui)
    while gui and gui ~= player.PlayerGui and gui.Parent do
        if gui:IsA("GuiObject") and not gui.Visible then return false end
        if gui:IsA("ScreenGui") and not gui.Enabled then return false end
        if gui.Name == "PopupTemplate" then return false end
        gui = gui.Parent
    end
    return true
end
function Lobby.press(button)
    if not button or type(firesignal) ~= "function" then return false end
    for _, signal in ipairs({ "Activated", "MouseButton1Click", "MouseButton1Down" }) do
        local ok, connections = pcall(getconnections, button[signal])
        if not ok or #connections > 0 then pcall(firesignal, button[signal]); return true end
    end
    return false
end
function Lobby.queued()
    for _, rootName in ipairs({ "_EVENT_CHALLENGES", "_CHALLENGES", "_LOBBIES", "_DUNGEONS", "_PORTALS", "_MATCHMAKING" }) do
        local root = workspace:FindFirstChild(rootName)
        for _, node in ipairs(root and root:GetDescendants() or {}) do
            if node.Name == "Owner" and node:IsA("ObjectValue") and node.Value == player then return true, node.Parent end
            if node:IsA("ObjectValue") and node.Value == player and node.Parent and node.Parent.Name == "Players" then return true end
        end
    end
    return false
end
function Lobby.joinApril()
    if Lobby.pendingUntil and os.clock() < Lobby.pendingUntil then setAction("April matchmaking requested; waiting for teleport"); return true end
    if S.aprilJoinMode == "Matchmaking" then
        setAction("Requesting April Fools matchmaking")
        local ok, why = call("request_matchmaking", "april2_event")
        if ok then Lobby.pendingUntil = os.clock() + 45 else setAction("Matchmaking rejected: " .. tostring(why)) end
        Lobby.nextJoin = os.clock() + 8
        return ok
    end
    local root = workspace:FindFirstChild("_EVENT_CHALLENGES")
    local lobbies = root and root:FindFirstChild("Lobbies")
    for _, lobby in ipairs(lobbies and lobbies:GetChildren() or {}) do
        local level = tostring(readValue(lobby, "Level", ""))
        if level:find("april", 1, true) then
            setAction("Joining Fool's Hunt")
            call("request_join_lobby", lobby.Name)
            Lobby.nextJoin = os.clock() + 8
            return true
        end
    end
    setAction("Fool's Hunt lobby not found")
    return false
end
local challengeCache = {}
function Lobby.challengeOpen(kind)
    local cached = challengeCache[kind]
    if not cached or os.clock() - cached.at > 60 then
        local ok, data = call(kind == "Daily Challenge" and "get_daily_challenge" or "get_normal_challenge")
        cached = { at = os.clock(), uuid = ok and type(data) == "table" and data.current_uuid or nil }
        challengeCache[kind] = cached
    end
    local profile = session() and session().profile_data
    local done = profile and (kind == "Daily Challenge" and profile.last_completed_daily_challenge_uuid or profile.last_completed_challenge_uuid)
    if cached.uuid == nil or cached.uuid == done then return false end
    return (S.challengeTries[tostring(cached.uuid)] or 0) < 2, cached.uuid
end
function Lobby.joinChallenge(kind)
    local root = workspace:FindFirstChild("_CHALLENGES")
    local group = root and root:FindFirstChild(kind == "Daily Challenge" and "DailyChallenge" or "Challenges")
    for _, lobby in ipairs(group and group:GetChildren() or {}) do
        if lobby:FindFirstChild("Owner") and not readValue(lobby, "Teleporting", false) and not readValue(lobby, "Locked", false) then
            setAction("Joining " .. kind)
            call("request_join_lobby", lobby.Name)
            task.wait(1)
            call("request_start_game", lobby.Name)
            return true
        end
    end
    setAction("Waiting for a " .. kind .. " lobby")
    return false
end
function Lobby.joinTower()
    setAction("Starting Infinity Castle floor " .. S.towerFloor)
    call("request_start_infinite_tower", S.towerFloor, S.difficulty)
    return true
end
function Lobby.raidOpen()
    local data = workspace:FindFirstChild("_LOBBIES") and workspace._LOBBIES:FindFirstChild("_DATA")
    return readValue(data, "raid_open", false) == true, tostring(readValue(data, "current_active_raid", ""))
end
function Lobby.stageFor(kind, world, act)
    for _, stage in ipairs(STAGE_CATALOG) do
        if stage.kind == kind and stage.groupName == world and (act == "" or stage.label == act) then return stage end
    end
end
function Lobby.joinStage(override, options)
    local stage = override or Lobby.stageFor(S.joinKind, S.joinWorld, S.joinAct)
    if not stage then setAction("Select a world and act"); return false end
    local root = workspace:FindFirstChild("_LOBBIES")
    local free
    for _, group in ipairs(root and root:GetChildren() or {}) do
        if group.Name:lower():find("story", 1, true) then
            for _, lobby in ipairs(group:GetDescendants()) do
                if lobby:IsA("Model") and lobby:FindFirstChild("Owner") then
                    local owner = readValue(lobby, "Owner", nil)
                    if owner == player then free = lobby break end
                    if owner == nil and not free and not readValue(lobby, "Teleporting", false) then free = lobby end
                end
            end
        end
        if free and readValue(free, "Owner", nil) == player then break end
    end
    if not free then setAction("Waiting for a free lobby"); return false end
    setAction("Joining " .. stage.groupName .. " · " .. stage.label)
    if readValue(free, "Owner", nil) ~= player then
        call("request_join_lobby", free.Name)
        local deadline = os.clock() + 6
        repeat task.wait(0.1) until readValue(free, "Owner", nil) == player or os.clock() >= deadline
        if readValue(free, "Owner", nil) ~= player then setAction("Lobby ownership was not confirmed"); return false end
    end
    local difficulty = stage.kind == "Infinite" and "Hard" or options and options.difficulty or S.difficulty
    call("request_lock_level", free.Name, stage.id, false, difficulty)
    local deadline = os.clock() + 5
    repeat task.wait(0.1) until tostring(readValue(free, "Level", "")) == stage.id or os.clock() >= deadline
    if tostring(readValue(free, "Level", "")) ~= stage.id then
        call("request_leave_lobby", free.Name)
        setAction("Stage selection was rejected or is locked"); return false
    end
    call("request_start_game", free.Name)
    return true
end
function Lobby.rollBanner()
    if not S.autoBanner then return false end
    if os.clock() < (Lobby.nextBanner or 0) then return false end
    local banner = Data.Banners and Data.Banners.April2025
    if not banner or banner.active ~= true then setAction("April banner is unavailable"); return false end
    local cost = tonumber(banner.resource_cost and banner.resource_cost.amount) or 150
    local amount = S.bannerAmount == "x10" and 10 or 1
    if aprilCoins() - S.bannerReserve < cost * amount then return false end
    local before = {}
    local beforeCoins = aprilCoins()
    Lobby.nextBanner = os.clock() + 5
    local col = collection()
    for uuid in pairs(col and col.collection_profile_data.owned_units or {}) do before[uuid] = true end
    local ok = call("buy_from_banner", "April2025", amount == 10 and "gems10" or "gems")
    task.wait(1.5)
    local confirmed = aprilCoins() < beforeCoins
    for uuid in pairs(col and col.collection_profile_data.owned_units or {}) do if not before[uuid] then confirmed = true end end
    if not confirmed then setAction("April roll was not confirmed; waiting before retry"); return false end
    setAction("Rolled April banner " .. S.bannerAmount)
    if S.webhookSummon then
        local pulled = {}
        for uuid, unit in pairs(col and col.collection_profile_data.owned_units or {}) do
            if not before[uuid] then
                local record = unitRecord(unit.unit_id)
                table.insert(pulled, (record and record.name or unit.unit_id) .. (record and record.rarity and (" (" .. record.rarity .. ")") or ""))
            end
        end
        task.spawn(webhook, "April banner " .. S.bannerAmount, { { "Pulled", #pulled > 0 and table.concat(pulled, "\n") or "Items only" }, { "April Coins left", aprilCoins() } }, 0xffb84d)
    end
    return ok
end
-- Mode orchestration. No guessed destructive dungeon purchases or shrine sacrifices.
local DungeonPolicy = (function()
local DungeonPolicy = {}
function DungeonPolicy.roomScore(choice, types, resources, depth, priority)
    local tags = choice._t or {}
    local score = 0
    if tags[types.CURSE] then score -= 120 end
    if tags[types.TREASURE_GOLD] then score += 70 end
    if tags[types.TREASURE] then score += 35 end
    if tags[types.MONEY] then score += 25 end
    if tags[types.SHOP] then score += (tonumber(resources.money) or 0) >= 300 and 55 or 5 end
    if tags[types.OPEN_CHEST] then score += (depth >= 19 and (tonumber(resources.treasure_gold) or 0) > 0) and 100 or 4 end
    if tags[types.SHRINE] then score += 10 end
    for tag,rank in pairs(priority or {})do
        rank=tonumber(rank) or 0
        if rank>0 and tags[tag] then score+=(100-rank)*10000 end
    end
    score -= tonumber(choice._l and choice._l._lobby_difficulty_scale) or 0
    return score
end
function DungeonPolicy.choose(choices, types, resources, depth, priority)
    local best, score
    for key, choice in pairs(choices or {}) do
        if type(choice) == "table" and choice._l and choice._l._dungeon then
            local value = DungeonPolicy.roomScore(choice, types, resources, depth, priority)
            local future = choices["next" .. tostring(key)]
            local nextBest
            for _, nextChoice in pairs(type(future) == "table" and future or {}) do
                if type(nextChoice) == "table" and nextChoice._l then
                    local nextScore = DungeonPolicy.roomScore(nextChoice, types, resources, depth + 1)
                    nextBest = math.max(nextBest or -math.huge, nextScore)
                end
            end
            value += (nextBest or 0) * 0.35
            if not best or value > score then best, score = tostring(key), value end
        end
    end
    return best
end
function DungeonPolicy.itemValue(item)
    if not item or (tonumber(item.curse_chance) or 0) > 0 or (tonumber(item.curse_super_chance) or 0) > 0 then return nil end
    local score = (tonumber(item.luck_increase) or 0) * 80
    for _, effect in ipairs(item.wave_modifier_effects or {}) do
        local amount = tonumber(effect.amount) or 0
        if effect.type == "stat_mul" then
            if effect.stat == "attack_cooldown" or effect.stat == "cost" or effect.stat == "upgrade_cost" then score -= amount * 100
            elseif effect.stat == "damage" then score += amount * 100
            elseif effect.stat == "range" then score += amount * 40 end
        elseif effect.type == "unit_cost" then score -= amount * 180
        elseif effect.type == "stat_add" and effect.stat == "physical_crit_chance" then score += amount * 40 end
    end
    if score <= 0 then return nil end
    return score / math.max(1, tonumber(item.cost) or 1)
end
return DungeonPolicy

end)()
Modes = { retryAt = 0, status = {}, started = {}, shopSeen = {} }
H.modes = Modes
function Modes.note(mode, message)
    Modes.status[mode] = message
    setAction(message)
end
function Modes.isDungeon()
    return Loader and Loader.LevelData and Loader.LevelData._dungeon ~= nil
end
function Modes.isContract()
    return Loader and Loader.LevelData and Loader.LevelData._event_contract ~= nil
end
function Modes.button(root, names)
    if not root then return nil end
    for _, node in ipairs(root:GetDescendants()) do
        if node:IsA("GuiButton") and Lobby.visible(node) and table.find(names, node.Name) then return node end
    end
end
function Modes.dungeon()
    local profile = session() and session().profile_data
    local dungeon = profile and profile.dungeon_data
    local gui = Services.GUIService and Services.GUIService.dungeon_ui
    if not dungeon or not gui then Modes.note("Dungeon", "Dungeon service is still loading"); return false end
    if dungeon._dead then Modes.note("Dungeon", "Dungeon run ended; no automatic reset"); return false end
    if not dungeon._started then
        if not S.dungeonAutoStart then Modes.note("Dungeon","Auto Start Dungeon is off");return false end
        Modes.note("Dungeon", "Starting dungeon")
        call("dungeon_start"); Modes.retryAt = os.clock() + 5; return true
    end
    if not gui.IsOpen then gui:toggle(true) end
    gui:refresh()
    for _, name in ipairs({ "ShopSelection", "ShrineRoom", "OpenTreasure", "YouDied" }) do
        local state = gui[name]
        if state and Lobby.visible(state) then
            local button
            if name == "ShopSelection" and S.dungeonShop then
                local bestButton, bestScore, bestId
                local core = Services.DungeonServiceCore
                local money = tonumber(dungeon._resources and dungeon._resources.money) or 0
                for _, frame in ipairs(state:GetDescendants()) do
                    if frame:IsA("Frame") and frame.Name == "SellFrame" then
                        local label = frame:FindFirstChild("ItemName", true)
                        for id, item in pairs(core and core.ITEMS or {}) do
                            local value = DungeonPolicy.itemValue(item)
                            local rank=tonumber(S.dungeonShopPriority[id]) or 0
                            if value and rank>0 then value+=(100-rank)*1000 end
                            local stamp = tostring(dungeon.depth_reached) .. ":" .. tostring(id)
                            if label and label.Text == item.name and value and (not S.dungeonSelectedShopOnly or S.dungeonShopItems[id]) and (tonumber(item.cost) or math.huge) <= money
                                and os.clock() >= (Modes.shopSeen[stamp] or 0) and (not bestScore or value > bestScore) then
                                local buy = Modes.button(frame, { "Buy", "Button" })
                                if buy then bestButton, bestScore, bestId = buy, value, stamp end
                            end
                        end
                    end
                end
                if bestButton then
                    Modes.shopSeen[bestId] = os.clock() + 8
                    Lobby.press(bestButton); Modes.retryAt = os.clock() + 2
                    Modes.note("Dungeon", "Buying a beneficial dungeon blessing"); return true
                end
            elseif name == "OpenTreasure" then
                local resources = dungeon._resources or {}
                local final = (tonumber(dungeon.depth_reached) or 0) >= S.dungeonChestDepth
                local gold = (tonumber(resources.treasure_gold) or 0) > 0 and (final or not S.dungeonKeepRare)
                local normal = (tonumber(resources.treasure) or 0) > 0 and (S.dungeonOpenNormal or final)
                local frame = state:FindFirstChild(gold and "ChestFrameRare" or "ChestFrameNormal", true)
                if gold or normal then button = Modes.button(frame, { "Open" }) end
            end
            if name=="ShrineRoom" then
                local allowed,identified=false,false
                if S.dungeonAcceptShrine then
                    for id,item in pairs(Services.DungeonServiceCore and Services.DungeonServiceCore.ITEMS or {})do
                        if tostring(id):find("_curse",1,true) then
                            for _,label in ipairs(state:GetDescendants())do
                                if label:IsA("TextLabel") and label.Text:find(item.name,1,true)then
                                    identified=true
                                    allowed=not S.dungeonDeclineCurses[id]
                                    break
                                end
                            end
                            if identified then break end
                        end
                    end
                end
                button=Modes.button(state,allowed and {"Yes","Accept"} or {"No"})
            else button=button or Modes.button(state,{"Continue"}) end
            if button then
                Modes.note("Dungeon", "Continuing dungeon " .. name)
                Lobby.press(button); Modes.retryAt = os.clock() + 4; return true
            end
        end
    end
    if (tonumber(dungeon.depth_reached) or 0) >= S.dungeonMaxDepth then Modes.note("Dungeon", "Dungeon depth target reached"); return false end
    local core = Services.DungeonServiceCore
    local best = DungeonPolicy.choose(dungeon.next, core and core.TYPES or {}, dungeon._resources or {}, tonumber(dungeon.depth_reached) or 0,S.dungeonRoomPriority)
    local selected = dungeon.selected_next and dungeon.selected_next.choice_str
    if selected then best = tostring(selected) end
    if not best then Modes.note("Dungeon", "Waiting for dungeon room choices"); return false end
    Modes.note("Dungeon", "Entering dungeon room " .. best)
    local ok = call("dungeon_enter_room", best)
    Modes.retryAt = os.clock() + 15
    if ok then Lobby.pendingUntil = os.clock() + 35 end
    return ok
end
function Modes.contract()
    local service = Services.EventContractsServiceClient
    local gui = Services.GUIService and Services.GUIService.contracts_ui
    if not service or not gui then Modes.note("Contracts", "Contracts are still loading"); return false end
    local windows = player.PlayerGui:FindFirstChild("NotificationWindows")
    local popups = windows and windows:FindFirstChild("Popups")
    local confirm = popups and popups:FindFirstChild("OpenPortalWindow")
    if Modes.contractPending and confirm and Lobby.visible(confirm) then
        local button = Modes.button(confirm, { "Yes" })
        if button then
            Lobby.press(button); Modes.contractPending = nil
            Modes.retryAt = os.clock() + 3
            Modes.note("Contracts", "Opening selected Contract portal"); return true
        end
    end
    if type(gui.refresh_all_completed) == "function" then gui:refresh_all_completed() end
    local best, bestKey, score
    for key, contract in pairs(service.CURRENT_CONTRACTS or {}) do
        local tier = tonumber(contract._portal_depth) or 0
        local entry = gui.ContractFrames and gui.ContractFrames[tostring(key)]
        local cleared = entry and entry.frame and entry.frame:FindFirstChild("Cleared", true)
        if tier <= S.contractTier and not (S.contractSkipCleared and cleared and cleared.Visible) then
            if not best or tier > score then best, bestKey, score = contract, tostring(key), tier end
        end
    end
    if not best then Modes.note("Contracts", "No uncleared contract within the tier limit"); return false end
    if not gui.IsOpen then gui:toggle(true); Modes.retryAt = os.clock() + 1; return true end
    local entry = gui.ContractFrames and gui.ContractFrames[bestKey]
    local button = entry and Modes.button(entry.frame, { "OpenPortal" })
    if not button then Modes.note("Contracts", "Contract portal button unavailable"); return false end
    Lobby.press(button)
    Modes.contractPending = best.id
    Modes.retryAt = os.clock() + 1
    Modes.note("Contracts", "Selected Contract tier " .. score)
    return true
end
function Modes.worthiness()
    local target
    for _, stage in ipairs(STAGE_CATALOG) do
        local record = Data.Levels and Data.Levels[stage.id]
        if stage.kind == "Infinite" and record and record.map == "aot" then target = stage; break end
    end
    if not target then Modes.note("Worthiness", "AOT Infinite is unavailable in this game's catalog"); return false end
    Modes.note("Worthiness", "Joining AOT Infinite for takedowns")
    local ok = Lobby.joinStage(target)
    Modes.retryAt = os.clock() + 12
    return ok
end
function Modes.step(activity)
    if os.clock() < Modes.retryAt then return true end
    if activity == "Dungeon" then return Modes.dungeon()
    elseif activity == "Assassin Contracts" then return Modes.contract()
    elseif activity == "AOT Worthiness" then return Modes.worthiness() end
    return false
end

local JoinPolicy=(function()
local Policy={kinds={World="Story",Legend="LegendaryStages",Raid="Raids",Infinite="Infinite",Event="Events"}}
function Policy.plan(settings)
    local enabled={
        ["Daily Challenge"]=settings.autoDailyChallenge,["Challenge"]=settings.autoChallenge,
        ["April Fools"]=settings.kaitun,["Infinity Castle"]=settings.autoTower,["Relic Shards"]=settings.autoRelic,
        ["Dungeon"]=settings.autoDungeon,["Assassin Contracts"]=settings.autoContracts,["AOT Worthiness"]=settings.autoWorthiness,
    }
    for activity,kind in pairs(Policy.kinds)do enabled[activity]=settings.joiners and settings.joiners[kind] and settings.joiners[kind].enabled==true end
    local plan={}
    local function add(activity)
        if enabled[activity] and not table.find(plan,activity)then table.insert(plan,activity)end
    end
    if settings.autoJoin then
        for _,key in ipairs({"priority1","priority2","priority3","priority4"})do add(settings[key])end
    end
    for _,activity in ipairs({"Daily Challenge","Challenge","April Fools","Dungeon","Assassin Contracts","AOT Worthiness","Infinity Castle","Relic Shards","World","Legend","Raid","Infinite","Event"})do add(activity)end
    return plan
end
return Policy

end)()
H.joinPolicy=JoinPolicy
function Lobby.step()
    if os.clock() < Lobby.nextJoin then return end
    if Lobby.pendingUntil and os.clock() < Lobby.pendingUntil then setAction("Matchmaking pending; waiting for teleport"); return end
    local queued, owned = Lobby.queued()
    if queued then
        local level = owned and tostring(readValue(owned, "Level", "")) or ""
        if owned and level:find("__EVENT_CONTRACT", 1, true) and not Modes.started[owned.Name] then
            Modes.started[owned.Name] = true
            call("request_start_game", owned.Name)
            Lobby.pendingUntil = os.clock() + 35
        end
        setAction("In queue, waiting for teleport"); Lobby.nextJoin = os.clock() + 3; return
    end
    if Lobby.rollBanner() then Lobby.nextJoin = os.clock() + 2; return end
    local kindByActivity=JoinPolicy.kinds
    local plan=JoinPolicy.plan(S)
    for _, activity in ipairs(plan) do
        if activity == "April Fools" then
            Lobby.joinApril(); return
        elseif activity == "Daily Challenge" or activity == "Challenge" then
            local open, uuid = Lobby.challengeOpen(activity)
            if open then
                if Lobby.joinChallenge(activity) then S.challengeTries[tostring(uuid)] = (S.challengeTries[tostring(uuid)] or 0) + 1; save() end
                Lobby.nextJoin = os.clock() + 20
                return
            end
        elseif activity == "Infinity Castle" then
            Lobby.joinTower(); Lobby.nextJoin = os.clock() + 15; return
        elseif activity == "Relic Shards" then
            local open, raid = Lobby.raidOpen()
            if open and raid:find("kai_planet", 1, true) then
                Lobby.joinStage({ id = "kai_planet_level_5", kind = "Raids", groupName = "Raid", label = "The Pure Form" })
                Lobby.nextJoin = os.clock() + 10; return
            end
        elseif activity == "Dungeon" or activity == "Assassin Contracts" or activity == "AOT Worthiness" then
            if Modes.step(activity) then return end
        elseif kindByActivity[activity] then
            local kind=kindByActivity[activity]
            local config=S.joiners[kind]
            local stage=Lobby.stageFor(kind,config.world,config.act)
            if stage then
                Lobby.joinStage(stage,config);Lobby.nextJoin=os.clock()+math.max(4,S.joinDelay);return
            end
        end
    end
end

local function matchStep()
    local rule = StagePlans.resolve(S.stagePlans, Loader and Loader.LevelData, S.difficulty)
    local kaitunEnabled = S.kaitun and isApril()
    local kaitun = kaitunEnabled and not rule
    local playback = (rule and rule.engine ~= "Off") or kaitun or Macro.playing
    if Match.finishedHandled and gameData("GameFinished") ~= true then
        Match.finishedHandled, Match.startClock, Match.macroStarted, Match.sold, Match.resultLogged, Match.farmsSold = false, nil, nil, nil, nil, nil
        Play.failures, April.failures, April.capped = {}, {}, nil
        Carry.id, Carry.merges, H.lastResult = nil, 0, nil
    end
    if gameData("GameFinished") == true then
        task.spawn(afterMatch)
        return
    end
    Match.finishedHandled = false
    if not Match.startClock and gameData("GameStarted") == true then Match.startClock, Match.startCoins = os.clock(), aprilCoins() end
    if (S.autoStart or kaitunEnabled) and gameData("GameStarted") == false then
        if os.clock() - (Match.lastVote or 0) > 3 then Match.lastVote = os.clock(); call("vote_start") end
    end
    local units = myUnits()
    if S.leaveWave > 0 and wave() >= S.leaveWave and not kaitun then call("teleport_back_to_lobby"); return end
    if S.sellFarmWave>0 and wave()>=S.sellFarmWave and not Match.farmsSold and not kaitun then
        Match.farmsSold=true
        for _,unit in ipairs(units)do if isFarm(unitRecord(unitId(unit)))then call("sell_unit_ingame",unit);task.wait(.15)end end
    end
    if S.sellWave > 0 and wave() >= S.sellWave and not Match.sold and not kaitun then
        Match.sold = true
        for _, unit in ipairs(units) do call("sell_unit_ingame", unit); task.wait(0.15) end
        return
    end
    if not Macro.recording then Abilities.step(units) end
    if Macro.recording then setAction("Recording macro · " .. #Macro.actions .. " actions"); return end
    if Macro.playing then return end
    if rule then
        if rule.engine == "Macro" then
            if not Match.macroStarted then
                Match.macroStarted = true
                local ok, why = Macro.play(rule.macro)
                if not ok then setAction("Stage macro: " .. tostring(why)) end
            end
            return
        elseif rule.engine == "Auto Play" then Play.step()
        else setAction("Playback off for this stage") end
    elseif kaitun then April.step(); return
    else setAction("No stage assignment; choose playback in Combat or Macros") end
    if S.autoWorthiness and wave() >= S.worthinessWave then
        local level = Loader and Loader.LevelData
        if level and level.map == "aot" then call("teleport_back_to_lobby") end
    end
end

local function mainLoop()
    while H.alive do
        local ok, err = pcall(function()
            if S.pauseAll then setAction("Automation paused"); return end
            if isLobby() then
                Lobby.step()
            elseif workspace:FindFirstChild("_DATA") then
                matchStep()
            end
        end)
        if not ok then log("Error: " .. tostring(err)); task.wait(2) end
        task.wait(0.35)
    end
end

local function queueTeleport()
    local queue = queue_on_teleport or (syn and syn.queue_on_teleport)
    if not S.autoExecute or type(queue) ~= "function" or not disk or not isfile("AnimeAdventures.luau") then return end
    if env.CometAAQueued then return end
    env.CometAAQueued = true
    pcall(queue, 'if not game:IsLoaded() then game.Loaded:Wait() end getgenv().CometAAQueued=nil if isfile("AnimeAdventures.luau") then loadstring(readfile("AnimeAdventures.luau"))() end')
end
track(player.OnTeleport:Connect(function(state)
    if state == Enum.TeleportState.Started then queueTeleport() end
end))

local function applyQuickSummon()
    local folder = player:FindFirstChild("_settings")
    local setting = folder and folder:FindFirstChild("quick_summon")
    if setting and S.skipSummon and setting.Value ~= true then pcall(call, "toggle_setting", "quick_summon") end
end

-- UI
local Window = Library.CreateMain({ Title = "CometHub", Desc = "Anime Adventures" })
H.ui, H.window = Library, Window
local controls = {}
H.controls = controls
local function toggle(section, key, title, desc, onChange)
    controls[key] = section.CreateToggle({ Title = title, Desc = desc, Default = S[key] }, function(value)
        if S[key] ~= value then
            S[key] = value
            local starters = {kaitun=true,autoJoin=true,autoDungeon=true,autoContracts=true,autoWorthiness=true,autoBanner=true,autoDailyChallenge=true,autoChallenge=true,autoTower=true,autoRelic=true}
            if value and starters[key] and S.pauseAll then
                S.pauseAll = false
                if controls.pauseAll then controls.pauseAll.SetValue(false,true) end
                log("Automation resumed: " .. title)
            end
            save(); if onChange then onChange(value) end
        end
    end)
    return controls[key]
end
local function dropdown(section, key, title, list, onChange)
    controls[key] = section.CreateDropdown({ Title = title, List = list, Default = S[key], Search = #list > 8 }, function(value)
        if value ~= nil and S[key] ~= value then S[key] = value; save(); if onChange then onChange(value) end end
    end)
    return controls[key]
end
local function multi(section, key, title)
    controls[key] = section.CreateDropdown({ Title = title, List = S[key], Selected = true, Default = {} }, function(name, value)
        S[key][name] = value; save()
    end)
    return controls[key]
end
local function slider(section, key, title, minimum, maximum)
    controls[key] = section.CreateSlider({ Title = title, Min = minimum, Max = maximum, Default = S[key] }, function(value)
        value = tonumber(value)
        if value and S[key] ~= value then S[key] = value; save() end
    end)
    return controls[key]
end

local pageHome = Window.CreatePage({ Page_Name = "Overview", Page_Title = "Overview" })
local pageJoin = Window.CreatePage({ Page_Name = "Joiners", Page_Title = "Joiners" })
local pageApril = Window.CreatePage({ Page_Name = "April Fools", Page_Title = "April Fools" })
local pageDungeon = Window.CreatePage({Page_Name="Dungeon",Page_Title="Dungeon"})
local pageGame = Window.CreatePage({ Page_Name = "Game", Page_Title = "Game" })
local pagePlay = Window.CreatePage({ Page_Name = "Autoplay", Page_Title = "Autoplay" })
local pageMacro = Window.CreatePage({ Page_Name = "Macros", Page_Title = "Macros" })
local pageSettings = Window.CreatePage({ Page_Name = "Settings", Page_Title = "Settings" })
local pageHook = Window.CreatePage({ Page_Name = "Webhook", Page_Title = "Webhook" })
H.pages = { Overview = pageHome, Joiners = pageJoin, Dungeon=pageDungeon, ["April Fools"] = pageApril, Autoplay = pagePlay, Game = pageGame, Webhook = pageHook, Combat = pageGame, Macros = pageMacro, Settings = pageSettings }

local statusLabel, actionLabel
do
    local section = pageHome.CreateSection("Status")
    statusLabel = section.CreateLabel({ Title = "Loading" })
    actionLabel = section.CreateLabel({ Title = "Idle" })
    local quick = pageHome.CreateSection("Session")
    toggle(quick, "pauseAll", "Pause automation")
end

do
    local kaitun = pageApril.CreateSection("April Fools")
    toggle(kaitun, "kaitun", "April Fools Kaitun", "Joins, plays and replays Fool's Hunt by itself")
    toggle(kaitun, "kaitunReplay", "Auto Rejoin After Match",nil,function(v)if v then S.endActionExplicit=false;save()end;if H.refreshEndControls then H.refreshEndControls()end end)
    dropdown(kaitun, "aprilJoinMode", "Join method", { "Matchmaking", "Solo" })
    local placing = pageApril.CreateSection("Placement", true)
    dropdown(placing, "aprilZone", "Position", { "Auto", "Front", "Middle", "Back" })
    toggle(placing, "aprilFarmsFirst", "Farms First")
    toggle(placing, "aprilSwapAtCap", "Swap Weak Units At Cap", "At the placement limit, sells the weakest unit for a much stronger hand unit")
    local merge = pageApril.CreateSection("Merge method")
    toggle(merge,"aprilMergeMethod","Max → level-0 merge cycle","Max one attacker, merge into an untouched identical copy, then rebuild and repeat")
    local spells = pageApril.CreateSection("Spells", true)
    multi(spells, "aprilSpells", "Use Spells")
    local cards = pageApril.CreateSection("Cards", true)
    dropdown(cards, "cardMode", "Card Priority", { "Buffs, then Candy", "Buffs", "Candy" })
    local banner = pageApril.CreateSection("April Banner", true)
    toggle(banner, "autoBanner", "Auto Roll April Banner", "Rolls in the lobby with spare April Coins")
    dropdown(banner, "bannerAmount", "Roll Amount", { "x1", "x10" })
    slider(banner, "bannerReserve", "Keep Coins", 0, 5000)
    banner.CreateLabel({ Title = "Pull notifications: Settings > Discord Webhook" })
end

local worldDropdown, actDropdown
local function worldsFor(kind)
    local list, seen, rank = {}, {}, {}
    for _, stage in ipairs(STAGE_CATALOG) do
        if stage.kind == kind and not seen[stage.groupName] then
            seen[stage.groupName] = true; table.insert(list, stage.groupName); rank[stage.groupName] = stage.worldRank or 999
        end
    end
    table.sort(list, function(a, b) if rank[a] ~= rank[b] then return rank[a] < rank[b] end return a < b end)
    return list
end
local function actsFor(kind, world)
    local list = {}
    for _, stage in ipairs(STAGE_CATALOG) do
        if stage.kind == kind and stage.groupName == world then table.insert(list, stage) end
    end
    table.sort(list, function(a, b) return (a.actNumber or 0) < (b.actNumber or 0) end)
    local labels = {}
    for _, stage in ipairs(list) do table.insert(labels, stage.label) end
    return labels
end
for _, stage in ipairs(STAGE_CATALOG) do
    local name = stage.name:gsub("^Raid:%s*", "")
    if stage.kind == "Infinite" then stage.label = "Infinite"
    elseif name:match("^Act %d+$") or name:match("^Stage %d+$") or name:match("^Legend Stage %d+$") then
        stage.label = (stage.kind == "LegendaryStages" and "Stage " or "Act ") .. (stage.actNumber or 1)
    else stage.label = (stage.kind == "LegendaryStages" and "Stage " or "Act ") .. (stage.actNumber or 1) .. " · " .. name end
end
do
    H.joinerControls={}
    for _,definition in ipairs({{"World","Story"},{"Legend","LegendaryStages"},{"Raid","Raids"},{"Infinite","Infinite"},{"Event","Events"}})do
        local title,kind=definition[1],definition[2]
        local config=S.joiners[kind]
        if type(config)~="table"then
            config={enabled=false,world="",act="",difficulty="Normal"}
            if kind==S.joinKind then config.world=S.joinWorld;config.act=S.joinAct;config.difficulty=S.difficulty end
            S.joiners[kind]=config
        end
        local worlds=worldsFor(kind)
        if not table.find(worlds,config.world)then config.world=worlds[1] or "" end
        local acts=actsFor(kind,config.world)
        if not table.find(acts,config.act)then config.act=acts[1] or "" end
        local section=pageJoin.CreateSection(title.." Joiner")
        local enabled=section.CreateToggle({Title="Auto Join "..title,Default=config.enabled==true},function(v)
            config.enabled=v
            if v then S.pauseAll=false;if controls.pauseAll then controls.pauseAll.SetValue(false,true)end end
            save()
        end)
        controls["joiner"..kind]=enabled
        local actControl
        local worldControl=section.CreateDropdown({Title="Select World",List=worlds,Default=config.world,Search=true},function(v)
            if not v then return end
            config.world=v
            local nextActs=actsFor(kind,v);config.act=nextActs[1] or ""
            if actControl then actControl:GetNewList(nextActs);actControl:ClearText(config.act)end
            save()
        end)
        actControl=section.CreateDropdown({Title=kind=="Story" and "Select Act" or "Select Stage",List=acts,Default=config.act},function(v)if v then config.act=v;save()end end)
        local hardControl=section.CreateToggle({Title="Hard Mode",Default=config.difficulty=="Hard"},function(v)config.difficulty=v and "Hard" or "Normal";save()end)
        H.joinerControls[kind]={enabled=enabled,world=worldControl,act=actControl,hard=hardControl}
    end
    local priority = pageJoin.CreateSection("Join priority", true)
    toggle(priority, "autoJoin", "Enable priority queue")
    local activities = { "Daily Challenge", "Challenge", "April Fools", "Infinity Castle", "Relic Shards", "Dungeon", "Assassin Contracts", "AOT Worthiness", "World", "Legend", "Raid", "Infinite", "Event", "None" }
    dropdown(priority, "priority1", "First", activities)
    dropdown(priority, "priority2", "Second", activities)
    dropdown(priority, "priority3", "Third", activities)
    dropdown(priority, "priority4", "Fourth", activities)
    local dungeon=pageDungeon.CreateSection("Dungeon Run")
    toggle(dungeon,"autoDungeon","Auto Join Dungeon Run")
    toggle(dungeon,"dungeonAutoStart","Auto Start Dungeon")
    slider(dungeon,"dungeonMaxDepth","Stop at depth",1,20)
    local chests=pageDungeon.CreateSection("Chests")
    slider(chests,"dungeonChestDepth","Open All Chests after Depth",1,20)
    toggle(chests,"dungeonKeepRare","Save rare chests")
    toggle(chests,"dungeonOpenNormal","Open normal chests immediately")
    local core=Services.DungeonServiceCore
    local room=pageDungeon.CreateSection("Dungeon Type Priority")
    local roomLabels,roomKeys={},{}
    for label,key in pairs(core and core.TYPES or {})do table.insert(roomLabels,label);roomKeys[label]=key end
    table.sort(roomLabels)
    local roomKey=roomLabels[1] and roomKeys[roomLabels[1]]
    local roomRank
    room.CreateDropdown({Title="Room type",List=roomLabels,Default=roomLabels[1]},function(v)roomKey=roomKeys[v];if roomRank then roomRank.SetValue(S.dungeonRoomPriority[roomKey]or 0,true)end end)
    roomRank=room.CreateSlider({Title="Priority (0 = Auto, 1 = first)",Min=0,Max=8,Default=roomKey and S.dungeonRoomPriority[roomKey]or 0},function(v)if roomKey then S.dungeonRoomPriority[roomKey]=v;save()end end)
    local shop=pageDungeon.CreateSection("Dungeon Shop")
    toggle(shop,"dungeonShop","Auto Buy Dungeon Shop")
    toggle(shop,"dungeonSelectedShopOnly","Buy selected items only")
    local itemLabels,itemKeys,selected={},{},{}
    local curseLabels,curseKeys,curseSelected={},{},{}
    for id,item in pairs(core and core.ITEMS or {})do
        if tostring(id):find("_curse",1,true) then
            table.insert(curseLabels,item.name);curseKeys[item.name]=id
            if S.dungeonDeclineCurses[id]then table.insert(curseSelected,item.name)end
        elseif DungeonPolicy.itemValue(item) then
            table.insert(itemLabels,item.name);itemKeys[item.name]=id
            if S.dungeonShopItems[id]then table.insert(selected,item.name)end
        end
    end
    table.sort(itemLabels);table.sort(curseLabels)
    shop.CreateDropdown({Title="Auto Buy Items",List=itemLabels,Selected=true,Default=selected,Search=true},function(name,v)local id=itemKeys[name];if id then S.dungeonShopItems[id]=v;save()end end)
    local itemKey=itemLabels[1] and itemKeys[itemLabels[1]]
    local itemRank
    shop.CreateDropdown({Title="Dungeon Buy Priority",List=itemLabels,Default=itemLabels[1],Search=true},function(v)itemKey=itemKeys[v];if itemRank then itemRank.SetValue(S.dungeonShopPriority[itemKey]or 0,true)end end)
    itemRank=shop.CreateSlider({Title="Buy priority (0 = Auto, 1 = first)",Min=0,Max=50,Default=itemKey and S.dungeonShopPriority[itemKey]or 0},function(v)if itemKey then S.dungeonShopPriority[itemKey]=v;save()end end)
    local shrine=pageDungeon.CreateSection("Shrine")
    toggle(shrine,"dungeonAcceptShrine","Auto Accept Shrine")
    shrine.CreateDropdown({Title="Decline Shrine Curse",List=curseLabels,Selected=true,Default=curseSelected,Search=true},function(name,v)local id=curseKeys[name];if id then S.dungeonDeclineCurses[id]=v;save()end end)
    local daily=pageJoin.CreateSection("Daily Challenge Joiner")
    toggle(daily,"autoDailyChallenge","Auto Join Daily Challenge")
    local challenge=pageJoin.CreateSection("Challenge Joiner")
    toggle(challenge,"autoChallenge","Auto Join Challenge")
    local contracts = pageJoin.CreateSection("Assassin Contracts", true)
    toggle(contracts, "autoContracts", "Auto Contracts")
    contracts.CreateLabel({ Title = "Select a map in Autoplay" })
    slider(contracts, "contractTier", "Maximum tier", 1, 15)
    toggle(contracts, "contractSkipCleared", "Skip completed contracts")
    local relic=pageJoin.CreateSection("Relic Materials",true)
    toggle(relic,"autoRelic","Auto Farm Relic Materials")
    local worth = pageJoin.CreateSection("AOT Infinite", true)
    toggle(worth, "autoWorthiness", "Farm AOT Infinite")
    slider(worth, "worthinessWave", "Return at wave", 10, 100)
    worth.CreateLabel({ Title = "Walled City takedowns: 100 takedowns = 1% worthiness. Uses your equipped team." })
    local tower = pageJoin.CreateSection("Infinity Castle", true)
    toggle(tower,"autoTower","Auto Join Infinity Castle")
    slider(tower, "towerFloor", "Start Floor", 1, 200)
    toggle(tower, "towerNext", "Auto Next Floor")
    slider(priority, "joinDelay", "Join Delay", 0, 30)
end

do
local Editor={draft=nil,slot="Stage defaults",unitSlot="1",target="Current stage",difficulty=S.difficulty,markers=nil,picking=false,pointIndex=1}
H.autoplayEditor=Editor
local editorSection=pagePlay.CreateSection("Stage setup")
local configSection=pagePlay.CreateSection("Economy & upgrades",true)
local positionSection=pagePlay.CreateSection("Positions",true)
local unitSection=pagePlay.CreateSection("Unit overrides",true)
local fields={}
local unitLabels,unitKeys,unitNames={},{},{}
for _,item in ipairs(Play.equipped())do unitNames[tostring(item.slot)]=unitName(item.id)end
for i=1,6 do local name="Slot "..i.." · "..(unitNames[tostring(i)]or"Empty");unitLabels[i]=name;unitKeys[name]=tostring(i)end
local scopeLabels={"Stage defaults"};for _,name in ipairs(unitLabels)do table.insert(scopeLabels,name)end
local stageTargets,keys={"Current stage"},{}
for _,stage in ipairs(STAGE_CATALOG)do
    local title=stage.groupName.." / "..tostring(stage.label).." ["..stage.id.."]"
    table.insert(stageTargets,title);keys[title]="stage:"..stage.id
end
for id,map in pairs(Data.Maps or{})do
    for _,mode in ipairs({"dungeon","contract","tower"})do
        local title=mode.." / "..tostring(type(map)=="table"and map.name or id).." ["..id.."]"
        table.insert(stageTargets,title);keys[title]=mode..":"..id
    end
end
function Editor.key()
    if Editor.target=="Current stage"then return currentPlanKey()end
    return keys[Editor.target]and(keys[Editor.target].."|"..Editor.difficulty)
end
Editor.targets=stageTargets
function Editor.defaults()
    return {zone=S.playZone,maxUnits=S.maxUnits,reserve=S.cashReserve,farmsFirst=S.farmsFirst}
end
function Editor.subject()
    if Editor.slot=="Stage defaults"then return Editor.draft end
    return Editor.draft.units[Editor.slot]
end
function Editor.clearPreview()
    if Editor.markers then Editor.markers:Destroy();Editor.markers=nil end
end
function Editor.preview()
    Editor.clearPreview()
    if isLobby()then return end
    local folder=Instance.new("Folder");folder.Name="CometPositionPreview";folder.Parent=workspace.CurrentCamera;Editor.markers=folder
    local subject=Editor.subject()
    for i,p in ipairs(subject and subject.points or{})do
        local part=Instance.new("Part");part.Name="Point"..i;part.Shape=Enum.PartType.Ball;part.Size=Vector3.new(.8,.8,.8)
        part.Anchored=true;part.CanCollide=false;part.CanTouch=false;part.CanQuery=false;part.Material=Enum.Material.Neon
        part.Color=Color3.fromRGB(235,235,240);part.Position=Vector3.new(table.unpack(p))+Vector3.new(0,.5,0);part.Parent=folder
        local billboard=Instance.new("BillboardGui");billboard.Size=UDim2.fromOffset(60,22);billboard.StudsOffset=Vector3.new(0,1,0);billboard.AlwaysOnTop=true;billboard.Parent=part
        local text=Instance.new("TextLabel");text.Size=UDim2.fromScale(1,1);text.BackgroundTransparency=1;text.Text=tostring(i);text.TextColor3=Color3.new(1,1,1);text.TextStrokeTransparency=0;text.TextSize=16;text.Parent=billboard
    end
end
local scopeLabel=editorSection.CreateLabel({Title="Choose the stage you want to configure."})
local pointsLabel=positionSection.CreateLabel({Title="No saved points"})
positionSection.CreateLabel({Title="Auto finds terrain. Area uses the first point as its center. Exact follows the saved points in order."})
local function message(text)scopeLabel.SetText(text)end
local function put(control,value)
    if control.SetValue then control.SetValue(value,true)else control:ClearText(value)end
end
function Editor.refresh()
    if not Editor.draft then return end
    for name,control in pairs(fields)do
        local subject=name:sub(1,2)=="u_"and Editor.draft.units[Editor.unitSlot]or Editor.draft
        local field=name:gsub("^u_","")
        put(control,subject[field])
    end
    local subject=Editor.subject();pointsLabel.SetText(Editor.slot..": "..#subject.points.." points. Mode: "..subject.mode..". Changes need Save.")
    if Editor.scopeControl then Editor.scopeControl:ClearText(Editor.slot=="Stage defaults"and Editor.slot or unitLabels[tonumber(Editor.slot)])end
    if Editor.unitControl then Editor.unitControl:ClearText(unitLabels[tonumber(Editor.unitSlot)])end
end
function Editor.load()
    local key=Editor.key();local rule=key and S.stagePlans[key]
    Editor.draft=AutoplayPolicy.normalize(rule and rule.autoplay,Editor.defaults())
    message((key or "Choose a stage, or enter a match").."\nPlayback: "..(rule and rule.engine or "Unassigned"))
    Editor.clearPreview();Editor.refresh()
end
local function set(field,value,unit)
    if not Editor.draft then return end
    local subject=unit and Editor.draft.units[Editor.unitSlot]or Editor.draft
    subject[field]=value
    message("Unsaved changes · "..(Editor.key()or"choose a stage"))
    Editor.refresh()
end
local function select(section,field,title,list,unit)
    fields[(unit and"u_"or"")..field]=section.CreateDropdown({Title=title,List=list,Default=list[1]},function(v)if v~=nil then set(field,v,unit)end end)
end
local function range(section,field,title,min,max,unit)
    fields[(unit and"u_"or"")..field]=section.CreateSlider({Title=title,Min=min,Max=max,Default=min},function(v)set(field,v,unit)end)
end
local function flag(section,field,title,unit)
    fields[(unit and"u_"or"")..field]=section.CreateToggle({Title=title,Default=true},function(v)set(field,v,unit)end)
end
editorSection.CreateDropdown({Title="Stage / map",List=stageTargets,Default="Current stage",Search=true},function(v)Editor.target=v;Editor.load()end)
editorSection.CreateDropdown({Title="Difficulty",List={"Normal","Hard"},Default=Editor.difficulty},function(v)Editor.difficulty=v;Editor.load()end)
select(configSection,"zone","Default combat zone",{"Auto","Front","Middle","Back"})
select(configSection,"farmZone","Farm zone",{"Back","Middle","Front","Auto"})
range(configSection,"maxUnits","Total placement limit",1,30)
range(configSection,"reserve","Keep cash",0,30000)
flag(configSection,"farmsFirst","Prioritize farms")
select(configSection,"upgrade","Upgrade strategy",{"Efficiency","Cheapest","Unit priority","Lowest level","Disabled"})
local function saveProfile(enable)
    local key=Editor.key()
    if not key then message("Choose a stage before saving");return end
    local rule=S.stagePlans[key]or{engine="Off"}
    rule.autoplay=AutoplayPolicy.normalize(Editor.draft,Editor.defaults())
    if enable then rule.engine="Auto Play";rule.macro=nil end
    S.stagePlans[key]=rule;Play.failures={};Match.macroStarted=nil;save()
    message("Saved "..key.."\nPlayback: "..rule.engine)
end
Editor.save=saveProfile
editorSection.CreateButton({Title="Save settings"},function()saveProfile(false)end)
editorSection.CreateButton({Title="Save and use Auto Play"},function()saveProfile(true)end)
editorSection.CreateButton({Title="Turn playback off for this stage"},function()
    local key=Editor.key();if key then Macro.stop();StagePlans.bind(S.stagePlans,key,"Off");save();Editor.load()end
end)
Editor.scopeControl=positionSection.CreateDropdown({Title="Edit positions for",List=scopeLabels,Default=Editor.slot},function(v)Editor.slot=unitKeys[v]or"Stage defaults";if Editor.slot~="Stage defaults"then Editor.unitSlot=Editor.slot end;Editor.refresh();Editor.clearPreview()end)
-- Position mode applies to the selected scope, unlike the stage-wide zone controls above.
local modeControl=positionSection.CreateDropdown({Title="Placement mode",List={"Inherit","Auto","Area","Exact"},Default="Auto"},function(v)Editor.subject().mode=v;Editor.refresh()end)
range(positionSection,"radius","Area radius (studs)",3,120)
local function updatePoints()
    pointsLabel.SetText(Editor.slot..": "..#Editor.subject().points.." points. Mode: "..Editor.subject().mode..". Changes need Save.")
    modeControl:ClearText(Editor.subject().mode)
end
local originalRefresh=Editor.refresh
function Editor.refresh()originalRefresh();if Editor.draft then updatePoints()end end
function Editor.finishPick()
    Editor.picking=false
    if Library.ScreenGui then Library.ScreenGui.Enabled=true;getgenv().UIToggled=true end
end
function Editor.addPoint(position)
    if #Editor.subject().points>=100 then message("100-point limit reached");return end
    table.insert(Editor.subject().points,{position.X,position.Y,position.Z})
    Editor.subject().mode="Exact";Editor.refresh();Editor.preview();message("Point added. Save to apply it.")
end
positionSection.CreateButton({Title="Pick a point on the map"},function()
    if isLobby()then message("Enter the matching map to pick world positions");return end
    local key=Editor.key();local level=Loader and Loader.LevelData
    local base=key and key:match("^(.-)|")
    local targetId=base and base:match("^stage:(.+)$")
    local expected=targetId and Data.Levels[targetId]and Data.Levels[targetId].map or base and base:match("^[^:]+:(.+)$")
    if not level or expected~=level.map then message("Enter the map selected in Stage setup first");return end
    Editor.picking=true;Library.ScreenGui.Enabled=false;getgenv().UIToggled=false
    setAction("Choose a map position · Escape cancels")
end)
track(game:GetService("UserInputService").InputBegan:Connect(function(input,processed)
    if not Editor.picking then return end
    if input.KeyCode==Enum.KeyCode.Escape then Editor.finishPick();return end
    if processed or(input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch)then return end
    local core=Services.PlacementCore;local camera=workspace.CurrentCamera
    if not core or not camera then Editor.finishPick();return end
    local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Include
    params.FilterDescendantsInstances={core.GroundRaycastParts,core.HillRaycastParts}
    local ray=camera:ScreenPointToRay(input.Position.X,input.Position.Y)
    local hit=workspace:Raycast(ray.Origin,ray.Direction*3000,params)
    Editor.finishPick()
    if hit then Editor.addPoint(hit.Position)else message("Choose valid ground or hill terrain")end
end))
positionSection.CreateButton({Title="Show saved point markers"},Editor.preview)
positionSection.CreateButton({Title="Add a suggested position"},function()
    if isLobby()then message("Enter the selected map to generate a position");return end
    if Editor.key()~=currentPlanKey()then message("Choose Current stage before generating a point");return end
    local record
    for _,item in ipairs(Play.equipped())do if tostring(item.slot)==Editor.unitSlot then record=item.record;break end end
    if not record then message("The selected team slot is empty");return end
    local point=Play.suggestSpot(record,Editor.draft.zone)
    if point then Editor.addPoint(point)else message("No valid position found for that unit")end
end)
positionSection.CreateButton({Title="Hide markers"},Editor.clearPreview)
positionSection.CreateBox({Title="Point number to remove",Placeholder="1"},function(v)Editor.pointIndex=math.floor(tonumber(v)or 1)end)
positionSection.CreateButton({Title="Remove selected point"},function()local p=Editor.subject().points;if Editor.pointIndex>=1 and Editor.pointIndex<=#p then table.remove(p,Editor.pointIndex);Editor.refresh();Editor.preview()end end)
positionSection.CreateButton({Title="Clear these points"},function()Editor.subject().points={};Editor.refresh();Editor.clearPreview()end)
Editor.unitControl=unitSection.CreateDropdown({Title="Equipped unit",List=unitLabels,Default=unitLabels[1]},function(v)local slot=unitKeys[v];if slot then Editor.slot=slot;Editor.unitSlot=slot;Editor.refresh()end end)
unitSection.CreateLabel({Title="Slots follow your equipped team. Position scope above selects the same slot."})
flag(unitSection,"enabled","Place this slot",true)
range(unitSection,"limit","Unit placement limit",0,30,true)
range(unitSection,"priority","Placement priority (1 = first)",1,6,true)
range(unitSection,"fromWave","Start placing at wave",0,100,true)
range(unitSection,"untilWave","Stop placing at wave (0 = never)",0,100,true)
flag(unitSection,"upgrade","Upgrade this slot",true)
range(unitSection,"maxUpgrade","Maximum upgrade (0 = unlimited)",0,30,true)
select(unitSection,"zone","Unit zone",{"Inherit","Auto","Front","Middle","Back"},true)
unitSection.CreateButton({Title="Reload saved settings"},Editor.load)
Editor.load()

end

do
    local round = pageGame.CreateSection("Match", true)
    toggle(round, "autoStart", "Auto Vote Start", "Kaitun votes start automatically, independently of this setting.")
    toggle(round, "autoSkip", "Auto Skip Wave")
    slider(round,"stopSkipWave","Stop skip at wave (0 = never)",0,100)
    toggle(round, "autoCards", "Auto Pick Cards")
    local endControls={}
    function H.refreshEndControls()
        local selected=S.kaitun and S.kaitunReplay and "Lobby" or S.afterMatch
        for action,control in pairs(endControls)do control.SetValue(action==selected,true)end
    end
    for _,item in ipairs({{"Next","Auto Next"},{"Replay","Auto Replay"},{"Lobby","Auto Return Lobby"}})do
        local action,title=item[1],item[2]
        endControls[action]=round.CreateToggle({Title=title,Default=false},function(enabled)
            S.endActionExplicit=true
            if enabled then
                S.afterMatch=action
                S.kaitunReplay=false
                if controls.kaitunReplay then controls.kaitunReplay.SetValue(false,true)end
            else
                S.afterMatch="Nothing";S.kaitunReplay=false
                if controls.kaitunReplay then controls.kaitunReplay.SetValue(false,true)end
            end
            Match.finishedHandled=false;save();H.refreshEndControls()
        end)
        controls["end"..action]=endControls[action]
    end
    H.refreshEndControls()
    local waves = pageGame.CreateSection("Wave Actions", true)
    slider(waves,"sellFarmWave","Sell farms at wave (0 = off)",0,100)
    slider(waves, "sellWave", "Sell All At Wave (0 = off)", 0, 100)
    slider(waves, "leaveWave", "Leave At Wave (0 = off)", 0, 100)
    local abilities = pageGame.CreateSection("Abilities", true)
    toggle(abilities, "autoAbility", "Auto Use Abilities")
    toggle(abilities, "abilityBossOnly", "Only During Boss")
    toggle(abilities, "autoRukia", "Snow Reaper rotation", "Uses charge when available; otherwise 40s recharge / 20s drain")
    toggle(abilities, "autoDazai", "Dazai smart ability", "Nullifies enemy passives; respects the 90s global cooldown")
end

do
    local manage = pageMacro.CreateSection("Macro")
    local macroStatus = manage.CreateLabel({ Title = "Not recording" })
    local nameBox = ""
    local list = manage.CreateDropdown({ Title = "Macro", List = Macro.list(), Default = S.macro, Search = true }, function(value)
        if value and value ~= S.macro then S.macro = value; save() end
    end)
    H.refreshMacroList=function()list:GetNewList(Macro.list())end
    manage.CreateBox({ Title = "New Macro Name", Placeholder = "Leave empty for automatic" }, function(text) nameBox = text end)
    manage.CreateButton({ Title = "Record / Stop" }, function()
        if Macro.recording then
            local name, count = Macro.stopRecording(nameBox)
            if count == 0 then macroStatus.SetText(name); return end
            S.macro = name; save()
            list:GetNewList(Macro.list()); list:ClearText(name)
            macroStatus.SetText("Saved " .. name .. " · " .. count .. " actions")
        else
            local ok, why = Macro.startRecording()
            macroStatus.SetText(ok and "Recording · place and upgrade normally" or tostring(why))
        end
    end)
    toggle(manage, "bindRecordedMacro", "Bind saved recording to this stage")
    manage.CreateButton({ Title = "Play selected macro here" }, function()
        local ok, why = Macro.play(S.macro)
        if not ok then macroStatus.SetText(tostring(why)) end
    end)
    dropdown(manage, "macroTiming", "Timing", { "Wave", "Time" })
    local assignments = pageMacro.CreateSection("Stage assignments")
    local targets, targetKeys = { "Current stage" }, {}
    for _, stage in ipairs(STAGE_CATALOG) do
        local label = stage.groupName .. " / " .. tostring(stage.label) .. " [" .. stage.id .. "]"
        table.insert(targets, label); targetKeys[label] = "stage:" .. stage.id
    end
    for id, map in pairs(Data.Maps or {}) do
        local name = type(map) == "table" and map.name or id
        for _, kind in ipairs({ "dungeon", "contract", "tower" }) do
            local label = kind .. " / " .. tostring(name) .. " [" .. id .. "]"
            table.insert(targets, label); targetKeys[label] = kind .. ":" .. id
        end
    end
    local target, difficulty, engine = "Current stage", S.difficulty, "Macro"
    local assignedLabel = assignments.CreateLabel({ Title = "No stage selected" })
    assignments.CreateDropdown({ Title = "Stage / map", List = targets, Default = target, Search = true }, function(value) if value then target = value end end)
    assignments.CreateDropdown({ Title = "Difficulty", List = { "Normal", "Hard" }, Default = difficulty }, function(value) if value then difficulty = value end end)
    assignments.CreateDropdown({ Title = "Playback", List = { "Off", "Auto Play", "Macro" }, Default = engine }, function(value) if value then engine = value end end)
    assignments.CreateButton({ Title = "Save assignment using selected macro" }, function()
        local key = target == "Current stage" and currentPlanKey() or targetKeys[target] and (targetKeys[target] .. "|" .. difficulty)
        local ok, why = StagePlans.bind(S.stagePlans, key, engine, S.macro)
        if ok then Match.macroStarted = nil; save(); assignedLabel.SetText(key .. " → " .. engine .. (engine == "Macro" and (": " .. S.macro) or ""))
        else assignedLabel.SetText(tostring(why)) end
    end)
    manage.CreateButton({ Title = "Stop playback" }, Macro.stop)
    slider(manage, "macroTimeout", "Action timeout (seconds)", 10, 90)
    manage.CreateButton({ Title = "Delete Selected" }, function()
        if disk and S.macro ~= "" and isfile(macroPath(S.macro)) and type(delfile) == "function" then
            delfile(macroPath(S.macro)); S.macro = ""; save()
            list:GetNewList(Macro.list())
        end
    end)
end

do
    local section = pageHook.CreateSection("Discord Webhook", true)
    section.CreateBox({ Title = "Webhook URL", Placeholder = "https://discord.com/api/webhooks/...", Default = S.webhookUrl ~= "" and S.webhookUrl or nil }, function(text)
        S.webhookUrl = text; save()
    end)
    toggle(section, "webhookMatch", "Send On Match End")
    toggle(section, "webhookSummon", "Send April Pulls")
    toggle(section, "webhookPing", "Ping Everyone")
    section.CreateButton({ Title = "Send Test" }, function()
        task.spawn(function()
            local ok, why = webhook("Webhook test", { { "Player", player.Name }, { "April Coins", aprilCoins() } })
            Library.CreateNoti({ Title = "Webhook", Desc = ok and "Delivered" or ("Failed: " .. tostring(why)), ShowTime = 4 }, true)
        end)
    end)
end

do
    local section = pageSettings.CreateSection("General")
    toggle(section, "autoExecute", "Auto Execute On Teleport")
    toggle(section, "skipSummon", "Quick Summon Animation", nil, applyQuickSummon)
    section.CreateBind({ Title = "Toggle UI", Key = Enum.KeyCode.RightControl }, function() Library.ToggleUI() end)
    section.CreateButton({ Title = "Unload" }, function() H.unload() end)
    local logs = pageSettings.CreateSection("Activity Log", true)
    H.logLabel = logs.CreateLabel({ Title = "" })
end

local utilities = pageSettings.CreateSection("Config")
local configText = ""
utilities.CreateBox({Title="Import config",Placeholder="Paste config JSON"},function(text)configText=text end)
utilities.CreateButton({Title="Copy config to clipboard"},function()
    if type(setclipboard)~="function" then return end
    setclipboard(HttpService:JSONEncode({format="CometHub",version=2,settings=S}))
end)
utilities.CreateButton({Title="Import config"},function()
    local ok,data=pcall(HttpService.JSONDecode,HttpService,configText)
    if not ok or type(data)~="table" or data.format~="CometHub" or type(data.settings)~="table" then
        Library.CreateNoti({Title="Config",Desc="Invalid config"});return
    end
    for key,value in pairs(data.settings)do
        if S[key]~=nil and type(value)==type(S[key]) then S[key]=value end
    end
    if not writeJSON(SETTINGS_FILE,S)then Library.CreateNoti({Title="Config",Desc="Save failed"});return end
    if disk and type(loadstring)=="function" and isfile("AnimeAdventures.luau")then
        local reload,why=loadstring(readfile("AnimeAdventures.luau"))
        if reload then task.spawn(reload)else Library.CreateNoti({Title="Config",Desc=tostring(why)})end
    else Library.CreateNoti({Title="Config",Desc="Imported. Re-execute to refresh controls."})end
end)

local transfer = pageMacro.CreateSection("Importer / Exporter",true)
local importName,importText="Imported Macro",""
transfer.CreateBox({Title="Macro name",Default=importName},function(v)importName=v end)
transfer.CreateBox({Title="Import macro",Placeholder="Paste macro JSON"},function(v)importText=v end)
local function validNumber(n)return type(n)=="number" and n==n and math.abs(n)<1e12 end
local function validateMacro(data)
    if type(data)~="table" or type(data.level)~="string" or type(data.actions)~="table" or #data.actions>10000 then return false end
    local placed={}
    for _,action in ipairs(data.actions)do
        if type(action)~="table" or not validNumber(action.t) or action.t<0
            or not validNumber(action.index) or action.index<1 or action.index%1~=0 then return false end
        if action.type=="place" then
            if placed[action.index] or type(action.unit)~="string" or not unitRecord(action.unit)
                or type(action.cf)~="table" or #action.cf~=12 then return false end
            for _,v in ipairs(action.cf)do if not validNumber(v)then return false end end
            placed[action.index]=true
        elseif not placed[action.index] or not table.find({"upgrade","sell","ability","priority"},action.type)then return false end
        if action.expectedLevel~=nil and (not validNumber(action.expectedLevel) or action.expectedLevel<0)then return false end
        if action.wave~=nil and (not validNumber(action.wave) or action.wave<0)then return false end
    end
    return true
end
H.validateMacro=validateMacro
transfer.CreateButton({Title="Import macro"},function()
    local ok,data=pcall(HttpService.JSONDecode,HttpService,importText)
    local path=macroPath(importName)
    if not path or not ok or not validateMacro(data)then Library.CreateNoti({Title="Macro",Desc="Invalid macro"});return end
    if disk and isfile(path)then Library.CreateNoti({Title="Macro",Desc="Name already exists"});return end
    local written=writeJSON(path,data)
    if written and H.refreshMacroList then H.refreshMacroList()end
    Library.CreateNoti({Title="Macro",Desc=written and "Imported" or "Save failed"})
end)
transfer.CreateButton({Title="Copy macro JSON to clipboard"},function()
    local path=macroPath(S.macro)
    if path and disk and isfile(path)and type(setclipboard)=="function"then setclipboard(readfile(path))end
end)
transfer.CreateButton({Title="Check macro units"},function()
    local data=readJSON(macroPath(S.macro)or "")
    if not data or not validateMacro(data)then Library.CreateNoti({Title="Macro",Desc="Select a valid macro"});return end
    local equipped,missing={},{}
    for _,item in ipairs(Play.equipped())do equipped[item.id]=true end
    for _,action in ipairs(data.actions)do if action.type=="place" and not equipped[action.unit]then missing[action.unit]=true end end
    local names={};for id in pairs(missing)do table.insert(names,unitName(id))end
    Library.CreateNoti({Title="Macro units",Desc=#names==0 and "All units equipped" or table.concat(names,", ")})
end)

local performance=pageGame.CreateSection("Performance",true)
local lighting=game:GetService("Lighting")
local changes={}
local function restorePerformance()
    for _,change in ipairs(changes)do pcall(function()change.object[change.key]=change.value end)end
    table.clear(changes)
end
local function change(object,key,value)
    table.insert(changes,{object=object,key=key,value=object[key]});object[key]=value
end
local function applyPerformance()
    restorePerformance()
    if not S.boostFps then return end
    change(lighting,"GlobalShadows",false)
    for _,effect in ipairs(lighting:GetChildren())do if effect:IsA("PostEffect")then change(effect,"Enabled",false)end end
end
toggle(performance,"boostFps","Boost FPS",nil,applyPerformance)
local black=Instance.new("Frame")
black.Name="BlackScreen";black.BackgroundColor3=Color3.new();black.BorderSizePixel=0
black.Size=UDim2.fromScale(1,1);black.ZIndex=0;black.Visible=false;black.Parent=Library.ScreenGui
local function applyBlack()
    black.Visible=S.blackScreen
    game:GetService("RunService"):Set3dRenderingEnabled(not S.blackScreen)
end
toggle(performance,"blackScreen","Black Screen",nil,applyBlack)
local misc=pageSettings.CreateSection("Misc",true)
local zoomBefore=player.CameraMaxZoomDistance
slider(misc,"cameraZoom","Max Camera Zoom Distance",32,1000)
toggle(misc,"rightClickTeleport","Right Click Teleport",nil,function(v)if v then S.rightClickMove=false;if controls.rightClickMove then controls.rightClickMove.SetValue(false,true)end end end)
toggle(misc,"rightClickMove","Right Click Move",nil,function(v)if v then S.rightClickTeleport=false;if controls.rightClickTeleport then controls.rightClickTeleport.SetValue(false,true)end end end)
toggle(misc,"walkAround","Walk Around")
toggle(misc,"rejoinOnPlayer","Teleport to lobby if players join")
misc.CreateButton({Title="Teleport to Lobby"},function()call("teleport_back_to_lobby")end)
track(game:GetService("UserInputService").InputBegan:Connect(function(input,processed)
    if processed or input.UserInputType~=Enum.UserInputType.MouseButton2 then return end
    local character=player.Character;local root=character and character:FindFirstChild("HumanoidRootPart")
    local humanoid=character and character:FindFirstChildOfClass("Humanoid")
    local point=player:GetMouse().Hit.Position
    if S.rightClickTeleport and root then root.CFrame=CFrame.new(point+Vector3.new(0,3,0))
    elseif S.rightClickMove and humanoid then humanoid:MoveTo(point)end
end))
track(Players.PlayerAdded:Connect(function()
    if S.rejoinOnPlayer and not isLobby()then call("teleport_back_to_lobby")end
end))
spawnLoop(function()
    while H.alive do
        player.CameraMaxZoomDistance=S.cameraZoom
        if S.walkAround and not S.pauseAll then
            local character=player.Character;local root=character and character:FindFirstChild("HumanoidRootPart")
            local humanoid=character and character:FindFirstChildOfClass("Humanoid")
            if root and humanoid then humanoid:MoveTo(root.Position+Vector3.new(math.random(-5,5),0,math.random(-5,5)))end
        end
        task.wait(5)
    end
end)
function H.restoreUtilities()
    restorePerformance();player.CameraMaxZoomDistance=zoomBefore
    game:GetService("RunService"):Set3dRenderingEnabled(true)
end
applyPerformance();applyBlack()


function H.unload()
    H.alive = false
    if H.restoreUtilities then H.restoreUtilities() end
    if H.autoplayEditor then H.autoplayEditor.clearPreview(); H.autoplayEditor.picking = false end
    if Library.DisconnectConnections then Library.DisconnectConnections() end
    if env.CometAAHook then env.CometAAHook.target = nil end
    for _, connection in ipairs(H.connections) do pcall(function() connection:Disconnect() end) end
    for _, thread in ipairs(H.threads) do pcall(task.cancel, thread) end
    for _, gui in ipairs(H.guis) do pcall(gui.Destroy, gui) end
    if env.CometAA == H then env.CometAA = nil end
end

spawnLoop(mainLoop)
spawnLoop(function()
    while H.alive do
        pcall(function()
            local where = isLobby() and "Lobby" or levelName(levelId())
            local text = where
            if not isLobby() then text ..= "  ·  Wave " .. wave() .. "  ·  $" .. math.floor(cash()) .. "  ·  Units " .. #myUnits() end
            text ..= "\nApril Coins " .. aprilCoins() .. "  ·  Matches " .. Match.matches
            statusLabel.SetText(text)
            actionLabel.SetText(H.action)
            if H.stageLabel then
                local rule, key = StagePlans.resolve(S.stagePlans, Loader and Loader.LevelData, S.difficulty)
                H.stageLabel.SetText((key or "Enter a stage or select it in Macros") .. "\nPlayback: " .. (rule and rule.engine or "Unassigned"))
            end
            if H.healthLabel then
                H.healthLabel.SetText(session() and "Ready · Autoplay profiles save per stage" or "Waiting for game data")
            end
            if H.verificationLabel then
                H.verificationLabel.SetText("Snow Reaper: " .. (Smart.status.Rukia or "not enabled") .. "\nDazai: " .. (Smart.status.Dazai or "not enabled") .. "\nFreeze loadout: unavailable")
            end
            if H.logLabel then
                local recent = {}
                for i = math.max(1, #H.log - 8), #H.log do table.insert(recent, H.log[i]) end
                H.logLabel.SetText(table.concat(recent, "\n"))
            end
        end)
        task.wait(0.5)
    end
end)
applyQuickSummon()
queueTeleport()
if not getgenv().UIToggled then Library.ToggleUI() end
log("Loaded")
