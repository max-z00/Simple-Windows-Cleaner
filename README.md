# Simple Windows Cleaner
hello and welcome to my repo for a simple Windows cleaner script written in powershell.

# How to run
 * Right-click on the Start button and select "Windows PowerShell (Admin)" to open an elevated PowerShell session.
 * Navigate to the folder where you saved the script using the cd command:
```
cd C:\path\to\your\script
```
* Temporarily change the execution policy for the current session to allow running the script:
```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process -Force
```
 * This command sets the execution policy to RemoteSigned, allowing you to run locally created scripts. The -Scope Process flag ensures that the policy change only applies to the current PowerShell session.
 * Run the script by entering its name:
  ``` 
  .\SimpleCleaner.ps1
  ```
