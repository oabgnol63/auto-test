#!/usr/bin/env robot
*** Settings ***
Library    Process
Library    OperatingSystem 
Library    conv.py
Library    String
Suite Setup   
    ...            Run Keywords
    ...            Log To Console    Test Suite Setup.....\n
    ...     AND    Create File    ./conv.txt
Suite Teardown        
    ...            Run Keywords    
    ...            Terminate All Processes    kill=True       
    ...     AND    Delete All Files 
    ...     AND    Log To Console    \nTest Suite Teardown.....
*** Variables ***
@{filename}=    #./result.txt    ./result2.txt    #./conv.txt
${convfile}=    ./conv.txt
${rs2}=         ./result2.txt

#*** Tasks ***
*** Comments ***
*** Keywords ***    
Delete All Files
    FOR    ${element}    IN    @{filename}
        Delete File    ${element}
    END
Sumary
    Match Regex Customer   r'^Name\:[a-zA-Z\s]+$   ${rs2}    ${convfile}
    File Should Not Be Empty    ${convfile}

*** Test Cases ***
TestCase1
    [Documentation]  Test the hello.cpp file -- 
    ...              Expect the output to be "hello world"
    [Tags]  test1 
    ${test1}     Run Process  echo -n 1 2 yes | ./mainApp  shell=True  stdin=PIPE
    Should Be Equal    ${test1.stdout}    hello world
TestCase2
    [Documentation]    Insert a new item -- Expect "List all items" contains the new-created item.
    [Tags]  test2
    [Timeout]    1
    ${test2}  Run Process  echo -n "2\netheral blade\n100\n850000\n4\n0" | ./run_file.sh  shell=True  cwd=/root/Bao/cpp/test   
    ...  stdin=PIPE
    ...  stdout=/root/Bao/auto/ex1/result.txt
    Should Contain    ${test2.stdout}    etheral blade    
Testcase3
    [Documentation]    Insert new customers -- Expect "List all customers" contains the new-created customers.
    [Tags]     Testcase3
    [Timeout]     1
    ${test3}  Run Process  ./mainApp  shell=True  cwd=/root/Bao/cpp/test/build  
    ...    stdout=/root/Bao/auto/ex1/result2.txt     
    ...    stdin=/root/Bao/auto/ex1/input2.txt
    ...    timeout=1  
    
    Should Contain    ${test3.stdout.strip()}    bao       hoang    le
    Sumary
    Write Into File   Hello     ${convfile}
    File Should Not Be Empty    ${convfile}

    

