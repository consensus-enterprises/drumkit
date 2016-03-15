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

  private $debug = FALSE;

  private $tempDir;

  private $orig_dir;

  /**
   * Initializes context.
   *
   * Every scenario gets its own context instance.
   * You can also pass arbitrary arguments to the
   * context constructor through behat.yml.
   */
  public function __construct() {
    $this->setOrigDir();
  }

  /**
   * Clean up temporary directories.
   */
  public function __destruct() {
    $this->rmdir($this->tempDir);
  }

  private function getOrigDir() {
    return $this->orig_dir;
  }

  private function setOrigDir() {
    if (!isset($this->orig_dir)) {
      $this->orig_dir = getcwd();
    }
  }

  /**
   * Run a command in a sub-process, and set its output.
   */
  private function exec($command) {
    $process = new Process("{$command}");
    $process->setTimeout(300);
    $process->run();

    if (!$process->isSuccessful()) {
      throw new \RuntimeException($process->getErrorOutput());
    }

    $this->output = $process->getOutput();
    if ($this->debug) {
      print_r($this->output);
    }
  }

  /**
   * Run a command that is expected to fail in a sub-process, and set its output.
   */
  private function fail($command) {
    $process = new Process("{$command}");
    $process->setTimeout(300);
    $process->run();

    if ($process->isSuccessful()) {
      throw new \RuntimeException($process->getOutput());
    }

    $this->output = $process->getErrorOutput();
    if ($this->debug) {
      print_r($this->output);
    }
  }

  /**
   * Create a temporary directory
   */
  private function makeTempDir() {
    $tempfile = tempnam(sys_get_temp_dir(), 'behat_cli_');
    if (file_exists($tempfile)) {
      unlink($tempfile);
    }
    mkdir($tempfile);
    $this->tempDir = $tempfile;
  }

  /**
   * Recursively delete a directory and its contents.
   */
  private function rmdir($dir) {
    if (is_dir($dir)) {
      foreach(scandir($dir) as $file) {
        if ('.' === $file || '..' === $file) {
          continue;
        }
        if (is_dir("$dir/$file")) {
          $this->rmdir("$dir/$file");
        }
        else unlink("$dir/$file");
      }
      rmdir($dir);
    }
  }

  /**
   * Set a debug flag when running scenarios tagged @debug.
   *
   * @BeforeScenario @debug
   */
  public function setDebugFlag() {
    $this->debug = TRUE;
  }

  /**
   * In case we switched to a temporary directory, switch back to the original
   * directory before the next scenario.
   *
   * @AfterScenario
   */
  public function returnToOrigDir() {
    chdir($this->getOrigDir());
  }

  /**
   * @When I run :command
   */
  public function iRun($command)
  {
    $this->exec($command);
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

  /**
   * @Then I should not get:
   */
  public function iShouldNotGet(PyStringNode $output)
  {
    foreach ($output->getStrings() as $string) {
      if (strpos($this->output, $string) !== FALSE) {
        throw new \RuntimeException("'$string' was found in command output.");
      }
    }
  }

  /**
   * @Given I am in a temporary directory
   */
  public function iAmInATemporaryDirectory()
  {
    $this->makeTempDir();
    chdir($this->tempDir);
  }

  /**
   * Execute a script in our project, even if we've moved to a temporary directory.
   *
   * @When I execute :script
   */
  public function iExecute($script)
  {
    $script = $this->getOrigDir() . DIRECTORY_SEPARATOR . $script;
    $this->exec($script);
  }

  /**
   * @Then executing :script should fail
   */
  public function executingShouldFail($script)
  {
    $script = $this->getOrigDir() . DIRECTORY_SEPARATOR . $script;
    $this->fail($script);
  }

  /**
   * @Then the following files should exist:
   */
  public function theFollowingFilesShouldExist(PyStringNode $files)
  {
     foreach ($files->getStrings() as $file) {
      if (!file_exists($file)) {
        throw new \RuntimeException("Expected file '$file' was not found.");
      }
    }
  }

  /**
   * @Given I bootstrap drumkit
   */
  public function iBootstrapDrumkit()
  {
    $this->iAmInATemporaryDirectory();
    $this->iRun("cp -r " . $this->getOrigDir() ." ./.mk");
    $this->iRun("echo 'include .mk/Makefile' > Makefile");
  }

}
