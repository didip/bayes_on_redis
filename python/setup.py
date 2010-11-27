import os
from setuptools import setup

# Utility function to read the README file.
# Used for the long_description.  It's nice, because now 1) we have a top level
# README file and 2) it's easier to type in the README file than to put a raw
# string in below ...
def read(fname):
    return open(os.path.join(os.path.dirname(__file__), fname)).read()

setup(
    name = "bayes_on_redis",
    version = "0.1.9",
    author = "Didip Kerabat",
    author_email = "didipk@gmail.com",
    description = ("bayes_on_redis library provides bayesian classification on a given text similar to many SPAM/HAM filtering technique."),
    license = "haven't decided",
    keywords = "bayesian filter redis",
    url = "https://github.com/didip/bayes_on_redis",
    packages=['bayes_on_redis', 'datasets'],
    package_data = {
        # If any package contains *.txt or *.rst files, include them:
        '': ['*.txt', '*.rst'],
    },
    long_description=read('README.markdown'),
    classifiers=[
        "Development Status :: 3 - Alpha",
    ],
)
