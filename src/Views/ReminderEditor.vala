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

        Reminduck.Repeatbox repeatbox;

        Gtk.Button save_button;

        Reminder reminder;

        bool touched;

        construct {
            orientation = Gtk.Orientation.VERTICAL;
            valign = Gtk.Align.FILL;
            hexpand = vexpand = true;
            margin_start = 24;
            margin_end = 24;
            reminder = new Reminder ();

            title = new Gtk.Label (_("Create a new reminder")) {
                margin_top = 24,
                margin_bottom = 12
            };
            title.add_css_class (Granite.STYLE_CLASS_H2_LABEL);

            reminder_input = new Gtk.Entry () {
                placeholder_text = _("What do you want to be reminded of?"),
                show_emoji_icon = true
            };

            date_picker = new Granite.DatePicker.with_format (
                Granite.DateTime.get_default_date_format (false, true, true)
            );

            time_picker = new Granite.TimePicker.with_format (
                Granite.DateTime.get_default_time_format (true),
                Granite.DateTime.get_default_time_format (false)
            );

            var date_time_container = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
            date_time_container.append (this.date_picker);
            date_time_container.append (this.time_picker);

            var fields_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 12) {
                valign = Gtk.Align.CENTER,
                vexpand = true
            };
            fields_box.append (this.reminder_input);
            fields_box.append (date_time_container);

            var label = new Gtk.Label (_("Repeat")) {
                margin_top = 6,
                halign = Gtk.Align.START
            };
            label.add_css_class (Granite.STYLE_CLASS_H4_LABEL);

            fields_box.append (label);
            repeatbox = new Repeatbox ();

            fields_box.append (repeatbox);

            save_button = new Gtk.Button.with_label (_("Save reminder")) {
                halign = Gtk.Align.END,
                sensitive = false
            };
            save_button.add_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
            save_button.clicked.connect (on_save);

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
                date_picker.add_css_class (Granite.STYLE_CLASS_ERROR);
                time_picker.add_css_class (Granite.STYLE_CLASS_ERROR);

                save_button.sensitive = false;
                result = false;
            } else {
                date_picker.remove_css_class (Granite.STYLE_CLASS_ERROR);
                time_picker.remove_css_class (Granite.STYLE_CLASS_ERROR);
            }

            if (result) {
                save_button.sensitive = true;
            }

            return result;
        }

        public void edit_reminder (Reminder? existing_reminder) {
            if (existing_reminder != null) {

                reminder = existing_reminder;

                reminder_input.text = reminder.description;
                date_picker.date = reminder.time;
                time_picker.time = reminder.time;

                repeatbox.recurrency_type = reminder.recurrency_type;

                if (reminder.recurrency_type != RecurrencyType.NONE) {
                    repeatbox.interval = reminder.recurrency_interval;
                }

            } else {
                reminder = new Reminder ();
                reset_fields ();
            }
        }

        public void reset_fields () {
            reminder_input.text = "";
            date_picker.date = new GLib.DateTime.now_local ().add_minutes (15);
            time_picker.time = this.date_picker.date;
            repeatbox.reset ();
        }

        private void on_save () {
            if (validate ()) {
                reminder.description = reminder_input.text;
                reminder.time = mount_datetime (date_picker.date, time_picker.time);
                reminder.recurrency_type = repeatbox.recurrency_type;
                reminder.recurrency_interval = (int)repeatbox.interval;

                var result = ReminduckApp.database.upsert_reminder (reminder);

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
