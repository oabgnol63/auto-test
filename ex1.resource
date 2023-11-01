*** Settings ***
Library    Process
Library    OperatingSystem 
Library    conv.py
*** Variables ***
@{filename}=    ./result.txt       ./conv.txt    #./resultmp.txt

#*** Tasks ***
*** Comments ***
*** Keywords ***    
Delete All Files
    FOR    ${element}    IN    @{filename}
        Delete File    ${element}
    END
Empty All Files
    FOR    ${element}    IN    @{filename}
        Empty File    ${element}    
    END
Check customers list after adding new customers
    [Documentation] 
    [Arguments]    ${infile}    ${outfile}
    Match Regex Customer    ${infile}    ${outfile} 
    ${ver}    Verify Customer Output    ${outfile}
    RETURN  ${ver}

Check customer's order list after making a new order
    [Documentation]    Alias Keyword for <Verify OrderID In Customer>
    [Arguments]    ${infile}    ${name}
    ${ver}    Verify OrderID In Customer    ${infile}    ${name}
    RETURN    ${ver}