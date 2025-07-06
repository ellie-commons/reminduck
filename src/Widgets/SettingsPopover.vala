

public class Reminduck.Widgets.SettingsPopover : Gtk.Popover {
    construct {




        var view = new Gtk.Box (Gtk.Orientation.VERTICAL, 18) {
            margin_top = margin_bottom = margin_start = margin_end = 18,
            vexpand = true,
            hexpand = true
        };


        /* QUACK TOGGLE */
        var quack_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
            halign = Gtk.Align.FILL,
            hexpand = true
        };

        var quack_button = new Gtk.Button.from_icon_name ("media-playback-start");
        quack_button.clicked.connect (() => {new Quack ();});

        var quack_toggle = new Gtk.Switch ();
        var minibox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6) {
            halign = Gtk.Align.END,
            hexpand = true
        };
        minibox.append (quack_button);
        minibox.append (quack_toggle);

        var quack_label = new Granite.HeaderLabel (_("Do a quack sound")) {
            mnemonic_widget = minibox,
            secondary_text = _("If enabled, the duck will quack when reminding you"),
            halign = Gtk.Align.START
        };

        quack_box.append (quack_label);
        quack_box.append (minibox);

        view.append (quack_box);

                /* PERMISSION BOX */
                var link = Granite.SettingsUri.NOTIFICATIONS;
                var linkname = _("Notifications");


                var permissions_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
                    halign = Gtk.Align.FILL
                };

                var permissions_link = new Gtk.LinkButton.with_label (
                                                                link,
                                                                linkname
                );

                // _("Applications → Permissions")
                permissions_link.tooltip_text = link;
                permissions_link.halign = Gtk.Align.END;

                var permissions_label = new Granite.HeaderLabel (_("Disable the 'DING' sound")) {
                    mnemonic_widget = permissions_link,
                    secondary_text = _("You can disable the system notification sounds for Reminduck in the settings"),
                    halign = Gtk.Align.START,
                    hexpand = true
                };

                permissions_label.set_hexpand (true);
                permissions_box.append (permissions_label);
                permissions_box.append (permissions_link);
                view.append (permissions_box);

            string desktop_environment = Environment.get_variable ("XDG_CURRENT_DESKTOP");
            print ("\nEnvironment: " + desktop_environment + " detected!");

            // Show only in Pantheon because others do not have an autostart panel
            if (desktop_environment != "Pantheon") {
                permissions_link.hide ();
            }


        /* PERSISTENT TOGGLE */
        var persist_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
            halign = Gtk.Align.FILL,
            hexpand = true
        };

        var persist_toggle = new Gtk.Switch () {
                halign = Gtk.Align.END,
                hexpand = true,
                valign = Gtk.Align.CENTER,
        };

        var persist_label = new Granite.HeaderLabel (_("Persistent notifications")) {
            mnemonic_widget = quack_toggle,
            secondary_text = _("If enabled, the duck will stay until (gently) dismissed"),
            halign = Gtk.Align.START
        };

        persist_box.append (persist_label);
        persist_box.append (persist_toggle);

        view.append (persist_box);

        child = view;

        /* BIND */
        var settings = new GLib.Settings ("io.github.ellie_commons.reminduck.state");
        settings.bind (
            "quack-sound",
            quack_toggle, "active",
            SettingsBindFlags.DEFAULT);

            settings.bind (
            "persistent",
            persist_toggle, "active",
            SettingsBindFlags.DEFAULT);



    }
}

