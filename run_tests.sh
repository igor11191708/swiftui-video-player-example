#!/bin/bash

# Load configurations from YAML file
# You’ll need a way to read and parse the YAML file from your script. While bash itself does not support parsing YAML natively, you can use a command-line tool like yq (a lightweight and portable command-line YAML processor).
# brew install yq

# Before you can run the script, you need to make it executable:
# chmod +x run_tests.sh

# Now, you can run your script from the command line:
# ./run_tests.sh

CONFIG_FILE="test_config.yml"
echo "Looking for config file at: $PWD/$CONFIG_FILE"
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Config file not found: $CONFIG_FILE"
  exit 1
fi

# Load configurations from YAML file
PROJECT=$(yq e '.test_config.project' $CONFIG_FILE)
SCHEME=$(yq e '.test_config.scheme' $CONFIG_FILE)
# Initialize an empty array
DESTINATIONS=()

# Read destinations into the array
while IFS= read -r line; do
  DESTINATIONS+=("$line")
done < <(yq e '.test_config.destinations[]' $CONFIG_FILE)

# Loop through each destination and run tests
echo "Starting test runs..."
for DESTINATION in "${DESTINATIONS[@]}"
do
  echo "Running tests on $DESTINATION"
  xcodebuild test -project "$PROJECT" -scheme "$SCHEME" -destination "$DESTINATION" | xcpretty
done
