[![Leia em Português](https://img.shields.io/badge/Leia%20em%20Portugu%C3%AA-%E2%9C%94-red)](README.pt.md)


# **Removal of Sensitivity Labels for Migration with Azure Information Protection (AIP)**

## **Objective**
The purpose of this case study is to demonstrate how to remove sensitivity labels and protection from files protected with Azure Information Protection (AIP), enabling a clean migration of files without impacting data security or integrity, especially for local files.

## **Reason for Removing Labels**
During the process of migrating files from one environment to another, the presence of sensitivity labels can cause access failures, security issues, and loss of proper permissions. To avoid these problems, it is essential to remove sensitivity labels and file protection before migration, particularly for local files that are more prone to compatibility issues during the process.

## **Tools Used**
- **Microsoft Purview Information Protection Client**: Client required to manage labels and protection on files in **Azure Information Protection**.
- **PowerShell**: Used to automate the removal of labels and protection from files.

## **Steps to Remove Labels and Protection**

### **1. Install the AIP Client**

The **Microsoft Purview Information Protection client** can be downloaded from the following link:

[Microsoft Purview Information Protection client](https://www.microsoft.com/en-us/download/details.aspx?id=53018).

### **2. Connect to the AIP Service**

To connect to the AIP service, use the following command in PowerShell:

```powershell
Connect-AipService
```

### **3. Check the Label Status on the File**

Use the **`Get-FileStatus`** command to check if the file has labels applied and if it is protected. This command will return a detailed report about the file's status:

```powershell
Get-FileStatus .\doc.docx
```

**Expected Output:**

```plaintext
FileName          : C:\repo\doc.docx
IsLabeled         : True
MainLabelId       : defa4170-0d19-0005-0005-bc88714345d2
MainLabelName     : Confidential
SubLabelId        : defa4170-0d19-0005-0007-bc88714345d2
SubLabelName      : All Employees
LabelingMethod    : Privileged
LabelDate         : 1/9/2025 2:02:22 PM
IsRMSProtected    : True
RMSTemplateId     : 6a3e3de3-086b-44a8-b8aa-2e1ceb1e035f
RMSTemplateName   : Confidential - All Employees
RMSOwner          : admin@monga.dev.br
IssuedTo          : admin@monga.dev.br
ContentId         : 4126380d-8200-426f-8aa9-1a04cf89f4e0
```

### **4. Remove Labels and Protection from the File**

To remove both the label and the protection from the file, use the following command:

```powershell
Remove-FileLabel .\doc.docx -RemoveProtection -RemoveLabel -JustificationMessage "Removing labels for migration"
```

This command will:

- Remove RMS protection (`-RemoveProtection`).
- Remove the sensitivity label (`-RemoveLabel`).
- Log a justification message for the removal (`-JustificationMessage`).

### **5. Verify the Status After Removal**

After removal, run the **`Get-FileStatus`** command again to confirm that the labels and protection have been removed:

```powershell
Get-FileStatus .\doc.docx
```

**Expected Output:**

```plaintext
FileName          : C:\repo\doc.docx
IsLabeled         : False
MainLabelId       :
MainLabelName     :
SubLabelId        :
SubLabelName      :
LabelingMethod    :
LabelDate         :
IsRMSProtected    : False
RMSTemplateId     :
RMSTemplateName   :
RMSOwner          :
IssuedTo          :
ContentId         :
```

# **Automating the Removal of Labels and Protection with PowerShell**

## **Batch Removal Automation Script**

The script [Remove-FileLabel.ps1](./Remove-FileLabel.ps1) automates the process of removing labels and protection from files using **Azure Information Protection** (AIP). It generates two CSV reports: one before removal and one after, allowing you to track the changes made to the files.

## **Execution Instructions**

1. Open **PowerShell** with administrator privileges.
2. Navigate to the directory where the `Remove-FileLabel.ps1` script is located.
3. Run the script with the following command:

   ```powershell
   .\Remove-FileLabel.ps1
   ```

## **What the Script Does**

- Connects to the **Azure Information Protection** service.
- Generates two CSV reports:
  - **StatusReport_Before.csv**: Contains information about the files before the labels and protection are removed.
  - **StatusReport_After.csv**: Contains information about the files after the labels and protection are removed.
- Removes the labels and protection from **all files** in the specified directory.

## **Example of Generated Reports**

### **StatusReport_Before.csv**

Example contents:

| FileName                                      | IsLabeled | MainLabelId       | MainLabelName | SubLabelName | LabelingMethod | IsRMSProtected | RMSTemplateName        |
|-----------------------------------------------|-----------|-------------------|---------------|--------------|----------------|----------------|------------------------|
| C:\repo\protect\lab\as\asa\asa02.docx         | True      | fas70-0005-bc872  | Confidential  | All Employees| Privileged     | True           | Confidential - All Employees |
| C:\repo\protect\lab\dc\dc03.docx              | True      | fas70-0005-bc872  | Confidential  | All Employees| Privileged     | True           | Confidential - All Employees |
| C:\repo\protect\lab\as\asb\asb01.docx         | True      | fas70-0005-bc872  | Confidential  | All Employees| Privileged     | True           | Confidential - All Employees |
| C:\repo\protect\lab\dc\dc02.docx              | True      | fas70-0005-bc872  | Confidential  | All Employees| Privileged     | True           | Confidential - All Employees |
| C:\repo\protect\lab\as\asb\asb03.docx         | True      | fas70-0005-bc872  | Confidential  | All Employees| Privileged     | True           | Confidential - All Employees |
| C:\repo\protect\lab\dc\dcb\dcb01.docx         | True      | fas70-0005-bc872  | Confidential  | All Employees| Privileged     | True           | Confidential - All Employees |
| C:\repo\protect\lab\ab\ab01.docx              | True      | fas70-0005-bc872  | Confidential  | All Employees| Privileged     | True           | Confidential - All Employees |
| C:\repo\protect\lab\as\asa\asa01.docx         | True      | fas70-0005-bc872  | Confidential  | All Employees| Privileged     | True           | Confidential - All Employees |

### **StatusReport_After.csv**

Example contents:

| FileName                                      | IsLabeled | MainLabelId | MainLabelName | SubLabelName | IsRMSProtected | RMSTemplateName |
|-----------------------------------------------|-----------|-------------|---------------|--------------|----------------|-----------------|
| C:\repo\protect\lab\ab\ab01.docx              | False     |             |               |              | False          |                 |
| C:\repo\protect\lab\dc\dc01.docx              | False     |             |               |              | False          |                 |
| C:\repo\protect\lab\as\asa\asa01.docx         | False     |             |               |              | False          |                 |
| C:\repo\protect\lab\dc\dc02.docx              | False     |             |               |              | False          |                 |
| C:\repo\protect\lab\as\asb\asb02.docx         | False     |             |               |              | False          |                 |
| C:\repo\protect\lab\as\asa\asa02.docx         | False     |             |               |              | False          |                 |
| C:\repo\protect\lab\dc\dc03.docx              | False     |             |               |              | False          |                 |
| C:\repo\protect\lab\dc\dcb\dcb01.docx         | False     |             |               |              | False          |                 |

## **Important Notes**

- **AIP Client**: The script will only work if the **Microsoft Purview Information Protection client** is installed and the AIP service is accessible.
- **CSV Reports**: These reports are saved in the `C:\temp` directory by default, but you can modify the path in the script.
- **Automation Caution**: The script removes **all labels and protection** from the files in the specified directory. Make sure to verify the files before running the script.

