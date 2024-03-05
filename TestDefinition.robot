*** Settings ***
Resource    ./TestResources.robot

*** Keywords ***

Verify successful Add/Update Product Data through Product Information API 
    [Documentation]    This test case adds/updates product information and verifies the added/updated product data in database.
    [Arguments]    ${UserId}   ${password}    ${product}    ${method}    ${productInformationURI}    ${jsonFilePath}    ${jsonID}    ${dbToJSONMap} 
    Given User is authenticated and authorized    ${UserId}    ${password}
    And Fetch Json Request Body    ${jsonFilePath}     ${jsonID}
    When Send the REST API request    ${method}    ${productInformationURI}    ${requestBody}
    Then Validate REST API request submitted successfully    
    And Data from response matches database values    ${product}    ${response}    ${dbToJSONMap}

Verify successful retrieval of Product Data through Product Information API
    [Documentation]    This test case gets the product information and verifies the retrieved product data against database values.
    [Arguments]    ${UserId}   ${password}    ${product}    ${method}    ${productInformationURI}    ${dbToJSONMap} 
    Given User is authenticated and authorized    ${UserId}    ${password}
    When Send the REST API request    ${method}    ${productInformationURI}
    Then Validate REST API request submitted successfully    
    And Data from response matches database values    ${product}    ${response}    ${dbToJSONMap}

Verify forbidden error response when user without required permission accesses Product Information API
    [Documentation]    This test case verifies 403 forbidden status response when user without required permission accesses Product Information API.
    [Arguments]    ${UserId}   ${password}    ${productInformationURI}    ${statusCode} 
    Given User is authenticated    ${UserId}    ${password} 
    And User is not authorized    ${UserId}    
    When Send the REST API request    POST    ${productInformationURI}
    Then Validate status code from Request API response    ${statusCode} 

Verify error resonse when user accesses Product Information API with invalid input parameters 
    [Documentation]    This test case verifies 400 error response when user accesses Product Information API with invalid input parameters.
    [Arguments]    ${UserId}   ${password}    ${productInformationURI}    ${statusCode}    ${errorJsonPath}    ${expectedErrorMessage}  
    Given User is authenticated    ${UserId}    ${password}
    When Send the REST API request    POST    ${productInformationURI}
    Then Validate error response from REST API response    ${statusCode}    ${errorJsonPath}    ${expectedErrorMessage}
    
Verify unauthorized error response when user accesses Product Information API with invalid user credentials
    [Documentation]    This test case verifies 401 unauthorized error when user accesses Product Information API with invalid user credentials.
    [Arguments]    ${UserId}   ${password}    ${productInformationURI}    ${statusCode}    ${errorJsonPath}    ${expectedErrorMessage}  
    Given User is not authenticated    ${UserId}    ${password}        
    When Send the REST API request    POST    ${productInformationURI}
    Then Validate error response from REST API response    ${statusCode}    ${errorJsonPath}    ${expectedErrorMessage}

Verify successful Order Placement through Order Processing API
    [Documentation]    This test case verifies that order has been placed successfully through Order Processing API by verifying the newly added record in database.
    [Arguments]    ${UserId}   ${password}    ${product}    ${method}    ${orderInformationURI}    ${jsonFilePath}    ${jsonID}    ${dbToJSONMap} 
    Given User is authenticated and authorized    ${UserId}    ${password}
    And Fetch Json Request Body    ${jsonFilePath}     ${jsonID}
    When Send the REST API request    ${method}    ${orderInformationURI}    ${requestBody}
    Then Validate REST API request submitted successfully 
    And New record is added for the placed order in database  ####Query database for the new order.  
    And Data from response matches database values    ${product}    ${response}    ${dbToJSONMap}   ###Passing ${product} argument by assuming that product will be one of the condition while querying. 

Verify Order status updated successfully through Order Processing API
    [Documentation]    This test case verifies that status of the order is updated successfully through Order Processing API by verifying the updated status in database.
    [Arguments]    ${UserId}   ${password}    ${product}    ${method}    ${orderInformationURI}    ${jsonFilePath}    ${jsonID}    ${dbToJSONMap} 
    Given User is authenticated and authorized    ${UserId}    ${password}
    And Fetch Json Request Body    ${jsonFilePath}     ${jsonID}
    When Send the REST API request    ${method}    ${orderInformationURI}    ${requestBody}
    Then Validate REST API request submitted successfully 
    And Status of the specified Order is updated  ####Query database for the oder and validate status against the expected status. 
    And Data from response matches database values    ${product}    ${response}    ${dbToJSONMap}

Verify successful retrieval of Order details through Order Processing API
    [Documentation]    This test case gets the oder information and verifies the retrieved order data against database values.
    [Arguments]    ${UserId}   ${password}    ${product}    ${method}    ${orderInformationURI}    ${dbToJSONMap} 
    Given User is authenticated and authorized    ${UserId}    ${password}
    When Send the REST API request    ${method}    ${orderInformationURI}
    Then Validate REST API request submitted successfully    
    And Data from response matches database values    ${product}    ${response}    ${dbToJSONMap}

Verify the display of Product and Order real time details on Dashboard page 
    [Documentation]    This test case verifies that Product and Order real time details are displayed on dashboard page.
    [Arguments]    ${loginURL}    ${userID}    ${password} 
    Given User is authenticated and authorized    ${UserId}    ${password}
    And User fetches the Product and Order details from database
    And User is logged into application     ${loginURL}    ${userID}    ${password}   
    When User navigates to Dashboard page
    Then Product and Order details are displayed  ##### This keyword validates that deatils dispalyed in UI against the data fetched from database.

Verify user is able to successfully edit and save configuration changes on Configuration page
    [Documentation]    This test case verifies that Product and Order real time details are displayed on dashboard page.
    [Arguments]    ${loginURL}    ${userID}    ${password} 
    Given User is authenticated and authorized    ${UserId}    ${password}    
    And User is logged into application     ${loginURL}    ${userID}    ${password}   
    And User navigates to Configuration page
    When User edits and saves email address of the user    
    Then Email address is updated in database      ## Query for email address in DB and verify it against the given email address
    When User edits and saves synchronization interval
    Then Synchronization interval is updated in database  ### Query for synchronization interval in DB and verify it against the given interval time.
    And Data synchronization is verified