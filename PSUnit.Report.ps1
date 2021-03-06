. PSUnit.Support.ps1

Filter Render-ReportHeader([string] $TestReportTitle)
{
    $RenderedString = $_ +
@"
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>$TestReportTitle</title>
<style type="text/css">
      body {
          font-family: verdana, arial, helvetica, sans-serif;
          background: white;
          font-size: 9pt;
          color: black;
      }
      table {
          font-size: 9pt;
      }
      th {
          background-color: #0A6CCD;
          color: white;
          padding-left: 5px;
          padding-right: 5px;
      }
      td {
          padding-left: 5px;
          padding-right: 5px;
      }
      td.hilite {
          font-weight: bold;
          text-align: left;
          padding-left: 5px;
          padding-right: 5px;
      }
  .PASS {
	background-color: #09e800;
	color: black
}
  .FAIL {
	background-color: #e81100;
	font-weight: bold;	
	color: white
}
  .SKIP {
	background-color: #fffc0d;
	color: black
}
  .HEAD {
	background-color: #0A6CCD;
	font-weight: bold;	
	color: white
}
  .ErrorMessage {
	font-family: Verdana;
	color: #e81100;
}
.Logo {
	border-width: 0px;
}
</style>
</head><body>
<p><a name="PSUnit" href="http://www.psunit.org">
<img alt="PSUnit Logo" src="PSUnitLogo400.png" width="400" height="140" class="Logo" /></a></p>
<h2>PSUnit - The coolest Unit Testing Framework on the planet</h2>

"@

    return $RenderedString
}

Filter Render-TestEnvironmentParagraph([System.Collections.HashTable] $HeaderData)
{
    $RenderedString = $_ +
@"
<h3>Test Environment</h3>
<table>
<tbody>
<tr>
<td class="hilite">Test File Name:</td>
<td align="left">$(Encode-Html $($HeaderData.TestFileName))</td>
<td class="hilite">Source Code Revision:</td>
<td align="left">$(Encode-Html $($HeaderData.SourceCodeRevision))</td>
</tr>
<tr>
<td class="hilite">Test Start:</td>
<td align="left">$(Encode-Html $($HeaderData.StartTime))</td>
<td class="hilite">Test End:</td>
<td align="left">$(Encode-Html $($HeaderData.EndTime))</td>
</tr>
<tr>
<td class="hilite">Test Duration:</td>
<td align="left">$(Encode-Html $($HeaderData.Duration))</td>
<td class="hilite">Category:</td>
<td align="left">$(Encode-Html $($HeaderData.Category))</td>
</tr>
<tr>
<td class="hilite">Machine:</td>
<td align="left">$(Encode-Html $($HeaderData.MachineName))</td>
<td class="hilite">User:</td>
<td align="left">$(Encode-Html $($HeaderData.UserName))</td>
</tr>
<tr>
<td class="hilite">Operating System:</td>
<td align="left">$(Encode-Html $($HeaderData.OperatingSystem))</td>
<td class="hilite">PowerShell Version:</td>
<td align="left">$(Encode-Html $($HeaderData.PowerShellVersion))</td>
</tr>
</tbody></table>

"@

    return $RenderedString
}

Filter Render-StatisticsParagraph([System.Collections.HashTable] $Stats)
{
    $RenderedString = $_ +
@"
<h3>Test Statistics</h3>
<table>
<tbody>
<tr>
<td class="hilite">Total Number of tests:</td>
<td class="HEAD" align="left">$($Stats.Total)</td>
</tr>
"@
if ($($Stats.Passed) -gt 0)
{
    $RenderedString +=
@"
<tr>
<td class="hilite">Passed:</td>
<td class="PASS" align="left">$($Stats.Passed)</td>
</tr>
"@
}
if ($($Stats.Failed) -gt 0)
{
    $RenderedString +=
@"
<tr>
<td class="hilite">Failed:</td>
<td class="FAIL" align="left">$($Stats.Failed)</td>
</tr>
"@
}
if ($($Stats.Skipped) -gt 0)
{
    $RenderedString +=
@"
<tr>
<td class="hilite">Skipped:</td>
<td class="SKIP" align="left">$($Stats.Skipped)</td>
</tr>
"@
}

    $RenderedString +=
@"
</tbody></table>

"@

    return $RenderedString
}

Filter Render-TestResultsParagraph([System.Collections.ArrayList] $Results)
{
    $RenderedString = $_ +
@'
<h3>Test Results</h3>
<table>
<colgroup>
<col/>
<col/>
<col/>
</colgroup>
<tr><th>Test</th><th>Result</th><th>Reason</th></tr>
'@
    $Index = 1
    $Results | ForEach-Object `
    {
        $Reason = Encode-Html "N/A"
        $Test = Encode-Html $_.Test
        $Result = Encode-Html $_.Result
        $RowHtml = ""

        If ($($_.Reason))
        {
            $Reason = Encode-Html $_.Reason
            $RowHtml = "<tr><td>$Test</td><td class=`"$Result`">$Result</td><td class=`"ErrorMessage`"><a href=`"#ErrorDetails$Index`">$Reason</a></td></tr>`n"
        }
        else
        {
            $RowHtml = "<tr><td>$Test</td><td class=`"$Result`">$Result</td><td>$Reason</td></tr>`n"
        }
        $Index++
        $RenderedString += $RowHtml
    }

    $RenderedString += "</table>`n"


    return $RenderedString
}

Filter Render-ErrorDetailsParagraph([System.Collections.ArrayList] $Results)
{
    $RenderedString = $_ +
@'
<h3>Error Details</h3>
'@

    $Index = 1
    $RowHtml = ""
    $Results | ForEach-Object `
    {
        if($_.Reason)
        {
            $Test = Encode-Html $_.Test
            $ErrorRecordOutput = Format-ErrorRecord $_.Reason
            $ErrorRecordOutputHtml = Encode-Html $ErrorRecordOutput
            $ErrorRecordOutputHtml = $ErrorRecordOutputHtml.Replace("`n", "<br />`n")
            $RowHtml =
@"
<a name="ErrorDetails$Index"/><h4>$Test</h4>
<p><span class="ErrorMessage">$ErrorRecordOutputHtml</span></p>
<a href="#PSUnit">&lt;&lt; Back
</a>
"@
            $RenderedString += $RowHtml
        }
        $Index++
    }
    return $RenderedString
}

Filter Render-ReportFooter()
{
    $RenderedString = $_ +
@"
</body></html>
"@

    return $RenderedString
}


Function Render-TestResultReport([System.Collections.ArrayList] $Results, [System.Collections.HashTable] $HeaderData, [System.Collections.HashTable] $Statistics)
{
    $ReportHtml = ""

    $ReportHtml = $ReportHtml | Render-ReportHeader -TestReportTitle $HeaderData.TestReportTitle `
                          | Render-TestEnvironmentParagraph -HeaderData $HeaderData `
                          | Render-StatisticsParagraph -Stats $Statistics `
                          | Render-TestResultsParagraph -Results $Results `
                          | Render-ErrorDetailsParagraph -Results $Results `
                          | Render-ReportFooter
    return $ReportHtml
}