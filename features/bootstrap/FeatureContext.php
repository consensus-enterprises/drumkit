<?php

use Behat\Behat\Tester\Exception\PendingException;
use Drupal\DrupalExtension\Context\RawDrupalContext;
use Behat\Behat\Context\SnippetAcceptingContext;
use Behat\Gherkin\Node\PyStringNode;
use Behat\Gherkin\Node\TableNode;

use Symfony\Component\Process\Process;

/**
 * Defines application features from the specific context.
 */
class FeatureContext extends RawDrupalContext implements SnippetAcceptingContext {

  /**
   * Initializes context.
   *
   * Every scenario gets its own context instance.
   * You can also pass arbitrary arguments to the
   * context constructor through behat.yml.
   */
  public function __construct() {
  }

    /**
     * @When I run :command
     */
    public function iRun($command)
    {
        $process = new Process("{$command}");
        $process->setTimeout(10);
        $process->run();

    if (!$process->isSuccessful()) {
      throw new \RuntimeException($process->getErrorOutput());
    }

        $this->output = $process->getOutput();

    }

    /**
     * @Then I should get:
     */
    public function iShouldGet(PyStringNode $output)
    {
        foreach ($output->getStrings() as $string) {
            if (strpos($this->output, $string) === FALSE) {
                throw new \RuntimeException("'$string' was not found in command output.");
            }
        }
    }
}
