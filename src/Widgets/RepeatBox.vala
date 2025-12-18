/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2011-2019 Matheus Fantinel
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */


public class Reminduck.Repeatbox : Gtk.Box {

    public signal void changed ();

    public RecurrencyType recurrency_type {
        get {
            if (!recurrency_switch.active) {
                return RecurrencyType.NONE;
            }
            return this.dropdown.selected;
        }

        set {
            if (value == RecurrencyType.NONE) {
                recurrency_switch.active = false;
                return;
            }
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

    Gtk.Revealer interval_revealer;
    Gtk.SpinButton interval_spin;

    construct {
        orientation = Gtk.Orientation.HORIZONTAL;
        spacing = 5;

        recurrency_switch = new Gtk.Switch () {
            margin_end = 10,
            active = false
        };

        dropdown = new Gtk.DropDown.from_strings (RecurrencyType.choices ());
        dropdown.set_selected (RecurrencyType.EVERY_DAY); // Enums are fucking magic

        // 60 minutes * 24  hrs = Maximum 1440 minutes. Next up may as well use days
        interval_spin = new Gtk.SpinButton.with_range (1, 1440, 1) {
            value = 30
        };

        interval_revealer = new Gtk.Revealer () {
            child = interval_spin,
            transition_type = Gtk.RevealerTransitionType.SLIDE_RIGHT
        };

        var recurrency_hidden_box = new Gtk.Box (HORIZONTAL, 0);
        recurrency_hidden_box.append (dropdown);
        recurrency_hidden_box.append (interval_revealer);

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

        recurrency_switch.activate.connect (() => {changed ();});

        dropdown.notify["selected"].connect (() => {
            print (dropdown.selected.to_string ());
            var selected_option = dropdown.selected;
            var if_every_x_selected = selected_option == RecurrencyType.EVERY_X_MINUTES;
            interval_revealer.reveal_child = if_every_x_selected;
            changed ();
        });
    }

    public void reset () {
        recurrency_switch.active = false;
        dropdown.set_selected (0);
        interval_spin.value = 30;
    }
}
