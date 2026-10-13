<#
================================================================================
  OmniReverse OSINT Ultra — Pro Reverse Search & Phone Intelligence Hub
  Version: 5.0 Pro Ultra (Image OSINT + Phone Intelligence & Fraud Check)
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
        Title="OmniReverse Ultra Pro — เครื่องมือค้นหารูปภาพ &amp; เบอร์โทรศัพท์ข้ามทุกแพลตฟอร์ม v5.0"
        Height="910" Width="1300" MinHeight="780" MinWidth="1120"
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
            <Setter Property="Background" Value="#2563EB"/>
            <Setter Property="Foreground" Value="#FFFFFF"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="FontSize" Value="13"/>
            <Setter Property="Padding" Value="16,10"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="border" Background="{TemplateBinding Background}" CornerRadius="8" Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="border" Property="Background" Value="#3B82F6"/>
                            </Trigger>
                            <Trigger Property="IsPressed" Value="True">
                                <Setter TargetName="border" Property="Background" Value="#1D4ED8"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style x:Key="EmeraldBtn" TargetType="Button">
            <Setter Property="Background" Value="#059669"/>
            <Setter Property="Foreground" Value="#FFFFFF"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="FontSize" Value="13"/>
            <Setter Property="Padding" Value="16,10"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="border" Background="{TemplateBinding Background}" CornerRadius="8" Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="border" Property="Background" Value="#10B981"/>
                            </Trigger>
                            <Trigger Property="IsPressed" Value="True">
                                <Setter TargetName="border" Property="Background" Value="#047857"/>
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
            <Setter Property="Padding" Value="14,8"/>
            <Setter Property="BorderBrush" Value="#334155"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="border" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="7" Padding="{TemplateBinding Padding}">
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
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="CornerRadius" Value="10"/>
            <Setter Property="Padding" Value="14,12"/>
            <Setter Property="Margin" Value="0,0,0,10"/>
        </Style>

        <Style TargetType="TabItem">
            <Setter Property="Foreground" Value="#94A3B8"/>
            <Setter Property="FontSize" Value="13"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="Padding" Value="20,10"/>
            <Setter Property="Background" Value="#0B1120"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Margin" Value="0,0,6,0"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="TabItem">
                        <Border x:Name="TabBorder" Background="{TemplateBinding Background}" CornerRadius="8,8,0,0" Padding="{TemplateBinding Padding}" Margin="{TemplateBinding Margin}">
                            <ContentPresenter ContentSource="Header" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsSelected" Value="True">
                                <Setter TargetName="TabBorder" Property="Background" Value="#1E293B"/>
                                <Setter Property="Foreground" Value="#38BDF8"/>
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
                            <Border Background="#8B5CF6" CornerRadius="4" Padding="6,2" Margin="10,0,0,0" VerticalAlignment="Center">
                                <TextBlock Text="ULTRA PRO v5.0" FontSize="10" FontWeight="Bold" Foreground="#FFFFFF"/>
                            </Border>
                            <Border Background="#10B981" CornerRadius="4" Padding="6,2" Margin="6,0,0,0" VerticalAlignment="Center">
                                <TextBlock Text="IMAGE &amp; PHONE DUAL MODE" FontSize="10" FontWeight="Bold" Foreground="#FFFFFF"/>
                            </Border>
                        </StackPanel>
                        <TextBlock Text="ระบบสแกนรูปภาพข้ามแพลตฟอร์ม &amp; ระบบเจาะลึกเบอร์โทรศัพท์ (Whoscall, Truecaller, LINE, Fraud Check)" FontSize="11" Foreground="#94A3B8" Margin="0,3,0,0"/>
                    </StackPanel>
                </StackPanel>

                <StackPanel Grid.Column="2" Orientation="Horizontal" VerticalAlignment="Center">
                    <Button Name="BtnOpenWebApp" Content="🌐 เปิดเวอร์ชันเว็บ (HTML)" Style="{StaticResource SecondaryBtn}" Margin="0,0,10,0"/>
                    <Button Name="BtnClearAll" Content="🗑️ ล้างข้อมูล" Style="{StaticResource SecondaryBtn}" Margin="0,0,10,0"/>
                    <Button Name="BtnMasterSearch" Content="🚀 เปิดทุกเครื่องมือพร้อมกัน" Style="{StaticResource GlowBtn}"/>
                </StackPanel>
            </Grid>
        </Border>

        <!-- MAIN TABS -->
        <TabControl Name="MainTabControl" Grid.Row="1" Background="Transparent" BorderThickness="0" Margin="16,10,16,10">

            <!-- ================= TAB 1: IMAGE OSINT ================= -->
            <TabItem Header="📸  ค้นหาด้วยรูปภาพ &amp; สแกนใบหน้า (Image OSINT)">
                <Grid Margin="0,14,0,0">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="450" MinWidth="370"/>
                        <ColumnDefinition Width="*"/>
                    </Grid.ColumnDefinitions>

                    <!-- LEFT -->
                    <Grid Grid.Column="0" Margin="0,0,16,0">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="*"/>
                        </Grid.RowDefinitions>

                        <!-- Dropzone -->
                        <Border Name="DropZoneBorder" Grid.Row="0" Background="#0F172A" BorderBrush="#06B6D4" BorderThickness="2" CornerRadius="12" Height="280" AllowDrop="True">
                            <Grid>
                                <StackPanel Name="DropPlaceholder" VerticalAlignment="Center" HorizontalAlignment="Center">
                                    <TextBlock Text="📸" FontSize="44" HorizontalAlignment="Center" Margin="0,0,0,8"/>
                                    <TextBlock Text="ลากรูปภาพมาวางที่นี่ (Drag &amp; Drop)" FontSize="15" FontWeight="Bold" Foreground="#F3F4F6" HorizontalAlignment="Center"/>
                                    <TextBlock Text="ระบบจะอัปโหลดภาพและเตรียมลิงก์ผลลัพธ์ตรงทันที" FontSize="12" Foreground="#64748B" HorizontalAlignment="Center" Margin="0,4,0,14"/>
                                    <StackPanel Orientation="Horizontal" HorizontalAlignment="Center">
                                        <Button Name="BtnBrowseFile" Content="📂 เลือกไฟล์รูปภาพ" Style="{StaticResource GlowBtn}" Margin="0,0,8,0"/>
                                        <Button Name="BtnPasteClipboard" Content="📋 วางภาพ (Ctrl+V)" Style="{StaticResource SecondaryBtn}"/>
                                    </StackPanel>
                                </StackPanel>

                                <Image Name="PreviewImage" Stretch="Uniform" Visibility="Collapsed" Margin="8"/>

                                <Border Name="ImageLoadedBadge" Background="#10B981" CornerRadius="4" Padding="6,3" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="14" Visibility="Collapsed">
                                    <TextBlock Text="✓ IMAGE LOADED" FontSize="10" FontWeight="Bold" Foreground="#FFFFFF"/>
                                </Border>
                            </Grid>
                        </Border>

                        <!-- Direct URL Banner -->
                        <Border Grid.Row="1" Background="#1E293B" BorderBrush="#334155" BorderThickness="1" CornerRadius="8" Padding="12,10" Margin="0,10,0,10">
                            <StackPanel>
                                <Grid>
                                    <Grid.ColumnDefinitions><ColumnDefinition Width="Auto"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
                                    <TextBlock Grid.Column="0" Text="🔗 Direct Search URL:" FontSize="11" FontWeight="Bold" Foreground="#38BDF8" Margin="0,0,6,0"/>
                                    <TextBlock Name="TxtPublicUrl" Grid.Column="1" Text="กำลังรอรูปภาพ..." FontSize="11" Foreground="#94A3B8" TextTrimming="CharacterEllipsis"/>
                                </Grid>
                                <ProgressBar Name="UploadProgressBar" Height="4" Margin="0,6,0,0" Background="#0F172A" Foreground="#06B6D4" IsIndeterminate="False" Visibility="Collapsed"/>
                            </StackPanel>
                        </Border>

                        <!-- Forensic Box -->
                        <Border Grid.Row="2" Background="#0B1120" BorderBrush="#1F2937" BorderThickness="1" CornerRadius="10" Padding="14">
                            <ScrollViewer VerticalScrollBarVisibility="Auto">
                                <StackPanel>
                                    <TextBlock Text="🔍 รายละเอียดภาพ &amp; ดิจิทัลฟอเรนสิกส์" FontSize="13" FontWeight="Bold" Foreground="#38BDF8" Margin="0,0,0,8"/>

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

                                    <Separator Background="#1F2937" Margin="0,8,0,8"/>

                                    <TextBlock Text="MD5 Checksum (ค้นหาไฟล์ซ้ำบน Discord CDN):" Foreground="#94A3B8" FontSize="11" Margin="0,0,0,2"/>
                                    <TextBox Name="TxtMd5Hash" IsReadOnly="True" Background="#1E293B" Foreground="#A78BFA" BorderThickness="0" Padding="6,4" FontSize="11" Margin="0,0,0,6"/>

                                    <TextBlock Text="SHA-256 Signature:" Foreground="#94A3B8" FontSize="11" Margin="0,0,0,2"/>
                                    <TextBox Name="TxtSha256" IsReadOnly="True" Background="#1E293B" Foreground="#A78BFA" BorderThickness="0" Padding="6,4" FontSize="10"/>
                                </StackPanel>
                            </ScrollViewer>
                        </Border>
                    </Grid>

                    <!-- RIGHT -->
                    <Grid Grid.Column="1">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="*"/>
                        </Grid.RowDefinitions>

                        <!-- Dork Bar -->
                        <Border Grid.Row="0" Background="#0F172A" BorderBrush="#3B82F6" BorderThickness="1.5" CornerRadius="12" Padding="16,12" Margin="0,0,0,12">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="Auto"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="Auto"/>
                                </Grid.ColumnDefinitions>
                                <TextBlock Grid.Column="0" Text="🏷️ คำสำคัญเสริม (ชื่อ/username):" Foreground="#94A3B8" FontSize="12" VerticalAlignment="Center" Margin="0,0,10,0"/>
                                <TextBox Name="TxtKeywordFilter" Grid.Column="1" Background="#1E293B" Foreground="#FFFFFF" BorderBrush="#334155" BorderThickness="1" Padding="8,6" FontSize="12"/>
                                <Button Name="BtnQuickDork" Grid.Column="2" Content="🔍 เจาะหาโซเชียล" Style="{StaticResource SecondaryBtn}" Margin="8,0,0,0"/>
                            </Grid>
                        </Border>

                        <!-- ENGINE CARDS -->
                        <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto">
                            <StackPanel>

                                <!-- 1. YANDEX -->
                                <Border Style="{StaticResource PlatformCard}" BorderBrush="#FC3F1D" BorderThickness="1.2">
                                    <Grid>
                                        <Grid.ColumnDefinitions><ColumnDefinition Width="48"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                        <TextBlock Grid.Column="0" Text="🌐" FontSize="26" VerticalAlignment="Center" HorizontalAlignment="Center"/>
                                        <StackPanel Grid.Column="1" VerticalAlignment="Center" Margin="8,0,0,0">
                                            <StackPanel Orientation="Horizontal">
                                                <TextBlock Text="Yandex Visual Search (แม่นยำสูงสุดสำหรับหาคน &amp; โซเชียล)" FontSize="14" FontWeight="Bold" Foreground="#FFFFFF"/>
                                                <Border Background="#FC3F1D" CornerRadius="4" Padding="5,1" Margin="8,0,0,0"><TextBlock Text="สแกนทั้งรูป 100%" FontSize="9" FontWeight="Bold" Foreground="#FFFFFF"/></Border>
                                            </StackPanel>
                                            <TextBlock Text="เครื่องมือค้นหาใบหน้าอันดับ 1 ของโลก จับคู่หาบัญชี Instagram, Facebook, VK และเว็บบอร์ดที่เคยลงรูปนี้" FontSize="11" Foreground="#94A3B8" Margin="0,2,0,0"/>
                                        </StackPanel>
                                        <Button Name="BtnSearchYandex" Grid.Column="2" Content="🌐 เปิดผลลัพธ์ Yandex" Style="{StaticResource GlowBtn}" Background="#E11D48"/>
                                    </Grid>
                                </Border>

                                <!-- 2. FACECHECK.ID -->
                                <Border Style="{StaticResource PlatformCard}" BorderBrush="#8B5CF6" BorderThickness="1.2">
                                    <Grid>
                                        <Grid.ColumnDefinitions><ColumnDefinition Width="48"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                        <TextBlock Grid.Column="0" Text="👤" FontSize="26" VerticalAlignment="Center" HorizontalAlignment="Center"/>
                                        <StackPanel Grid.Column="1" VerticalAlignment="Center" Margin="8,0,0,0">
                                            <StackPanel Orientation="Horizontal">
                                                <TextBlock Text="FaceCheck.id (AI Facial Recognition OSINT)" FontSize="14" FontWeight="Bold" Foreground="#FFFFFF"/>
                                                <Border Background="#8B5CF6" CornerRadius="4" Padding="5,1" Margin="8,0,0,0"><TextBlock Text="AI Face Search" FontSize="9" FontWeight="Bold" Foreground="#FFFFFF"/></Border>
                                            </StackPanel>
                                            <TextBlock Text="สแกนใบหน้าโดยเฉพาะ เพื่อหาโปรไฟล์บน Instagram, Facebook, TikTok, Twitter/X, OnlyFans, LinkedIn" FontSize="11" Foreground="#94A3B8" Margin="0,2,0,0"/>
                                        </StackPanel>
                                        <Button Name="BtnSearchFaceCheck" Grid.Column="2" Content="👤 สแกนใบหน้า AI" Style="{StaticResource GlowBtn}" Background="#8B5CF6"/>
                                    </Grid>
                                </Border>

                                <!-- 3. GOOGLE LENS -->
                                <Border Style="{StaticResource PlatformCard}">
                                    <Grid>
                                        <Grid.ColumnDefinitions><ColumnDefinition Width="48"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                        <TextBlock Grid.Column="0" Text="🔍" FontSize="26" VerticalAlignment="Center" HorizontalAlignment="Center"/>
                                        <StackPanel Grid.Column="1" VerticalAlignment="Center" Margin="8,0,0,0">
                                            <StackPanel Orientation="Horizontal">
                                                <TextBlock Text="Google Lens (ค้นหาแหล่งที่มาของภาพทั้งรูป)" FontSize="14" FontWeight="Bold" Foreground="#FFFFFF"/>
                                                <Border Background="#EA4335" CornerRadius="4" Padding="5,1" Margin="8,0,0,0"><TextBlock Text="Direct Result" FontSize="9" FontWeight="Bold" Foreground="#FFFFFF"/></Border>
                                            </StackPanel>
                                            <TextBlock Text="เปิดหน้าผลลัพธ์ Google ที่ภาพถูกสแกนเรียบร้อย พร้อมลิงก์ไปยังเว็บและข่าวสารที่เคยลงรูปนี้" FontSize="11" Foreground="#94A3B8" Margin="0,2,0,0"/>
                                        </StackPanel>
                                        <Button Name="BtnSearchGoogle" Grid.Column="2" Content="🔍 เปิดผลลัพธ์ Google" Style="{StaticResource GlowBtn}" Background="#2563EB"/>
                                    </Grid>
                                </Border>

                                <!-- 4. TINEYE -->
                                <Border Style="{StaticResource PlatformCard}">
                                    <Grid>
                                        <Grid.ColumnDefinitions><ColumnDefinition Width="48"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                        <TextBlock Grid.Column="0" Text="👁️" FontSize="26" VerticalAlignment="Center" HorizontalAlignment="Center"/>
                                        <StackPanel Grid.Column="1" VerticalAlignment="Center" Margin="8,0,0,0">
                                            <StackPanel Orientation="Horizontal">
                                                <TextBlock Text="TinEye Reverse Search (สแกนโครงสร้างทั้งรูป)" FontSize="14" FontWeight="Bold" Foreground="#FFFFFF"/>
                                                <Border Background="#0EA5E9" CornerRadius="4" Padding="5,1" Margin="8,0,0,0"><TextBlock Text="Original Tracker" FontSize="9" FontWeight="Bold" Foreground="#FFFFFF"/></Border>
                                            </StackPanel>
                                            <TextBlock Text="สแกนลายนิ้วมือดิจิทัลทั้งภาพ แสดงรายชื่อทุกเว็บที่เคยมีรูปนี้ และวันที่รูปนี้ปรากฏบนเน็ตครั้งแรก" FontSize="11" Foreground="#94A3B8" Margin="0,2,0,0"/>
                                        </StackPanel>
                                        <Button Name="BtnSearchTinEye" Grid.Column="2" Content="👁️ เปิดผลลัพธ์ TinEye" Style="{StaticResource SecondaryBtn}"/>
                                    </Grid>
                                </Border>

                                <!-- 5. BING -->
                                <Border Style="{StaticResource PlatformCard}">
                                    <Grid>
                                        <Grid.ColumnDefinitions><ColumnDefinition Width="48"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                        <TextBlock Grid.Column="0" Text="🟦" FontSize="26" VerticalAlignment="Center" HorizontalAlignment="Center"/>
                                        <StackPanel Grid.Column="1" VerticalAlignment="Center" Margin="8,0,0,0">
                                            <StackPanel Orientation="Horizontal">
                                                <TextBlock Text="Microsoft Bing Visual Search" FontSize="14" FontWeight="Bold" Foreground="#FFFFFF"/>
                                                <Border Background="#008373" CornerRadius="4" Padding="5,1" Margin="8,0,0,0"><TextBlock Text="Bing" FontSize="9" FontWeight="Bold" Foreground="#FFFFFF"/></Border>
                                            </StackPanel>
                                            <TextBlock Text="เปิดแท็บ 'Pages With This Image' ของ Microsoft ดูเว็บและโซเชียลมีเดียที่เคยใช้รูปนี้" FontSize="11" Foreground="#94A3B8" Margin="0,2,0,0"/>
                                        </StackPanel>
                                        <Button Name="BtnSearchBing" Grid.Column="2" Content="🟦 เปิดผลลัพธ์ Bing" Style="{StaticResource SecondaryBtn}"/>
                                    </Grid>
                                </Border>

                                <!-- 6. BAIDU -->
                                <Border Style="{StaticResource PlatformCard}">
                                    <Grid>
                                        <Grid.ColumnDefinitions><ColumnDefinition Width="48"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                        <TextBlock Grid.Column="0" Text="🐉" FontSize="26" VerticalAlignment="Center" HorizontalAlignment="Center"/>
                                        <StackPanel Grid.Column="1" VerticalAlignment="Center" Margin="8,0,0,0">
                                            <StackPanel Orientation="Horizontal">
                                                <TextBlock Text="Baidu Visual Search (ฐานข้อมูลเอเชีย)" FontSize="14" FontWeight="Bold" Foreground="#FFFFFF"/>
                                                <Border Background="#2563EB" CornerRadius="4" Padding="5,1" Margin="8,0,0,0"><TextBlock Text="Asia Database" FontSize="9" FontWeight="Bold" Foreground="#FFFFFF"/></Border>
                                            </StackPanel>
                                            <TextBlock Text="ฐานข้อมูลภาพที่ใหญ่ที่สุดในเอเชีย ช่วยค้นหาภาพที่ถูกนำไปรีโพสต์ในโซเชียลฝั่งเอเชีย" FontSize="11" Foreground="#94A3B8" Margin="0,2,0,0"/>
                                        </StackPanel>
                                        <Button Name="BtnSearchBaidu" Grid.Column="2" Content="🐉 เปิดผลลัพธ์ Baidu" Style="{StaticResource SecondaryBtn}"/>
                                    </Grid>
                                </Border>

                                <!-- 7. INSTAGRAM & FACEBOOK -->
                                <Border Style="{StaticResource PlatformCard}">
                                    <Grid>
                                        <Grid.ColumnDefinitions><ColumnDefinition Width="48"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                        <TextBlock Grid.Column="0" Text="📸" FontSize="26" VerticalAlignment="Center" HorizontalAlignment="Center"/>
                                        <StackPanel Grid.Column="1" VerticalAlignment="Center" Margin="8,0,0,0">
                                            <StackPanel Orientation="Horizontal">
                                                <TextBlock Text="Instagram &amp; Facebook Targeted Dorks" FontSize="14" FontWeight="Bold" Foreground="#FFFFFF"/>
                                                <Border Background="#E1306C" CornerRadius="4" Padding="5,1" Margin="8,0,0,0"><TextBlock Text="Meta OSINT" FontSize="9" FontWeight="Bold" Foreground="#FFFFFF"/></Border>
                                            </StackPanel>
                                            <TextBlock Text="ค้นหาโปรไฟล์ ภาพถ่าย และโพสต์บน Instagram / Facebook ที่เกี่ยวข้องกับภาพนี้" FontSize="11" Foreground="#94A3B8" Margin="0,2,0,0"/>
                                        </StackPanel>
                                        <Button Name="BtnSearchInstagram" Grid.Column="2" Content="📸 เจาะหาบน IG/FB" Style="{StaticResource SecondaryBtn}"/>
                                    </Grid>
                                </Border>

                                <!-- 8. DISCORD -->
                                <Border Style="{StaticResource PlatformCard}">
                                    <Grid>
                                        <Grid.ColumnDefinitions><ColumnDefinition Width="48"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                        <TextBlock Grid.Column="0" Text="💬" FontSize="26" VerticalAlignment="Center" HorizontalAlignment="Center"/>
                                        <StackPanel Grid.Column="1" VerticalAlignment="Center" Margin="8,0,0,0">
                                            <StackPanel Orientation="Horizontal">
                                                <TextBlock Text="Discord CDN &amp; Server Matcher" FontSize="14" FontWeight="Bold" Foreground="#FFFFFF"/>
                                                <Border Background="#5865F2" CornerRadius="4" Padding="5,1" Margin="8,0,0,0"><TextBlock Text="Discord" FontSize="9" FontWeight="Bold" Foreground="#FFFFFF"/></Border>
                                            </StackPanel>
                                            <TextBlock Text="สแกนหาไฟล์แนบ cdn.discordapp.com และเซิร์ฟเวอร์สาธารณะที่เคยแชร์รูปนี้" FontSize="11" Foreground="#94A3B8" Margin="0,2,0,0"/>
                                        </StackPanel>
                                        <Button Name="BtnSearchDiscord" Grid.Column="2" Content="💬 ตรวจสอบบน Discord" Style="{StaticResource SecondaryBtn}"/>
                                    </Grid>
                                </Border>

                            </StackPanel>
                        </ScrollViewer>
                    </Grid>
                </Grid>
            </TabItem>

            <!-- ================= TAB 2: PHONE NUMBER OSINT ================= -->
            <TabItem Header="📞  ค้นหาด้วยเบอร์โทรศัพท์ (Phone Intelligence &amp; Fraud Check)">
                <Grid Margin="0,14,0,0">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="450" MinWidth="370"/>
                        <ColumnDefinition Width="*"/>
                    </Grid.ColumnDefinitions>

                    <!-- LEFT: PHONE INPUT -->
                    <Grid Grid.Column="0" Margin="0,0,16,0">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="*"/>
                        </Grid.RowDefinitions>

                        <!-- Input Box -->
                        <Border Grid.Row="0" Background="#0F172A" BorderBrush="#10B981" BorderThickness="1.5" CornerRadius="12" Padding="20">
                            <StackPanel>
                                <TextBlock Text="📞 ระบุเบอร์โทรศัพท์ที่ต้องการค้นหา" FontSize="16" FontWeight="Bold" Foreground="#FFFFFF"/>
                                <TextBlock Text="รองรับเบอร์มือถือไทย (08x, 09x, 06x), เบอร์บ้าน (02x) และเบอร์สากล" FontSize="11" Foreground="#94A3B8" Margin="0,4,0,16"/>

                                <Grid Margin="0,0,0,12">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="130"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Name="ComboCountryCode" Grid.Column="0" Background="#1E293B" Foreground="#000000" FontSize="12" Padding="8,8" Margin="0,0,8,0">
                                        <ComboBoxItem Content="🇹🇭 +66 (ไทย)" IsSelected="True"/>
                                        <ComboBoxItem Content="🇺🇸 +1 (USA)"/>
                                        <ComboBoxItem Content="🇬🇧 +44 (UK)"/>
                                        <ComboBoxItem Content="🇯🇵 +81 (ญี่ปุ่น)"/>
                                        <ComboBoxItem Content="🇰🇷 +82 (เกาหลี)"/>
                                        <ComboBoxItem Content="🇸🇬 +65 (สิงคโปร์)"/>
                                        <ComboBoxItem Content="🇨🇳 +86 (จีน)"/>
                                    </ComboBox>
                                    <TextBox Name="TxtPhoneNumber" Grid.Column="1" Background="#1E293B" Foreground="#FFFFFF" BorderBrush="#334155" BorderThickness="1" Padding="10,8" FontSize="14" FontWeight="Bold" Text=""/>
                                </Grid>

                                <!-- Live Carrier Detector -->
                                <Border Background="#1E293B" BorderBrush="#334155" BorderThickness="1" CornerRadius="8" Padding="12,10" Margin="0,0,0,16">
                                    <StackPanel>
                                        <Grid>
                                            <Grid.ColumnDefinitions><ColumnDefinition Width="Auto"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
                                            <TextBlock Grid.Column="0" Text="📡 เครือข่าย/ชนิด: " FontSize="11" FontWeight="Bold" Foreground="#38BDF8"/>
                                            <TextBlock Name="TxtCarrierDetect" Grid.Column="1" Text="กรุณาพิมพ์เบอร์โทร..." FontSize="11" Foreground="#CBD5E1" TextTrimming="CharacterEllipsis"/>
                                        </Grid>
                                        <Grid Margin="0,4,0,0">
                                            <Grid.ColumnDefinitions><ColumnDefinition Width="Auto"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
                                            <TextBlock Grid.Column="0" Text="🌐 สากล (E.164): " FontSize="11" FontWeight="Bold" Foreground="#10B981"/>
                                            <TextBlock Name="TxtE164Format" Grid.Column="1" Text="-" FontSize="11" Foreground="#34D399"/>
                                        </Grid>
                                    </StackPanel>
                                </Border>

                                <Button Name="BtnMasterPhoneSearch" Content="🚀 ค้นหาเบอร์นี้ข้ามทุกระบบ (One-Click Search)" Style="{StaticResource EmeraldBtn}" Margin="0,0,0,8"/>
                            </StackPanel>
                        </Border>

                        <!-- Guidance Box -->
                        <Border Grid.Row="1" Background="#0B1120" BorderBrush="#1F2937" BorderThickness="1" CornerRadius="10" Padding="16" Margin="0,14,0,0">
                            <StackPanel>
                                <TextBlock Text="💡 ค้นหาเบอร์โทรศัพท์ทำอะไรได้บ้าง?" FontSize="13" FontWeight="Bold" Foreground="#34D399" Margin="0,0,0,8"/>
                                <TextBlock Text="• Whoscall &amp; Truecaller: ดูชื่อที่คนอื่นบันทึกไว้ในสมุดโทรศัพท์ และตรวจจับมิจฉาชีพ/สแปม" FontSize="11" Foreground="#CBD5E1" Margin="0,0,0,4" TextWrapping="Wrap"/>
                                <TextBlock Text="• LINE Messenger: ค้นหาบัญชีผู้ใช้เพื่อดูชื่อและรูปโปรไฟล์ที่ตั้งไว้" FontSize="11" Foreground="#CBD5E1" Margin="0,0,0,4" TextWrapping="Wrap"/>
                                <TextBlock Text="• WhatsApp: ตรวจสอบรูปภาพโปรไฟล์และสถานะเปิดบัญชีตรงผ่าน wa.me" FontSize="11" Foreground="#CBD5E1" Margin="0,0,0,4" TextWrapping="Wrap"/>
                                <TextBlock Text="• Blacklistseller: ตรวจสอบประวัติคนโกงเงิน ซื้อขายของออนไลน์ในไทย" FontSize="11" Foreground="#CBD5E1" Margin="0,0,0,4" TextWrapping="Wrap"/>
                                <TextBlock Text="• Social Dorking: ดึงโพสต์บน Facebook, IG และ TikTok ที่เคยลงเบอร์นี้ไว้ติดต่อ" FontSize="11" Foreground="#CBD5E1" TextWrapping="Wrap"/>
                            </StackPanel>
                        </Border>
                    </Grid>

                    <!-- RIGHT: PHONE TOOLS -->
                    <Grid Grid.Column="1">
                        <ScrollViewer VerticalScrollBarVisibility="Auto">
                            <StackPanel>

                                <!-- 1. FACEBOOK -->
                                <Border Style="{StaticResource PlatformCard}" BorderBrush="#1877F2" BorderThickness="1.2">
                                    <Grid>
                                        <Grid.ColumnDefinitions><ColumnDefinition Width="48"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                        <TextBlock Grid.Column="0" Text="👥" FontSize="26" VerticalAlignment="Center" HorizontalAlignment="Center"/>
                                        <StackPanel Grid.Column="1" VerticalAlignment="Center" Margin="8,0,0,0">
                                            <StackPanel Orientation="Horizontal">
                                                <TextBlock Text="Facebook Phone Search (เจาะหาบัญชี &amp; โพสต์)" FontSize="14" FontWeight="Bold" Foreground="#FFFFFF"/>
                                                <Border Background="#1877F2" CornerRadius="4" Padding="5,1" Margin="8,0,0,0"><TextBlock Text="Facebook" FontSize="9" FontWeight="Bold" Foreground="#FFFFFF"/></Border>
                                            </StackPanel>
                                            <TextBlock Text="สแกนหาโพสต์สาธารณะ, โปรไฟล์ผู้ใช้, เพจร้านค้า และกลุ่มซื้อขายบน Facebook ที่เคยลงเบอร์นี้ไว้" FontSize="11" Foreground="#94A3B8" Margin="0,2,0,0"/>
                                        </StackPanel>
                                        <StackPanel Grid.Column="2" Orientation="Horizontal" VerticalAlignment="Center">
                                            <Button Name="BtnLookupFacebookDirect" Content="👥 ค้นหาบน FB ตรง" Style="{StaticResource GlowBtn}" Margin="0,0,6,0"/>
                                            <Button Name="BtnLookupFacebook" Content="🔍 เจาะหาโพสต์/กลุ่ม" Style="{StaticResource SecondaryBtn}"/>
                                        </StackPanel>
                                    </Grid>
                                </Border>

                                <!-- 2. LINE -->
                                <Border Style="{StaticResource PlatformCard}" BorderBrush="#06C755" BorderThickness="1.2">
                                    <Grid>
                                        <Grid.ColumnDefinitions><ColumnDefinition Width="48"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                        <TextBlock Grid.Column="0" Text="💬" FontSize="26" VerticalAlignment="Center" HorizontalAlignment="Center"/>
                                        <StackPanel Grid.Column="1" VerticalAlignment="Center" Margin="8,0,0,0">
                                            <StackPanel Orientation="Horizontal">
                                                <TextBlock Text="LINE Messenger Profile (ดูรูปและชื่อบัญชี LINE)" FontSize="14" FontWeight="Bold" Foreground="#FFFFFF"/>
                                                <Border Background="#06C755" CornerRadius="4" Padding="5,1" Margin="8,0,0,0"><TextBlock Text="LINE Profile" FontSize="9" FontWeight="Bold" Foreground="#FFFFFF"/></Border>
                                            </StackPanel>
                                            <TextBlock Text="เปิดค้นหาบัญชี LINE ที่ผูกเบอร์โทรนี้ เพื่อดูรูปโปรไฟล์และชื่อแสดงตนที่ใช้บนแอป LINE" FontSize="11" Foreground="#94A3B8" Margin="0,2,0,0"/>
                                        </StackPanel>
                                        <StackPanel Grid.Column="2" Orientation="Horizontal" VerticalAlignment="Center">
                                            <Button Name="BtnLookupLineApp" Content="💬 เปิดแอป LINE เพิ่มเพื่อน" Style="{StaticResource EmeraldBtn}" Margin="0,0,6,0"/>
                                            <Button Name="BtnLookupLine" Content="🔍 เจาะหา LINE ID" Style="{StaticResource SecondaryBtn}"/>
                                        </StackPanel>
                                    </Grid>
                                </Border>

                                <!-- 3. INSTAGRAM & TIKTOK -->
                                <Border Style="{StaticResource PlatformCard}" BorderBrush="#E1306C" BorderThickness="1.2">
                                    <Grid>
                                        <Grid.ColumnDefinitions><ColumnDefinition Width="48"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                        <TextBlock Grid.Column="0" Text="📸" FontSize="26" VerticalAlignment="Center" HorizontalAlignment="Center"/>
                                        <StackPanel Grid.Column="1" VerticalAlignment="Center" Margin="8,0,0,0">
                                            <StackPanel Orientation="Horizontal">
                                                <TextBlock Text="Instagram &amp; TikTok Phone Search" FontSize="14" FontWeight="Bold" Foreground="#FFFFFF"/>
                                                <Border Background="#E1306C" CornerRadius="4" Padding="5,1" Margin="8,0,0,0"><TextBlock Text="IG / TikTok" FontSize="9" FontWeight="Bold" Foreground="#FFFFFF"/></Border>
                                            </StackPanel>
                                            <TextBlock Text="ค้นหาคำอธิบายโปรไฟล์ (Bio), แคปชั่นคลิปวิดีโอ และลิงก์ติดต่อที่เคยใส่เบอร์นี้" FontSize="11" Foreground="#94A3B8" Margin="0,2,0,0"/>
                                        </StackPanel>
                                        <StackPanel Grid.Column="2" Orientation="Horizontal" VerticalAlignment="Center">
                                            <Button Name="BtnLookupInstagram" Content="📸 เจาะหาบน IG" Style="{StaticResource SecondaryBtn}" Margin="0,0,6,0"/>
                                            <Button Name="BtnLookupTikTok" Content="🎵 เจาะหาบน TikTok" Style="{StaticResource SecondaryBtn}"/>
                                        </StackPanel>
                                    </Grid>
                                </Border>

                                <!-- 4. DISCORD -->
                                <Border Style="{StaticResource PlatformCard}" BorderBrush="#5865F2" BorderThickness="1.2">
                                    <Grid>
                                        <Grid.ColumnDefinitions><ColumnDefinition Width="48"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                        <TextBlock Grid.Column="0" Text="🎮" FontSize="26" VerticalAlignment="Center" HorizontalAlignment="Center"/>
                                        <StackPanel Grid.Column="1" VerticalAlignment="Center" Margin="8,0,0,0">
                                            <StackPanel Orientation="Horizontal">
                                                <TextBlock Text="Discord Phone OSINT (เซิร์ฟเวอร์ดิสคอร์ด &amp; ไฟล์แนบ)" FontSize="14" FontWeight="Bold" Foreground="#FFFFFF"/>
                                                <Border Background="#5865F2" CornerRadius="4" Padding="5,1" Margin="8,0,0,0"><TextBlock Text="Discord OSINT" FontSize="9" FontWeight="Bold" Foreground="#FFFFFF"/></Border>
                                            </StackPanel>
                                            <TextBlock Text="สแกนหาข้อความในเซิร์ฟเวอร์ดิสคอร์ดสาธารณะ, ประวัติแลกเบอร์วอลเล็ต, และไฟล์แนบ cdn.discordapp" FontSize="11" Foreground="#94A3B8" Margin="0,2,0,0"/>
                                        </StackPanel>
                                        <StackPanel Grid.Column="2" Orientation="Horizontal" VerticalAlignment="Center">
                                            <Button Name="BtnLookupDiscord" Content="🎮 เจาะหาใน Discord" Style="{StaticResource GlowBtn}" Background="#5865F2" Margin="0,0,6,0"/>
                                            <Button Name="BtnLookupDiscordCdn" Content="📁 หา cdn.discordapp" Style="{StaticResource SecondaryBtn}"/>
                                        </StackPanel>
                                    </Grid>
                                </Border>

                                <!-- 5. WHOSCALL -->
                                <Border Style="{StaticResource PlatformCard}" BorderBrush="#10B981" BorderThickness="1.2">
                                    <Grid>
                                        <Grid.ColumnDefinitions><ColumnDefinition Width="48"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                        <TextBlock Grid.Column="0" Text="📱" FontSize="26" VerticalAlignment="Center" HorizontalAlignment="Center"/>
                                        <StackPanel Grid.Column="1" VerticalAlignment="Center" Margin="8,0,0,0">
                                            <StackPanel Orientation="Horizontal">
                                                <TextBlock Text="Whoscall Number Lookup (อันดับ 1 ในไทย)" FontSize="14" FontWeight="Bold" Foreground="#FFFFFF"/>
                                                <Border Background="#10B981" CornerRadius="4" Padding="5,1" Margin="8,0,0,0"><TextBlock Text="ไทย &amp; มิจฉาชีพ" FontSize="9" FontWeight="Bold" Foreground="#FFFFFF"/></Border>
                                            </StackPanel>
                                            <TextBlock Text="ดูชื่อที่คนอื่นบันทึกไว้ในเครื่อง และตรวจสอบว่าเบอร์นี้ถูกคนไทยรายงานเป็นเบอร์มิจฉาชีพหรือหลอกลวงหรือไม่" FontSize="11" Foreground="#94A3B8" Margin="0,2,0,0"/>
                                        </StackPanel>
                                        <Button Name="BtnLookupWhoscall" Grid.Column="2" Content="📱 เช็คชื่อบน Whoscall" Style="{StaticResource EmeraldBtn}"/>
                                    </Grid>
                                </Border>

                                <!-- 6. TRUECALLER -->
                                <Border Style="{StaticResource PlatformCard}" BorderBrush="#2563EB" BorderThickness="1.2">
                                    <Grid>
                                        <Grid.ColumnDefinitions><ColumnDefinition Width="48"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                        <TextBlock Grid.Column="0" Text="📞" FontSize="26" VerticalAlignment="Center" HorizontalAlignment="Center"/>
                                        <StackPanel Grid.Column="1" VerticalAlignment="Center" Margin="8,0,0,0">
                                            <StackPanel Orientation="Horizontal">
                                                <TextBlock Text="Truecaller Global Caller ID (ฐานข้อมูลสากล)" FontSize="14" FontWeight="Bold" Foreground="#FFFFFF"/>
                                                <Border Background="#2563EB" CornerRadius="4" Padding="5,1" Margin="8,0,0,0"><TextBlock Text="Global Lookup" FontSize="9" FontWeight="Bold" Foreground="#FFFFFF"/></Border>
                                            </StackPanel>
                                            <TextBlock Text="ฐานข้อมูลสมุดโทรศัพท์ที่ใหญ่ที่สุดในโลก ตรวจสอบชื่อเจ้าของเบอร์ทั้งเบอร์ไทยและเบอร์ต่างประเทศ" FontSize="11" Foreground="#94A3B8" Margin="0,2,0,0"/>
                                        </StackPanel>
                                        <Button Name="BtnLookupTruecaller" Grid.Column="2" Content="📞 ค้นหาบน Truecaller" Style="{StaticResource GlowBtn}"/>
                                    </Grid>
                                </Border>

                                <!-- 7. WHATSAPP -->
                                <Border Style="{StaticResource PlatformCard}">
                                    <Grid>
                                        <Grid.ColumnDefinitions><ColumnDefinition Width="48"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                        <TextBlock Grid.Column="0" Text="🟢" FontSize="26" VerticalAlignment="Center" HorizontalAlignment="Center"/>
                                        <StackPanel Grid.Column="1" VerticalAlignment="Center" Margin="8,0,0,0">
                                            <StackPanel Orientation="Horizontal">
                                                <TextBlock Text="WhatsApp Direct Chat &amp; Profile Photo" FontSize="14" FontWeight="Bold" Foreground="#FFFFFF"/>
                                                <Border Background="#25D366" CornerRadius="4" Padding="5,1" Margin="8,0,0,0"><TextBlock Text="WhatsApp" FontSize="9" FontWeight="Bold" Foreground="#FFFFFF"/></Border>
                                            </StackPanel>
                                            <TextBlock Text="เปิดหน้าแชทตรงเพื่อดูว่าเบอร์นี้เปิดใช้งาน WhatsApp หรือไม่ พร้อมดูภาพโปรไฟล์สากล" FontSize="11" Foreground="#94A3B8" Margin="0,2,0,0"/>
                                        </StackPanel>
                                        <Button Name="BtnLookupWhatsApp" Grid.Column="2" Content="🟢 ดูโปรไฟล์ WhatsApp" Style="{StaticResource SecondaryBtn}"/>
                                    </Grid>
                                </Border>

                                <!-- 8. BLACKLISTSELLER -->
                                <Border Style="{StaticResource PlatformCard}" BorderBrush="#E11D48" BorderThickness="1.2">
                                    <Grid>
                                        <Grid.ColumnDefinitions><ColumnDefinition Width="48"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                        <TextBlock Grid.Column="0" Text="🚨" FontSize="26" VerticalAlignment="Center" HorizontalAlignment="Center"/>
                                        <StackPanel Grid.Column="1" VerticalAlignment="Center" Margin="8,0,0,0">
                                            <StackPanel Orientation="Horizontal">
                                                <TextBlock Text="Blacklistseller (ตรวจสอบประวัติคนโกงในไทย)" FontSize="14" FontWeight="Bold" Foreground="#FFFFFF"/>
                                                <Border Background="#E11D48" CornerRadius="4" Padding="5,1" Margin="8,0,0,0"><TextBlock Text="ศูนย์คนโกง" FontSize="9" FontWeight="Bold" Foreground="#FFFFFF"/></Border>
                                            </StackPanel>
                                            <TextBlock Text="ตรวจสอบฐานข้อมูลผู้เสียหาย ดูว่าเบอร์นี้เคยมีประวัติฉ้อโกงเงิน โอนเงินแล้วไม่ส่งของ หรือติดแบล็คลิสต์หรือไม่" FontSize="11" Foreground="#94A3B8" Margin="0,2,0,0"/>
                                        </StackPanel>
                                        <Button Name="BtnLookupBlacklist" Grid.Column="2" Content="🚨 เช็คประวัติคนโกง" Style="{StaticResource GlowBtn}" Background="#E11D48"/>
                                    </Grid>
                                </Border>

                                <!-- 9. GOOGLE BROAD -->
                                <Border Style="{StaticResource PlatformCard}">
                                    <Grid>
                                        <Grid.ColumnDefinitions><ColumnDefinition Width="48"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                        <TextBlock Grid.Column="0" Text="🔍" FontSize="26" VerticalAlignment="Center" HorizontalAlignment="Center"/>
                                        <StackPanel Grid.Column="1" VerticalAlignment="Center" Margin="8,0,0,0">
                                            <StackPanel Orientation="Horizontal">
                                                <TextBlock Text="Google Global &amp; Pantip Forum Mentions" FontSize="14" FontWeight="Bold" Foreground="#FFFFFF"/>
                                                <Border Background="#4285F4" CornerRadius="4" Padding="5,1" Margin="8,0,0,0"><TextBlock Text="Google Web" FontSize="9" FontWeight="Bold" Foreground="#FFFFFF"/></Border>
                                            </StackPanel>
                                            <TextBlock Text="ค้นหาทุกหน้าเว็บ เว็บบอร์ด Pantip ฟอรัม และเอกสารบนอินเทอร์เน็ตที่เคยระบุหมายเลขนี้" FontSize="11" Foreground="#94A3B8" Margin="0,2,0,0"/>
                                        </StackPanel>
                                        <Button Name="BtnLookupGoogle" Grid.Column="2" Content="🔍 สแกนเว็บทั่วโลก" Style="{StaticResource SecondaryBtn}"/>
                                    </Grid>
                                </Border>

                                <!-- 10. BRIDGE TO IMAGE TAB -->
                                <Border Style="{StaticResource PlatformCard}" BorderBrush="#F59E0B" BorderThickness="1.2">
                                    <Grid>
                                        <Grid.ColumnDefinitions><ColumnDefinition Width="48"/><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                        <TextBlock Grid.Column="0" Text="🖼️" FontSize="26" VerticalAlignment="Center" HorizontalAlignment="Center"/>
                                        <StackPanel Grid.Column="1" VerticalAlignment="Center" Margin="8,0,0,0">
                                            <StackPanel Orientation="Horizontal">
                                                <TextBlock Text="ระบบสแกนรูปภาพข้ามทุกแพลตฟอร์ม (Image &amp; Face OSINT)" FontSize="14" FontWeight="Bold" Foreground="#FFFFFF"/>
                                                <Border Background="#F59E0B" CornerRadius="4" Padding="5,1" Margin="8,0,0,0"><TextBlock Text="Image Scanner" FontSize="9" FontWeight="Bold" Foreground="#000000"/></Border>
                                            </StackPanel>
                                            <TextBlock Text="ได้รูปโปรไฟล์จากเบอร์โทรแล้วใช่ไหม? สลับไปโหมดสแกนรูปภาพเพื่อค้นหาว่าคนนี้ปรากฏอยู่ที่ไหนอีกบ้างบนอินเทอร์เน็ต" FontSize="11" Foreground="#94A3B8" Margin="0,2,0,0"/>
                                        </StackPanel>
                                        <Button Name="BtnBridgeToImageTab" Grid.Column="2" Content="📸 สลับไปสแกนรูปภาพทันที" Style="{StaticResource GlowBtn}" Background="#F59E0B" Foreground="#000000"/>
                                    </Grid>
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
                    <TextBlock Name="TxtStatus" Text="พร้อมใช้งาน: สลับแท็บเพื่อค้นหาด้วยรูปภาพ หรือใส่เบอร์โทรศัพท์เพื่อตรวจประวัติได้ทันที" FontSize="12" Foreground="#94A3B8" VerticalAlignment="Center"/>
                </StackPanel>
                <TextBlock Grid.Column="1" Text="OmniReverse Ultra v5.0 | Ready" FontSize="11" Foreground="#64748B" VerticalAlignment="Center"/>
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
$btnMasterSearch = $window.FindName("BtnMasterSearch")

