#!/bin/bash

# Prompt user for project name
read -p "Enter your project name: " PROJECT_NAME

# Confirm if user wants an empty project
read -p "Do you want an empty project? (y/n): " RESPONSE

if [ "$RESPONSE" = "y" ]; then
  # Create a new Next.js project with the given name and empty template
  npx create-next-app@latest "$PROJECT_NAME" --ts --tailwind --eslint --app --turbopack --use-pnpm --empty
else
  # Create a new Next.js project with the given name and default template
  npx create-next-app@latest "$PROJECT_NAME" --ts --tailwind --eslint --app --turbopack --use-pnpm
fi

