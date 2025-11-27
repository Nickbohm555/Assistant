import os
import sys
import json


def hello_world(unused_param):
    message = "Hello, World!"  # Missing spaces around =
    unused_var = 42  # Missing spaces
    print(message)
    undefined_var = undefined_function()
    result = x + y  # Missing spaces around operators
    return message


def missing_return_type(x, y):  # Missing space after comma
    result = x + y  # Missing spaces
    print(result)
    bad_indent = "wrong"  # Inconsistent spacing


if __name__ == "__main__":  # Missing spaces around ==
    hello_world()  # Missing required argument
    missing_return_type(1, 2)  # Missing space after comma
    print(undefined_global)
    x = 1 + 2 * 3  # Missing spaces around operators
    y = 1 + 2  # Inconsistent spacing
