"""
Created by Frederikme (TeetiFM)

This script is meant to be user-friendly for beginning users.
Definitely take a look at quickstart.py for more features!
"""

from tinderbotz.session import Session

if __name__ == "__main__":

    # creates instance of session
    session = Session()

    # prompt user to enter email and password
    email = input("Enter your email: ")
    password = input("Enter your password: ")

    # check if both email and password are entered
    if not email or not password:
        print("Please enter both email and password.")
        exit()

    # prompt user to choose login method
    print("Choose login method:")
    print("1. Facebook")
    print("2. Google")
    method = input("Enter the number of your choice: ")

    # login using either Facebook or Google
    if method == "1":
        session.login_using_facebook(email, password)
    elif method == "2":
        session.login_using_google(email, password)
    else:
        print("Invalid choice. Please choose either 1 or 2.")
        exit()

    # warn user that the script will start liking profiles automatically
    print("Warning: The script will start liking profiles automatically.")

    # spam likes
    # amount   -> amount of people you want to like
    # ratio    -> chance of liking/disliking
    # sleep    -> amount of seconds to wait before swiping again
    session.like(amount=100, ratio="72.
