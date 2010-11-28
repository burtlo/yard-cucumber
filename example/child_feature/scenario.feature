@scenarios
Feature: Scenario
  As a reader of the documentation I expect that scenario are documented correctly

  Background:
    Given this background step

  @first
  Scenario: No Step Scenario

  @second
  Scenario: Scenario With Steps
    Given this first step
	When this second step
	Then this third step
	
  @third @optional_parameters
  Scenario: Optional Parameter Step Definition
    # This step definition has some optional parameters
    Given a project
    And an inactive project
    And a project with the name 'optional', start date 10/26/2010, nicknamed 'norman'

  @fourth @highlight
  Scenario: Matched Term Highlighting
    Given a duck that has a bill
    Then I expect the duck to quack

  @fifth @table
  Scenario: Scenario With Table
    Given the following table:
      | column 1 | column 2 | column 3 |
      | value 1  | value 2  | value 3  |

  @sixth @text
  Scenario: Scenario With Text
    Given the following text:
    """
      Oh what a bother!
    """

  # Comments before the scenario
  @seventh @comments
  Scenario: Scenario with comments and a description
    There once was a need for information to be displayed alongside all the
    entities that I hoped to test
    # First Comment
    Given this first step
    # Second Comment
    And this second step
    # Third Comment
    And this third step
    # Comments after the last step, where do they go?

