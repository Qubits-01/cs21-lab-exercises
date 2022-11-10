import asyncio
import os
import subprocess
import time
from colorama import Fore


async def main():
    print(Fore.BLUE + 'READING TEST CASES MASTER LIST FILE...\n')

    test_cases_master_list_file = open('test_cases_master_list.txt', 'r')
    test_cases_master_list_lines = test_cases_master_list_file.readlines()
    test_cases_master_list_file.close()

    # print(test_cases_master_list_lines)
    # print(len(test_cases_master_list_lines))

    temp_input_file = open('temp_input.txt', 'w')
    # temp_output_data_file = open('temp_output_data.txt', 'w+')
    test_case_num = 1

    for i in range(0, len(test_cases_master_list_lines), 10):
        print(Fore.GREEN + f'Test Case {test_case_num}: ', end='')

        # Read the board state.
        temp_input = []
        for j in range(1, 8):
            temp_input.append(test_cases_master_list_lines[i + j])
            temp_input_file.writelines(temp_input)

        # Read the expected output (YES or NO).
        expected_output = test_cases_master_list_lines[i + 8].strip()
        # print('expected output:', expected_output)

        # print(f'{test_case_num}. {temp_input}')
        # print(temp_output)

        # Run MIPS code through Mars' CLI.
        command = 'java -jar Mars4_5.jar p sm nc cs21project1C.asm < input.txt'
        starting_time = time.time()
        p = subprocess.Popen(command, stdout=subprocess.PIPE, shell=True)
        (output, err) = p.communicate()
        p_status = p.wait()
        print('outptut', output)
        execution_time = time.time() - starting_time

        # Read the first line of temp_output_data.txt.
        temp_output_data_file = open('temp_output_data.txt', 'r')
        actual_output = temp_output_data_file.readline().strip()
        temp_output_data_file.close()
        # print('actual output:', actual_output)

        if execution_time > 10:
            print(Fore.RED + f'FAILED | ? {actual_output} | TLE ({execution_time} s)')
        elif actual_output != expected_output:
            print(Fore.RED + f'FAILED | WA ({actual_output}) | {execution_time} s')
        else:
            print(Fore.LIGHTGREEN_EX + f'PASSED | {actual_output} | {execution_time} s')

        print('expected output:', expected_output)
        print('actual output:', actual_output)







        test_case_num += 1

    print(Fore.BLUE + '\nCLEANING UP...\n')
    temp_input_file.close()
    os.remove('temp_input.txt')
    # temp_output_data_file.close()
    # os.remove('temp_output_data.txt')


if __name__ == '__main__':
    asyncio.run(main())
