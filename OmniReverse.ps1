<#
================================================================================
  OmniReverse OSINT - Cross-Platform Reverse Image Search & Social Media Hub
  Version: 2.5 Pro
  Author: Google Deepmind Antigravity Agent
================================================================================
#>

# Ensure Single Thread Apartment (STA) Mode
if ([System.Threading.Thread]::CurrentThread.GetApartmentState() -ne [System.Threading.ApartmentState]::STA) {
    powershell.exe -ExecutionPolicy Bypass -NoProfile -STA -WindowStyle Hidden -File $MyInvocation.MyCommand.Path
    exit
}

Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Drawing, System.Windows.Forms, System.Net.Http

[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12 -bor [System.Net.SecurityProtocolType]::Tls11 -bor [System.Net.SecurityProtocolType]::Tls

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$logoPath = Join-Path $scriptDir "assets\logo.jpg"

$xamlString = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="OmniReverse Pro — Cross-Platform Reverse Image Search &amp; OSINT Hub"
        Height="860" Width="1240" MinHeight="750" MinWidth="1050"
        WindowStartupLocation="CenterScreen"
        Background="#0A0E17" Foreground="#F3F4F6"
        FontFamily="Segoe UI, Tahoma, sans-serif"
        AllowDrop="True">

    <Window.Resources>
        <!-- Modern ScrollViewer Style -->
        <Style TargetType="ScrollBar">
            <Setter Property="Background" Value="#111827"/>
            <Setter Property="Foreground" Value="#4B5563"/>
        </Style>

        <!-- Glow Button Primary -->
        <Style x:Key="GlowBtn" TargetType="Button">
            <Setter Property="Background" Value="#2563EB"/>
            <Setter Property="Foreground" Value="#FFFFFF"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="FontSize" Value="13"/>
            <Setter Property="Padding" Value="14,9"/>
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

        <!-- Secondary Button -->
        <Style x:Key="SecondaryBtn" TargetType="Button">
            <Setter Property="Background" Value="#1E293B"/>
            <Setter Property="Foreground" Value="#E2E8F0"/>
            <Setter Property="FontWeight" Value="Medium"/>
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="Padding" Value="12,7"/>
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

        <!-- Card Container Style -->
        <Style x:Key="PlatformCard" TargetType="Border">
            <Setter Property="Background" Value="#131B2E"/>
            <Setter Property="BorderBrush" Value="#1E293B"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="CornerRadius" Value="10"/>
            <Setter Property="Padding" Value="14"/>
            <Setter Property="Margin" Value="0,0,0,10"/>
        </Style>
    </Window.Resources>

    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="70"/>   <!-- Header Bar -->
            <RowDefinition Height="*"/>    <!-- Main Content Area -->
            <RowDefinition Height="36"/>   <!-- Status Bar -->
        </Grid.RowDefinitions>

        <!-- ================= TOP HEADER BAR ================= -->
        <Border Grid.Row="0" Background="#0F172A" BorderBrush="#1E293B" BorderThickness="0,0,0,1" Padding="20,10">
            <Grid>
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="Auto"/>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="Auto"/>
                </Grid.ColumnDefinitions>

                <StackPanel Grid.Column="0" Orientation="Horizontal" VerticalAlignment="Center">
                    <Border CornerRadius="8" Width="44" Height="44" Margin="0,0,14,0" Background="#1E293B" ClipToBounds="True">
                        <Image Name="AppLogoImage" Stretch="UniformToFill"/>
                    </Border>
                    <StackPanel VerticalAlignment="Center">
                        <StackPanel Orientation="Horizontal">
                            <TextBlock Text="OmniReverse" FontSize="20" FontWeight="Bold" Foreground="#FFFFFF"/>
                            <Border Background="#6366F1" CornerRadius="4" Padding="6,2" Margin="10,0,0,0" VerticalAlignment="Center">
                                <TextBlock Text="OSINT PRO" FontSize="10" FontWeight="Bold" Foreground="#FFFFFF"/>
                            </Border>
                            <Border Background="#0D9488" CornerRadius="4" Padding="6,2" Margin="6,0,0,0" VerticalAlignment="Center">
                                <TextBlock Text="MULTI-SEARCH" FontSize="10" FontWeight="Bold" Foreground="#FFFFFF"/>
                            </Border>
                        </StackPanel>
                        <TextBlock Text="ค้นหารูปภาพข้ามทุกแพลตฟอร์ม: Google, Instagram, Facebook, Discord, Yandex, Bing, FaceCheck" FontSize="11" Foreground="#94A3B8" Margin="0,2,0,0"/>
                    </StackPanel>
                </StackPanel>

                <!-- Search Options & Mode Switch -->
                <StackPanel Grid.Column="2" Orientation="Horizontal" VerticalAlignment="Center">
                    <Border Background="#1E293B" CornerRadius="8" Padding="12,6" Margin="0,0,10,0">
                        <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
                            <TextBlock Text="โหมดค้นหา:" FontSize="12" Foreground="#94A3B8" VerticalAlignment="Center" Margin="0,0,8,0"/>
                            <RadioButton Name="RbCloudMode" Content="☁️ Auto Cloud Upload" IsChecked="True" Foreground="#38BDF8" FontSize="12" VerticalAlignment="Center" Margin="0,0,12,0"/>
                            <RadioButton Name="RbClipboardMode" Content="📋 Direct Clipboard (Offline/Private)" Foreground="#A78BFA" FontSize="12" VerticalAlignment="Center"/>
                        </StackPanel>
                    </Border>
                    <Button Name="BtnClearAll" Content="🗑️ ล้างข้อมูล" Style="{StaticResource SecondaryBtn}"/>
                </StackPanel>
            </Grid>
        </Border>

        <!-- ================= MAIN CONTENT AREA ================= -->
        <Grid Grid.Row="1" Margin="20,16,20,10">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="420" MinWidth="340"/>  <!-- Left: Image Box & Forensics -->
                <ColumnDefinition Width="*"/>                  <!-- Right: Search Engines & Actions -->
            </Grid.ColumnDefinitions>

            <!-- LEFT PANEL: Image Drop & Forensics -->
            <Grid Grid.Column="0" Margin="0,0,16,0">
                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/> <!-- Drop Zone / Preview -->
                    <RowDefinition Height="Auto"/> <!-- Upload & Action Buttons -->
                    <RowDefinition Height="*"/>    <!-- Forensic Metadata & Hash details -->
                </Grid.RowDefinitions>

                <!-- Drop Zone / Image Display -->
                <Border Name="DropZoneBorder" Grid.Row="0" Background="#111827" BorderBrush="#3B82F6" BorderThickness="2" CornerRadius="12" Height="280" AllowDrop="True">
                    <Grid>
                        <!-- Placeholder State (Before Image Loaded) -->
                        <StackPanel Name="DropPlaceholder" VerticalAlignment="Center" HorizontalAlignment="Center">
                            <TextBlock Text="📸" FontSize="44" HorizontalAlignment="Center" Margin="0,0,0,10"/>
                            <TextBlock Text="ลากรูปภาพมาวางที่นี่ (Drag &amp; Drop)" FontSize="15" FontWeight="SemiBold" Foreground="#F3F4F6" HorizontalAlignment="Center"/>
                            <TextBlock Text="รองรับ JPG, PNG, WEBP, GIF, BMP" FontSize="12" Foreground="#64748B" HorizontalAlignment="Center" Margin="0,4,0,12"/>
                            <StackPanel Orientation="Horizontal" HorizontalAlignment="Center">
                                <Button Name="BtnBrowseFile" Content="📂 เลือกไฟล์รูปภาพ" Style="{StaticResource GlowBtn}" Margin="0,0,8,0"/>
                                <Button Name="BtnPasteClipboard" Content="📋 วางจากคลิปบอร์ด (Ctrl+V)" Style="{StaticResource SecondaryBtn}"/>
                            </StackPanel>
                        </StackPanel>

                        <!-- Loaded Image Preview -->
                        <Image Name="PreviewImage" Stretch="Uniform" Visibility="Collapsed" Margin="8"/>

                        <!-- Badge on Top Right of Preview -->
                        <Border Name="ImageLoadedBadge" Background="#10B981" CornerRadius="4" Padding="6,3" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="14" Visibility="Collapsed">
                            <TextBlock Text="✓ LOADED" FontSize="10" FontWeight="Bold" Foreground="#FFFFFF"/>
                        </Border>
                    </Grid>
                </Border>

                <!-- Action Bar under image -->
                <StackPanel Grid.Row="1" Orientation="Horizontal" Margin="0,10,0,10">
                    <Button Name="BtnReupload" Content="📁 เปลี่ยนรูปภาพ" Style="{StaticResource SecondaryBtn}" Margin="0,0,6,0"/>
                    <Button Name="BtnCopyImageToClipboard" Content="📋 ก็อปปี้รูปไปคลิปบอร์ด" Style="{StaticResource SecondaryBtn}" Margin="0,0,6,0"/>
                    <Button Name="BtnCopyUrl" Content="🔗 ก็อปปี้ลิงก์ภาพ" Style="{StaticResource SecondaryBtn}"/>
                </StackPanel>

                <!-- Forensic & Metadata Box -->
                <Border Grid.Row="2" Background="#0F172A" BorderBrush="#1E293B" BorderThickness="1" CornerRadius="10" Padding="14">
                    <ScrollViewer VerticalScrollBarVisibility="Auto">
                        <StackPanel>
                            <TextBlock Text="🔍 รายละเอียดภาพ &amp; ดิจิทัลฟอเรนสิกส์" FontSize="13" FontWeight="Bold" Foreground="#38BDF8" Margin="0,0,0,8"/>

                            <Grid Margin="0,2,0,4">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="90"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <TextBlock Grid.Column="0" Text="ชื่อไฟล์:" Foreground="#94A3B8" FontSize="12"/>
                                <TextBlock Name="TxtFileName" Grid.Column="1" Text="ยังไม่ได้เลือกรูปภาพ" Foreground="#F3F4F6" FontSize="12" TextTrimming="CharacterEllipsis"/>
                            </Grid>

                            <Grid Margin="0,2,0,4">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="90"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <TextBlock Grid.Column="0" Text="ความละเอียด:" Foreground="#94A3B8" FontSize="12"/>
                                <TextBlock Name="TxtDimensions" Grid.Column="1" Text="-" Foreground="#F3F4F6" FontSize="12"/>
                            </Grid>

                            <Grid Margin="0,2,0,4">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="90"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <TextBlock Grid.Column="0" Text="ขนาดไฟล์:" Foreground="#94A3B8" FontSize="12"/>
                                <TextBlock Name="TxtFileSize" Grid.Column="1" Text="-" Foreground="#F3F4F6" FontSize="12"/>
                            </Grid>

                            <Grid Margin="0,2,0,4">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="90"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <TextBlock Grid.Column="0" Text="Public URL:" Foreground="#94A3B8" FontSize="12"/>
                                <TextBlock Name="TxtPublicUrl" Grid.Column="1" Text="ยังไม่ได้อัปโหลด" Foreground="#06B6D4" FontSize="11" TextTrimming="CharacterEllipsis"/>
                            </Grid>

                            <Separator Background="#1E293B" Margin="0,8,0,8"/>

                            <TextBlock Text="MD5 Checksum (ค้นหาไฟล์ซ้ำบน Discord/Web):" Foreground="#94A3B8" FontSize="11" Margin="0,0,0,2"/>
                            <TextBox Name="TxtMd5Hash" IsReadOnly="True" Background="#1E293B" Foreground="#A78BFA" BorderThickness="0" Padding="6,4" FontSize="11" Margin="0,0,0,6"/>

                            <TextBlock Text="SHA-256 Signature:" Foreground="#94A3B8" FontSize="11" Margin="0,0,0,2"/>
                            <TextBox Name="TxtSha256" IsReadOnly="True" Background="#1E293B" Foreground="#A78BFA" BorderThickness="0" Padding="6,4" FontSize="10" Margin="0,0,0,6"/>

                            <TextBlock Text="EXIF / Camera Metadata:" Foreground="#94A3B8" FontSize="11" Margin="0,4,0,2"/>
                            <TextBox Name="TxtExifInfo" IsReadOnly="True" TextWrapping="Wrap" Background="#1E293B" Foreground="#CBD5E1" BorderThickness="0" Padding="6,4" FontSize="11" Height="65" VerticalScrollBarVisibility="Auto"/>
                        </StackPanel>
                    </ScrollViewer>
                </Border>
            </Grid>

            <!-- RIGHT PANEL: Cross-Platform Search Engines & Social Lookups -->
            <Grid Grid.Column="1">
                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/> <!-- Master Launch Bar -->
                    <RowDefinition Height="*"/>    <!-- Platform Cards ScrollView -->
                </Grid.RowDefinitions>

                <!-- MASTER SEARCH BAR -->
                <Border Grid.Row="0" Background="#131B2E" BorderBrush="#2563EB" BorderThickness="1.5" CornerRadius="12" Padding="16,14" Margin="0,0,0,12">
                    <Grid>
                        <Grid.RowDefinitions>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="Auto"/>
                        </Grid.RowDefinitions>

                        <Grid Grid.Row="0">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="Auto"/>
                            </Grid.ColumnDefinitions>

                            <StackPanel Grid.Column="0">
                                <TextBlock Text="🚀 ค้นหาข้ามทุกแพลตฟอร์มพร้อมกัน (One-Click Multi-Search)" FontSize="15" FontWeight="Bold" Foreground="#FFFFFF"/>
                                <TextBlock Text="เปิดแท็บการค้นหาไปยัง Google, Yandex, Bing, Instagram, Facebook, Discord, FaceCheck พร้อมกันในคลิกเดียว" FontSize="11" Foreground="#94A3B8" Margin="0,2,0,0"/>
                            </StackPanel>

                            <Button Name="BtnSearchAll" Grid.Column="1" Content="🚀 เริ่มค้นหาทุกแพลตฟอร์มทันที" Style="{StaticResource GlowBtn}" Padding="20,12" FontSize="14" Background="#3B82F6"/>
                        </Grid>

                        <!-- Optional Keyword / Dork query filter -->
                        <Grid Grid.Row="1" Margin="0,12,0,0">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="Auto"/>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="Auto"/>
                            </Grid.ColumnDefinitions>

                            <TextBlock Grid.Column="0" Text="🏷️ คำค้นหาเจาะจง (Optional Keyword):" Foreground="#94A3B8" FontSize="12" VerticalAlignment="Center" Margin="0,0,10,0"/>
                            <TextBox Name="TxtKeywordFilter" Grid.Column="1" Background="#0F172A" Foreground="#FFFFFF" BorderBrush="#334155" BorderThickness="1" Padding="8,6" FontSize="12" Text="เช่น ชื่อคน, username, สถานที่ หรือข้อความในรูป"/>
                            <Button Name="BtnQuickDork" Grid.Column="2" Content="🔍 ค้นด้วยคำสำคัญ" Style="{StaticResource SecondaryBtn}" Margin="8,0,0,0"/>
                        </Grid>
                    </Grid>
                </Border>

                <!-- PLATFORM CARDS LIST -->
                <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto">
                    <StackPanel>

                        <!-- 1. GOOGLE LENS -->
                        <Border Style="{StaticResource PlatformCard}">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="50"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="Auto"/>
                                </Grid.ColumnDefinitions>
                                <TextBlock Grid.Column="0" Text="🔍" FontSize="28" VerticalAlignment="Center" HorizontalAlignment="Center"/>
                                <StackPanel Grid.Column="1" VerticalAlignment="Center" Margin="8,0,0,0">
                                    <StackPanel Orientation="Horizontal">
                                        <TextBlock Text="Google Lens / Reverse Search" FontSize="14" FontWeight="Bold" Foreground="#FFFFFF"/>
                                        <Border Background="#EA4335" CornerRadius="4" Padding="5,1" Margin="8,0,0,0">
                                            <TextBlock Text="Google" FontSize="9" FontWeight="Bold" Foreground="#FFFFFF"/>
                                        </Border>
                                    </StackPanel>
                                    <TextBlock Text="ค้นหาแหล่งที่มาของภาพทั่วโลก, สแกนข้อความในภาพ (OCR), และค้นหาภาพที่คล้ายกัน" FontSize="11" Foreground="#94A3B8" Margin="0,2,0,0"/>
                                </StackPanel>
                                <StackPanel Grid.Column="2" Orientation="Horizontal" VerticalAlignment="Center">
                                    <CheckBox Name="ChkGoogle" IsChecked="True" VerticalAlignment="Center" Margin="0,0,12,0" ToolTip="รวมในการค้นหา Multi-Search"/>
                                    <Button Name="BtnSearchGoogle" Content="ค้นหาด้วย Google Lens" Style="{StaticResource SecondaryBtn}"/>
                                </StackPanel>
                            </Grid>
                        </Border>

                        <!-- 2. INSTAGRAM (META) -->
                        <Border Style="{StaticResource PlatformCard}">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="50"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="Auto"/>
                                </Grid.ColumnDefinitions>
                                <TextBlock Grid.Column="0" Text="📸" FontSize="28" VerticalAlignment="Center" HorizontalAlignment="Center"/>
                                <StackPanel Grid.Column="1" VerticalAlignment="Center" Margin="8,0,0,0">
                                    <StackPanel Orientation="Horizontal">
                                        <TextBlock Text="Instagram Search &amp; Profile Dorks" FontSize="14" FontWeight="Bold" Foreground="#FFFFFF"/>
                                        <Border Background="#E1306C" CornerRadius="4" Padding="5,1" Margin="8,0,0,0">
                                            <TextBlock Text="Instagram" FontSize="9" FontWeight="Bold" Foreground="#FFFFFF"/>
                                        </Border>
                                        <Border Background="#3B82F6" CornerRadius="4" Padding="5,1" Margin="6,0,0,0">
                                            <TextBlock Text="Meta OSINT" FontSize="9" FontWeight="Bold" Foreground="#FFFFFF"/>
                                        </Border>
                                    </StackPanel>
                                    <TextBlock Text="ค้นหาโปรไฟล์, โพสต์, รูปภาพบน Instagram ผ่าน Google/Yandex Index + Instagram Search Dorks" FontSize="11" Foreground="#94A3B8" Margin="0,2,0,0"/>
                                </StackPanel>
                                <StackPanel Grid.Column="2" Orientation="Horizontal" VerticalAlignment="Center">
                                    <CheckBox Name="ChkInstagram" IsChecked="True" VerticalAlignment="Center" Margin="0,0,12,0" ToolTip="รวมในการค้นหา Multi-Search"/>
                                    <Button Name="BtnSearchInstagram" Content="เจาะหาบน Instagram" Style="{StaticResource SecondaryBtn}"/>
                                </StackPanel>
                            </Grid>
                        </Border>

                        <!-- 3. FACEBOOK (META) -->
                        <Border Style="{StaticResource PlatformCard}">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="50"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="Auto"/>
                                </Grid.ColumnDefinitions>
                                <TextBlock Grid.Column="0" Text="👥" FontSize="28" VerticalAlignment="Center" HorizontalAlignment="Center"/>
                                <StackPanel Grid.Column="1" VerticalAlignment="Center" Margin="8,0,0,0">
                                    <StackPanel Orientation="Horizontal">
                                        <TextBlock Text="Facebook Profile &amp; Post Lookups" FontSize="14" FontWeight="Bold" Foreground="#FFFFFF"/>
                                        <Border Background="#1877F2" CornerRadius="4" Padding="5,1" Margin="8,0,0,0">
                                            <TextBlock Text="Facebook" FontSize="9" FontWeight="Bold" Foreground="#FFFFFF"/>
                                        </Border>
                                    </StackPanel>
                                    <TextBlock Text="ค้นหารูปภาพโปรไฟล์, เพจสาธารณะ, กลุ่ม และโพสต์ Facebook ที่เคยอัปโหลดรูปนี้" FontSize="11" Foreground="#94A3B8" Margin="0,2,0,0"/>
                                </StackPanel>
                                <StackPanel Grid.Column="2" Orientation="Horizontal" VerticalAlignment="Center">
                                    <CheckBox Name="ChkFacebook" IsChecked="True" VerticalAlignment="Center" Margin="0,0,12,0" ToolTip="รวมในการค้นหา Multi-Search"/>
                                    <Button Name="BtnSearchFacebook" Content="เจาะหาบน Facebook" Style="{StaticResource SecondaryBtn}"/>
                                </StackPanel>
                            </Grid>
                        </Border>

                        <!-- 4. DISCORD -->
                        <Border Style="{StaticResource PlatformCard}">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="50"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="Auto"/>
                                </Grid.ColumnDefinitions>
                                <TextBlock Grid.Column="0" Text="💬" FontSize="28" VerticalAlignment="Center" HorizontalAlignment="Center"/>
                                <StackPanel Grid.Column="1" VerticalAlignment="Center" Margin="8,0,0,0">
                                    <StackPanel Orientation="Horizontal">
                                        <TextBlock Text="Discord CDN &amp; Public Server Tracker" FontSize="14" FontWeight="Bold" Foreground="#FFFFFF"/>
                                        <Border Background="#5865F2" CornerRadius="4" Padding="5,1" Margin="8,0,0,0">
                                            <TextBlock Text="Discord" FontSize="9" FontWeight="Bold" Foreground="#FFFFFF"/>
                                        </Border>
                                    </StackPanel>
                                    <TextBlock Text="สแกนหาไฟล์แนบบน Discord CDN, เซิร์ฟเวอร์สาธารณะ, ชุมชนบอท และก็อปปี้รูปไปวางในแชท Discord ทันที" FontSize="11" Foreground="#94A3B8" Margin="0,2,0,0"/>
                                </StackPanel>
                                <StackPanel Grid.Column="2" Orientation="Horizontal" VerticalAlignment="Center">
                                    <CheckBox Name="ChkDiscord" IsChecked="True" VerticalAlignment="Center" Margin="0,0,12,0" ToolTip="รวมในการค้นหา Multi-Search"/>
                                    <Button Name="BtnSearchDiscord" Content="ค้นหาบน Discord" Style="{StaticResource SecondaryBtn}"/>
                                </StackPanel>
                            </Grid>
                        </Border>

                        <!-- 5. YANDEX VISUAL (BEST FOR SOCIAL & FACES) -->
                        <Border Style="{StaticResource PlatformCard}">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="50"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="Auto"/>
                                </Grid.ColumnDefinitions>
                                <TextBlock Grid.Column="0" Text="🌐" FontSize="28" VerticalAlignment="Center" HorizontalAlignment="Center"/>
                                <StackPanel Grid.Column="1" VerticalAlignment="Center" Margin="8,0,0,0">
                                    <StackPanel Orientation="Horizontal">
                                        <TextBlock Text="Yandex Visual Search (แนะนำสูงสุดสำหรับใบหน้า &amp; โซเชียล)" FontSize="14" FontWeight="Bold" Foreground="#FFFFFF"/>
                                        <Border Background="#FC3F1D" CornerRadius="4" Padding="5,1" Margin="8,0,0,0">
                                            <TextBlock Text="แม่นยำสูงมาก" FontSize="9" FontWeight="Bold" Foreground="#FFFFFF"/>
                                        </Border>
                                    </StackPanel>
                                    <TextBlock Text="ระบบค้นหาใบหน้าและบัญชีโซเชียลอันดับ 1 ของโลก ค้นพบโปรไฟล์ Instagram, VK และเว็บที่ Google หาไม่เจอ" FontSize="11" Foreground="#94A3B8" Margin="0,2,0,0"/>
                                </StackPanel>
                                <StackPanel Grid.Column="2" Orientation="Horizontal" VerticalAlignment="Center">
                                    <CheckBox Name="ChkYandex" IsChecked="True" VerticalAlignment="Center" Margin="0,0,12,0" ToolTip="รวมในการค้นหา Multi-Search"/>
                                    <Button Name="BtnSearchYandex" Content="ค้นหาด้วย Yandex" Style="{StaticResource SecondaryBtn}"/>
                                </StackPanel>
                            </Grid>
                        </Border>

                        <!-- 6. BING VISUAL SEARCH -->
                        <Border Style="{StaticResource PlatformCard}">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="50"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="Auto"/>
                                </Grid.ColumnDefinitions>
                                <TextBlock Grid.Column="0" Text="🟦" FontSize="28" VerticalAlignment="Center" HorizontalAlignment="Center"/>
                                <StackPanel Grid.Column="1" VerticalAlignment="Center" Margin="8,0,0,0">
                                    <StackPanel Orientation="Horizontal">
                                        <TextBlock Text="Microsoft Bing Visual Search" FontSize="14" FontWeight="Bold" Foreground="#FFFFFF"/>
                                        <Border Background="#008373" CornerRadius="4" Padding="5,1" Margin="8,0,0,0">
                                            <TextBlock Text="Bing" FontSize="9" FontWeight="Bold" Foreground="#FFFFFF"/>
                                        </Border>
                                    </StackPanel>
                                    <TextBlock Text="ค้นหาบุคคล วัตถุ และสินค้า พร้อมระบบตรวจจับองค์ประกอบย่อยในรูปภาพของ Microsoft" FontSize="11" Foreground="#94A3B8" Margin="0,2,0,0"/>
                                </StackPanel>
                                <StackPanel Grid.Column="2" Orientation="Horizontal" VerticalAlignment="Center">
                                    <CheckBox Name="ChkBing" IsChecked="True" VerticalAlignment="Center" Margin="0,0,12,0" ToolTip="รวมในการค้นหา Multi-Search"/>
                                    <Button Name="BtnSearchBing" Content="ค้นหาด้วย Bing" Style="{StaticResource SecondaryBtn}"/>
                                </StackPanel>
                            </Grid>
                        </Border>

                        <!-- 7. TINEYE REVERSE SEARCH -->
                        <Border Style="{StaticResource PlatformCard}">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="50"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="Auto"/>
                                </Grid.ColumnDefinitions>
                                <TextBlock Grid.Column="0" Text="👁️" FontSize="28" VerticalAlignment="Center" HorizontalAlignment="Center"/>
                                <StackPanel Grid.Column="1" VerticalAlignment="Center" Margin="8,0,0,0">
                                    <StackPanel Orientation="Horizontal">
                                        <TextBlock Text="TinEye Reverse Image Search" FontSize="14" FontWeight="Bold" Foreground="#FFFFFF"/>
                                        <Border Background="#0EA5E9" CornerRadius="4" Padding="5,1" Margin="8,0,0,0">
                                            <TextBlock Text="Original Tracker" FontSize="9" FontWeight="Bold" Foreground="#FFFFFF"/>
                                        </Border>
                                    </StackPanel>
                                    <TextBlock Text="ค้นหารูปต้นฉบับ ดูประวัติวันที่ปรากฏครั้งแรกบนอินเทอร์เน็ต และตรวจสอบการตัดต่อ/ดัดแปลง" FontSize="11" Foreground="#94A3B8" Margin="0,2,0,0"/>
                                </StackPanel>
                                <StackPanel Grid.Column="2" Orientation="Horizontal" VerticalAlignment="Center">
                                    <CheckBox Name="ChkTinEye" IsChecked="True" VerticalAlignment="Center" Margin="0,0,12,0" ToolTip="รวมในการค้นหา Multi-Search"/>
                                    <Button Name="BtnSearchTinEye" Content="ค้นหาด้วย TinEye" Style="{StaticResource SecondaryBtn}"/>
                                </StackPanel>
                            </Grid>
                        </Border>

                        <!-- 8. FACECHECK & PIMEYES (AI FACE RECOGNITION) -->
                        <Border Style="{StaticResource PlatformCard}">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="50"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="Auto"/>
                                </Grid.ColumnDefinitions>
                                <TextBlock Grid.Column="0" Text="👤" FontSize="28" VerticalAlignment="Center" HorizontalAlignment="Center"/>
                                <StackPanel Grid.Column="1" VerticalAlignment="Center" Margin="8,0,0,0">
                                    <StackPanel Orientation="Horizontal">
                                        <TextBlock Text="FaceCheck.id &amp; PimEyes (AI Face Recognition)" FontSize="14" FontWeight="Bold" Foreground="#FFFFFF"/>
                                        <Border Background="#8B5CF6" CornerRadius="4" Padding="5,1" Margin="8,0,0,0">
                                            <TextBlock Text="AI Facial OSINT" FontSize="9" FontWeight="Bold" Foreground="#FFFFFF"/>
                                        </Border>
                                    </StackPanel>
                                    <TextBlock Text="เจาะลึกค้นหาใบหน้าเฉพาะบุคคลบน Instagram, Facebook, TikTok, Twitter, LinkedIn และโซเชียลมีเดีย" FontSize="11" Foreground="#94A3B8" Margin="0,2,0,0"/>
                                </StackPanel>
                                <StackPanel Grid.Column="2" Orientation="Horizontal" VerticalAlignment="Center">
                                    <CheckBox Name="ChkFaceCheck" IsChecked="True" VerticalAlignment="Center" Margin="0,0,12,0" ToolTip="รวมในการค้นหา Multi-Search"/>
                                    <Button Name="BtnSearchFaceCheck" Content="สแกนใบหน้าข้ามโซเชียล" Style="{StaticResource SecondaryBtn}"/>
                                </StackPanel>
                            </Grid>
                        </Border>

                    </StackPanel>
                </ScrollViewer>
            </Grid>
        </Grid>

        <!-- ================= STATUS BAR ================= -->
        <Border Grid.Row="2" Background="#0B0F19" BorderBrush="#1E293B" BorderThickness="0,1,0,0" Padding="20,0">
            <Grid VerticalAlignment="Center">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="Auto"/>
                </Grid.ColumnDefinitions>

                <StackPanel Grid.Column="0" Orientation="Horizontal">
                    <TextBlock Text="●" Name="StatusDot" Foreground="#10B981" FontSize="14" VerticalAlignment="Center" Margin="0,0,6,0"/>
                    <TextBlock Name="TxtStatus" Text="พร้อมใช้งาน: ลากรูปภาพมาวางหรือกดเลือกไฟล์เพื่อเริ่มต้นค้นหา" FontSize="12" Foreground="#94A3B8" VerticalAlignment="Center"/>
                </StackPanel>

                <TextBlock Grid.Column="1" Text="OmniReverse Engine v2.5 | Ready" FontSize="11" Foreground="#64748B" VerticalAlignment="Center"/>
            </Grid>
        </Border>
    </Grid>
</Window>
"@

# Global State Variables
$global:CurrentFilePath = ""
$global:CurrentPublicUrl = ""
$global:CurrentBitmap = $null

# Parse XAML
$reader = [System.Xml.XmlReader]::Create([System.IO.StringReader]::new($xamlString))
$window = [System.Windows.Markup.XamlReader]::Load($reader)

# Map UI Controls
$appLogoImage = $window.FindName("AppLogoImage")
$dropZoneBorder = $window.FindName("DropZoneBorder")
$dropPlaceholder = $window.FindName("DropPlaceholder")
$previewImage = $window.FindName("PreviewImage")
$imageLoadedBadge = $window.FindName("ImageLoadedBadge")

$btnBrowseFile = $window.FindName("BtnBrowseFile")
$btnPasteClipboard = $window.FindName("BtnPasteClipboard")
$btnReupload = $window.FindName("BtnReupload")
$btnCopyImageToClipboard = $window.FindName("BtnCopyImageToClipboard")
$btnCopyUrl = $window.FindName("BtnCopyUrl")
$btnClearAll = $window.FindName("BtnClearAll")

$rbCloudMode = $window.FindName("RbCloudMode")
$rbClipboardMode = $window.FindName("RbClipboardMode")

$txtFileName = $window.FindName("TxtFileName")
$txtDimensions = $window.FindName("TxtDimensions")
$txtFileSize = $window.FindName("TxtFileSize")
$txtPublicUrl = $window.FindName("TxtPublicUrl")
$txtMd5Hash = $window.FindName("TxtMd5Hash")
$txtSha256 = $window.FindName("TxtSha256")
$txtExifInfo = $window.FindName("TxtExifInfo")

$txtKeywordFilter = $window.FindName("TxtKeywordFilter")
$btnQuickDork = $window.FindName("BtnQuickDork")
$btnSearchAll = $window.FindName("BtnSearchAll")

$chkGoogle = $window.FindName("ChkGoogle")
$chkInstagram = $window.FindName("ChkInstagram")
$chkFacebook = $window.FindName("ChkFacebook")
$chkDiscord = $window.FindName("ChkDiscord")
$chkYandex = $window.FindName("ChkYandex")
$chkBing = $window.FindName("ChkBing")
$chkTinEye = $window.FindName("ChkTinEye")
$chkFaceCheck = $window.FindName("ChkFaceCheck")

$btnSearchGoogle = $window.FindName("BtnSearchGoogle")
$btnSearchInstagram = $window.FindName("BtnSearchInstagram")
$btnSearchFacebook = $window.FindName("BtnSearchFacebook")
$btnSearchDiscord = $window.FindName("BtnSearchDiscord")
$btnSearchYandex = $window.FindName("BtnSearchYandex")
$btnSearchBing = $window.FindName("BtnSearchBing")
$btnSearchTinEye = $window.FindName("BtnSearchTinEye")
$btnSearchFaceCheck = $window.FindName("BtnSearchFaceCheck")

$statusDot = $window.FindName("StatusDot")
$txtStatus = $window.FindName("TxtStatus")

# Load App Logo if exists
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

# Helper: Update Status Message
function Set-AppStatus([string]$msg, [string]$color = "#10B981") {
    $window.Dispatcher.Invoke([Action]{
        $txtStatus.Text = $msg
        $statusDot.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString($color)
    })
}

# Helper: Upload Image to Temporary Cloud Host for Search Engines
function Upload-ImageToHost([string]$filePath) {
    if (-not (Test-Path $filePath)) { return "" }
    
    Set-AppStatus "กำลังอัปโหลดภาพขึ้นคลาวด์ชั่วคราวเพื่อส่งให้ Search Engine..." "#38BDF8"
    
    # 1. Try Litterbox / Catbox (1 hour auto-delete for privacy)
    try {
        $handler = New-Object System.Net.Http.HttpClientHandler
        $client = New-Object System.Net.Http.HttpClient($handler)
        $client.Timeout = [TimeSpan]::FromSeconds(15)

        $form = New-Object System.Net.Http.MultipartFormDataContent
        $form.Add((New-Object System.Net.Http.StringContent("fileupload")), "reqtype")
        $form.Add((New-Object System.Net.Http.StringContent("1h")), "time")

        $fileBytes = [System.IO.File]::ReadAllBytes($filePath)
        $fileContent = New-Object System.Net.Http.ByteArrayContent($fileBytes, 0, $fileBytes.Length)
        
        $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
        $mime = switch ($ext) {
            ".png" { "image/png" }
            ".gif" { "image/gif" }
            ".webp" { "image/webp" }
            ".bmp" { "image/bmp" }
            default { "image/jpeg" }
        }
        $fileContent.Headers.ContentType = [System.Net.Http.Headers.MediaTypeHeaderValue]::Parse($mime)
        $form.Add($fileContent, "fileToUpload", [System.IO.Path]::GetFileName($filePath))

        $res = $client.PostAsync("https://litterbox.catbox.moe/resources/internals/api.php", $form).Result
        if ($res.IsSuccessStatusCode) {
            $url = $res.Content.ReadAsStringAsync().Result.Trim()
            if ($url -match "^https?://") {
                Set-AppStatus "อัปโหลดภาพสำเร็จ: พร้อมค้นหาแล้ว!" "#10B981"
                return $url
            }
        }
    } catch {}

    # 2. Fallback: tmpfiles.org
    try {
        $handler = New-Object System.Net.Http.HttpClientHandler
        $client = New-Object System.Net.Http.HttpClient($handler)
        $client.Timeout = [TimeSpan]::FromSeconds(15)

        $form = New-Object System.Net.Http.MultipartFormDataContent
        $fileBytes = [System.IO.File]::ReadAllBytes($filePath)
        $fileContent = New-Object System.Net.Http.ByteArrayContent($fileBytes, 0, $fileBytes.Length)
        $form.Add($fileContent, "input", [System.IO.Path]::GetFileName($filePath))

        $res = $client.PostAsync("https://tmpfiles.org/api/v1/upload", $form).Result
        if ($res.IsSuccessStatusCode) {
            $jsonStr = $res.Content.ReadAsStringAsync().Result
            $json = ConvertFrom-Json $jsonStr
            if ($json.data.url) {
                # tmpfiles.org returns view URL -> convert to dl direct link
                $directUrl = $json.data.url.Replace("tmpfiles.org/", "tmpfiles.org/dl/")
                Set-AppStatus "อัปโหลดภาพสำเร็จ (tmpfiles): พร้อมค้นหา!" "#10B981"
                return $directUrl
            }
        }
    } catch {}

    Set-AppStatus "การอัปโหลดอัตโนมัติไม่สำเร็จ (จะใช้โหมด Clipboard คัดลอกภาพไปวางแทน)" "#F59E0B"
    return ""
}

# Helper: Extract EXIF Metadata
function Get-ExifMetadata([string]$filePath) {
    $sb = [System.Text.StringBuilder]::new()
    try {
        $img = [System.Drawing.Image]::FromFile($filePath)
        $items = $img.PropertyItems
        $img.Dispose()

        $hasExif = $false
        foreach ($item in $items) {
            # 0x010F = Make, 0x0110 = Model, 0x0132 = DateTime, 0x0131 = Software
            if ($item.Id -eq 0x010F) {
                $val = [System.Text.Encoding]::ASCII.GetString($item.Value).Trim([char]0)
                [void]$sb.AppendLine("Camera Make: $val")
                $hasExif = $true
            }
            if ($item.Id -eq 0x0110) {
                $val = [System.Text.Encoding]::ASCII.GetString($item.Value).Trim([char]0)
                [void]$sb.AppendLine("Camera Model: $val")
                $hasExif = $true
            }
            if ($item.Id -eq 0x0132) {
                $val = [System.Text.Encoding]::ASCII.GetString($item.Value).Trim([char]0)
                [void]$sb.AppendLine("Date Taken: $val")
                $hasExif = $true
            }
            if ($item.Id -eq 0x0131) {
                $val = [System.Text.Encoding]::ASCII.GetString($item.Value).Trim([char]0)
                [void]$sb.AppendLine("Software: $val")
                $hasExif = $true
            }
        }
        if (-not $hasExif) {
            return "ไม่มีข้อมูล EXIF (ภาพอาจถูกบีบอัดหรือลบ Metadata แล้ว)"
        }
        return $sb.ToString().Trim()
    } catch {
        return "ไม่พบข้อมูล EXIF"
    }
}

# Helper: Process and Load Image
function Load-ImageFile([string]$path) {
    if (-not (Test-Path $path)) { return }
    
    $global:CurrentFilePath = $path
    $global:CurrentPublicUrl = ""

    try {
        # Load Bitmap for WPF Preview
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

        # Basic Info
        $fi = Get-Item $path
        $txtFileName.Text = $fi.Name
        $txtDimensions.Text = "$($bmp.PixelWidth) × $($bmp.PixelHeight) px"
        $sizeKb = [Math]::Round($fi.Length / 1KB, 1)
        if ($sizeKb -gt 1024) {
            $txtFileSize.Text = "$([Math]::Round($sizeKb / 1024, 2)) MB"
        } else {
            $txtFileSize.Text = "$sizeKb KB"
        }

        # Checksums
        $md5 = (Get-FileHash -Path $path -Algorithm MD5).Hash
        $sha256 = (Get-FileHash -Path $path -Algorithm SHA256).Hash
        $txtMd5Hash.Text = $md5
        $txtSha256.Text = $sha256

        # EXIF Metadata
        $txtExifInfo.Text = Get-ExifMetadata $path

        # Copy image directly to Windows Clipboard so user can Ctrl+V immediately anywhere!
        try {
            [System.Windows.Clipboard]::SetImage($bmp)
            Set-AppStatus "โหลดรูปภาพสำเร็จ & ก็อปปี้ลงคลิปบอร์ดแล้ว (กด Ctrl+V วางได้ทันที!)" "#10B981"
        } catch {
            Set-AppStatus "โหลดรูปภาพสำเร็จ: พร้อมค้นหา" "#10B981"
        }

        # Cloud Upload if selected
        if ($rbCloudMode.IsChecked) {
            [System.Threading.ThreadPool]::QueueUserWorkItem({
                $url = Upload-ImageToHost $path
                if ($url) {
                    $global:CurrentPublicUrl = $url
                    $window.Dispatcher.Invoke([Action]{
                        $txtPublicUrl.Text = $url
                    })
                }
            })
        } else {
            $txtPublicUrl.Text = "ปิดการอัปโหลด (โหมด Clipboard)"
        }

    } catch {
        [System.Windows.MessageBox]::Show("เกิดข้อผิดพลาดในการโหลดรูปภาพ: $($_.Exception.Message)", "OmniReverse Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
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

# Browse File Button
$btnBrowseFile.Add_Click({
    $dlg = New-Object System.Windows.Forms.OpenFileDialog
    $dlg.Title = "เลือกไฟล์รูปภาพที่ต้องการค้นหา"
    $dlg.Filter = "Image Files (*.jpg;*.jpeg;*.png;*.webp;*.gif;*.bmp)|*.jpg;*.jpeg;*.png;*.webp;*.gif;*.bmp|All Files (*.*)|*.*"
    if ($dlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        Load-ImageFile $dlg.FileName
    }
})

$btnReupload.Add_Click({
    $dlg = New-Object System.Windows.Forms.OpenFileDialog
    $dlg.Title = "เลือกไฟล์รูปภาพใหม่"
    $dlg.Filter = "Image Files (*.jpg;*.jpeg;*.png;*.webp;*.gif;*.bmp)|*.jpg;*.jpeg;*.png;*.webp;*.gif;*.bmp|All Files (*.*)|*.*"
    if ($dlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        Load-ImageFile $dlg.FileName
    }
})

# Paste from Clipboard Button
$btnPasteClipboard.Add_Click({
    if ([System.Windows.Clipboard]::ContainsImage()) {
        $imgSource = [System.Windows.Clipboard]::GetImage()
        $tempPath = Join-Path $env:TEMP "OmniReverse_Clipboard_$([Guid]::NewGuid().ToString('N')).png"
        
        $encoder = New-Object System.Windows.Media.Imaging.PngBitmapEncoder
        $encoder.Frames.Add([System.Windows.Media.Imaging.BitmapFrame]::Create($imgSource))
        $fs = New-Object System.IO.FileStream($tempPath, [System.IO.FileMode]::Create)
        $encoder.Save($fs)
        $fs.Close()
        $fs.Dispose()

        Load-ImageFile $tempPath
    } elseif ([System.Windows.Clipboard]::ContainsFileDropList()) {
        $files = [System.Windows.Clipboard]::GetFileDropList()
        if ($files.Count -gt 0) {
            Load-ImageFile $files[0]
        }
    } else {
        [System.Windows.MessageBox]::Show("ไม่พบรูปภาพในคลิปบอร์ด กรุณาใช้ Snipping Tool (Win+Shift+S) หรือคัดลอกรูปภาพมาก่อน", "คลิปบอร์ดว่างเปล่า", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    }
})

# Copy Image to Clipboard
$btnCopyImageToClipboard.Add_Click({
    if ($global:CurrentBitmap) {
        try {
            [System.Windows.Clipboard]::SetImage($global:CurrentBitmap)
            Set-AppStatus "คัดลอกรูปภาพลงคลิปบอร์ดแล้ว! กด Ctrl+V วางใน Discord หรือเบราว์เซอร์ได้ทันที" "#10B981"
        } catch {
            Set-AppStatus "ไม่สามารถคัดลอกภาพลงคลิปบอร์ดได้" "#EF4444"
        }
    } else {
        Set-AppStatus "ยังไม่มีรูปภาพที่จะคัดลอก" "#F59E0B"
    }
})

# Copy URL Button
$btnCopyUrl.Add_Click({
    if ($global:CurrentPublicUrl) {
        [System.Windows.Clipboard]::SetText($global:CurrentPublicUrl)
        Set-AppStatus "คัดลอก Public URL ลงคลิปบอร์ดแล้ว: $($global:CurrentPublicUrl)" "#10B981"
    } elseif ($global:CurrentFilePath) {
        [System.Windows.Clipboard]::SetText($global:CurrentFilePath)
        Set-AppStatus "คัดลอกตำแหน่งไฟล์ในเครื่องแล้ว: $($global:CurrentFilePath)" "#10B981"
    }
})

# Clear All Button
$btnClearAll.Add_Click({
    $global:CurrentFilePath = ""
    $global:CurrentPublicUrl = ""
    $global:CurrentBitmap = $null
    
    $previewImage.Source = $null
    $previewImage.Visibility = [System.Windows.Visibility]::Collapsed
    $dropPlaceholder.Visibility = [System.Windows.Visibility]::Visible
    $imageLoadedBadge.Visibility = [System.Windows.Visibility]::Collapsed

    $txtFileName.Text = "ยังไม่ได้เลือกรูปภาพ"
    $txtDimensions.Text = "-"
    $txtFileSize.Text = "-"
    $txtPublicUrl.Text = "ยังไม่ได้อัปโหลด"
    $txtMd5Hash.Text = ""
    $txtSha256.Text = ""
    $txtExifInfo.Text = ""
    $txtKeywordFilter.Text = ""

    Set-AppStatus "ล้างข้อมูลเรียบร้อยแล้ว: พร้อมสำหรับภาพใหม่" "#10B981"
})

# Search Helper: Launch Browser URL
function Open-SearchUrl([string]$url) {
    if (-not $url) { return }
    try {
        [System.Diagnostics.Process]::Start([System.Diagnostics.ProcessStartInfo]::new($url) | ForEach-Object { $_.UseShellExecute = $true; $_ })
    } catch {
        Start-Process $url
    }
}

# Engine Search Functions
function Search-GoogleLens {
    if ($global:CurrentBitmap) {
        try { [System.Windows.Clipboard]::SetImage($global:CurrentBitmap) } catch {}
    }
    if ($global:CurrentPublicUrl) {
        $encoded = [System.Web.HttpUtility]::UrlEncode($global:CurrentPublicUrl)
        Open-SearchUrl "https://lens.google.com/uploadbyurl?url=$encoded"
    } else {
        Open-SearchUrl "https://lens.google.com/"
    }
}

function Search-Instagram {
    $keyword = $txtKeywordFilter.Text.Trim()
    if ($keyword -eq "เช่น ชื่อคน, username, สถานที่ หรือข้อความในรูป") { $keyword = "" }
    
    if ($global:CurrentPublicUrl) {
        $encoded = [System.Web.HttpUtility]::UrlEncode($global:CurrentPublicUrl)
        # Yandex visual search with Instagram focus + Google Dork
        Open-SearchUrl "https://yandex.com/images/search?rpt=imageview&url=$encoded"
    }
    
    if ($keyword) {
        $dork = [System.Web.HttpUtility]::UrlEncode("site:instagram.com `"$keyword`"")
        Open-SearchUrl "https://www.google.com/search?q=$dork"
    } else {
        $dork = [System.Web.HttpUtility]::UrlEncode("site:instagram.com")
        Open-SearchUrl "https://www.google.com/search?q=$dork"
    }
}

function Search-Facebook {
    $keyword = $txtKeywordFilter.Text.Trim()
    if ($keyword -eq "เช่น ชื่อคน, username, สถานที่ หรือข้อความในรูป") { $keyword = "" }

    if ($global:CurrentPublicUrl) {
        $encoded = [System.Web.HttpUtility]::UrlEncode($global:CurrentPublicUrl)
        Open-SearchUrl "https://www.bing.com/images/search?view=detailv2&iss=sbi&imgurl=$encoded"
    }

    if ($keyword) {
        $dork = [System.Web.HttpUtility]::UrlEncode("site:facebook.com `"$keyword`"")
        Open-SearchUrl "https://www.google.com/search?q=$dork"
    } else {
        $dork = [System.Web.HttpUtility]::UrlEncode("site:facebook.com photo OR profile")
        Open-SearchUrl "https://www.google.com/search?q=$dork"
    }
}

function Search-Discord {
    $keyword = $txtKeywordFilter.Text.Trim()
    if ($keyword -eq "เช่น ชื่อคน, username, สถานที่ หรือข้อความในรูป") { $keyword = "" }

    if ($global:CurrentBitmap) {
        try {
            [System.Windows.Clipboard]::SetImage($global:CurrentBitmap)
            Set-AppStatus "ก็อปปี้รูปไปคลิปบอร์ดแล้ว! กด Ctrl+V วางในแชท Discord ได้ทันที" "#10B981"
        } catch {}
    }

    $hashQuery = ""
    if ($txtMd5Hash.Text) { $hashQuery = "`"$($txtMd5Hash.Text)`"" }

    $query = "site:discord.com OR site:discord.gg OR site:cdn.discordapp.com"
    if ($keyword) { $query += " `"$keyword`"" }
    if ($hashQuery) { $query += " OR $hashQuery" }

    $dork = [System.Web.HttpUtility]::UrlEncode($query)
    Open-SearchUrl "https://www.google.com/search?q=$dork"
}

function Search-Yandex {
    if ($global:CurrentBitmap) {
        try { [System.Windows.Clipboard]::SetImage($global:CurrentBitmap) } catch {}
    }
    if ($global:CurrentPublicUrl) {
        $encoded = [System.Web.HttpUtility]::UrlEncode($global:CurrentPublicUrl)
        Open-SearchUrl "https://yandex.com/images/search?rpt=imageview&url=$encoded"
    } else {
        Open-SearchUrl "https://yandex.com/images/"
    }
}

function Search-Bing {
    if ($global:CurrentBitmap) {
        try { [System.Windows.Clipboard]::SetImage($global:CurrentBitmap) } catch {}
    }
    if ($global:CurrentPublicUrl) {
        $encoded = [System.Web.HttpUtility]::UrlEncode($global:CurrentPublicUrl)
        Open-SearchUrl "https://www.bing.com/images/search?view=detailv2&iss=sbi&imgurl=$encoded"
    } else {
        Open-SearchUrl "https://www.bing.com/visualsearch"
    }
}

function Search-TinEye {
    if ($global:CurrentPublicUrl) {
        $encoded = [System.Web.HttpUtility]::UrlEncode($global:CurrentPublicUrl)
        Open-SearchUrl "https://tineye.com/search?url=$encoded"
    } else {
        Open-SearchUrl "https://tineye.com/"
    }
}

function Search-FaceCheck {
    if ($global:CurrentBitmap) {
        try { [System.Windows.Clipboard]::SetImage($global:CurrentBitmap) } catch {}
    }
    # FaceCheck.id is the premier AI facial recognition OSINT site for social media
    Open-SearchUrl "https://facecheck.id/"
}

# Attach Individual Buttons
$btnSearchGoogle.Add_Click({ Search-GoogleLens })
$btnSearchInstagram.Add_Click({ Search-Instagram })
$btnSearchFacebook.Add_Click({ Search-Facebook })
$btnSearchDiscord.Add_Click({ Search-Discord })
$btnSearchYandex.Add_Click({ Search-Yandex })
$btnSearchBing.Add_Click({ Search-Bing })
$btnSearchTinEye.Add_Click({ Search-TinEye })
$btnSearchFaceCheck.Add_Click({ Search-FaceCheck })

# Keyword Dork Button
$btnQuickDork.Add_Click({
    $keyword = $txtKeywordFilter.Text.Trim()
    if (-not $keyword -or $keyword -eq "เช่น ชื่อคน, username, สถานที่ หรือข้อความในรูป") {
        [System.Windows.MessageBox]::Show("กรุณากรอกคำสำคัญ เช่น ชื่อคน หรือ username ก่อนค้นหา", "คำสำคัญว่างเปล่า", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
        return
    }
    $dork = [System.Web.HttpUtility]::UrlEncode("(site:instagram.com OR site:facebook.com OR site:discord.com) `"$keyword`"")
    Open-SearchUrl "https://www.google.com/search?q=$dork"
})

# Master One-Click Search All Button
$btnSearchAll.Add_Click({
    if (-not $global:CurrentFilePath -and -not $global:CurrentBitmap) {
        [System.Windows.MessageBox]::Show("กรุณาลากหรือเลือกรูปภาพก่อนเริ่มค้นหา", "ยังไม่มีรูปภาพ", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
        return
    }

    # If in cloud mode and not yet uploaded, upload now
    if ($rbCloudMode.IsChecked -and -not $global:CurrentPublicUrl -and $global:CurrentFilePath) {
        $url = Upload-ImageToHost $global:CurrentFilePath
        if ($url) {
            $global:CurrentPublicUrl = $url
            $txtPublicUrl.Text = $url
        }
    }

    # Always ensure image is in clipboard
    if ($global:CurrentBitmap) {
        try { [System.Windows.Clipboard]::SetImage($global:CurrentBitmap) } catch {}
    }

    $count = 0
    if ($chkGoogle.IsChecked) { Search-GoogleLens; $count++ }
    if ($chkYandex.IsChecked) { Start-Sleep -Milliseconds 250; Search-Yandex; $count++ }
    if ($chkBing.IsChecked) { Start-Sleep -Milliseconds 250; Search-Bing; $count++ }
    if ($chkInstagram.IsChecked) { Start-Sleep -Milliseconds 250; Search-Instagram; $count++ }
    if ($chkFacebook.IsChecked) { Start-Sleep -Milliseconds 250; Search-Facebook; $count++ }
    if ($chkDiscord.IsChecked) { Start-Sleep -Milliseconds 250; Search-Discord; $count++ }
    if ($chkTinEye.IsChecked) { Start-Sleep -Milliseconds 250; Search-TinEye; $count++ }
    if ($chkFaceCheck.IsChecked) { Start-Sleep -Milliseconds 250; Search-FaceCheck; $count++ }

    Set-AppStatus "เปิดแท็บค้นหา $count แพลตฟอร์มเรียบร้อยแล้ว! (และคัดลอกภาพลงคลิปบอร์ดให้พร้อมวาง)" "#10B981"
})

# Clear placeholder text on focus
$txtKeywordFilter.Add_GotFocus({
    if ($txtKeywordFilter.Text -eq "เช่น ชื่อคน, username, สถานที่ หรือข้อความในรูป") {
        $txtKeywordFilter.Text = ""
        $txtKeywordFilter.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#FFFFFF")
    }
})

# Show the GUI Window
$window.ShowDialog() | Out-Null
