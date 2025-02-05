*** Settings ***
Documentation    Test cases for the barrels endpoint
Resource    ../Resources/Api_keywords.resource    # Import the API keywords
Library    String    # Import the String library for string operations
Test Setup    Create Session    api    ${BASE_URL}    # Create a session for the tests
Test Teardown    Delete Test Data    # Delete all test data after the tests

*** Test Cases ***
Test Create Barrel
    [Documentation]    Creates a barrel and checks if the response is 201
    ${response}=    Create Barrel    test-qr    test-rfid    test-nfc    # Create barrel with test data
    Should Be Equal As Strings    ${response.status_code}    201    # Check if the response status code is 201
    Log    Barrel Created: ${response.json()}    # Log the created barrel

Test Get Barrel By ID
    [Documentation]    Gets a barrel by ID and checks if the response is 200 
    ${create_response}=    Create Barrel    test-qr    test-rfid    test-nfc    # Create barrel with test data
    ${barrel_id}=    Set Variable    ${create_response.json()["id"]}    # Extract the ID of the created barrel
    Sleep    1s    # Wait for the barrel to be created
    ${get_response}=    Get Barrel By ID    ${barrel_id}    # Get the barrel by ID
    Log    Get Barrel Response: ${get_response.json()}    # Log the response
    Should Be Equal As Strings    ${get_response.status_code}    200  # ❌ API returns 500 → report to the developers
    Should Be Equal As Strings    ${get_response.json()["id"]}    ${barrel_id}
    


Test Create Barrel Debug    
    [Documentation]    This test creates a barrel with test data and logs the response
    ${response}=    Create Barrel    test-qr    test-rfid    test-nfc    # Create barrel with test data
    Log    Response status: ${response.status_code}    # Log the response status code    
    Log    Response body: ${response.json()}    # Log the response body
    ${barrel_id}=    Set Variable    ${response.json()["id"]}    # Extract the ID of the created barrel        
    Log    Extracted ID: ${barrel_id}    # Log the extracted ID

Test Get All Barrels
    [Documentation]    This test gets all barrels and checks the response status code    
    ${response}=    GET    ${BARRELS_ENDPOINT}    # Get all barrels
    Log    Response status: ${response.status_code}    # Log the response status code
    Log    Response body: ${response.json()}    # Log the response body
    Should Be Equal As Strings    ${response.status_code}    200    # Check if the response status code is 200

Test Delete Barrel
    [Documentation]    This test creates a barrel and then deletes it
    ${response}=    Create Barrel    test-qr    test-rfid    test-nfc    # Create barrel with test data
    ${barrel_id}=    Set Variable    ${response.json()["id"]}    # Extract the ID of the created barrel
    ${delete_response}=    Delete Barrel    ${barrel_id}    # Delete the barrel
    Log    Delete Response: ${delete_response.json()}    # Log the delete response
    Should Be Equal As Strings    ${delete_response.status_code}    204    # Check if the response status code is 204

Edge Case: Create Barrel Missing Required Fields
    [Documentation]    The test checks if the API returns 400 for missing required fields
    [Template]    Test Missing Required Field    # Test missing required fields    
    qr        rfid=test    nfc=test    # Missing QR
    rfid      qr=test      nfc=test    # Missing RFID
    nfc       qr=test      rfid=test    # Missing NFC

Edge Case: Create Barrel Invalid Data Types
    [Documentation]    The test checks if the API returns 400 for invalid data types
    ${invalid_body}=    Create Dictionary    qr=123    rfid=${456}    nfc=${true}    # Invalid data types
    ${response}=    Create Barrel With Body    ${invalid_body}    # Create a barrel with invalid data types
    Should Be Equal As Strings    ${response.status_code}    400    # Check if the response status code is 400
    Should Contain    ${response.json()["detail"]}    Validation error    # Check if the response contains the error message

Edge Case: Create Barrel Duplicate QR Code
    [Documentation]    The test checks if the API returns 409 for a duplicate QR code
    ${TIMESTAMP}=    Get Time    epoch    # Get the current timestamp
    ${qr}=    Set Variable    unique-qr-${TIMESTAMP}    # Create a unique QR code
    Create Barrel    ${qr}    rfid1    nfc1    # Create a barrel with the unique QR code
    ${response}=    Create Barrel    ${qr}    rfid2    nfc2    # Create a barrel with the same QR code
    Should Be Equal As Strings    ${response.status_code}    409    # Check if the response status code is 409
    Should Contain    ${response.json()["detail"]}    already exists    # Check if the response contains the error message

Edge Case: Get Non-Existent Barrel
    [Documentation]    The test checks if the API returns 404 for a non-existent barrel
    ${response}=    Get Barrel By ID    999999    # Get a non-existent barrel
    Should Be Equal As Strings    ${response.status_code}    404    # Check if the response status code is 404
    Should Contain    ${response.json()["detail"]}    not found    # Check if the response contains the error message

Edge Case: Get Barrel Invalid ID Format
    [Documentation]    The test checks if the API returns 422 for an invalid ID format
    [Template]    Test Invalid ID Format    # Test invalid ID format        
    invalid_id_123    # Invalid ID format
    -123    # Negative ID
    12.34    # Floating point ID

Edge Case: Delete Non-Existent Barrel
    [Documentation]    The test checks if the API returns 404 for a non-existent barrel
    ${response}=    Delete Barrel    999999    # Delete a non-existent barrel
    Should Be Equal As Strings    ${response.status_code}    404    # Check if the response status code is 404

Edge Case: Delete Barrel Invalid ID Format
    [Documentation]    The test checks if the API returns 422 for an invalid ID format
    [Template]    Test Invalid ID Format For Delete    # Test invalid ID format for delete
    invalid_id_456    # Invalid ID format
    -456    # Negative ID
    56.78    # Floating point ID

Edge Case: Create Barrel Max Field Lengths
    [Documentation]    The test checks if the API accepts the maximum field lengths
    ${long_string}=    Generate Long String    500    # Generate a long string
    ${response}=    Create Barrel    ${long_string}    ${long_string}    ${long_string}    # Create a barrel with the long string
    Should Be Equal As Strings    ${response.status_code}    201    # Check if the response status code is 201

Edge Case: Create Barrel Special Characters
    [Documentation]    The test checks if the API accepts special characters
    ${response}=    Create Barrel    qr-!@#$%^    rfid-&*()_    nfc-ěščřžý    # Create a barrel with special characters
    Should Be Equal As Strings    ${response.status_code}    201    # Check if the response status code is 201
    Validate Barrel Response    ${response}    # Validate the response


