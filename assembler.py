import sys

op_codes = {
    "NOP": "00001",
    "HLT": "00010",
    "SETC": "00011",
    "NOT": "00100",
    "INC": "00101",
    "OUT": "00110",
    "IN": "00111",
    "MOV": "01000",
    "ADD": "01001",
    "SUB": "01010",
    "AND": "01011",
    "IADD": "01100",
    "PUSH": "10000",
    "POP": "10001",
    "LDM": "10010",
    "LDD": "10011",
    "STD": "10100",
    "JZ": "11000",
    "JN": "11001",
    "JC": "11010",
    "JMP": "11011",
    "CALL": "11100",
    "RET": "11101",
    "INT": "11110",
    "RTI": "11111"
}

registers = {
    "R0": "000",
    "R1": "001",
    "R2": "010",
    "R3": "011",
    "R4": "100",
    "R5": "101",
    "R6": "110",
    "R7": "111"
}


def hexToBinary(hex_num):
    hex_as_int = int(hex_num, 16)
    binary_num = bin(hex_as_int)
    binary_num = binary_num[2:].zfill(16)

    return binary_num


def preprocess(lines):
    processed_lines = []
    for line in lines:
        # Find the beginning of a comment in the line
        commentIndex = line.find('#')

        # If there is a comment in the line, remove it
        if commentIndex != -1:
            line = line[:commentIndex]

        # Strip the line from white space before and after it
        line = line.strip()

        # If the line is empty, skip it
        if line == "":
            continue

        # Replace commas with spaces
        line = line.replace(', ', ' ').replace(',', ' ')

        # Convert the line to upper case
        line = line.upper()

        # Remove any paranthesis
        line = line.replace('(', ' ').replace(')', '')

        # Add to the processed lines
        processed_lines.append(line)

    return processed_lines


def assemble(lines):
    assembled_lines = {}
    is_org = False
    address = None
    x = 0

    for line in lines:
        temp_lines = []
        # Split the line into an array of operands
        operands = line.split(' ')
        if operands[0] == ".ORG":
            address = operands[1].lower()
            is_org = True
            continue

        if is_org and x < 5:
            assembled_lines[address] = hexToBinary(operands[0])
            address = hex(int(address, 16) + 1)[2:]
            assembled_lines[address] = hexToBinary("0000")
            is_org = False
            x += 1
            continue

        # operands[0] --> OP Code
        if len(operands) == 1:
            # Append to the assembled lines the OP Code + 11 Bits
            temp_lines.append(op_codes[operands[0]] + "00000000000")

        # operands[1] may be either Rdst or Interrupt Index
        elif len(operands) == 2:
            if operands[0] == "INT":
                # Convert the interrupt's index from decimal to binary
                index = '{0:02b}'.format(int(operands[1]))

                # Append to the assembled lines the OP Code + Index + 9 Bits
                temp_lines.append(
                    op_codes[operands[0]] + index + "000000000")
            else:
                # Append to the assembled lines the OP Code + Rsrc Address + 2 Bits + Rdst Address + 2 Bits
                temp_lines.append(
                    op_codes[operands[0]] + registers[operands[1]] + "000" + registers[operands[1]] + "00")

        elif len(operands) == 3:
            if (operands[0] == "MOV"):
                temp_lines.append(
                    op_codes[operands[0]] + registers[operands[1]] + "000" + registers[operands[2]] + "00")
            else:
                temp_lines.append(
                    op_codes[operands[0]] + registers[operands[1]] + "00000000")
                temp_lines.append(hexToBinary(operands[2]))

        elif len(operands) == 4:
            if (operands[0] == "ADD" or operands[0] == "SUB" or operands[0] == "AND"):
                temp_lines.append(
                    op_codes[operands[0]] + registers[operands[2]] + registers[operands[3]] + registers[operands[1]] + "00")
            elif operands[0] == "IADD":
                temp_lines.append(
                    op_codes[operands[0]] + registers[operands[1]] + "000" + registers[operands[2]] + "00")
                temp_lines.append(hexToBinary(operands[3]))
            else:
                temp_lines.append(
                    op_codes[operands[0]] + registers[operands[1]] + "000" + registers[operands[3]] + "00")
                temp_lines.append(hexToBinary(operands[2]))

        for line in temp_lines:
            assembled_lines[address] = line
            address = hex(int(address, 16) + 1)[2:]

    return assembled_lines


def readInputFile():
    input_file = open(sys.argv[1], 'r')
    lines = input_file.readlines()
    input_file.close()

    return lines


def writeOutputFile(lines):
    output_file = sys.argv[2] if len(sys.argv) == 3 else "instruction.mem"
    output_file += ".mem" if output_file.find(".mem") == -1 else ""
    output_file = open(output_file, 'w')
    output_file.write(
        '// instance=/fetch_stage/y/addressing_instruction\n')
    output_file.write(
        '// format=mti addressradix=h dataradix=b version=1.0 wordsperline=1\n')
    length = len(list(lines.keys())[-1])
    for address in lines:
        output_file.write(f'{address.zfill(length)}: {lines[address]}\n')
    output_file.close()


def print_lines(lines):
    for address in lines:
        print(address, lines[address])


if __name__ == '__main__':
    if len(sys.argv) < 2 or len(sys.argv) > 3:
        print("Invalid command")
        print("python assembler.py <inputfile> <outputfile>[OPTIONAL]")
        sys.exit(1)
    else:
        lines = readInputFile()

        lines = preprocess(lines)
        lines = assemble(lines)

        # print_lines(lines)

        writeOutputFile(lines)
