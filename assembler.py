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


def preprocess(lines):
    processed_lines = []
    for line in lines:
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
    assembled_lines = []
    for line in lines:
        # Split the line into an array of operands
        operands = line.split(' ')

        # operands[0] --> OP Code
        if len(operands) == 1:
            # Append the OP Code + 11 Bits to the assembled lines
            assembled_lines.append(op_codes[operands[0]] + "00000000000\n")

        # operands[1] may be either Rdst or Interrupt Index
        elif len(operands) == 2:
            if operands[0] == "INT":
                # Convert the interrupt's index from decimal to binary
                index = '{0:02b}'.format(int(operands[1]))

                # Append the OP Code + Index + 9 Bits to the assembled lines
                assembled_lines.append(
                    op_codes[operands[0]] + index + "000000000\n")
            else:
                # Append the OP Code + Rdst Address + 8 Bits to the assembled lines
                assembled_lines.append(
                    op_codes[operands[0]] + registers[operands[1]] + "00000000\n")

        elif len(operands) == 3:
            if (operands[0] == "MOV"):
                assembled_lines.append(
                    op_codes[operands[0]] + registers[operands[1]] + registers[operands[2]] + "00000\n")
            else:
                assembled_lines.append(
                    op_codes[operands[0]] + registers[operands[1]] + "00000000\n")
                assembled_lines.append(operands[2] + '\n')
    return assembled_lines


if __name__ == '__main__':
    if len(sys.argv) < 2 or len(sys.argv) > 3:
        print("Invalid command")
        print("python assembler.py <inputfile> <outputfile>[OPTIONAL]")
        sys.exit(1)
    else:
        input_file = open(sys.argv[1], 'r')
        lines = input_file.readlines()
        input_file.close()

        lines = preprocess(lines)
        lines = assemble(lines)

        output_file = sys.argv[2] if len(sys.argv) == 3 else "instruction.mem"
        output_file += ".mem" if output_file.find(".mem") == -1 else ""
        output_file = open(output_file, 'w')
        output_file.write(
            '// instance=/fetch_stage/y/addressing_instruction\n')
        output_file.write(
            '// format=mti addressradix=h dataradix=b version=1.0 wordsperline=1\n')
        for i in range(len(lines)):
            output_file.write(f'{hex(i)[2:]}: {lines[i]}')
        output_file.close()
