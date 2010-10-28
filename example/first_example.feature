@feature @bvt
Feature: Feature File
  As a product owner it is important for me to be able to view a feature file through
  an interface which is easily accessible.  A feature's description appears along side
  the comments for the feature.

  Background:
    Given this first background step

  @bvt
  Scenario: First Scenario
    Given this first scenario step
    When this is parsed with Cucumber-In-The-YARD
    Then I expect that each step is highlighted and matched to a step definition 

  Scenario: Second Scenario
    Given this first scenario step
    When this is parsed with Cucumber-In-The-YARD
    Then I expect that this scenario is present