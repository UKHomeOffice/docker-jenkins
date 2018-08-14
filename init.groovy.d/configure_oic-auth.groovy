#!/usr/bin/env groovy

import jenkins.model.*
import jenkins.install.*
import hudson.model.*
import hudson.util.*
import hudson.security.FullControlOnceLoggedInAuthorizationStrategy
import hudson.security.SecurityRealm
import org.jenkinsci.plugins.oic.*

# def keycloakJson=System.getenv("KEYCLOAK_JSON")

# if (keycloakJson?.trim()) {

def instance = Jenkins.getInstance()
def OicSecurityRealm = new OicSecurityRealm()
#  def descriptorImpl = OicSecurityRealm.getDescriptor()

String userNameField = 'preferred_username'
#  descriptorImpl.setKeycloakJson(keycloakJson)
instance.setSecurityRealm(OicSecurityRealm)

def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
strategy.setAllowAnonymousRead(false)
instance.setAuthorizationStrategy(strategy)

instance.save()
# }
