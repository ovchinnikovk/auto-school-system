deps = [
    dependency('libadwaita-1'),
    dependency('gee-0.8'),
    dependency('libsoup-3.0'),
    dependency('json-glib-1.0')
]

sources = files(
    'app.vala',
)

subdir('data')
subdir('models')
subdir('services')
subdir('ui')

app = executable(
    output,

    resources,
    sources,
    dependencies: deps,
    win_subsystem: 'windows',
    install: true,
)
