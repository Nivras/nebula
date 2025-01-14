Feature: Match seek by id

  Background: Prepare space
    Given a graph with space named "nba"

  Scenario: basic
    When executing query:
      """
      MATCH (v)
      WHERE id(v) == 'Paul Gasol'
      RETURN v.player.name AS Name, v.player.age AS Age
      """
    Then the result should be, in any order:
      | Name         | Age |
      | 'Paul Gasol' | 38  |
    When executing query:
      """
      MATCH (v)
      WHERE id(v) IN ['James Harden', 'Jonathon Simmons', 'Klay Thompson', 'Dejounte Murray']
      RETURN v.player.name AS Name
      """
    Then the result should be, in any order:
      | Name               |
      | 'James Harden'     |
      | 'Jonathon Simmons' |
      | 'Klay Thompson'    |
      | 'Dejounte Murray'  |

  Scenario: basic logical not
    When executing query:
      """
      MATCH (v)
      WHERE NOT NOT id(v) == 'Paul Gasol'
      RETURN v.player.name AS Name, v.player.age AS Age
      """
    Then the result should be, in any order:
      | Name         | Age |
      | 'Paul Gasol' | 38  |
    When executing query:
      """
      MATCH (v)
      WHERE NOT NOT id(v) IN ['James Harden', 'Jonathon Simmons', 'Klay Thompson', 'Dejounte Murray']
      RETURN v.player.name AS Name
      """
    Then the result should be, in any order:
      | Name               |
      | 'James Harden'     |
      | 'Jonathon Simmons' |
      | 'Klay Thompson'    |
      | 'Dejounte Murray'  |

  Scenario: basic logical and
    When executing query:
      """
      MATCH (v)
      WHERE (NOT NOT id(v) == 'Paul Gasol') AND id(v) IN ['James Harden', 'Jonathon Simmons', 'Klay Thompson', 'Dejounte Murray']
      RETURN v.player.name AS Name
      """
    Then the result should be, in any order:
      | Name |
    When executing query:
      """
      MATCH (v)
      WHERE (NOT NOT id(v) == 'Paul Gasol') AND id(v) IN ['James Harden', 'Jonathon Simmons', 'Klay Thompson', 'Dejounte Murray', 'Paul Gasol']
      RETURN v.player.name AS Name
      """
    Then the result should be, in any order:
      | Name         |
      | 'Paul Gasol' |

  Scenario: basic logical or
    When executing query:
      """
      MATCH (v)
      WHERE (NOT NOT id(v) == 'Paul Gasol') OR id(v) IN ['James Harden', 'Jonathon Simmons', 'Klay Thompson', 'Dejounte Murray']
      RETURN v.player.name AS Name
      """
    Then the result should be, in any order:
      | Name               |
      | 'Paul Gasol'       |
      | 'James Harden'     |
      | 'Jonathon Simmons' |
      | 'Klay Thompson'    |
      | 'Dejounte Murray'  |
    When executing query:
      """
      MATCH (v)
      WHERE (NOT NOT id(v) == 'Paul Gasol') OR id(v) IN ['James Harden', 'Jonathon Simmons', 'Klay Thompson', 'Dejounte Murray', 'Paul Gasol']
      RETURN v.player.name AS Name
      """
    Then the result should be, in any order:
      | Name               |
      | 'Paul Gasol'       |
      | 'James Harden'     |
      | 'Jonathon Simmons' |
      | 'Klay Thompson'    |
      | 'Dejounte Murray'  |

  Scenario: basic logical with noise
    When executing query:
      """
      MATCH (v)
      WHERE (NOT NOT id(v) == 'Paul Gasol') AND id(v) == 'Paul Gasol'
      RETURN v.player.name AS Name
      """
    Then the result should be, in any order:
      | Name         |
      | 'Paul Gasol' |
    When executing query:
      """
      MATCH (v)
      WHERE (NOT NOT id(v) == 'Paul Gasol') AND id(v) != 'Paul Gasol'
      RETURN v.player.name AS Name
      """
    Then the result should be, in any order:
      | Name |
    When executing query:
      """
      MATCH (v)
      WHERE id(v) IN ['James Harden', 'Jonathon Simmons', 'Klay Thompson', 'Dejounte Murray', 'Paul Gasol']
            OR false
      RETURN v.player.name AS Name
      """
    Then the result should be, in any order:
      | Name               |
      | 'Paul Gasol'       |
      | 'James Harden'     |
      | 'Jonathon Simmons' |
      | 'Klay Thompson'    |
      | 'Dejounte Murray'  |
    When executing query:
      """
      MATCH (v)
      WHERE id(v) IN ['James Harden', 'Jonathon Simmons', 'Klay Thompson', 'Dejounte Murray', 'Paul Gasol']
            AND (id(v) == 'James Harden' OR v.player.age == 23)
      RETURN v.player.name AS Name
      """
    Then the result should be, in any order:
      | Name           |
      | 'James Harden' |
    When executing query:
      """
      MATCH (v:player)
      WHERE id(v) IN ['James Harden', v.player.age]
      RETURN v.player.name AS Name
      """
    Then the result should be, in any order:
      | Name           |
      | 'James Harden' |

  Scenario: complicate logical
    When executing query:
      """
      MATCH (v)
      WHERE ((NOT NOT id(v) == 'Paul Gasol')
            OR id(v) IN ['James Harden', 'Jonathon Simmons', 'Klay Thompson', 'Dejounte Murray'])
            AND id(v) != 'Paul Gasol'
            AND v.player.name != 'Jonathon Simmons'
            AND v.player.age == 29
      RETURN v.player.name AS Name
      """
    Then the result should be, in any order:
      | Name              |
      | 'James Harden'    |
      | 'Klay Thompson'   |
      | 'Dejounte Murray' |
    When executing query:
      """
      MATCH (v)
      WHERE (id(v) == "Tim Duncan" AND v.player.age>10) OR (id(v) == "Tony Parker" AND v.player.age>10)
      RETURN v.player.name AS Name
      """
    Then the result should be, in any order:
      | Name          |
      | "Tim Duncan"  |
      | "Tony Parker" |

  Scenario: with extend
    When executing query:
      """
      MATCH (v)-[:serve]->(t)
      WHERE (NOT NOT id(v) == 'Paul Gasol') AND id(v) == 'Paul Gasol'
      RETURN v.player.name AS Name, t.team.name AS Team
      """
    Then the result should be, in any order:
      | Name         | Team        |
      | 'Paul Gasol' | 'Grizzlies' |
      | 'Paul Gasol' | 'Lakers'    |
      | 'Paul Gasol' | 'Bulls'     |
      | 'Paul Gasol' | 'Spurs'     |
      | 'Paul Gasol' | 'Bucks'     |

  Scenario: multiple nodes
    When executing query:
      """
      MATCH (v)-[:serve]->(t)
      WHERE (NOT NOT id(v) == 'Paul Gasol') AND id(v) == 'Paul Gasol' AND id(t) IN ['Grizzlies', 'Lakers']
      RETURN v.player.name AS Name, t.team.name AS Team
      """
    Then the result should be, in any order:
      | Name         | Team        |
      | 'Paul Gasol' | 'Grizzlies' |
      | 'Paul Gasol' | 'Lakers'    |
    When executing query:
      """
      MATCH (v)-[:serve]->(t)
      WHERE ((NOT NOT id(v) == 'Paul Gasol') AND id(v) == 'Paul Gasol') OR id(t) IN ['Grizzlies', 'Lakers']
      RETURN v.player.name AS Name, t.team.name AS Team
      """
    Then the result should be, in any order:
      | Name         | Team        |
      | 'Paul Gasol' | 'Grizzlies' |
      | 'Paul Gasol' | 'Lakers'    |
      | 'Paul Gasol' | 'Bulls'     |
      | 'Paul Gasol' | 'Spurs'     |
      | 'Paul Gasol' | 'Bucks'     |

  Scenario: can't refer
    When executing query:
      """
      MATCH (v)
      WHERE NOT id(v) == 'Paul Gasol'
      RETURN v.player.name AS Name, v.player.age AS Age
      """
    Then a ExecutionError should be raised at runtime: Scan vertices or edges need to specify a limit number, or limit number can not push down.
    When executing query:
      """
      MATCH (v)
      WHERE NOT id(v) IN ['James Harden', 'Jonathon Simmons', 'Klay Thompson', 'Dejounte Murray']
      RETURN v.player.name AS Name
      """
    Then a ExecutionError should be raised at runtime: Scan vertices or edges need to specify a limit number, or limit number can not push down.
    When executing query:
      """
      MATCH (v)
      WHERE id(x) == 'James Harden'
      RETURN v.player.name AS Name
      """
    Then a SemanticError should be raised at runtime: Alias used but not defined: `x'
    When executing query:
      """
      MATCH (v)
      WHERE (id(v) + '') == 'James Harden'
      RETURN v.player.name AS Name
      """
    Then a SemanticError should be raised at runtime:
    When executing query:
      """
      MATCH (v)
      WHERE id(v) IN ['James Harden', v.player.name]
      RETURN v.player.name AS Name
      """
    Then a ExecutionError should be raised at runtime: Scan vertices or edges need to specify a limit number, or limit number can not push down.

  @skip
  Scenario: test OR logic (reason = "or logic optimization error")
    When executing query:
      """
      MATCH (v)
      WHERE id(v) IN ['James Harden', 'Jonathon Simmons', 'Klay Thompson', 'Dejounte Murray']
            OR v.player.age == 23
      RETURN v.player.name AS Name
      """
    Then the result should be, in any order:
      | Name                 |
      | 'James Harden'       |
      | 'Jonathon Simmons'   |
      | 'Klay Thompson'      |
      | 'Dejounte Murray'    |
      | 'Kristaps Porzingis' |
    When executing query:
      """
      MATCH (v)
      WHERE id(v) == 'James Harden'
            OR v.player.age == 23
      RETURN v.player.name AS Name
      """
    Then the result should be, in any order:
      | Name                 |
      | 'James Harden'       |
      | 'Kristaps Porzingis' |
    When executing query:
      """
      MATCH (v)
      WHERE id(v) == 'James Harden'
            OR v.player.age != 23
      RETURN v.player.name AS Name
      """
    Then the result should be, in any order:
      | Name |

  Scenario: Start from end
    When executing query:
      """
      MATCH (v)-[:serve]->(t)
      WHERE id(t) == 'Pistons'
      RETURN v.player.name AS Name
      """
    Then the result should be, in any order:
      | Name            |
      | 'Aron Baynes'   |
      | 'Blake Griffin' |
      | 'Grant Hill'    |
