*** Variables ***
# Basic configuration
# BASE_URL is set via an environment variable, allowing tests to be configured per environment.
${BASE_URL}               %BASE_URL%    # Base URL for the API

# API Endpoints
${BARRELS_ENDPOINT}       ${BASE_URL}/barrels    # Barrels endpoint
${MEASUREMENTS_ENDPOINT}  ${BASE_URL}/measurements    # Measurements endpoint

# Global variables to store IDs of entities created during tests.
# They are initialized to ${None} in case they have not been set yet.
# ${CREATED_BARREL_ID} is used in barrel-related tests.
# ${CREATED_MEASUREMENT_ID} is reserved for measurement-related tests and future cleanup tasks.
${CREATED_BARREL_ID}      ${None}    # ID of the created barrel
# ${CREATED_MEASUREMENT_ID}     ${None}    # ID of the created measurement