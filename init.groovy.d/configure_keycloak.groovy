#!/usr/bin/env groovy

import hudson.model.*
import jenkins.model.*
import hudson.tools.*
import hudson.security.*
import hudson.plugins.*
import hudson.security.SecurityRealm.*
import org.jenkinsci.plugins.oic.*
import groovy.json.*

def keycloakJson=System.getenv("KEYCLOAK_JSON")

if (keycloakJson?.trim()) {

  def json = new JsonSlurper().parseText(keycloakJson)
  def instance = Jenkins.getInstance()

  String realmId = json.realm
  String clientId = json.resource
  String clientSecret = json.credentials.secret
  String tokenServerUrl = 'https://sso.digital.homeoffice.gov.uk/auth/realms/'+ realmId +'/protocol/openid-connect/token'
  String authorizationServerUrl = 'https://sso.digital.homeoffice.gov.uk/auth/realms/'+ realmId + '/protocol/openid-connect/auth'
  String userInfoServerUrl = ''
  String userNameField = 'preferred_username'
  String tokenFieldToCheckKey = ''
  String tokenFieldToCheckValue = ''
  String fullNameFieldName = ''
  String emailFieldName = ''
  String scopes = 'openid email'
  String groupsFieldName = ''
  boolean disableSslVerification = 'false'
  boolean logoutFromOpenidProvider = 'false'
  String endSessionUrl = ''
  String postLogoutRedirectUrl = ''
  boolean escapeHatchEnabled = 'false'
  String escapeHatchUsername = ''
  String escapeHatchSecret = ''
  String escapeHatchGroup = ''

  realm = new OicSecurityRealm(clientId, clientSecret, tokenServerUrl, authorizationServerUrl, userInfoServerUrl, userNameField, tokenFieldToCheckKey, tokenFieldToCheckValue, fullNameFieldName, emailFieldName, scopes, groupsFieldName, disableSslVerification, logoutFromOpenidProvider, endSessionUrl, postLogoutRedirectUrl, escapeHatchEnabled, escapeHatchUsername, escapeHatchSecret, escapeHatchGroup)

  instance.setSecurityRealm(realm)

  def strategy = new FullControlOnceLoggedInAuthorizationStrategy()

  strategy.setAllowAnonymousRead(false)

  instance.setAuthorizationStrategy(strategy)

  instance.save()

}
