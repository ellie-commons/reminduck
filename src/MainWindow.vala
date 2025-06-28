/*
* Copyright(c) 2011-2019 Matheus Fantinel
* Copyright (c) 2025 Stella, Charlie, (teamcons on GitHub) and the Ellie_Commons community
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or(at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Matheus Fantinel <matfantinel@gmail.com>
*/

namespace Reminduck {
    public class MainWindow : Gtk.ApplicationWindow {
        Gtk.Stack stack;
        Gtk.HeaderBar headerbar;
        Gtk.Button back_button;

        private GLib.Settings settings;
        public Gtk.Settings gtk_settings;
        public Granite.Settings granite_settings;

        Granite.Placeholder welcome_widget = null;
        int? view_reminders_action_reference = null;

        Widgets.Views.ReminderEditor reminder_editor;
        Widgets.Views.RemindersView reminders_view;

        public MainWindow () {
            settings = new GLib.Settings ("io.github.ellie_commons.reminduck.state");
            Intl.setlocale ();

            // Use reminduck styling
            var app_provider = new Gtk.CssProvider ();
            app_provider.load_from_resource ("/io/github/ellie_commons/reminduck/Application.css");

            Gtk.StyleContext.add_provider_for_display (
                Gdk.Display.get_default (),
                app_provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION + 1
            );

            stack = new Gtk.Stack () {
                transition_duration = 500,
                hexpand = vexpand = true,
                halign = Gtk.Align.FILL,
                valign = Gtk.Align.FILL,
            };


            title = "Reminduck";
            Gtk.Label title_widget = new Gtk.Label ("Reminduck");
            title_widget.add_css_class (Granite.STYLE_CLASS_TITLE_LABEL);

            this.headerbar = new Gtk.HeaderBar ();
            this.headerbar.title_widget = title_widget;
            this.headerbar.add_css_class ("default-decoration");

            set_titlebar (this.headerbar);

            granite_settings = Granite.Settings.get_default ();
                if (granite_settings.prefers_color_scheme == DARK) {
                    this.headerbar.add_css_class ("reminduck-headerbar-dark");
                } else {
                    this.headerbar.remove_css_class ("reminduck-headerbar-dark");
                }

            granite_settings.notify["prefers-color-scheme"].connect (() => {
                if (granite_settings.prefers_color_scheme == DARK) {
                    this.headerbar.add_css_class ("reminduck-headerbar-dark");
                } else {
                    this.headerbar.remove_css_class ("reminduck-headerbar-dark");
                }
            });

            this.back_button = new Gtk.Button.with_label (_("Back"));
            this.back_button.add_css_class ("back-button");
            this.back_button.valign = Gtk.Align.CENTER;
            this.headerbar.pack_start (this.back_button);

            this.back_button.clicked.connect (() => {
                this.show_welcome_view ();
            });


            this.welcome_widget = new Granite.Placeholder ( _("QUACK! I'm Reminduck")) {
                description = _("The duck that reminds you"),
                valign = Gtk.Align.FILL
            };

            var reminder_editor = this.welcome_widget.append_button (
                new ThemedIcon ("document-new"),
                _("New Reminder"),
                _("Create a new reminder for a set date and time")
            );
            reminder_editor.clicked.connect (() => {
                show_reminder_editor ();
            });


            if (ReminduckApp.reminders.size > 0) {

                var reminders_view = this.welcome_widget.append_button (
                        new ThemedIcon ("accessories-text-editor"),
                        _("View Reminders"),
                        _("See reminders you've created"
                ));


                reminders_view.clicked.connect (() => {
                        show_reminders_view (Gtk.StackTransitionType.SLIDE_LEFT);
                    });
            }

            var image = new Gtk.Image () {
                icon_name = "io.github.ellie_commons.reminduck",
                pixel_size = 96,
                valign = Gtk.Align.FILL
            };

            var fields_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 24) {
                margin_top = 24,
                margin_bottom = 24,
                margin_start = 24,
                margin_end = 24,
                valign = Gtk.Align.CENTER
            };

            fields_box.add_css_class ("reminduck-welcome-box");
            fields_box.append (image);
            fields_box.append (this.welcome_widget);

            stack.add_named (fields_box, "welcome");

            this.build_reminder_editor ();
            this.build_reminders_view ();

            stack.halign = stack.valign = Gtk.Align.FILL;
            stack.hexpand = stack.vexpand = true;

            var handle = new Gtk.WindowHandle () {
                child = stack
            };

            child = handle;

            this.show_welcome_view (Gtk.StackTransitionType.NONE);

            this.close_request.connect (e => {
                return before_destroy ();
            });
        }

        private void update_view_reminders_welcome_action () {
            if (ReminduckApp.reminders.size > 0) {
                if (this.view_reminders_action_reference == null) {
 

                    this.welcome_widget.show ();
                }
            } else {
                //if (this.view_reminders_action_reference != null) {
                //    this.welcome_widget.remove_item (this.view_reminders_action_reference);
                //}
                this.view_reminders_action_reference = null;
            }
        }

        private void build_reminder_editor () {
            this.reminder_editor = new Widgets.Views.ReminderEditor ();

            this.reminder_editor.reminder_created.connect ((new_reminder) => {
                ReminduckApp.reload_reminders ();                
                show_reminders_view ();
            });

            this.reminder_editor.reminder_edited.connect ((edited_file) => {
                ReminduckApp.reload_reminders ();
                show_reminders_view ();
            });

            stack.add_named (this.reminder_editor, "reminder_editor");
        }

        private void build_reminders_view () {
            this.reminders_view = new Widgets.Views.RemindersView ();

            this.reminders_view.add_request.connect (() => {
                show_reminder_editor ();
            });

            this.reminders_view.edit_request.connect ((reminder) => {
                show_reminder_editor (reminder);
            });

            this.reminders_view.reminder_deleted.connect (() => {
                ReminduckApp.reload_reminders ();
                if (ReminduckApp.reminders.size == 0) {
                    show_welcome_view ();
                } else {
                    this.reminders_view.build_reminders_list ();
                }
            });

            stack.add_named (this.reminders_view, "reminders_view");
        }

        private void show_reminder_editor (Reminder? reminder = null) {
            stack.set_transition_type (Gtk.StackTransitionType.SLIDE_LEFT);
            stack.set_visible_child_name ("reminder_editor");
            this.back_button.show ();
            this.reminder_editor.edit_reminder (reminder);
        }

        private void show_reminders_view (Gtk.StackTransitionType slide = Gtk.StackTransitionType.SLIDE_RIGHT) {
            stack.set_transition_type (slide);
            stack.set_visible_child_name ("reminders_view");
            this.reminders_view.build_reminders_list ();
            this.back_button.show ();
            this.reminder_editor.reset_fields ();
        }

        public void show_welcome_view (Gtk.StackTransitionType slide = Gtk.StackTransitionType.SLIDE_RIGHT) {
            this.update_view_reminders_welcome_action ();
            stack.set_transition_type (slide);
            stack.set_visible_child_name ("welcome");
            this.back_button.hide ();
            this.reminder_editor.reset_fields ();
        }

        private bool before_destroy () {
            int width, height;

            get_default_size (out width, out height);

            this.settings.set_int ("window-width", width);
            this.settings.set_int ("window-height", height);

            hide ();
            return true;
        }
    }
}
