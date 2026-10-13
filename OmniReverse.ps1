<#
================================================================================
  OmniReverse OSINT Ultra — Blacklistseller & FaceCheck.ID Direct Hub
  Version: 6.0 Direct (Blacklistseller Direct + FaceCheck.ID Direct)
  ไม่มี QR Code | ไม่ใช้เว็บอื่น | ค้นหาตรง 100%
================================================================================
#>

if ([System.Threading.Thread]::CurrentThread.GetApartmentState() -ne [System.Threading.ApartmentState]::STA) {
    powershell.exe -ExecutionPolicy Bypass -NoProfile -STA -WindowStyle Hidden -File $MyInvocation.MyCommand.Path
    exit
}

Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Drawing, System.Windows.Forms, System.Net.Http, System.Web

[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12 -bor [System.Net.SecurityProtocolType]::Tls11 -bor [System.Net.SecurityProtocolType]::Tls

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$logoPath = Join-Path $scriptDir "assets\logo.jpg"
$htmlPath = Join-Path $scriptDir "index.html"

$xamlString = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="OmniReverse Ultra — Blacklistseller &amp; FaceCheck.ID Direct Hub v6.0"
        Height="880" Width="1240" MinHeight="750" MinWidth="1050"
        WindowStartupLocation="CenterScreen"
        Background="#060911" Foreground="#F3F4F6"
        FontFamily="Segoe UI, Tahoma, sans-serif"
        AllowDrop="True">

    <Window.Resources>
        <Style TargetType="ScrollBar">
            <Setter Property="Background" Value="#0F172A"/>
            <Setter Property="Foreground" Value="#334155"/>
        </Style>

        <Style x:Key="GlowBtn" TargetType="Button">
            <Setter Property="Background" Value="#DC2626"/>
            <Setter Property="Foreground" Value="#FFFFFF"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="FontSize" Value="13"/>
            <Setter Property="Padding" Value="18,11"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="border" Background="{TemplateBinding Background}" CornerRadius="9" Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="border" Property="Background" Value="#EF4444"/>
                            </Trigger>
                            <Trigger Property="IsPressed" Value="True">
                                <Setter TargetName="border" Property="Background" Value="#B91C1C"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style x:Key="PurpleBtn" TargetType="Button">
            <Setter Property="Background" Value="#7C3AED"/>
            <Setter Property="Foreground" Value="#FFFFFF"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="FontSize" Value="13"/>
            <Setter Property="Padding" Value="18,11"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="border" Background="{TemplateBinding Background}" CornerRadius="9" Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="border" Property="Background" Value="#8B5CF6"/>
                            </Trigger>
                            <Trigger Property="IsPressed" Value="True">
                                <Setter TargetName="border" Property="Background" Value="#6D28D9"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style x:Key="SecondaryBtn" TargetType="Button">
            <Setter Property="Background" Value="#1E293B"/>
            <Setter Property="Foreground" Value="#E2E8F0"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="Padding" Value="14,9"/>
            <Setter Property="BorderBrush" Value="#334155"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="border" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="8" Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="border" Property="Background" Value="#334155"/>
                                <Setter TargetName="border" Property="BorderBrush" Value="#06B6D4"/>
                            </Trigger>
                            <Trigger Property="IsPressed" Value="True">
                                <Setter TargetName="border" Property="Background" Value="#0F172A"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style x:Key="PlatformCard" TargetType="Border">
            <Setter Property="Background" Value="#0F172A"/>
            <Setter Property="BorderBrush" Value="#1E293B"/>
            <Setter Property="BorderThickness" Value="1.5"/>
            <Setter Property="CornerRadius" Value="14"/>
            <Setter Property="Padding" Value="20"/>
            <Setter Property="Margin" Value="0,0,0,14"/>
        </Style>

        <Style TargetType="TabItem">
            <Setter Property="Foreground" Value="#94A3B8"/>
            <Setter Property="FontSize" Value="14"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="Padding" Value="24,12"/>
            <Setter Property="Background" Value="#0B1120"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Margin" Value="0,0,8,0"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="TabItem">
                        <Border x:Name="TabBorder" Background="{TemplateBinding Background}" CornerRadius="10,10,0,0" Padding="{TemplateBinding Padding}" Margin="{TemplateBinding Margin}">
                            <ContentPresenter ContentSource="Header" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsSelected" Value="True">
                                <Setter TargetName="TabBorder" Property="Background" Value="#1E293B"/>
                                <Setter Property="Foreground" Value="#F87171"/>
                            </Trigger>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="TabBorder" Property="Background" Value="#162032"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>

    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="76"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="38"/>
        </Grid.RowDefinitions>

        <!-- HEADER -->
        <Border Grid.Row="0" Background="#0B1120" BorderBrush="#1E293B" BorderThickness="0,0,0,1" Padding="20,10">
            <Grid>
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="Auto"/>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="Auto"/>
                </Grid.ColumnDefinitions>

                <StackPanel Grid.Column="0" Orientation="Horizontal" VerticalAlignment="Center">
                    <Border CornerRadius="10" Width="50" Height="50" Margin="0,0,14,0" Background="#1E293B" ClipToBounds="True">
                        <Image Name="AppLogoImage" Stretch="UniformToFill"/>
                    </Border>
                    <StackPanel VerticalAlignment="Center">
                        <StackPanel Orientation="Horizontal">
                            <TextBlock Text="OmniReverse" FontSize="20" FontWeight="Bold" Foreground="#FFFFFF"/>
                            <Border Background="#DC2626" CornerRadius="4" Padding="7,2" Margin="10,0,0,0" VerticalAlignment="Center">
                                <TextBlock Text="BLACKLISTSELLER DIRECT" FontSize="10" FontWeight="Bold" Foreground="#FFFFFF"/>
                            </Border>
                            <Border Background="#7C3AED" CornerRadius="4" Padding="7,2" Margin="6,0,0,0" VerticalAlignment="Center">
                                <TextBlock Text="FACECHECK.ID" FontSize="10" FontWeight="Bold" Foreground="#FFFFFF"/>
                            </Border>
                        </StackPanel>
                        <TextBlock Text="ค้นหาชื่อ &amp; เช็คคนโกง Blacklistseller (ไม่ต้องใช้ QR Code) และค้นหาใบหน้า FaceCheck.ID โดยตรง ไม่ใช้เว็บอื่น" FontSize="11" Foreground="#94A3B8" Margin="0,3,0,0"/>
                    </StackPanel>
                </StackPanel>

                <StackPanel Grid.Column="2" Orientation="Horizontal" VerticalAlignment="Center">
                    <Button Name="BtnOpenWebApp" Content="🌐 เปิดเวอร์ชันเว็บ (In-App View)" Style="{StaticResource SecondaryBtn}" Margin="0,0,10,0"/>
                    <Button Name="BtnClearAll" Content="🗑️ ล้างข้อมูล" Style="{StaticResource SecondaryBtn}"/>
                </StackPanel>
            </Grid>
        </Border>

        <!-- MAIN TABS -->
        <TabControl Name="MainTabControl" Grid.Row="1" Background="Transparent" BorderThickness="0" Margin="18,12,18,10">

            <!-- ================= TAB 1: BLACKLISTSELLER PHONE & NAME SEARCH ================= -->
            <TabItem Header="🚨  ค้นหาชื่อ &amp; เช็คประวัติคนโกง (Blacklistseller Direct)">
                <Grid Margin="0,14,0,0">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="480" MinWidth="400"/>
                        <ColumnDefinition Width="*"/>
                    </Grid.ColumnDefinitions>

                    <!-- LEFT: INPUT & CARRIER DETECTION -->
                    <Grid Grid.Column="0" Margin="0,0,18,0">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="*"/>
                        </Grid.RowDefinitions>

                        <!-- Input Box -->
                        <Border Grid.Row="0" Background="#0F172A" BorderBrush="#EF4444" BorderThickness="1.5" CornerRadius="14" Padding="22">
                            <StackPanel>
                                <TextBlock Text="🚨 ระบุข้อมูลที่ต้องการค้นหาบน Blacklistseller" FontSize="16" FontWeight="Bold" Foreground="#FFFFFF"/>
                                <TextBlock Text="พิมพ์เบอร์โทรศัพท์ (08x, 09x, 06x), เลขบัญชี หรือชื่อ-นามสกุล โดยตรง (ไม่ต้องใช้ QR Code)" FontSize="11" Foreground="#CBD5E1" Margin="0,4,0,16" TextWrapping="Wrap"/>

                                <TextBlock Text="ข้อมูลที่ต้องการค้นหา (เบอร์โทร / เลขบัญชี / ชื่อ):" FontSize="12" FontWeight="Bold" Foreground="#FCA5A5" Margin="0,0,0,6"/>
                                <TextBox Name="TxtPhoneNumber" Background="#1E293B" Foreground="#FFFFFF" BorderBrush="#EF4444" BorderThickness="1.5" Padding="12,10" FontSize="16" FontWeight="Bold" Margin="0,0,0,14"/>

                                <!-- Live Detection -->
                                <Border Background="#1E293B" BorderBrush="#334155" BorderThickness="1" CornerRadius="10" Padding="14,12" Margin="0,0,0,16">
                                    <StackPanel>
                                        <Grid>
                                            <Grid.ColumnDefinitions><ColumnDefinition Width="Auto"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
                                            <TextBlock Grid.Column="0" Text="📡 เครือข่าย/ชนิด: " FontSize="11" FontWeight="Bold" Foreground="#38BDF8"/>
                                            <TextBlock Name="TxtCarrierDetect" Grid.Column="1" Text="กรุณาพิมพ์เบอร์โทร หรือชื่อ..." FontSize="11" Foreground="#CBD5E1" TextTrimming="CharacterEllipsis"/>
                                        </Grid>
                                        <Grid Margin="0,6,0,0">
                                            <Grid.ColumnDefinitions><ColumnDefinition Width="Auto"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
                                            <TextBlock Grid.Column="0" Text="🔍 ประเภทคำค้นหา: " FontSize="11" FontWeight="Bold" Foreground="#FCA5A5"/>
                                            <TextBlock Name="TxtTargetFormat" Grid.Column="1" Text="-" FontSize="11" Foreground="#CBD5E1"/>
                                        </Grid>
                                    </StackPanel>
                                </Border>

                                <Button Name="BtnLookupBlacklist" Content="🚨 ค้นหาชื่อและประวัติคนโกงบน Blacklistseller ทันที" Style="{StaticResource GlowBtn}" Margin="0,0,0,10"/>
                                <Button Name="BtnOpenBlacklistPage" Content="🌐 เปิดหน้าค้นหา Blacklistseller (report_search_page)" Style="{StaticResource SecondaryBtn}"/>
                            </StackPanel>
                        </Border>

                        <!-- Guidance Box -->
                        <Border Grid.Row="1" Background="#0B1120" BorderBrush="#1F2937" BorderThickness="1" CornerRadius="12" Padding="18" Margin="0,16,0,0">
                            <StackPanel>
                                <TextBlock Text="💡 ข้อมูลสำคัญเกี่ยวกับระบบค้นหา:" FontSize="13" FontWeight="Bold" Foreground="#FCA5A5" Margin="0,0,0,10"/>
                                <TextBlock Text="• ระบบนี้เชื่อมต่อกับ https://www.blacklistseller.com/report/report_search_page โดยตรง" FontSize="11" Foreground="#CBD5E1" Margin="0,0,0,6" TextWrapping="Wrap"/>
                                <TextBlock Text="• ไม่ต้องใช้ QR Code ในการสแกน เพียงพิมพ์เบอร์โทรศัพท์หรือเลขบัญชี ระบบจะส่งไปค้นหาชื่อให้ทันที" FontSize="11" Foreground="#CBD5E1" Margin="0,0,0,6" TextWrapping="Wrap"/>
                                <TextBlock Text="• ไม่ใช้เว็บอื่น ตัด Whoscall, Facebook, Line, Google ออกทั้งหมด เพื่อให้ค้นหาได้ตรงจุด" FontSize="11" Foreground="#CBD5E1" TextWrapping="Wrap"/>
                            </StackPanel>
                        </Border>
                    </Grid>

                    <!-- RIGHT: BLACKLISTSELLER INTELLIGENCE DISPLAY -->
                    <Grid Grid.Column="1">
                        <ScrollViewer VerticalScrollBarVisibility="Auto">
                            <StackPanel>

                                <!-- BLACKLISTSELLER HERO CARD -->
                                <Border Style="{StaticResource PlatformCard}" BorderBrush="#DC2626">
                                    <StackPanel>
                                        <Grid Margin="0,0,0,14">
                                            <Grid.ColumnDefinitions>
                                                <ColumnDefinition Width="Auto"/>
                                                <ColumnDefinition Width="*"/>
                                                <ColumnDefinition Width="Auto"/>
                                            </Grid.ColumnDefinitions>
                                            <TextBlock Grid.Column="0" Text="🚨" FontSize="36" VerticalAlignment="Center" Margin="0,0,14,0"/>
                                            <StackPanel Grid.Column="1" VerticalAlignment="Center">
                                                <StackPanel Orientation="Horizontal">
                                                    <TextBlock Text="Blacklistseller Database" FontSize="18" FontWeight="Bold" Foreground="#FFFFFF"/>
                                                    <Border Background="#DC2626" CornerRadius="4" Padding="6,2" Margin="10,0,0,0">
                                                        <TextBlock Text="ฐานข้อมูลคนโกงอันดับ 1 ของไทย" FontSize="9" FontWeight="Bold" Foreground="#FFFFFF"/>
                                                    </Border>
                                                </StackPanel>
                                                <TextBlock Text="ตรวจสอบประวัติฉ้อโกง, บัญชีม้า, เบอร์โทรหลอกลวง, รายงานผู้เสียหาย และสำเนาแจ้งความ" FontSize="12" Foreground="#94A3B8" Margin="0,4,0,0"/>
                                            </StackPanel>
                                            <Button Name="BtnSearchBlacklistDirect" Grid.Column="2" Content="🔍 ค้นหาทันที" Style="{StaticResource GlowBtn}"/>
                                        </Grid>

                                        <Border Background="#090D1C" CornerRadius="10" Padding="16" BorderBrush="#334155" BorderThickness="1">
                                            <StackPanel>
                                                <TextBlock Text="🔗 Target Query Endpoint:" FontSize="11" FontWeight="Bold" Foreground="#38BDF8" Margin="0,0,0,4"/>
                                                <TextBlock Name="TxtBlacklistUrlPreview" Text="https://www.blacklistseller.com/report/report_search_page" FontSize="12" Foreground="#94A3B8" TextWrapping="Wrap"/>
                                            </StackPanel>
                                        </Border>
                                    </StackPanel>
                                </Border>

                                <!-- IN-APP NOTICE -->
                                <Border Style="{StaticResource PlatformCard}" BorderBrush="#10B981">
                                    <StackPanel>
                                        <TextBlock Text="🛡️ ค้นหาชื่อโดยตรง (Direct Identity Search)" FontSize="15" FontWeight="Bold" Foreground="#10B981" Margin="0,0,0,8"/>
                                        <TextBlock Text="เมื่อท่านกรอกเบอร์โทรหรือเลขบัญชี ระบบจะประมวลผลและเปิดหน้าค้นหาสำเร็จ (report_search_success_page) พร้อมแสดงชื่อและคดีฉ้อโกงให้ทันที โดยไม่ต้องสแกน QR Code อีกต่อไป" FontSize="12" Foreground="#CBD5E1" LineHeight="18" TextWrapping="Wrap"/>
                                    </StackPanel>
                                </Border>

                            </StackPanel>
                        </ScrollViewer>
                    </Grid>
                </Grid>
            </TabItem>

            <!-- ================= TAB 2: FACECHECK.ID DIRECT SEARCH ================= -->
            <TabItem Header="👤  ค้นหาใบหน้า (FaceCheck.ID Direct)">
                <Grid Margin="0,14,0,0">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="480" MinWidth="400"/>
                        <ColumnDefinition Width="*"/>
                    </Grid.ColumnDefinitions>

                    <!-- LEFT: IMAGE DROPZONE -->
                    <Grid Grid.Column="0" Margin="0,0,18,0">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="*"/>
                        </Grid.RowDefinitions>

                        <!-- Dropzone -->
                        <Border Name="DropZoneBorder" Grid.Row="0" Background="#0F172A" BorderBrush="#8B5CF6" BorderThickness="2" CornerRadius="14" Height="280" AllowDrop="True">
                            <Grid>
                                <StackPanel Name="DropPlaceholder" VerticalAlignment="Center" HorizontalAlignment="Center">
                                    <TextBlock Text="📸" FontSize="44" HorizontalAlignment="Center" Margin="0,0,0,8"/>
                                    <TextBlock Text="ลากรูปภาพมาวางที่นี่ (Drag &amp; Drop)" FontSize="15" FontWeight="Bold" Foreground="#F3F4F6" HorizontalAlignment="Center"/>
                                    <TextBlock Text="หรือคลิกปุ่มเพื่อเลือกไฟล์รูปภาพใบหน้า" FontSize="12" Foreground="#64748B" HorizontalAlignment="Center" Margin="0,4,0,14"/>
                                    <StackPanel Orientation="Horizontal" HorizontalAlignment="Center">
                                        <Button Name="BtnBrowseFile" Content="📂 เลือกไฟล์รูปภาพ" Style="{StaticResource PurpleBtn}" Margin="0,0,8,0"/>
                                        <Button Name="BtnPasteClipboard" Content="📋 วางภาพ (Ctrl+V)" Style="{StaticResource SecondaryBtn}"/>
                                    </StackPanel>
                                </StackPanel>

                                <Image Name="PreviewImage" Stretch="Uniform" Visibility="Collapsed" Margin="8"/>

                                <Border Name="ImageLoadedBadge" Background="#10B981" CornerRadius="4" Padding="6,3" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="14" Visibility="Collapsed">
                                    <TextBlock Text="✓ IMAGE LOADED" FontSize="10" FontWeight="Bold" Foreground="#FFFFFF"/>
                                </Border>
                            </Grid>
                        </Border>

                        <!-- Public URL Banner -->
                        <Border Grid.Row="1" Background="#1E293B" BorderBrush="#334155" BorderThickness="1" CornerRadius="8" Padding="12,10" Margin="0,10,0,10">
                            <StackPanel>
                                <Grid>
                                    <Grid.ColumnDefinitions><ColumnDefinition Width="Auto"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
                                    <TextBlock Grid.Column="0" Text="🔗 Status:" FontSize="11" FontWeight="Bold" Foreground="#38BDF8" Margin="0,0,6,0"/>
                                    <TextBlock Name="TxtPublicUrl" Grid.Column="1" Text="พร้อมสำหรับสแกนใบหน้าบน FaceCheck.ID" FontSize="11" Foreground="#94A3B8" TextTrimming="CharacterEllipsis"/>
                                </Grid>
                                <ProgressBar Name="UploadProgressBar" Height="4" Margin="0,6,0,0" Background="#0F172A" Foreground="#8B5CF6" IsIndeterminate="False" Visibility="Collapsed"/>
                            </StackPanel>
                        </Border>

                        <!-- File Stats -->
                        <Border Grid.Row="2" Background="#0B1120" BorderBrush="#1F2937" BorderThickness="1" CornerRadius="10" Padding="14">
                            <StackPanel>
                                <TextBlock Text="🔍 รายละเอียดภาพใบหน้า" FontSize="13" FontWeight="Bold" Foreground="#A78BFA" Margin="0,0,0,8"/>
                                <Grid Margin="0,2,0,4">
                                    <Grid.ColumnDefinitions><ColumnDefinition Width="80"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
                                    <TextBlock Grid.Column="0" Text="ชื่อไฟล์:" Foreground="#94A3B8" FontSize="12"/>
                                    <TextBlock Name="TxtFileName" Grid.Column="1" Text="ยังไม่ได้เลือกรูป" Foreground="#F3F4F6" FontSize="12" TextTrimming="CharacterEllipsis"/>
                                </Grid>
                                <Grid Margin="0,2,0,4">
                                    <Grid.ColumnDefinitions><ColumnDefinition Width="80"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
                                    <TextBlock Grid.Column="0" Text="ความละเอียด:" Foreground="#94A3B8" FontSize="12"/>
                                    <TextBlock Name="TxtDimensions" Grid.Column="1" Text="-" Foreground="#F3F4F6" FontSize="12"/>
                                </Grid>
                                <Grid Margin="0,2,0,4">
                                    <Grid.ColumnDefinitions><ColumnDefinition Width="80"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
                                    <TextBlock Grid.Column="0" Text="ขนาดไฟล์:" Foreground="#94A3B8" FontSize="12"/>
                                    <TextBlock Name="TxtFileSize" Grid.Column="1" Text="-" Foreground="#F3F4F6" FontSize="12"/>
                                </Grid>
                            </StackPanel>
                        </Border>
                    </Grid>

                    <!-- RIGHT: FACECHECK.ID CARD -->
                    <Grid Grid.Column="1">
                        <ScrollViewer VerticalScrollBarVisibility="Auto">
                            <StackPanel>

                                <!-- FACECHECK.ID DEDICATED CARD -->
                                <Border Style="{StaticResource PlatformCard}" BorderBrush="#8B5CF6">
                                    <StackPanel>
                                        <Grid Margin="0,0,0,16">
                                            <Grid.ColumnDefinitions>
                                                <ColumnDefinition Width="Auto"/>
                                                <ColumnDefinition Width="*"/>
                                                <ColumnDefinition Width="Auto"/>
                                            </Grid.ColumnDefinitions>
                                            <TextBlock Grid.Column="0" Text="👤" FontSize="36" VerticalAlignment="Center" Margin="0,0,14,0"/>
                                            <StackPanel Grid.Column="1" VerticalAlignment="Center">
                                                <StackPanel Orientation="Horizontal">
                                                    <TextBlock Text="FaceCheck.ID Facial Recognition" FontSize="18" FontWeight="Bold" Foreground="#FFFFFF"/>
                                                    <Border Background="#8B5CF6" CornerRadius="4" Padding="6,2" Margin="10,0,0,0">
                                                        <TextBlock Text="AI Face Search" FontSize="9" FontWeight="Bold" Foreground="#FFFFFF"/>
                                                    </Border>
                                                </StackPanel>
                                                <TextBlock Text="สแกนใบหน้าโดยตรง เพื่อค้นหาโปรไฟล์บน Instagram, Facebook, TikTok, Twitter/X, OnlyFans, LinkedIn" FontSize="12" Foreground="#94A3B8" Margin="0,4,0,0"/>
                                            </StackPanel>
                                            <Button Name="BtnSearchFaceCheck" Grid.Column="2" Content="👤 ค้นหาบน FaceCheck.ID ทันที" Style="{StaticResource PurpleBtn}"/>
                                        </Grid>

                                        <Border Background="#090D1C" CornerRadius="10" Padding="16" BorderBrush="#334155" BorderThickness="1">
                                            <StackPanel>
                                                <TextBlock Text="🛡️ เฉพาะ FaceCheck.ID โดยตรง (ไม่ใช้เว็บอื่น)" FontSize="13" FontWeight="Bold" Foreground="#A78BFA" Margin="0,0,0,4"/>
                                                <TextBlock Text="ระบบตัดเว็บค้นหารูปทั่วไป (Yandex, Google, TinEye, Bing, Baidu) ออกทั้งหมด เพื่อให้ท่านสืบค้นใบหน้าผ่าน FaceCheck.ID ได้โดยตรงอย่างแม่นยำ" FontSize="12" Foreground="#CBD5E1" LineHeight="18" TextWrapping="Wrap"/>
                                            </StackPanel>
                                        </Border>
                                    </StackPanel>
                                </Border>

                            </StackPanel>
                        </ScrollViewer>
                    </Grid>
                </Grid>
            </TabItem>

        </TabControl>

        <!-- STATUS BAR -->
        <Border Grid.Row="2" Background="#05080E" BorderBrush="#1F2937" BorderThickness="0,1,0,0" Padding="20,0">
            <Grid VerticalAlignment="Center">
                <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                <StackPanel Grid.Column="0" Orientation="Horizontal">
                    <TextBlock Text="●" Name="StatusDot" Foreground="#10B981" FontSize="14" VerticalAlignment="Center" Margin="0,0,6,0"/>
                    <TextBlock Name="TxtStatus" Text="พร้อมใช้งาน: ค้นหาชื่อบน Blacklistseller หรือสแกนใบหน้าบน FaceCheck.ID ได้ทันที" FontSize="12" Foreground="#94A3B8" VerticalAlignment="Center"/>
                </StackPanel>
                <TextBlock Grid.Column="1" Text="OmniReverse Direct v6.0 | Ready" FontSize="11" Foreground="#64748B" VerticalAlignment="Center"/>
            </Grid>
        </Border>
    </Grid>
</Window>
"@

$global:CurrentFilePath = ""
$global:CurrentPublicUrl = ""
$global:CurrentBitmap = $null

$reader = [System.Xml.XmlReader]::Create([System.IO.StringReader]::new($xamlString))
$window = [System.Windows.Markup.XamlReader]::Load($reader)

# Element References
$appLogoImage = $window.FindName("AppLogoImage")
$mainTabControl = $window.FindName("MainTabControl")
$dropZoneBorder = $window.FindName("DropZoneBorder")
$dropPlaceholder = $window.FindName("DropPlaceholder")
$previewImage = $window.FindName("PreviewImage")
$imageLoadedBadge = $window.FindName("ImageLoadedBadge")

$btnOpenWebApp = $window.FindName("BtnOpenWebApp")
$btnBrowseFile = $window.FindName("BtnBrowseFile")
$btnPasteClipboard = $window.FindName("BtnPasteClipboard")
$btnClearAll = $window.FindName("BtnClearAll")

$txtPublicUrl = $window.FindName("TxtPublicUrl")
$uploadProgressBar = $window.FindName("UploadProgressBar")

$txtFileName = $window.FindName("TxtFileName")
$txtDimensions = $window.FindName("TxtDimensions")
$txtFileSize = $window.FindName("TxtFileSize")

$btnSearchFaceCheck = $window.FindName("BtnSearchFaceCheck")

# Blacklistseller Tab Elements
$txtPhoneNumber = $window.FindName("TxtPhoneNumber")
$txtCarrierDetect = $window.FindName("TxtCarrierDetect")
$txtTargetFormat = $window.FindName("TxtTargetFormat")
$btnLookupBlacklist = $window.FindName("BtnLookupBlacklist")
$btnOpenBlacklistPage = $window.FindName("BtnOpenBlacklistPage")
$btnSearchBlacklistDirect = $window.FindName("BtnSearchBlacklistDirect")
$txtBlacklistUrlPreview = $window.FindName("TxtBlacklistUrlPreview")

$statusDot = $window.FindName("StatusDot")
$txtStatus = $window.FindName("TxtStatus")

# Load App Logo
if (Test-Path $logoPath) {
    try {
        $logoBmp = New-Object System.Windows.Media.Imaging.BitmapImage
        $logoBmp.BeginInit()
        $logoBmp.UriSource = [System.Uri]::new((Resolve-Path $logoPath).Path)
        $logoBmp.CacheOption = [System.Windows.Media.Imaging.BitmapCacheOption]::OnLoad
        $logoBmp.EndInit()
        $appLogoImage.Source = $logoBmp
    } catch {}
}

function Set-AppStatus([string]$msg, [string]$color = "#10B981") {
    $window.Dispatcher.Invoke([Action]{
        $txtStatus.Text = $msg
        $statusDot.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString($color)
    })
}

function Open-Url([string]$url) {
    if (-not $url) { return }
    try {
        [System.Diagnostics.Process]::Start([System.Diagnostics.ProcessStartInfo]::new($url) | ForEach-Object { $_.UseShellExecute = $true; $_ })
    } catch {
        Start-Process $url
    }
}

function Load-ImageFile([string]$path) {
    if (-not (Test-Path $path)) { return }
    $global:CurrentFilePath = $path
    $global:CurrentPublicUrl = ""

    try {
        $bmp = New-Object System.Windows.Media.Imaging.BitmapImage
        $bmp.BeginInit()
        $bmp.UriSource = [System.Uri]::new((Resolve-Path $path).Path)
        $bmp.CacheOption = [System.Windows.Media.Imaging.BitmapCacheOption]::OnLoad
        $bmp.EndInit()

        $global:CurrentBitmap = $bmp
        $previewImage.Source = $bmp
        $dropPlaceholder.Visibility = [System.Windows.Visibility]::Collapsed
        $previewImage.Visibility = [System.Windows.Visibility]::Visible
        $imageLoadedBadge.Visibility = [System.Windows.Visibility]::Visible

        $fi = Get-Item $path
        $txtFileName.Text = $fi.Name
        $txtDimensions.Text = "$($bmp.PixelWidth) × $($bmp.PixelHeight) px"
        $sizeKb = [Math]::Round($fi.Length / 1KB, 1)
        $txtFileSize.Text = "$sizeKb KB"

        try { [System.Windows.Clipboard]::SetImage($bmp) } catch {}

        Set-AppStatus "โหลดรูปภาพใบหน้าเรียบร้อยแล้ว พร้อมค้นหาบน FaceCheck.ID" "#8B5CF6"
    } catch {
        [System.Windows.MessageBox]::Show("เกิดข้อผิดพลาดในการโหลดรูป: $($_.Exception.Message)", "Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}

# Drag & Drop Handlers
$dropZoneBorder.Add_DragOver({
    param($s, $e)
    if ($e.Data.GetDataPresent([System.Windows.DataFormats]::FileDrop)) {
        $e.Effects = [System.Windows.DragDropEffects]::Copy
    } else {
        $e.Effects = [System.Windows.DragDropEffects]::None
    }
    $e.Handled = $true
})

$dropZoneBorder.Add_Drop({
    param($s, $e)
    if ($e.Data.GetDataPresent([System.Windows.DataFormats]::FileDrop)) {
        $files = $e.Data.GetData([System.Windows.DataFormats]::FileDrop)
        if ($files -and $files.Count -gt 0) {
            Load-ImageFile $files[0]
        }
    }
})

$btnBrowseFile.Add_Click({
    $dlg = New-Object System.Windows.Forms.OpenFileDialog
    $dlg.Title = "เลือกรูปภาพใบหน้าที่ต้องการค้นหา"
    $dlg.Filter = "Image Files (*.jpg;*.jpeg;*.png;*.webp;*.gif;*.bmp)|*.jpg;*.jpeg;*.png;*.webp;*.gif;*.bmp|All Files (*.*)|*.*"
    if ($dlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        Load-ImageFile $dlg.FileName
    }
})

$btnPasteClipboard.Add_Click({
    if ([System.Windows.Clipboard]::ContainsImage()) {
        $imgSource = [System.Windows.Clipboard]::GetImage()
        $tempPath = Join-Path $env:TEMP "OmniReverse_Direct_$([Guid]::NewGuid().ToString('N')).png"
        
        $encoder = New-Object System.Windows.Media.Imaging.PngBitmapEncoder
        $encoder.Frames.Add([System.Windows.Media.Imaging.BitmapFrame]::Create($imgSource))
        $fs = New-Object System.IO.FileStream($tempPath, [System.IO.FileMode]::Create)
        $encoder.Save($fs)
        $fs.Close()
        $fs.Dispose()

        Load-ImageFile $tempPath
    } elseif ([System.Windows.Clipboard]::ContainsFileDropList()) {
        $files = [System.Windows.Clipboard]::GetFileDropList()
        if ($files.Count -gt 0) { Load-ImageFile $files[0] }
    } else {
        [System.Windows.MessageBox]::Show("ไม่พบรูปในคลิปบอร์ด กรุณาใช้ Win+Shift+S เพื่อแคปภาพก่อน", "คลิปบอร์ดว่างเปล่า", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    }
})

$btnOpenWebApp.Add_Click({
    if (Test-Path $htmlPath) {
        Open-Url "file:///$($htmlPath.Replace('\', '/'))"
    } else {
        Open-Url "https://www.blacklistseller.com/report/report_search_page"
    }
})

$btnClearAll.Add_Click({
    $global:CurrentFilePath = ""
    $global:CurrentPublicUrl = ""
    $global:CurrentBitmap = $null
    
    $previewImage.Source = $null
    $previewImage.Visibility = [System.Windows.Visibility]::Collapsed
    $dropPlaceholder.Visibility = [System.Windows.Visibility]::Visible
    $imageLoadedBadge.Visibility = [System.Windows.Visibility]::Collapsed
    
    $txtFileName.Text = "ยังไม่ได้เลือกรูป"
    $txtDimensions.Text = "-"
    $txtFileSize.Text = "-"
    $txtPhoneNumber.Text = ""
    $txtCarrierDetect.Text = "กรุณาพิมพ์เบอร์โทร หรือชื่อ..."
    $txtTargetFormat.Text = "-"
    $txtBlacklistUrlPreview.Text = "https://www.blacklistseller.com/report/report_search_page"

    Set-AppStatus "ล้างข้อมูลทั้งหมดเรียบร้อยแล้ว" "#10B981"
})

# ================= BLACKLISTSELLER SEARCH LOGIC =================
function Update-BlacklistDetect {
    $raw = $txtPhoneNumber.Text.Trim()
    if (-not $raw) {
        $txtCarrierDetect.Text = "กรุณาพิมพ์เบอร์โทร หรือชื่อ..."
        $txtTargetFormat.Text = "-"
        $txtBlacklistUrlPreview.Text = "https://www.blacklistseller.com/report/report_search_page"
        return
    }

    $clean = $raw -replace "[^0-9]", ""
    $isDigits = ($clean.Length -ge 8 -and ($raw -replace "[- ]", "") -match "^[0-9]+$")

    if ($isDigits) {
        $txtTargetFormat.Text = "ค้นหาด้วยเลขหมาย/บัญชี (bank_number: $clean)"
        $txtBlacklistUrlPreview.Text = "https://www.blacklistseller.com/report/report_search_success_page?bank_number=$clean"

        if ($clean.StartsWith("08") -or $clean.StartsWith("09") -or $clean.StartsWith("06")) {
            $prefix = $clean.Substring(0, [Math]::Min(3, $clean.Length))
            if (@('080','081','082','087','089','092','093','097','098','061','062','063','066') -contains $prefix) {
                $txtCarrierDetect.Text = "เบอร์มือถือไทย (กลุ่ม AIS/AWN)"
            } elseif (@('083','084','085','086','090','091','094','095','096','099','064') -contains $prefix) {
                $txtCarrierDetect.Text = "เบอร์มือถือไทย (กลุ่ม TrueMove H / DTAC)"
            } elseif (@('088','065') -contains $prefix) {
                $txtCarrierDetect.Text = "เบอร์มือถือไทย (กลุ่ม NT Mobile / my by CAT)"
            } else {
                $txtCarrierDetect.Text = "เบอร์มือถือประเทศไทย (+66)"
            }
        } elseif ($clean.StartsWith("02")) {
            $txtCarrierDetect.Text = "เบอร์บ้าน/สำนักงาน (กทม./นนทบุรี/ปทุมธานี/สมุทรปราการ)"
        } else {
            $txtCarrierDetect.Text = "เลขบัญชีธนาคาร / TrueMoney Wallet"
        }
    } else {
        $parts = $raw.Split(' ')
        $fName = [System.Web.HttpUtility]::UrlEncode($parts[0])
        $lName = if ($parts.Count -gt 1) { [System.Web.HttpUtility]::UrlEncode($parts[1..($parts.Count - 1)] -join ' ') } else { "" }
        $txtTargetFormat.Text = "ค้นหาด้วยชื่อ-นามสกุล (first_name: $($parts[0]))"
        $txtCarrierDetect.Text = "ชื่อบุคคล / ผู้รับโอนเงิน"
        $txtBlacklistUrlPreview.Text = "https://www.blacklistseller.com/report/report_search_success_page?first_name=$fName&last_name=$lName"
    }
}

$txtPhoneNumber.Add_TextChanged({ Update-BlacklistDetect })

function Exec-BlacklistsellerSearch {
    $raw = $txtPhoneNumber.Text.Trim()
    if (-not $raw) {
        [System.Windows.MessageBox]::Show("กรุณากรอกเบอร์โทรศัพท์, เลขที่บัญชี หรือชื่อ-นามสกุลก่อนครับ", "แจ้งเตือน", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
        return
    }

    $clean = $raw -replace "[^0-9]", ""
    $isDigits = ($clean.Length -ge 8 -and ($raw -replace "[- ]", "") -match "^[0-9]+$")

    if ($isDigits) {
        $targetUrl = "https://www.blacklistseller.com/report/report_search_success_page?bank_number=$clean"
    } else {
        $parts = $raw.Split(' ')
        $fName = [System.Web.HttpUtility]::UrlEncode($parts[0])
        $lName = if ($parts.Count -gt 1) { [System.Web.HttpUtility]::UrlEncode($parts[1..($parts.Count - 1)] -join ' ') } else { "" }
        $targetUrl = "https://www.blacklistseller.com/report/report_search_success_page?first_name=$fName&last_name=$lName"
    }

    Open-Url $targetUrl
    Set-AppStatus "ค้นหา '$raw' บน Blacklistseller เรียบร้อยแล้ว (Direct Search)" "#EF4444"
}

$btnLookupBlacklist.Add_Click({ Exec-BlacklistsellerSearch })
$btnSearchBlacklistDirect.Add_Click({ Exec-BlacklistsellerSearch })
$btnOpenBlacklistPage.Add_Click({
    Open-Url "https://www.blacklistseller.com/report/report_search_page"
})

# ================= FACECHECK.ID SEARCH LOGIC =================
function Exec-FaceCheckDirect {
    Open-Url "https://facecheck.id/"
    Set-AppStatus "เปิดระบบ FaceCheck.ID Facial Recognition เรียบร้อยแล้ว (Direct Search)" "#8B5CF6"
}

$btnSearchFaceCheck.Add_Click({ Exec-FaceCheckDirect })

$window.ShowDialog() | Out-Null
