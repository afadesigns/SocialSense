def add_numbers(a, b):
  return a + b

def subtract_numbers(a, b):
  return a - b

def multiply_numbers(a, b):
  return a * b

def divide_numbers(a, b):
  return a / b

result = add_numbers(5, 3)
print(result)

result = subtract_numbers(5, 3)
print(result)

result = multiply_numbers(5, 3)
print(result)

result = divide_numbers(5, 3)
print(result)


def perform_operation(a, b, operation):
  if operation == 'add':
    return a + b
  elif operation == 'subtract':
    return a - b
  elif operation == 'multiply':
    return a * b
  elif operation == 'divide':
    return a / b
  else:
    raise ValueError(f"Invalid operation: {operation}")

operations = ['add', 'subtract', 'multiply', 'divide']
numbers =
