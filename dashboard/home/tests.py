# C:\Users\Andreas\Projects\SocialSense\dashboard\home\tests.pyimport os

import os
import sys

import django

# Configure Django settings module
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "core.settings")
django.setup()

import json
import unittest
from unittest.mock import patch
from django.conf import settings

# Import modules from your project
from instagrapi import Client
from instagrapi.exceptions import ReloginAttemptExceeded, TwoFactorRequired
from . import services

# Add the project directory to the Python path if necessary
project_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), "../.."))
if project_dir not in sys.path:
    sys.path.append(project_dir)


# Your test cases follow
class TestServices(unittest.TestCase):
    def setUp(self):
        # Define test session file path
        self.test_session_file_path = os.path.join(
            settings.BASE_DIR, "test_session.json"
        )

    @patch("builtins.open", new_callable=unittest.mock.mock_open)
    def test_save_session_to_file(self, mock_open):
        # Create a mock client
        client = Client()
        client.settings = {"test_setting": "test_value"}

        # Call the function to save session to file
        services.save_session_to_file(client)

        # Check if the file was opened with the correct path
        mock_open.assert_called_once_with(self.test_session_file_path, "w")

        # Check if the session data was dumped to the file
        mock_open.return_value.write.assert_called_once_with(
            json.dumps(client.settings)
        )

    @patch(
        "builtins.open",
        new_callable=unittest.mock.mock_open,
        read_data='{"test_setting": "test_value"}',
    )
    def test_load_session_from_file(self, mock_open):
        # Call the function to load session from file
        client = services.load_session_from_file()

        # Check if the file was opened with the correct path
        mock_open.assert_called_once_with(self.test_session_file_path, "r")

        # Check if the session data was loaded correctly
        self.assertEqual(client.settings, {"test_setting": "test_value"})

    def test_handle_bad_password(self):
        # Create a mock client with a relogin attempt
        client = Client()
        client.relogin_attempt = 1

        with self.assertRaises(ReloginAttemptExceeded):
            services.handle_bad_password(client)

    def test_handle_login_required(self):
        # Create a mock client
        client = Client()

        # Mock the relogin method
        client.relogin = unittest.mock.Mock()

        # Mock the update_client_settings method
        client.update_client_settings = unittest.mock.Mock()

        # Call the function
        services.handle_login_required(client)

        # Check if the relogin method was called
        client.relogin.assert_called_once()

        # Check if the update_client_settings method was called
        client.update_client_settings.assert_called_once()

    def test_handle_challenge_required(self):
        # Create a mock client with last_json containing challenge data
        client = Client()
        client.last_json = {"challenge": {"api_path": "/challenge/"}}

        with self.assertRaises(Client.ClientConnectionError):
            services.handle_challenge_required(client)

    def test_handle_feedback_required(self):
        # Create a mock client with last_json containing feedback message
        client = Client()
        client.last_json = {"feedback_message": "Test feedback message"}

        # Call the function
        services.handle_feedback_required(client)

        # No assertions needed, just check if the function runs without errors

    def test_handle_please_wait_few_minutes(self):
        # Create a mock client
        client = Client()

        # Call the function
        services.handle_please_wait_few_minutes(client)

        # No assertions needed, just check if the function runs without errors

    @patch("builtins.input", return_value="test_verification_code")
    @patch("logging.error")
    def test_get_instagrapi_client_with_2fa(self, mock_logging_error, mock_input):
        # Create a mock client
        client = Client()

        # Mock the login method to raise TwoFactorRequired exception
        def login():
            raise TwoFactorRequired({"two_factor_identifier": "test_identifier"})

        client.login = login

        # Call the function
        result = services.get_instagrapi_client()

        # Check if the input function was called
        mock_input.assert_called_once()

        # Check if the logger.error function was called
        mock_logging_error.assert_called_once()

        # Check if the function returns None
        self.assertIsNone(result)

    @patch("logging.error")
    def test_get_instagrapi_client_with_other_error(self, mock_logging_error):
        # Create a mock client
        _ = Client()  # No need to assign to a variable if not used

        # Call the function
        result = services.get_instagrapi_client()

        # Check if the logger.error function was called
        mock_logging_error.assert_called_once_with(
            "An unexpected error occurred while logging in: Test error"
        )

        # Check if the function returns None
        self.assertIsNone(result)

    @patch("logging.error")
    def test_use_instagrapi_client(self, mock_logging_error):
        # Mock the get_instagrapi_client function
        services.get_instagrapi_client = unittest.mock.Mock(return_value=None)

        # Call the function
        result = services.use_instagrapi_client()

        # Check if the logger.error function was called
        mock_logging_error.assert_called_once()

        # Check if the function returns None
        self.assertIsNone(result)


if __name__ == "__main__":
    unittest.main()
