/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2011-2019 Matheus Fantinel
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

namespace Reminduck {
    public class Reminder : GLib.Object {
        public string rowid { get; set; }
        public string description { get; set; }
        public GLib.DateTime time { get; set; }
        public RecurrencyType recurrency_type { get; set; default = RecurrencyType.NONE; }
        public int recurrency_interval { get; set; }
    }

    public enum RecurrencyType {
        EVERY_X_MINUTES,
        EVERY_X_HOURS,
        EVERY_DAY,
        EVERY_WEEK,
        EVERY_MONTH,
        NONE;

        public string to_friendly_string (int? interval = 0) {
            switch (this) {
                case NONE: return _("Don't Repeat");
                case EVERY_X_MINUTES: return GLib.ngettext ("Minute", "Minutes", interval);
                case EVERY_X_HOURS: return GLib.ngettext ("Hour", "Hours", interval);
                case EVERY_DAY: return GLib.ngettext ("Day", "Days", interval);
                case EVERY_WEEK: return GLib.ngettext ("Week", "Weeks", interval);
                case EVERY_MONTH: return GLib.ngettext ("Month", "Months", interval);
                default: assert_not_reached ();
            }
        }

        public static string[] choices (int? interval = 0) {
            return {
                RecurrencyType.EVERY_X_MINUTES.to_friendly_string (interval),
                RecurrencyType.EVERY_X_HOURS.to_friendly_string (interval),
                RecurrencyType.EVERY_DAY.to_friendly_string (interval),
                RecurrencyType.EVERY_WEEK.to_friendly_string (interval),
                RecurrencyType.EVERY_MONTH.to_friendly_string (interval)
            };
        }
    }
}
