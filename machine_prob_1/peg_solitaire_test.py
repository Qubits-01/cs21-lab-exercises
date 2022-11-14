import subprocess
import time
import argparse
from colorama import Fore

test_starting_time = time.time()

parser = argparse.ArgumentParser()
parser.add_argument('-v', '--verbose', help='Shows a detailed view of the test case running.')
parser.add_argument('-i', '--implementation', help='Define what specific implementation was used (will rename the .asm file accordingly).')
args = parser.parse_args()


def main():
    if args.verbose is not None:
        is_verbose = args.verbose.strip().lower() in ['yes', 'y', '1', 'true', 'oo', 'yup', 'wen', 'sige']
    else:
        is_verbose = False

    implementation = 'C'
    if args.implementation is not None:
        implementation = args.implementation.strip().upper()

    print(Fore.BLUE + 'READING TEST CASES MASTER LIST FILE...')
    print(f'Currently testing cs21project1{implementation}.asm file.\n')
    test_cases_master_list_file = open('test_cases_master_list.txt', 'r')
    test_cases_master_list_lines = test_cases_master_list_file.readlines()
    test_cases_master_list_file.close()

    no_of_test_cases = (len(test_cases_master_list_lines) + 1) // 10
    print(f'RUNNING {no_of_test_cases} number of test case/s.')

    test_case_num = 1
    n_successful_test_cases = 0

    for i in range(0, len(test_cases_master_list_lines), 10):
        if is_verbose:
            print(Fore.YELLOW + '==================================================')

        print(Fore.GREEN + f'Test Case {test_case_num}: ', end='')

        # Read the board state.
        temp_input = ''
        for j in range(1, 8):
            temp_input += test_cases_master_list_lines[i + j]

        # Read the expected output (YES or NO).
        expected_output = test_cases_master_list_lines[i + 8].strip()

        # Optional: Display the input.
        if is_verbose:
            test_case_description = test_cases_master_list_lines[i]
            print(test_case_description[test_case_description.index(' '):].strip())
            print(Fore.CYAN + temp_input.strip())
            print(Fore.LIGHTCYAN_EX + 'Expected output: ', end='')
            print(Fore.CYAN + f'{expected_output}\n')

        # Run MIPS code through Mars' CLI
        command = f'java -jar Mars4_5.jar p sm nc cs21project1{implementation}.asm'
        starting_time = time.time()
        p = subprocess.Popen(command, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
        (output, err) = p.communicate(temp_input.encode('utf-8').strip())
        p_status = p.wait()  # Wait for the subprocess to finish.
        execution_time = time.time() - starting_time

        actual_output = output.decode('utf-8')
        yes_or_no = actual_output.strip().split()[0].strip()

        # Optional: Display your output.
        if is_verbose:
            print(Fore.LIGHTCYAN_EX + 'Your output:')
            print(Fore.CYAN + actual_output.strip(), end='\n')

        spacing = ''
        if not is_verbose:
            spacing = ' '
        else:
            print()

        if execution_time > 10:
            is_wrong_answer = True if yes_or_no != expected_output else False
            print(Fore.RED + f'{spacing}FAILED  |  {"WA (" if is_wrong_answer else ""}{yes_or_no}{")" if is_wrong_answer else " "}  |  TLE ({execution_time} s)')
        elif yes_or_no != expected_output:
            print(Fore.RED + f'{spacing}FAILED  |  WA ({yes_or_no})  |  {execution_time} s')
        else:
            if yes_or_no == 'NO':
                yes_or_no = 'NO '

            print(Fore.LIGHTGREEN_EX + f'{spacing}PASSED  |  {yes_or_no}  |  {execution_time} s')
            n_successful_test_cases += 1

        if is_verbose:
            print(Fore.YELLOW + '==================================================\n')

        test_case_num += 1

    print(Fore.BLUE + f'Time elapsed: {time.time() - test_starting_time} s')
    print(f'{n_successful_test_cases} out of {no_of_test_cases} test case/s passed ( {round((n_successful_test_cases / no_of_test_cases) * 100, 2)}% ).')
    print('\nDONE\n')


if __name__ == '__main__':
    main()