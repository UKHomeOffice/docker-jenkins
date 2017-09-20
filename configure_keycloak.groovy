#!/usr/bin/env groovy

import jenkins.model.*
import jenkins.install.*
import hudson.model.*
import hudson.util.*
import hudson.security.FullControlOnceLoggedInAuthorizationStrategy
import org.jenkinsci.plugins.KeycloakSecurityRealm

def keycloakJson=System.getenv("KEYCLOAK_JSON")

if (keycloakJson?.trim()) {

  def instance = Jenkins.getInstance()
  def keycloakSecurityRealm = new KeycloakSecurityRealm()
  def descriptorImpl = keycloakSecurityRealm.getDescriptor()

  descriptorImpl.setKeycloakJson(keycloakJson)
  instance.setSecurityRealm(keycloakSecurityRealm)

  def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
  strategy.setAllowAnonymousRead(false)
  instance.setAuthorizationStrategy(strategy)

  instance.save()
}
