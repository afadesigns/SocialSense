import os


def find_null_bytes(directory):
    affected_files = []
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith(".py"):
                file_path = os.path.join(root, file)
                with open(file_path, "rb") as f:
                    content = f.read()
                if b"\x00" in content:
                    affected_files.append(file_path)
    return affected_files


# Replace 'your_project_directory' with the path to your Django project directory
project_directory = "your_project_directory"
files_with_null_bytes = find_null_bytes(project_directory)

if files_with_null_bytes:
    print("Found null bytes in the following files:")
    for file in files_with_null_bytes:
        print(file)
else:
    print("No files with null bytes were found.")
