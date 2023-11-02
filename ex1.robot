#!/usr/bin/env robot
*** Settings ***
Resource           ex1_2.resource    
Suite Setup   
    ...            Run Keywords
    ...            Log To Console    \nTest Suite Setup.....\n\n------------------------------------------------------------------------------
    ...     AND    Create File    ./conv.txt
Test Teardown
    ...            Run Keyword    
    ...            Empty All Files
Suite Teardown        
    ...            Run Keywords    
    ...            Terminate All Processes    kill=True    
    ...     AND    Log to Console    \nComment out @{filename} file at Resource to read the output file\n  
    ...     AND    Delete All Files 
    ...     AND    Log To Console    Test Suite Teardown.....\n

*** Test Cases ***
Verify <New item> Function With Valid Input Set
    [Documentation]    Insert a new item (1) -- Expect <List all items> contains the new-created item.
    [Tags]  test1
    ${test1}       Run Process  echo -n "2\netheral blade\n100\n850000\n4\n0" | ./run_file.sh  shell=True  cwd=/root/Bao/cpp/test   
        ...        stdin=PIPE
        ...        stdout=/root/Bao/auto/ex1/result.txt
    Should Contain   ${test1.stdout.strip()}    etheral blade    
Verify <New customer> Function With Valid Input Set
    [Documentation]    Insert new customers (2) -- Expect <List all customers> contains the new-created customers.
    [Tags]        test2
    ${proc2}       Run Process  ./mainApp  shell=True  cwd=/root/Bao/cpp/test/build  
        ...        stdout=/root/Bao/auto/ex1/result.txt     
        ...        stdin=/root/Bao/auto/ex1/input2.txt
        ...        timeout=1  
    ${result2} =    Check customers list after adding new customers   ./result.txt    ./conv.txt
    #Log To Console    \n\n${result2}\n\n
    Should Be Equal As Integers  ${result2}    4

Verify <New customer> Function With Wrong Info
    [Documentation]    Insert new customers (2) with empty <Addres> -- Expect return "Fail at Address field"
    [Tags]     test3
    ${proc3}       Run Process  echo -n "1\nbao\n \n911\n3\n0" | ./mainApp  shell=True  cwd=/root/Bao/cpp/test/build  
        ...        stdout=/root/Bao/auto/ex1/result.txt     
        ...        stdin=PIPE
        ...        timeout=1  
    ${result3} =    Check customers list after adding new customers   ./result.txt    ./conv.txt
    Log To Console    \n\n${result3}\n
    Should Contain    ${result3}    Fail at Address field

Verify <Make a new order> Function With Invalid Input Set
    [Documentation]    Insert new orders (6) -- Make an order with not available item -- Expect message "Item not exits"
        ...  Step       |  Input
        ...  Select (6) |  Type Customer's ID (number only): 123      #any number
        ...             |  Type item's name: iphone 15                #any that's not valid
        ...   ---------------------------------------------------------------------------------------
        ...             |  Output
        ...   ---------------------------------------------------------------------------------------
        ...  <console>  |  Expect logging to console:  "Item not exits"
        ...  Select (0) |  Exit program
    [Tags]    test4
    ${proc4}   Run Process  echo -n "6\n123\niphone\n0" | ./mainApp  shell=True  cwd=/root/Bao/cpp/test/build  
        ...    stdout=/root/Bao/auto/ex1/result.txt     
        ...    stdin=PIPE
        ...    timeout=1
    Should Contain    ${proc4.stdout.strip()}    Item not exits

Verify <Make a new order> Function With Invalid Input Set 2
    [Documentation]    Make a new orders (6) with invalid input <quantities> -- Expect message "Item x have only y in stock"
        ...  Step       |  Input
        ...  ---------------------------------------------------------------------------------------
        ...  Select (2) |  Insert item's name: etheral blade          #any that's not in item's list
        ...             |  Insert item's quantities: 10
        ...             |  Insert price: 800000
        ...  Select (6) |  Type Customer's ID (number only): 123      #any number
        ...             |  Type item's name: etheral blade            #which is just added by (2)
        ...             |  Quantities: 101                            #any number that's larger than available value added by (2) (which is 10)
        ...   ---------------------------------------------------------------------------------------
        ...             |  Output
        ...   ---------------------------------------------------------------------------------------
        ...  <console>  |  Expect logging to console:  "Item /etheral blade/ have only /10/ in stock"
        ...  Select (0) |  Exit program
    [Tags]    test5
    ${proc5}   Run Process  echo -n "2\netheral blade\n10\n800000\n6\n123\netheral blade\n101\n0" | ./run_file.sh  shell=True  cwd=/root/Bao/cpp/test/ 
        ...    stdout=/root/Bao/auto/ex1/result.txt     
        ...    stdin=PIPE
        ...    timeout=5
    Should Contain    ${proc5.stdout.strip()}    Item etheral blade have only 10 in stock


Verify <Make a new order> Function With Valid Input Set
    [Documentation]    Make a new orders (6) with valid input -- Expect info is saved successfully 
        ...  Step       |  Input
        ...  ---------------------------------------------------------------------------------------
        ...  Select (6) |  Type Customer's ID (number only): 123   #any number
        ...             |  Type item's name: divine rapier   
        ...             |  Quantities: 1                           
        ...             |  Continue shopping? (Y|N): n
        ...   <console> |  Customer not found! Create new... 
        ...             |  Input your name: nam
        ...             |  Input your address: tma
        ...             |  Input your phone num: 911
        ...   ---------------------------------------------------------------------------------------
        ...             |  Output
        ...   ---------------------------------------------------------------------------------------
        ...   <console> |  Assigned customer's ID: some number    #auto increment customer's Id, expected 2023002
        ...   <console> |  Assigned order's ID: some number       #auto generated order's Id 
        ...   <console> |  Total: 1000000.00                      #value of all bought items, < divine rapier -1000000 > in this case
        ...  Select (3) |  Expect this customer will be listed with <List all customers>, and /Order list/ includes new generated order's ID
        ...  Select (0) |  Exit program
    [Tags]    test6
    ${proc6}   Run Process  echo -n "6\n123\ndivine rapier\n1\nn\nnam\ntma\n911\n3\n0" | ./run_file.sh  shell=True   
        ...    stdout=/root/Bao/auto/ex1/result.txt     
        ...    stdin=PIPE
        ...    timeout=5
        ...    cwd=/root/Bao/cpp/test/
    ${result6}    Check customer's order list after making a new order    ./result.txt    nam
    Should Be Equal As Strings    ${result6}   Found the new order ID in customer's order list