$txtPublicUrl = $window.FindName("TxtPublicUrl")
$uploadProgressBar = $window.FindName("UploadProgressBar")

$txtFileName = $window.FindName("TxtFileName")
$txtDimensions = $window.FindName("TxtDimensions")
$txtFileSize = $window.FindName("TxtFileSize")
$txtMd5Hash = $window.FindName("TxtMd5Hash")
$txtSha256 = $window.FindName("TxtSha256")

$txtKeywordFilter = $window.FindName("TxtKeywordFilter")
$btnQuickDork = $window.FindName("BtnQuickDork")

$btnSearchYandex = $window.FindName("BtnSearchYandex")
$btnSearchFaceCheck = $window.FindName("BtnSearchFaceCheck")
$btnSearchGoogle = $window.FindName("BtnSearchGoogle")
$btnSearchTinEye = $window.FindName("BtnSearchTinEye")
$btnSearchBing = $window.FindName("BtnSearchBing")
$btnSearchBaidu = $window.FindName("BtnSearchBaidu")
$btnSearchInstagram = $window.FindName("BtnSearchInstagram")
$btnSearchDiscord = $window.FindName("BtnSearchDiscord")

# Phone Tab Elements
$comboCountryCode = $window.FindName("ComboCountryCode")
$txtPhoneNumber = $window.FindName("TxtPhoneNumber")
$txtCarrierDetect = $window.FindName("TxtCarrierDetect")
$txtE164Format = $window.FindName("TxtE164Format")
$btnMasterPhoneSearch = $window.FindName("BtnMasterPhoneSearch")

