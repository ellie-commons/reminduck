/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2011-2019 Matheus Fantinel
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */


public class Reminduck.Repeatbox : Gtk.Box {

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

        dropdown = new Gtk.DropDown.from_strings (RecurrencyType.choices ());
        dropdown.set_selected (RecurrencyType.EVERY_DAY); // Enums are fucking magic

        // 60 minutes * 24  hrs = Maximum 1440 minutes. Next up may as well use days
        interval_spin = new Gtk.SpinButton.with_range (1, 30, 1) {
            value = 1
        };

        var recurrency_hidden_box = new Gtk.Box (HORIZONTAL, 0);
        recurrency_hidden_box.append (every_label);
        recurrency_hidden_box.append (interval_spin);
        recurrency_hidden_box.append (dropdown);

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
        interval_spin.value_changed.connect (on_minutes_at_one);
    }

    private void on_selected_change () {
        debug (dropdown.selected.to_string ());
        var selected_option = dropdown.selected;

        switch (selected_option) {
            case RecurrencyType.EVERY_X_MINUTES:
                interval_spin.adjustment.step_increment = 30;
                interval_spin.adjustment.upper = 1440;
                return;

            case RecurrencyType.EVERY_DAY:
                interval_spin.adjustment.step_increment = 1;
                interval_spin.adjustment.upper = 30;
                return;

            case RecurrencyType.EVERY_WEEK:
                interval_spin.adjustment.step_increment = 1;
                interval_spin.adjustment.upper = 4;
                return;

            case RecurrencyType.EVERY_MONTH:
                interval_spin.adjustment.step_increment = 1;
                interval_spin.adjustment.upper = 12;
                return;
        }
    }

    private void on_minutes_at_one () {
        debug ("On minutes at one");
        if (interval_spin.value != 1) {return;}

        var selected_option = dropdown.selected;
        var if_every_x_selected = selected_option == RecurrencyType.EVERY_X_MINUTES;

        if (if_every_x_selected) {
            interval_spin.value_changed.connect (adjust_minutes);
        }
    }

    private void adjust_minutes () {
        debug (dropdown.selected.to_string ());
        var selected_option = dropdown.selected;
        var if_every_x_selected = selected_option == RecurrencyType.EVERY_X_MINUTES;

        if (if_every_x_selected && interval_spin.value == 31) {
            interval_spin.value = 30;
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
