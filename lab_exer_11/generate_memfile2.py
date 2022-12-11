def main():
    memfile2 = open('memfile2.mem', 'w')
    hex_data = []

    for input in range(64):
        hex_num = extend_to_32bit_hex(remove_0x(hex(input * 2)))
        hex_data.append(hex_num + '\n')

    print(hex_data)

    memfile2.writelines(hex_data)
    memfile2.close()


def extend_to_32bit_hex(hex_num):
    new_hex_num = hex_num
    while len(new_hex_num) != 8:
        new_hex_num = '0' + new_hex_num

    return new_hex_num


def remove_0x(hex_num):
    return hex_num[2:]


if __name__ == '__main__':
    main()
