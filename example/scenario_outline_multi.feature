Feature: My Feature

Scenario Outline: Multiple Example Table
  Given that <Customer> is a valid customer
  And that the product, named '<Product>', is a valid product
  When the customer has purchased the product
  Then I expect the customer to be a member of the '<Product>' group

  Examples: Example group A
   | Customer   | Product   |
   | Customer A | Product A |

  Examples: Example group B
   | Customer   | Product   |
   | Customer B | Product A |