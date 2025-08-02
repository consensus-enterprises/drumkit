<?php

use Behat\Mink\Exception\ExpectationException;
use Drupal\DrupalExtension\Context\RawDrupalContext;


/**
 * Defines application features from the specific context.
 */
class FeatureContext extends RawDrupalContext
{
    /**
     * Initializes context.
     *
     * Every scenario gets its own context instance.
     * You can also pass arbitrary arguments to the
     * context constructor through behat.yml.
     */
    public function __construct() {}

    /**
     * @Given I wait :seconds seconds
     */
    public function iWait($seconds)
    {
        sleep($seconds);
    }

    /**
     * @Then the :field field is required
     */
    public function theFieldIsRequired(string $field)
    {
        if (!$this->fieldIsRequired($field)) {
            throw new ExpectationException("The '{$field}' field was expected to be required, but it was not.", $this->getSession()->getDriver());
        }
    }

    /**
     * @Then the :field field is not required
     */
    public function theFieldIsNotRequired(string $field)
    {
        if ($this->fieldIsRequired($field)) {
            throw new ExpectationException("The '{$field}' field was required, but it was not expected to be.", $this->getSession()->getDriver());

        }
    }

    /**
     * Determine whether a given field is required.
     */
    protected function fieldIsRequired(string $field): bool {
        return (boolean) $this
                 ->getSession()
                 ->getPage()
                 ->findField($field)
                 ->getAttribute('required');
    }

}
