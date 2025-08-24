FROM rust:1.75-slim

WORKDIR /app

# Install dependencies
RUN apt-get update && \
    apt-get install -y git build-essential python3 python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip3 install difflib

# Copy project files
COPY . .

# Restore Cargo.toml to a working version
RUN echo '[package]' > Cargo.toml && \
    echo 'name = "solidity_to_multiversx"' >> Cargo.toml && \
    echo 'version = "0.1.0"' >> Cargo.toml && \
    echo 'edition = "2021"' >> Cargo.toml && \
    echo '' >> Cargo.toml && \
    echo '[dependencies]' >> Cargo.toml && \
    echo 'solang-parser = "0.3.3"' >> Cargo.toml && \
    echo 'multiversx-sc = "0.42.0"' >> Cargo.toml && \
    echo 'multiversx-sc-derive = "0.42.0"' >> Cargo.toml && \
    echo 'anyhow = "1.0.75"' >> Cargo.toml && \
    echo 'clap = { version = "4.4.18", features = ["derive"] }' >> Cargo.toml && \
    echo 'pest = "2.7.5"' >> Cargo.toml && \
    echo 'pest_derive = "2.7.5"' >> Cargo.toml && \
    echo 'serde = { version = "=1.0", features = ["derive"] }' >> Cargo.toml && \
    echo 'serde_json = "=1.0"' >> Cargo.toml && \
    echo 'convert_case = "=0.6"' >> Cargo.toml && \
    echo 'regex = "1.11.1"' >> Cargo.toml && \
    echo 'Inflector = "0.11"' >> Cargo.toml

# Run the test script
CMD ["python3", "test_script.py"] 