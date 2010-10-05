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

  Scenario: Customers with a complete profile are allowed to post
    Given that a customer is a valid customer
    And the customer has the following details:
      | Name  | Email       | Age |
      | Frank | f@email.com | 22  | 
    When a customer logs in as username 'frank' with password 'default'
	And visits the customer update page
	Then I expect the customer is able able to post to their profile
	
  @product
  Scenario Outline: Customers that bought a product are included in their product groups
    Given that <Customer> is a valid customer
    And that the product, named '<Product>', is a valid product
    When the customer has purchased the product
    Then I expect the customer to be a member of the '<Product>' group

    Examples:
     | Customer   | Product   |
     | Customer A | Product A |
     | Customer A | Product B |
     | Customer A | Product C |
