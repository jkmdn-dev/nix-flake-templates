#!/usr/bin/env python3

# MIT License
#
# Author: Joakim Paulsson
# email: jkmdn@proton.me

# See: https://stackoverflow.com/questions/16294819/check-if-my-python-has-all-required-packages/45474387#45474387

"""Test availability of required packages."""

from pathlib import Path
import unittest

from pkg_resources import parse_requirements, require

_REQUIREMENTS_FILE: Path = Path(__file__).parent.with_name("requirements.txt")


class TestRequirements(unittest.TestCase):
    """Test availability of required packages."""

    def setUp(self) -> None:
        """Set up test."""

        self.open_req_file = _REQUIREMENTS_FILE.open()

    def tearDown(self) -> None:
        """Tear down test."""

        self.open_req_file.close()

    def test_requirements(self) -> None:
        """Test that each requirement is available."""

        self.assertTrue(_REQUIREMENTS_FILE.exists())

        requirements = parse_requirements(self.open_req_file)
        for requirement in requirements:
            requirement = str(requirement)

            with self.subTest(requirement=requirement):
                require(requirement)


if __name__ == "__main__":
    unittest.main()
