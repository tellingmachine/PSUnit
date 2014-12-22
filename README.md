PSUnit
======

Unit testing framework for Windows PowerShell

Forked from tellingmachine/PSUnit credits go to original author.

The role of this fork is to extend functionality up to PowerShell 4.0

Installation
------------------
Copy this directory to $pshome/Modules/PSUnit

Operation
-----------------

  Import-Module PSUnit
  Set-DebugMode

  #Launch PSUnit test runner
  .\PSUnit.Run.ps1 -PSUnitTestFile (Join-Path -Path . -ChildPath PSUnit.Example.Test.ps1) -ShowReportInBrowser

  #Launch PSUnit test runner with Category "FastTests"
  .\PSUnit.Run.ps1 -PSUnitTestFile (Join-Path -Path . -ChildPath PSUnit.Example.Test.ps1) -ShowReportInBrowser -Category "FastTests"
