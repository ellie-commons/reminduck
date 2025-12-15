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
        EVERY_DAY,
        EVERY_WEEK,
        EVERY_MONTH,
        // EVERY_X_HOURS
        NONE;

        public string to_friendly_string (int? interval = null) {
            switch (this) {
                case NONE:
                    return _("Don't Repeat");

                case EVERY_X_MINUTES:
                    if (interval == null || interval == 0) {
                        return _("Every X minutes");
                    } else {
                        return GLib.ngettext ("Every minute", "Every %d minutes", interval).printf (interval);
                    }

                case EVERY_DAY:
                    return _("Every day");

                case EVERY_WEEK:
                    return _("Every week");

                case EVERY_MONTH:
                    return _("Every month");

                default:
                    assert_not_reached ();
            }
        }
    }
}
