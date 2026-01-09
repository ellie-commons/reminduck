/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2011-2019 Matheus Fantinel
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/elly-codes/)
 */

/**
 * A specialized horizontal box used by the ReminderEditor to set repeating reminders
 * Use recurrency_type and interval to retrieve values
 * 
 * There are two dropdowns, one with a singular version one with a plural version, they switch up place depending what to use
 */
public class Reminduck.RepeatBox : Gtk.Box {

    public RecurrencyType recurrency_type {
        get {
            if (!recurrency_switch.active) {
                return RecurrencyType.NONE;
            }
            return dropdown.selected;
        }

        set {
            if (value == RecurrencyType.NONE) {
                recurrency_switch.active = false;
                return;
            }
            recurrency_switch.active = true;
            dropdown.set_selected (value);
        }
    }

    public uint interval {
        get {return (uint)interval_spin.value;}
        set {interval_spin.value = (float)value;}
    }

    Gtk.Switch recurrency_switch;
    Gtk.Revealer recurrency_revealer;
    Gtk.DropDown dropdown;
    Gtk.SpinButton interval_spin;

    construct {
        orientation = Gtk.Orientation.HORIZONTAL;
        spacing = 5;

        recurrency_switch = new Gtk.Switch () {
            margin_end = 10,
            active = false
        };

        ///TRANSLATORS: If your language doesnt match "Every XX Minutes/Month/etc" pattern please tell me!!!!!! So i can adapt it for your lang
        var every_label = new Gtk.Label (_("Every")) {
            margin_end = 10,
        };
        every_label.add_css_class (Granite.STYLE_CLASS_H4_LABEL);

        dropdown = new Gtk.DropDown.from_strings (RecurrencyType.choices (1)) {
            selected = RecurrencyType.EVERY_DAY, // Enums are fucking magic
            width_request = 96
        };
        var dropdown_plural = new Gtk.DropDown.from_strings (RecurrencyType.choices (2)) {
            width_request = 96
        };

        // 60 minutes * 24  hrs = Maximum 1440 minutes. Next up may as well use days
        interval_spin = new Gtk.SpinButton.with_range (1, 30, 1) {
            value = 1
        };

        var recurrency_hidden_box = new Gtk.Box (HORIZONTAL, 0);
        recurrency_hidden_box.append (every_label);
        recurrency_hidden_box.append (interval_spin);
        recurrency_hidden_box.append (dropdown);
        recurrency_hidden_box.append (dropdown_plural);

        recurrency_revealer = new Gtk.Revealer () {
            child = recurrency_hidden_box,
            transition_type = Gtk.RevealerTransitionType.SLIDE_RIGHT
        };

        append (recurrency_switch);
        append (recurrency_revealer);



        /* ---------------- CONNECTS AND BINDS ---------------- */
        recurrency_switch.bind_property (
            "active",
            recurrency_revealer, "reveal_child",
            GLib.BindingFlags.DEFAULT
        );

        on_selected_change ();
        dropdown.notify["selected"].connect (on_selected_change);
        interval_spin.changed.connect (on_spin_changed);

        /* Two dropdowns, both brothers, yet both opposites, doomed to never meet, in an eternal cycle */
        dropdown.bind_property ("visible",
                            dropdown_plural, "visible",
                            GLib.BindingFlags.INVERT_BOOLEAN | GLib.BindingFlags.SYNC_CREATE | GLib.BindingFlags.BIDIRECTIONAL);

        dropdown.bind_property ("selected",
                            dropdown_plural, "selected",
                            GLib.BindingFlags.SYNC_CREATE | GLib.BindingFlags.BIDIRECTIONAL);
    }

    private void on_spin_changed () {
        debug ("Spin changed!");
        dropdown.visible = (interval_spin.value == 1);
    }

    private void on_selected_change () {
        debug (dropdown.selected.to_string ());
        var selected_option = dropdown.selected;

        switch (selected_option) {
            case RecurrencyType.EVERY_X_MINUTES:
                interval_spin.adjustment.step_increment = 5;
                interval_spin.adjustment.upper = 1440;                      // One day
                interval_spin.value_changed.connect (set_minutes_watch);
                set_minutes_watch ();
                return;

            case RecurrencyType.EVERY_X_HOURS:
                interval_spin.adjustment.step_increment = 1;
                interval_spin.adjustment.upper = 72;                        // Three days
                interval_spin.value_changed.disconnect (set_minutes_watch);
                return;

            case RecurrencyType.EVERY_DAY:
                interval_spin.adjustment.step_increment = 1;
                interval_spin.adjustment.upper = 90;                        // Three months
                interval_spin.value_changed.disconnect (set_minutes_watch);
                return;

            case RecurrencyType.EVERY_WEEK:
                interval_spin.adjustment.step_increment = 1;
                interval_spin.adjustment.upper = 48;                            // One year
                interval_spin.value_changed.disconnect (set_minutes_watch);
                return;

            case RecurrencyType.EVERY_MONTH:
                interval_spin.adjustment.step_increment = 1;
                interval_spin.adjustment.upper = 12;                            // One year
                interval_spin.value_changed.disconnect (set_minutes_watch);
                return;
        }
    }

    // User may be at 1 minutes, then click "+" and jump to 6, 11... Thats no good
    private void set_minutes_watch () {
        debug ("On minutes at one");
        if (interval_spin.value != 1) {return;}

        // value is at one. Keep an eye out to adjust 6
        interval_spin.value_changed.connect (adjust_minutes);
    }

    private void adjust_minutes () {
        debug (dropdown.selected.to_string ());

        if (interval_spin.value == 6) {
            interval_spin.value = 5;
        }
        // Crisis averted, stop keeping watch
        interval_spin.value_changed.disconnect (adjust_minutes);
    }

    public void reset () {
        recurrency_switch.active = false;
        dropdown.set_selected (RecurrencyType.EVERY_DAY);
        interval_spin.value = 1;
    }
}
