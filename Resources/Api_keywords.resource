*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    OperatingSystem
Library    DateTime
Resource    ../Resources/Variables.resource

*** Keywords ***
Create Barrel    
    [Documentation]    Creates a barrel with the given QR, RFID, and NFCResources/Api_keywords.resource
    [Arguments]    ${qr}    ${rfid}    ${nfc}    # Arguments for the barrel {QR-code, RFID-chip, NFC-reader}
    ${body}=    Create Dictionary    qr=${qr}    rfid=${rfid}    nfc=${nfc}    # Create the body of the request
    ${response}=    POST    ${BARRELS_ENDPOINT}    json=${body}    # Send the POST request
    Log    Status Code: ${response.status_code}    # Log the status code
    Log    Response: ${response.json()}    # Log the response
    RETURN    ${response}    # Return the response

Get Barrel By ID    
    [Documentation]    Gets a barrel by ID
    [Arguments]    ${barrel_id}    # Argument for the barrel ID
    ${url}=    Set Variable    ${BARRELS_ENDPOINT}/${barrel_id}    # Create the URL for the request 
    ${response}=    GET    ${url}    # Send the GET request
    Log    Status Code: ${response.status_code}    # Log the status code
    Log    Response: ${response.json()}    # Log the response
    RETURN    ${response}    # Return the response

Get All Barrels
    [Documentation]    Gets all barrels
    ${response}=    GET    ${BARRELS_ENDPOINT}    # Send the GET request
    Log    Status Code: ${response.status_code}    # Log the status code
    Log    Response: ${response.json()}    # Log the response
    RETURN    ${response}    # Return the response

Delete Barrel
    [Arguments]    ${barrel_id}
    ${url}=    Set Variable    ${BARRELS_ENDPOINT}/${barrel_id}    # Create the URL for the request
    ${response}=    DELETE    ${url}    # Send the DELETE request
    Log    Response status: ${response.status_code}    # Log the response status code
    RETURN    ${response}    # Return the response

Create Barrel With Body
    [Documentation]    Creates a barrel with the given body
    [Arguments]    ${body}    # Argument for the body
    ${headers}=    Create Dictionary    Content-Type=application/json    # Create the headers for the request
    ${response}=    POST    ${BARRELS_ENDPOINT}    json=${body}    headers=${headers}    # Send the POST request
    RETURN    ${response}    # Return the response

Generate Long String
    [Documentation]    Generates a string of a given length
    [Arguments]    ${length}    # Argument for the length of the string
    ${string}=    Evaluate    'x' * ${length}    # Generate the string
    RETURN    ${string}    # Return the string


Test Missing Required Field
    [Documentation]    Tests missing required fields
    [Arguments]    ${missing_field}    &{fields}    # Arguments for the missing field and the fields
    ${body}=    Create Dictionary    &{fields}        # Create the body of the request
    ${response}=    Create Barrel With Body    ${body}    # Send the POST request
    Should Be Equal As Strings    ${response.status_code}    400    # Check if the response status code is 400
    Should Contain    ${response.json()["detail"]}    ${missing_field}    # Check if the response contains the missing field

Test Invalid ID Format    
    [Documentation]    Tests invalid ID format
    [Arguments]    ${invalid_id}    # Argument for the invalid ID
    ${response}=    Get Barrel By ID    ${invalid_id}    # Get the barrel
    Should Be Equal As Strings    ${response.status_code}    422    # Check if the response status code is 422
    Should Contain    ${response.json()["detail"]}    Invalid ID format    # Check if the response contains the invalid ID format

Test Invalid ID Format For Delete
    [Documentation]    Tests invalid ID format for delete
    [Arguments]    ${invalid_id}    # Argument for the invalid ID
    ${response}=    Delete Barrel    ${invalid_id}    # Delete the barrel
    Should Be Equal As Strings    ${response.status_code}    422    # Check if the response status code is 422
    Should Contain    ${response.json()["detail"]}    Invalid ID format    # Check if the response contains the invalid ID format

Validate Barrel Response
    [Documentation]    Validuje základní strukturu odpovědi pro barel
    [Arguments]    ${response}    # Argument pro odpověď
    Should Contain    ${response.json()}    id    # Check if the response contains the ID
    Should Contain    ${response.json()}    qr    # Check if the response contains the QR code
    Should Contain    ${response.json()}    rfid    # Check if the response contains the RFID
    Should Contain    ${response.json()}    nfc    # Check if the response contains the NFC


Create Measurement
    [Documentation]    Creates a new measurement with required parameters
    [Arguments]    ${barrel_id}    ${impurity_percentage}    ${timestamp}=${None}    # Required arguments for the measurement
    ${body}=    Create Dictionary    barrel_id=${barrel_id}    impurity_percentage=${impurity_percentage}    # Create the body of the request

    IF    ${timestamp} is not ${None}    # If timestamp is provided
        Set To Dictionary    ${body}    timestamp=${timestamp}    # Add the timestamp to the body
    END    # End the if statement

    ${headers}=    Create Dictionary    Content-Type=application/json    # Create the headers for the request
    ${response}=    POST    ${MEASUREMENTS_ENDPOINT}    json=${body}    headers=${headers}    # Send the POST request
    RETURN    ${response}    # Return the response

Get All Measurements    
    [Documentation]    Retrieves all measurements from the system
    ${response}=    GET    ${MEASUREMENTS_ENDPOINT}    # Send the GET request
    RETURN    ${response}    # Return the response

Get Measurement By ID
    [Documentation]    Retrieves specific measurement by its ID
    [Arguments]    ${measurement_id}    # Argument for the measurement ID
    ${url}=    Set Variable    ${MEASUREMENTS_ENDPOINT}/${measurement_id}    # Create the URL for the request
    ${response}=    GET    ${url}    # Send the GET request
    RETURN    ${response}    # Return the response
    
Delete Measurement
    [Documentation]    Deletes a specific measurement by ID
    [Arguments]    ${measurement_id}    # Argument for the measurement ID
    ${url}=    Set Variable    ${MEASUREMENTS_ENDPOINT}/${measurement_id}    # Create the URL for the request
    ${response}=    DELETE    ${url}    # Send the DELETE request
    RETURN    ${response}    # Return the response

Validate Measurement Response
    [Documentation]    Validates basic structure of measurement response
    [Arguments]    ${response}    # Argument for the response
    Should Contain    ${response.json()}    id    # Check if the response contains the ID
    Should Contain    ${response.json()}    barrel_id    # Check if the response contains the barrel ID
    Should Contain    ${response.json()}    impurity_percentage    # Check if the response contains the impurity percentage
    Should Contain    ${response.json()}    timestamp    # Check if the response contains the timestamp

Delete Test Data
    [Documentation]    The keyword deletes all created barrels and measurements
    Run Keyword If    "${CREATED_BARREL_ID}" != "${None}"    Delete Barrel    ${CREATED_BARREL_ID}    # Delete the created barrel
    Reset Created IDs    # Reset the created IDs
Reset Created IDs    
    Set Global Variable    ${CREATED_BARREL_ID}    ${None}    # Reset the created barrel ID
