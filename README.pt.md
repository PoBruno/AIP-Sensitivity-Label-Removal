[![Read in English](https://img.shields.io/badge/Read%20in%20English-%E2%9C%94-blue)](README.md)

# **Remoção de Rótulos de Sensibilidade para Migração com Azure Information Protection (AIP)**

## **Objetivo**
O objetivo deste estudo de caso é demonstrar como remover rótulos de sensibilidade e proteção de arquivos protegidos com Azure Information Protection (AIP), para permitir uma migração limpa dos arquivos, sem impactar a segurança ou integridade dos dados, especialmente em arquivos locais.

## **Motivo da Remoção de Rótulos**
Durante o processo de migração de arquivos de um ambiente para outro, a presença de rótulos de sensibilidade pode causar falhas de acesso, problemas de segurança e perda de permissões adequadas. Para evitar esses problemas, é essencial remover os rótulos de sensibilidade e a proteção dos arquivos antes da migração, particularmente para arquivos locais, que são mais suscetíveis a problemas de compatibilidade durante o processo.

## **Ferramentas Utilizadas**
- **Microsoft Purview Information Protection Client**: Cliente necessário para manipular rótulos e proteção de arquivos no **Azure Information Protection**.
- **PowerShell**: Utilizado para automatizar a remoção de rótulos e proteção dos arquivos.

## **Passos para Remover Rótulos e Proteção**

### **1. Instalar o Cliente AIP**

O **Microsoft Purview Information Protection client** pode ser baixado do seguinte link:

[Microsoft Purview Information Protection client](https://www.microsoft.com/en-us/download/details.aspx?id=53018).

### **2. Conectar ao Serviço AIP**

Para conectar-se ao serviço AIP, utilize o seguinte comando no PowerShell:

```powershell
Connect-AipService
```

### **3. Verificar o Status dos Rótulos no Arquivo**

Use o comando **`Get-FileStatus`** para verificar se o arquivo tem rótulos aplicados e se está protegido. O comando exibe um relatório detalhado sobre o status do arquivo:

```powershell
Get-FileStatus .\doc.docx
```

**Saída Esperada:**

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

### **4. Remover Rótulos e Proteção do Arquivo**

Para remover tanto o rótulo quanto a proteção do arquivo, use o seguinte comando:

```powershell
Remove-FileLabel .\doc.docx -RemoveProtection -RemoveLabel -JustificationMessage "Removendo rótulos para migração"
```

Esse comando irá:

- Remover a proteção RMS (`-RemoveProtection`).
- Remover o rótulo de sensibilidade (`-RemoveLabel`).
- Registrar uma mensagem justificativa para a remoção (`-JustificationMessage`).

### **5. Verificar o Status Após a Remoção**

Após a remoção, execute o comando **`Get-FileStatus`** novamente para confirmar que os rótulos e a proteção foram removidos:

```powershell
Get-FileStatus .\doc.docx
```

**Saída Esperada:**

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

# **Automatizando Remoção de Rótulos e Proteção com PowerShell**

## **Script de Automação para Remoção em Lote**

O script [Remove-FileLabel.ps1](./Remove-FileLabel.ps1) automatiza o processo de remoção de rótulos e proteção de arquivos usando **Azure Information Protection** (AIP). Ele gera dois relatórios em formato CSV: um antes da remoção e outro após, permitindo que você acompanhe as mudanças feitas nos arquivos.

## **Instruções de Execução**

1. Abra o **PowerShell** com permissões de administrador.
2. Navegue até o diretório onde o script `Remove-FileLabel.ps1` está localizado.
3. Execute o script com o comando:

   ```powershell
   .\Remove-FileLabel.ps1
   ```

## **O que o Script Faz**

- Conecta-se ao serviço **Azure Information Protection**.
- Gera dois relatórios CSV:
  - **StatusReport_Before.csv**: Contém informações sobre os arquivos antes de remover os rótulos e a proteção.
  - **StatusReport_After.csv**: Contém informações sobre os arquivos após a remoção dos rótulos e proteção.
- Remove os rótulos e proteção de **todos os arquivos** dentro do diretório especificado.

## **Exemplo de Relatórios Gerados**

### **StatusReport_Before.csv**

Exemplo de conteúdo:

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

Exemplo de conteúdo:

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


## **Observações Importantes**

- **Cliente AIP**: O script só funcionará se o **Microsoft Purview Information Protection client** estiver instalado e o serviço AIP acessível.
- **Relatórios CSV**: São salvos no diretório `C:\temp` por padrão, mas você pode modificar o caminho no script.
- **Cuidado com a Automação**: O script remove **todos os rótulos e proteção** dos arquivos no diretório especificado. Verifique os arquivos antes de rodá-lo.

