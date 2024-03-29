"""
Created by Frederikme (TeetiFM)

This script is meant to be user friendly for beginning users.
Definitly take a look at quickstart.py for more features!
"""

from tinderbotz.session import Session

if __name__ == "__main__":

    # creates instance of session
    session = Session()

    # prompt user for email and password
    email = input("Enter your email: ")
    password = input("Enter your password: ")

    # login using either your facebook account or google account (delete the line of code you don't need)
    session.login_using_facebook(email, password)
    session.login_using_google(email, password)

    while True:
        # prompt user for amount of people to like
        amount = int(input("Enter the number of people you want to like: "))

        # prompt user for like/dislike ratio
        while True:
            ratio = input("Enter the like/dislike ratio (e.g. 75% for 75% like and 25% dislike): ")
            if "%" in ratio:
                break
            else:
                print("Invalid ratio. Please enter a percentage sign (%) to indicate the ratio.")

        # prompt user for sleep time
        sleep = int(input("Enter the number of seconds to wait between swipes: "))

        # spam likes
        session.like(amount=amount, ratio=ratio, sleep=sleep)

        # ask user if they want to continue
        cont = input("Do you want to continue? (yes/no): ")
        if cont
