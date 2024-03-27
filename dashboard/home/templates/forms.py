from django import forms
from django.contrib.auth.forms import (
    UserCreationForm,
    AuthenticationForm,
    PasswordChangeForm,
    UsernameField,
    PasswordResetForm,
    SetPasswordForm,
)
from django.contrib.auth.models import User
from django.utils.translation import gettext_lazy as _


class RegistrationForm(UserCreationForm):
    password1 = forms.CharField(
        label=_("Password"),
        widget=forms.PasswordInput(
            attrs={
                "class": "form-control",
                "placeholder": "Password",
                "required": True,
                "autofocus": "autofocus",
            }
        ),
    )
    password2 = forms.CharField(
        label=_("Confirm Password"),
        widget=forms.PasswordInput(
            attrs={
                "class": "form-control",
                "placeholder": "Confirm Password",
                "required": True,
            }
        ),
    )

    class Meta:
        model = User
        fields = (
            "username",
            "email",
        )

        widgets = {
            "username": forms.TextInput(
                attrs={
                    "class": "form-control",
                    "placeholder": "Username",
                    "required": True,
                }
            ),
            "email": forms.EmailInput(
                attrs={
                    "class": "form-control",
                    "placeholder": "example@company.com",
                    "required": True,
                }
            ),
        }


class LoginForm(AuthenticationForm):
    username = UsernameField(
        label=_("Your Username"),
        widget=forms.TextInput(
            attrs={
                "class": "form-control",
                "placeholder": "Username",
                "required": True,
            }
        ),
    )
    password = forms.CharField(
        label=_("Your Password"),
        strip=False,
        widget=forms.PasswordInput(
            attrs={
                "class": "form-control",
                "placeholder": "Password",
                "required": True,
                "autocomplete": "current-password",
            }
        ),
    )


class UserPasswordResetForm(PasswordResetForm):
    email = forms.EmailField(
        widget=forms.EmailInput(
            attrs={
                "class": "form-control",
                "placeholder": "Email",
                "required": True,
                "autocomplete": "email",
            }
        )
    )


class UserSetPasswordForm(SetPasswordForm):
    new_password1 = forms.CharField(
        max_length=50,
        widget=forms.PasswordInput(
            attrs={
                "class": "form-control",
                "placeholder": "New Password",
                "required": True,
            }
        ),
        label="New Password",
        help_text=_(
            "Enter a new password that is at least 8 characters long. "
            "Your new password can't be too similar to your old password. "
            "Your new password must contain at least 1 uppercase letter, 1 lowercase letter, 1 number and 1 special character."
        ),
    )
    new_password2 = forms.CharField(
        max_length=50,
        widget=forms.PasswordInput(
            attrs={
                "class": "form-control",
                "placeholder": "Confirm New Password",
                "required": True,
            }
        ),
        label="Confirm New Password",
        help_text=_(
            "Enter the same new password you entered before, for verification."
        ),
    )


class UserPasswordChangeForm(PasswordChangeForm):
    old_password = forms.CharField(
        max_length=50,
        widget=forms.PasswordInput(
            attrs={
                "class": "form-control",
                "placeholder": "Old Password",
                "required": True,
            }
        ),
        label="Old Password",
    )
    new_password1 = forms.CharField(
        max_length=50,
        widget=forms.PasswordInput(
            attrs={
                "class": "form-control",
                "placeholder": "New Password",
                "required": True,
            }
        ),
        label="New Password",
        help_text=_(
            "Enter a new password that is at least 8 characters long. "
            "Your new password can
