#Requires -Version 7.0
<#
.SYNOPSIS
    Creates the context-extractor workspace directory tree.
.DESCRIPTION
    Recommended: point -BasePath INSIDE your Obsidian vault (e.g. a "Контекст"
    subfolder). Then the accumulated functional folders are part of your knowledge
    base, the agent sees the whole history for Scenario A (updating existing files),
    and moving results from _review/ is a copy within the same vault.
.PARAMETER BasePath
    Target path for the workspace. Default: ~/work/context-extractor
    Recommended for Obsidian users: "<your-vault>/Контекст"
.EXAMPLE
    .\bin\create-workspace.ps1
    .\bin\create-workspace.ps1 -BasePath "C:\Users\<you>\ObsidianVault\Контекст"
#>
param(
    [string]$BasePath = (Join-Path $env:USERPROFILE "work\context-extractor")
)

$folders = @(
    "_inbox",
    "_review",
    "01_Франшиза",
    "02_Розничные продажи",
    "03_Корпоративные продажи",
    "04_Маркетинг",
    "05_Медицинское оборудование",
    "06_Медицинский отдел",
    "07_Собственные медицинские офисы",
    "08_ИТ",
    "09_Колл-центр",
    "10_Транспортная логистика",
    "11_Логистика расходного материала",
    "12_Юриспруденция и право",
    "13_Лаборатория и преаналитика",
    "14_Кадры и персонал",
    "15_Финансы и бухгалтерия",
    "16_Стандарты и контроль",
    "17_Регионы и филиалы",
    "18_Служба безопасности",
    "19_Помещения"
)

Write-Host "Creating workspace at: $BasePath" -ForegroundColor Cyan

foreach ($folder in $folders) {
    $path = Join-Path $BasePath $folder
    New-Item -ItemType Directory -Force -Path $path | Out-Null
    Write-Host "  [OK] $folder" -ForegroundColor Green
}

# Create .claude/settings.json for Claude Code permissions
$claudeDir = Join-Path $BasePath ".claude"
New-Item -ItemType Directory -Force -Path $claudeDir | Out-Null

$settingsPath = Join-Path $claudeDir "settings.json"
if (-not (Test-Path $settingsPath)) {
    $settingsContent = @'
{
  "_setup_notes": "ATTENTION: Replace the Obsidian path in deny rules with Sergey's actual vault path during installation.",
  "permissions": {
    "defaultMode": "plan",
    "allow": [
      "Read(~/work/context-extractor/**)",
      "Write(~/work/context-extractor/_review/**)",
      "Edit(~/work/context-extractor/glossary.md)",
      "Edit(~/work/context-extractor/_review/**)",
      "Glob(~/work/context-extractor/**)",
      "Grep(~/work/context-extractor/**)"
    ],
    "deny": [
      "Write(~/Documents/Obsidian/**)",
      "Edit(~/Documents/Obsidian/**)"
    ]
  }
}
'@
    [System.IO.File]::WriteAllText($settingsPath, $settingsContent, [System.Text.Encoding]::UTF8)
    Write-Host "  [OK] .claude/settings.json" -ForegroundColor Green
}

# Create starter glossary.md if not exists
$glossaryPath = Join-Path $BasePath "glossary.md"
if (-not (Test-Path $glossaryPath)) {
    $glossaryContent = @"
# Словарь канонических имён

Формат каждой строки: ``* **Каноничное Имя**: синоним1, синоним2``

- **Каноничное Имя** — официальное название сущности в именительном падеже
- **Синонимы** — все варианты написания из транскриптов, через запятую

---

"@
    [System.IO.File]::WriteAllText($glossaryPath, $glossaryContent, [System.Text.Encoding]::UTF8)
    Write-Host "  [OK] glossary.md (starter template)" -ForegroundColor Green
}

Write-Host ""
Write-Host "Done! Workspace ready at: $BasePath" -ForegroundColor Cyan
Write-Host "Open Claude Code in that folder to start processing transcripts."
