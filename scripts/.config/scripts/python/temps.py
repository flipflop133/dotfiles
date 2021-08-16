import subprocess
process = subprocess.run(['sensors'],
						stdout=subprocess.PIPE, 
                        universal_newlines=True)
output_list = (process.stdout).splitlines()
# fans
print('fans speeds:')
for i in output_list:
    if "fan" in i:
        print(' '*5 + i)
# acpitz-acpi-0
print('acpitz-acpi-0')
for i in output_list:
    if 'temp1' in i or 'temp2' in i:
        print(' '*5 + i)
# cores temps
print('cores temps')
for i in output_list:
    if 'Core' in i:
        print(' '*5 + i)
