let () =
  let win = Curses.initscr () in
  Curses.raw ();
  Curses.noecho ();
  Curses.keypad win true;

  let _ = Curses.mvaddstr 5 10 "SECSET" in
  let _ = Curses.refresh () in

  ignore (Curses.getch ());

  Curses.endwin ()
