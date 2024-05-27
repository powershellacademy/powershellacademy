Add-Type -AssemblyName System.Windows.Forms

# Create Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Server System Information"
$form.Size = New-Object System.Drawing.Size(800, 600)
$form.StartPosition = "CenterScreen"

# Create Label for Server Input
$lblServers = New-Object System.Windows.Forms.Label
$lblServers.Location = New-Object System.Drawing.Point(20, 20)
$lblServers.Size = New-Object System.Drawing.Size(100, 20)
$lblServers.Text = "Enter Servers:"
$form.Controls.Add($lblServers)

# Create TextBox for Server Input
$txtServers = New-Object System.Windows.Forms.TextBox
$txtServers.Location = New-Object System.Drawing.Point(120, 20)
$txtServers.Size = New-Object System.Drawing.Size(600, 20)
$form.Controls.Add($txtServers)

# Create Button for Checking System Information
$btnCheck = New-Object System.Windows.Forms.Button
$btnCheck.Location = New-Object System.Drawing.Point(20, 50)
$btnCheck.Size = New-Object System.Drawing.Size(100, 30)
$btnCheck.Text = "Check Info"
$btnCheck.Add_Click({
    # Retrieve server names from TextBox
    $servers = $txtServers.Text.Split(',')

    # Prepare data to display in DataGridView
    $data = foreach ($server in $servers) {
        try {
            $info = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $server -ErrorAction Stop
            [PSCustomObject]@{
                ServerName = $server
                OS = $info.Caption
                Version = $info.Version
                Architecture = $info.OSArchitecture
            }
        } catch {
            Write-Host "Failed to get information from $server"
        }
    }

    # Clear existing rows from DataGridView
    $datagrid.Rows.Clear()

    # Display data in DataGridView
    $data | ForEach-Object {
        $datagrid.Rows.Add($_.ServerName, $_.OS, $_.Version, $_.Architecture)
    }
})
$form.Controls.Add($btnCheck)

# Create DataGridView
$datagrid = New-Object System.Windows.Forms.DataGridView
$datagrid.Location = New-Object System.Drawing.Point(20, 100)
$datagrid.Size = New-Object System.Drawing.Size(750, 450)
$datagrid.AutoSizeColumnsMode = "Fill"
$datagrid.ColumnCount = 4
$datagrid.Columns[0].Name = "Server Name"
$datagrid.Columns[1].Name = "OS"
$datagrid.Columns[2].Name = "Version"
$datagrid.Columns[3].Name = "Architecture"
$form.Controls.Add($datagrid)

# Show the Form
$form.ShowDialog() | Out-Null
