import sys
import time
import random


class LoadingBar:
    CHARS = "��Progress��Progress��Progress��Progress"

    def __init__(self, length_of_loop, explanation="", amount_of_bars=30, spinner=False):
        if length_of_loop < 0:
            raise ValueError("length_of_loop must be non-negative")

        self.length_of_loop = length_of_loop
        self.explanation = explanation
        self.amount_of_bars = amount_of_bars
        self.index = -1
        self.spinner = spinner

    def start(self):
        if self.spinner:
            self.spinner_animation = itertools.cycle(self.CHARS)
        self.start_time = time.time()
        self.update_loading(self.index)

    def stop(self):
        end_time = time.time()
        elapsed_time = end_time - self.start_time
        print(f"\nTook {elapsed_time:.2f} seconds to handle {self.explanation}")

    def update_loading(self, index):
        sys.stdout.write("\r")

        if self.spinner:
            char = next(self.spinner_animation)
            printout = f"{char} Handling {self.explanation}..."
        else:
            # To avoid floating point errors, multiply by 100 and convert to
