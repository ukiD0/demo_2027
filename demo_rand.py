import random

numbers = list(range(1, 31))
random.shuffle(numbers)

print("Нажмите Enter для выдачи следующего номера стола (или 'q' для выхода)")

for i, number in enumerate(numbers, 1):
    input()
    print(f"Участник {i}: стол №{number}")
    
    if i == 30:
        break