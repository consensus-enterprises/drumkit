<?php
namespace Drumkit;

use Behat\Behat\Tester\Exception\PendingException;
use Behat\Behat\Context\SnippetAcceptingContext;
use Behat\Gherkin\Node\PyStringNode;
use Behat\Gherkin\Node\TableNode;
use Symfony\Component\Process\Exception\ProcessFailedException;
use Symfony\Component\Process\Process;
use consensus\BehatTerminalContext\Context\TerminalContext;

/**
 * Defines application features from the specific context.
 */
class DrumkitContext extends TerminalContext implements SnippetAcceptingContext {

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
   * @Then The :pkg deb package should be installed on :host
   */
  public function theDebPackageShouldBeInstalledOn($pkg, $host) {
    $this->theDebPackageIsInstalledOn($pkg, $host);
  }

  /**
   * @Given The :pkg deb package is not installed on :host
   */
  public function theDebPackageIsNotInstalledOn($pkg, $host) {
    $this->ignoreFailures = TRUE;
    $this->fail("ssh $host dpkg -l $pkg");
    if (preg_match("/ii[ ]+$pkg/", $this->getOutput())) {
      throw new \Exception("'$pkg' is unexpectedly installed, dpkg output was:\n" . $this->getOutput());
    }
  }

  /**
   * @Then The :pkg deb package should not be installed on :host
   */
  public function theDebPackageShouldNotBeInstalledOn($pkg, $host) {
    $this->theDebPackageIsNotInstalledOn($pkg, $host);
  }

  /**
   * @Given I bootstrap a clean drumkit environment
   */
  public function iBootstrapACleanDrumkitEnvironment()
  {
    $this->iBootstrapDrumkit();
    $this->iRun("make clean-mk");
    $this->iRun("make clean-drumkit");
    $this->iRun("make init-drumkit");
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

}
