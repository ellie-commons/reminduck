/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2011-2019 Matheus Fantinel
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */


public class Reminduck.QuackBox : Gtk.Box {

    construct {
        orientation = Gtk.Orientation.VERTICAL;
        spacing = 0;
        hexpand = true;

        /* QUACK TOGGLE */
        var quack_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12) {
            halign = Gtk.Align.FILL,
            hexpand = true
        };

        var quack_toggle = new Gtk.Switch () {
            valign = Gtk.Align.CENTER
        };

        //minibox.append (quack_toggle);

        var quack_label = new Granite.HeaderLabel (_("Do a quack sound")) {
            mnemonic_widget = quack_toggle,
            secondary_text = _("If enabled, the duck will quack when reminding you"),
            halign = Gtk.Align.START,
            hexpand = true
        };

        quack_box.append (quack_label);
        quack_box.append (quack_toggle);


        /* CHOICE BOX */
        var choicebox = new Gtk.Box (HORIZONTAL, 12);


        var quack_button = new Gtk.Button.from_icon_name ("media-playback-start") {
            tooltip_text = _("Click to preview reminder sound")
        };
        var quack_dropdown = new Gtk.DropDown.from_strings (QuackType.choices ());

        var minibox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12) {
            halign = Gtk.Align.END
        };
        minibox.append (quack_button);
        minibox.append (quack_dropdown);


        var quack_choice = new Granite.HeaderLabel (_("Choose your quack")) {
            mnemonic_widget = minibox,
            secondary_text = _("Which will be your champion?"),
            halign = Gtk.Align.START,
            hexpand = true
        };

        choicebox.append (quack_choice);
        choicebox.append (minibox);



        /* PERMISSION BOX */
        var link = Granite.SettingsUri.NOTIFICATIONS;
        var linkname = _("Notifications");


        var permissions_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12) {
            halign = Gtk.Align.FILL
        };

        var permissions_link = new Gtk.LinkButton.with_label (
                                                        link,
                                                        linkname
        );

        // _("Applications → Permissions")
        permissions_link.tooltip_text = link;
        permissions_link.halign = Gtk.Align.END;

        var permissions_label = new Gtk.Label (_("You can disable system notification sounds in the system settings")) {
            mnemonic_widget = permissions_link,
            halign = Gtk.Align.START,
            hexpand = true,
            valign = Gtk.Align.START,
            margin_top = 0
        };
        permissions_label.add_css_class ("advice");



        // Show link only in Pantheon because others do not have an autostart panel
        var desktop_environment = Environment.get_variable ("XDG_CURRENT_DESKTOP");
        permissions_link.visible = (desktop_environment == "Pantheon");

        permissions_box.append (permissions_label);
        permissions_box.append (permissions_link);



        var hidden_box = new Gtk.Box (VERTICAL, 24) {
            margin_top = 24
        };
        hidden_box.append (choicebox);
        hidden_box.append (permissions_box);

        var revealer = new Gtk.Revealer () {
            transition_type = Gtk.RevealerTransitionType.SLIDE_DOWN,
            child = hidden_box
        };

        append (quack_box);
        append (revealer);

        /* ---------------- BIND ---------------- */
        quack_button.clicked.connect (() => {
            var a = new Quack ();
        });

        quack_toggle.bind_property ("active",
                                    revealer, "reveal_child",
                                    GLib.BindingFlags.DEFAULT);

        ReminduckApp.settings.bind (
            "quack-sound",
            quack_toggle, "active",
            SettingsBindFlags.DEFAULT);

    }

}
