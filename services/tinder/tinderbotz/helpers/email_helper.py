import smtplib
from email.message import EmailMessage
from getpass import getpass

class EmailHelper:
    @staticmethod
    def send_mail_match_found(to):
        match_msg = "Congratulations you've been matched with someone. Please check your profile for more details."

        msg = EmailMessage()
        msg.set_content(match_msg)

        msg["Subject"] = "NEW TINDER MATCH"
        msg["From"] = "your-email@gmail.com"
        msg["To"] = to

        # Send the message via our own SMTP server.
        server = smtplib.SMTP_SSL("smtp.gmail.com", 465)
        server.login(msg["From"], getpass("Enter your email password: "))
        server.send_message(msg)
        server.quit()

if __name__ == "__main__":
    to_email = input("Enter the recipient's email address: ")
    EmailHelper.send_mail_match_found(to_email)
