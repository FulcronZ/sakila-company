from setuptools import find_packages, setup

setup(
    name="sakila_etl",
    packages=find_packages(exclude=["sakila_etl_tests"]),
    install_requires=["dagster", "dagster-cloud"],
    extras_require={"dev": ["dagster-webserver", "pytest"]},
)
