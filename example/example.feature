@customer
Feature: Customer Login
  As a customer of the product I am able to login as myself

  Background:
    Given this undefined step definition

  @bvt
  Scenario: Customer with valid login is able to log ing
    Given that a customer is a valid customer
    When a customer logs in as username 'frank' with password 'default'
    Then I expect them to have logged in successfully

