@scenarios
Feature: Step Transforms
  As a developer of the test suite I expect that step transforms are documented correctly

  @first
  Scenario: Step with step transformation
    Given this scenario step
    Then I expect that the step, on the step transformer page, will link to the step transform

  @second
  Scenario: Step Transform uses a constant
    Given this first step
    Then I expect that the step, on the step transformer page, will link to the step transform
