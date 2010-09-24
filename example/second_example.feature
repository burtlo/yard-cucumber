@customer
Feature: Customer Logout Feature
  As a customer of the product I am able to logout

  Background:
    Given this undefined step definition

  @bvt
  Scenario: Customer that is logged in is able to log out
    Given that a customer is a valid customer
    And a customer logs in as username 'frank' with password 'default'
    And I expect them to have logged in successfully
    When the customer logs out
	Then I expect the customer to be shown the logout page

