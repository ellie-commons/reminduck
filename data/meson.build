i18n.merge_file(
    input: 'reminduck.desktop.in',
    output: meson.project_name() + '.desktop',
    po_dir: join_paths(meson.global_source_root(), 'po', 'extra'),
    type: 'desktop',
    install: true,
    install_dir: join_paths(get_option('datadir'), 'applications')
)

i18n.merge_file(
    input: 'reminduck.metainfo.xml.in',
    output: meson.project_name() + '.metainfo.xml',
    po_dir: join_paths(meson.global_source_root(), 'po', 'extra'),
    install: true,
    install_dir: join_paths(get_option('datadir'), 'metainfo')
)

install_data(
    'reminduck.gschema.xml',
    install_dir: join_paths(get_option('datadir'), 'glib-2.0', 'schemas')
)


# Install our icons in all the required sizes
icon_sizes = ['16', '24', '32', '48', '64', '128', '256']

foreach i : icon_sizes
    install_data(
        'icons' / 'hicolor' / i + '.png',
        install_dir: get_option('datadir') / 'icons' / 'hicolor' / i + 'x' + i / 'apps',
        rename: meson.project_name() + '.png'
    )
    install_data(
        'icons' / 'hicolor@2' / i + '@2.png',
        install_dir: get_option('datadir') / 'icons' / 'hicolor' / i + 'x' + i + '@2' / 'apps',
        rename: meson.project_name() + '.png'
    )
endforeach

install_data(
    'icons' / 'scalable.svg',
    install_dir: get_option('datadir') / 'icons' / 'scalable' / 'apps',
    rename: meson.project_name() + '.svg'
)