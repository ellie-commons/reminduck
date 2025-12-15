*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2011-2019 Matheus Fantinel
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */


public class Reminduck.Repeatbox : Gtk.Box {

    Gtk.Box recurrency_switch_container;
    Gtk.Switch recurrency_switch;
    Gtk.ComboBox recurrency_combobox;
    Gtk.Revealer recurrency_revealer;
    Gtk.SpinButton recurrency_interval;
    Gtk.Button save_button;

    construct {
        orientation = Gtk.Orientation.HORIZONTAL;
        spacing = 0;
    }

    private void build_ui () {

        this.title = new Gtk.Label (_("Create a new reminder")) {
            margin_top = 24,
            margin_bottom = 12
        };
        this.title.add_css_class (Granite.STYLE_CLASS_H2_LABEL);

        this.reminder_input = new Gtk.Entry () {
            placeholder_text = _("What do you want to be reminded of?"),
            show_emoji_icon = true
        };

        this.date_picker = new Granite.DatePicker.with_format (
            Granite.DateTime.get_default_date_format (false, true, true)
        );

        this.time_picker = new Granite.TimePicker.with_format (
            Granite.DateTime.get_default_time_format (true),
            Granite.DateTime.get_default_time_format (false)
        );

        this.build_recurrency_ui ();

        this.reset_fields ();

        var date_time_container = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
        date_time_container.append (this.date_picker);
        date_time_container.append (this.time_picker);

        var fields_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 12) {
            valign = Gtk.Align.CENTER,
            vexpand = true
        };
        fields_box.append (this.reminder_input);
        fields_box.append (date_time_container);

        var repeat_label_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        repeat_label_box.margin_top = 6;
        repeat_label_box.append (new Gtk.Label (_("Repeat")));

        fields_box.append (repeat_label_box);
        fields_box.append (this.recurrency_switch_container);

        this.save_button = new Gtk.Button.with_label (_("Save reminder"));
        this.save_button.halign = Gtk.Align.END;
        this.save_button.add_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
        this.save_button.activate.connect (on_save);
        this.save_button.clicked.connect (on_save);
        this.save_button.set_sensitive (false);
        fields_box.append (this.save_button);

        append (title);
        append (fields_box);

        this.reminder_input.changed.connect (() => {
            this.touched = true;
            this.validate ();
        });

        this.reminder_input.activate.connect (() => {
            this.save_button.clicked ();
        });

        this.date_picker.changed.connect (() => {
            this.validate ();
        });

        this.time_picker.changed.connect (() => {
            this.validate ();
        });

        this.recurrency_switch.notify["active"].connect (() => {
            if (this.recurrency_switch.active) {
                this.recurrency_combobox.changed ();
            }
        });

        this.recurrency_switch.bind_property (
            "active",
            recurrency_revealer, "reveal_child",
            GLib.BindingFlags.SYNC_CREATE
        );

        this.recurrency_combobox.changed.connect (() => {
            var selected_option = this.recurrency_combobox.get_active ();

            if ((RecurrencyType)selected_option == RecurrencyType.EVERY_X_MINUTES) {
                this.recurrency_interval.show ();
            } else {
                this.recurrency_interval.hide ();
            }
        });

        this.recurrency_interval.value_changed.connect (() => {
            if (this.recurrency_interval.value == 0) {
                this.recurrency_interval.value = 1;
            }
        });
    }

    private void build_recurrency_ui () {
        this.recurrency_switch = new Gtk.Switch ();
        this.recurrency_switch.margin_end = 10;

        this.recurrency_switch_container = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5);

        this.recurrency_switch_container.append (this.recurrency_switch);

        string[] recurrency_options = {
            RecurrencyType.EVERY_X_MINUTES.to_friendly_string (),
            RecurrencyType.EVERY_DAY.to_friendly_string (),
            RecurrencyType.EVERY_WEEK.to_friendly_string (),
            RecurrencyType.EVERY_MONTH.to_friendly_string ()
        };
        Gtk.ListStore list_store = new Gtk.ListStore (1, typeof (string));

        for (int i = 0; i < recurrency_options.length; i++) {
            Gtk.TreeIter iter;
            list_store.append (out iter);
            list_store.set (iter, 0, recurrency_options[i]);
        }

        recurrency_combobox = new Gtk.ComboBox.with_model (list_store);

        Gtk.CellRendererText cell = new Gtk.CellRendererText ();
        recurrency_combobox.pack_start (cell, false);

        recurrency_combobox.set_attributes (cell, "text", 0);


        recurrency_interval = new Gtk.SpinButton.with_range (0, 1000, 1) {
            value = 30
        };

        var recurrency_hidden_box = new Gtk.Box (HORIZONTAL, 0);
        recurrency_hidden_box.append (recurrency_combobox);
        recurrency_hidden_box.append (recurrency_interval);

        recurrency_revealer = new Gtk.Revealer () {
            child = recurrency_hidden_box,
            transition_type = Gtk.RevealerTransitionType.SLIDE_RIGHT
        };

        this.recurrency_switch_container.append (recurrency_revealer);
    }
}
