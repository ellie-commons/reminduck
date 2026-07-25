#
# Sources
#

#================================
# Config.vala allows us to set variables in Meson, for the Vala app to use later

config_file = configure_file(
    input: 'Config.vala.in',
    output: '@BASENAME@',
    configuration: config_data
)

#================================

# Gee to hold all these reminders
# Libportal to set autostart
# SQLite for the storage system

dependencies = [
    dependency('gtk4', version: '>=4.14'),              # 24.04 LTS
    dependency('granite-7', version: '>=7.6.0'),        # Version both in appcenter and flathub
    dependency('gee-0.8'),                              # List manipulation
    dependency('sqlite3')                               # SQL Database where reminders are saved
    ]


#================================
sources = files (

    'Objects' / 'Reminder.vala',
    'Objects' / 'Quack.vala',

    'Services' / 'Database.vala',
    'Services' / 'Utils.vala',

    'Views' / 'ReminderEditor.vala',
    'Views' / 'RemindersView.vala',
    'Views' / 'WelcomeView.vala',
    'Views' / 'SettingsView.vala',

    'Widgets' / 'RepeatBox.vala',
    'Widgets' / 'QuackBox.vala',

    'Application.vala',
    'Constants.vala',
    'MainWindow.vala',
    'main.vala',
    )


#================================
# Windows should have libportal set to false, as it doesnt have it
# Other OSes might have it set to true

if libportal
    add_project_arguments('--define=LIBPORTAL', language: 'vala')
    dependencies += dependency('libportal')
    #sources += files('Utils' / 'Autostart.vala')

endif


#================================
# Windows specific stuff
# theres a gio-windows and a gio-unix. We need to add depending on case 
# We need to compile an icon and add to the sources to avoid "missing icon" icon at every turn
# So AFAIK ico.rc just point to an ico file in the same folder it is, so this is like gresource

if windows
    dependencies += dependency('gio-windows-2.0')
    ico_src = import('windows').compile_resources('../windows/icons/ico.rc')
    sources += ico_src

else
    dependencies += dependency('gio-unix-2.0')

endif

#================================
# There it is. The exe. The cause of all this mess.

executable(
    app_id,
    gresource,
    config_file,
    sources,
    dependencies: dependencies,
    win_subsystem: development ? 'console' : 'windows',         # Show a console in windows dev builds. Seem to not bother standard builds
    install : true
)
