*** Settings ***
Library    DatabaseLibrary
Resource    ./TestDefinitions.robot
Suite Setup    Connect to Database

*** Variables ***

${ProductInformationURI}    https://smartFactory.com/productInfo
&{DBToJSONMap}    COLUMN_NAME1=jsonFeildName1    COLUMN_NAME2=jsonFeildName2
${ErrorJsonPath}    $.error.message   
${InvalidInputParametersErrorMessage}    Invalid Input Paramters
${InvalidUserCredentialsErrorMessage}    Invalid User Crendentials
${JSONFilePath}    ./InputFile.json
${OrderInformationURI}    https://smartFactory.com/orderInfo
${LoginURL}    hTTps://smartfactory.com/home


*** Test Cases ***

####### Scenarios on Product Information API #######

Verify successful Add/Update Product Data through Product Information API  
    [Template]    Verify successful Add/Update Product Data through Product Information API 
    [Tags]    API
    ### Add New Product
    #${UserId}   ${password}    ${product}    ${method}    ${productInformationURI}    ${jsonFilePath}      ${jsonID}        ${dbToJSONMap}          
        user      password        product       POST       ${ProductInformationURI}    ${JSONFilePath}     AddRequestData    ${DBToJSONMap}
    ### Update Product Data
    #${UserId}   ${password}    ${product}    ${method}    ${productInformationURI}    ${jsonFilePath}       ${jsonID}         ${dbToJSONMap}          
        user      password        product        PUT       ${ProductInformationURI}    ${JSONFilePath}     UpdateRequestData   ${DBToJSONMap}

Verify successful retrieval of Product Data through Product Information API
    [Template]    Verify successful retrieval of Product Data through Product Information API
    [Tags]    API
    #${UserId}   ${password}    ${product}    ${method}    ${productInformationURI}    ${dbToJSONMap}          
        user      password        product        GET      ${ProductInformationURI}    ${DBToJSONMap}

########## Error Scenarios #########

Verify forbidden error response when user without required permission accesses Product Information API
    [Template]    Verify forbidden error response when user without required permission accesses Product Information API
    [Tags]    API
    #${UserId}   ${password}    ${productInformationURI}    ${statusCode}          
        user      password      ${ProductInformationURI}        403

Verify error resonse when user accesses Product Information API with invalid input parameters  
    [Template]    Verify error resonse when user accesses Product Information API with invalid input parameters  
    [Tags]    API
    #${UserId}   ${password}    ${productInformationURI}    ${statusCode}    ${errorJsonPath}    ${expectedErrorMessage}          
        user      password      ${ProductInformationURI}        400         ${ErrorJsonPath}    ${InvalidInputParametersErrorMessage} 

Verify unauthorized error response when user accesses Product Information API with invalid credentials  
    [Template]    Verify unauthorized error response when user accesses Product Information API with invalid credentials 
    [Tags]    API
    #${UserId}   ${password}    ${productInformationURI}    ${statusCode}    ${errorJsonPath}    ${expectedErrorMessage}          
        user      password       ${ProductInformationURI}        401         ${ErrorJsonPath}    ${InvalidUserCredentialsErrorMessage} 

####### Scenarios on Order Placement API #######

Verify successful Order Placement through Order Processing API
    [Template]    Verify successful Order Placement through Order Processing API
    [Tags]    API    
    #${UserId}   ${password}    ${product}    ${method}    ${orderInformationURI}    ${jsonFilePath}       ${jsonID}      ${dbToJSONMap} 
        user      password        product       POST       ${OrderInformationURI}    ${JSONFilePath}     AddRequestData    ${DBToJSONMap}
   
Verify Order status updated successfully through Order Processing API
    [Template]    Verify Order status updated successfully through Order Processing API
    [Tags]    API    
    #${UserId}   ${password}    ${product}    ${method}    ${orderInformationURI}    ${jsonFilePath}       ${jsonID}      ${dbToJSONMap} 
        user      password        product       PUT       ${OrderInformationURI}    ${JSONFilePath}     UpdateRequestData    ${DBToJSONMap}
   
Verify successful retrieval of Order details through Order Processing API
    [Template]    Verify successful retrieval of Order details through Order Processing API
    [Tags]    API    
    #${UserId}   ${password}    ${product}    ${method}   ${orderInformationURI}    ${dbToJSONMap} 
        user      password        product       GET       ${OrderInformationURI}    ${DBToJSONMap}

######## Scenarios on UI and Data consistency #######

Verify the display of Product and Order real time details on Dashboard page 
    [Template]    Verify the display of Product and Order real time details on Dashboard page 
    [Tags]    API    
    #${loginURL}    ${userID}  ${password} 
    ${LoginURL}       user      password 
    [Teardown]     Close All Browsers

Verify user is able to successfully edit and save configuration changes on Configuration page
    [Template]    Verify user is able to successfully edit and save configuration changes on Configuration page
    [Tags]    API    
    #${loginURL}    ${userID}  ${password} 
    ${LoginURL}       user      password 
    [Teardown]     Close All Browsers       
   
