*** Settings ***
Library  RequestLibrary
Library  Utility
Library  String
Library    JSONLibrary
Library    SeleniumLibrary

*** Keywords ***

Send the REST API request
    [Documentation]    This keyword sends the API request for the specified REST API method, endpointURI and data.
    [Arguments]    ${method}    ${endPointURL}   ${jsonData}=${EMPTY}    
    Run Keyword If    '${method}'=='${postMethod}'    Post    ${endPointURl}   body=${jsonData}   
    ...            ELSE IF    '${method}'=='${getMethod}'    Get    ${endPointURl}      
    ...            ELSE IF    '${method}'=='${deleteMethod}'    Delete    ${endPointURl}   
    ...            ELSE IF    '${method}'=='${putMethod}'     Put    ${endPointURl}   body=${jsonData}    
    ...            ELSE IF    '${method}'=='${patchMethod}'     Patch    ${endPointURl}   body=${jsonData}    
    ...            ELSE    Fail    Invalid Rest method Name
    Output  response 

Validate REST API request submitted successfully  
    [Documentation]     This keyword is used to validate the response submitted successfully.
    ${statusCode}    Output    response status 
    Log   ${statusCode} 
    Should Be Equal    200    ${statusCode}
    Should Be True    ${status}    REST API was not submitted successfully. Expected status code should be among ${RESTResponseSuccessStatusList} but the status was ${statusCode}
    ${responseDataMap}     Create Dictionary     
    ${responseDataMap}     Output  response 
    ${RESTAPIResponseErrors}    Fetch Errors From RESTAPI Response    ${responseDataMap}
    Should Be Empty    ${RESTAPIResponseErrors}    REST API Response is not submitted successfully as it contains error: ${RESTAPIResponseErrors}       

Data from response matches database values
    [Documentation]    This keyword queries the database table and validates the query result matches with the API response data.
    [Arguments]    ${product}    ${response}    ${dbToJSONMap}
    ${querySelectString}    Construct the select statement string for database query    ${columnNames}
    ${queryResult}    Catenate    SELECT ${querySelectString} FROM Table WHERE product=\'${product}\'
    ${dictAreEqualFlag}    Validate Json Data Matches With Query Result Data    ${response}    ${queryResult}   ${dbToJSONMap}
    Should Be True    ${dictAreEqualFlag}   Repossession post sale details from JSON :${jsonBodyData} does not matches with the database values:${queryResult}[0].
    
Construct the select statement string for database query
    [Documentation]    This keyword construct the select statement string for the query using the given tableColumnNames argument.
    [Arguments]    ${tableColumnNames}
    ${selectStatementValues}   Set Variable    ${EMPTY}    
    FOR   ${item}    IN    @{tableColumnNames}  
        ${selectStatementValues}    Catenate   ${selectStatementValues}  ${item},
    END
    ${selectColumnsString}=        Get Substring   ${selectStatementValues}  0  -1
    log    ${selectColumnsString}
    [Return]   ${selectColumnsString} 

Validate status code from REST API response
    [Documentation]    This keyword used to verify status code from response.
    [Arguments]    ${statusCode}
    ${responseStatusCode}    Set Variable   ${response.status_code}    
    Log   ${responseStatusCode}
    Should Be Equal As Numbers    ${responseStatusCode}    ${statusCode}    Expected response status code ${statusCode} and actual response status code ${responseStatusCode} are different.    

Validate error response from REST API response
    [Documentation]    This keyword is used to verify error status code and error message present in the response.
    [Arguments]    ${statusCode}    ${errorJsonPath}    ${expectedErrorMessage}
    Validate status code from REST API response    ${statusCode}
    ${errorFromResponse}    Get Value From Json    ${response}    ${errorJsonPath}  
    Should Be Equal    ${errorFromResponse}    ${expectedErrorMessage}    Response error message:${errorFromResponse} not equal to expected error message:${expectedErrorMessage}

User is logged into application 
    [Documentation]    This keyword will log into application and navigates to Home page.
    [Arguments]    ${loginURL}    ${userID}    ${password}
    Open Browser    ${loginURL}    chrome
    Maximize Browser Window 
    Wait Until Page Contains Element    LoginPageWebElementxpath     5s    Login page is not displayed
    Input Text    UserNameTextBoxxpath     ${userID}
    Input Password    PasswordTextBoxxpath    ${password}
    Click Button    SubmitButtonxpath
    Wait Until Page Contains Element    HomePageElementxpath    5s    Home page is not displayed

User navigates to Dashboard page
    [Documentation]    This keyword navigates the urer to Dashboard page after clicking on the dashboard link.
    Wait Until Element Is Enabled     DashboardLink    5s    Dashboard link is not enabled.
    Click Element    DashboardLink    
    Wait Until Element Is Visible    DashboardPageElement    5s    User is not navigated to Dashboard page

User navigates to Configuration page
    [Documentation]    This keyword navigates the urer to Configuration page after clicking on the configuration link.
    Wait Until Element Is Enabled     ConfigurationLink    5s    Configuration link is not enabled.
    Click Element    ConfigurationLink    
    Wait Until Element Is Visible    ConfigurationPageElement    5s    User is not navigated to Configuration page

User edits and saves email address of the user
    [Documentation]    This keyword edits and saves the email address of the user.   
    Clear Element Text    EmailAddressTextBox
    Input Text    EmailAddressTextBox    test@gmail.com
    Wait Until Element Is Visible    SaveButton    5s     Save button is not displayed
    Click Button    SaveButton  

Data synchronization is verified
    [Documentation]    This keyword fetches the product and order data from database, verifies the same is getting displayed in UI.
    ...    After synchronization interval of time, verifies that the database details are updated by validating last updated timestamp.
    ...    and verifies database values against UI. Cycle continues for given number of count.
    [Arguments]    ${count}=3    ${synchronizationInterval}=30s
    FOR    ${i}    IN RANGE    ${count}
        Fetch product and order details from database
        Verify the displayed details in UI   ### UI details are verified against fetched database values
        Sleep    ${synchronizationInterval}
        Verify last updated timestamp is updated in database
    END    
