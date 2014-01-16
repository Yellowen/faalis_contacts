Feature: ContactDetails API
  In order to intract with contact_details from dashboard
  ContactDetails API should be accessable by logged in users
  And anonymous user should not have accesss to API

  Scenario: Anonymous User should not have access to API
    Given I am not authenticated
    And there is a contact_details named "Iran" in database
    When format is json and I go to the api v1 contact_details page
    Then I should get "401" status code
    When format is json and I go to "/api/v1/contact_details/1"
    Then I should get "401" status code
    When format is json and I send patch to "/api/v1/contact_details/1" with:
    """
    {"details_value":"bVtqmzhonDXNUhrpeVcAhJffumDUyjnDywoTjJhiMsqXcplTQx"}
    """
    Then I should get "401" status code
    When format is json and I send post to "/api/v1/contact_details" with:
    """
    {"details_value":"RmcGQhVLvtXuFZnvFpZUQFuqVMoskeUWZpkVTOjOvbthBGxMHy"}
    """
    Then I should get "401" status code
    When format is json and I send delete to "/api/v1/contact_details/1"
    Then I should get "401" status code

  Scenario: Default response should be json
    Given I am authenticated
    When I go to the api v1 contact_details page
    Then response type should be application/json

  Scenario: Anonymous User via HTTP
    Given I am not authenticated
    When format is html and I go to the api v1 contact_details page
    Then I should be in sign in page

  Scenario: Anonymous USer via JSON format
    Given I am not authenticated
    When format is json and I go to the api v1 contact_details page
    Then I should get "401" status code

  Scenario: Logged in User via HTTP
    Given I am authenticated
    When format is html and I go to the api v1 contact_details page
    Then I should get unknown format exception
    #Then I should get "406" status code

  Scenario: Logged in User via JSON format
    Given I am authenticated
    When format is json and I go to the api v1 contact_details page
    Then the JSON should have 0 keys

  Scenario: Logged in User via JSON format And Initial Data
    Given I am authenticated
    And there is a contact_details named "XYZ" in database
    When format is json and I go to the api v1 contact_details page
    Then the JSON should have 1 keys
    And the JSON at "0/name" should be "XYZ"

  Scenario: API should not response to "/new"
    Given I am authenticated
    When format is json and I go to "/api/v1/contact_details/new"
    Then action should not be found

  @javascript
  Scenario: Add New contact_details
    Given I am authenticated
    When I go to "/dashboard#/contact_details/new"
    And fill in "name" with "XYZ"
    And click on "save"
    And wait for ajax to return
    Then there should be a contact_details with "XYZ" as "name"

  @javascript
  Scenario: Edit contact_details
    Given I am authenticated
    And there shouldn't be any contact_details
    And there is a contact_details named "XYZ" in database
    Then there should be a contact_details with "XYZ" as "name"
    When I go to "/dashboard#/contact_details/1/edit"
    And fill in "name" with "XYZW"
    Then field "name" contains "XYZW"
    When click on "save"
    And wait for ajax to return
    Then there should be a contact_details with "XYZW" as "name"

  Scenario: Delete contact_details
    Given I am authenticated
    And there is a contact_details named "ABC" in database
    And there is a contact_details named "XYZ" in database
    When format is json and I send delete to "/api/v1/contact_details/1,2"
    Then the JSON at "msg" should be "Items removed successfully."
    And there shouldn't be any contact_details
