# Kotlin Student Grading System

A professional, fully-featured console application built with Kotlin for evaluating student results. This application reads student data from an Excel workbook, applies interchangeable grading strategies based on configurable JSON files, and exports the final metrics to various robust formats including Excel, CSV, PDF, and JSON.

## Project Structure

```text
GradingApp/
├── config/
│   └── grading_config.json
├── src/main/kotlin/
│   ├── model/
│   │   └── Student.kt
│   ├── config/
│   │   └── GradingConfig.kt
│   ├── grading/
│   │   └── GradingStrategy.kt
│   ├── security/
│   │   └── AuthManager.kt
│   ├── export/
│   │   ├── ExportStrategy.kt
│   │   ├── ExcelExporter.kt
│   │   ├── CsvExporter.kt
│   │   ├── PdfExporter.kt
│   │   ├── JsonExporter.kt
│   │   └── ExportManager.kt
│   ├── reader/
│   │   └── ExcelReader.kt
│   ├── console/
│   │   └── ConsoleApp.kt
│   └── Main.kt
├── build.gradle.kts
├── deploy.bat
├── deploy.sh
└── README.md
```

## Requirements
- JDK 17 or higher.

## How to Build

We provide deploying scripts to quickly spin up the `shadowJar` (fat JAR containing all dependencies).

**Windows:**
```bat
deploy.bat
```

**Linux/Mac:**
Make the script executable and run:
```bash
chmod +x deploy.sh
./deploy.sh
```

Or you can use the Gradle Wrapper manually:
```bash
./gradlew shadowJar
```

## How to Run
After compiling the robust fat JAR, you can run it via:
```bash
java -jar build/libs/grading-app.jar
```

## Login Credentials

Authentication is required to launch the app. You can use any of the predefined profiles.

| Role      | Username | Password  |
|-----------|----------|-----------|
| Admin     | admin    | admin123  |
| Lecturer  | lecturer | grade2024 |

## Customizing Grades

The application reads logic parameters from `config/grading_config.json`.
You can customize max marks, grade brackets, app name, and pass limits without modifying the Kotlin code.

Example structure:
```json
{
  "appName": "Student Grading System",
  "passMarkTotal": 40,
  "gradeBands": [
    { "grade": "A", "minScore": 70, "maxScore": 100, "remark": "Excellent" },
    ...
  ]
}
```

## Input File Format

The system expects an input file (default: `students_input.xlsx`).
The spreadsheet **must** have 3 columns in order:
`Student Name` | `CA Mark` (0-40) | `Exam Mark` (0-60)

The first row is ignored as it is assumed to be the header row. Any invalid rows are systematically ignored with a warning displayed on the console.

## Output Formats
The app exports output using four discrete strategies:
- `.xlsx` -> Full formatting, headers with yellow fill, using Apache POI.
- `.csv` -> Comma separated values for easy data processing in other scripts.
- `.pdf` -> Pretty-printed PDF document with centering and tables using iText.
- `.json` -> Serialized data interchange payload for web integrations.

## Extensibility

To add a new Grading Strategy:
1. Navigate to `src/main/kotlin/grading/GradingStrategy.kt`.
2. Implement the `GradingStrategy` interface in a new class (e.g., `LenientGradingStrategy`).
3. Add the strategy instantiation inside `console/ConsoleApp.kt` based on a new prompt option.
