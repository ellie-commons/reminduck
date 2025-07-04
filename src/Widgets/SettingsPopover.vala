

public class Reminduck.Widgets.SettingsPopover : Granite.Popover {
    construct {

        /* QUACK TOGGLE */
        var quack_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);

        quack_toggle = new Gtk.Switch () {
                halign = Gtk.Align.END,
                hexpand = true,
                valign = Gtk.Align.CENTER,
        };

        var quack_label = new Granite.HeaderLabel (_("Do a quack sound")) {
            mnemonic_widget = quack_toggle,
            secondary_text = _("If enabled, the duck will quack when reminding you")
        };

        quack_box.append (quack_label);
        quack_box.append (quack_toggle);
        append (quack_box)


        /* PERMISSION BOX */
        var link = Granite.SettingsUri.PERMISSIONS;
        var linkname = _("Notifications");


        var permissions_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
        var permissions_link = new Gtk.LinkButton.with_label (
                                                        link,
                                                        linkname
        );

        // _("Applications → Permissions")
        permissions_link.tooltip_text = link;
        permissions_link.halign = Gtk.Align.END;

        var permissions_label = new Granite.HeaderLabel (_("Disable the DING sound")) {
            mnemonic_widget = permissions_link,
            secondary_text = _("You can disable the system notification sounds for Reminduck in the settings")
        };
        permissions_label.set_hexpand (true);
        permissions_box.append (permissions_label);
        permissions_box.append (permissions_link);
        append (permissions_box);

        /* BIND */
        Application.settings.bind (
            "quack-sound",
            quack_toggle, "active",
            SettingsBindFlags.DEFAULT);
        };


}