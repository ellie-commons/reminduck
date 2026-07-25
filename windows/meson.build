#
#   WINDOWS
#

#========================
# NSIS Installer script

config_installer_script = configure_file(
    input: 'installer.nsi.in',
    output: 'installer.nsi',
    configuration: config_data
    )

#========================
# DEPLOY

config_deploy_script = configure_file(
    input: 'deploy.sh.in',
    output: 'deploy.sh',
    configuration: config_data
    )
