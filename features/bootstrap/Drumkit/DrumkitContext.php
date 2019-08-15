<?php
namespace Drumkit;

use Behat\Behat\Tester\Exception\PendingException;
use Behat\Behat\Context\SnippetAcceptingContext;
use Behat\Gherkin\Node\PyStringNode;
use Behat\Gherkin\Node\TableNode;
use Drupal\DrupalExtension\Context\RawDrupalContext;
use Symfony\Component\Process\Exception\ProcessFailedException;
use Symfony\Component\Process\Process;


/**
 * Defines application features from the specific context.
 */
class DrumkitContext extends RawDrupalContext implements SnippetAcceptingContext {

  protected $debug = FALSE;

  protected $ignoreFailures = FALSE;

  private $process;

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

  protected function getOutput() {
    if ($this->process->isSuccessful()) {
      return $this->process->getOutput();
    }
    return $this->process->getErrorOutput();
  }

  /**
   * Run a command in a sub-process, and set its output.
   */
  private function exec($command) {
    $this->process = new Process("{$command}");
    $this->process->setTimeout(300);
    $this->process->run();

    $output = $this->getOutput();
    $this->printDebug($output);
  }

  private function printDebug(string $output) {
    if (!$this->debug) return;
    if (empty($output)) return;
    print_r("--- DEBUG START ---\n");
    print_r($output);
    print_r("\n--- DEBUG END -----\n");
  }

  private function succeed($command) {
    $this->exec($command);

    if (!$this->process->isSuccessful()) {
      throw new ProcessFailedException($this->process);
    }
  }

  /**
   * Run a command that is expected to fail in a sub-process, and set its output.
   */
  private function fail($command) {
    $this->exec($command);

    if ($this->process->isSuccessful()) {
      throw new \RuntimeException($this->getOutput());
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
    $this->iRun('rm -rf ' . $dir);
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
    if ($this->ignoreFailures) {
      return $this->exec($command);
    } 
    $this->succeed($command);
  }

  /**
   * @When I run :cmd on :host
   */
  public function iRunOn($cmd, $host) {
    $this->iRun("ssh $host $cmd");
    if (!$this->process->isSuccessful()) {
      throw new ProcessFailedException($this->process);
    }
  }

  /**
   * @Given The :pkg deb package is installed on :host
   */
  public function theDebPackageIsInstalledOn($pkg, $host) {
    $this->ignoreFailures = TRUE;
    $this->iRunOn("dpkg -l $pkg", $host);
    if (!preg_match("/ii[ ]+$pkg/", $this->getOutput())) {
      throw new \Exception("'$pkg' is not installed, dpkg output was:\n" . $this->getOutput());
    }
  }

  /**
   * @Then I should get:
   */
  public function iShouldGet(PyStringNode $expectedOutput)
  {
    $output = $this->getOutput();
    foreach ($expectedOutput->getStrings() as $string) {
      $string = trim($string);
      if (!empty($string) && strpos($output, $string) === FALSE) {
        throw new \Exception("'$string' was not found in command output:\n------\n" . $output . "\n------\n");
      }
    }
  }

  /**
   * @And I get:
   */
  public function iGet(PyStringNode $unexpectedOutput)
  {
    return $this->iShouldGet($unexpectedOutput);
  }

  /**
   * @Then I should not get:
   */
  public function iShouldNotGet(PyStringNode $unexpectedOutput)
  {
    foreach ($unexpectedOutput->getStrings() as $string) {
      $string = trim($string);
      if (!empty($string) && strpos($this->getOutput(), $string) !== FALSE) {
        throw new \RuntimeException("'$string' was found in command output:\n------\n" . $this->getOutput() . "\n------\n");
      }
    }
  }

  /**
   * @And I do not get:
   */
  public function iDoNotGet(PyStringNode $unexpectedOutput)
  {
    return $this->iShouldNotGet($unexpectedOutput);
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
    $this->succeed($script);
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
   * @Given executing :script fails
   */
  public function executingFails($script)
  {
    $this->executingShouldFail($script);
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
   * @Given the following files exist:
   */
  public function theFollowingFilesExist(PyStringNode $files)
  {
    $this->theFollowingFilesShouldExist($files);
  }

  /**
   * @Then the following files should not exist:
   */
  public function theFollowingFilesShouldNotExist(PyStringNode $files)
  {
    foreach ($files->getStrings() as $file) {
      if (file_exists($file)) {
        throw new \RuntimeException("Unxpected file '$file' was found.");
      }
    }
  }

  /**
   * @Given the following files do not exist:
   */
  public function theFollowingFilesDoNotExist(PyStringNode $files)
  {
    $this->theFollowingFilesShouldNotExist($files);
  }

  /**
   * @Given I bootstrap drumkit
   */
  public function iBootstrapDrumkit()
  {
    $this->iAmInATemporaryDirectory();
    $this->iRun("cp -r " . $this->getOrigDir() ." ./.mk");
    $this->iInitializeDrumkit();
  }

  public function iInitializeDrumkit()
  {
    $this->iRun("echo 'include .mk/GNUmakefile' > Makefile");
    $this->iRun("make clean-mk");
    $this->iRun("git init");
    $this->iRun("make init-drumkit");
  }

  /**
   * @Given I bootstrap this code
   */
  public function iBootstrapThisCode()
  {
    $this->iAmInATemporaryDirectory();
    $this->iRun("bash -c 'shopt -s dotglob && cp -r " . $this->getOrigDir() . "/* .'");
  }

  /**
   * @Given I bootstrap this Ansible role
   */
  public function iBootstrapThisAnsibleRole()
  {
    $this->iAmInATemporaryDirectory();
    $this->iRun("cp -r " . $this->getOrigDir() ."/.mk .");
    $this->iInitializeDrumkit();
    $this->iRun("mkdir roles && cp -r " . $this->getOrigDir() . " ./roles");
  }

  /**
   * @Then the file :file should contain:
   */
  public function theFileShouldContain($file, PyStringNode $lines)
  {
    $contents = file_get_contents($file);
    foreach ($lines->getStrings() as $line) {
      if (strlen($line) == 0) continue; # Skip empty lines.
      if (strpos($contents, $line) === FALSE) {
        throw new \RuntimeException("'$line' was not found in '$file'.");
      }
    }
  }

  /**
   * @Given the file :file contains:
   */
  public function theFileContains($file, PyStringNode $lines)
  {
    $this->theFileShouldContain($file, $lines);
  }

}
