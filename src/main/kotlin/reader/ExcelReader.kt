package reader

import model.Student
import org.apache.poi.ss.usermodel.WorkbookFactory
import security.AuthManager
import java.io.File
import java.io.FileNotFoundException

/**
 * Singleton reader component for extracting student input data from an Excel workbook.
 */
object ExcelReader {

    /**
     * Reads students from an Excel file at the given path.
     * Skips the header row (index 0). Validates each row using [AuthManager].
     * @throws FileNotFoundException if the specified file cannot be found.
     */
    fun readStudents(path: String): List<Student> {
        val file = File(path)
        if (!file.exists()) {
            throw FileNotFoundException("Input file not found at $path")
        }

        val students = mutableListOf<Student>()

        WorkbookFactory.create(file).use { workbook ->
            val sheet = workbook.getSheetAt(0)
            
            // Skip header (row 0), start from 1
            for (i in 1..sheet.lastRowNum) {
                val row = sheet.getRow(i) ?: continue

                val nameCell = row.getCell(0)
                val caCell = row.getCell(1)
                val examCell = row.getCell(2)

                val name = nameCell?.stringCellValue?.trim()
                
                // Read numeric values safely. They might be formatted as strings in some cells
                val caStr = caCell?.let { 
                    when (it.cellType) {
                        org.apache.poi.ss.usermodel.CellType.NUMERIC -> it.numericCellValue.toInt().toString()
                        else -> it.stringCellValue
                    }
                }
                
                val examStr = examCell?.let { 
                    when (it.cellType) {
                        org.apache.poi.ss.usermodel.CellType.NUMERIC -> it.numericCellValue.toInt().toString()
                        else -> it.stringCellValue
                    }
                }

                if (AuthManager.validateStudent(name, caStr, examStr)) {
                    val caMark = caStr!!.toInt()
                    val examMark = examStr!!.toInt()
                    students.add(Student(name!!, caMark, examMark))
                }
            }
        }
        
        return students
    }
}
