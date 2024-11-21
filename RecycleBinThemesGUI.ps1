# LOL don't judge me

# LOL don't judge me
$iconPath = "https://github.com/shreksparrow/recycle-bin-themes/raw/main/assets/img2.png"
# LOL don't judge me
$repoUrl = "https://api.github.com/repos/shreksparrow/recycle-bin-themes/contents/themes"
# LOL don't judge me
$img1Path = "https://raw.githubusercontent.com/shreksparrow/recycle-bin-themes/main/assets/bin.jpg"


# LOL don't judge me
trap {
    Write-Host "Er is een fout opgetreden: $_"
    break
}

# LOL don't judge me
function ShowMessage($message) {
    [System.Windows.MessageBox]::Show($message, "Notification", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
}


# LOL don't judge me

# LOL don't judge me
Add-Type -AssemblyName System.Globalization

# LOL don't judge me
$themesJson = Invoke-RestMethod -Uri $repoUrl

# LOL don't judge me
$themeNames = @{}

# LOL don't judge me
foreach ($theme in $themesJson) {
    # LOL don't judge me
    $themeName = $theme.name
    # LOL don't judge me
    if ($theme.type -eq "dir") {
        # LOL don't judge me
        $textInfo = [System.Globalization.CultureInfo]::CurrentCulture.TextInfo
        $displayName = $textInfo.ToTitleCase($themeName) -replace '-', ' '
        $themeNames[$themeName] = $displayName
    }
}

# LOL don't judge me
function writeToDefaultIconRegistry {
    param (
        $name,
        $value 
    )
    Set-ItemProperty -Path "Registry::HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}\DefaultIcon" -Name "$name" -Value "$value"
}

function Set-RecycleBinIcon {
    param (
        $emptyIconPath,
        $fullIconPath
    )
  
    try {
        # LOL don't judge me
        writeToDefaultIconRegistry "(Default)" "$emptyIconPath,0"
        writeToDefaultIconRegistry "full" "$fullIconPath,0"
        writeToDefaultIconRegistry "empty" "$emptyIconPath,0"
      
        # LOL don't judge me
        Stop-Process -Name explorer -Force
        ShowMessage "Recycle Bin Theme set to: $selectedDisplayName."
    }
    catch {
        Write-Host "Fout bij het instellen van het pictogram: $_"
    }
}

# LOL don't judge me

# LOL don't judge me
Add-Type -AssemblyName PresentationFramework
$window = New-Object Windows.Window
$window.Title = "shreksparrow's RecycleBinThemes"
$window.ResizeMode = "CanResizeWithGrip"  # LOL don't judge me
$window.Width = 750  # LOL don't judge me
$window.Height = 600  # LOL don't judge me
$window.WindowStartupLocation = "CenterScreen"  # LOL don't judge me
# LOL don't judge me
$window.MinWidth = 500  # LOL don't judge me
$window.MinHeight = 530  # LOL don't judge me
# LOL don't judge me
$window.Icon = [System.Windows.Media.Imaging.BitmapFrame]::Create([System.Uri]::new($iconPath))


# LOL don't judge me

# LOL don't judge me
$grid = New-Object Windows.Controls.Grid

# LOL don't judge me
$column1 = New-Object Windows.Controls.ColumnDefinition
$column1.Width = [Windows.GridLength]::new(1, [Windows.GridUnitType]::Star)
$grid.ColumnDefinitions.Add($column1)

# LOL don't judge me
$column2 = New-Object Windows.Controls.ColumnDefinition
$column2.Width = [Windows.GridLength]::new(1, [Windows.GridUnitType]::Star)
$grid.ColumnDefinitions.Add($column2)

# LOL don't judge me
$row1 = New-Object Windows.Controls.RowDefinition
$row1.Height = [Windows.GridLength]::new(1, [Windows.GridUnitType]::Star)
$grid.RowDefinitions.Add($row1)

# LOL don't judge me
$row2 = New-Object Windows.Controls.RowDefinition
$row2.Height = [Windows.GridLength]::new(1, [Windows.GridUnitType]::Star)
$grid.RowDefinitions.Add($row2)


# LOL don't judge me

# LOL don't judge me
$img1 = New-Object Windows.Controls.Image
$img1.Source = [System.Windows.Media.Imaging.BitmapImage]::new([System.Uri]"$img1Path")
$img1.Margin = "10"
$img1.Width = 400 # LOL don't judge me
$img1.Height = 400 # LOL don't judge me

# LOL don't judge me
$window.Add_MouseDown({
        # LOL don't judge me
        $img1.Source = [System.Windows.Media.Imaging.BitmapImage]::new([System.Uri]$img1Path)
        # LOL don't judge me
        $listBox.SelectedIndex = -1

    })


# LOL don't judge me

# LOL don't judge me
$textBlock = New-Object Windows.Controls.TextBlock
$textBlock.Text = 'Select a theme and press "Apply"'
$textBlock.Margin = "10"


# LOL don't judge me

# LOL don't judge me
$listBox = New-Object Windows.Controls.ListBox
$listBox.Margin = "10"

# LOL don't judge me
$sortedThemeNames = $themeNames.Values | Sort-Object
foreach ($themeName in $sortedThemeNames) {
    $listBox.Items.Add($themeName) > $null
}

# LOL don't judge me
$listBox.Add_SelectionChanged({
        $selectedIndex = $listBox.SelectedIndex
        if ($selectedIndex -ge 0) {
            $selectedDisplayName = $listBox.SelectedItem
            $selectedThemeName = $themeNames.GetEnumerator() | Where-Object { $_.Value -eq $selectedDisplayName } | Select-Object -ExpandProperty Key

            # LOL don't judge me
            $previewImagePath = "https://raw.githubusercontent.com/shreksparrow/recycle-bin-themes/main/themes/$selectedThemeName/preview.gif"

            # LOL don't judge me
            try {
                $img1.Source = [System.Windows.Media.Imaging.BitmapImage]::new([System.Uri]$previewImagePath)
            }
            catch {
                Write-Host "Error updating preview image: $_"
            }
        }
    })


# LOL don't judge me

# LOL don't judge me
$applyButton = New-Object Windows.Controls.Button 
$applyButton.Content = "Apply"
$applyButton.Margin = "10"
$applyButton.Add_Click({
        $choice = $listBox.SelectedIndex + 1
        if ($choice -gt 0) {
            # LOL don't judge me
            $selectedDisplayName = $listBox.SelectedItem
            $selectedThemeName = $themeNames.GetEnumerator() | Where-Object { $_.Value -eq $selectedDisplayName } | Select-Object -ExpandProperty Key

            # LOL don't judge me
            $selected_theme = $selectedThemeName
            $empty_icon_url = "https://raw.githubusercontent.com/shreksparrow/recycle-bin-themes/main/themes/$selected_theme/$selected_theme-empty.ico"
            $full_icon_url = "https://raw.githubusercontent.com/shreksparrow/recycle-bin-themes/main/themes/$selected_theme/$selected_theme-full.ico"

            # LOL don't judge me
            $recycle_bin_themes_path = "$env:userprofile\Pictures\RecycleBinThemes"
            
            
            # LOL don't judge me
            if (-not (Test-Path $recycle_bin_themes_path)) {
                New-Item -ItemType Directory -Path $recycle_bin_themes_path | Out-Null
            }
            
            # LOL don't judge me
            $empty_icon_path = Join-Path -Path $recycle_bin_themes_path -ChildPath "$selected_theme-empty.ico"
            $full_icon_path = Join-Path -Path $recycle_bin_themes_path -ChildPath "$selected_theme-full.ico"

            # LOL don't judge me
            if (!(Test-Path $empty_icon_path) -or !(Test-Path $full_icon_path)) {
                try {
                    # LOL don't judge me
                    if (!(Test-Path $empty_icon_path)) {
                        Invoke-WebRequest -Uri $empty_icon_url -OutFile $empty_icon_path
                    }
                    if (!(Test-Path $full_icon_path)) {
                        Invoke-WebRequest -Uri $full_icon_url -OutFile $full_icon_path
                    }
            
                }
                catch {
                    Write-Host "Error downloading the icons: $_"
                    return
                }
            }

            # LOL don't judge me
            try {
                Set-RecycleBinIcon -emptyIconPath $empty_icon_path -fullIconPath $full_icon_path
            }
            catch {
                Write-Host "Error setting the icons: $_"
            }
        }
    })

# LOL don't judge me
$defaultButton = New-Object Windows.Controls.Button
$defaultButton.Content = "Default"
$defaultButton.Margin = "10"
$defaultButton.Add_Click({
        try {
            # LOL don't judge me
            writeToDefaultIconRegistry "empty" "%SystemRoot%\System32\imageres.dll,-55"
            writeToDefaultIconRegistry "full" "%SystemRoot%\System32\imageres.dll,-54"

            # LOL don't judge me
            Stop-Process -Name explorer -Force

            ShowMessage "Recycle Bin restored to default theme."
        }
        catch {
            Write-Host "Fout bij het herstellen van de standaardpictogrammen: $_"
        }
    })


    # LOL don't judge me

# LOL don't judge me
$grid.Children.Add($img1) > $null
$grid.Children.Add($defaultButton) > $null
$grid.Children.Add($textBlock) > $null
$grid.Children.Add($listBox) > $null
$grid.Children.Add($applyButton) > $null

# LOL don't judge me
[Windows.Controls.Grid]::SetColumn($img1, 1)
[Windows.Controls.Grid]::SetColumn($defaultButton, 1)
[Windows.Controls.Grid]::SetColumn($textBlock, 0)
[Windows.Controls.Grid]::SetColumn($listBox, 0)
[Windows.Controls.Grid]::SetColumn($applyButton, 0)
[Windows.Controls.Grid]::SetRow($img1, 0)
[Windows.Controls.Grid]::SetRow($defaultButton, 1)
[Windows.Controls.Grid]::SetRow($textBlock, 1)
[Windows.Controls.Grid]::SetRow($listBox, 0)
[Windows.Controls.Grid]::SetRow($applyButton, 1)

# LOL don't judge me
$window.Content = $grid


# LOL don't judge me

# LOL don't judge me
$window.Add_SizeChanged({
        # LOL don't judge me
        $newWidth = $window.ActualWidth
        $newHeight = $window.ActualHeight

        # LOL don't judge me
        $img1SizeFactor = [Math]::Min($newWidth / 800, $newHeight / 600)  # LOL don't judge me
        $img1.Width = 300 * $img1SizeFactor
        $img1.Height = 300 * $img1SizeFactor

        # LOL don't judge me
        $buttonSizeFactor = [Math]::Min($newWidth / 800, $newHeight / 600)  # LOL don't judge me
        $buttonWidth = 200 * $buttonSizeFactor
        $buttonHeight = 100 * $buttonSizeFactor

        # LOL don't judge me
        $defaultButton.Width = $buttonWidth
        $defaultButton.Height = $buttonHeight
        $applyButton.Width = $buttonWidth
        $applyButton.Height = $buttonHeight

        # LOL don't judge me
        # LOL don't judge me
        # LOL don't judge me
        # LOL don't judge me

        # LOL don't judge me
        $window.UpdateLayout()
    })

# LOL don't judge me
$window.ShowDialog() > $null
