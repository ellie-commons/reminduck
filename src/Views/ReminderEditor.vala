/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2011-2019 Matheus Fantinel
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */


namespace Reminduck.Views {
    public class ReminderEditor : Gtk.Box {
        public signal void reminder_created ();
        public signal void reminder_edited ();

        Gtk.Label title;
        Gtk.Entry reminder_input;
        Granite.DatePicker date_picker;
        Granite.TimePicker time_picker;

        Gtk.Box recurrency_switch_container;
        Gtk.Switch recurrency_switch;
        Gtk.ComboBox recurrency_combobox;
        Gtk.Revealer recurrency_revealer;
        Gtk.SpinButton recurrency_interval;
        Gtk.Button save_button;

        Reminder reminder;

        bool touched;

        construct {
            orientation = Gtk.Orientation.VERTICAL;
            valign = Gtk.Align.FILL;
            hexpand = vexpand = true;
            margin_start = 24;
            margin_end = 24;
            this.reminder = new Reminder ();
        }

        public ReminderEditor () {
            this.build_ui ();
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

        public bool validate () {
            var result = true;

            if (this.reminder_input.get_text () == null || this.reminder_input.get_text ().length <= 0) {
                if (this.touched) {
                    this.reminder_input.add_css_class (Granite.STYLE_CLASS_ERROR);
                }

                this.save_button.set_sensitive (false);
                result = false;
            } else {
                this.reminder_input.remove_css_class (Granite.STYLE_CLASS_ERROR);
            }

            var datetime = this.mount_datetime (this.date_picker.date, this.time_picker.time);

            if (datetime.compare (new GLib.DateTime.now_local ()) <= 0) {
                this.date_picker.add_css_class (Granite.STYLE_CLASS_ERROR);
                this.time_picker.add_css_class (Granite.STYLE_CLASS_ERROR);

                this.save_button.set_sensitive (false);
                result = false;
            } else {
                this.date_picker.remove_css_class (Granite.STYLE_CLASS_ERROR);
                this.time_picker.remove_css_class (Granite.STYLE_CLASS_ERROR);
            }

            if (result) {
                this.save_button.set_sensitive (true);
            }

            return result;
        }

        public void edit_reminder (Reminder ? existing_reminder) {
            if (existing_reminder != null) {
                this.reminder = existing_reminder;

                this.reminder_input.text = this.reminder.description;
                this.date_picker.date = this.reminder.time;
                this.time_picker.time = this.reminder.time;

                if (this.reminder.recurrency_type == RecurrencyType.NONE) {
                    this.recurrency_switch.set_active (false);
                } else {
                    this.recurrency_switch.set_active (true);
                    this.recurrency_combobox.set_active ((int)this.reminder.recurrency_type);

                    if (this.reminder.recurrency_type == RecurrencyType.EVERY_X_MINUTES) {
                        this.recurrency_interval.value = (double)this.reminder.recurrency_interval;
                        this.recurrency_interval.show ();
                    }
                }
            } else {
                this.reminder = new Reminder ();
                this.reset_fields ();
            }
        }

        public void reset_fields () {
            this.reminder_input.text = "";
            this.date_picker.date = new GLib.DateTime.now_local ().add_minutes (15);
            this.time_picker.time = this.date_picker.date;
            this.recurrency_switch.set_active (false);
            this.recurrency_combobox.set_active ((int)RecurrencyType.EVERY_X_MINUTES);
        }

        private void on_save () {
            if (this.validate ()) {
                this.reminder.description = this.reminder_input.get_text ();
                this.reminder.time = this.mount_datetime (this.date_picker.date, this.time_picker.time);
                if (this.recurrency_switch.get_active ()) {
                    this.reminder.recurrency_type = (RecurrencyType)(this.recurrency_combobox.get_active ());

                    if (this.reminder.recurrency_type == RecurrencyType.EVERY_X_MINUTES) {
                        this.reminder.recurrency_interval = (int)this.recurrency_interval.value;
                    } else {
                        this.reminder.recurrency_interval = 0;
                    }
                } else {
                    this.reminder.recurrency_type = RecurrencyType.NONE;
                    this.reminder.recurrency_interval = 0;
                }

                var result = ReminduckApp.database.upsert_reminder (this.reminder);

                if (result) {
                    reminder_created ();
                } else {
                    reminder_edited ();
                }
            }
        }

        private DateTime mount_datetime (DateTime date, DateTime time) {
            return new GLib.DateTime.local (
                date.get_year (),
                date.get_month (),
                date.get_day_of_month (),
                time.get_hour (),
                time.get_minute (),
                0
            );
        }
    }
}
