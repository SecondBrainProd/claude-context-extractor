# context-extractor

Плагин Claude Code для извлечения As-Is бизнес-контекста из транскриптов совещаний.

Положи транскрипт в `_inbox/` рабочей папки — плагин извлечёт процессы, роли, системы, правила, проблемы, решения, термины и открытые вопросы, задаст один пакет уточняющих вопросов, покажет план в Plan Mode и после твоего «ОК» запишет файлы в `_review/` (не в основную базу). Глоссарий ведётся отдельным sub-agent'ом, который точечно правит `glossary.md` и ловит дубли с нормализацией регистра.

## Установка

В Claude Code:

```
/plugin marketplace add SecondBrainProd/claude-context-extractor
/plugin install context-extractor@claude-context-extractor
```

Перезапусти Claude Code (`/exit`, потом `claude`). Проверь, что субагенты появились:

```
/agents
```

Должны быть `context-extractor` и `glossary-steward`.

## Создание рабочей папки

На Windows из папки плагина (или указав свой путь):

```powershell
.\bin\create-workspace.ps1                                       # дефолтный путь: ~\work\context-extractor
.\bin\create-workspace.ps1 -BasePath "C:\my-path\context"        # свой путь
```

Скрипт создаст:
- `_inbox/` — куда класть транскрипты
- `_review/` — куда плагин пишет промежуточный результат
- `glossary.md` — пустая заготовка словаря канонических имён
- 19 функциональных папок (`01_Франшиза`, `02_Розничные продажи`, …, `19_Помещения`)
- `.claude/settings.json` — permission-правила (`defaultMode: plan` + deny на основной Obsidian-vault)

После запуска скрипта открой `.claude\settings.json` в созданной папке и в секции `deny` замени плейсхолдер `~/Documents/Obsidian/**` на реальный путь к своему Obsidian-vault — это защитит vault от случайной записи.

Если 19 функциональных папок не подходят — отредактируй массив `$folders` в `bin/create-workspace.ps1` и `skills/transcript-router/SKILL.md` (там тот же список + правила маршрутизации).

## Повседневный сценарий

1. Положи транскрипт в `_inbox/` (`.md` или `.txt`).
2. Открой терминал в рабочей папке:
   ```
   cd ~/work/context-extractor
   claude
   ```
3. Запусти команду:
   ```
   /context-extractor:process-transcript
   ```
4. Ответь на пакет уточняющих вопросов.
5. Проверь план в Plan Mode → `approve`.
6. Файлы появятся в `_review/`, словарь обновится через `glossary-steward`.
7. Перенеси проверенные файлы из `_review/` в основной Obsidian-vault руками.

## Структура плагина

- `agents/context-extractor.md` — извлекает 8 категорий из транскрипта, формирует пакет вопросов, готовит план.
- `agents/glossary-steward.md` — точечно правит `glossary.md`, ловит дубли через нормализацию (case-insensitive, дефисы/пробелы).
- `commands/process-transcript.md` — оркестратор всего цикла.
- `skills/transcript-router/SKILL.md` — правила маршрутизации по функциональным папкам, форматы вывода, сценарии «обновление vs создание», обработка пересечения «общий контекст + функция».
- `bin/create-workspace.ps1` — генерация рабочей папки для Windows.

Чтобы изменить правила маршрутизации, отредактируй `skills/transcript-router/SKILL.md` в кэше плагина (`~/.claude/plugins/cache/claude-context-extractor/context-extractor/<version>/`) — это обычный Markdown.

## Лицензия

MIT.
