@echo off
setlocal enabledelayedexpansion

:: Ensure at least one argument is provided
if "%~1"=="" (
    echo Error: Commit message is required.
    echo Usage: push "Your commit message" [branch]
    exit /b 1
)

:: Extract commit message and optional branch
set "message=%~1"
set "branch="

:: If a second argument is provided, use it as the branch name
if not "%~2"=="" (
    set "branch=%~2"
) else (
    for /f "tokens=*" %%b in ('git branch --show-current 2^>nul') do set "branch=%%b"
)

:: Ensure Git is installed
where git >nul 2>nul
if %errorlevel% neq 0 (
    echo Error: Git is not installed or not in PATH.
    exit /b 1
)

:: Ensure this is a Git repository
git rev-parse --is-inside-work-tree >nul 2>nul
if %errorlevel% neq 0 (
    echo Error: This is not a Git repository.
    exit /b 1
)

:: Validate branch existence
if "%branch%"=="" (
    echo Error: Unable to determine the current branch.
    echo Please specify a branch manually.
    exit /b 1
)

echo Pushing to branch: %branch%
echo Commit message: "%message%"

:: Add, commit, and push
git add .
if %errorlevel% neq 0 (
    echo Error: Failed to add files.
    exit /b 1
)

git commit -m "%message%"
if %errorlevel% neq 0 (
    echo Error: Commit failed. Check for untracked or unstaged files.
    exit /b 1
)

git push origin %branch%
if %errorlevel% neq 0 (
    echo Error: Push failed. Check your network connection or repository permissions.
    exit /b 1
)

echo Successfully pushed changes to origin/%branch%!
endlocal
exit /b 0
