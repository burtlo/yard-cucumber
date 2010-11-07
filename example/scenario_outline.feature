@scenario_outlines @bvt
Feature: Scenario Outline
  As a reader of the documentation I expect that scenario outlines are documented correctly

  @first
  Scenario Outline: Three Examples
    Given that <Customer> is a valid customer
    And that the product, named '<Product>', is a valid product
    When the customer has purchased the product
    Then I expect the customer to be a member of the '<Product>' group

    Examples:
     | Customer   | Product   |
     | Customer A | Product A |
     | Customer A | Product B |
     | Customer A | Product C |

  @second
  Scenario Outline: Step contains a text block
    Given the following text:
    """
    The <noun> jumped over the <place>
    """
    When I click on an example row
 	Then I expect <noun> to be replaced by the example noun
    And I expect <place> to be replaced by the example place
    
    Examples:
     | noun  | place |
     | cow   | moon  |
     | horse | spoon |

  @third
  Scenario Outline: Step contains a table
    Given the following table:
      | name   | price   | quantity |
      | <name> | <price> | 100000   |
    When I click on an example row
 	Then I expect <name> to be replaced by the example name
    And I expect <price> to be replaced by the example price

    Examples:
     | name | price |
     | toy  | $99   |
     | game | $49   |

  @fourth
  Scenario Outline: Step contains a table; table header uses an example
    Given the following table:
      | name   | <denomination> | quantity |
      | <name> | <price>        | 100000   |
	When I click on an example row
 	Then I expect <name> to be replaced by the example name
    And I expect <price> to be replaced by the example price
    And I expect <denomination> to be replaced by the example denomination

    Examples:
     | name | price | denomination    |
     | toy  | 99    | cost in euros   |
     | game | 49    | cost in dollars |