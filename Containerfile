# Use a lightweight base image with bash
FROM docker.io/library/bash:latest

# Set the working directory
WORKDIR /app

# Copy all the project files into the container
COPY . .

# Make the test runner executable
RUN chmod +x run_tests.sh

CMD ["./run_tests.sh"]
