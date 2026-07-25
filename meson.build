project(
    'reminduck', 
    ['c', 'vala'],                # The floor is vala
    version: '2.4.0',                       # Versioning: first should follow Gtk version, second and third depending how proud you are of the update
    license: 'GPL-3.0-or-later',
    meson_version: '>= 1.1'                 # Use meson.option instead of meson_options.txt
    )

app_name = meson.project_name()
app_version = meson.project_version()

correct_app_id = 'io.github.elly_code.' + app_name
correct_app_path = '/io/github/elly_code/' + app_name

legacy_app_id = 'io.github.ellie_commons.' +  app_name
legacy_app_path = '/io/github/ellie_commons/' + app_name

nicename = 'Reminduck'
publisher = 'elly-code'

if get_option('legacy-rdnn')
    app_id = legacy_app_id
    alternate_app_id = correct_app_id
    app_path = legacy_app_path

else
    app_id = correct_app_id
    alternate_app_id = legacy_app_id
    app_path = correct_app_path

endif


#================================
# Preparation

prefix = get_option('prefix')
datadir = get_option('datadir')

development = get_option('development')
if development
  app_id +=  '.devel'
  add_project_arguments('--define=DEVEL', '--define=LATTE', language: 'vala')

endif

gnome = import('gnome')
i18n = import('i18n')
add_project_arguments(
    '-DGETTEXT_PACKAGE="@0@"'.format (app_id),           # 
    '-DG_LOG_DOMAIN="@0@"'.format (app_id),              # Dev builds add the app_id to G_MESSAGES_DEBUG
    '-w',                                                       # Because of Vala we get ten thousand warnings we can do nothing about
    language:'c'
    )


# Play nice with clang
# https://gitlab.gnome.org/GNOME/vala/-/issues/1413#note_1707480
if meson.get_compiler ('c').get_id () == 'clang'
    add_project_arguments('-Wno-incompatible-function-pointer-types', language: 'c')
endif

#================================
# OS and Ports related

linux = get_option('profile') == 'linux'
windows = get_option('profile') == 'windows'

# Here is to autodetect and adjust
# Remember however that people may do cross compiling, so do not assume by default it is for linux
# So avoid else conditions adding linux stuff
build_machine_system = build_machine.system()

if build_machine_system == 'windows'
    windows = true
endif

# Here is to adjust the project accordingly to stuff
# Porting efforts: add your OS here

if windows
    add_project_arguments('--define=WINDOWS', language: 'vala')
    appstream = false
    libportal = false

else
    # Ideal case, Linux, with all the things
    appstream = true
    libportal = true

endif


#================================
# Add subfolders for Meson to look

config_data = configuration_data(
    {
        'APP_NAME': app_name,
        'APP_ID': app_id,
        'APP_PATH': app_path,
        'APP_VERSION': app_version,
        'NICENAME': nicename,
        'PUBLISHER': publisher,
        'ALTERNATE_APP_ID': alternate_app_id,
        'LOCALEDIR': prefix / get_option('localedir')
        }
    )

subdir('po')
subdir('data')
subdir('src')

if windows
    subdir('windows')
endif

#subdir('tests')


gnome.post_install(
    glib_compile_schemas: true,
    gtk_update_icon_cache: true,
    update_desktop_database: true
    )
