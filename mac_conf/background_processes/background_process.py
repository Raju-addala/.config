#!/usr/bin/env python3
import time
import logging
from datetime import datetime
from pathlib import Path

# Set up logging to ~/.my_config/process.log (expand and create parent only if needed)
LOG_PATH = Path.home() / '.my_config' / 'process.log'
if not LOG_PATH.parent.exists():
    LOG_PATH.parent.mkdir(parents=True, exist_ok=True)

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(message)s',
    filename=str(LOG_PATH)
)

def main():
    while True:
        current_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        logging.info(f"Background process is running at {current_time}")
        time.sleep(60)  # Wait for 60 seconds before next iteration

if __name__ == "__main__":
    logging.info("Background process started")
    main()