$btnLookupFacebookDirect = $window.FindName("BtnLookupFacebookDirect")
$btnLookupFacebook = $window.FindName("BtnLookupFacebook")
$btnLookupLineApp = $window.FindName("BtnLookupLineApp")
$btnLookupLine = $window.FindName("BtnLookupLine")
$btnLookupInstagram = $window.FindName("BtnLookupInstagram")
$btnLookupTikTok = $window.FindName("BtnLookupTikTok")
$btnLookupDiscord = $window.FindName("BtnLookupDiscord")
$btnLookupDiscordCdn = $window.FindName("BtnLookupDiscordCdn")
$btnLookupWhoscall = $window.FindName("BtnLookupWhoscall")
$btnLookupTruecaller = $window.FindName("BtnLookupTruecaller")
$btnLookupWhatsApp = $window.FindName("BtnLookupWhatsApp")
$btnLookupBlacklist = $window.FindName("BtnLookupBlacklist")
$btnLookupGoogle = $window.FindName("BtnLookupGoogle")
$btnBridgeToImageTab = $window.FindName("BtnBridgeToImageTab")

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

# Image Upload
function Upload-ImageDirect([string]$filePath) {
    if (-not (Test-Path $filePath)) { return "" }

    $window.Dispatcher.Invoke([Action]{
        $uploadProgressBar.Visibility = [System.Windows.Visibility]::Visible
        $uploadProgressBar.IsIndeterminate = $true
        $txtPublicUrl.Text = "กำลังอัปโหลดภาพทั้งรูป..."
    })
    Set-AppStatus "กำลังอัปโหลดภาพทั้งรูปเพื่อสร้าง Direct Search Links..." "#38BDF8"

    $curlPath = "C:\Windows\System32\curl.exe"
    if (Test-Path $curlPath) {
        try {
            $cmd = "& `"$curlPath`" -s -F `"reqtype=fileupload`" -F `"time=1h`" -F `"fileToUpload=@$filePath`" https://litterbox.catbox.moe/resources/internals/api.php"
            $url = (Invoke-Expression $cmd).Trim()
            if ($url -match "^https?://") {
                $window.Dispatcher.Invoke([Action]{
                    $uploadProgressBar.Visibility = [System.Windows.Visibility]::Collapsed
                    $txtPublicUrl.Text = $url
                })
                Set-AppStatus "อัปโหลดภาพสำเร็จ! พร้อมเปิดผลการค้นหาตรงทันที" "#10B981"
                return $url
            }
        } catch {}
    }

    $window.Dispatcher.Invoke([Action]{
        $uploadProgressBar.Visibility = [System.Windows.Visibility]::Collapsed
        $txtPublicUrl.Text = "อัปโหลดไม่สำเร็จ (คัดลอกภาพลงคลิปบอร์ดให้แล้ว)"
    })
    return ""
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

        $txtMd5Hash.Text = (Get-FileHash -Path $path -Algorithm MD5).Hash
        $txtSha256.Text = (Get-FileHash -Path $path -Algorithm SHA256).Hash

        try { [System.Windows.Clipboard]::SetImage($bmp) } catch {}

        [System.Threading.ThreadPool]::QueueUserWorkItem({
            $url = Upload-ImageDirect $path
            if ($url) { $global:CurrentPublicUrl = $url }
        })

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
    $dlg.Title = "เลือกรูปภาพที่ต้องการค้นหา"
    $dlg.Filter = "Image Files (*.jpg;*.jpeg;*.png;*.webp;*.gif;*.bmp)|*.jpg;*.jpeg;*.png;*.webp;*.gif;*.bmp|All Files (*.*)|*.*"
    if ($dlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        Load-ImageFile $dlg.FileName
    }
})

$btnPasteClipboard.Add_Click({
    if ([System.Windows.Clipboard]::ContainsImage()) {
        $imgSource = [System.Windows.Clipboard]::GetImage()
        $tempPath = Join-Path $env:TEMP "OmniReverse_Ultra_$([Guid]::NewGuid().ToString('N')).png"
        
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
        Open-Url "https://google.com"
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
    $txtPublicUrl.Text = "กำลังรอรูปภาพ..."
    $txtMd5Hash.Text = ""
    $txtSha256.Text = ""
    $txtKeywordFilter.Text = ""
    $txtPhoneNumber.Text = ""
    Update-PhoneDetect

    Set-AppStatus "ล้างข้อมูลเรียบร้อยแล้ว" "#10B981"
})

# Image Search Triggers
function Exec-Yandex {
    if ($global:CurrentPublicUrl) {
        $enc = [System.Web.HttpUtility]::UrlEncode($global:CurrentPublicUrl)
        Open-Url "https://yandex.com/images/search?rpt=imageview&url=$enc"
    } else { Open-Url "https://yandex.com/images/" }
}
function Exec-FaceCheck { Open-Url "https://facecheck.id/" }
function Exec-GoogleLens {
    if ($global:CurrentPublicUrl) {
        $enc = [System.Web.HttpUtility]::UrlEncode($global:CurrentPublicUrl)
        Open-Url "https://lens.google.com/uploadbyurl?url=$enc"
    } else { Open-Url "https://lens.google.com/" }
}
function Exec-TinEye {
    if ($global:CurrentPublicUrl) {
        $enc = [System.Web.HttpUtility]::UrlEncode($global:CurrentPublicUrl)
        Open-Url "https://tineye.com/search?url=$enc"
    } else { Open-Url "https://tineye.com/" }
}
function Exec-Bing {
    if ($global:CurrentPublicUrl) {
        $enc = [System.Web.HttpUtility]::UrlEncode($global:CurrentPublicUrl)
        Open-Url "https://www.bing.com/images/search?view=detailv2&iss=sbi&imgurl=$enc"
    } else { Open-Url "https://www.bing.com/visualsearch" }
}
function Exec-Baidu {
    if ($global:CurrentPublicUrl) {
        $enc = [System.Web.HttpUtility]::UrlEncode($global:CurrentPublicUrl)
        Open-Url "https://graph.baidu.com/details?isfromsimilarity=1&image=$enc"
    } else { Open-Url "https://graph.baidu.com/" }
}
function Exec-Instagram {
    $kw = $txtKeywordFilter.Text.Trim()
    if ($global:CurrentPublicUrl) {
        $enc = [System.Web.HttpUtility]::UrlEncode($global:CurrentPublicUrl)
        Open-Url "https://yandex.com/images/search?rpt=imageview&url=$enc"
    }
    $query = "site:instagram.com"
    if ($kw) { $query += " `"$kw`"" }
    $dork = [System.Web.HttpUtility]::UrlEncode($query)
    Open-Url "https://www.google.com/search?q=$dork"
}
function Exec-Discord {
    $kw = $txtKeywordFilter.Text.Trim()
    $md5 = $txtMd5Hash.Text
    $query = "site:discord.com OR site:discord.gg OR site:cdn.discordapp.com"
    if ($kw) { $query += " `"$kw`"" }
    if ($md5) { $query += " OR `"$md5`"" }
    $dork = [System.Web.HttpUtility]::UrlEncode($query)
    Open-Url "https://www.google.com/search?q=$dork"
}

$btnSearchYandex.Add_Click({ Exec-Yandex })
$btnSearchFaceCheck.Add_Click({ Exec-FaceCheck })
$btnSearchGoogle.Add_Click({ Exec-GoogleLens })
$btnSearchTinEye.Add_Click({ Exec-TinEye })
$btnSearchBing.Add_Click({ Exec-Bing })
$btnSearchBaidu.Add_Click({ Exec-Baidu })
$btnSearchInstagram.Add_Click({ Exec-Instagram })
$btnSearchDiscord.Add_Click({ Exec-Discord })

$btnQuickDork.Add_Click({
    $kw = $txtKeywordFilter.Text.Trim()
    if (-not $kw) {
        [System.Windows.MessageBox]::Show("กรุณากรอกคำค้นหา เช่น ชื่อคน หรือ username", "แจ้งเตือน", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
        return
    }
    $dork = [System.Web.HttpUtility]::UrlEncode("(site:instagram.com OR site:facebook.com OR site:discord.com OR site:tiktok.com) `"$kw`"")
    Open-Url "https://www.google.com/search?q=$dork"
})

# ================= PHONE OSINT LOGIC =================
function Get-CleanPhone {
    $raw = $txtPhoneNumber.Text.Trim()
    return ($raw -replace "[^0-9]", "")
}

function Get-PhoneE164 {
    $num = Get-CleanPhone
    if (-not $num) { return "" }
    $codeStr = $comboCountryCode.SelectedItem.Content.ToString()
    if ($codeStr -match "\+([0-9]+)") {
        $cc = $matches[1]
        if ($cc -eq "66" -and $num.StartsWith("0")) {
            $num = $num.Substring(1)
        }
        return "$cc$num"
    }
    return $num
}

function Update-PhoneDetect {
    $num = Get-CleanPhone
    if (-not $num) {
        $txtCarrierDetect.Text = "กรุณาพิมพ์เบอร์โทร..."
        $txtE164Format.Text = "-"
        return
    }

    $e164 = Get-PhoneE164
    $txtE164Format.Text = "+$e164"

    if ($num.StartsWith("08") -or $num.StartsWith("09") -or $num.StartsWith("06")) {
        $prefix = $num.Substring(0, [Math]::Min(3, $num.Length))
        if (@('081','082','089','092','093','097','098') -contains $prefix) {
            $txtCarrierDetect.Text = "เบอร์มือถือไทย (กลุ่มหมายเลข AIS/ทั่วไป)"
        } elseif (@('083','084','085','086','094','099') -contains $prefix) {
            $txtCarrierDetect.Text = "เบอร์มือถือไทย (กลุ่มหมายเลข True/Dtac)"
        } else {
            $txtCarrierDetect.Text = "เบอร์มือถือประเทศไทย (+66)"
        }
    } elseif ($num.StartsWith("02")) {
        $txtCarrierDetect.Text = "เบอร์บ้าน/สำนักงาน กรุงเทพและปริมณฑล"
    } else {
        $txtCarrierDetect.Text = "เบอร์โทรศัพท์ระหว่างประเทศ"
    }
}

$txtPhoneNumber.Add_TextChanged({ Update-PhoneDetect })
$comboCountryCode.Add_SelectionChanged({ Update-PhoneDetect })

function Exec-Whoscall {
    $num = Get-CleanPhone
    if (-not $num) { [System.Windows.MessageBox]::Show("กรุณากรอกเบอร์โทรศัพท์ก่อนครับ", "แจ้งเตือน"); return }
    Open-Url "https://whoscall.com/th/search/$num"
}

function Exec-Truecaller {
    $e164 = Get-PhoneE164
    if (-not $e164) { [System.Windows.MessageBox]::Show("กรุณากรอกเบอร์โทรศัพท์ก่อนครับ", "แจ้งเตือน"); return }
    Open-Url "https://www.truecaller.com/search/th/$e164"
}

function Exec-FacebookPhoneDirect {
    $num = Get-CleanPhone
    if (-not $num) { [System.Windows.MessageBox]::Show("กรุณากรอกเบอร์โทรศัพท์ก่อนครับ", "แจ้งเตือน"); return }
    $enc = [System.Web.HttpUtility]::UrlEncode($num)
    Open-Url "https://www.facebook.com/search/top/?q=$enc"
}

function Exec-FacebookPhone {
    $num = Get-CleanPhone
    $e164 = Get-PhoneE164
    if (-not $num) { [System.Windows.MessageBox]::Show("กรุณากรอกเบอร์โทรศัพท์ก่อนครับ", "แจ้งเตือน"); return }
    $enc = [System.Web.HttpUtility]::UrlEncode("site:facebook.com (`"$num`" OR `"+$e164`")")
    Open-Url "https://www.google.com/search?q=$enc"
}

function Exec-LineApp {
    $num = Get-CleanPhone
    if (-not $num) { [System.Windows.MessageBox]::Show("กรุณากรอกเบอร์โทรศัพท์ก่อนครับ", "แจ้งเตือน"); return }
    Open-Url "https://line.me/R/nv/addFriends"
}

function Exec-LinePhone {
    $num = Get-CleanPhone
    if (-not $num) { [System.Windows.MessageBox]::Show("กรุณากรอกเบอร์โทรศัพท์ก่อนครับ", "แจ้งเตือน"); return }
    $enc = [System.Web.HttpUtility]::UrlEncode("(site:line.me OR site:lin.ee OR `"line id`") `"$num`"")
    Open-Url "https://www.google.com/search?q=$enc"
}

function Exec-InstagramPhone {
    $num = Get-CleanPhone
    $e164 = Get-PhoneE164
    if (-not $num) { [System.Windows.MessageBox]::Show("กรุณากรอกเบอร์โทรศัพท์ก่อนครับ", "แจ้งเตือน"); return }
    $enc = [System.Web.HttpUtility]::UrlEncode("site:instagram.com (`"$num`" OR `"+$e164`")")
    Open-Url "https://www.google.com/search?q=$enc"
}

function Exec-TikTokPhone {
    $num = Get-CleanPhone
    if (-not $num) { [System.Windows.MessageBox]::Show("กรุณากรอกเบอร์โทรศัพท์ก่อนครับ", "แจ้งเตือน"); return }
    $enc = [System.Web.HttpUtility]::UrlEncode("site:tiktok.com `"$num`"")
    Open-Url "https://www.google.com/search?q=$enc"
}

function Exec-DiscordPhone {
    $num = Get-CleanPhone
    $e164 = Get-PhoneE164
    if (-not $num) { [System.Windows.MessageBox]::Show("กรุณากรอกเบอร์โทรศัพท์ก่อนครับ", "แจ้งเตือน"); return }
    $enc = [System.Web.HttpUtility]::UrlEncode("(site:discord.com OR site:discord.gg OR `"discord.com/users/`") (`"$num`" OR `"+$e164`")")
    Open-Url "https://www.google.com/search?q=$enc"
}

function Exec-DiscordCdn {
    $num = Get-CleanPhone
    if (-not $num) { [System.Windows.MessageBox]::Show("กรุณากรอกเบอร์โทรศัพท์ก่อนครับ", "แจ้งเตือน"); return }
    $enc = [System.Web.HttpUtility]::UrlEncode("site:cdn.discordapp.com `"$num`"")
    Open-Url "https://www.google.com/search?q=$enc"
}

function Exec-Whoscall {
    $num = Get-CleanPhone
    if (-not $num) { [System.Windows.MessageBox]::Show("กรุณากรอกเบอร์โทรศัพท์ก่อนครับ", "แจ้งเตือน"); return }
    Open-Url "https://whoscall.com/th/search/$num"
}

function Exec-Truecaller {
    $e164 = Get-PhoneE164
    if (-not $e164) { [System.Windows.MessageBox]::Show("กรุณากรอกเบอร์โทรศัพท์ก่อนครับ", "แจ้งเตือน"); return }
    Open-Url "https://www.truecaller.com/search/th/$e164"
}

function Exec-WhatsAppPhone {
    $e164 = Get-PhoneE164
    if (-not $e164) { [System.Windows.MessageBox]::Show("กรุณากรอกเบอร์โทรศัพท์ก่อนครับ", "แจ้งเตือน"); return }
    Open-Url "https://wa.me/$e164"
}

function Exec-Blacklistseller {
    $num = Get-CleanPhone
    if (-not $num) { [System.Windows.MessageBox]::Show("กรุณากรอกเบอร์โทรศัพท์ก่อนครับ", "แจ้งเตือน"); return }
    $enc = [System.Web.HttpUtility]::UrlEncode($num)
    Open-Url "https://www.blacklistseller.com/report/report_search_page?search=$enc"
}

function Exec-GooglePhone {
    $num = Get-CleanPhone
    $e164 = Get-PhoneE164
    if (-not $num) { [System.Windows.MessageBox]::Show("กรุณากรอกเบอร์โทรศัพท์ก่อนครับ", "แจ้งเตือน"); return }
    $enc = [System.Web.HttpUtility]::UrlEncode("`"$num`" OR `"+$e164`"")
    Open-Url "https://www.google.com/search?q=$enc"
}

$btnLookupFacebookDirect.Add_Click({ Exec-FacebookPhoneDirect })
$btnLookupFacebook.Add_Click({ Exec-FacebookPhone })
$btnLookupLineApp.Add_Click({ Exec-LineApp })
$btnLookupLine.Add_Click({ Exec-LinePhone })
$btnLookupInstagram.Add_Click({ Exec-InstagramPhone })
$btnLookupTikTok.Add_Click({ Exec-TikTokPhone })
$btnLookupDiscord.Add_Click({ Exec-DiscordPhone })
$btnLookupDiscordCdn.Add_Click({ Exec-DiscordCdn })

$btnLookupWhoscall.Add_Click({ Exec-Whoscall })
$btnLookupTruecaller.Add_Click({ Exec-Truecaller })
$btnLookupWhatsApp.Add_Click({ Exec-WhatsAppPhone })
$btnLookupBlacklist.Add_Click({ Exec-Blacklistseller })
$btnLookupGoogle.Add_Click({ Exec-GooglePhone })

$btnBridgeToImageTab.Add_Click({
    $mainTabControl.SelectedIndex = 0
    Set-AppStatus "สลับมาที่โหมดค้นหารูปภาพแล้ว กรุณาเลือกหรือวางรูปภาพที่ต้องการสแกน" "#38BDF8"
})

$btnMasterPhoneSearch.Add_Click({
    $num = Get-CleanPhone
    if (-not $num) {
        [System.Windows.MessageBox]::Show("กรุณากรอกเบอร์โทรศัพท์ก่อนเริ่มค้นหาครับ", "แจ้งเตือน", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
        return
    }
    Set-AppStatus "เปิดระบบค้นหาในเว็บ In-App Search (ไม่เด้งออกเว็บภายนอก)..." "#10B981"
    if (Test-Path $htmlPath) {
        Open-Url "file:///$($htmlPath.Replace('\', '/'))"
    } else {
        Exec-Whoscall
    }
    Set-AppStatus "ระบบ In-App Search พร้อมใช้งานบนหน้าเว็บ (กรองเฉพาะที่พบข้อมูล)" "#10B981"
})

$btnMasterSearch.Add_Click({
    if ($mainTabControl.SelectedIndex -eq 1) {
        $btnMasterPhoneSearch.RaiseEvent((New-Object System.Windows.RoutedEventArgs([System.Windows.Controls.Button]::ClickEvent)))
    } else {
        Set-AppStatus "เปิดระบบ In-App Visual OSINT (ค้นหาในเว็บ ไม่เด้งแท็บ กรองเฉพาะที่พบข้อมูล)..." "#10B981"
        if (Test-Path $htmlPath) {
            Open-Url "file:///$($htmlPath.Replace('\', '/'))"
        } else {
            Exec-Yandex
        }
        Set-AppStatus "ระบบ In-App Visual Search พร้อมใช้งานบนหน้าเว็บ (กรองเฉพาะที่พบข้อมูล)" "#10B981"
    }
})

$window.ShowDialog() | Out-Null
