/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2011-2019 Matheus Fantinel
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */


public class Reminduck.Views.SettingsView : Gtk.Box {

    Granite.Toast toast;

    public SettingsView () {
        Object (
            orientation: Gtk.Orientation.VERTICAL,
            valign: Gtk.Align.FILL,
            hexpand: true,
            vexpand: true
        );
    }

    construct {
        var centerbox = new Gtk.Box (Gtk.Orientation.VERTICAL, 24) {
            hexpand = vexpand = true,
            halign = Gtk.Align.FILL,
            valign = Gtk.Align.START,
            margin_start = 24,
            margin_end = 24,
            margin_top = 12
        };

        var overlay = new Gtk.Overlay ();
        append (overlay);

        toast = new Granite.Toast (_("Request to system sent"));
        overlay.add_overlay (toast);


        var title = new Granite.HeaderLabel (_("Settings")) {
                margin_top = 24,
                margin_bottom = 12,
                size = Granite.HeaderLabel.Size.H2
        };

        append (title);


        /* ---------------- QUACK TOGGLE ---------------- */
        var quack_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12) {
            halign = Gtk.Align.FILL,
            hexpand = true
        };

        var quack_button = new Gtk.Button.from_icon_name ("media-playback-start") {
            tooltip_text = _("Click to preview reminder sound")
        };

        quack_button.clicked.connect (() => {new Quack ();});

        var quack_toggle = new Gtk.Switch () {
            valign = Gtk.Align.CENTER
        };
        var minibox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12) {
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

        centerbox.append (quack_box);

        /* ---------------- PERMISSION BOX ---------------- */
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

        var permissions_label = new Granite.HeaderLabel (_("You can disable the 'DING' sound in the system settings")) {
            mnemonic_widget = permissions_link,
            halign = Gtk.Align.START,
            hexpand = true,
            valign = Gtk.Align.START,
            margin_top = 0
        };
        //permissions_label.add_css_class ("advice");

        permissions_label.set_hexpand (true);
        permissions_box.append (permissions_label);
        permissions_box.append (permissions_link);
        centerbox.append (permissions_box);

        // Show link only in Pantheon because others do not have an autostart panel
        var desktop_environment = Environment.get_variable ("XDG_CURRENT_DESKTOP");
        permissions_link.visible = (desktop_environment == "Pantheon");


        /* ---------------- PERSISTENT TOGGLE ---------------- */
        var persist_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12) {
            halign = Gtk.Align.FILL,
            hexpand = true
        };

        var persist_toggle = new Gtk.Switch () {
                halign = Gtk.Align.END,
                hexpand = true,
                valign = Gtk.Align.CENTER
        };

        var persist_label = new Granite.HeaderLabel (_("Persistent notifications")) {
            mnemonic_widget = quack_toggle,
            secondary_text = _("If enabled, the duck will stay until (gently) dismissed"),
            halign = Gtk.Align.START
        };

        persist_box.append (persist_label);
        persist_box.append (persist_toggle);

        centerbox.append (persist_box);

        /* AUTOSTART */
        var both_buttons = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6) {
            halign = Gtk.Align.FILL
        };

        ///TRANSLATORS: Button to autostart the application
        var button_set_autostart = new Gtk.Button () {
            label = _("Enable"),
            valign = Gtk.Align.CENTER
        };

        button_set_autostart.clicked.connect (set_autostart);

        ///TRANSLATORS: Button to remove the autostart for the application
        var button_remove_autostart = new Gtk.Button () {
            label = _("Disable"),
            valign = Gtk.Align.CENTER
        };
        //remove_autostart.add_css_class (Granite.STYLE_CLASS_DESTRUCTIVE_ACTION);

        button_remove_autostart.clicked.connect (remove_autostart);

        both_buttons.append (button_set_autostart);
        both_buttons.append (button_remove_autostart);

        var autostart_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);

        var autostart_label = new Granite.HeaderLabel (_("Autostart in the background")) {
            mnemonic_widget = both_buttons,
            secondary_text = _("Request the system to start the application in the background when you log in"),
            hexpand = true
        };

        autostart_box.append (autostart_label);
        autostart_box.append (both_buttons);
        centerbox.append (autostart_box);

        append (centerbox);


        /* ---------------- BOTTOM BAR ---------------- */
        var boxbottom = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12) {
            hexpand = true,
            vexpand = false,
            halign = Gtk.Align.FILL,
            margin_bottom = 12,
            margin_start = margin_end = 24
        };

            // Monies?
        var support_button = new Gtk.LinkButton.with_label (
            DONATE_LINK,
            _("Support us!")
        );
        support_button.halign = Gtk.Align.START;
        boxbottom.append (support_button);

        var reset_button = new Gtk.Button () {
            halign = Gtk.Align.END,
            hexpand = true,
            label = _("Reset to Default"),
            tooltip_text = _("Reset all settings to defaults")
        };
        boxbottom.append (reset_button);

        append (boxbottom);


        /* ---------------- CONNECTS AND BINDS ---------------- */
        ReminduckApp.settings.bind (
            KEY_QUACK_SOUND,
            quack_toggle, "active",
            SettingsBindFlags.DEFAULT);

        ReminduckApp.settings.bind (
            KEY_PERSISTENT_NOTIFICATION,
            persist_toggle, "active",
            SettingsBindFlags.DEFAULT);

        reset_button.clicked.connect (on_reset);
    }

    private void on_reset () {
        debug ("Resetting settings…");

        string[] keys = {KEY_QUACK_SOUND, KEY_PERSISTENT_NOTIFICATION};
        foreach (var key in keys) {
                ReminduckApp.settings.reset (key);
        }
    }

    private void set_autostart () {
        debug ("Setting autostart");
        Reminduck.Utils.request_autostart ();
        toast.send_notification ();
    }

    private void remove_autostart () {
        debug ("Removing autostart");
        Reminduck.Utils.remove_autostart ();
        toast.send_notification ();
    }
}

