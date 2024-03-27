from setuptools import find_packages, setup

requirements = []
# requirements = [
#     line.strip()
#     for line in open('requirements.txt').readlines()
# ]

setup(
    name="instagrapi",
    version="2.0.4",
    author="Mark Subzeroid",
    author_email="143403577+subzeroid@users.noreply.github.com",
    license="MIT",
    url="https://github.com/subzeroid/instagrapi",
    install_requires=requirements,
    keywords=[
        "instagram private api",
        "instagram-private-api",
        "instagram api",
        "instagram-api",
        "instagram",
        "instagram-scraper",
        "instagram-client",
        "instagram-stories",
        "instagram-feed",
        "instagram-reels",
        "instagram-insights",
        "downloader",
        "uploader",
        "videos",
        "photos",
        "albums",
        "igtv",
        "reels",
        "stories",
        "pictures",
        "instagram-user-photos",
        "instagram-photos",
        "instagram-metadata",
        "instagram-downloader",
        "instagram-uploader",
        "instagram-note",
    ],
    description="Fast and effective Instagram Private API wrapper",
    long_description=open('README.md').read(),
    long_description_content_type="text/markdown",
    packages=find_packages(),
    python_requires=">=3.9",
    include_package_data=True,
    classifiers=[
        "Development Status :: 4 - Beta",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: MIT License",
        "Topic :: Software Development :: Libraries :: Python Modules",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
    ],
)



requests<3.0,>=2.25.1
PySocks==1.7.1
pydantic==2.5.3
pycryptodomex==3.20.0
