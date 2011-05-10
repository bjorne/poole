Feature: Command-line Album Creation
  In order to make it easy to create an album
  As an administrator of a gallery
  I want to create albums from the commandline task

  Scenario: Create album
    Given I am in the albums directory
    When I run the album create task with arguments "party_pix"
    Then I should see output "Successfully created album" 
    And the directory "party_pix" should be an album
