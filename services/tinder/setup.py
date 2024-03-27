from setuptools import setup

setup(
    name="tinderbotz",
    version="1.6",
    description="Tinder automated bot and data scraper",
    url="https://github.com/frederikme/TinderBotz",
    author="Frederik Mees",
    author_email="frederik.mees@gmail.com",
    license="MIT",
    packages=["tinderbotz"],
    install_requires=["selenium", "webdriver-manager"],
    python_requires=">=3.6",
    classifiers=[
        "Development Status :: 3 - Alpha",
        "Intended Audience :: Developers",
        "Topic :: Software Development :: Build Tools",
        "License :: OSI Approved :: MIT License",
        "Programming Language :: Python :: 3",
    ],
)


setup(
    # ...
    packages=["tinderbotz"],
    package_data={
        "tinderbotz": ["data/*.txt"],
    },
    # ...
)
