from django.db import models

class Book(models.Model):
    """
    A model representing a book.
    """
    # Fields
    title = models.CharField(max_length=200, help_text="The title of the book.")
    description = models.TextField(blank=True, help_text="A brief description of the book.")
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    # Metadata
    class Meta:
        ordering = ('-created_at',)

    # Methods
    def __str__(self):
        """
        Returns a string representation of the model.
        """
        return self.title
