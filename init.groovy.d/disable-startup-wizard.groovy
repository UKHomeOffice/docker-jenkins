import hudson.util.PluginServletFilter
import jenkins.model.Jenkins

Jenkins j = Jenkins.instance

legacySetupWizard = ('getSetupWizard' in j.metaClass.methods*.name)
newSetupWizard = (('getInstallState' in j.metaClass.methods*.name) && ('isSetupComplete' in j.installState.metaClass.methods*.name))


if((!newSetupWizard && legacySetupWizard) || (newSetupWizard && !j.installState.isSetupComplete())) {
    def w=j.setupWizard
    if(w != null) {
        try {
          //pre Jenkins 2.6
          w.completeSetup(j)
          PluginServletFilter.removeFilter(w.FORCE_SETUP_WIZARD_FILTER)
        }
        catch(Exception e) {
          w.completeSetup()
        }
        j.save()
        println 'Jenkins 2.0 wizard skipped.'
    }
}
