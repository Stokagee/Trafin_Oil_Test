*** Settings *** 
Documentation    Test cases for the measurements endpoint
Resource    ../resources/Api_keywords.resource
Test Setup    Create Session    api    url=${BASE_URL}    # Create a session for the tests
Test Teardown    Delete Test Data    # Delete all test data after the tests

*** Test Cases ***
Create Valid Measurement Should Succeed
    [Documentation]    Test creating a measurement with valid data. First create a barrel to associate with
    ${barrel_resp}=    Create Barrel    test-qr-1    test-rfid-1    test-nfc-1    # Create a barrel
    Should Be Equal As Strings    ${barrel_resp.status_code}    201    # Check if the response status code is 201
    ${response}=    Create Measurement    ${barrel_resp.json()['id']}    15.5    # Create a measurement
    Should Be Equal As Strings    ${response.status_code}    201    # Check if the response status code is 201
    Validate Measurement Response    ${response}

Create Measurement With Invalid Barrel ID Should Fail
    [Documentation]    Test creating measurement with non-existent barrel ID
    ${response}=    Create Measurement    999999    20.0    # Create a measurement with invalid barrel ID
    Should Be Equal As Strings    ${response.status_code}    404    # Check if the response status code is 404

Get All Measurements After Creation
    [Documentation]    Verify measurements list contains created entry
    ${barrel_resp}=    Create Barrel    test-qr-2    test-rfid-2    test-nfc-2    # Create a barrel    
    ${measurement}=    Create Measurement    ${barrel_resp.json()['id']}    18.3    # Create a measurement
    ${all_measurements}=    Get All Measurements        # Get all measurements
    Should Be Equal As Strings    ${all_measurements.status_code}    200    # Check if the response status code is 200
    List Should Contain Value    ${all_measurements.json()}    ${measurement.json()}    # Check if the created measurement is in the list

Get Specific Measurement By ID
    [Documentation]    Test retrieving specific measurement
    ${barrel_resp}=    Create Barrel    test-qr-3    test-rfid-3    test-nfc-3    # Create a barrel
    ${measurement}=    Create Measurement    ${barrel_resp.json()['id']}    22.1    # Create a measurement
    ${retrieved}=    Get Measurement By ID    ${measurement.json()['id']}    # Get the created measurement
    Should Be Equal As Strings    ${retrieved.status_code}    200    # Check if the response status code is 200
    Should Be Equal As Numbers    ${retrieved.json()['impurity_percentage']}    22.1    # Check if the impurity percentage is correct
    
Delete Measurement Should Remove Entry
    [Documentation]    Test measurement deletion functionality
    ${barrel_resp}=    Create Barrel    test-qr-4    test-rfid-4    test-nfc-4    # Create a barrel
    ${measurement}=    Create Measurement    ${barrel_resp.json()['id']}    25.0    # Create a measurement
    ${delete_resp}=    Delete Measurement    ${measurement.json()['id']}    # Delete the created measurement
    Should Be Equal As Strings    ${delete_resp.status_code}    204    # Check if the response status code is 204
    ${retrieved}=    Get Measurement By ID    ${measurement.json()['id']}    # Try to get the deleted measurement. Verify deletion
    Should Be Equal As Strings    ${retrieved.status_code}    404    # Check if the response status code is 404

Edge Case: Create Measurement Without Required Fields
    [Documentation]    Test missing required fields validation
    ${headers}=    Create Dictionary    Content-Type=application/json    # Create the headers for the request
    ${body}=    Create Dictionary    # Missing barrel_id and impurity_percentage
    ${response}=    POST    ${MEASUREMENTS_ENDPOINT}    json=${body}    headers=${headers}    # Send the POST request
    Should Be Equal As Strings    ${response.status_code}    400    # Check if the response status code is 400