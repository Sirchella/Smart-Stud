#!/bin/bash

echo "Building Kotlin Student Grading System..."
./gradlew shadowJar

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Build successful!"
    echo "To run the application, use:"
    echo "    java -jar build/libs/grading-app.jar"
else
    echo ""
    echo "❌ Build failed! Please check the output above."
fi
