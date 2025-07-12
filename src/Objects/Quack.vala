/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2011-2019 Matheus Fantinel
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

public class Reminduck.Quack : Object {
    public Quack () {
        var m = Gtk.MediaFile.for_resource ("/io/github/ellie_commons/reminduck/quack.ogg");

        m.notify["ended"].connect (() => {
            print ("stream ended %s\n", m.ended.to_string ());
        });

        m.notify["prepared"].connect (() => {
            var t = m.duration;
            var s = t / 1000000;
            var ms = t % 1000000;
            print ("Play for %jd.%06jd\n", s, ms);
        });

        m.play ();

    }
}
