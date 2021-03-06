. PSUnit.ps1                                        #Load PSUnit frame work (Accessible via PATH environment variable set in the profile)
. PSUnit.Example.AdvancedFunction.ps1

function Throw-Error()
{
    $Exception = New-Object -TypeName "System.InvalidOperationException"
    Throw $Exception   
}

function DontThrow-Error()
{
    "Sorry, no error!"
}

function Test.Throw-Error_ThrowsError([System.InvalidOperationException] $ExpectedException = $(new-object -TypeName "System.InvalidOperationException") )
{
    "Throwing Error"
    Throw-Error
}

function Test.DontThrow-Error_FailsTest([System.InvalidOperationException] $ExpectedException = $(new-object -TypeName "System.InvalidOperationException") )
{
    "This test is not supposed to trigger the expected exception"
    DontThrow-Error
}

function Test.ThisFunctionHasAllTestMetaData([System.InvalidOperationException] $ExpectedException = $(new-object -TypeName "System.InvalidOperationException"), [switch] $Skip, [switch] $Category_FastTests)
{
    "Function with all test meta data attributes"
}

function Test.ThisFunctionHasAllMetaExceptSkip([System.InvalidOperationException] $ExpectedException = $(new-object -TypeName "System.InvalidOperationException"), [switch] $Category_FastTests)
{
    "Function with all test meta data attributes, except the skip parameter"
}

function Test.ThisFunctionHasCategoryFastTests([switch] $Category_FastTests)
{
    "Category Fast Tests"
    Assert-That $(2 + 2) {$ActualValue -eq 4}
}


function Test.ThisFunctionHasCategoryFastTestsAndUsesTheDefaultException([switch] $Category_FastTests, [System.InvalidOperationException] $ExpectedException = $(DefaultException))
{
    "Category Fast Tests"
    Throw $(DefaultException)
    Assert-That $(2 + 2) {[System.InvalidOperationException] $ExpectedException = $(DefaultException)}
}

function Test.ThisFunctionCausesAnAssertToANonBoolean()
{
    Assert-That $(2 + 2) {"NonBooleanContraintEvaluation"}
}

function Test.ThisFunctionThrowsAnUnexpectedInvalidOperationException()
{
    Throw New-Object -TypeName "System.InvalidOperationException" -ArgumentList "Unexpected Exception!"
}

function Test.ThisFunctionThrowsSomeUnforeseenException()
{
    & (blabla.exe)   
}

function Test.ThisFunctionCausesAnAssertToANull()
{
    Assert-That $(2 + 2) {$Null}
}

function Test.ThisFunctionCausesAnAssertToThrowAnException()
{
    Assert-That $(2 + 2) {& (blabla.exe)}
}

function Test.ThisFunctionUsesAnUnknownExceptionTypeInTheExpectedExceptionParameter([System.InvalidOperationException] $ExpectedException = $(New-Object -TypeName "System.CPUOverclockedExcpetion"))
{
    Assert-That $(2 + 2) {$ActualValue -eq 4}
}

function Test.ExpectPSUnitExpectedExceptionNotThrownExceptionCausesTestToPassIfNoOtherExceptionIsThrown([PSUnit.Assert.PSUnitExpectedExceptionNotThrownException] $ExpectedException = $(New-Object -TypeName "PSUnit.Assert.PSUnitExpectedExceptionNotThrownException"))
{
    "PSUnitExpectedExceptionNotThrownException is expected, but not thrown"
}

function Test.ExpectPSUnitExpectedExceptionNotThrownExceptionCausesTestToFailIfRuntimeExceptionIsThrown([PSUnit.Assert.PSUnitExpectedExceptionNotThrownException] $ExpectedException = $(New-Object -TypeName "PSUnit.Assert.PSUnitExpectedExceptionNotThrownException"))
{
    Throw-Error
}

function Test.ExpectSystemManagementAutomationValidationExceptionValidateUsingTryCatchAndComparingOfExceptionRuntimeObjects()
{
    #Arrange
    
    
    #Act
    try
    {
        $Result = Validate-Validation -CantBeNullOrEmpty "Test" -ScriptBlockExpressionNeedsToReturnTrue "C:\PathThatWillNeverExist\"
    }
    catch
    {
        $Actual = $_.Exception
    }
    
    #Assert
    $Expected = Get-ParameterBindingValidationException
    
    Assert-That -ActualValue $Actual -Constraint {$ActualValue.GetType() -eq $Expected.GetType()}
}

function Test.ExpectSystemManagementAutomationValidationExceptionValidateUsingEncodedExceptionNameInParameterNameOfTypePSUnitExpectedException([PSUnit.Assert.PSUnitExpectedException] $System_DOT_Management_DOT_Automation_DOT_ParameterBindingValidationException)
{
    #Arrange
    #Act
    $Actual = Validate-Validation -CantBeNullOrEmpty "Test" -ScriptBlockExpressionNeedsToReturnTrue "C:\PathThatWillNeverExist\"
    
    
    #Assert
    Assert-That -ActualValue $Actual -Constraint {$ActualValue -eq "400"}
}

function Test.ExpectSystemManagementAutomationValidationExceptionWhenPassingEmptyString([PSUnit.Assert.PSUnitExpectedException] $System_DOT_Management_DOT_Automation_DOT_ParameterBindingValidationException)
{
    #Arrange
    #Act
    $Actual = Validate-Validation -CantBeNullOrEmpty "" 
    
    
    #Assert
    Assert-That -ActualValue $Actual -Constraint {$ActualValue -eq "400"}
}

function Test.ExpectedExceptionISAssertThatExceptionAndAssertFails([PSUnit.Assert.PSUnitExpectedException] $PSUnit_DOT_Assert_DOT_PSUnitAssertFailedException)
{
    #Arrange
    #Act
    $Actual = Validate-Validation -CantBeNullOrEmpty "Test" 
    $Actual = "200"
    
    #Assert
    Assert-That -ActualValue $Actual -Constraint {$ActualValue -eq "400"}
}

function Test.DontExpectSystemManagementAutomationValidationExceptionWhenPassingValidStringTestFailsInAssert([PSUnit.Assert.PSUnitExpectedException] $System_DOT_Management_DOT_Automation_DOT_ParameterBindingValidationException)
{
    #Arrange
    #Act
    $Actual = Validate-Validation -CantBeNullOrEmpty "Test" 
    $Actual = "200"
    
    #Assert
    Assert-That -ActualValue $Actual -Constraint {$ActualValue -eq "400"}
}


function Test.ExpectedExceptionISAssertThatExceptionAndAssertSucceeds([PSUnit.Assert.PSUnitExpectedException] $PSUnit_DOT_Assert_DOT_PSUnitAssertFailedException)
{
    #Arrange
    #Act
    $Actual = Validate-Validation -CantBeNullOrEmpty "Test" 
    $Actual = "400"
    
    #Assert
    Assert-That -ActualValue $Actual -Constraint {$ActualValue -eq "400"}
}