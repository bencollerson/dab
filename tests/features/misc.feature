Feature: Docker entrypoint wrapper script works
	The main dab entrypoint is actually a small posix complient shell script
	that wraps docker and starts a container using the dab image for you.

	This script is designed to be lightweight and portable and should rarely be
	updated as the rest of the code for dab lives inside the image.

	Scenario: Can execute dab with no parameters and get usage info
		When I run `dab`

		Then it should fail with "Usage:"

	Scenario: Can execute dab with -h and get usage info
		When I run `dab -h`

		Then it should pass with "Usage:"

	Scenario: Warns user when wrapper is out of date with image wrapper
		Given I successfully run `dab -h`
		And the output should not contain:
		"""
		Dab wrapper script appears to have an update available!
		"""
		And I copy the file "/bin/dab" to "/bin/dab.original"
		And I append to "/bin/dab" with:
		"""
		# simulated change indicating wrapper is out of date
		"""

		When I successfully run `dab -h`

		Then the output should contain:
		"""
		Dab wrapper script appears to have an update available!
		"""
		And I copy the file "/bin/dab.original" to "/bin/dab"

	Scenario Outline: All sub commands groups provide usage information
		Given I run `dab <SUBCOMMAND> --help`
		And it should pass with "Usage:"
		And the output should contain "SUBCOMMAND"

		When I run `dab <SUBCOMMAND> -h`
		And it should pass with "Usage:"
		And the output should contain "SUBCOMMAND"

		Then I run `dab <SUBCOMMAND> help`
		And it should pass with "Usage:"
		And the output should contain "SUBCOMMAND"

		Examples:
			| SUBCOMMAND          |
			| config              |
			| network             |
			| repo                |
			| repo entrypoint     |
			| repo entrypoint set |
			| repo group          |
			| tools               |

	Scenario Outline: All sub commands provide usage information
		Given I run `dab <SUBCOMMAND> --help`
		And it should pass with "Usage:"

		When I run `dab <SUBCOMMAND> -h`
		And it should pass with "Usage:"

		Then I run `dab <SUBCOMMAND> help`
		And it should pass with "Usage:"

		Examples:
			| SUBCOMMAND                  |
			| config add                  |
			| config get                  |
			| config keys                 |
			| config set                  |
			| network destroy             |
			| network shell               |
			| repo add                    |
			| repo clone                  |
			| repo entrypoint set command |
			| repo entrypoint set script  |
			| repo entrypoint start       |
			| repo entrypoint stop        |
			| repo fetch                  |
			| repo group repo             |
			| repo group start            |
			| repo group tool             |
			| repo group update           |
			| repo require                |
			| shell                       |
			| tools address               |
			| tools destroy               |
			| tools exec                  |
			| tools list                  |
			| tools logs                  |
			| tools restart               |
			| tools run                   |
			| tools start                 |
			| tools stop                  |
			| tools update                |
			| update                      |
