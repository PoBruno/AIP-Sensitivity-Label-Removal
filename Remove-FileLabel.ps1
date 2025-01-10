
# Define the folder path and report path
$folderPath = "C:\repo\protect\lab"
$reportPath = "C:\temp"
$justificationMessage = "Removing labels and protection for migration"

# Try to connect to the AIP service
try {
    Connect-Aipservice
    Write-Host "Connected to Azure Information Protection service."
} catch {
    Write-Host "Failed to connect to Azure Information Protection service."
    Write-Host "Please download and install the AIP client from the following link: https://www.microsoft.com/en-us/download/details.aspx?id=53018"
    return  # Exit the script if the connection fails
}

# Function to get the file status and export it to CSV
function Get-FileStatusReport {
    param (
        [string]$folderPath,    # The folder path to check the files
        [string]$reportPath,    # The path to save the CSV report
        [string]$reportName     # The name of the report file
    )

    # Get the file status for the folder and subfolders
    $fileStatusReport = Get-FileStatus $folderPath

    # Create a table from the file status report and select all properties
    $fileStatusReportTable = $fileStatusReport | Select-Object FileName, IsLabeled, MainLabelId, MainLabelName, SubLabelName, LabelingMethod, IsRMSProtected, RMSTemplateName

    # Export the file status report to a CSV file
    $fileStatusReportTable | Export-Csv -Path ($reportPath + "\" + $reportName) -NoTypeInformation -Force
}

# Function to remove file labels and protection
function Remove-FileLabelsAndProtection {
    param (
        [string]$folderPath,             # The folder path to remove labels and protection
        [string]$justificationMessage    # The justification message for removing labels and protection
    )

    # Remove file labels and protection for migration with a justification message
    Remove-FileLabel $folderPath -RemoveLabel -JustificationMessage $justificationMessage
}

# Get and export the file status before any changes
Get-FileStatusReport -folderPath $folderPath -reportPath $reportPath -reportName "StatusReport_Before.csv"

# Get all the files in the folder and its subfolders
$files = Get-ChildItem -Path $folderPath -Recurse -File

# Remove labels and protection from the files
Remove-FileLabelsAndProtection -folderPath $folderPath -justificationMessage $justificationMessage

# Get and export the file status after labels and protection are removed
Get-FileStatusReport -folderPath $folderPath -reportPath $reportPath -reportName "StatusReport_After.csv"

