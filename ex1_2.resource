*** Settings ***
Library    Process
Library    OperatingSystem 
Library    oop.py     ${CURDIR}/result.txt    ${CURDIR}/conv.txt     WITH NAME     lib  
*** Variables ***
@{filename}=    ./result.txt       ./conv.txt    #./resultmp.txt

#*** Tasks ***
*** Comments ***
*** Keywords ***    
Delete All Files
    FOR    ${element}    IN    @{filename}
        lib.Delete File    ${element}
    END
Empty All Files
    FOR    ${element}    IN    @{filename}
        lib.Empty File    ${element}    
    END
Check customers list after adding new customers
    [Documentation] 
    [Arguments]    ${infile}    ${outfile}
    lib.Match Regex Customer    
    ${ver}    lib.Verify Customer Output    
    RETURN  ${ver}

Check customer's order list after making a new order
    [Documentation]    Alias Keyword for <Verify OrderID In Customer>
    [Arguments]    ${infile}    ${name}
    ${ver}    lib.Verify OrderID In Customer   nam
    RETURN    ${ver}