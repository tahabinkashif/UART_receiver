import serial

# Configure your serial port
ser = serial.Serial('COM6', 9600)  # Change COM3 & baud rate as needed

while True:
    # Get binary input from user
    binary_str = input("Enter 8-bit binary number (e.g., 10101100 or 'q' to quit): ")

    if binary_str.lower() == 'q':
        break

    # Validate input
    if len(binary_str) != 8 or not all(bit in '01' for bit in binary_str):
        print("Invalid input! Please enter exactly 8 bits (0 or 1).")
        continue

    # Convert binary string to integer
    byte_value = int(binary_str, 2)

    # Send the byte to the FPGA
    ser.write(bytes([byte_value]))
    print(f"Sent byte: {binary_str} (decimal {byte_value})")

ser.close()
