@customer
Feature: Customer Account
  As a customer of the product I am able to configure settings for my account

  Background:
    Given this third defined step definition
	And the customer has the following details:
      | Name  | Email       | Age |
      | Roger | r@email.com | 22  |

  @bvt
  Scenario: Customer is able to change their password
    Given that a customer that is logged in to the system
    When the customer changes their password to 'lions_tigers_and_bears'
    Then I expect when they login again that it will use this new password

  @wip
  Scenario: Customer cannot change settings if they are not logged in
    Given that a customer is a valid customer
    When the customer visits the account settings page
    Then I expect the customer to be presented with the login page
	
  @wip
  Scenario: Customer cannot change settings if they are not logged in
    Given that a customer that is logged in to the system
	When the customer visits the account settings page
	And edits their the biography to state:
	"""
		I am an avid golfer, spelunker, and designer of clothing for stuffed
		animals.
	"""
    Then I expect the customer to be presented with the login page

